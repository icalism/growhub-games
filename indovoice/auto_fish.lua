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
-- komponen dari ctx.ui (kit GrowHub) supaya tampilan sama dengan tab lain.
local function buildUI(parent, ctx)
    ctx = ctx or {}
    local ui = ctx.ui
    if not ui then
        local l = Instance.new("TextLabel")
        l.Text = "Update GrowHub to use this panel (F8 still toggles auto fish)."
        l.TextColor3 = Color3.fromRGB(137, 143, 153)
        l.BackgroundTransparency = 1
        l.Size = UDim2.new(1, 0, 0, 24)
        l.Parent = parent
        return
    end
    local Theme = ctx.Theme
    local setFont, corner, addStroke, tw = ctx.setFont, ctx.corner, ctx.addStroke, ctx.tween
    local notify = ctx.notify or function() end

    local RS = game:GetService("ReplicatedStorage")
    local okCountry, Country = pcall(function()
        return require(RS:WaitForChild("Content", 5):WaitForChild("Country", 5))
    end)
    if not okCountry or type(Country) ~= "table" then
        Country = {}
    end

    local countries = {}
    local byCode = {}
    for code, v in pairs(Country) do
        local item = {
            code = tostring(code),
            name = tostring(type(v) == "table" and v.CountryName or code),
            icon = tostring(type(v) == "table" and v.Icon or ""),
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

    local left, right = ui.columns()

    -- ── kolom kiri: auto fish ───────────────────────────────────────────────
    local fish = ui.section(left, "fish", "AUTO FISH")
    local setRun = ui.toggle(fish, "Auto Fish · F8", S.running == true, function(v)
        if v then
            if type(S.start) == "function" then
                S.start()
                notify("Auto fish started", "play")
            end
        elseif type(S.stop) == "function" then
            S.stop()
            notify("Auto fish stopped", "circle-stop")
        end
    end)
    local sState = ui.stat(fish, "activity", "Status")
    local sCatch = ui.stat(fish, "fish", "Catches")
    local sLast = ui.stat(fish, "sparkles", "Last Catch")
    local sDetail = ui.stat(fish, "scale", "Weight")
    local sSession = ui.stat(fish, "clock", "Session")

    local tips = ui.section(left, "info", "NOTES")
    local tipBlock = ui.block(tips, 52)
    local tip = Instance.new("TextLabel")
    tip.Text = "Stand still with the rod equipped. The loop casts, skips the drag phase and plays the bar minigame for you."
    setFont(tip, "Medium")
    tip.TextSize = 11
    tip.TextColor3 = Theme.TEXT_MUTED
    tip.TextWrapped = true
    tip.TextXAlignment = Enum.TextXAlignment.Left
    tip.TextYAlignment = Enum.TextYAlignment.Top
    tip.Position = UDim2.fromOffset(8, 2)
    tip.Size = UDim2.new(1, -16, 1, -4)
    tip.BackgroundTransparency = 1
    tip.ZIndex = 106
    tip.Parent = tipBlock

    -- ── kolom kanan: flag changer ───────────────────────────────────────────
    local flag = ui.section(right, "flag", "FLAG")
    local cur = ui.block(flag, 30)
    local preview = Instance.new("ImageLabel")
    preview.Size = UDim2.fromOffset(24, 16)
    preview.Position = UDim2.new(0, 8, 0.5, -8)
    preview.BackgroundColor3 = Theme.WIN_BG
    preview.BackgroundTransparency = 0.2
    preview.ScaleType = Enum.ScaleType.Fit
    preview.ZIndex = 106
    preview.Parent = cur
    corner(preview, UDim.new(0, 3))
    local curName = Instance.new("TextLabel")
    setFont(curName, "Bold")
    curName.TextSize = 12
    curName.TextColor3 = Theme.TEXT_MAIN
    curName.Position = UDim2.fromOffset(40, 0)
    curName.Size = UDim2.new(1, -90, 1, 0)
    curName.BackgroundTransparency = 1
    curName.TextXAlignment = Enum.TextXAlignment.Left
    curName.TextTruncate = Enum.TextTruncate.AtEnd
    curName.ZIndex = 106
    curName.Parent = cur
    local curCode = Instance.new("TextLabel")
    setFont(curCode, "Bold")
    curCode.TextSize = 10
    curCode.TextColor3 = Theme.NEON_GREEN
    curCode.BackgroundColor3 = Theme.WIN_BG
    curCode.BackgroundTransparency = 0.1
    curCode.Position = UDim2.new(1, -46, 0.5, -8)
    curCode.Size = UDim2.fromOffset(38, 16)
    curCode.ZIndex = 106
    curCode.Parent = cur
    corner(curCode, UDim.new(0, 5))

    local listBlock = ui.block(flag, #countries > 0 and 236 or 26)
    local searchFrame = Instance.new("Frame")
    searchFrame.Size = UDim2.new(1, -16, 0, 26)
    searchFrame.Position = UDim2.fromOffset(8, 2)
    searchFrame.BackgroundColor3 = Theme.WIN_BG
    searchFrame.BackgroundTransparency = 0.1
    searchFrame.ZIndex = 106
    searchFrame.Parent = listBlock
    corner(searchFrame, UDim.new(0, 7))
    local searchStroke = addStroke(searchFrame, Theme.BORDER_DIM, 1, 0.5)
    local sIco = Instance.new("ImageLabel")
    sIco.Size = UDim2.fromOffset(12, 12)
    sIco.Position = UDim2.new(0, 9, 0.5, -6)
    sIco.BackgroundTransparency = 1
    sIco.ImageColor3 = Theme.TEXT_MUTED
    sIco.ZIndex = 107
    sIco.Parent = searchFrame
    if ctx.setLucide then ctx.setLucide(sIco, "search") end
    local search = Instance.new("TextBox")
    search.Text = ""
    search.PlaceholderText = "Search country..."
    search.PlaceholderColor3 = Theme.TEXT_MUTED
    search.ClearTextOnFocus = false
    setFont(search, "Medium")
    search.TextSize = 11
    search.TextColor3 = Theme.TEXT_MAIN
    search.TextXAlignment = Enum.TextXAlignment.Left
    search.BackgroundTransparency = 1
    search.Position = UDim2.fromOffset(28, 0)
    search.Size = UDim2.new(1, -36, 1, 0)
    search.ZIndex = 107
    search.Parent = searchFrame
    search.Focused:Connect(function() tw(searchStroke, { Color = Theme.NEON_GREEN, Transparency = 0.3 }, 0.15) end)
    search.FocusLost:Connect(function() tw(searchStroke, { Color = Theme.BORDER_DIM, Transparency = 0.5 }, 0.15) end)

    local list = Instance.new("ScrollingFrame")
    list.Position = UDim2.fromOffset(8, 34)
    list.Size = UDim2.new(1, -16, 1, -36)
    list.BackgroundTransparency = 1
    list.BorderSizePixel = 0
    list.ScrollBarThickness = 2
    list.ScrollBarImageColor3 = Theme.CARD_ACTIVE
    list.ScrollingDirection = Enum.ScrollingDirection.Y
    list.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
    list.CanvasSize = UDim2.fromOffset(0, 0)
    list.AutomaticCanvasSize = Enum.AutomaticSize.Y
    list.ZIndex = 106
    list.Parent = listBlock
    local ll = Instance.new("UIListLayout")
    ll.Padding = UDim.new(0, 1)
    ll.SortOrder = Enum.SortOrder.LayoutOrder
    ll.Parent = list

    -- baris negara: style item dropdown GrowHub (bar aksen + sorot saat terpilih)
    local rows = {}
    local function paintRow(r)
        local sel = r.code == S.flagCode
        r.bar.Visible = sel
        r.btn.BackgroundTransparency = sel and 0.55 or 1
        r.name.TextColor3 = sel and Theme.NEON_GREEN or Theme.TEXT_MAIN
        setFont(r.name, sel and "Bold" or "SemiBold")
    end

    local function updatePreview()
        local item = byCode[S.flagCode]
        preview.Image = item and item.icon or ""
        curName.Text = item and item.name or "Unknown"
        curName.TextColor3 = item and Theme.TEXT_MAIN or Theme.TEXT_MUTED
        curCode.Text = item and item.code or "--"
        for _, r in ipairs(rows) do paintRow(r) end
    end

    local function applyFlag(code)
        if S.flagBusy then
            notify("Wait a moment before changing again", "clock")
            return
        end
        local events = RS:FindFirstChild("GameRemoteEvents")
        local ev = events and events:FindFirstChild("CountryChangedEvent")
        if not ev then
            notify("Country remote not found", "alert-triangle")
            return
        end
        S.flagBusy = true
        local ok = pcall(function() ev:FireServer(code) end)
        if ok then
            S.flagCode = code
            updatePreview()
            local item = byCode[code]
            notify("Flag: " .. (item and item.name or code), "flag")
            task.delay(1.5, function()
                local actual = detectFlagCode()
                if actual and actual ~= code then
                    S.flagCode = actual
                    pcall(updatePreview)
                    notify("Flag change was rate-limited, try again", "alert-triangle")
                end
            end)
            task.delay(2.1, function() S.flagBusy = false end)
        else
            notify("Flag change failed", "alert-triangle")
            task.delay(0.5, function() S.flagBusy = false end)
        end
    end

    for i, c in ipairs(countries) do
        local btn = Instance.new("TextButton")
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.BackgroundColor3 = Theme.CARD_HOVER
        btn.BackgroundTransparency = 1
        btn.Size = UDim2.new(1, 0, 0, 24)
        btn.LayoutOrder = i
        btn.ZIndex = 107
        btn.Parent = list
        corner(btn, UDim.new(0, 6))
        local bar = Instance.new("Frame")
        bar.Size = UDim2.fromOffset(2, 12)
        bar.Position = UDim2.new(0, 3, 0.5, -6)
        bar.BackgroundColor3 = Theme.NEON_GREEN
        bar.BorderSizePixel = 0
        bar.Visible = false
        bar.ZIndex = 108
        bar.Parent = btn
        local icon = Instance.new("ImageLabel")
        icon.Size = UDim2.fromOffset(18, 12)
        icon.Position = UDim2.new(0, 10, 0.5, -6)
        icon.BackgroundTransparency = 1
        icon.Image = c.icon
        icon.ScaleType = Enum.ScaleType.Fit
        icon.ZIndex = 108
        icon.Parent = btn
        local name = Instance.new("TextLabel")
        name.Text = c.name
        setFont(name, "SemiBold")
        name.TextSize = 11
        name.Position = UDim2.fromOffset(34, 0)
        name.Size = UDim2.new(1, -72, 1, 0)
        name.BackgroundTransparency = 1
        name.TextXAlignment = Enum.TextXAlignment.Left
        name.TextTruncate = Enum.TextTruncate.AtEnd
        name.ZIndex = 108
        name.Parent = btn
        local code = Instance.new("TextLabel")
        code.Text = c.code
        setFont(code, "Bold")
        code.TextSize = 9
        code.TextColor3 = Theme.TEXT_MUTED
        code.Position = UDim2.new(1, -38, 0, 0)
        code.Size = UDim2.new(0, 30, 1, 0)
        code.BackgroundTransparency = 1
        code.TextXAlignment = Enum.TextXAlignment.Right
        code.ZIndex = 108
        code.Parent = btn
        local r = { code = c.code, hay = string.lower(c.name .. " " .. c.code), btn = btn, bar = bar, name = name }
        rows[#rows + 1] = r
        btn.MouseEnter:Connect(function() tw(btn, { BackgroundTransparency = 0.3 }, 0.1) end)
        btn.MouseLeave:Connect(function() tw(btn, { BackgroundTransparency = (r.code == S.flagCode) and 0.55 or 1 }, 0.1) end)
        btn.MouseButton1Click:Connect(function() applyFlag(c.code) end)
    end
    if #countries == 0 then
        searchFrame.Visible = false
        preview.Visible = false
        curName.Position = UDim2.fromOffset(8, 0)
        list.Position = UDim2.fromOffset(8, 0)
        list.Size = UDim2.new(1, -16, 1, 0)
        local e = Instance.new("TextLabel")
        e.Text = "Flag list is only available in Indo Voice."
        e.TextXAlignment = Enum.TextXAlignment.Left
        setFont(e, "Medium")
        e.TextSize = 11
        e.TextColor3 = Theme.TEXT_MUTED
        e.Size = UDim2.new(1, 0, 0, 24)
        e.BackgroundTransparency = 1
        e.ZIndex = 107
        e.Parent = list
    end

    -- filter tanpa rebuild (list ~200 negara)
    search:GetPropertyChangedSignal("Text"):Connect(function()
        local q = string.lower(search.Text)
        for _, r in ipairs(rows) do
            r.btn.Visible = q == "" or string.find(r.hay, q, 1, true) ~= nil
        end
    end)

    local shownRun = S.running == true
    local function refresh()
        local running = S.running == true
        if running ~= shownRun then
            shownRun = running
            setRun(running, true) -- sync dari F8 tanpa memicu callback
        end
        if running then
            sState("running", Theme.NEON_GREEN)
        elseif S.loopRunning then
            sState("stopping...", Theme.TEXT_MUTED)
        else
            sState("stopped", Theme.TEXT_MUTED)
        end
        sCatch(tostring(S.catchCount or 0), Theme.NEON_GREEN)
        local lc = S.lastCatch
        if type(lc) == "table" then
            sLast(tostring(lc.name or "?") .. " · " .. tostring(lc.rarity or "?"))
            sDetail(string.format("%.2f kg · $%s", tonumber(lc.weight) or 0, tostring(lc.price or 0)))
        else
            sLast("no catch yet", Theme.TEXT_MUTED)
            sDetail("--", Theme.TEXT_MUTED)
        end
        if running and (tonumber(S.startTime) or 0) > 0 then
            local secs = math.max(0, math.floor(os.clock() - S.startTime))
            sSession(string.format("%02d:%02d", math.floor(secs / 60), secs % 60))
        else
            sSession("--:--", Theme.TEXT_MUTED)
        end
    end

    updatePreview()
    refresh()
    task.spawn(function()
        while parent.Parent do
            pcall(refresh)
            task.wait(0.5)
        end
    end)
end

getgenv().GrowGame = {
    Id = "indovoice_autofish",
    Name = "Indo Voice",
    Version = "1.2.0",
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
