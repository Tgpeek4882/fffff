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
local ProximityPromptService = cloneref(game:GetService("ProximityPromptService"))

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

local function getTag(name)
    if getgenv().PREMIUM_KEY == true then
        return "[ PREMIUM ]"
    end
    return "[ FREEMIUM ]"
end

local discordLink = "https://discord.gg/QmvpbPdw9J"
local blacklist = {}
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/azurelw/azurehub/refs/heads/main/main.lua"))()

if blacklist[lp.UserId] then
    lp:Kick("Exploiting")
    return
end

local gid = 3461453
local bannedRanks = {
    ["Community Staff"] = true,
    ["Tester"] = true,
    ["Moderator"] = true,
    ["Contributor"] = true,
    ["Scripter"] = true,
    ["Builder"] = true
}
local rankName = lp:GetRoleInGroup(gid)
if bannedRanks[rankName] then
    lp:Kick("Exploiting")
end

WindUI:SetNotificationLower(true)
local Window = WindUI:CreateWindow({
    Title = "Azure Hub | Rivals ".. getTag(lp.Name),
    Author = "discord.gg/QmvpbPdw9J",
    Folder = "RivalsHub",
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
    Title = "Open Azure Hub ".. getTag(lp.Name),
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
    Player = Tabs.Features:Tab({ Title = "| Player", Icon = "users-round" }),
    Esp = Tabs.Features:Tab({ Title = "| ESP", Icon = "eye" }),
    Misc = Tabs.Features:Tab({ Title = "| Misc", Icon = "layout-grid" }),
    Config = Tabs.Utilities:Tab({ Title = "| Configuration", Icon = "settings" })
}

local updparagraph = Logs:Paragraph({
    Title = "Update Logs",
    Desc = "16.01.26\n[+] Rivals",
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

local cdups = {}
local spups = {}
local rcups = {}

local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/linemaster2/esp-library/main/library.lua"))();
ESP.Enabled = false;
ESP.ShowBox = false;
ESP.ShowName = false;
ESP.ShowHealth = false;
ESP.ShowTracer = false;
ESP.ShowDistance = false;
ESP.ShowSkeletons = false;
local ESP_SETTINGS = {
    BoxOutlineColor = Color3.new(1, 1, 1),
    BoxColor = Color3.new(1, 1, 1),
    NameColor = Color3.new(1, 1, 1),
    HealthOutlineColor = Color3.new(0, 0, 0),
    HealthHighColor = Color3.new(0, 1, 0),
    HealthLowColor = Color3.new(1, 0, 0),
    CharSize = Vector2.new(4, 6),
    Teamcheck = true,
    WallCheck = false,
    Enabled = false,
    ShowBox = false,
    BoxType = "2D",
    ShowName = false,
    ShowHealth = false,
    ShowDistance = false,
    ShowSkeletons = false,
    ShowTracer = false,
    TracerColor = Color3.new(1, 1, 1), 
    TracerThickness = 2,
    SkeletonsColor = Color3.new(1, 1, 1),
    TracerPosition = "Bottom",
}
    
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

local TargetParent = (gethui and gethui()) or (pcall(function() return game.CoreGui.Name end) and game.CoreGui) or lp.PlayerGui
local existing = TargetParent:FindFirstChild("FOVSys")
if existing then existing:Destroy() end

local FOVGui = Instance.new("ScreenGui")
FOVGui.Name = "FOVSys"
FOVGui.DisplayOrder = 10
FOVGui.ResetOnSpawn = false 
FOVGui.IgnoreGuiInset = true 
FOVGui.Parent = TargetParent

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
UIStroke.Color = Color3.fromRGB(255, 255, 255)
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
        local screen_position, on_screen = Camera:WorldToViewportPoint(head.Position);
        if (not on_screen) then
            continue;
        end
        local distance = (Vector2.new(screen_position.X, screen_position.Y) - Camera.ViewportSize / 2).Magnitude;
        if (distance < closest_distance) then
            closest_part = head;
            closest_distance = distance;
        end
    end

    return closest_part;
end

local function autoaim()
   RunService.RenderStepped:Connect(function()
        local screenCenter = Camera.ViewportSize / 2

        if FOVToggle then
            FOVFrame.Visible = true
            local diameter = FOVRadius * 2
            FOVFrame.Size = UDim2.new(0, diameter, 0, diameter)
            FOVFrame.Position = UDim2.new(0, screenCenter.X, 0, screenCenter.Y)
        else
            FOVFrame.Visible = false
        end
        if not AutoAimToggle or not lp.Character then return end
        
        local myRoot = lp.Character:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end
        
        local nearestTarget = nil
        local shortestDistance = math.huge

        for _, obj in ipairs(workspace:GetChildren()) do
            if obj ~= lp.Character and obj:IsA("Model") and isAlive(obj) then
                local targetPart = obj:FindFirstChild(AimbotPart)
                
                if targetPart then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                    local dist2D = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                    
                    local inFOV = (not FOVToggle) or (onScreen and dist2D <= FOVRadius)
                    
                    if inFOV then
                        local isVisible = true
                        if WallCheckToggle then
                            local rayParams = RaycastParams.new()
                            rayParams.FilterDescendantsInstances = {lp.Character, obj}
                            rayParams.FilterType = Enum.RaycastFilterType.Exclude
                            
                            local ray = workspace:Raycast(myRoot.Position, (targetPart.Position - myRoot.Position), rayParams)
                            if ray then isVisible = false end
                        end
                        
                        if isVisible then
                            local mag = (targetPart.Position - myRoot.Position).Magnitude
                            if mag < shortestDistance then
                                shortestDistance = mag
                                nearestTarget = obj
                            end
                        end
                    end
                end
            end
        end
        
        if nearestTarget then
            local tPart = nearestTarget:FindFirstChild(AimbotPart)
            if tPart then
                local currentPos = Camera.CFrame.Position
                local targetLook = CFrame.lookAt(currentPos, tPart.Position)

                if AimbotSmoothness > 0 then
                    Camera.CFrame = Camera.CFrame:Lerp(targetLook, 1 / AimbotSmoothness)
                else
                    Camera.CFrame = targetLook
                end
                
                local screenPos, onScreen = Camera:WorldToViewportPoint(tPart.Position)
                if onScreen then
                    local relativeX = (screenPos.X - screenCenter.X)
                    local relativeY = (screenPos.Y - screenCenter.Y)
                    

                    local mouseSmoothness = (AimbotSmoothness > 0) and AimbotSmoothness or 1
                    mousemoverel(relativeX / mouseSmoothness, relativeY / mouseSmoothness)
                end
            end
        end
    end)
end

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
local NoCooldownHandle = ExploitsSection:Toggle({
    Title = "No Cooldown",
    Value = false,
    Callback = function(state)
        if state then
            for _, gcVal in pairs(getgc(true)) do
                if type(gcVal) == "table" and rawget(gcVal, "ShootCooldown") then
                    if cdups[gcVal] == nil then
                        cdups[gcVal] = gcVal["ShootCooldown"]
                    end
                    gcVal["ShootCooldown"] = 0
                end
            end
        else
            for tbl, originalVal in pairs(cdups) do
                if tbl and rawget(tbl, "ShootCooldown") then
                    tbl["ShootCooldown"] = originalVal
                end
            end
            cdups = {} 
        end
    end
})
local NoSpreadHandle = ExploitsSection:Toggle({
    Title = "No Spread",
    Value = false,
    Callback = function(state)
        if state then
            for _, gcVal in pairs(getgc(true)) do
                if type(gcVal) == "table" and rawget(gcVal, "ShootSpread") then
                    if spups[gcVal] == nil then
                        spups[gcVal] = gcVal["ShootSpread"]
                    end
                    gcVal["ShootSpread"] = 0
                end
            end
        else
            for tbl, originalVal in pairs(spups) do
                if tbl and rawget(tbl, "ShootSpread") then
                    tbl["ShootSpread"] = originalVal
                end
            end
            spups = {}
        end
    end
})
local NoRecoilHandle = ExploitsSection:Toggle({
    Title = "No Recoil",
    Value = false,
    Callback = function(state)
        if state then
            for _, gcVal in pairs(getgc(true)) do
                if type(gcVal) == "table" and rawget(gcVal, "ShootRecoil") then
                    if rcups[gcVal] == nil then
                        rcups[gcVal] = gcVal["ShootRecoil"]
                    end
                    gcVal["ShootRecoil"] = 0
                end
            end
        else
            for tbl, originalVal in pairs(rcups) do
                if tbl and rawget(tbl, "ShootRecoil") then
                    tbl["ShootRecoil"] = originalVal
                end
            end
            rcups = {}
        end
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
		if state then applyBypassSpeed() end
	end
})
local WsSliderHandle = TabHandles.Player:Slider({
       Title = "WalkSpeed",
	Value = { Min = 16, Max = 300, Default = 16 },
	Callback = function(Value)
		currentSpeed = Value
	end
})

local ESPHighlightHandle = TabHandles.Esp:Toggle({
       Title = "ESP Enabled?",
       Value = false,
       Callback = function(state)
             ESP.Enabled = state
       end
})
local ESPTracersHandle = TabHandles.Esp:Toggle({
       Title = "Show Tracers",
       Desc = "Adds line pointing to your object.",
       Value = false,
       Callback = function(state)
             ESP.ShowTracer = state
       end
})
local ESPBoxesHandle = TabHandles.Esp:Toggle({
       Title = "Show Boxes",
       Desc = "Adds box showing the hitbox of your ESP object.",
       Value = false,
       Callback = function(state)
             ESP.ShowBox = state
       end
})
local ESPNamesHandle = TabHandles.Esp:Toggle({
       Title = "Show Names",
       Desc = "Adds name of object above your object's head.",
       Value = false,
       Callback = function(state)
             ESP.ShowName = state
       end
})
local ESPStudsHandle = TabHandles.Esp:Toggle({
       Title = "Show Studs",
       Desc = "Adds studs above ur objects head, shows how far you're away from the object.",
       Value = false,
       Callback = function(state)
             ESP.ShowDistance = state
       end
})
local ESPSkeHandle = TabHandles.Esp:Toggle({
       Title = "Show Skeletons",
       Desc = "Adds skeletons to your object.",
       Value = false,
       Callback = function(state)
             ESP.ShowSkeletons = state
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
            configFile:Register("WsToggleHandle", WsToggleHandle)
            configFile:Register("WsSliderHandle", WsSliderHandle)
            configFile:Register("FOVSliderHandle", FOVSliderHandle)
    configFile:Register("FOVRadiusHandle", FOVRadiusHandle)
    configFile:Register("AimbotHandle", AimbotHandle)
    configFile:Register("NoCooldownHandle", NoCooldownHandle)
                configFile:Register("NoSpreadHandle", NoSpreadHandle)
                configFile:Register("NoRecoilHandle", NoRecoilHandle)
    configFile:Register("FOVHandle", FOVHandle)
    configFile:Register("AimbotPartHandle", AimbotPartHandle)
                configFile:Register("AimbotSmoothnessHandle", AimbotSmoothnessHandle)
    configFile:Register("TeamCheckHandle", TeamCheckHandle)
    configFile:Register("WallCheckHandle", WallCheckHandle)
    configFile:Register("ESPHighlightHandle", ESPHighlightHandle)
    configFile:Register("ESPTracersHandle", ESPTracersHandle)
    configFile:Register("ESPBoxesHandle", ESPBoxesHandle)
    configFile:Register("ESPStudsHandle", ESPStudsHandle)
    configFile:Register("ESPSkeHandle", ESPSkeHandle)
    configFile:Register("ESPNamesHandle", ESPNamesHandle)
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
local targetFile = "rhub.txt"
local ALC = false

if ConfigManager then
    ConfigManager:Init(Window)
    configFile = ConfigManager:CreateConfig(configName)
    configFile:Register("NoclipHandle", NoclipHandle)
    configFile:Register("WsToggleHandle", WsToggleHandle)
    configFile:Register("WsSliderHandle", WsSliderHandle)
    configFile:Register("FOVSliderHandle", FOVSliderHandle)
    configFile:Register("FOVRadiusHandle", FOVRadiusHandle)
    configFile:Register("AimbotHandle", AimbotHandle)
    configFile:Register("NoCooldownHandle", NoCooldownHandle)
                configFile:Register("NoSpreadHandle", NoSpreadHandle)
                configFile:Register("NoRecoilHandle", NoRecoilHandle)
    configFile:Register("FOVHandle", FOVHandle)
    configFile:Register("AimbotPartHandle", AimbotPartHandle)
                configFile:Register("AimbotSmoothnessHandle", AimbotSmoothnessHandle)
    configFile:Register("TeamCheckHandle", TeamCheckHandle)
    configFile:Register("WallCheckHandle", WallCheckHandle)
    configFile:Register("ESPHighlightHandle", ESPHighlightHandle)
    configFile:Register("ESPTracersHandle", ESPTracersHandle)
    configFile:Register("ESPBoxesHandle", ESPBoxesHandle)
    configFile:Register("ESPStudsHandle", ESPStudsHandle)
    configFile:Register("ESPSkeHandle", ESPSkeHandle)
    configFile:Register("ESPNamesHandle", ESPNamesHandle)
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
                configFile:Register("NoclipHandle", NoclipHandle)
                configFile:Register("WsToggleHandle", WsToggleHandle)
                configFile:Register("WsSliderHandle", WsSliderHandle)
                configFile:Register("FOVSliderHandle", FOVSliderHandle)
                configFile:Register("NoCooldownHandle", NoCooldownHandle)
                configFile:Register("NoSpreadHandle", NoSpreadHandle)
                configFile:Register("NoRecoilHandle", NoRecoilHandle)
    configFile:Register("FOVRadiusHandle", FOVRadiusHandle)
    configFile:Register("AimbotHandle", AimbotHandle)
    configFile:Register("FOVHandle", FOVHandle)
    configFile:Register("AimbotPartHandle", AimbotPartHandle)
                configFile:Register("AimbotSmoothnessHandle", AimbotSmoothnessHandle)
    configFile:Register("TeamCheckHandle", TeamCheckHandle)
    configFile:Register("WallCheckHandle", WallCheckHandle)
    configFile:Register("ESPHighlightHandle", ESPHighlightHandle)
    configFile:Register("ESPTracersHandle", ESPTracersHandle)
    configFile:Register("ESPBoxesHandle", ESPBoxesHandle)
    configFile:Register("ESPStudsHandle", ESPStudsHandle)
    configFile:Register("ESPSkeHandle", ESPSkeHandle)
    configFile:Register("ESPNamesHandle", ESPNamesHandle)
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
            writefile(targetFile, tostring(state))
        end
    })

    if isfile(targetFile) and readfile(targetFile) == "true" then
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