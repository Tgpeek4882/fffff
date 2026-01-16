local cloneref = cloneref or function(o) return o end
local Players = cloneref(game:GetService("Players"))
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local RunService = cloneref(game:GetService("RunService"))
local lp = Players.LocalPlayer
local username = lp.Name
local Camera = workspace.CurrentCamera
local UserInputService = cloneref(game:GetService("UserInputService"))
local TweenService = cloneref(game:GetService("TweenService"))
local SoundService = cloneref(game:GetService("SoundService"))
local VIM = cloneref(game:GetService("VirtualInputManager"))
local Mouse = lp:GetMouse()

local Toggles = {} 
local character
local hum
local root

local chaseSound
local activeTween

local function uCR(char)
    character = char
    root = character:WaitForChild("HumanoidRootPart", 5)
    hum = character:WaitForChild("Humanoid", 5)
    if chaseSound then
       chaseSound:Stop()
	chaseSound:Destroy()
	chaseSound = nil
    end
end

uCR(lp.Character or lp.CharacterAdded:Wait())
lp.CharacterAdded:Connect(function(newChar)
    uCR(newChar)
end)

getgenv().settings = {
    AI = {
        DetectionRange = 300,
        PathUpdateRate = 0.1,
        AttackDistance = 10,
        RunDistance = 50,
        RepairDistance = 5,
        SpinDistance = 15
    },
    Pathfinding = {
        AgentCanJump = false,
        AgentHeight = 5,
        WaypointSpacing = 4,
        Costs = {
             Water = 100,
             Plastic = 1,
             SmoothPlastic = 0.5
        }
    },
    Toggles = {
        Wallhug = false,
        Debug = false
    },
    Methods = {
        Farm = true, 
        Run = true,
        Loop = false 
    }
}

local blacklist = {
    [1834326225] = true,
    [396125889] = true,
    [98750775] = true,
    [3808251668] = true,
    [160224394] = true,
    [49706510] = true,
    [115342213] = true,
    [1806115340] = true,
    [1260363902] = true,
    [64656085] = true,
    [271036866] = true,
    [3137137279] = true
}
local testers = {"Tgpeek1", "Technique12_12", "urboyfiePoP", "Bva_Back"}
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/azurelw/azurehub/refs/heads/main/main.lua"))()

local function getTag(name)
    if getgenv().PREMIUM_KEY == true then
        return "[ PREMIUM ]"
    end
    return "[ FREEMIUM ]"
end

if blacklist[lp.UserId] then
    lp:Kick("Exploiting")
    return
end

local gid = 8818124
local bannedRanks = {
    ["contributors"] = true,
    ["Smiling Friends"] = true,
    ["rick"] = true
}

local success, rankName = pcall(function()
    return lp:GetRoleInGroup(gid)
end)

if success and rankName then
    if bannedRanks[rankName] then
        lp:Kick("Exploiting")
        return 
    end
else
    warn("[AzureHub] Failed to fetch group rank (HTTP Error), continuing...")
end

print("Loaded!\nAzureHub By Cat\nDiscord: https://discord.gg/QmvpbPdw9J")

WindUI:SetNotificationLower(true)
local Window = WindUI:CreateWindow({
    Title = "Azure Hub | Violence District ".. getTag(lp.Name),
    Author = "discord.gg/QmvpbPdw9J",
    Folder = "ViolenceDistrictHub",
    Size = UDim2.fromOffset(500, 300),
    Theme = "Dark",
    User = {
        Enabled = false,
        Anonymous = false
    },
    Transparent = true,
    SideBarWidth = 220,
    ScrollBarEnabled = true
})
Window:SetToggleKey(Enum.KeyCode.K)

Window:EditOpenButton({
    Title = "Open Azure Hub " .. getTag(lp.Name),
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2,
    OnlyMobile = true,
    Enabled = true,
    Draggable = true,
})
if not game.UserInputService.TouchEnabled then WindUI:Notify({ Title = "Azure Hub", Content = "Use 'K' Button To Toggle UI.", Icon = "info", Duration = 3 }) end

Window:CreateTopbarButton("theme-switcher", "moon", function()
    WindUI:SetTheme(WindUI:GetCurrentTheme() == "Dark" and "Light" or "Dark")
    WindUI:Notify({
        Title = "Theme Changed",
        Content = "Current theme: "..WindUI:GetCurrentTheme(),
        Duration = 2
    })
end, 990)

local Logs = Window:Tab({ Title = "|  Update Logs", Icon = "scroll-text" })
Window:Divider()

local Tabs = {
    Features = Window:Section({ Title = "Features", Opened = true }),
    Utilities = Window:Section({ Title = "Utilities", Opened = true })
}

local TabHandles = {
Universal = Tabs.Features:Tab({ Title = "|  Universal", Icon = "orbit" }),
Killer = Tabs.Features:Tab({ Title = "|  Killer", Icon = "slice" }),
Survivor = Tabs.Features:Tab({ Title = "|  Survivor", Icon = "user" }),
Esp = Tabs.Features:Tab({ Title = "|  ESP", Icon = "eye" }),
Player = Tabs.Features:Tab({ Title = "|  Player", Icon = "users-round" }),
Misc = Tabs.Features:Tab({ Title = "|  Misc", Icon = "layout-grid" }),
Config = Tabs.Utilities:Tab({ Title = "|  Configuration", Icon = "settings" })
}

local updparagraph = Logs:Paragraph({
    Title = "Update Logs",
    Desc = "08.01.26\n[+] Auto Play (AI, BETA)\n[+] Auto Run (BETA)\n[+] Auto Farm (BETA)\n[+] Auto Loop (BETA)\n[+] Wall Hug\n[+] Version Checker (In-Built)\n\n07.01.26\n[+] Infinite Lunge (Premium)\n[+] Hook Farm (Screws Farm)\n[+] Auto Aim Charged Spear (Veil, Works)\n[+] Auto Aim Spear (Veil, Works)\n[+] Expand Hitboxes (Universal>Fun)\n[+] No Fall\n[/] Several Bug Fixes (Damage Aura, etc.)\n[/] Improved Things\n[/] Rewrited Code\n\n02.01.26\n[+] Veil (Infinite Abilities, Untested)\n[-] Jeff (Infinite Abilities, Patched)\n[/] Auto Parry Bug Fixes\n[/] More PC Support Features\n\n27.12.25\n[+] FOV Radius\n[/] Improved Invisibility\n[/] Improved Perfect Skill Checks\n\n24.12.25\n[/] Reverted Auto Aim Veil\n[/] Improved Auto Parry\n[/] Heavily Optimized Script\n[/] Optimized Auto Drop Pallets\n[/] Fixed ESP Not Working On Rooftop\n\n23.12.25\n[+] Invisibility\n[+] Auto Perfect Generator\n[+] Auto Perfect Heal\n[+] Potato Graphics (Boost FPS)\n[/] Improve Auto Parry (Works now, slightly improved)\n[/] Improve Auto Aim Veil (Still need to test, unstable)\n[/] ESP: Repaired Gens Highlights Green\n[/] Fix WalkSpeed Changer\n[/] Fix Hitbox Expander\n[/] Unlock FPS (built-in)\n[/] Fixed Lot Of Bugs (ex. script not loading)\n\n20.12.25\n[+] Auto Presents\n[+] ESP: Presents\n[/] Updated To Latest Data\n[/] Fixed New Detections\n[/] Fixed Lot Of Bugs\n\n18.12.25\n[+] Expand Killer Hitboxes (flashlight)\n[/] Improved Auto Attack (revolver)\n[/] Fixed Some Bugs (not desync)\n\n16.12.25\n[/] Fixed Shooting Takes Time\n[-] Expand Survivor Hitboxes (Detected)\n\n12.12.25\nUniversal Tab:\n[+] Desync\n[+] Desync Options\n- Hitbox Improving makes your server-side visualizer sync faster and move forward.\n- Fake Position makes everyone see you at the place you activated Desync.\n\n30.11.25\n[/] Updated To Latest Data\n[-] Grab Nearest Player (Detected)\n[-] Carry Nearest Player (Detected)\n\n14.11.25\n[-] ESP: Pumpkins\n\n8.10.25\n[+] Damage Aura\nDefense:\n[+] Grab Nearest Player (Premium)\n[+] Carry Nearest Player (Premium)\n\n31.10.25\n[+] Updated To Latest Data\n[+] Auto Drop Pallete\n[+] Auto Aim Spear (Veil)\n[+] Remove Veil Clothings\n[+] ESP: Pumpkins\n[/] Bug Fixes\n\n24.09.25\n[+] Hit Sound\n[+] Chase Theme\n[+] In-Built Auto Dodge Slash\n[+] In-Built Fix Carry Bug\n\n23.09.25\n[+] God Mode\n[-] No Damage Patched\n\n3.09.25\n[+] Violence District\n[+] Premium Features",
    Locked = false,
    Buttons = {
        {
            Icon = "clipboard",
            Title = "Discord Server",
            Callback = function() setclipboard("https://discord.gg/QmvpbPdw9J") WindUI:Notify({ Title = "Discord Server", Content = "Link Copied!", Icon = "info", Duration = 2 }) end,
        }
    }
})

local InvisibilityToggle = false
local AutoEventToggle = false
local AntiFlashlight = false
local Autoshoot = false
local Autoparry = false
local facingLoop = false
local selectedTarget = {}
local AntiGFail = false
local AntiHFail = false
local GodmodeToggle = false
local AntislowToggle = false
local ExpandHitboxesToggle = false
local HitboxesVisibleToggle = false
local InfThingsToggle = false
local chasetheme = "Default"
local noCdEnabled = false
local RemoveClothingsToggle = false
local AutoAimNormalToggle = false
local AutoAimChargedToggle = false
local AutoDropToggle = false
local AutoDropSetToggle = false
local DamageAura = false
local DesyncType = "Hitbox Improving"
local Desync = false
local ParryDistance = 10
local HitboxesRadius = 10
local HookFarmToggle = false
local HookTimes = 5
local NoFallToggle = false
local FallRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Mechanics"):WaitForChild("Fall")

local WalkToggle = false
local currentSpeed = 28
local Noclip = nil
local Clip = nil
local NoclipToggle = false
local selectedESPTypes = {}
local ESPHighlight = false
local ESPTracers = false
local ESPNames = false
local ESPBoxes = false
local ESPStuds = false
local ESPObjects = {}
local esp = {}
local tracers = {}
local boxes = {}
local names = {}
local studs = {}
local DrawingAvailable = (type(Drawing) == "table" or type(Drawing) == "userdata")

local targetanims = {
    [139369275981139] = true,
    [111920872708571] = true,
    [78935059863801] = true,
    [78432063483146] = true,
    [74968262036854] = true,
    [132817836308238] = true,
    [133963973694098] = true,
    [98163597193511] = true,
    [111920872708571] = true,
    [106871536134254] = true,
    [82666958311998] = true,
}

