-- fish_auto.lua
-- auto-fishing for the rod system in this place.
-- drives the live RodClientModule + FishingUIController closures instead of raw remotes,
-- so the server-side ready token path stays intact.
--
-- F8 = start / stop
--
-- notes:
--   * character must stay still and the rod equipped
--   * real cast goes through the rod InputBegan/InputEnded closures (token-safe)
--   * PreFishing drag is skipped by calling the live u21 transition closure
--   * bar minigame is played by clicking only during the green phase
--   * logs to fish_auto_log.txt

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local LP = Players.LocalPlayer
local LOG_FILE = "fish_auto_log.txt"

local S = getgenv()._fishAuto
if type(S) ~= "table" then
    S = {}
    getgenv()._fishAuto = S
end

S.generation = (S.generation or 0) + 1
local GEN = S.generation
S.running = false
S.loopRunning = false
S.listeners = S.listeners or false
S.listenerTool = S.listenerTool
S.cancelCount = S.cancelCount or 0
S.baitLanded = S.baitLanded or 0
S.startCount = S.startCount or 0
S.lastCancel = S.lastCancel
S.lastFish = S.lastFish
S.lastReady = S.lastReady
S.startTime = S.startTime or 0
S.rodTool = nil
S.f694 = nil
S.f730 = nil

