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

local character
local hum
local root

local function uCR(char)
    character = char
    root = character:WaitForChild("HumanoidRootPart", 5)
    hum = character:WaitForChild("Humanoid", 5)
end

uCR(lp.Character or lp.CharacterAdded:Wait())
lp.CharacterAdded:Connect(function(newChar)
    uCR(newChar)
end)

local blacklist = {
    [2507060115] = true
}
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/azurelw/azurehub/refs/heads/main/main.lua"))()

local function getTag(name)
    if getgenv().PREMIUM_KEY == true then
        return "[ PREMIUM ]"
    end
    return "[ FREEMIUM ]"
end

local discordLink = "https://discord.gg/QmvpbPdw9J"

if blacklist[lp.UserId] then
    lp:Kick("Exploiting")
    return
end

local gid = 875557553
local bannedRanks = {
    ["Owner"] = true,
    ["Admin"] = true,
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
    Title = "Azure Hub | Flick ".. getTag(lp.Name),
    Author = "discord.gg/QmvpbPdw9J",
    Folder = "MurderMystery2Hub",
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
    Main = Tabs.Features:Tab({ Title = "| Main", Icon = "house" }),
    Esp = Tabs.Features:Tab({ Title = "|  ESP", Icon = "eye" }),
    Player = Tabs.Features:Tab({ Title = "|  Player", Icon = "users-round" }),
    Misc = Tabs.Features:Tab({ Title = "|  Misc", Icon = "layout-grid" }),
    Config = Tabs.Utilities:Tab({ Title = "|  Configuration", Icon = "settings" })
}

local updparagraph = Logs:Paragraph({
    Title = "Update Logs",
    Desc = "19.12.25\n[+] Flick",
    Locked = false,
    Buttons = {
        {
            Icon = "clipboard",
            Title = "Discord Server",
            Callback = function() setclipboard(discordLink) WindUI:Notify({ Title = "Discord Server", Content = "Link Copied!", Icon = "info", Duration = 2 }) end,
        }
    }
})

local AutoAimToggle = false
local FOVToggle = false
local FOVRadius = 30
local AimbotPart = "Head"
local AimbotSmoothness = 10
local TeamCheckToggle = false
local WallCheckToggle = false

local WalkToggle = false
local currentSpeed = 28
local Noclip = nil
local Clip = nil
local NoclipToggle = false

local antiAfkToggle = false
local FlingToggle = false
local antiFlingToggle = false
local flingThread

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

local function contains(tbl, val)
    if not tbl or type(tbl) ~= "table" then return false end
    for _, v in ipairs(tbl) do
        if v == val then return true end
    end
    return false
end

local function isPlayerObject(obj)
    if obj:IsA("Model") and obj:FindFirstChild("Head") and obj.Name ~= lp.Name then
        return true
    end
    return false
end

local function passesDropdownFilter(obj)
    if not selectedESPTypes or #selectedESPTypes == 0 then
        return false
    end
    if contains(selectedESPTypes, "Players") and isPlayerObject(obj) then return true end
    return false
end

