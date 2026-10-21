-- vd.lua -- Violence District automation for GrowHub
-- survivor side: insta skillchecks, auto parry, auto repair / heal / unhook / escape, esp, fullbright, movement
-- remote map reverse-engineered live: Generator.SkillCheckResultEvent("success",1,token,genPoint),
-- Healing.SkillCheckResultEvent("success",1,token), Items["Parrying Dagger"].parry(),
-- Generator.RepairEvent(point,true/false), Healing.HealEvent(target,true/false), Carry.UnHookEvent(point),
-- Carry.SelfUnHookEvent(), Exit.LeverEvent(point,true/false), Pallet.PalletDropEvent(point)
-- interaction points come from CollectionService tags: GeneratorPoint, UnhookPoint, ExitPoint, PalletPoint

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local Lighting = game:GetService("Lighting")

local LP = Players.LocalPlayer
local LOG_FILE = "vd_log.txt"

local S = getgenv()._vdState
if type(S) ~= "table" then
    S = {}
    getgenv()._vdState = S
end

if type(S.cleanup) == "function" then
    pcall(S.cleanup)
end

S.generation = (S.generation or 0) + 1
local GEN = S.generation
local alive = true

S.conns = {}
S.teardowns = {}
S.espObjs = {}
S.ncSaved = {}

if type(S.features) ~= "table" then
    S.features = {
        instaCheck = false,
        autoParry = false,
        parryEquip = true,
        parryReach = 16,
        autoRepair = false,
        autoHeal = false,
        healOthers = false,
        autoUnhook = false,
        selfUnhook = false,
        autoEscape = false,
        autoPalletDrop = false,
        esp = false,
        fullbright = false,
        noClip = false,
        speed = false,
        speedValue = 22,
        checkMode = "off",
        instantValue = 100,
    }
end
local F = S.features
if F.checkMode == nil then
    F.checkMode = F.instaCheck and "perfect" or "off"
end
F.instaCheck = F.checkMode ~= "off"

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
    if #old > 40000 then
        old = old:sub(-12000)
    end
    pcall(writefile, LOG_FILE, old .. line .. "\n")
end

local function mkConn(conn)
    if conn then
        table.insert(S.conns, conn)
    end
    return conn
end

local function clearConns()
    for _, c in ipairs(S.conns) do
        pcall(function()
            c:Disconnect()
        end)
    end
    table.clear(S.conns)
end

-- remotes
local Remotes = RS:WaitForChild("Remotes", 30)
local GeneratorR = Remotes and Remotes.Generator
local HealingR = Remotes and Remotes.Healing
local CarryR = Remotes and Remotes.Carry
local ExitR = Remotes and Remotes.Exit
local PalletR = Remotes and Remotes.Pallet
local ItemsR = Remotes and Remotes.Items

local function remote(path1, path2)
    local folder = Remotes and Remotes[path1]
    return folder and folder[path2]
end

local RepairEvent = GeneratorR and GeneratorR.RepairEvent
local GenSkillCheckEvent = GeneratorR and GeneratorR.SkillCheckEvent
local GenSkillCheckResult = GeneratorR and GeneratorR.SkillCheckResultEvent
local HealEvent = HealingR and HealingR.HealEvent
local HealSkillCheckEvent = HealingR and HealingR.SkillCheckEvent
local HealSkillCheckResult = HealingR and HealingR.SkillCheckResultEvent
local UnHookEvent = CarryR and CarryR.UnHookEvent
local SelfUnHookEvent = CarryR and CarryR.SelfUnHookEvent
local LeverEvent = ExitR and ExitR.LeverEvent
local PalletDropEvent = PalletR and PalletR.PalletDropEvent
local ParryEvent = ItemsR and ItemsR:FindFirstChild("Parrying Dagger") and ItemsR["Parrying Dagger"].parry

-- helpers

local function getChar()
    return LP.Character
end

local function getHum()
    local char = getChar()
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function getRoot()
    local char = getChar()
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function isKillerChar(c)
    if not c then
        return false
    end
    if c:GetAttribute("TerrorRadius") ~= nil or c:GetAttribute("BloodLust") ~= nil then
        return true
    end
    local p = Players:GetPlayerFromCharacter(c)
    if p and p.Team and p.Team.Name == "Killer" then
        return true
    end
    return false
end

