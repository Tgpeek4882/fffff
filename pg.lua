local cloneref = cloneref or function(o) return o end
local Players = cloneref(game:GetService("Players"))
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local PoopEvent = ReplicatedStorage:WaitForChild("PoopEvent")
local PoopCharge = ReplicatedStorage:WaitForChild("PoopChargeStart")
local PoopEventSold = ReplicatedStorage:WaitForChild("PoopSold")
local VIM = cloneref(game:GetService("VirtualInputManager"))
local RunService = cloneref(game:GetService("RunService"))
local lp = Players.LocalPlayer
local character = lp.Character or lp.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")
local username = lp.Name
local humanoid = character:WaitForChild("Humanoid")
local gui = lp:WaitForChild("PlayerGui")
local container = gui:WaitForChild("PoopBalancingUI"):WaitForChild("BalancingContainer")
local bar = container:WaitForChild("MovingBar")
local zone = container:WaitForChild("TargetZone")

local blacklist = {
    [2204711352] = true,
    [8555525313] = true
}

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

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

print("Loaded!\nAzureHub By Cat\nDiscord: https://discord.gg/QmvpbPdw9J")

WindUI:SetNotificationLower(true)
local Window = WindUI:CreateWindow({
    Title = "Azure Hub | Poop Game ".. getTag(lp.Name),
    Author = "discord.gg/QmvpbPdw9J",
    Folder = "PoopHub",
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
     Main = Tabs.Features:Tab({ Title = "|  Main", Icon = "house" }),
     Player = Tabs.Features:Tab({ Title = "|  Player", Icon = "users-round" }),
     Exploit = Tabs.Features:Tab({ Title = "|  Exploits", Icon = "cpu" }),
     Misc = Tabs.Features:Tab({ Title = "|  Misc", Icon = "layout-grid" }),
     Config = Tabs.Utilities:Tab({ Title = "|  Configuration", Icon = "settings" })
}

local clicked = false
local farmToggle = false
local walkToggle = false
local currentSpeed = 28
local sellToggle = false
local sellSpeed = 1
local Noclip = nil
local Clip = nil
local NoclipToggle = false
local instaToggle = false
local instaSpeed = 0.30
local removeToggle = false

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

local poopToggleHandle = TabHandles.Main:Toggle({
	Title = "Auto Farm Poop",
	Value = false,
	Callback = function(state)
	       farmToggle = state
	end
})
local sellToggleHandle = TabHandles.Main:Toggle({
	Title = "Auto Sell Inventory",
	Value = false,
	Callback = function(state)
	       sellToggle = state
	end
})
local sellSliderHandle = TabHandles.Main:Slider({
       Title = "Auto Sell Interval",
       Step = 1,
	Value = { Min = 1, Max = 180, Default = 1 },
	Callback = function(Value)
		sellSpeed = Value
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
	Value = { Min = 28, Max = 100, Default = 28 },
	Callback = function(Value)
		currentSpeed = Value
	end
})

local instaPoopHandle = TabHandles.Exploit:Toggle({
        Title = "Instant Poop",
	Value = false,
	Callback = function(state)
		instaToggle = state
	end
})
local instaIntHandle = TabHandles.Exploit:Slider({
       Title = "Instant Poop Interval",
       Desc = "Minimum - 30, lower = detected.",
       Step = 0.01,
	Value = { Min = 0.30, Max = 10, Default = 0.30 },
	Flag = "instaSpeed",
	Callback = function(Value)
		instaSpeed = Value
	end
})
local removePoopHandle = TabHandles.Exploit:Toggle({
	Title = "Remove Poops",
	Desc = "Reduces lag a little bit, reccomended to use with instant poop.",
	Value = false,
	Callback = function(state)
		removeToggle = state
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
	while true do
		if antiAfkToggle then
			root.CFrame = root.CFrame + Vector3.new(0, 3, 0)
		end
		task.wait(60)
	end
end)

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
			if table.find(blacklist, plr.UserId) then
				lp:Kick("Admin detected: " .. plr.Name)
			end
		end
	    end
	end
end)

task.spawn(function()
    while true do
        task.wait(0.02)
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
            configFile:Register("poopToggleHandle", poopToggleHandle)
            configFile:Register("sellToggleHandle", sellToggleHandle)
            configFile:Register("sellSliderHandle", sellSliderHandle)
            configFile:Register("NoclipHandle", NoclipHandle)
            configFile:Register("WsToggleHandle", WsToggleHandle)
            configFile:Register("WsSliderHandle", WsSliderHandle)
            configFile:Register("instaPoopHandle", instaPoopHandle)
            configFile:Register("instaIntHandle", instaIntHandle)
            configFile:Register("removePoopHandle", removePoopHandle)
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
local autoLoadFile = "AZUREHUB_ALC_PG.txt"
local ALC = false

if ConfigManager then
    ConfigManager:Init(Window)
    
    configFile = ConfigManager:CreateConfig(configName)
    configFile:Register("poopToggleHandle", poopToggleHandle)
    configFile:Register("sellToggleHandle", sellToggleHandle)
            configFile:Register("sellSliderHandle", sellSliderHandle)
            configFile:Register("NoclipHandle", NoclipHandle)
            configFile:Register("WsToggleHandle", WsToggleHandle)
            configFile:Register("WsSliderHandle", WsSliderHandle)
            configFile:Register("instaPoopHandle", instaPoopHandle)
            configFile:Register("instaIntHandle", instaIntHandle)
            configFile:Register("removePoopHandle", removePoopHandle)
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
                configFile:Register("poopToggleHandle", poopToggleHandle)
                configFile:Register("sellToggleHandle", sellToggleHandle)
            configFile:Register("sellSliderHandle", sellSliderHandle)
            configFile:Register("NoclipHandle", NoclipHandle)
            configFile:Register("WsToggleHandle", WsToggleHandle)
            configFile:Register("WsSliderHandle", WsSliderHandle)
            configFile:Register("instaPoopHandle", instaPoopHandle)
            configFile:Register("instaIntHandle", instaIntHandle)
            configFile:Register("removePoopHandle", removePoopHandle)
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

RunService.RenderStepped:Connect(function()
	if not farmToggle then return end
	if not bar or not zone then return end

	local barX = bar.AbsolutePosition.X + bar.AbsoluteSize.X / 2
	local zoneStart = zone.AbsolutePosition.X
	local zoneEnd = zoneStart + zone.AbsoluteSize.X

	if barX >= zoneStart and barX <= zoneEnd then
		if not clicked then
			local clickX = zoneStart + zone.AbsoluteSize.X / 2
			local clickY = zone.AbsolutePosition.Y + zone.AbsoluteSize.Y / 2

			VIM:SendMouseButtonEvent(clickX, clickY, 0, true, game, 0)
			VIM:SendMouseButtonEvent(clickX, clickY, 0, false, game, 0)

			clicked = true
		end
	else
		clicked = false
	end
end)

task.spawn(function()
	while true do
		if WalkToggle then
			humanoid.WalkSpeed = currentSpeed
		end
		wait()
	end
end)

task.spawn(function()
	while true do
		if instaToggle then
			local args = {1}
			PoopCharge:FireServer(unpack(args))
			PoopEvent:FireServer(unpack(args))
		end
		task.wait(instaSpeed)
	end
end)

task.spawn(function()
	while true do
		if removeToggle then
			for _, obj in pairs(workspace:GetChildren()) do
				local name = string.lower(obj.Name)
				if name:find("poop") and not name:find("poopsellernpc") then
					pcall(function()
						obj:Destroy()
					end)
				end
			end
		end
		task.wait(0.05)
	end
end)

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