local function getObjColor(obj)
    if isPlayerObject(obj) then return Color3.fromRGB(0, 255, 0) end
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
    
    if now - lR > rI then
        lR = now
        for _, obj in ipairs(workspace:GetChildren()) do
            if obj ~= lp.Character and passesDropdownFilter(obj) then 
                ensureAllFor(obj) 
            end
        end
    end

    local viewportSize = Camera.ViewportSize
    local myRoot = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")

    for obj, data in pairs(esp) do
        local color = getObjColor(obj)
        
        if not obj or not obj.Parent or not passesDropdownFilter(obj) then
            removeESP(obj)
            rootCache[obj] = nil
            continue
        end

        local worldPos = getRootPosition(obj)
        local screenPos, onScreen = Camera:WorldToViewportPoint(worldPos)
        local isVisible = onScreen and screenPos.Z > 0
        
        if tracers[obj] then
            tracers[obj].Visible = isVisible and ESPTracers
            if tracers[obj].Visible then
                tracers[obj].Color = color
                tracers[obj].From = Vector2.new(viewportSize.X / 2, viewportSize.Y)
                tracers[obj].To = Vector2.new(screenPos.X, screenPos.Y)
            end
        end

        if data.billboard then
            data.billboard.Enabled = isVisible and (ESPNames or ESPStuds)
            if data.billboard.Enabled and myRoot then
                local targetLabel = data.nameLabel or data.billboard:FindFirstChildOfClass("TextLabel")
                if targetLabel then
                     targetLabel.Visible = true
                     local dist = (Camera.CFrame.Position - worldPos).Magnitude
                     
                     if ESPNames and ESPStuds then
                         targetLabel.Text = obj.Name .. " (" .. string.format("%.0fm", dist) .. ")"
                     elseif ESPNames then
                         targetLabel.Text = obj.Name
                     elseif ESPStuds then
                         targetLabel.Text = string.format("%.0fm", dist)
                     end
                     targetLabel.TextColor3 = color
                end
            end
        end

        if boxes[obj] then
            local box = boxes[obj]
            local showBox = isVisible and ESPBoxes
            for _, line in pairs(box) do line.Visible = showBox; line.Color = color end
            if showBox then
                local size = (1 / screenPos.Z) * 1000 
                local w, h = size * 0.6, size
                local x, y = screenPos.X, screenPos.Y
                box.tl.From = Vector2.new(x-w, y-h); box.tl.To = Vector2.new(x+w, y-h)
                box.tr.From = Vector2.new(x+w, y-h); box.tr.To = Vector2.new(x+w, y+h)
                box.br.From = Vector2.new(x+w, y+h); box.br.To = Vector2.new(x-w, y+h)
                box.bl.From = Vector2.new(x-w, y+h); box.bl.To = Vector2.new(x-w, y-h)
            end
        end
        
        if data.highlight then
            data.highlight.FillColor = color
        end
    end
end)

Workspace.ChildAdded:Connect(function(child)
    task.wait(0.5)
    if passesDropdownFilter(child) then ensureAllFor(child) end
end)

Workspace.ChildRemoved:Connect(function(child)
    removeESP(child)
end)

local CoreGui = game:GetService("CoreGui")
local PlayerGui = lp:WaitForChild("PlayerGui")

local existing = CoreGui:FindFirstChild("FOVSys") or PlayerGui:FindFirstChild("FOVSys")
if existing then existing:Destroy() end

local FOVGui = Instance.new("ScreenGui")
FOVGui.Name = "FOVSys"
FOVGui.DisplayOrder = 10
FOVGui.ResetOnSpawn = false 
FOVGui.IgnoreGuiInset = true 

local success, err = pcall(function()
    FOVGui.Parent = CoreGui
end)
if not success then
    FOVGui.Parent = PlayerGui
end

local FOVFrame = Instance.new("Frame")
FOVFrame.Name = "FOVCircle"
FOVFrame.BackgroundTransparency = 1
FOVFrame.BorderSizePixel = 0
FOVFrame.AnchorPoint = Vector2.new(0.5, 0.5)
FOVFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
FOVFrame.Visible = false
FOVFrame.Parent = FOVGui

local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 1.5
UIStroke.Color = Color3.fromRGB(0, 255, 255)
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = FOVFrame

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = FOVFrame

local function isAlive(obj)
    local hum = obj:FindFirstChildOfClass("Humanoid")
    return hum and hum.Health > 0
end

function get_closest_target(range: number)
    local closest_part, closest_distance = nil, range;

    for _, player in (Players:GetPlayers()) do
        if (player == lp) then
            continue;
        end
        if (not character) then
            continue;
        end
        local humanoid = character:FindFirstChild("Humanoid");
        local head = character:FindFirstChild("Head");
        if (not head) or (not humanoid) or (humanoid.Health == 0) then
            continue;
        end
        local screen_position, on_screen = camera:WorldToViewportPoint(head.Position);
        if (not on_screen) then
            continue;
        end
        local distance = (Vector2.new(screen_position.X, screen_position.Y) - camera.ViewportSize / 2).Magnitude;
        if (distance < closest_distance) then
            closest_part = head;
            closest_distance = distance;
        end
    end

    return closest_part;