local function findKiller()
    local root = getRoot()
    if not root then
        return nil
    end
    local best, bestD = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP then
            local c = p.Character
            if c and c:FindFirstChildOfClass("Humanoid") and isKillerChar(c) then
                local hrp = c:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local d = (hrp.Position - root.Position).Magnitude
                    if d < bestD then
                        best = hrp
                        bestD = d
                    end
                end
            end
        end
    end
    if best then
        return best, bestD
    end
    return nil
end

local function killerNear(radius)
    local _, d = findKiller()
    return d ~= nil and d <= radius
end

local BUSY_ATTRS = { "isVaulting", "isSliding", "isDroppingPallet", "isRepairing", "isHealing", "isUnhooking", "isExiting" }

local function isBusy()
    local char = getChar()
    if not char then
        return true
    end
    if LP:GetAttribute("IsDead") then
        return true
    end
    if char:GetAttribute("IsCarried") or char:GetAttribute("IsHooked") or char:GetAttribute("Knocked") then
        return true
    end
    local ci = char:FindFirstChild("CheckInterractable")
    if ci then
        for _, a in ipairs(BUSY_ATTRS) do
            if ci:GetAttribute(a) then
                return true
            end
        end
    end
    return false
end

local function nearestTag(tag, maxDist)
    local root = getRoot()
    if not root then
        return nil
    end
    local best, bestD = nil, maxDist
    for _, inst in ipairs(CollectionService:GetTagged(tag)) do
        if inst:IsA("BasePart") and not inst:IsDescendantOf(getChar() or root) then
            local parent = inst.Parent
            if not (parent and CollectionService:HasTag(parent, "Blocked")) then
                local d = (inst.Position - root.Position).Magnitude
                if d <= bestD then
                    best = inst
                    bestD = d
                end
            end
        end
    end
    return best
end

local function equipDagger()
    local char = getChar()
    if not char or char:FindFirstChild("Parrying Dagger") then
        return
    end
    local bp = LP:FindFirstChildOfClass("Backpack")
    local tool = bp and bp:FindFirstChild("Parrying Dagger")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if tool and hum then
        pcall(function()
            hum:EquipTool(tool)
        end)
    end
end

-- insta skillchecks (mode: off / perfect / instant)

local function checkMode()
    local m = F.checkMode
    if m == nil then
        m = F.instaCheck and "perfect" or "off"
    end
    return m
end

if GenSkillCheckEvent and GenSkillCheckResult then
    mkConn(GenSkillCheckEvent.OnClientEvent:Connect(function(token, genPoint)
        if not alive then
            return
        end
        local mode = checkMode()
        if mode == "off" then
            return
        end
        local val = 1
        if mode == "instant" then
            val = tonumber(F.instantValue) or 100
        end
        local gen = genPoint and genPoint.Parent
        local before = gen and gen:GetAttribute("RepairProgress")
        pcall(function()
            GenSkillCheckResult:FireServer("success", val, token, genPoint)
        end)
        if mode == "instant" and gen then
            S.instantTries = (S.instantTries or 0) + 1
            if S.instantTries <= 10 then
                task.delay(1.2, function()
                    pcall(function()
                        local after = gen:GetAttribute("RepairProgress")
                        log(string.format("instant: fired %s, progress %s -> %s", tostring(val), tostring(before), tostring(after)))
                    end)
                end)
            end
        end
    end))
end

if HealSkillCheckEvent and HealSkillCheckResult then
    mkConn(HealSkillCheckEvent.OnClientEvent:Connect(function(token)
        if not alive or checkMode() == "off" then
            return
        end
        pcall(function()
            HealSkillCheckResult:FireServer("success", 1, token)
        end)
    end))
end

-- attack watcher (drives auto parry trigger window)
mkConn(Remotes.AttackEvent.OnClientEvent:Connect(function()
    S.lastAttack = tick()
end))

-- repair state

local function stopRepair()
    if S.repairPoint and RepairEvent then
        pcall(function()
            RepairEvent:FireServer(S.repairPoint, false)
        end)
    end
    S.repairPoint = nil
    local root = getRoot()
    if root then
        pcall(function()
            root.Anchored = false
        end)
    end
end

-- heal state

local function stopHeal()
    if S.healPoint and HealEvent then
        pcall(function()
            HealEvent:FireServer(S.healPoint, false)
        end)
    end
    S.healPoint = nil
end

-- escape state

local function stopExit()
    if S.exitPoint and LeverEvent then
        pcall(function()
            LeverEvent:FireServer(S.exitPoint, false)
        end)
    end
    S.exitPoint = nil
end

-- engine: parry loop