local function log(...)
    local parts = {}
    for i = 1, select("#", ...) do
        parts[#parts + 1] = tostring(select(i, ...))
    end
    local line = string.format("[%s] %s", os.date("%H:%M:%S"), table.concat(parts, " "))
    local old = ""
    local ok, content = pcall(readfile, LOG_FILE)
    if ok and type(content) == "string" then
        old = content
    end
    if #old > 60000 then
        old = old:sub(-20000)
    end
    writefile(LOG_FILE, old .. line .. "\n")
end

local function readXP()
    local levelUI = LP.PlayerGui:FindFirstChild("LevelUI")
    if not levelUI then
        return 0
    end
    local label = levelUI:FindFirstChild("XPLabel", true)
    if not label or not label:IsA("TextLabel") then
        return 0
    end
    local clean = label.Text
    clean = clean:gsub(",", "")
    clean = clean:gsub("%s", "")
    local current = clean:match("^(%d+)/")
    return tonumber(current) or 0
end

local function findRod()
    local char = LP.Character
    if not char then
        return nil
    end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Tool") and child:GetAttribute("IsRod") == true then
            return child
        end
    end
    return nil
end

local function equipRod()
    local char = LP.Character
    if not char then
        return nil
    end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then
        return nil
    end
    local rod = findRod()
    if rod then
        return rod
    end
    local backpack = LP:FindFirstChildOfClass("Backpack")
    if backpack then
        for _, child in ipairs(backpack:GetChildren()) do
            if child:IsA("Tool") and child:GetAttribute("IsRod") == true then
                hum:EquipTool(child)
                task.wait(1.5)
                return findRod()
            end
        end
    end
    return nil
end

local function attachListeners()
    if S.listeners and S.listenerTool == findRod() then
        return
    end
    local rod = findRod()
    if not rod then
        return
    end
    S.listeners = true
    S.listenerTool = rod
    for _, remote in ipairs(rod:GetChildren()) do
        if remote:IsA("RemoteEvent") then
            remote.OnClientEvent:Connect(function(...)
                if remote.Name == "BaitLanded" then
                    S.baitLanded = S.baitLanded + 1
                elseif remote.Name == "FishingCanceled" then
                    S.cancelCount = S.cancelCount + 1
                    S.lastCancel = tostring((...))
                    log("event", "FishingCanceled", S.lastCancel)
                elseif remote.Name == "StartMinigame" then
                    S.startCount = S.startCount + 1
                    S.startTime = os.clock()
                    local fish = select(2, ...)
                    if type(fish) == "table" then
                        S.lastFish = fish
                        log("event", "StartMinigame", tostring(fish.FishName), tostring(fish.Rarity), tostring(fish.Weight) .. "kg", tostring(fish.Price))
                    end
                elseif remote.Name == "ToolReady" then
                    S.lastReady = select(1, ...)
                    log("event", "ToolReady", tostring(S.lastReady))
                elseif remote.Name == "GiveFishReward" then
                    log("event", "GiveFishReward")
                end
            end)
        end
    end
end

local function scanFunctions(sourceNeedle)
    local out = {}
    local i = 0
    for _, obj in pairs(getgc(true)) do
        i = i + 1
        if type(obj) == "function" then
            local ok, src = pcall(debug.info, obj, "s")
            if ok and type(src) == "string" and src:find(sourceNeedle, 1, true) then
                local okLine, line = pcall(debug.info, obj, "l")
                if okLine then
                    out[#out + 1] = { fn = obj, line = line }
                end
            end
        end
        if i % 4000 == 0 then
            task.wait()
        end
    end
    return out
end

local function findRodFns(force)
    local rod = findRod()
    if not rod then
        return nil, nil
    end
    if not force and S.rodTool == rod and S.f694 and S.f730 then
        return S.f694, S.f730
    end
    local list = scanFunctions("RodClientModule")
    local f694 = nil
    local f730 = nil
    for _, entry in ipairs(list) do
        if entry.line == 694 then
            f694 = entry.fn
        elseif entry.line == 730 then
            f730 = entry.fn
        end
    end
    if not f730 then
        local castRemote = rod:FindFirstChild("Cast")
        for _, entry in ipairs(list) do
            local ok, uvs = pcall(debug.getupvalues, entry.fn)
            if ok then
                for _, value in ipairs(uvs) do
                    if value == castRemote then
                        f730 = entry.fn
                        break
                    end
                end
            end
            if f730 then
                break
            end
        end
    end
    S.rodTool = rod
    S.f694 = f694
    S.f730 = f730
    return f694, f730
end

local function makeFakeInput(state)
    return {
        UserInputType = Enum.UserInputType.MouseButton1,
        KeyCode = Enum.KeyCode.Unknown,
        UserInputState = state or Enum.UserInputState.Begin,
        Position = Vector3.new(960, 540, 0),
        Delta = Vector3.new(0, 0, 0)
    }
end

local function doCast(f694, f730)
    local input = makeFakeInput(Enum.UserInputState.Begin)
    if f694 then
        pcall(f694, input, false)
    else
        pcall(debug.setupvalue, f730, 1, true)
        pcall(debug.setupvalue, f730, 5, tick() - 0.35)
    end
    task.wait(0.42)
    input.UserInputState = Enum.UserInputState.End
    local ok, err = pcall(f730, input, false)
    return ok, err
end

local function isLiveIn(ui, value)
    if typeof(value) ~= "Instance" then
        return false
    end
    local ok, result = pcall(function()
        return value:IsDescendantOf(ui)
    end)
    return ok and result
end

local function findUiFns(ui)
    local list = scanFunctions("FishingUIController")
    local f685 = nil
    local f425 = nil
    for _, entry in ipairs(list) do
        local ok, uvs = pcall(debug.getupvalues, entry.fn)
        local live = false
        if ok then
            for _, value in ipairs(uvs) do
                if isLiveIn(ui, value) then
                    live = true
                    break
                end
            end
        end
        if live then
            if entry.line == 685 then
                f685 = entry.fn
            elseif entry.line == 425 then
                f425 = entry.fn
            end
        end
    end
    if not f685 then
        for _, entry in ipairs(list) do
            local ok, uvs = pcall(debug.getupvalues, entry.fn)
            local hasDrag = false
            local hasTarget = false
            if ok then
                for _, value in ipairs(uvs) do
                    if typeof(value) == "Instance" and value:IsA("UIDragDetector") then
                        hasDrag = true
                    end
                    if typeof(value) == "Instance" and value.Name == "TargetFrame" then
                        hasTarget = true
                    end
                end
            end
            if hasDrag and hasTarget then
                f685 = entry.fn
                break
            end
        end
    end
    if not f425 then
        for _, entry in ipairs(list) do
            local ok, uvs = pcall(debug.getupvalues, entry.fn)
            local hasFrame = false
            local hasBar = false
            local hasActive = false
            if ok then
                for _, value in ipairs(uvs) do
                    if typeof(value) == "Instance" and value.Name == "FishingFrame" then
                        hasFrame = true
                    end
                    if typeof(value) == "Instance" and value.Name == "Bar" then
                        hasBar = true
                    end
                    if typeof(value) == "boolean" then
                        hasActive = true
                    end
                end
            end
            if hasFrame and hasBar and hasActive then
                f425 = entry.fn
                break
            end
        end
    end
    return f685, f425
end

local function waitForUi(baitMark, cancelMark, timeout)
    local t0 = os.clock()
    local gotBait = false
    while os.clock() - t0 < timeout do
        local ui = LP.PlayerGui:FindFirstChild("FishingUI")
        if ui then
            return ui
        end
        if S.baitLanded ~= baitMark then
            gotBait = true
        end
        if S.cancelCount ~= cancelMark then
            return nil, "canceled"
        end
        if not gotBait and os.clock() - t0 > 12 then
            return nil, "no bait"
        end
        task.wait(0.15)
    end
    return nil, "timeout"
end

local function playUi(ui)
    local f685, f425 = findUiFns(ui)
    if not f685 or not f425 then
        log("ui closures missing", tostring(f685), tostring(f425))
        return false
    end
    local pre = ui:FindFirstChild("PreFishingHolder")
    local fishHolder = ui:FindFirstChild("FishingHolder")
    if not pre or not fishHolder then
        return false
    end
    local frame = fishHolder:FindFirstChild("FishingFrame")
    if not frame then
        return false
    end
    local icon = frame:FindFirstChild("FishContainer", true)
    if icon then
        icon = icon:FindFirstChild("FishIcon")
    end
    local barContainer = frame:FindFirstChild("BarContainer", true)
    local bar = nil
    if barContainer then
        bar = barContainer:FindFirstChild("Bar")
    end

    local rounds = 0
    while rounds < 6 and ui.Parent and S.loopGen == S.generation do
        if fishHolder.Visible then
            break
        end
        if pre.Visible then
            local uvs = nil
            local okUv = pcall(function()
                uvs = debug.getupvalues(f685)
            end)
            if okUv and uvs and uvs[1] == "PreFishing" then
                pcall(f685)
            end
        end
        rounds = rounds + 1
        task.wait(0.85)
    end

    if not fishHolder.Visible then
        log("bar minigame did not start")
        return false
    end

    local input = makeFakeInput(Enum.UserInputState.Begin)
    local clicks = 0
    local lastClick = 0
    local minEnd = (S.startTime or os.clock()) + 5.6
    if minEnd - os.clock() > 20 then
        minEnd = os.clock() + 5.6
    end
    local t0 = os.clock()
    while os.clock() - t0 < 45 and ui.Parent and S.loopGen == S.generation do
        if fishHolder.Visible then
            local green = icon and icon.ImageColor3.G > 0.6
            local now = os.clock()
            local barValue = 0
            if bar then
                barValue = bar.Size.X.Scale
            end
            local holdUnder = now < minEnd and barValue >= 0.65
            if green and not holdUnder and now - lastClick >= 0.13 then
                pcall(f425, input, false)
                clicks = clicks + 1
                lastClick = now
            end
            if barValue >= 0.995 then
                task.wait(0.9)
                break
            end
        end
        task.wait(0.03)
    end

    log("bar done clicks=" .. tostring(clicks) .. " ui=" .. tostring(ui.Parent ~= nil))
    return ui.Parent == nil
end

local function runCycle()
    if S.loopGen ~= S.generation then
        return false
    end
    local xp0 = readXP()

    local leftover = LP.PlayerGui:FindFirstChild("FishingUI")
    if leftover then
        log("recovering leftover ui")
        playUi(leftover)
        task.wait(1)
    end

    local backpack = LP:FindFirstChildOfClass("Backpack")
    if backpack then
        local tools = 0
        for _, child in ipairs(backpack:GetChildren()) do
            if child:IsA("Tool") then
                tools = tools + 1
            end
        end
        if tools > 160 then
            log("backpack almost full, stopping", tostring(tools))
            S.running = false
            return false
        end
    end

    local rod = equipRod()
    if not rod then
        log("waiting for rod")
        local waitStart = os.clock()
        while os.clock() - waitStart < 90 and S.running do
            task.wait(1)
            rod = equipRod()
            if rod then
                break
            end
        end
    end
    if not rod then
        log("rod missing")
        return false
    end
    attachListeners()

    local f694, f730 = findRodFns(false)
    if not f730 then
        f694, f730 = findRodFns(true)
    end
    if not f730 then
        log("rod closures not found")
        return false
    end

    local baitMark = S.baitLanded
    local cancelMark = S.cancelCount
    local startMark = S.startCount

    local okCast, errCast = doCast(f694, f730)
    if not okCast then
        log("cast call failed", tostring(errCast))
        return false
    end

    local ui, why = waitForUi(baitMark, cancelMark, 70)
    if not ui then
        log("no minigame", tostring(why))
        task.wait(1.5)
        return false
    end

    playUi(ui)
    task.wait(1.5)

    local xp1 = readXP()
    if S.cancelCount ~= cancelMark then
        log("lost", tostring(S.lastCancel), "xp+" .. tostring(xp1 - xp0))
    elseif S.startCount ~= startMark and S.lastFish then
        local fish = S.lastFish
        log("catch", tostring(fish.FishName), tostring(fish.Rarity), tostring(fish.Weight) .. "kg", tostring(fish.Price), "xp+" .. tostring(xp1 - xp0))
    else
        log("cycle ended xp+" .. tostring(xp1 - xp0))
    end
    return true
end

local function ensureLoop()
    if S.loopRunning then
        return
    end
    S.running = true
    S.loopRunning = true
    S.loopGen = GEN
    task.spawn(function()
        while S.running and S.generation == GEN do
            local ok, err = pcall(runCycle)
            if not ok then
                log("cycle error", tostring(err))
            end
            task.wait(1.5)
        end
        S.loopRunning = false
        if S.generation == GEN then
            log("loop stopped")
        end
    end)
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then
        return
    end
    if input.KeyCode ~= Enum.KeyCode.F8 then
        return
    end
    if S.running then
        S.running = false
        log("stop requested")
    else
        ensureLoop()
        log("start requested")
    end
end)

log("=== fish_auto loaded ===")
ensureLoop()

-- GrowHub contract: the hub calls Stop() before loading another game.
getgenv().GrowGame = {
    Id = "indovoice_autofish",
    Name = "Indo Voice - Auto Fish",
    Version = "1.0.0",
    Stop = function()
        local st = getgenv()._fishAuto
        if st then
            st.running = false
        end
    end,
}