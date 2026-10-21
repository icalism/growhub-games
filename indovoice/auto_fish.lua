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
S.catchCount = S.catchCount or 0
S.lastCatch = S.lastCatch
S.flagCode = S.flagCode
S.flagBusy = false
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
        local gained = xp1 - xp0
        S.catchCount = (S.catchCount or 0) + 1
        S.lastCatch = {
            name = tostring(fish.FishName or "?"),
            rarity = tostring(fish.Rarity or "?"),
            weight = tonumber(fish.Weight) or 0,
            price = tonumber(fish.Price) or 0,
            xp = gained,
            at = os.time(),
        }
        log("catch", tostring(fish.FishName), tostring(fish.Rarity), tostring(fish.Weight) .. "kg", tostring(fish.Price), "xp+" .. tostring(gained))
    else
        log("cycle ended xp+" .. tostring(xp1 - xp0))
    end
    return true
end

local function ensureLoop()
    if S.loopRunning then
        S.running = true
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
        if S.generation == GEN then
            S.loopRunning = false
            log("loop stopped")
        end
    end)
end

S.start = ensureLoop
S.stop = function()
    S.running = false
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

-- GrowHub contract: UI(parent, ctx) mounts the game panel inside the Games tab.
local function buildUI(parent, ctx)
    ctx = ctx or {}
    local Theme = ctx.Theme or {
        TEXT_MAIN = Color3.fromRGB(240, 242, 245),
        TEXT_MUTED = Color3.fromRGB(137, 143, 153),
        CARD_BG = Color3.fromRGB(27, 28, 34),
        WIN_BG = Color3.fromRGB(16, 17, 21),
        NEON_GREEN = Color3.fromRGB(158, 255, 74),
        ACCENT_RED = Color3.fromRGB(255, 92, 102),
        BORDER_DIM = Color3.fromRGB(39, 41, 49),
    }
    local setFont = ctx.setFont or function(obj, weight)
        obj.Font = (weight == "Bold" and Enum.Font.GothamBold) or (weight == "SemiBold" and Enum.Font.GothamSemibold) or Enum.Font.Gotham
    end
    local corner = ctx.corner or function(obj, radius)
        local c = Instance.new("UICorner")
        c.CornerRadius = radius or UDim.new(0, 10)
        c.Parent = obj
        return c
    end
    local addStroke = ctx.addStroke or function(obj, color, thickness, transparency)
        local s = Instance.new("UIStroke")
        s.Color = color or Theme.BORDER_DIM
        s.Thickness = thickness or 1
        s.Transparency = transparency or 0.5
        s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        s.Parent = obj
        return s
    end
    local notify = ctx.notify or function() end

    local RS = game:GetService("ReplicatedStorage")
    local okCountry, Country = pcall(function()
        return require(RS:WaitForChild("Content"):WaitForChild("Country"))
    end)
    if not okCountry or type(Country) ~= "table" then
        Country = {}
    end

    local countries = {}
    local byCode = {}
    for code, v in pairs(Country) do
        local item = {
            code = tostring(code),
            name = tostring(v.CountryName or code),
            icon = tostring(v.Icon or ""),
        }
        countries[#countries + 1] = item
        byCode[item.code] = item
    end
    table.sort(countries, function(a, b)
        return string.lower(a.name) < string.lower(b.name)
    end)

    local function detectFlagCode()
        local pg = LP:FindFirstChild("PlayerGui")
        local plist = pg and pg:FindFirstChild("PlayerList")
        local entry = plist and plist:FindFirstChild(LP.Name, true)
        local icon = entry and entry:FindFirstChild("CountryIcon", true)
        local img = icon and tostring(icon.Image) or ""
        local found = nil
        for _, c in ipairs(countries) do
            if c.icon == img then
                if c.code == S.flagCode then
                    return c.code
                end
                found = found or c.code
            end
        end
        return found
    end

    S.flagCode = detectFlagCode() or S.flagCode or "ID"

    parent.BackgroundTransparency = 1
    parent.ZIndex = 106

    local header = Instance.new("TextLabel")
    header.Text = "Indo Voice"
    setFont(header, "Bold")
    header.TextSize = 16
    header.TextColor3 = Theme.TEXT_MAIN
    header.Position = UDim2.fromOffset(0, 0)
    header.Size = UDim2.new(1, 0, 0, 20)
    header.BackgroundTransparency = 1
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.ZIndex = 107
    header.Parent = parent

    local sub = Instance.new("TextLabel")
    sub.Text = "Auto Fish  ·  flag changer"
    setFont(sub, "Medium")
    sub.TextSize = 10
    sub.TextColor3 = Theme.TEXT_MUTED
    sub.Position = UDim2.fromOffset(0, 21)
    sub.Size = UDim2.new(1, 0, 0, 14)
    sub.BackgroundTransparency = 1
    sub.TextXAlignment = Enum.TextXAlignment.Left
    sub.ZIndex = 107
    sub.Parent = parent

    local function makeCard(pos, size)
        local card = Instance.new("Frame")
        card.Position = pos
        card.Size = size
        card.BackgroundColor3 = Theme.CARD_BG
        card.BackgroundTransparency = 0.08
        card.ZIndex = 107
        card.Parent = parent
        corner(card, UDim.new(0, 10))
        addStroke(card, Theme.BORDER_DIM, 1, 0.45)
        return card
    end

    local left = makeCard(UDim2.fromOffset(0, 40), UDim2.new(0.54, -6, 1, -46))
    local right = makeCard(UDim2.new(0.54, 6, 0, 40), UDim2.new(0.46, -6, 1, -46))

    local leftTitle = Instance.new("TextLabel")
    leftTitle.Text = "AUTO FISH"
    setFont(leftTitle, "Bold")
    leftTitle.TextSize = 11
    leftTitle.TextColor3 = Theme.TEXT_MAIN
    leftTitle.Position = UDim2.fromOffset(12, 10)
    leftTitle.Size = UDim2.new(1, -24, 0, 16)
    leftTitle.BackgroundTransparency = 1
    leftTitle.TextXAlignment = Enum.TextXAlignment.Left
    leftTitle.ZIndex = 108
    leftTitle.Parent = left

    local dot = Instance.new("Frame")
    dot.Size = UDim2.fromOffset(7, 7)
    dot.Position = UDim2.fromOffset(12, 34)
    dot.BackgroundColor3 = Theme.ACCENT_RED
    dot.BorderSizePixel = 0
    dot.ZIndex = 108
    dot.Parent = left
    corner(dot, UDim.new(1, 0))

    local stateLbl = Instance.new("TextLabel")
    stateLbl.Text = "stopped"
    setFont(stateLbl, "SemiBold")
    stateLbl.TextSize = 10
    stateLbl.TextColor3 = Theme.TEXT_MUTED
    stateLbl.Position = UDim2.fromOffset(25, 29)
    stateLbl.Size = UDim2.new(1, -37, 0, 16)
    stateLbl.BackgroundTransparency = 1
    stateLbl.TextXAlignment = Enum.TextXAlignment.Left
    stateLbl.ZIndex = 108
    stateLbl.Parent = left

    local catchLbl = Instance.new("TextLabel")
    catchLbl.Text = "CATCHES"
    setFont(catchLbl, "SemiBold")
    catchLbl.TextSize = 9
    catchLbl.TextColor3 = Theme.TEXT_MUTED
    catchLbl.Position = UDim2.fromOffset(12, 56)
    catchLbl.Size = UDim2.new(1, -24, 0, 12)
    catchLbl.BackgroundTransparency = 1
    catchLbl.TextXAlignment = Enum.TextXAlignment.Left
    catchLbl.ZIndex = 108
    catchLbl.Parent = left

    local catchVal = Instance.new("TextLabel")
    catchVal.Text = "0"
    setFont(catchVal, "Bold")
    catchVal.TextSize = 24
    catchVal.TextColor3 = Theme.NEON_GREEN
    catchVal.Position = UDim2.fromOffset(12, 68)
    catchVal.Size = UDim2.new(1, -24, 0, 30)
    catchVal.BackgroundTransparency = 1
    catchVal.TextXAlignment = Enum.TextXAlignment.Left
    catchVal.ZIndex = 108
    catchVal.Parent = left

    local lastLbl = Instance.new("TextLabel")
    lastLbl.Text = "LAST CATCH"
    setFont(lastLbl, "SemiBold")
    lastLbl.TextSize = 9
    lastLbl.TextColor3 = Theme.TEXT_MUTED
    lastLbl.Position = UDim2.fromOffset(12, 104)
    lastLbl.Size = UDim2.new(1, -24, 0, 12)
    lastLbl.BackgroundTransparency = 1
    lastLbl.TextXAlignment = Enum.TextXAlignment.Left
    lastLbl.ZIndex = 108
    lastLbl.Parent = left

    local lastVal = Instance.new("TextLabel")
    lastVal.Text = "no catch yet"
    setFont(lastVal, "Medium")
    lastVal.TextSize = 11
    lastVal.TextColor3 = Theme.TEXT_MAIN
    lastVal.Position = UDim2.fromOffset(12, 118)
    lastVal.Size = UDim2.new(1, -24, 0, 34)
    lastVal.BackgroundTransparency = 1
    lastVal.TextXAlignment = Enum.TextXAlignment.Left
    lastVal.TextYAlignment = Enum.TextYAlignment.Top
    lastVal.TextWrapped = true
    lastVal.ZIndex = 108
    lastVal.Parent = left

    local sessionLbl = Instance.new("TextLabel")
    sessionLbl.Text = "SESSION"
    setFont(sessionLbl, "SemiBold")
    sessionLbl.TextSize = 9
    sessionLbl.TextColor3 = Theme.TEXT_MUTED
    sessionLbl.Position = UDim2.fromOffset(12, 158)
    sessionLbl.Size = UDim2.new(1, -24, 0, 12)
    sessionLbl.BackgroundTransparency = 1
    sessionLbl.TextXAlignment = Enum.TextXAlignment.Left
    sessionLbl.ZIndex = 108
    sessionLbl.Parent = left

    local sessionVal = Instance.new("TextLabel")
    sessionVal.Text = "--:--"
    setFont(sessionVal, "SemiBold")
    sessionVal.TextSize = 12
    sessionVal.TextColor3 = Theme.TEXT_MAIN
    sessionVal.Position = UDim2.fromOffset(12, 171)
    sessionVal.Size = UDim2.new(1, -24, 0, 16)
    sessionVal.BackgroundTransparency = 1
    sessionVal.TextXAlignment = Enum.TextXAlignment.Left
    sessionVal.ZIndex = 108
    sessionVal.Parent = left

    local toggle = Instance.new("TextButton")
    toggle.Text = "START AUTO FISH"
    setFont(toggle, "Bold")
    toggle.TextSize = 11
    toggle.TextColor3 = Color3.fromRGB(8, 14, 11)
    toggle.BackgroundColor3 = Theme.NEON_GREEN
    toggle.BackgroundTransparency = 0
    toggle.AutoButtonColor = false
    toggle.Position = UDim2.new(0, 12, 1, -46)
    toggle.Size = UDim2.new(1, -24, 0, 34)
    toggle.ZIndex = 109
    toggle.Parent = left
    corner(toggle, UDim.new(0, 8))

    local flagTitle = Instance.new("TextLabel")
    flagTitle.Text = "FLAG"
    setFont(flagTitle, "Bold")
    flagTitle.TextSize = 11
    flagTitle.TextColor3 = Theme.TEXT_MAIN
    flagTitle.Position = UDim2.fromOffset(12, 10)
    flagTitle.Size = UDim2.new(1, -24, 0, 16)
    flagTitle.BackgroundTransparency = 1
    flagTitle.TextXAlignment = Enum.TextXAlignment.Left
    flagTitle.ZIndex = 108
    flagTitle.Parent = right

    local preview = Instance.new("ImageLabel")
    preview.Size = UDim2.fromOffset(26, 18)
    preview.Position = UDim2.fromOffset(12, 30)
    preview.BackgroundColor3 = Theme.WIN_BG
    preview.BackgroundTransparency = 0.3
    preview.BorderSizePixel = 0
    preview.ScaleType = Enum.ScaleType.Fit
    preview.ZIndex = 108
    preview.Parent = right
    corner(preview, UDim.new(0, 3))

    local currentLbl = Instance.new("TextLabel")
    currentLbl.Text = "current"
    setFont(currentLbl, "SemiBold")
    currentLbl.TextSize = 10
    currentLbl.TextColor3 = Theme.TEXT_MUTED
    currentLbl.Position = UDim2.fromOffset(44, 30)
    currentLbl.Size = UDim2.new(1, -56, 0, 18)
    currentLbl.BackgroundTransparency = 1
    currentLbl.TextXAlignment = Enum.TextXAlignment.Left
    currentLbl.TextTruncate = Enum.TextTruncate.AtEnd
    currentLbl.ZIndex = 108
    currentLbl.Parent = right

    local search = Instance.new("TextBox")
    search.Text = ""
    search.PlaceholderText = "search country"
    search.PlaceholderColor3 = Theme.TEXT_MUTED
    search.ClearTextOnFocus = false
    setFont(search, "Medium")
    search.TextSize = 10
    search.TextColor3 = Theme.TEXT_MAIN
    search.BackgroundColor3 = Theme.WIN_BG
    search.BackgroundTransparency = 0.15
    search.Position = UDim2.fromOffset(12, 56)
    search.Size = UDim2.new(1, -24, 0, 26)
    search.ZIndex = 109
    search.Parent = right
    corner(search, UDim.new(0, 7))
    addStroke(search, Theme.BORDER_DIM, 1, 0.5)

    local list = Instance.new("ScrollingFrame")
    list.Position = UDim2.fromOffset(12, 90)
    list.Size = UDim2.new(1, -24, 1, -100)
    list.BackgroundTransparency = 1
    list.BorderSizePixel = 0
    list.ScrollBarThickness = 3
    list.ScrollBarImageColor3 = Theme.NEON_GREEN
    list.CanvasSize = UDim2.fromOffset(0, 0)
    list.ZIndex = 108
    list.Parent = right

    local rows = {}

    local function updatePreview()
        local item = byCode[S.flagCode]
        if item then
            preview.Image = item.icon
            currentLbl.Text = item.name .. "  ·  " .. item.code
            currentLbl.TextColor3 = Theme.TEXT_MAIN
        else
            preview.Image = ""
            currentLbl.Text = tostring(S.flagCode or "unknown")
            currentLbl.TextColor3 = Theme.TEXT_MUTED
        end
    end

    local renderFlags

    local function applyFlag(code)
        if S.flagBusy then
            return
        end
        local events = RS:FindFirstChild("GameRemoteEvents")
        local ev = events and events:FindFirstChild("CountryChangedEvent")
        if not ev then
            notify("country remote not found", "alert-triangle")
            return
        end
        S.flagBusy = true
        local requested = code
        local ok = pcall(function()
            ev:FireServer(requested)
        end)
        if ok then
            S.flagCode = requested
            updatePreview()
            if renderFlags then
                renderFlags(search.Text)
            end
            local item = byCode[requested]
            notify("Flag: " .. (item and item.name or requested), "flag")
            task.delay(1.5, function()
                local actual = detectFlagCode()
                if actual and actual ~= requested then
                    S.flagCode = actual
                    pcall(updatePreview)
                    if renderFlags then pcall(renderFlags, search.Text) end
                    notify("Flag change was rate-limited, try again", "alert-triangle")
                end
            end)
            task.delay(2.1, function()
                S.flagBusy = false
            end)
        else
            notify("flag change failed", "alert-triangle")
            task.delay(0.5, function()
                S.flagBusy = false
            end)
        end
    end

    renderFlags = function(filter)
        for i = #rows, 1, -1 do
            pcall(function() rows[i]:Destroy() end)
            rows[i] = nil
        end
        local q = string.lower(tostring(filter or ""))
        local y = 0
        for _, c in ipairs(countries) do
            local hay = string.lower(c.name) .. " " .. string.lower(c.code)
            if q == "" or string.find(hay, q, 1, true) then
                local active = c.code == S.flagCode
                local row = Instance.new("TextButton")
                row.Text = ""
                row.AutoButtonColor = false
                row.BackgroundColor3 = Theme.CARD_BG
                row.BackgroundTransparency = active and 0.35 or 1
                row.Position = UDim2.fromOffset(0, y)
                row.Size = UDim2.new(1, -4, 0, 26)
                row.ZIndex = 108
                row.Parent = list
                corner(row, UDim.new(0, 6))
                addStroke(row, active and Theme.NEON_GREEN or Theme.BORDER_DIM, 1, active and 0.25 or 1)

                local icon = Instance.new("ImageLabel")
                icon.Size = UDim2.fromOffset(18, 12)
                icon.Position = UDim2.fromOffset(6, 7)
                icon.BackgroundTransparency = 1
                icon.Image = c.icon
                icon.ScaleType = Enum.ScaleType.Fit
                icon.ZIndex = 109
                icon.Parent = row

                local nameLbl = Instance.new("TextLabel")
                nameLbl.Text = c.name
                setFont(nameLbl, active and "SemiBold" or "Medium")
                nameLbl.TextSize = 10
                nameLbl.TextColor3 = active and Theme.NEON_GREEN or Theme.TEXT_MAIN
                nameLbl.Position = UDim2.fromOffset(30, 4)
                nameLbl.Size = UDim2.new(1, -64, 0, 18)
                nameLbl.BackgroundTransparency = 1
                nameLbl.TextXAlignment = Enum.TextXAlignment.Left
                nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
                nameLbl.ZIndex = 109
                nameLbl.Parent = row

                local codeLbl = Instance.new("TextLabel")
                codeLbl.Text = c.code
                setFont(codeLbl, "SemiBold")
                codeLbl.TextSize = 9
                codeLbl.TextColor3 = Theme.TEXT_MUTED
                codeLbl.Position = UDim2.new(1, -36, 0, 4)
                codeLbl.Size = UDim2.fromOffset(30, 18)
                codeLbl.BackgroundTransparency = 1
                codeLbl.TextXAlignment = Enum.TextXAlignment.Right
                codeLbl.ZIndex = 109
                codeLbl.Parent = row

                row.MouseButton1Click:Connect(function()
                    applyFlag(c.code)
                end)

                rows[#rows + 1] = row
                y = y + 28
            end
        end
        list.CanvasSize = UDim2.fromOffset(0, math.max(y, 1))
    end

    local function refreshState()
        local running = S.running == true
        dot.BackgroundColor3 = running and Theme.NEON_GREEN or Theme.ACCENT_RED
        stateLbl.Text = running and "running" or (S.loopRunning and "stopping..." or "stopped")
        stateLbl.TextColor3 = running and Theme.NEON_GREEN or Theme.TEXT_MUTED
        toggle.Text = running and "STOP AUTO FISH" or "START AUTO FISH"
        toggle.BackgroundColor3 = running and Theme.ACCENT_RED or Theme.NEON_GREEN
        toggle.TextColor3 = running and Color3.fromRGB(255, 244, 244) or Color3.fromRGB(8, 14, 11)
    end

    local function refreshStats()
        catchVal.Text = tostring(S.catchCount or 0)
        local lc = S.lastCatch
        if type(lc) == "table" then
            lastVal.Text = tostring(lc.name or "?") .. "  ·  " .. tostring(lc.rarity or "?")
                .. "\n" .. string.format("%.2f", tonumber(lc.weight) or 0) .. " kg  ·  $" .. tostring(lc.price or 0)
        else
            lastVal.Text = "no catch yet"
        end
        if S.running and (tonumber(S.startTime) or 0) > 0 then
            local secs = math.max(0, math.floor(os.clock() - S.startTime))
            sessionVal.Text = string.format("%02d:%02d", math.floor(secs / 60), secs % 60)
        else
            sessionVal.Text = "--:--"
        end
    end

    toggle.MouseButton1Click:Connect(function()
        if S.running then
            S.stop()
            notify("Auto fish stopped", "square")
        else
            if type(S.start) == "function" then
                S.start()
                notify("Auto fish started", "play")
            else
                notify("start function missing", "alert-triangle")
            end
        end
        refreshState()
    end)

    search:GetPropertyChangedSignal("Text"):Connect(function()
        renderFlags(search.Text)
    end)

    updatePreview()
    renderFlags("")
    refreshState()
    refreshStats()

    task.spawn(function()
        while parent.Parent do
            pcall(refreshState)
            pcall(refreshStats)
            task.wait(0.5)
        end
    end)
end

getgenv().GrowGame = {
    Id = "indovoice_autofish",
    Name = "Indo Voice",
    Version = "1.1.2",
    UI = buildUI,
    Stop = function()
        local st = getgenv()._fishAuto
        if st and type(st.stop) == "function" then
            st.stop()
        elseif st then
            st.running = false
        end
    end,
}