task.spawn(function()
    while alive and S.generation == GEN do
        pcall(function()
            if F.autoParry and ParryEvent then
                local char = getChar()
                local hum = getHum()
                if char and hum and hum.Health > hum.MaxHealth * 0.5 and not isBusy() then
                    local kroot, kdist = findKiller()
                    if kroot and kdist <= (tonumber(F.parryReach) or 16) + 8 and F.parryEquip then
                        equipDagger()
                    end
                    if char:FindFirstChild("Parrying Dagger") then
                        local trigger = false
                        if kroot then
                            local chasingMe = kroot:GetAttribute("ChaseTargetUserId") == LP.UserId
                            local recentAttack = S.lastAttack and (tick() - S.lastAttack) < 0.5
                            local reach = tonumber(F.parryReach) or 16
                            if kdist <= 8 then
                                trigger = true
                            elseif recentAttack and kdist <= reach + 4 then
                                trigger = true
                            elseif chasingMe and kdist <= reach then
                                trigger = true
                            end
                        end
                        if trigger and tick() - (S.lastParry or 0) > 0.35 then
                            S.lastParry = tick()
                            ParryEvent:FireServer()
                        end
                    end
                end
            end
        end)
        task.wait(0.1)
    end
end)

-- engine: repair loop

task.spawn(function()
    while alive and S.generation == GEN do
        pcall(function()
            if F.autoRepair and RepairEvent then
                local char = getChar()
                local hum = getHum()
                local ok = char and hum and hum.Health > hum.MaxHealth * 0.5 and not char:GetAttribute("IsHooked") and not char:GetAttribute("IsCarried") and not LP:GetAttribute("IsDead")
                if ok and killerNear(20) then
                    stopRepair()
                elseif ok then
                    local moving = hum.MoveDirection.Magnitude > 0.1
                    if moving then
                        stopRepair()
                    else
                        local point = nearestTag("GeneratorPoint", 15)
                        if point ~= S.repairPoint then
                            stopRepair()
                            if point then
                                S.repairPoint = point
                                RepairEvent:FireServer(point, true)
                                local root = getRoot()
                                if root then
                                    root.Anchored = true
                                end
                            end
                        end
                    end
                else
                    stopRepair()
                end
            else
                if S.repairPoint then
                    stopRepair()
                end
            end
        end)
        task.wait(0.25)
    end
end)

-- engine: heal loop

task.spawn(function()
    while alive and S.generation == GEN do
        pcall(function()
            if F.autoHeal and HealEvent then
                local char = getChar()
                local hum = getHum()
                local root = getRoot()
                local valid = char and hum and root and hum.Health > 0 and not char:GetAttribute("IsHooked") and not char:GetAttribute("IsCarried") and not LP:GetAttribute("IsDead")
                if S.healPoint then
                    local targetOk = false
                    if valid then
                        if S.healPoint == root then
                            targetOk = hum.Health < hum.MaxHealth and root.AssemblyLinearVelocity.Magnitude < 6 and not S.repairPoint
                        else
                            local targetChar = nil
                            for _, p in ipairs(Players:GetPlayers()) do
                                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") == S.healPoint then
                                    targetChar = p.Character
                                end
                            end
                            if targetChar then
                                local th = targetChar:FindFirstChildOfClass("Humanoid")
                                targetOk = th and th.Health > 0 and S.healPoint:GetAttribute("CanGetHealed") == true
                            end
                        end
                    end
                    if not targetOk then
                        stopHeal()
                    end
                end
                if valid and not S.healPoint and not S.repairPoint then
                    if hum.Health <= hum.MaxHealth * 0.5 and root.AssemblyLinearVelocity.Magnitude < 2 then
                        S.healPoint = root
                        HealEvent:FireServer(root, true)
                    elseif F.healOthers then
                        local best, bestD = nil, 6
                        for _, p in ipairs(Players:GetPlayers()) do
                            local c = p.Character
                            if p ~= LP and c then
                                local hrp = c:FindFirstChild("HumanoidRootPart")
                                local th = c:FindFirstChildOfClass("Humanoid")
                                if hrp and th and th.Health > 0 and hrp:GetAttribute("CanGetHealed") == true then
                                    local d = (hrp.Position - root.Position).Magnitude
                                    if d <= bestD then
                                        best = hrp
                                        bestD = d
                                    end
                                end
                            end
                        end
                        if best then
                            S.healPoint = best
                            HealEvent:FireServer(best, true)
                        end
                    end
                end
            else
                if S.healPoint then
                    stopHeal()
                end
            end
        end)
        task.wait(0.4)
    end
end)