local toggles = {
    JasonPursuit = false,
    JasonMist = false,
    StalkerEvolve = false,
    StalkerStage = false,
    Masked = false
}

local function getKiller()
    local weapon = character:FindFirstChild("Weapon")
    local rightArm = weapon and weapon:FindFirstChild("Right Arm")
    
    if character:FindFirstChild("spearmanager") then
        return "Veil"
    end

    if rightArm and rightArm:FindFirstChild("Machete") then
        if rightArm and rightArm.Machete:FindFirstChild("pCube4_knife_0") then
            return "Jeff"
        else
            return "Jason"
        end

    elseif rightArm and rightArm:FindFirstChild("Knife") then
        return "Stalker"

    elseif weapon and weapon:FindFirstChild("Chainsaw") then
        return "Masked"
    end

    return nil
end

local function hookButton(btn)
    btn.MouseButton1Down:Connect(function()
        local killer = getKiller()
        if not killer then return end
        
        if btn.Name == "attack" and noCdEnabled then
            game.ReplicatedStorage.Remotes.Attacks.BasicAttack:FireServer()
        end
        
        if killer == "Jason" then
            if btn.Name == "move1" then
                toggles.JasonPursuit = not toggles.JasonPursuit
                game.ReplicatedStorage.Remotes.Killers.Jason.Pursuit:FireServer(toggles.JasonPursuit)
                if toggles.JasonPursuit then
                    local hum = (lp.Character or lp.CharacterAdded:Wait()):WaitForChild("Humanoid")
                    local anim = Instance.new("Animation")
                    anim.AnimationId = "rbxassetid://125224839697689"
                    hum:LoadAnimation(anim):Play()
                end
            elseif btn.Name == "move2" then
                toggles.JasonMist = not toggles.JasonMist
                game.ReplicatedStorage.Remotes.Killers.Jason.LakeMist:FireServer(toggles.JasonMist)
            end

        elseif killer == "Veil" then
            if btn.Name == "move1" or btn.Name == "move2" then
            local lookDirection = Camera.CFrame.LookVector
            local args = {
              lookDirection,
              5.290782451629639
            }
            ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Killers"):WaitForChild("Veil"):WaitForChild("Spearthrow"):FireServer(unpack(args))
            end

        elseif killer == "Stalker" then
            if btn.Name == "move1" then
                toggles.StalkerEvolve = not toggles.StalkerEvolve
                game.ReplicatedStorage.Remotes.Killers.Stalker.EvolveStage:FireServer(toggles.StalkerStage and 2 or false)
            elseif btn.Name == "move2" then
                toggles.StalkerStage = not toggles.StalkerStage
            end

        elseif killer == "Masked" then
            if btn.Name == "move1" then
                if toggles.Masked then
                game.ReplicatedStorage.Remotes.Killers.Masked.Deactivatepower:FireServer()
                    toggles.Masked = false
                    task.wait(2)
                end
                game.ReplicatedStorage.Remotes.Killers.Masked.Activatepower:FireServer(chosenMapped)
                toggles.Masked = true
            end
        end
    end)
end

local function isPlayerObject(obj)
    local child = obj:FindFirstChild("Highlight-forsurvivor")
    return child and child:IsA("LocalScript")
end

local function isKillerObject(obj)
    local killer1 = obj:FindFirstChild("Killerost")
    local killer2 = obj:FindFirstChild("Lookscriptkiller")
    return (killer1 and killer1:IsA("LocalScript")) or (killer2 and killer2:IsA("LocalScript"))
end

local function contains(tbl, val)
    if not tbl or type(tbl) ~= "table" then return false end
    for _, v in ipairs(tbl) do
        if v == val then return true end
    end
    return false
end

local function getObjType(obj)
    if not obj then return nil end
    if obj:FindFirstChild("Highlight-forsurvivor") then return "Players" end
    if obj:FindFirstChild("Killerost") or obj:FindFirstChild("Lookscriptkiller") then return "Killers", obj end
    if obj.Name == "Generator" or (obj.Parent and obj.Parent.Name == "Gens") then 
        return "Generators"
    end
    if obj.Parent and obj.Parent.Name == "Window" and obj.Parent.Parent and obj.Parent.Parent.Name == "Vaults" then
        return "Windows"
    end
    if string.find(obj.Name, "GiftHandle") and obj.Parent then return "Presents", obj.Parent end
    return nil
end

local function passesFilter(obj)
    local t = getObjType(obj)
    return t and contains(selectedESPTypes, t)
end

local function getObjColor(obj)
    local t = getObjType(obj)
    if t == "Killers" then return Color3.fromRGB(255, 0, 0) end
    if t == "Generators" then
        local foundPoint = false
        for _, child in ipairs(obj:GetChildren()) do
            if string.find(child.Name, "GeneratorPoint") then
                foundPoint = true
                break
            end
        end
        if not foundPoint then
            return Color3.fromRGB(0, 255, 0)
        end
        return Color3.fromRGB(255, 255, 0)
    end
    if t == "Windows" then return Color3.fromRGB(128, 0, 128) end
    if t == "Presents" then return Color3.fromRGB(1, 50, 32) end
    return Color3.fromRGB(0, 255, 0)
end

local function getRootPosition(target)
    if target:IsA("BasePart") then 
        return target.Position 
    end
    
    if target:IsA("Model") then
        if target.PrimaryPart then return target.PrimaryPart.Position end
        
        local root = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChild("VisibleParts")
        if root and root:IsA("BasePart") then return root.Position end
        
        return target:GetPivot().Position
    end
    
    return Vector3.new(0, 0, 0)
end

local function ensureHighlight(obj)
    if not ESPHighlight then
        if esp[obj] and esp[obj].highlight then
            esp[obj].highlight:Destroy()
            esp[obj].highlight = nil
        end
        return
    end
    
    if not esp[obj].highlight then
        local h = Instance.new("Highlight")
        h.Adornee = obj
        h.FillTransparency = 0.5
        h.OutlineTransparency = 0
        h.FillColor = getObjColor(obj)
        h.OutlineColor = Color3.new(1, 1, 1)
        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        h.Parent = obj
        esp[obj].highlight = h
    end
end

local function ensureBillboard(obj)
    if not (ESPNames or ESPStuds) then
        if esp[obj].billboard then
            esp[obj].billboard:Destroy()
            esp[obj].billboard = nil
        end
        return
    end

    if not esp[obj].billboard then
        local head = obj:FindFirstChild("Head") or obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildWhichIsA("BasePart")
        if not head then return end

        local b = Instance.new("BillboardGui")
        b.Name = "roblox"
        b.Size = UDim2.new(0, 200, 0, 50)
        b.Adornee = head
        b.AlwaysOnTop = true
        b.MaxDistance = 5000
        b.Parent = obj
        
        local n = Instance.new("TextLabel")
        n.Name = "MainLabel"
        n.Parent = b
        n.BackgroundTransparency = 1
        n.Size = UDim2.new(1, 0, 1, 0)
        n.Text = ""
        n.Font = Enum.Font.SourceSansBold
        n.TextSize = 14
        n.TextStrokeTransparency = 0
        n.RichText = true

        esp[obj].billboard = b
        esp[obj].nameLabel = n
        esp[obj].studsLabel = nil 
    end
end

local function ensureTracer(obj)
    if not ESPTracers then
        if tracers[obj] then tracers[obj]:Remove() tracers[obj] = nil end
        return
    end
    
    if not tracers[obj] then
        local L = Drawing.new("Line")
        L.Thickness = 1
        L.Transparency = 1
        tracers[obj] = L
    end
end

local function ensureBox(obj)
    if not ESPBoxes then
        if boxes[obj] then
            for _, l in pairs(boxes[obj]) do l:Remove() end
            boxes[obj] = nil
        end
        return
    end

    if not boxes[obj] then
        boxes[obj] = {
            tl = Drawing.new("Line"),
            tr = Drawing.new("Line"),
            bl = Drawing.new("Line"),
            br = Drawing.new("Line")
        }
        for _, line in pairs(boxes[obj]) do
            line.Thickness = 1
            line.Transparency = 1
        end
    end
end

local function ensureAllFor(obj)
    if not esp[obj] then esp[obj] = {} end
    
    ensureHighlight(obj)
    ensureBillboard(obj)
    ensureTracer(obj)
    ensureBox(obj)
end

local function removeESP(obj)
    local d = esp[obj]
    if d then
        if d.highlight then pcall(function() d.highlight:Destroy() end) end
        if d.billboard then pcall(function() d.billboard:Destroy() end) end
        esp[obj] = nil
    end
    if tracers[obj] then pcall(function() tracers[obj]:Remove() end) tracers[obj] = nil end
    if boxes[obj] then
        for _, l in pairs(boxes[obj]) do pcall(function() l:Remove() end) end
        boxes[obj] = nil
    end
end

