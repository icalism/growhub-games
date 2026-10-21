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

-- VIM for simulating Space press (perfect mode visual)
local VIM = game:GetService("VirtualInputManager")

-- get skillcheck UI refs (cached once)
local function getSkillCheckUI()
    local pg = LP:FindFirstChild("PlayerGui")
    local scg = pg and pg:FindFirstChild("SkillCheckPromptGui")
    local check = scg and scg:FindFirstChild("Check")
    if not check then return nil, nil, nil end
    return check, check:FindFirstChild("Line"), check:FindFirstChild("Goal")
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
        if mode == "instant" then
            -- instant: fire result directly, skip visual
            task.delay(0.15, function()
                if not alive then return end
                pcall(function()
                    GenSkillCheckResult:FireServer("success", 1, token, genPoint)
                end)
            end)
        else
            -- perfect: wait for needle to reach perfect zone, then press Space
            -- so the game's own handler stops the needle visually at the right spot
            task.spawn(function()
                local check, line, goal = getSkillCheckUI()
                if not check or not line or not goal then
                    task.wait(0.6)
                    pcall(function() GenSkillCheckResult:FireServer("success", 1, token, genPoint) end)
                    return
                end
                -- wait for game to show the check (0.5s internal delay)
                local waited = 0
                while waited < 1.5 and not check.Visible do
                    task.wait(0.03)
                    waited = waited + 0.03
                end
                if not check.Visible or not alive then return end
                -- poll until needle enters perfect zone
                -- perfect zone: [102 + Goal.Rotation, 116 + Goal.Rotation]
                local RunSvc = game:GetService("RunService")
                local done = false
                local conn
                conn = RunSvc.Heartbeat:Connect(function()
                    if done or not alive then
                        if conn then conn:Disconnect() end
                        return
                    end
                    local lr = line.Rotation
                    local gr = goal.Rotation
                    if lr >= 102 + gr and lr <= 116 + gr then
                        done = true
                        conn:Disconnect()
                        pcall(function()
                            VIM:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                            task.delay(0.05, function()
                                VIM:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                            end)
                        end)
                    end
                end)
                -- safety timeout
                task.delay(2.5, function()
                    if not done and alive then
                        done = true
                        if conn then pcall(function() conn:Disconnect() end) end
                        pcall(function() GenSkillCheckResult:FireServer("success", 1, token, genPoint) end)
                    end
                end)
            end)
        end
    end))
end

if HealSkillCheckEvent and HealSkillCheckResult then
    mkConn(HealSkillCheckEvent.OnClientEvent:Connect(function(token)
        if not alive then
            return
        end
        local mode = checkMode()
        if mode == "off" then
            return
        end
        task.delay(mode == "instant" and 0.15 or 0.45, function()
            if not alive then
                return
            end
            pcall(function()
                HealSkillCheckResult:FireServer("success", 1, token)
            end)
        end)
    end))
end

-- attack watcher (drives auto parry trigger window)
mkConn(Remotes.AttackEvent.OnClientEvent:Connect(function()
    S.lastAttack = tick()
end))

-- repair state

local function getProgressFrame()
    local pg = LP:FindFirstChild("PlayerGui")
    local ppg = pg and pg:FindFirstChild("ProgressPromptGui")
    return ppg and ppg:FindFirstChild("Frame")
end

local function startRepairUI()
    local char = getChar()
    local ci = char and char:FindFirstChild("CheckInterractable")
    if ci then
        pcall(function() ci:SetAttribute("isRepairing", true) end)
    end
    local f = getProgressFrame()
    if f then
        pcall(function() f.Visible = true end)
    end
end

local function stopRepairUI()
    local char = getChar()
    local ci = char and char:FindFirstChild("CheckInterractable")
    if ci then
        pcall(function() ci:SetAttribute("isRepairing", false) end)
    end
    local f = getProgressFrame()
    if f then
        pcall(function() f.Visible = false end)
    end