-- engine: unhook loop (others) + self unhook watcher

task.spawn(function()
    while alive and S.generation == GEN do
        pcall(function()
            if F.autoUnhook and UnHookEvent then
                local char = getChar()
                local hum = getHum()
                local ok = char and hum and hum.Health > hum.MaxHealth * 0.5 and not char:GetAttribute("IsHooked") and not char:GetAttribute("IsCarried") and not LP:GetAttribute("IsDead")
                if ok and not isBusy() and not killerNear(14) then
                    local point = nearestTag("UnhookPoint", 7)
                    if point and tick() - (S.lastUnhook or 0) > 3.2 then
                        S.lastUnhook = tick()
                        UnHookEvent:FireServer(point)
                    end
                end
            end
            if F.selfUnhook and SelfUnHookEvent then
                local char = getChar()
                if char and char:GetAttribute("IsHooked") and not char:GetAttribute("IsCarried") then
                    local hookCount = LP:GetAttribute("HookCount") or 0
                    if hookCount < 3 and tick() - (S.hookStamp or 0) > 3.5 then
                        S.hookStamp = tick()
                        SelfUnHookEvent:FireServer()
                    end
                end
                if char and not char:GetAttribute("IsHooked") then
                    S.hookStamp = 0
                end
            end
        end)
        task.wait(0.5)
    end
end)

-- engine: escape loop

task.spawn(function()
    while alive and S.generation == GEN do
        pcall(function()
            if F.autoEscape and LeverEvent then
                local point = nearestTag("ExitPoint", 9)
                if point ~= S.exitPoint then
                    stopExit()
                    if point then
                        S.exitPoint = point
                        LeverEvent:FireServer(point, true)
                    end
                end
            else
                if S.exitPoint then
                    stopExit()
                end
            end
        end)
        task.wait(0.5)
    end
end)

-- engine: pallet drop loop

task.spawn(function()
    while alive and S.generation == GEN do
        pcall(function()
            if F.autoPalletDrop and PalletDropEvent then
                local _, kdist = findKiller()
                if kdist and kdist <= 6 and tick() - (S.lastPallet or 0) > 1 then
                    local point = nearestTag("PalletPoint", 7)
                    if point then
                        S.lastPallet = tick()
                        PalletDropEvent:FireServer(point)
                    end
                end
            end
        end)
        task.wait(0.25)
    end
end)

-- engine: esp

local function espGetOrCreate(inst, color)
    local hl = S.espObjs[inst]
    if not hl or not hl.Parent then
        hl = Instance.new("Highlight")
        hl.Name = "VD_ESP"
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.FillTransparency = 0.85
        hl.OutlineTransparency = 0.25
        hl.Adornee = inst
        hl.Parent = inst
        S.espObjs[inst] = hl
    end
    hl.FillColor = color
    hl.OutlineColor = color
    return hl
end

task.spawn(function()
    while alive and S.generation == GEN do
        pcall(function()
            local wanted = {}
            if F.esp then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LP then
                        local c = p.Character
                        if c and c:FindFirstChildOfClass("Humanoid") then
                            local color
                            if isKillerChar(c) then
                                color = Color3.fromRGB(255, 70, 70)
                            elseif c:GetAttribute("IsHooked") then
                                color = Color3.fromRGB(255, 165, 60)
                            elseif c:GetAttribute("Knocked") or c:GetAttribute("IsCarried") then
                                color = Color3.fromRGB(80, 210, 255)
                            else
                                color = Color3.fromRGB(90, 255, 140)
                            end
                            wanted[c] = color
                        end
                    end
                end
                local map = workspace:FindFirstChild("Map")
                local gens = map and map:FindFirstChild("Generators")
                if gens then
                    for _, g in ipairs(gens:GetChildren()) do
                        wanted[g] = Color3.fromRGB(190, 120, 255)
                    end
                end
                for _, part in ipairs(CollectionService:GetTagged("ExitPoint")) do
                    if part:IsA("BasePart") then
                        wanted[part] = Color3.fromRGB(255, 205, 70)
                    end
                end
            end
            for inst, hl in pairs(S.espObjs) do
                if not wanted[inst] then
                    pcall(function()
                        hl:Destroy()
                    end)
                    S.espObjs[inst] = nil
                end
            end
            for inst, color in pairs(wanted) do
                espGetOrCreate(inst, color)
            end
        end)
        task.wait(0.4)
    end
end)

-- engine: fullbright