local lR, rI = 0, 1.5
local rootCache = {}
RunService.Heartbeat:Connect(function()
    local now = tick()
    if now -  lR > rI then
        lR = now
        local map = workspace:FindFirstChild("Map")
        
        for _, obj in ipairs(workspace:GetChildren()) do
            if obj.Name ~= "Map" and obj ~= lp.Character and passesFilter(obj) then
                ensureAllFor(obj)
            end
        end

        if map then
            for _, obj in ipairs(map:GetChildren()) do
                if passesFilter(obj) then
                    ensureAllFor(obj)
                end
            end
            
            local possible = {"Gens", "Rooftop", "Nature"}
            for _, n in ipairs(possible) do
                local f = map:FindFirstChild(n, true)
                if f then
                    for _, o in ipairs(f:GetChildren()) do
                        if o ~= lp.Character and passesFilter(o) then ensureAllFor(o) end
                    end
                end
            end

            for _, child in ipairs(map:GetChildren()) do
                if child.Name:lower():find("chris") then
                    local gifts = child:FindFirstChildOfClass("Folder") or child
                    for _, g in ipairs(gifts:GetChildren()) do
                        if g.Name:lower():find("gift") or g:FindFirstChild("GiftHandle") then
                            local h = g:FindFirstChild("GiftHandle") or g
                            if passesFilter(h) then ensureAllFor(h) end
                        end
                    end
                end
            end
        end
    end 
    
    for obj, data in pairs(esp) do
        local color = getObjColor(obj)
        
        if not obj or not obj.Parent or not passesFilter(obj) then
            removeESP(obj)
            rootCache[obj] = nil
            continue
        end

        local worldPos = getRootPosition(obj)
        local screenPos, onScreen = Camera:WorldToViewportPoint(worldPos)
        local isVisible = onScreen and screenPos.Z > 0

        if data.billboard then
            local active = isVisible and (ESPNames or ESPStuds)
            data.billboard.Enabled = active
            
            if active then
                data.billboard.Adornee = obj:IsA("BasePart") and obj or obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart
                data.billboard.AlwaysOnTop = true
                data.billboard.Size = UDim2.new(0, 200, 0, 50)
                data.billboard.StudsOffset = Vector3.new(0, 3, 0)

                local targetLabel = data.nameLabel or data.billboard:FindFirstChildOfClass("TextLabel")
                if targetLabel and root then
                    targetLabel.Visible = true
                    targetLabel.Size = UDim2.new(1, 0, 1, 0)
                    targetLabel.BackgroundTransparency = 1
                    
                    local dist = (Camera.CFrame.Position - worldPos).Magnitude
                    local name = (obj.Name == "GiftHandle") and "Present" or obj.Name
                    
                    if ESPNames and ESPStuds then
                        targetLabel.Text = name .. " (" .. string.format("%.0fm", dist) .. ")"
                    elseif ESPNames then
                        targetLabel.Text = name
                    elseif ESPStuds then
                        targetLabel.Text = string.format("%.0fm", dist)
                    end
                    targetLabel.TextColor3 = color
                end
            end
        end

        if tracers[obj] then
            tracers[obj].Visible = isVisible and ESPTracers
            if tracers[obj].Visible then
                tracers[obj].Color = color
                tracers[obj].From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                tracers[obj].To = Vector2.new(screenPos.X, screenPos.Y)
            end
        end

        if boxes[obj] then
            local box = boxes[obj]
            local showBox = isVisible and ESPBoxes
            for _, line in pairs(box) do line.Visible = showBox; line.Color = color end
            if showBox then
                local size = (1 / screenPos.Z) * 1000 
                local w, h = size * 0.6, size
                if obj.Name == "GiftHandle" then w, h = size * 0.4, size * 0.4 end
                local x, y = screenPos.X, screenPos.Y
                box.tl.From = Vector2.new(x-w, y-h); box.tl.To = Vector2.new(x+w, y-h)
                box.tr.From = Vector2.new(x+w, y-h); box.tr.To = Vector2.new(x+w, y+h)
                box.br.From = Vector2.new(x+w, y+h); box.br.To = Vector2.new(x-w, y+h)
                box.bl.From = Vector2.new(x-w, y+h); box.bl.To = Vector2.new(x-w, y-h)
            end
        end
        
        if data.highlight then data.highlight.FillColor = color end
    end
end)

Workspace.ChildAdded:Connect(function(child) task.wait(0.5); if passesFilter(child) then ensureAllFor(child) end 
end)
Workspace.ChildRemoved:Connect(function(child) removeESP(child) end)

local IsInvisible = false
local IsSettingUp = false
local FakeCharacter, RealCharacter, Part

local function protectGuis()
    local pGui = lp:FindFirstChild("PlayerGui")
    if pGui then
        for _, gui in ipairs(pGui:GetChildren()) do
            if gui:IsA("ScreenGui") then
                gui.ResetOnSpawn = false
            end
        end
    end
end

local function setupFakeCharacter()
    if IsSettingUp then return end
    IsSettingUp = true
    
    RealCharacter = lp.Character or lp.CharacterAdded:Wait()
    RealCharacter.Archivable = true
    
    if FakeCharacter then FakeCharacter:Destroy() end
    if Part then Part:Destroy() end

    FakeCharacter = RealCharacter:Clone()
    FakeCharacter.Name = "FakeCharacter"
    
    Part = Instance.new("Part")
    Part.Anchored = true
    Part.Size = Vector3.new(10, 1, 10)
    Part.CFrame = CFrame.new(0, 200, 0)
    Part.CanCollide = true
    Part.Parent = workspace

    FakeCharacter.Parent = workspace
    
    for _, v in ipairs(FakeCharacter:GetChildren()) do
        if v:IsA("BasePart") then v.Transparency = 0.7 end
    end
    
    for _, v in ipairs(RealCharacter:GetChildren()) do
        if v:IsA("LocalScript") then
            local c = v:Clone()
            c.Disabled = true
            c.Parent = FakeCharacter
        end
    end
    
    task.spawn(function()
        while task.wait(0.1) do
            if IsInvisible and RealCharacter and RealCharacter:FindFirstChild("HumanoidRootPart") then
                RealCharacter.HumanoidRootPart.CFrame = Part.CFrame * CFrame.new(0, 5, 0)
                RealCharacter.HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
            end
        end
    end)
    
    IsSettingUp = false
end

local function enableInvis()
    if IsInvisible or IsSettingUp then return end
    
    RealCharacter = lp.Character
    protectGuis()

    if not FakeCharacter then 
        setupFakeCharacter() 
        repeat task.wait() until FakeCharacter
    end

    local realRoot = RealCharacter:FindFirstChild("HumanoidRootPart")
    local fakeRoot = FakeCharacter:FindFirstChild("HumanoidRootPart")
    
    if realRoot and fakeRoot then
        local storedCF = realRoot.CFrame
        realRoot.CFrame = fakeRoot.CFrame
        fakeRoot.CFrame = storedCF
        
        realRoot.Anchored = true 
        
        RealCharacter.Humanoid:UnequipTools()
        lp.Character = FakeCharacter
        workspace.CurrentCamera.CameraSubject = FakeCharacter.Humanoid

        for _, v in ipairs(FakeCharacter:GetChildren()) do
            if v:IsA("LocalScript") then v.Disabled = false end
        end

        IsInvisible = true
    end
end

local function disableInvis()
    if not IsInvisible or IsSettingUp then return end

    local realRoot = RealCharacter:FindFirstChild("HumanoidRootPart")
    local fakeRoot = FakeCharacter:FindFirstChild("HumanoidRootPart")

    if realRoot and fakeRoot then
        local storedCF = fakeRoot.CFrame
        fakeRoot.CFrame = realRoot.CFrame
        realRoot.CFrame = storedCF
        
        realRoot.Anchored = false 
        
        FakeCharacter.Humanoid:UnequipTools()
        lp.Character = RealCharacter
        workspace.CurrentCamera.CameraSubject = RealCharacter.Humanoid

        for _, v in ipairs(FakeCharacter:GetChildren()) do
            if v:IsA("LocalScript") then v.Disabled = true end
        end
        for _, v in ipairs(RealCharacter:GetChildren()) do
            if v:IsA("LocalScript") then v.Disabled = false end
        end

        IsInvisible = false
    end
end

local function noclip()
	Clip = false
	if Noclip then Noclip:Disconnect() end
	Noclip = RunService.Stepped:Connect(function()
		if Clip == false and lp.Character then
			for _, v in ipairs(lp.Character:GetChildren()) do --descen
				if v:IsA("BasePart") and v.CanCollide then
					v.CanCollide = false
				end
			end
		end
	end)
end

local function clip()
	Clip = true
	if Noclip then
		Noclip:Disconnect()
		Noclip = nil
	end
end

local supportsHooks = getrawmetatable and hookfunction and setreadonly

if supportsHooks then
    local success, err = pcall(function()
        local mt = getrawmetatable(game)
        local oldIndex
        local oldNewIndex

        setreadonly(mt, false)

        oldIndex = hookfunction(mt.__index, function(self, index)
            if WalkToggle and not checkcaller() and self:IsA("Humanoid") and self:IsDescendantOf(game.Players.LocalPlayer.Character) then
                if index == "WalkSpeed" then
                    return 16
                end
            end
            return oldIndex(self, index)
        end)

        oldNewIndex = hookfunction(mt.__newindex, function(self, index, value)
            if WalkToggle and not checkcaller() and self:IsA("Humanoid") and self:IsDescendantOf(game.Players.LocalPlayer.Character) then
                if index == "WalkSpeed" then
                    return 
                end
            end
            return oldNewIndex(self, index, value)
        end)

        setreadonly(mt, true)
    end)
    
    if not success then
        warn("[AzureHub] Bypass failed to initialize: " .. tostring(err))
    end
else
    warn("[AzureHub] Executor does not support metatable hooking (getrawmetatable, setreadonly). WS Bypass Skipped.")
end

local function applyBypassSpeed()
    task.spawn(function()
        while task.wait(0.2) do
            if WalkToggle and lp.Character then
                if hum then
                    hum.WalkSpeed = currentSpeed
                end
            end
        end
    end)
end

local crossUI

local function findFolderByKeyword(parent, keyword)
    if not parent then return nil end
    for _, child in ipairs(parent:GetChildren()) do
        if string.find(string.lower(child.Name), string.lower(keyword)) then
            return child
        end
    end
    return nil
end

local countevent = 0
local function autofarmcurrency()
    task.spawn(function()
        while AutoEventToggle do
            if countevent > 8 then
                warn("[AzureHub] Remote limit. Waiting 15 seconds to avoid detection...")
                WindUI:Notify({ Title = "Azure Hub", Content = "Remote limit. Waiting 15 seconds to avoid detection...", Icon = "info", Duration = 15 })
                task.wait(15)
                countevent = 0
                continue
            end
            local mapf = workspace:FindFirstChild("Map")
            
            if root and mapf then
                local chris = findFolderByKeyword(mapf, "chris")
                local treeFolder = findFolderByKeyword(chris, "tree")
                
                local treePart = nil
                if treeFolder then
                    local model = treeFolder:FindFirstChild("Model")
                    treePart = model and model:FindFirstChild("Part")
                end

                local giftsFolder = findFolderByKeyword(chris, "gift")
                local targetGift = giftsFolder and giftsFolder:FindFirstChild("GiftHandle", true)

                if targetGift and treePart then
                    root.CFrame = targetGift.CFrame
                    task.wait(0.3)
                    
                    local remote = game:GetService("ReplicatedStorage"):FindFirstChild("gift", true)
                    if remote then
                        remote:FireServer(targetGift)
                        countevent += 1
                    end
                    
                    task.wait(0.1)
                    root.CFrame = treePart.CFrame
                    task.wait(1)
                else
                    task.wait(1)
                end
            else
                task.wait(1)
            end
        end
    end)
end

local function getNearestTarget()
    local nearest, nearestDist

    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("Model") then
            local valid = false
            if selectedTarget == "Players" and isPlayerObject(obj) then
                valid = true
            elseif selectedTarget == "Killers" and isKillerObject(obj) then
                valid = true
            end

            if valid and obj ~= lp.Character then
                local targetRoot = obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart
                if targetRoot and root then
                    local dist = (targetRoot.Position - root.Position).Magnitude
                    if not nearest or dist < nearestDist then
                        nearest, nearestDist = obj, dist
                    end
                end
            end
        end
    end

    return nearest
end

local function faceTarget(model)
    if not root then return end

    local arm = model:FindFirstChild("Head")
    if not arm and model.PrimaryPart then
        arm = model.PrimaryPart
    end
    if not arm then return end

    local pos = arm.Position
    local dir = (pos - root.Position).Unit

    root.CFrame = CFrame.new(root.Position, root.Position + Vector3.new(dir.X, 0, dir.Z))

    local cam = workspace.CurrentCamera
    cam.CFrame = CFrame.new(cam.CFrame.Position, pos)