end

local function stopRepair()
    if S.repairPoint and RepairEvent then
        pcall(function()
            RepairEvent:FireServer(S.repairPoint, false)
        end)
    end
    S.repairPoint = nil
    S.repairGen = nil
    S.repairStopAt = tick()
    stopRepairUI()
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

-- repair targeting: lock onto one generator. chasing individual GeneratorPoint
-- identity made sibling points on the same generator flip-flop, and the churn
-- made the server drop the repair (progress froze, PlayersRepairingCount back to 0).

local function genUsable(gen)
    if not gen or not gen.Parent then
        return false
    end
    if gen:GetAttribute("Completed") or gen:GetAttribute("Regressing") or gen:GetAttribute("ProgressPaused") then
        return false
    end
    return true
end

local function pickRepairPoint(maxDist)
    local root = getRoot()
    if not root then
        return nil
    end
    local best, bestScore = nil, -math.huge
    local seen = {}
    for _, inst in ipairs(CollectionService:GetTagged("GeneratorPoint")) do
        local gen = inst:IsA("BasePart") and inst.Parent
        if gen and not seen[gen] and genUsable(gen) and not CollectionService:HasTag(gen, "Blocked") then
            local d = (inst.Position - root.Position).Magnitude
            if d <= maxDist then
                seen[gen] = true
                local score = (tonumber(gen:GetAttribute("RepairProgress")) or 0) * 0.5 - d
                if score > bestScore then
                    best, bestScore = inst, score
                end
            end
        end
    end
    return best
end

-- engine: repair loop