local function fbApply()
    if not S.fbSaved then
        S.fbSaved = {
            Ambient = Lighting.Ambient,
            OutdoorAmbient = Lighting.OutdoorAmbient,
            Brightness = Lighting.Brightness,
            ClockTime = Lighting.ClockTime,
            FogEnd = Lighting.FogEnd,
            GlobalShadows = Lighting.GlobalShadows,
            ExposureCompensation = Lighting.ExposureCompensation,
        }
    end
    Lighting.Ambient = Color3.fromRGB(185, 185, 185)
    Lighting.OutdoorAmbient = Color3.fromRGB(185, 185, 185)
    Lighting.Brightness = 2.5
    Lighting.ClockTime = 14
    Lighting.FogEnd = 100000
    Lighting.GlobalShadows = false
end

local function fbRestore()
    if S.fbSaved then
        pcall(function()
            Lighting.Ambient = S.fbSaved.Ambient
            Lighting.OutdoorAmbient = S.fbSaved.OutdoorAmbient
            Lighting.Brightness = S.fbSaved.Brightness
            Lighting.ClockTime = S.fbSaved.ClockTime
            Lighting.FogEnd = S.fbSaved.FogEnd
            Lighting.GlobalShadows = S.fbSaved.GlobalShadows
            Lighting.ExposureCompensation = S.fbSaved.ExposureCompensation
        end)
        S.fbSaved = nil
    end
end

table.insert(S.teardowns, fbRestore)

task.spawn(function()
    while alive and S.generation == GEN do
        pcall(function()
            if F.fullbright then
                fbApply()
            elseif S.fbSaved then
                fbRestore()
            end
        end)
        task.wait(1)
    end
end)

-- engine: speed + noclip

table.insert(S.teardowns, function()
    local char = getChar()
    if char and S.speedSavedSet then
        pcall(function()
            char:SetAttribute("speedboost", S.speedBoostSaved)
        end)
        S.speedSavedSet = false
    end
end)

table.insert(S.teardowns, function()
    for part, col in pairs(S.ncSaved) do
        pcall(function()
            if part.Parent then
                part.CanCollide = col
            end
        end)
    end
    table.clear(S.ncSaved)
end)

task.spawn(function()
    while alive and S.generation == GEN do
        pcall(function()
            local char = getChar()
            if char then
                if F.speed then
                    if not S.speedSavedSet then
                        S.speedBoostSaved = char:GetAttribute("speedboost")
                        S.speedSavedSet = true
                    end
                    local target = (tonumber(F.speedValue) or 22) / 10
                    if char:GetAttribute("speedboost") ~= target then
                        pcall(function()
                            char:SetAttribute("speedboost", target)
                        end)
                    end
                elseif S.speedSavedSet then
                    pcall(function()
                        char:SetAttribute("speedboost", S.speedBoostSaved)
                    end)
                    S.speedSavedSet = false
                end
                if F.noClip then
                    for _, d in ipairs(char:GetDescendants()) do
                        if d:IsA("BasePart") and d.CanCollide then
                            S.ncSaved[d] = d.CanCollide
                            d.CanCollide = false
                        end
                    end
                elseif next(S.ncSaved) then
                    for part, col in pairs(S.ncSaved) do
                        if part.Parent then
                            part.CanCollide = col
                        end
                    end
                    table.clear(S.ncSaved)
                end
            end
        end)
        task.wait(0.2)
    end
end)

-- engine: info feed for UI

S.info = S.info or {}