end

local function pressSpecialButton(args)
    local pg = lp:FindFirstChild("PlayerGui")
    if not pg then return end
    local survivor = pg:FindFirstChild("Survivor-mob")
    if not survivor then return end
    local controls = survivor:FindFirstChild("Controls")
    if not controls then return end
    local button = controls:FindFirstChild(args)
    if not button or not (button:IsA("TextButton") or button:IsA("ImageButton")) then return end

    for _, ev in ipairs({"MouseButton1Down", "MouseButton1Up", "MouseButton1Click"}) do
        if button[ev] then
            for _, sig in pairs(getconnections(button[ev])) do
                if sig.Function then
                    sig.Function()
                end
            end
        end
    end
end

local GenConnection = nil
local HealConnection = nil
local genHitDone = false
local healHitDone = false

local function autoperfectgen()
    local pGui = lp:FindFirstChild("PlayerGui")
    local checkGui = pGui and pGui:FindFirstChild("SkillCheckPromptGui") and pGui.SkillCheckPromptGui:FindFirstChild("Check")
    
    if checkGui and checkGui.Visible then
        local line = checkGui:FindFirstChild("Line")
        local goal = checkGui:FindFirstChild("Goal")
        
        if line and goal then
            local currentRot = line.Rotation
            local perfectStart = 104 + goal.Rotation
            
            if not genHitDone and currentRot >= (perfectStart + 1) and currentRot <= (perfectStart + 9) then
                game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Space, false, game)
game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Space, false, game)

                pressSpecialButton("action")
                genHitDone = true
            end
        end
    else
        genHitDone = false
    end
end

local function autoperfectheal()
    local pGui = lp:FindFirstChild("PlayerGui")
    local checkGui = pGui and pGui:FindFirstChild("SkillCheckPromptGui") and pGui.SkillCheckPromptGui:FindFirstChild("Check")
    
    if checkGui and checkGui.Visible then
        local line = checkGui:FindFirstChild("Line")
        local goal = checkGui:FindFirstChild("Goal")
        
        if line and goal then
            local currentRot = line.Rotation
            local perfectStart = 104 + goal.Rotation
            
            if not healHitDone and currentRot >= (perfectStart + 1) and currentRot <= (perfectStart + 9) then
                game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Space, false, game)
game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                pressSpecialButton("action")
                healHitDone = true
            end
        end
    else
        healHitDone = false
    end
end

local function AutoShoot()
    if not character then return end
    if not UserInputService.TouchEnabled then
        return WindUI:Notify({
            Title = "Auto Attack",
            Content = "Only works in mobile, PC soon.",
            Icon = "info",
            Duration = 3
        })
    end
    local pg = lp:FindFirstChild("PlayerGui")
    if not pg then return end

    local survivor = pg:FindFirstChild("Survivor-mob")
    if not survivor then
        return WindUI:Notify({
            Title = "Auto Attack",
            Content = "You must be survivor for that!",
            Icon = "info",
            Duration = 2
        })
    end
    if not (character:FindFirstChild("Twist of Fate") or character:FindFirstChild("Flashlight")) then
       return WindUI:Notify({
           Title = "Auto Attack",
           Content = "You must have revolver or flashlight to use this feature.",
           Icon = "info",
           Duration = 3
        })
    end

    local controls = survivor:FindFirstChild("Controls")
    if not controls then return end

    local button = controls:FindFirstChild("Gui-mob")
    if not button or not (button:IsA("TextButton") or button:IsA("ImageButton")) then return end
    
    if facingLoop then 
        facingLoop:Disconnect() 
        facingLoop = nil 
    end
    
    facingLoop = RunService.RenderStepped:Connect(function()
        if not Autoshoot then 
            facingLoop:Disconnect()
            facingLoop = nil
            return 
        end
        
        local target = getNearestTarget()
        if target then
            faceTarget(target)
        end
    end)
    
    task.delay(0.5, function()
        if Autoshoot and button and facingLoop then
            pressSpecialButton("Gui-mob")
            facingLoop:Disconnect()
            facingLoop = nil
        end
    end)
end

local function getSoundIdFromTheme()
	if chasetheme == "Mila - Compass" then
		return "rbxassetid://115877769571526"
	elseif chasetheme == "Close To Me" then
		return "rbxassetid://90022574613230"
	end
	return nil
end

local function fadeTo(vol, time)
	if not chaseSound then return end
	if activeTween then activeTween:Cancel() end
	activeTween = TweenService:Create(chaseSound, TweenInfo.new(time, Enum.EasingStyle.Linear), {Volume = vol})
	activeTween:Play()
end

local function setupChaseMusic(soundid)
	if not chaseSound then
		chaseSound = Instance.new("Sound")
		chaseSound.Name = "CCM"
		chaseSound.SoundId = soundid
		chaseSound.Looped = true
		chaseSound.Volume = 0
		chaseSound.Parent = SoundService

		chaseSound.Loaded:Wait()
		if 96.5 < chaseSound.TimeLength then
			if chasetheme == "Mila - Compass" then 
			chaseSound.TimePosition = 96.5
			end
		end
		chaseSound:Play()
	end

	fadeTo(1.2, 0)
end

local function CreateCross()
    if crossUI then return end

    local pg = game:GetService("CoreGui")
    crossUI = Instance.new("ScreenGui")
    crossUI.Name = "roblox"
    crossUI.ResetOnSpawn = false
    if gethui then crossUI.Parent = gethui() elseif syn and syn.protect_gui then syn.protect_gui(crossUI) crossUI.Parent = game.CoreGui else crossUI.Parent = game.CoreGui end

    local button = Instance.new("ImageButton")
    button.Name = "CircleButton"
    button.Size = UDim2.fromOffset(50, 50)
    button.Position = UDim2.new(1, -120, 0, 150)
    button.BackgroundTransparency = 1
    button.AutoButtonColor = false
    button.Active = true
    button.Draggable = true
    button.Parent = crossUI

    local circle = Instance.new("Frame")
    circle.Size = UDim2.fromScale(1, 1)
    circle.BackgroundTransparency = 1
    circle.Parent = button

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = circle

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.Color = Color3.fromRGB(0, 0, 0)
    stroke.Transparency = 0
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = circle

    button.MouseButton1Click:Connect(function()
        AutoShoot()
    end)
end

local function RemoveCross()
    if crossUI then
        crossUI:Destroy()
        crossUI = nil
    end
end