task.spawn(function()
    while alive and S.generation == GEN do
        pcall(function()
            if (F.autoRepair or checkMode() == "instant") and RepairEvent then
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
                        local root = getRoot()
                        local rp = S.repairPoint
                        if rp then
                            local stale = not rp.Parent or not genUsable(rp.Parent)
                                or (root and (rp.Position - root.Position).Magnitude > 16)
                            if stale then
                                stopRepair()
                                rp = nil
                            end
                        end
                        if not rp and (tick() - (S.repairStopAt or 0) > 0.4) then
                            local point = pickRepairPoint(15)
                            if point then
                                S.repairPoint = point
                                S.repairGen = point.Parent
                                RepairEvent:FireServer(point, true)
                                startRepairUI()
                            end
                        end
                        -- keep native UI flags alive while repairing (game resets
                        -- isRepairing after each skillcheck result)
                        if S.repairPoint then
                            startRepairUI()
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
                    local point = nearestTag("HookPoint", 7)
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
                local point = nearestTag("Exit", 9)
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
table.insert(S.teardowns, stopRepairUI)

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
                info.killer = (kp and kp.DisplayName or "killer") .. string.format(" · %.0f st", kdist)
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
            info.gens = cnt > 0 and string.format("%.0f%% · %d gens, %d active", sum / cnt, cnt, repairing) or "none"
            local states = {}
            if S.repairPoint then
                local pr = S.repairGen and tonumber(S.repairGen:GetAttribute("RepairProgress"))
                states[#states + 1] = pr and string.format("repairing %.0f%%", pr) or "repairing"
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
    local ui = ctx.ui
    if not ui then
        -- hub lama tanpa kit komponen
        local l = Instance.new("TextLabel")
        l.Text = "Update GrowHub to use this panel (script is still running)."
        l.TextColor3 = Color3.fromRGB(137, 143, 153)
        l.BackgroundTransparency = 1
        l.Size = UDim2.new(1, 0, 0, 24)
        l.Parent = parent
        return
    end
    local Theme = ctx.Theme

    local left, right = ui.columns()
    local refs = {}

    -- kolom kiri: automation
    local sk = ui.section(left, "zap", "SKILLCHECK & PARRY")
    -- label Title Case, nilai internal tetap lowercase
    local MODES = { Off = "off", Perfect = "perfect", Instant = "instant" }
    local MODE_LABEL = { off = "Off", perfect = "Perfect", instant = "Instant" }
    refs.checkMode = ui.select(sk, "Skillcheck Mode", { "Off", "Perfect", "Instant" },
        function() return MODE_LABEL[F.checkMode] or "Off" end,
        function(v)
            F.checkMode = MODES[v] or "off"
            F.instaCheck = F.checkMode ~= "off"
        end)
    refs.autoParry = ui.toggle(sk, "Auto Parry", F.autoParry, function(v) F.autoParry = v end)
    refs.parryEquip = ui.toggle(sk, "Parry Equip Assist", F.parryEquip, function(v) F.parryEquip = v end)
    refs.parryReach = ui.slider(sk, "Parry Reach", 8, 24, F.parryReach, " st", function(v) F.parryReach = v end)

    local tasks = ui.section(left, "wrench", "AUTO TASKS")
    for _, t in ipairs({
        { "Auto Repair", "autoRepair" },
        { "Auto Heal (self)", "autoHeal" },
        { "Heal Others", "healOthers" },
        { "Auto Unhook", "autoUnhook" },
        { "Self Unhook", "selfUnhook" },
        { "Auto Escape (gate)", "autoEscape" },
        { "Auto Pallet Drop", "autoPalletDrop" },
    }) do
        local key = t[2]
        refs[key] = ui.toggle(tasks, t[1], F[key], function(v) F[key] = v end)
    end

    -- kolom kanan: status live, visuals, movement
    local st = ui.section(right, "activity", "MATCH STATUS")
    local sRole = ui.stat(st, "shield", "Role")
    local sHp = ui.stat(st, "heart", "Health")
    local sKiller = ui.stat(st, "skull", "Killer")
    local sGens = ui.stat(st, "zap", "Generators")
    local sDoing = ui.stat(st, "wrench", "Doing")

    local vis = ui.section(right, "eye", "VISUALS")
    refs.esp = ui.toggle(vis, "Player ESP", F.esp, function(v) F.esp = v end)
    refs.fullbright = ui.toggle(vis, "Fullbright", F.fullbright, function(v) F.fullbright = v end)

    local mv = ui.section(right, "move", "MOVEMENT")
    refs.speed = ui.toggle(mv, "Speed Boost", F.speed, function(v) F.speed = v end)
    refs.speedValue = ui.slider(mv, "Speed", 16, 60, F.speedValue, " sps", function(v) F.speedValue = v end)
    refs.noClip = ui.toggle(mv, "NoClip", F.noClip, function(v) F.noClip = v end)

    S.ui = refs

    task.spawn(function()
        while parent.Parent and alive do
            pcall(function()
                local info = S.info
                sRole(info.role or "?")
                local h, mh = string.match(tostring(info.hp), "(%d+) / (%d+)")
                local low = h and tonumber(h) <= tonumber(mh) * 0.35
                sHp(info.hp or "-", low and Theme.ACCENT_RED or Theme.TEXT_MAIN)
                local k = tostring(info.killer or "none")
                sKiller(k, k ~= "none" and Theme.ACCENT_RED or Theme.TEXT_MUTED)
                sGens(info.gens or "none", info.gens and info.gens ~= "none" and Theme.TEXT_MAIN or Theme.TEXT_MUTED)
                local d = tostring(info.status or "idle")
                sDoing(d, d ~= "idle" and Theme.NEON_GREEN or Theme.TEXT_MUTED)
            end)
            task.wait(0.5)
        end
    end)
end

getgenv().GrowGame = {
    Id = "violencedistrict",
    Name = "Violence District",
    Version = "1.4.1",
    UI = buildUI,
    Stop = function()
        pcall(shutdown)
    end,
}

log("loaded gen " .. tostring(GEN) .. " (" .. tostring(LP.Name) .. ")")