task.spawn(function()
    while alive and S.generation == GEN do
        pcall(function()
            local info = S.info
            local char = getChar()
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            info.role = LP.Team and LP.Team.Name or "?"
            if hum then
                info.hp = string.format("%d / %d", math.floor(hum.Health), math.floor(hum.MaxHealth))
            else
                info.hp = "-"
            end
            local kroot, kdist = findKiller()
            if kroot then
                local kp = Players:GetPlayerFromCharacter(kroot.Parent)
                info.killer = (kp and kp.Name or "killer") .. string.format("  %.0f", kdist)
            else
                info.killer = "none"
            end
            local map = workspace:FindFirstChild("Map")
            local gens = map and map:FindFirstChild("Generators")
            local sum, cnt, repairing = 0, 0, 0
            if gens then
                for _, g in ipairs(gens:GetChildren()) do
                    local pr = g:GetAttribute("RepairProgress")
                    if pr then
                        sum = sum + pr
                        cnt = cnt + 1
                    end
                    if (g:GetAttribute("PlayersRepairingCount") or 0) > 0 then
                        repairing = repairing + 1
                    end
                end
            end
            info.gens = cnt > 0 and string.format("%.0f%%  (%d gens, %d active)", sum / cnt, cnt, repairing) or "-"
            local states = {}
            if S.repairPoint then
                states[#states + 1] = "repairing"
            end
            if S.healPoint then
                states[#states + 1] = "healing"
            end
            if S.exitPoint then
                states[#states + 1] = "opening gate"
            end
            if char then
                if char:GetAttribute("IsHooked") then
                    states[#states + 1] = "hooked"
                elseif char:GetAttribute("IsCarried") then
                    states[#states + 1] = "carried"
                end
            end
            info.status = #states > 0 and table.concat(states, ", ") or "idle"
        end)
        task.wait(0.5)
    end
end)

-- shutdown

local function shutdown()
    if not alive then
        return
    end
    alive = false
    pcall(stopRepair)
    pcall(stopHeal)
    pcall(stopExit)
    for _, fn in ipairs(S.teardowns) do
        pcall(fn)
    end
    table.clear(S.teardowns)
    pcall(clearConns)
    for inst, hl in pairs(S.espObjs) do
        pcall(function()
            hl:Destroy()
        end)
    end
    table.clear(S.espObjs)
    log("shutdown gen " .. tostring(GEN))
end

S.cleanup = shutdown

-- ui

local function buildUI(parent, ctx)
    ctx = ctx or {}
    local Theme = ctx.Theme or {
        TEXT_MAIN = Color3.fromRGB(240, 242, 245),
        TEXT_MUTED = Color3.fromRGB(137, 143, 153),
        CARD_BG = Color3.fromRGB(27, 28, 34),
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

    parent.BackgroundTransparency = 1
    parent.ZIndex = 106

    local header = Instance.new("TextLabel")
    header.Text = "Violence District"
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
    sub.Text = "auto parry  ·  insta checks  ·  esp  ·  movement"
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

    local function cardTitle(card, text, y)
        local t = Instance.new("TextLabel")
        t.Text = text
        setFont(t, "Bold")
        t.TextSize = 11
        t.TextColor3 = Theme.TEXT_MAIN
        t.Position = UDim2.fromOffset(12, y)
        t.Size = UDim2.new(1, -24, 0, 16)
        t.BackgroundTransparency = 1
        t.TextXAlignment = Enum.TextXAlignment.Left
        t.ZIndex = 108
        t.Parent = card
        return t
    end

    local function makeDropdown(card, y, label, key, options)
        local row = Instance.new("TextButton")
        row.Text = ""
        row.AutoButtonColor = false
        row.BackgroundTransparency = 1
        row.Position = UDim2.fromOffset(10, y)
        row.Size = UDim2.new(1, -20, 0, 24)
        row.ZIndex = 108
        row.Parent = card

        local lbl = Instance.new("TextLabel")
        lbl.Text = label
        setFont(lbl, "Medium")
        lbl.TextSize = 11
        lbl.TextColor3 = Theme.TEXT_MAIN
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.BackgroundTransparency = 1
        lbl.Size = UDim2.new(1, -110, 1, 0)
        lbl.ZIndex = 108
        lbl.Parent = row

        local pill = Instance.new("TextButton")
        pill.AutoButtonColor = false
        setFont(pill, "Bold")
        pill.TextSize = 10
        pill.Size = UDim2.fromOffset(96, 18)
        pill.Position = UDim2.new(1, -96, 0.5, -9)
        pill.ZIndex = 109
        pill.Parent = row
        corner(pill, UDim.new(1, 0))

        local menu
        local function closeMenu()
            if menu then
                menu:Destroy()
                menu = nil
            end
        end

        local function refresh()
            local cur = F[key]
            local on = cur ~= nil and cur ~= "off"
            pill.Text = tostring(cur or "off")
            pill.BackgroundColor3 = on and Theme.NEON_GREEN or Theme.BORDER_DIM
            pill.TextColor3 = on and Color3.fromRGB(8, 14, 11) or Theme.TEXT_MUTED
        end

        local function openMenu()
            if menu then
                closeMenu()
                return
            end
            menu = Instance.new("Frame")
            menu.BackgroundColor3 = Theme.CARD_BG
            menu.Position = UDim2.new(1, -120, 0, 22)
            menu.Size = UDim2.fromOffset(120, #options * 20 + 4)
            menu.ZIndex = 120
            menu.Parent = row
            corner(menu, UDim.new(0, 8))
            addStroke(menu, Theme.BORDER_DIM, 1, 0.15)
            for i, opt in ipairs(options) do
                local ob = Instance.new("TextButton")
                ob.Text = tostring(opt)
                ob.AutoButtonColor = false
                setFont(ob, "Bold")
                ob.TextSize = 10
                ob.TextColor3 = (F[key] == opt) and Theme.NEON_GREEN or Theme.TEXT_MAIN
                ob.BackgroundTransparency = (F[key] == opt) and 0.75 or 1
                ob.Position = UDim2.fromOffset(2, 2 + (i - 1) * 20)
                ob.Size = UDim2.new(1, -4, 0, 20)
                ob.ZIndex = 121
                ob.Parent = menu
                corner(ob, UDim.new(0, 6))
                ob.MouseButton1Click:Connect(function()
                    F[key] = opt
                    if key == "checkMode" then
                        F.instaCheck = (opt ~= "off")
                    end
                    refresh()
                    closeMenu()
                end)
            end
        end

        row.MouseButton1Click:Connect(openMenu)
        pill.MouseButton1Click:Connect(openMenu)
        refresh()
        return refresh
    end

    local function makeToggle(card, y, label, key)
        local row = Instance.new("TextButton")
        row.Text = ""
        row.AutoButtonColor = false
        row.BackgroundTransparency = 1
        row.Position = UDim2.fromOffset(10, y)
        row.Size = UDim2.new(1, -20, 0, 24)
        row.ZIndex = 108
        row.Parent = card

        local lbl = Instance.new("TextLabel")
        lbl.Text = label
        setFont(lbl, "Medium")
        lbl.TextSize = 11
        lbl.TextColor3 = Theme.TEXT_MAIN
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.BackgroundTransparency = 1
        lbl.Size = UDim2.new(1, -50, 1, 0)
        lbl.ZIndex = 108
        lbl.Parent = row

        local track = Instance.new("Frame")
        track.Size = UDim2.fromOffset(34, 18)
        track.Position = UDim2.new(1, -34, 0.5, -9)
        track.BackgroundColor3 = Theme.BORDER_DIM
        track.BorderSizePixel = 0
        track.ZIndex = 108
        track.Parent = row
        corner(track, UDim.new(1, 0))

        local knob = Instance.new("Frame")
        knob.Size = UDim2.fromOffset(12, 12)
        knob.Position = UDim2.fromOffset(3, 3)
        knob.BackgroundColor3 = Theme.TEXT_MUTED
        knob.BorderSizePixel = 0
        knob.ZIndex = 109
        knob.Parent = track
        corner(knob, UDim.new(1, 0))

        local function refresh()
            local on = F[key] == true
            track.BackgroundColor3 = on and Theme.NEON_GREEN or Theme.BORDER_DIM
            knob.BackgroundColor3 = on and Color3.fromRGB(8, 14, 11) or Theme.TEXT_MUTED
            knob.Position = on and UDim2.new(1, -15, 0, 3) or UDim2.fromOffset(3, 3)
        end

        row.MouseButton1Click:Connect(function()
            F[key] = not F[key]
            refresh()
        end)
        refresh()
        return refresh
    end

    local function makeSlider(card, y, label, key, min, max, step)
        local row = Instance.new("Frame")
        row.BackgroundTransparency = 1
        row.Position = UDim2.fromOffset(10, y)
        row.Size = UDim2.new(1, -20, 0, 24)
        row.ZIndex = 108
        row.Parent = card

        local lbl = Instance.new("TextLabel")
        lbl.Text = label
        setFont(lbl, "Medium")
        lbl.TextSize = 11
        lbl.TextColor3 = Theme.TEXT_MAIN
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.BackgroundTransparency = 1
        lbl.Size = UDim2.new(1, -110, 1, 0)
        lbl.ZIndex = 108
        lbl.Parent = row

        local function mkBtn(text, x)
            local b = Instance.new("TextButton")
            b.Text = text
            b.AutoButtonColor = false
            setFont(b, "Bold")
            b.TextSize = 13
            b.TextColor3 = Theme.TEXT_MAIN
            b.BackgroundColor3 = Theme.BORDER_DIM
            b.BorderSizePixel = 0
            b.Size = UDim2.fromOffset(20, 20)
            b.Position = UDim2.new(1, x, 0.5, -10)
            b.ZIndex = 109
            b.Parent = row
            corner(b, UDim.new(0, 6))
            return b
        end

        local minus = mkBtn("-", -96)
        local val = Instance.new("TextLabel")
        val.Text = tostring(F[key])
        setFont(val, "SemiBold")
        val.TextSize = 11
        val.TextColor3 = Theme.NEON_GREEN
        val.BackgroundTransparency = 1
        val.Size = UDim2.fromOffset(34, 20)
        val.Position = UDim2.new(1, -74, 0.5, -10)
        val.ZIndex = 109
        val.Parent = row
        local plus = mkBtn("+", -38)

        local function refresh()
            val.Text = tostring(F[key])
        end

        minus.MouseButton1Click:Connect(function()
            F[key] = math.max(min, (tonumber(F[key]) or min) - step)
            refresh()
        end)
        plus.MouseButton1Click:Connect(function()
            F[key] = math.min(max, (tonumber(F[key]) or min) + step)
            refresh()
        end)
        refresh()
        return refresh
    end

    cardTitle(left, "SURVIVOR AUTOMATION", 10)
    local y = 32
    local rowStep = 27
    local refreshers = {}
    refreshers[#refreshers + 1] = makeDropdown(left, y, "Skillcheck Mode", "checkMode", { "off", "perfect", "instant" })
    y = y + rowStep
    local toggles = {
        { "Auto Parry", "autoParry" },
        { "Parry Equip Assist", "parryEquip" },
        { "Auto Repair", "autoRepair" },
        { "Auto Heal (self)", "autoHeal" },
        { "Heal Others", "healOthers" },
        { "Auto Unhook", "autoUnhook" },
        { "Self Unhook", "selfUnhook" },
        { "Auto Escape (gate)", "autoEscape" },
        { "Auto Pallet Drop", "autoPalletDrop" },
    }
    for _, t in ipairs(toggles) do
        refreshers[#refreshers + 1] = makeToggle(left, y, t[1], t[2])
        y = y + rowStep
    end
    y = y + 4
    refreshers[#refreshers + 1] = makeSlider(left, y, "Parry reach", "parryReach", 8, 24, 2)

    cardTitle(right, "VISUALS", 10)
    y = 32
    refreshers[#refreshers + 1] = makeToggle(right, y, "ESP", "esp")
    y = y + rowStep
    refreshers[#refreshers + 1] = makeToggle(right, y, "Fullbright", "fullbright")
    y = y + rowStep + 8
    cardTitle(right, "MOVEMENT", y)
    y = y + 22
    refreshers[#refreshers + 1] = makeToggle(right, y, "Speed", "speed")
    y = y + rowStep
    refreshers[#refreshers + 1] = makeSlider(right, y, "Speed value", "speedValue", 16, 60, 2)
    y = y + rowStep
    refreshers[#refreshers + 1] = makeToggle(right, y, "NoClip", "noClip")
    y = y + rowStep + 8
    cardTitle(right, "STATUS", y)
    y = y + 22

    local infoRows = {}
    for _, infoKey in ipairs({ "role", "hp", "killer", "gens", "status" }) do
        local lbl = Instance.new("TextLabel")
        lbl.Text = infoKey .. ": -"
        setFont(lbl, "Medium")
        lbl.TextSize = 10
        lbl.TextColor3 = Theme.TEXT_MUTED
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextTruncate = Enum.TextTruncate.AtEnd
        lbl.BackgroundTransparency = 1
        lbl.Position = UDim2.fromOffset(12, y)
        lbl.Size = UDim2.new(1, -24, 0, 14)
        lbl.ZIndex = 108
        lbl.Parent = right
        infoRows[infoKey] = lbl
        y = y + 16
    end

    task.spawn(function()
        while parent.Parent and alive do
            pcall(function()
                local info = S.info
                if infoRows.role then
                    infoRows.role.Text = "role:  " .. tostring(info.role or "?")
                end
                infoRows.hp.Text = "health:  " .. tostring(info.hp or "-")
                infoRows.killer.Text = "killer:  " .. tostring(info.killer or "none")
                infoRows.gens.Text = "gens:  " .. tostring(info.gens or "-")
                infoRows.status.Text = "status:  " .. tostring(info.status or "idle")
            end)
            task.wait(0.5)
        end
    end)

    notify("Violence District loaded", "check")
end

getgenv().GrowGame = {
    Id = "violencedistrict",
    Name = "Violence District",
    Version = "1.0.1",
    UI = buildUI,
    Stop = function()
        pcall(shutdown)
    end,
}

log("loaded gen " .. tostring(GEN) .. " (" .. tostring(LP.Name) .. ")")