local function createDropdown()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "roblox"
    if gethui then ScreenGui.Parent = gethui() elseif syn and syn.protect_gui then syn.protect_gui(ScreenGui) ScreenGui.Parent = game.CoreGui else ScreenGui.Parent = game.CoreGui end

    local chosenOption = "Select Mask"
    local chosenMapped = "Rooster"
    local options = {"Chainsaw", "Deadly Punches", "Walk Faster", "Further Dash", "Vault Faster", "Complete Stealth", "Default Mask"}

    local optionMap = {
        ["Chainsaw"] = "Alex",
        ["Deadly Punches"] = "Tony",
        ["Walk Faster"] = "Brandon",
        ["Further Dash"] = "Cobra",
        ["Vault Faster"] = "Rabbit",
        ["Complete Stealth"] = "Richter",
        ["Default Mask"] = "Rooster"
    }

    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Size = UDim2.new(0, 160, 0, 40)
    DropdownButton.Position = UDim2.new(0.68, 0, 0.05, 0)
    DropdownButton.Text = chosenOption
    DropdownButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    DropdownButton.TextColor3 = Color3.new(1, 1, 1)
    DropdownButton.Font = Enum.Font.SourceSansBold
    DropdownButton.TextSize = 18
    DropdownButton.Parent = ScreenGui
    DropdownButton.Active = true
    DropdownButton.Draggable = true

    local OptionsFrame = Instance.new("Frame")
    OptionsFrame.Size = UDim2.new(0, 160, 0, 0)
    OptionsFrame.Position = UDim2.new(0, 0, 1, 0)
    OptionsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    OptionsFrame.BorderSizePixel = 0
    OptionsFrame.Visible = false
    OptionsFrame.ClipsDescendants = true
    OptionsFrame.Parent = DropdownButton

    local optionHeight = 20
    for i, name in ipairs(options) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, optionHeight)
        btn.Position = UDim2.new(0, 0, 0, (i-1) * optionHeight)
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.SourceSans
        btn.TextSize = 16
        btn.Text = name
        btn.Parent = OptionsFrame

        btn.MouseButton1Click:Connect(function()
            chosenOption = name
            chosenMapped = optionMap[name]
            DropdownButton.Text = chosenOption
            OptionsFrame.Visible = false
            OptionsFrame.Size = UDim2.new(0, 160, 0, 0)
        end)
    end

    DropdownButton.MouseButton1Click:Connect(function()
        if OptionsFrame.Visible then
            OptionsFrame.Visible = false
            OptionsFrame.Size = UDim2.new(0, 160, 0, 0)
        else
            OptionsFrame.Visible = true
            OptionsFrame.Size = UDim2.new(0, 160, 0, #options * optionHeight)
        end
    end)

    return {
        getSelection = function()
            return chosenOption, chosenMapped
        end
    }
end

function createDraggableToggle()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "roblox"
    ScreenGui.ResetOnSpawn = false
    if gethui then ScreenGui.Parent = gethui() elseif syn and syn.protect_gui then syn.protect_gui(ScreenGui) ScreenGui.Parent = game.CoreGui else ScreenGui.Parent = game.CoreGui end

    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(0, 130, 0, 35)
    ToggleFrame.Position = UDim2.new(0.5, -65, 0.2, 0)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ToggleFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ToggleFrame.Active = true
    ToggleFrame.Draggable = true
    ToggleFrame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = ToggleFrame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0.7, 0, 0.7, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "No Cd: OFF"
    Title.Font = Enum.Font.Code
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextScaled = true
    Title.Parent = ToggleFrame

    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.new(1, 0, 1, 0)
    Toggle.BackgroundTransparency = 1
    Toggle.Text = ""
    Toggle.Parent = ToggleFrame

    local enabled = false
    Toggle.MouseButton1Click:Connect(function()
        enabled = not enabled
        Title.Text = "No Cd: " .. (enabled and "ON" or "OFF")

        if enabled then
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(40, 100, 40)
            noCdEnabled = true
        else
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            noCdEnabled = false
        end
    end)
end

local lastAnim
RunService.Heartbeat:Connect(function()
    if not root or not character then return end

    for _, obj in ipairs(workspace:GetChildren()) do
        local isKiller = obj:FindFirstChild("Killerost") or obj:FindFirstChild("Lookscriptkiller")
        
        if isKiller and obj:IsA("Model") and obj ~= character then
            local killerHum = obj:FindFirstChildOfClass("Humanoid")
            local killerRoot = obj.PrimaryPart or obj:FindFirstChild("HumanoidRootPart")

            if killerHum and killerRoot then
                local dist = (killerRoot.Position - root.Position).Magnitude
                if Autoparry and dist <= ParryDistance and character:FindFirstChild("Parrying Dagger") then
                    for _, track in ipairs(killerHum:GetPlayingAnimationTracks()) do
                        local animIdStr = track.Animation.AnimationId or ""
                        local id = tonumber(string.match(animIdStr, "%d+"))
                        
                        if id and targetanims[id] then
                            if character:GetAttribute("IsHooked") or character:GetAttribute("IsCarried") then continue end
                            game.ReplicatedStorage.Remotes.Items["Parrying Dagger"].parry:FireServer()
                            if game.UserInputService.TouchEnabled then
                                pressSpecialButton("Gui-mob") 
                            else
                                local Pos = game:GetService("UserInputService"):GetMouseLocation()
                                VIM:SendMouseButtonEvent(Pos.X, Pos.Y, 1, true, game, 1)
                                VIM:SendMouseButtonEvent(Pos.X, Pos.Y, 1, false, game, 1)
                            end
                            break
                        end
                    end
                end

                if dist <= 20 then
                    for _, track in ipairs(killerHum:GetPlayingAnimationTracks()) do
                        local animId = track.Animation.AnimationId or ""
                        local trackName = track.Name or ""
                        local key = animId ~= "" and animId or trackName

                        if string.find(animId, "80411309607666") or trackName:lower() == "slash" then
                            if lastAnim ~= key then
                                pressSpecialButton("crouch")
                                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Mechanics"):WaitForChild("ChangeAttribute"):FireServer("Crouchingserver", true)
                                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Chase"):WaitForChild("Runevent"):FireServer(game.Players.LocalPlayer.Character, false)
                                lastAnim = key
                                task.delay(5, function()
                                    if lastAnim == key then lastAnim = "" end
                                end)
                            end
                            return 
                        end
                    end
                end
            end
        end
    end
end)

local function autodrop()
    task.spawn(function()
        while AutoDropToggle do
            task.wait(0.1)
            
            local nearestPallet = nil
            local shortestDistance = 10
            local rootPos = root.Position
            
            local map = workspace:FindFirstChild("Map")
            local searchFolders = {}
            
            if map then
                table.insert(searchFolders, map)
                local rooftop = map:FindFirstChild("Rooftop")
                if rooftop then
                    local nature = rooftop:FindFirstChild("Nature")
                    if nature then
                        table.insert(searchFolders, nature)
                    end
                end
            end
            
            for _, folder in ipairs(searchFolders) do
                for _, obj in ipairs(folder:GetChildren()) do
                    if obj.Name == "Palletwrong" then
                        local distance = (obj:GetPivot().Position - rootPos).Magnitude
                        if distance < shortestDistance then
                            shortestDistance = distance
                            nearestPallet = obj
                        end
                    end
                end
            end
            
            if nearestPallet then
                local nearestPalletPoint = nil
                local closestPointDistance = math.huge
                
                for _, point in pairs(nearestPallet:GetChildren()) do
                    if point:IsA("BasePart") and point.Name == "PalletPoint" then
                        local distance = (point.Position - rootPos).Magnitude
                        if distance < closestPointDistance then
                            closestPointDistance = distance
                            nearestPalletPoint = point
                        end
                    end
                end
                
                if nearestPalletPoint then
                    for _, obj in pairs(workspace:GetChildren()) do
                        if isKillerObject(obj) and obj ~= character then
                            for _, killerPart in pairs(obj:GetChildren()) do
                                if killerPart:IsA("BasePart") then
                                    for _, palletPart in pairs(nearestPallet:GetChildren()) do
                                        if palletPart:IsA("BasePart") then
                                            local localPos = palletPart.CFrame:PointToObjectSpace(killerPart.Position)
                                            local partSize = palletPart.Size
                                            
                                            if math.abs(localPos.X) <= partSize.X/2 and
                                               math.abs(localPos.Y) <= partSize.Y/2 and
                                               math.abs(localPos.Z) <= partSize.Z/2 then
                                               
                                                if not AutoDropSetToggle and character:GetAttribute("IsCarried") then
                                                else
                                                    game.ReplicatedStorage.Remotes.Pallet.PalletDropEvent:FireServer(nearestPalletPoint)
                                                end
                                                break
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end

local desyncT = {enabled = false, loc = CFrame.new()}
local prevLookVector = nil
local isSpinning = false
local spinThreshold = 15
local desynchook = nil
local heartbeatConn, charConn = nil, nil

local function getOffsetCFrame()
    local ping = game:GetService("Players").LocalPlayer:GetNetworkPing() * 1000
    if ping < 100 then 
        return CFrame.new(0, 0, -2)
    elseif ping <= 170 then 
        return CFrame.new(0, 0, -2.7)
    else 
        return CFrame.new(0, 0, -3.7)
    end
end

local function enableHitboxDesync()
    heartbeatConn = RunService.Heartbeat:Connect(function()
        if not desyncT.enabled or not character then return end
        if not root then return end
        
        local currentLook = root.CFrame.LookVector
        if prevLookVector then
            local dot = math.clamp(prevLookVector:Dot(currentLook), -1, 1)
            local angleDiff = math.deg(math.acos(dot))
            isSpinning = angleDiff > spinThreshold
        end
        prevLookVector = currentLook
        
        if isSpinning then return end 
        
        desyncT.loc = root.CFrame
        local offset = getOffsetCFrame()
        local newCFrame = desyncT.loc * offset
        root.CFrame = newCFrame
        
        root.CFrame = desyncT.loc
    end)
    
    desynchook = hookmetamethod(game, "__index", newcclosure(function(self, key)
        if desyncT.enabled and not checkcaller() and 
           key == "CFrame" and 
           LocalPlayer.Character and 
           self == LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and
           not isSpinning then
            return desyncT.loc
        end
        return desynchook(self, key)
    end))
    
    charConn = LocalPlayer.CharacterAdded:Connect(function()
        task.wait(1)
        prevLookVector = nil
        isSpinning = false
    end)
end

local function disableHitboxDesync()
    desyncT.enabled = false
    if heartbeatConn then
        heartbeatConn:Disconnect()
        heartbeatConn = nil
    end
    if charConn then
        charConn:Disconnect()
        charConn = nil
    end
    if desynchook then
        desynchook = nil
    end
    prevLookVector = nil
    isSpinning = false
end

local RemoveCrosshair = nil

local function LoadCrosshair()
    local LineX = Drawing.new('Line')
    LineX.Thickness = 2
    LineX.Transparency = 1
    LineX.Color = Color3.fromRGB(255,255,255)
    LineX.Visible = true
    
    local LineY = Drawing.new('Line')
    LineY.Thickness = 2
    LineY.Transparency = 1
    LineY.Color = Color3.fromRGB(255,255,255)
    LineY.Visible = true

    local function UpdatePosition()
        local ViewportSize = Camera.ViewportSize
        local CenterX, CenterY = ViewportSize.X / 2, ViewportSize.Y / 2
        
        LineX.From = Vector2.new(CenterX - 8, CenterY)
        LineX.To = Vector2.new(CenterX + 8, CenterY)
        
        LineY.From = Vector2.new(CenterX, CenterY - 8)
        LineY.To = Vector2.new(CenterX, CenterY + 8)
    end
    
    UpdatePosition()
    local Connection = Camera:GetPropertyChangedSignal("ViewportSize"):Connect(UpdatePosition)

    return function()
        if LineX then LineX:Remove() end
        if LineY then LineY:Remove() end
        if Connection then Connection:Disconnect() end
    end
end

local OPSection = TabHandles.Universal:Section({ 
    Title = "Fun",
    Icon = "crown"
})
Toggles.DesyncHandle = OPSection:Toggle({
    Title = "Desync",
    Desc = "Use for better hitboxes or for faking position.",
    Value = false,
    Callback = function(state)
      task.spawn(function()
        if not setfflag then
            warn("[AzureHub] Desync not supported. Desync will not work.")
            return
        end
        Desync = state
        
        if DesyncType == "Fake Position" then
            setfflag('NextGenReplicatorEnabledWrite4', tostring(state))
        elseif DesyncType == "Hitbox Improving" then
            desyncT.enabled = state
            
            if state then
                enableHitboxDesync()
            else
                Window:Close()
                task.wait(0.1)
                disableHitboxDesync()
            end
        end
      end)
    end
})
Toggles.DesyncTypeHandle = OPSection:Dropdown({
       Title =  "Desync Type",
       Values = { "Hitbox Improving", "Fake Position" },
       Value = DesyncType,
       Multi = false,
       AllowNone = false,
       Callback = function(option)
             DesyncType = option
       end
})
Toggles.InvisibilityHandle = OPSection:Toggle({
       Title =  "Invisibility",
       Desc = "Turns you invisible, others cannot see you.",
       Value = false,
       Callback = function(state)
             InvisibilityToggle = state
             if state then 
                 enableInvis()
             else
                 disableInvis()
             end
       end
})
OPSection:Divider()
Toggles.HitboxesRadiusHandle = OPSection:Slider({
       Title = "Hitboxes Radius",
	Value = { Min = 5, Max = 30, Default = 10 },
	Callback = function(Value)
		HitboxesRadius = tonumber(Value)
	end
})
Toggles.ExpandHitboxesHandle = OPSection:Toggle({
       Title = "Expand Hitboxes",
       Desc = "Expands opposite team's hitboxes.",
       Value = false,
       Callback = function(state)
             ExpandHitboxesToggle = state
       end
})
Toggles.HitboxesVisibleHandle = OPSection:Toggle({
       Title = "Hitboxes Visible?",
       Desc = "Makes hitboxes half transparent.",
       Value = false,
       Callback = function(state)
             HitboxesVisibleToggle = state
       end
})

local UMiscSection = TabHandles.Universal:Section({ 
    Title = "Misc",
    Icon = "layout-grid"
})
Toggles.AutoEventHandle = UMiscSection:Toggle({
       Title =  "Auto Farm Event",
       Desc = "Farms existing event, current event: 🎄",
       Value = false,
       Callback = function(state)
             AutoEventToggle = state
             if state then
                 autofarmcurrency()
             end
       end
})
Toggles.CrosshairHandle = UMiscSection:Toggle({
       Title = "Crosshair",
       Desc = "Adds crosshair to the screen, useful with revolver.",
       Value = false,
       Callback = function(state)
             if state then
                 if not RemoveCrosshair then
                     RemoveCrosshair = LoadCrosshair()
                 end
             else
                 if RemoveCrosshair then
                     RemoveCrosshair()
                     RemoveCrosshair = nil
                 end
             end
       end
})
UMiscSection:Button({
       Title =  "Potato Graphics",
       Callback = function(state)
        local lighting = game:GetService("Lighting")
        local terrain = workspace:FindFirstChildOfClass("Terrain")

        lighting.GlobalShadows = false
        lighting.FogEnd = 9e9
        lighting.Brightness = 1

        if terrain then
            terrain.WaterWaveSize = 0
            terrain.WaterWaveSpeed = 0
            terrain.WaterReflectance = 0
            terrain.WaterTransparency = 0
        end

        for _, v in ipairs(lighting:GetChildren()) do
            if v:IsA("PostProcessEffect") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") then
                v.Enabled = false
            end
        end

        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Material = Enum.Material.SmoothPlastic
                v.Reflectance = 0
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Enabled = false
            elseif v:IsA("MeshPart") then
                v.Material = Enum.Material.SmoothPlastic
                v.Reflectance = 0
            end
        end
       end
})
local UPlaySection = TabHandles.Universal:Section({ 
    Title = "Auto Play",
    Icon = "joystick"
})
Toggles.AutoPlayHandle = UPlaySection:Toggle({
   Title =  "Auto Play (AI, BETA)",
   Desc = "Automatically plays for you, will be improving further.",
   Value = false,
   Callback = function(state)
       getgenv().AIPlaying = state
       if state then
           loadstring(game:HttpGet("https://pastefy.app/P7Xzdqfu/raw"))()
       end
   end
})
UPlaySection:Divider()
Toggles.RunHandle = UPlaySection:Toggle({
   Title =  "Auto Run (BETA)",
   Desc = "Runs from killer if he's close and you're survivor.",
   Value = false,
   Callback = function(state)
       getgenv().settings.Methods.Run = state
   end
})
Toggles.FarmHandle = UPlaySection:Toggle({
   Title =  "Auto Farm (BETA)",
   Desc = "Farms generators if you're survivor, survivors if you're killer.",
   Value = false,
   Callback = function(state)
       getgenv().settings.Methods.Farm = state
   end
})
Toggles.LoopHandle = UPlaySection:Toggle({
   Title =  "Auto Loop (BETA)",
   Desc = "Loops killer if you're survivor.",
   Value = false,
   Callback = function(state)
       getgenv().settings.Methods.Farm = state
   end
})
Toggles.WallHugHandle = UPlaySection:Toggle({
   Title =  "Wall Hug",
   Desc = "Hugs wall while running/farming/looping.",
   Value = false,
   Callback = function(state)
       getgenv().settings.Toggles.Wallhug = state
   end
})

local KillerBlatantSection = TabHandles.Killer:Section({ 
    Title = "Blatant",
    Icon = "fan"
})
Toggles.InfThingsHandle = KillerBlatantSection:Toggle({
    Title = "Infinite Abilities " .. (getTag(lp.Name) == "[ FREEMIUM ]" and "(PREMIUM)" or ""),
    Desc = "Includes no attack cooldown. Supported killers for inf abillities: Slasher, Masked, Veil, Stalker.",
    Value = false,
    Callback = function(state)
        if state then
            if getgenv().PREMIUM_KEY then
                InfThingsToggle = true
            else
                InfThingsToggle = false
                WindUI:Notify({
                    Title = "Premium Feature",
                    Content = "This feature is only for premium users, get premium in our discord server.",
                    Icon = "info",
                    Duration = 3
                })
                if Toggles.InfThingsHandle then
                    Toggles.InfThingsHandle:Set(false)
                end
            end
        else
            InfThingsToggle = false
        end
    end
})
local InfLungeConnection = nil
Toggles.InfLungeHandle = KillerBlatantSection:Toggle({
    Title = "Infinite Lunge " .. (getTag(lp.Name) == "[ FREEMIUM ]" and "(PREMIUM)" or ""),
    Desc = "Lunge infinitely without any restrictions.",
    Value = false,
    Callback = function(state)
        if state then
            if not getgenv().PREMIUM_KEY then
                state = false
                WindUI:Notify({
                    Title = "Premium Feature",
                    Content = "This feature is only for premium users, get premium in our discord server.",
                    Icon = "info",
                    Duration = 3
                })
                if Toggles.InfLungeHandle then
                    Toggles.InfLungeHandle:Set(false)
                end
                return
            end
        end
        if state then
            character:SetAttribute("lungeboost", 999)
            if InfLungeConnection then InfLungeConnection:Disconnect() end
            InfLungeConnection = lp.CharacterAdded:Connect(function(newChar)
                task.wait(1)
                character:SetAttribute("lungeboost", 999)
            end)
        else
            if InfLungeConnection then
                InfLungeConnection:Disconnect()
                InfLungeConnection = nil
            end
            character:SetAttribute("lungeboost", 1)
        end
    end
})
KillerBlatantSection:Divider()
Toggles.HookFarmHandle = KillerBlatantSection:Toggle({
       Title = "Hook Farm",
       Desc = "Use for farming screws, must hook someone once.",
       Value = false,
       Callback = function(state)
             HookFarmToggle = state
       end
})
Toggles.HookTimesHandle = KillerBlatantSection:Slider({
       Title = "Hook Times",
	Value = { Min = 2, Max = 1000, Default = 10 },
	Callback = function(Value)
		HookTimes = tonumber(Value)
	end
})

local KillerSection = TabHandles.Killer:Section({ 
    Title = "Hunting",
    Icon = "axe"
})
Toggles.OneTapHandle = KillerSection:Toggle({
       Title = "Damage Aura",
       Desc = "Throws cycles of hits at the location you're facing.",
       Value = false,
       Callback = function(state)
             DamageAura = state
             while DamageAura and task.wait(0.1) do
                 game.ReplicatedStorage.Remotes.Attacks.BasicAttack:FireServer()
             end
       end
})
KillerSection:Divider()
Toggles.AutoAimChargedHandle = KillerSection:Toggle({
       Title = "Auto Aim Charged Spear (Veil)",
       Desc = "Automatically aims charged spear to the closest survivor. YOU MUST BE HOLDING SPEAR DONT FUCKING BUG REPORT",
       Value = false,
       Callback = function(state)
             AutoAimChargedToggle = state
             if state and AutoAimNormalToggle and AutoAimNormalHandle then
                 AutoAimNormalToggle = false
                 AutoAimNormalHandle:Set(false)
             end
       end
})
Toggles.AutoAimNormalHandle = KillerSection:Toggle({
       Title = "Auto Aim Spear (Veil)",
       Desc = "Automatically aims spear to the closest survivor. YOU MUST BE HOLDING SPEAR DONT FUCKING BUG REPORT",
       Value = false,
       Callback = function(state)
             AutoAimNormalToggle = state
             if state and AutoAimChargedToggle and AutoAimChargedHandle then
                 AutoAimChargedToggle = false
                 AutoAimChargedHandle:Set(false)
             end
       end
})

local KillerMiscSection = TabHandles.Killer:Section({ 
    Title = "Attributes",
    Icon = "syringe"
})
Toggles.AntiFlashlightHandle = KillerMiscSection:Toggle({
       Title = "Anti Flashlight",
       Desc = "Removes flashlight brightness.",
       Value = false,
       Callback = function(state)
             AntiFlashlight = state
       end
})
Toggles.AntiSlowHandle = KillerMiscSection:Toggle({
       Title = "Anti Slow Down",
       Desc = "Removes negative walk speed effects.",
       Value = false,
       Callback = function(state)
             AntislowToggle = state
       end
})
KillerMiscSection:Button({
	Title = "Enable Emotes",
	Callback = function()
	      local pg = lp:FindFirstChild("PlayerGui")
	      if pg then
                local emotesGui = pg:FindFirstChild("Emotes")
                if emotesGui then
                   emotesGui.Enabled = true
                end
             end
	end
})

--[[local SurvBlatantSection = TabHandles.Survivor:Section({ 
    Title = "Blatant",
    Icon = "fan"
})
Toggles.InstaHealHandle = SurvSection:Toggle({
       Title = "Instant Heal",
       Desc = "Instantly heal downed players.",
       Value = false,
       Callback = function(state)
       end
})]]

local SurvSection = TabHandles.Survivor:Section({ 
    Title = "Combat",
    Icon = "axe"
})
Toggles.GodModeHandle = SurvSection:Toggle({
    Title = "God Mode " .. (getTag(lp.Name) == "[ FREEMIUM ]" and "(PREMIUM)" or ""),
    Desc = "Prevents you from being attacked, makes you invincible.",
    Value = false,
    Callback = function(state)
        if state then
            if getgenv().PREMIUM_KEY then
                GodmodeToggle = true
            else
                GodmodeToggle = false
                WindUI:Notify({
                    Title = "Premium Feature",
                    Content = "This feature is only for premium users, get premium in our discord server.",
                    Icon = "info",
                    Duration = 3
                })
                if Toggles.GodModeHandle then
                    Toggles.GodModeHandle:Set(false)
                end
            end
        else
            GodmodeToggle = false
        end
    end
})
Toggles.AutoShootHandle = SurvSection:Toggle({
       Title = "Auto Attack",
       Desc = "Automatically aims to target and shoots him, must have revolver/flashlight and target must be in FOV.",
       Value = false,
       Callback = function(state)
             Autoshoot = state
             if Autoshoot then
            CreateCross()
            else
            RemoveCross()
            end
       end
})
Toggles.ShootTargetHandle = SurvSection:Dropdown({
       Title =  "Auto Attack Target",
       Values = { "Killers", "Players" },
       Value = "",
       Multi = false,
       AllowNone = true,
       Callback = function(option)
             selectedTarget = option
       end
})

local SurvDefSection = TabHandles.Survivor:Section({ 
    Title = "Looping",
    Icon = "infinity"
})
Toggles.AutoParryHandle = SurvDefSection:Toggle({
       Title = "Auto Parry Killer",
       Desc = "Automatically stuns killer parrying him, must have parrying dagger as survivor.",
       Value = false,
       Callback = function(state)
             Autoparry = state
       end
})
Toggles.ParrySliderHandle = SurvDefSection:Slider({
       Title = "Parry Radius",
       Desc = "Modify the radius of auto parry (optional).",
	Value = { Min = 5, Max = 30, Default = 10 },
	Callback = function(Value)
		ParryDistance = tonumber(Value)
	end
})
if getrawmetatable and setreadonly then
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if NoFallToggle and self == FallRemote and method == "FireServer" then
        return nil
    end
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)
else
warn("[AzureHub] Executor does not support metatable hooking (getrawmetatable, setreadonly). NoFall Bypass Skipped.")
end

Toggles.NoFallHandle = SurvDefSection:Toggle({
    Title = "No Fall",
    Desc = "Removes falling negative effects.",
    Value = false,
    Callback = function(state)
        NoFallToggle = state 
    end
})
SurvDefSection:Divider()
Toggles.AutoDropHandle = SurvDefSection:Toggle({
       Title = "Auto Drop Pallete",
       Desc = "Drops pallete right to killer, must be near.",
       Value = false,
       Callback = function(state)
             AutoDropToggle = state
             if state then autodrop() end
       end
})
Toggles.AutoDropSetHandle = SurvDefSection:Toggle({
       Title = "Pallet Works On Carry?",
       Desc = "Drops pallete even if killer is carrying you and passing after pallet.",
       Value = false,
       Callback = function(state)
             AutoDropSetToggle = state
       end
})

local SurvMiscSection = TabHandles.Survivor:Section({ 
    Title = "Objectives",
    Icon = "check"
})
Toggles.PerfectGenHandle = SurvMiscSection:Toggle({
    Title = "Auto Perfect Generator",
    Desc = "Does generator skill check at perfect spot.",
    Value = false,
    Callback = function(state)
        if state then
            GenConnection = RunService.Heartbeat:Connect(autoperfectgen)
        else
            if GenConnection then
                GenConnection:Disconnect()
                GenConnection = nil
            end
        end
    end
})
Toggles.PerfectHealHandle = SurvMiscSection:Toggle({
    Title = "Auto Perfect Heal",
    Desc = "Does heal skill check at perfect spot.",
    Value = false,
    Callback = function(state)
        if state then
            HealConnection = RunService.Heartbeat:Connect(autoperfectheal)
        else
            if HealConnection then
                HealConnection:Disconnect()
                HealConnection = nil
            end
        end
    end
})
SurvMiscSection:Divider()
Toggles.AntiGFailHandle = SurvMiscSection:Toggle({
       Title = "Anti Fail Generator",
       Desc = "Failing generator skill check will not do anything.",
       Value = false,
       Callback = function(state)
             AntiGFail = state
       end
})
Toggles.RemoveClothingsHandle = SurvMiscSection:Toggle({
       Title = "Remove Veil Clothings",
       Desc = "Nakes veil killer.",
       Value = false,
       Callback = function(state)
             RemoveClothingsToggle = state
       end
})
SurvMiscSection:Button({
	Title = "Instant Escape",
	Callback = function()
	       local gate = workspace.Map:FindFirstChild("Gate")
	       if gate then
	           local box = gate:FindFirstChild("Box")
	           if box and box:IsA("BasePart") then
		        local backCFrame = box.CFrame * CFrame.new(0, 0, -50)
		        root.CFrame = CFrame.new(backCFrame.Position, box.Position)
	           end
	       end
	end
})
SurvMiscSection:Button({
    Title = "Destroy Gates",
    Callback = function()
        local map = workspace:FindFirstChild("Map")
        if not map then return end

        for _, gate in ipairs(map:GetChildren()) do
            if gate.Name == "Gate" and gate:IsA("Model") then
                gate:Destroy()
            end
        end
    end
})

local FOVRadius = 70
RunService.RenderStepped:Connect(function()
    if game.workspace.CurrentCamera.FieldOfView ~= FOVRadius then
        game.workspace.CurrentCamera.FieldOfView = FOVRadius
    end
end)
Toggles.FOVSliderHandle = TabHandles.Esp:Slider({
       Title = "FOV Radius",
       Desc = "Modify the radius of FOV.",
	Value = { Min = 1, Max = 120, Default = 70 },
	Callback = function(Value)
		FOVRadius = tonumber(Value)
	end
})
TabHandles.Esp:Button({
	Title = "Full Bright",
	Callback = function()
	       local Lighting = game:GetService("Lighting")
	       Lighting.Ambient = Color3.fromRGB(255, 255, 255)
	       Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
	       Lighting.Brightness = 2
	       Lighting.ShadowSoftness = 0
	       Lighting.GlobalShadows = false
	end
})
Toggles.ESPDropdownHandle = TabHandles.Esp:Dropdown({
       Title =  "ESP's",
       Values = { "Killers", "Players", "Generators", "Presents" },
       Value = { "" },
       Multi = true,
       AllowNone = true,
       Callback = function(option)
             selectedESPTypes = option
       end
})
Toggles.ESPHighlightHandle = TabHandles.Esp:Toggle({
       Title = "Highlight objects",
       Desc = "Highlights objects, most useful feature.",
       Value = false,
       Callback = function(state)
             ESPHighlight = state
       end
})
Toggles.ESPTracersHandle = TabHandles.Esp:Toggle({
       Title = "Show Tracers",
       Desc = "Adds line pointing to your ESP object.",
       Value = false,
       Callback = function(state)
             ESPTracers = state
       end
})
Toggles.ESPBoxesHandle = TabHandles.Esp:Toggle({
       Title = "Show Boxes",
       Desc = "Adds box showing the hitbox of your ESP object.",
       Value = false,
       Callback = function(state)
             ESPBoxes = state
       end
})
Toggles.ESPNamesHandle = TabHandles.Esp:Toggle({
       Title = "Show Names",
       Desc = "Adds name of object above ur object's head.",
       Value = false,
       Callback = function(state)
             ESPNames = state
       end
})
Toggles.ESPStudsHandle = TabHandles.Esp:Toggle({
       Title = "Show Studs",
       Desc = "Adds studs above ur objects head, shows how far you're away from the object.",
       Value = false,
       Callback = function(state)
             ESPStuds = state
       end
})

Toggles.NoclipHandle = TabHandles.Player:Toggle({
	Title = "Noclip",
	Desc = "Pass through walls with this toggle on.",
	Value = false,
	Callback = function(state)
		NoclipToggle = state
		if state then
			noclip()
		else
			clip()
		end
	end
})
Toggles.WsToggleHandle = TabHandles.Player:Toggle({
	Title = "WalkSpeed Changer",
	Desc = "Set your speed to your preference.",
	Value = false,
	Callback = function(state)
		WalkToggle = state
		if state then applyBypassSpeed() end
	end
})
Toggles.WsSliderHandle = TabHandles.Player:Slider({
       Title = "WalkSpeed",
	Value = { Min = 10, Max = 100, Default = 28 },
	Callback = function(Value)
		currentSpeed = Value
	end
})

local antiAfkToggle = false
local FlingToggle = false
local antiFlingToggle = false
local flingThread

local function fling()
    local movel = 0.1
    while FlingToggle do
        RunService.Heartbeat:Wait()
        local c = lp.Character
        local hrp = c and c:FindFirstChild("HumanoidRootPart")
        if hrp then
            local vel = hrp.Velocity
            hrp.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
            RunService.RenderStepped:Wait()
            hrp.Velocity = vel
            RunService.Stepped:Wait()
            hrp.Velocity = vel + Vector3.new(0, movel, 0)
            movel = -movel
        end
    end
end

task.spawn(function()
	while task.wait(60) do
		if antiAfkToggle then
			root.CFrame = root.CFrame + Vector3.new(0, 3, 0)
		end
	end
end)

local HitSoundHandle = TabHandles.Misc:Input({
    Title = "Hit Sound",
    Type = "Input",
    Placeholder = "rbxassetid://",
    Callback = function(input) 
    end
})

local chaseThemeHandle = TabHandles.Misc:Dropdown({
       Title = "Chase Theme",
       Values = { "Mila - Compass" },
       Value = chasetheme,
       AllowNone = true,
       Callback = function(option)
       chasetheme = option
       end
})

local idConn
Toggles.ProtectIdentityHandle = TabHandles.Misc:Toggle({
    Title = "Protect Identity",
    Desc = "Hides user, avatar, etc.",
    Value = false,
    Callback = function(state)
        local function bacon(c)
            if not character then return end
            for _, v in pairs(character:GetChildren()) do 
                if v:IsA("Accessory") or v:IsA("Clothing") or v:IsA("ShirtGraphic") or v:IsA("CharacterMesh") then v:Destroy() end 
            end
            if character:FindFirstChild("Head") and character.Head:FindFirstChild("face") then character.Head.face.Texture = "rbxassetid://144075659" end
            local bc = character:FindFirstChild("BodyColors") or Instance.new("BodyColors", c)
            bc.HeadColor3 = Color3.fromRGB(234, 184, 146); bc.TorsoColor3 = Color3.fromRGB(116, 134, 157); bc.LeftLegColor3 = Color3.fromRGB(82, 84, 82); bc.RightLegColor3 = Color3.fromRGB(82, 84, 82); bc.LeftArmColor3 = bc.HeadColor3; bc.RightArmColor3 = bc.HeadColor3
            if lp then
                lp.Name = "azurehub"
                lp.DisplayName = "azurehub"
            end
        end

        if state then
            bacon(character)
            if idConn then idConn:Disconnect() end
            idConn = lp.CharacterAdded:Connect(function(c)
                bacon(c)
                task.wait(2)
                bacon(c) 
            end)
        else
            if idConn then idConn:Disconnect() end
        end
    end
})
Toggles.antiAfkHandle = TabHandles.Misc:Toggle({
    Title = "Anti AFK",
    Desc = "If enabled, jumps every minute so you wouldn't get kicked out for AFK.",
    Value = false,
    Callback = function(state)
        antiAfkToggle = state
    end
})

Toggles.antiFlingHandle = TabHandles.Misc:Toggle({
    Title = "Anti Fling",
    Desc = "If enabled, no one could fling you off map.",
    Value = false,
    Callback = function(state)
        antiFlingToggle = state
        if not state then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= lp and plr.Character then
                    for _, part in ipairs(plr.Character:GetChildren()) do -- descen
                        if part:IsA("BasePart") then
                            part.CanCollide = true
                        end
                    end
                end
            end
        end
    end
})

Toggles.FlingHandle = TabHandles.Misc:Toggle({
    Title = "Touch Fling",
    Desc = "If enabled, you could fling anyone in map by touching them.",
    Value = false,
    Callback = function(state)
        FlingToggle = state
    end
})

local antiAdminToggle = false
Toggles.antiAdminHandle = TabHandles.Misc:Toggle({
    Title = "Anti Admin",
    Desc = "If enabled, kicks you out if there's admin in your experience.",
    Value = false,
    Callback = function(state)
        antiAdminToggle = state
    end
})

task.spawn(function()
	while task.wait(1) and antiAdminToggle do
	       for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= lp and (table.find(blacklist, plr.UserId) or bannedRanks[plr:GetRoleInGroup(gid)]) then
				lp:Kick("Admin detected: " .. plr.Name)
			end
		end
	end
end)

task.spawn(function()
    while task.wait(0.1) do
        if GodmodeToggle then
           hum.Health = 100
           character:SetAttribute("IsCarried", false)
           character:SetAttribute("IsHooked", false)
           character:SetAttribute("Knocked", false)
        end
        if FlingToggle then
            fling()
        end
    end
end)

local configName = "Config Name"
TabHandles.Config:Input({
    Title = "Config Name",
    Value = configName,
    Callback = function(value)
        configName = value
        if ConfigManager then
            configFile = ConfigManager:CreateConfig(configName)
            -- AUTOMATIC REGISTRATION LOOP
            for name, handle in pairs(Toggles) do
                configFile:Register(name, handle)
            end
        end
    end
})

local ConfigManager = Window.ConfigManager
local configFile
local autoLoadFile = "AZUREHUB_ALC_VD.txt"
local ALC = false

if ConfigManager then
    ConfigManager:Init(Window)
    
    configFile = ConfigManager:CreateConfig(configName)
    
    for name, handle in pairs(Toggles) do
        configFile:Register(name, handle)
    end
    
    TabHandles.Config:Button({
        Title = "Save Config",
        Icon = "save",
        Variant = "Primary",
        Callback = function()
            configFile:Set("lastSave", os.date("%Y-%m-%d %H:%M:%S"))
            configFile:Save()
            WindUI:Notify({ 
                Title = "Saved Config", 
                Content = "Saved as: "..configName,
                Icon = "check",
                Duration = 3
            })
        end
    })

    TabHandles.Config:Button({
        Title = "Load Config",
        Icon = "folder",
        Callback = function()
           if not configFile then
                configFile = ConfigManager:CreateConfig(configName)
                for name, handle in pairs(Toggles) do
                    configFile:Register(name, handle)
                end
            end

            local loadedData = configFile:Load()

            if loadedData then
                WindUI:Notify({ 
                    Title = "Load Config", 
                    Content = "Loaded: "..configName.."\nLast save: "..(loadedData.lastSave or "Unknown"),
                    Icon = "refresh-cw",
                    Duration = 5
                })
            else
                WindUI:Notify({ 
                    Title = "Load Config", 
                    Content = "Failed to load config: "..configName,
                    Icon = "x",
                    Duration = 5
                })
            end
        end
    })
    local autoloadconfig
    autoloadconfig = TabHandles.Config:Toggle({
        Title = "Auto Load Config",
        Desc = "Automatically load the last used config on execute.",
        Callback = function(state)
            ALC = state
            writefile(autoLoadFile, tostring(state))
        end
    })

    if isfile(autoLoadFile) and readfile(autoLoadFile) == "true" then
        pcall(function()
            if not configFile then
                configFile = ConfigManager:CreateConfig(configName)
            end

            local loadedData = configFile:Load()
            if loadedData then
                autoloadconfig:Set(true)
                WindUI:Notify({
                    Title = "Auto Load Config",
                    Content = "Automatically loaded config: " .. configName,
                    Icon = "refresh-ccw",
                    Duration = 2
                })
            end
        end)
    end
end

local uicreated = false
local dropdownCreated = false

task.spawn(function()
	while task.wait(1) do
		local gui = lp:FindFirstChild("PlayerGui")
               local myKiller = getKiller()

               if myKiller == "Masked" and not dropdownCreated and InfThingsToggle then
                   createDropdown()
                   dropdownCreated = true
              end

		if RemoveClothingsToggle then
		    for _, pl in ipairs(game.Workspace:GetChildren()) do
		        if pl:FindFirstChild("spearmanager") then
		            for _, item in ipairs(pl:GetChildren()) do
		                if item:IsA("BasePart") and string.lower(item.Name):find("hat") then item:Destroy() end
		            end
		        end
		    end
		end

		if AntiFlashlight and gui then
		       local mob = gui:FindFirstChild("Slasher-mob") or gui:FindFirstChild("Masked-mob") or gui:FindFirstChild("Hidden-mob")
			if mob then
			       local Blind = mob:FindFirstChild("Blind")
			       if Blind then
					pcall(function()
					        obj:Destroy()
					end)
				end
			end
		end

		if AntislowToggle and hum then
			hum:SetAttribute("speedboost", 1)
			hum.WalkSpeed = hum.WalkSpeed + hum:GetAttribute("speedboost")
		end

		if ExpandHitboxesToggle then
                   local amIKiller = character:FindFirstChild("Killerost") or character:FindFirstChild("Lookscriptkiller")
                   for _, model in ipairs(workspace:GetChildren()) do
                       if model:IsA("Model") and model ~= character then
                           local isTarget = false
                           if amIKiller then
                               if model:FindFirstChild("Highlight-forsurvivor") then
                                  isTarget = true
                               end
                           else
                           if model:FindFirstChild("Killerost") or model:FindFirstChild("Lookscriptkiller") then
                               isTarget = true
                           end
                       end

                       if isTarget then
                           local part = model:FindFirstChild("HumanoidRootPart")
                           if part and part:IsA("BasePart") then
                                   pcall(function()
                                       part.Size = Vector3.new(HitboxesRadius, HitboxesRadius, HitboxesRadius)
                                       part.CanCollide = false
                                       if HitboxesVisibleToggle then
                                            part.Transparency = 0.5
                                       else
                                            part.Transparency = 1
                                       end
                                   end)
                               end
                           end
                       end
                  end
               end
               
		if InfThingsToggle and gui then
			local mob = gui:FindFirstChild("Slasher-mob") or gui:FindFirstChild("Masked-mob") or gui:FindFirstChild("Hidden-mob")
			if mob then
				local controls = mob:FindFirstChild("Controls")
				if controls then
					local powerOne = controls:FindFirstChild("move1")
					local powerTwo = controls:FindFirstChild("move2")
					local attack = controls:FindFirstChild("attack")

					if powerOne then hookButton(powerOne) end
					if powerTwo then hookButton(powerTwo) end
					if attack then hookButton(attack) end

					if not uicreated then
						task.defer(function()
							createDraggableToggle()
						end)
						uicreated = true
					end
				end
			end
		end
	end
end)

task.spawn(function()
	while task.wait(0.2) do
	       for _, obj in ipairs(SoundService:GetChildren()) do
			if obj:IsA("Sound") and obj ~= chaseSound and (chasetheme == "Mila - Compass" or chasetheme == "Close To Me") then
				if string.lower(obj.Name) == "chasemusic" then
					obj.Volume = 0
					obj.Playing = false
				end
			end
		end
	end
end)

ReplicatedStorage.Remotes.Carry.HookEvent.OnClientEvent:Connect(function(...)
    if not HookFarmToggle then return end
    for i = 1, HookTimes do
        ReplicatedStorage.Remotes.Carry.HookEvent:FireServer(...)
    end
end)

ReplicatedStorage.Remotes.Generator.SkillCheckEvent.OnClientEvent:Connect(function(generator, point, context)
    if not AntiGFail then return end
    ReplicatedStorage.Remotes.Generator.SkillCheckResultEvent:FireServer("success", 1, generator, point)
end)

local PredictionTime = 0.14
local MinDistance = 10
local MaxDistance = 200
local MinPitch = -1
local MaxPitch = 30

local PitchTable = {
    [0] = 0.09, [1] = 0.90, [2] = 1.9, [3] = 2.9, [4] = 3.9,
    [5] = 4.9, [6] = 5.9, [7] = 6.9, [8] = 7.9, [9] = 8.9,
    [10] = 10.9, [11] = 11.9, [12] = 12.9, [13] = 13.9, [14] = 14.9,
    [15] = 15.9, [16] = 16.9, [17] = 17.9, [18] = 18.9, [19] = 20.3,
    [20] = 22.3
}
local FallbackPitch = 23.3
local aimConnection

local function InitializeCharacter(newChar)
    character = newChar
    root = newChar:WaitForChild("HumanoidRootPart", 9)

    if aimConnection then 
        aimConnection:Disconnect() 
        aimConnection = nil 
    end
    newChar:GetAttributeChangedSignal('spearmode'):Connect(function()
        local isSpearMode = newChar:GetAttribute('spearmode')

        if aimConnection then 
            aimConnection:Disconnect() 
            aimConnection = nil 
        end
        
        if isSpearMode then 
            aimConnection = game:GetService("RunService").RenderStepped:Connect(function()
                if not (AutoAimNormalToggle or AutoAimChargedToggle) then return end
                if not root then return end

                local targetChar = nil
                local shortestMetric = math.huge
                
                for _, v in ipairs(game:GetService("Players"):GetPlayers()) do
                    if v ~= lp and v.Character then
                        local char = v.Character
                        
                        if char:GetAttribute("IsHooked") or char:GetAttribute("IsCarried") or char:GetAttribute("Knocked") then continue end

                        local tHead = char:FindFirstChild("Head")
                        local tRoot = char:FindFirstChild("HumanoidRootPart")
                        local tHum = char:FindFirstChild("Humanoid")

                        if tHead and tRoot and tHum and tHum.Health > 0 then
                            if AutoAimNormalToggle then
                                local screenPos, onScreen = Camera:WorldToViewportPoint(tHead.Position)
                                if onScreen then
                                    local dist2D = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                                    if dist2D < shortestMetric then
                                        shortestMetric = dist2D
                                        targetChar = char
                                    end
                                end
                            elseif AutoAimChargedToggle then
                                local dist3D = (tHead.Position - root.Position).Magnitude
                                if dist3D < shortestMetric then
                                    shortestMetric = dist3D
                                    targetChar = char
                                end
                            end
                        end
                    end
                end

                if not targetChar then return end
                local tHead = targetChar.Head
                local tVel = targetChar.HumanoidRootPart.Velocity
                
                local predictedPos = tHead.Position + (tVel * PredictionTime)
                local camPos = Camera.CFrame.Position
                local distToTarget = (predictedPos - camPos).Magnitude
                
                local finalPitch = 0

                if AutoAimNormalToggle then
                    local alpha = math.clamp((distToTarget - MinDistance) / (MaxDistance - MinDistance), 0, 1)
                    finalPitch = MinPitch + (MaxPitch - MinPitch) * alpha
                    
                elseif AutoAimChargedToggle then
                    local index = math.floor(distToTarget / 10)
                    finalPitch = PitchTable[index] or FallbackPitch
                end
                
                local dir = (predictedPos - camPos).Unit
                local yaw = math.atan2(dir.X, dir.Z)
                local pitchRad = math.rad(finalPitch)

                local look = Vector3.new(
                    math.sin(yaw) * math.cos(pitchRad),
                    math.sin(pitchRad),
                    math.cos(yaw) * math.cos(pitchRad)
                )

                Camera.CFrame = CFrame.new(camPos, camPos + look)
            end)
        end
    end)
end

lp.CharacterAdded:Connect(InitializeCharacter)
if lp.Character then
    InitializeCharacter(lp.Character)
end

ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Chase"):WaitForChild("ChaseMusicEvent").OnClientEvent:Connect(function(action)
       if chasetheme == "Default" or (chasetheme ~= "Mila - Compass" and chasetheme ~= "Close To Me") then return end
	local soundid = getSoundIdFromTheme()

	if action == "StartImmediate" then
		setupChaseMusic(soundid)

	elseif action == "FadeOut" then
		fadeTo(0, 10)

	elseif action == "FadeIn" then
		if chaseSound then
			fadeTo(1.2, 0)
		else
			setupChaseMusic(soundid)
		end
	end
end)

task.spawn(function()
while task.wait(0.02) do
  if antiFlingToggle then
     for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= lp and plr.Character then
            for _, part in ipairs(plr.Character:GetChildren()) do --descen
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
     end
  end
end
end)