end

local function autoaim()
    RunService.Heartbeat:Connect(function()
        local Camera = workspace.CurrentCamera
        local screenCenter = Camera.ViewportSize / 2

        if FOVToggle then
            FOVFrame.Visible = true
            local diameter = FOVRadius * 2
            FOVFrame.Size = UDim2.new(0, diameter, 0, diameter)
        else
            FOVFrame.Visible = false
        end

        if not AutoAimToggle or not lp.Character then return end

        local nearestTarget = nil
        local shortestDistance = math.huge
        local myRoot = lp.Character:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end

        local function checkTarget(obj)
            if obj == lp.Character or not obj:IsA("Model") then return end
            if obj.Name == "deadbody" then return end
            if not isAlive(obj) then return end
            
            local targetPart = obj:FindFirstChild(AimbotPart)
            if targetPart then
                local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                
                if onScreen then
                    if FOVToggle then
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                        if dist > FOVRadius then return end
                    end
                elseif FOVToggle then 
                    return 
                end

                if WallCheckToggle then
                    local rayParams = RaycastParams.new()
                    rayParams.FilterDescendantsInstances = {lp.Character, obj}
                    local ray = workspace:Raycast(myRoot.Position, (targetPart.Position - myRoot.Position), rayParams)
                    if ray then return end
                end

                local mag = (targetPart.Position - myRoot.Position).Magnitude
                if mag < shortestDistance then
                    shortestDistance = mag
                    nearestTarget = obj
                end
            end
        end

        for _, obj in ipairs(workspace:GetChildren()) do checkTarget(obj) end
        if nearestTarget then
            local tRoot = nearestTarget:FindFirstChild("HumanoidRootPart")
            local tPart = nearestTarget:FindFirstChild(AimbotPart)
            
            if tRoot and tPart then
                local targetLook = CFrame.new(Camera.CFrame.Position, tPart.Position)
                if AimbotSmoothness > 0 then
                    Camera.CFrame = Camera.CFrame:Lerp(targetLook, 1 / AimbotSmoothness)
                else
                    Camera.CFrame = targetLook
                end
            end
        end
    end)
end

local function noclip()
	Clip = false
	if Noclip then Noclip:Disconnect() end
	Noclip = RunService.Stepped:Connect(function()
		if Clip == false and lp.Character then
			for _, v in ipairs(lp.Character:GetChildren()) do
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

local function applyBypassSpeed()
    task.spawn(function()
        while task.wait(0.2) do
            if not WalkToggle then continue end
            
            if hum then
                for _, conn in ipairs(getconnections(hum:GetPropertyChangedSignal("WalkSpeed"))) do
                    conn:Disable()
                end
                hum.WalkSpeed = currentSpeed
            end
        end
    end)
end
applyBypassSpeed()

local AimbotSection = TabHandles.Main:Section({ 
    Title = "Aimbot",
    Icon = "crosshair"
})
local AimbotHandle = AimbotSection:Toggle({
    Title = "Auto Aimbot",
    Desc = "Aims to enemies part that you can choose in aimbot settings.",
    Value = false,
    Callback = function(state)
        AutoAimToggle = state
        if state then autoaim() end
    end
})
local FOVHandle = AimbotSection:Toggle({
    Title = "Aimbot FOV",
    Desc = "Creates a FOV, if players inside aimbot would trigger.",
    Value = false,
    Callback = function(state)
        FOVToggle = state
    end
})

local SettingsSection = TabHandles.Main:Section({ 
    Title = "Aimbot Settings",
    Icon = "settings"
})
local AimbotPartHandle = SettingsSection:Dropdown({
       Title = "Target Part",
       Values = { "Head", "HumanoidRootPart" },
       Value = "Head",
       Multi = false,
       AllowNone = false,
       Callback = function(option)
             AimbotPart = option
       end
})
local AimbotSmoothnessHandle = SettingsSection:Slider({
       Title = "Camera Smoothness",
	Value = { Min = 0, Max = 50, Default = 10 },
	Callback = function(Value)
		AimbotSmoothness = tonumber(Value)
	end
})
local FOVRadiusHandle = SettingsSection:Slider({
       Title = "FOV Radius",
	Value = { Min = 10, Max = 150, Default = 30 },
	Callback = function(Value)
		FOVRadius = tonumber(Value)
	end
})
local WallCheckHandle = SettingsSection:Toggle({
    Title = "Wall Check?",
    Value = false,
    Callback = function(state)
        WallCheckToggle = state
    end
})

local ExploitsSection = TabHandles.Main:Section({ 
    Title = "Exploits",
    Icon = "cpu"
})
local NoRecoilHandle = ExploitsSection:Toggle({
    Title = "Silent Aim/Insta Hit",
    Desc = "Makes your bullet force * 1000, yk what silent aim stands for.",
    Value = false,
    Callback = function(state)
        if state then
            --[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
local workspace = game:GetService("Workspace");
local players = game:GetService("Players");

local local_player = players.LocalPlayer;
local camera = workspace.CurrentCamera;

local bullet_handler = require(game:GetService("ReplicatedStorage").ModuleScripts.GunModules.BulletHandler);

function get_closest_target(range: number)
    local closest_part, closest_distance = nil, range;

    for _, player in (players:GetPlayers()) do
        if (player == local_player) then
            continue;
        end
        local character = player.Character;
        if (not character) then
            continue;
        end
        local humanoid = character:FindFirstChild("Humanoid");
        local head = character:FindFirstChild("Head");
        if (not head) or (not humanoid) or (humanoid.Health == 0) then
            continue;
        end
        local screen_position, on_screen = camera:WorldToViewportPoint(head.Position);
        if (not on_screen) then
            continue;
        end
        local distance = (Vector2.new(screen_position.X, screen_position.Y) - camera.ViewportSize / 2).Magnitude;
        if (distance < closest_distance) then
            closest_part = head;
            closest_distance = distance;
        end
    end

    return closest_part;
end

local old = bullet_handler.Fire;
bullet_handler.Fire = function(data)
    local closest = get_closest_target(999);
    if (closest) then
        data.Force = data.Force * 1000;
        data.Direction = (closest.Position - data.Origin).Unit;
    end
    return old(data);
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
local FOVSliderHandle = TabHandles.Esp:Slider({
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
local ESPDropdownHandle = TabHandles.Esp:Dropdown({
       Title =  "ESP's",
       Values = { "Players" },
       Value = { "" },
       Multi = true,
       AllowNone = true,
       Callback = function(option)
             selectedESPTypes = option
       end
})
local ESPHighlightHandle = TabHandles.Esp:Toggle({
       Title = "Highlight objects",
       Desc = "Highlights objects, most useful feature.",
       Value = false,
       Callback = function(state)
             ESPHighlight = state
       end
})
local ESPTracersHandle = TabHandles.Esp:Toggle({
       Title = "Show Tracers",
       Desc = "Adds line pointing to your ESP object.",
       Value = false,
       Callback = function(state)
             ESPTracers = state
       end
})
local ESPBoxesHandle = TabHandles.Esp:Toggle({
       Title = "Show Boxes",
       Desc = "Adds box showing the hitbox of your ESP object.",
       Value = false,
       Callback = function(state)
             ESPBoxes = state
       end
})
local ESPNamesHandle = TabHandles.Esp:Toggle({
       Title = "Show Names",
       Desc = "Adds name of object above ur object's head.",
       Value = false,
       Callback = function(state)
             ESPNames = state
       end
})
local ESPStudsHandle = TabHandles.Esp:Toggle({
       Title = "Show Studs",
       Desc = "Adds studs above ur objects head, shows how far you're away from the object.",
       Value = false,
       Callback = function(state)
             ESPStuds = state
       end
})

local NoclipHandle = TabHandles.Player:Toggle({
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
local WsToggleHandle = TabHandles.Player:Toggle({
	Title = "WalkSpeed Changer",
	Desc = "Set your speed to your preference.",
	Value = false,
	Callback = function(state)
		WalkToggle = state
	end
})
local WsSliderHandle = TabHandles.Player:Slider({
       Title = "WalkSpeed",
	Value = { Min = 16, Max = 100, Default = 16 },
	Callback = function(Value)
		currentSpeed = Value
	end
})

local idConn
local ProtectIdentityHandle = TabHandles.Misc:Toggle({
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
local antiAfkHandle = TabHandles.Misc:Toggle({
    Title = "Anti AFK",
    Desc = "If enabled, jumps every minute so you wouldn't get kicked out for AFK.",
    Value = false,
    Callback = function(state)
        antiAfkToggle = state
    end
})

local antiFlingHandle = TabHandles.Misc:Toggle({
    Title = "Anti Fling",
    Desc = "If enabled, no one could fling you off map.",
    Value = false,
    Callback = function(state)
        antiFlingToggle = state
        if not state then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= lp and plr.Character then
                    for _, part in ipairs(plr.Character:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = true
                        end
                    end
                end
            end
        end
    end
})

local FlingHandle = TabHandles.Misc:Toggle({
    Title = "Touch Fling",
    Desc = "If enabled, you could fling anyone in map by touching them.",
    Value = false,
    Callback = function(state)
        FlingToggle = state
        if state then fling() end
    end
})

local antiAdminToggle = false
local antiAdminHandle = TabHandles.Misc:Toggle({
    Title = "Anti Admin",
    Desc = "If enabled, kicks you out if there's admin in your experience.",
    Value = false,
    Callback = function(state)
        antiAdminToggle = state
    end
})

task.spawn(function()
	while task.wait(1) do
		if antiAdminToggle then
			for _, plr in ipairs(Players:GetPlayers()) do
				if plr ~= lp and (table.find(blacklist, plr.UserId) or bannedRanks[plr:GetRoleInGroup(gid)]) then
					lp:Kick("Admin detected: " .. plr.Name)
				end
			end
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
            configFile:Register("FOVSliderHandle", FOVSliderHandle)
            configFile:Register("FOVRadiusHandle", FOVRadiusHandle)
            configFile:Register("AimbotHandle", AimbotHandle)
                configFile:Register("FOVHandle", FOVHandle)
                configFile:Register("AimbotPartHandle", AimbotPartHandle)
                configFile:Register("AimbotSmoothnessHandle", AimbotSmoothnessHandle)
                configFile:Register("TeamCheckHandle", TeamCheckHandle)
                configFile:Register("WallCheckHandle", WallCheckHandle)
            configFile:Register("NoRecoilHandle", NoRecoilHandle)
            configFile:Register("NoCooldownHandle", NoCooldownHandle)
            configFile:Register("ESPDropdownHandle", ESPDropdownHandle)
            configFile:Register("ESPHighlightHandle", ESPHighlightHandle)
            configFile:Register("ESPTracersHandle", ESPTracersHandle)
            configFile:Register("ESPBoxesHandle", ESPBoxesHandle)
            configFile:Register("ESPStudsHandle", ESPStudsHandle)
            configFile:Register("NoclipHandle", NoclipHandle)
            configFile:Register("WsToggleHandle", WsToggleHandle)
            configFile:Register("WsSliderHandle", WsSliderHandle)
            configFile:Register("ProtectIdentityHandle", ProtectIdentityHandle)
            configFile:Register("antiAfkHandle", antiAfkHandle)
            configFile:Register("antiFlingHandle", antiFlingHandle)
            configFile:Register("FlingHandle", FlingHandle)
            configFile:Register("antiAdminHandle", antiAdminHandle)
        end
    end
})

local ConfigManager = Window.ConfigManager
local configFile
local autoLoadFile = "AZUREHUB_ALC_F.txt"
local ALC = false

if ConfigManager then
    ConfigManager:Init(Window)
    
    configFile = ConfigManager:CreateConfig(configName)
    configFile:Register("FOVSliderHandle", FOVSliderHandle)
    configFile:Register("FOVRadiusHandle", FOVRadiusHandle)
    configFile:Register("AimbotHandle", AimbotHandle)
                configFile:Register("FOVHandle", FOVHandle)
                configFile:Register("AimbotPartHandle", AimbotPartHandle)
                configFile:Register("AimbotSmoothnessHandle", AimbotSmoothnessHandle)
                configFile:Register("TeamCheckHandle", TeamCheckHandle)
                configFile:Register("WallCheckHandle", WallCheckHandle)
    configFile:Register("NoRecoilHandle", NoRecoilHandle)
    configFile:Register("NoCooldownHandle", NoCooldownHandle)
    configFile:Register("ESPDropdownHandle", ESPDropdownHandle)
    configFile:Register("ESPHighlightHandle", ESPHighlightHandle)
    configFile:Register("ESPTracersHandle", ESPTracersHandle)
    configFile:Register("ESPBoxesHandle", ESPBoxesHandle)
    configFile:Register("ESPStudsHandle", ESPStudsHandle)
    configFile:Register("NoclipHandle", NoclipHandle)
    configFile:Register("WsToggleHandle", WsToggleHandle)
    configFile:Register("WsSliderHandle", WsSliderHandle)
    configFile:Register("ProtectIdentityHandle", ProtectIdentityHandle)
    configFile:Register("antiAfkHandle", antiAfkHandle)
    configFile:Register("antiFlingHandle", antiFlingHandle)
    configFile:Register("FlingHandle", FlingHandle)
    configFile:Register("antiAdminHandle", antiAdminHandle)
    
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
                configFile:Register("FOVSliderHandle", FOVSliderHandle)
                configFile:Register("FOVRadiusHandle", FOVRadiusHandle)
                configFile:Register("AimbotHandle", AimbotHandle)
                configFile:Register("FOVHandle", FOVHandle)
                configFile:Register("AimbotPartHandle", AimbotPartHandle)
                configFile:Register("AimbotSmoothnessHandle", AimbotSmoothnessHandle)
                configFile:Register("TeamCheckHandle", TeamCheckHandle)
                configFile:Register("WallCheckHandle", WallCheckHandle)
                configFile:Register("NoRecoilHandle", NoRecoilHandle)
                configFile:Register("NoCooldownHandle", NoCooldownHandle)
                configFile:Register("ESPDropdownHandle", ESPDropdownHandle)
                configFile:Register("ESPHighlightHandle", ESPHighlightHandle)
                configFile:Register("ESPTracersHandle", ESPTracersHandle)
                configFile:Register("ESPBoxesHandle", ESPBoxesHandle)
                configFile:Register("ESPStudsHandle", ESPStudsHandle)
                configFile:Register("NoclipHandle", NoclipHandle)
                configFile:Register("WsToggleHandle", WsToggleHandle)
                configFile:Register("WsSliderHandle", WsSliderHandle)
                configFile:Register("ProtectIdentityHandle", ProtectIdentityHandle)
                configFile:Register("antiAfkHandle", antiAfkHandle)
                configFile:Register("antiFlingHandle", antiFlingHandle)
                configFile:Register("FlingHandle", FlingHandle)
                configFile:Register("antiAdminHandle", antiAdminHandle)
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
        local success, err = pcall(function()
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

task.spawn(function()
while task.wait(0.02) do
  if antiFlingToggle then
     for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= lp and plr.Character then
            for _, part in ipairs(plr.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
     end
  end
end
end)