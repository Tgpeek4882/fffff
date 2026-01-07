local cloneref = cloneref or function(o) return o end
local position = nil
local Players = cloneref(game:GetService("Players"))
local RunService = cloneref(game:GetService("RunService"))
local lp = Players.LocalPlayer
local character = lp.Character or lp.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")
local username = lp.Name
local humanoid
position = root.Position

local blacklist = {}
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

local gid = 33857612
local bannedRanks = {
    ["Developer"] = true,
    ["Admin"] = true,
    ["Owner"] = true
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
    Title = "Azure Hub | Scary Sushi ".. getTag(lp.Name),
    Author = "discord.gg/QmvpbPdw9J",
    Folder = "ScaryHub",
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
Window:SetToggleKey(Enum.KeyCode.K)

local Logs = Window:Tab({ Title = "|  Update Logs", Icon = "scroll-text" })
Window:Divider()

local Tabs = {
    Features = Window:Section({ Title = "Features", Opened = true }),
    Utilities = Window:Section({ Title = "Utilities", Opened = true })
}

local TabHandles = {
     Main = Tabs.Features:Tab({ Title = "|  Teleports", Icon = "orbit" }),
     Player = Tabs.Features:Tab({ Title = "|  Player", Icon = "users-round" }),
     Misc = Tabs.Features:Tab({ Title = "|  Misc", Icon = "layout-grid" }),
     Config = Tabs.Utilities:Tab({ Title = "|  Configuration", Icon = "settings" })
}

local updparagraph = Logs:Paragraph({
    Title = "Update Logs",
    Desc = "13.07.25\n[+] Scary Sushi\n[/] Fixed Teleport",
    Locked = false,
    Buttons = {
        {
            Icon = "clipboard",
            Title = "Discord Server",
            Callback = function() setclipboard(discordLink) WindUI:Notify({ Title = "Discord Server", Content = "Link Copied!", Icon = "info", Duration = 2 }) end,
        }
    }
})

local antiAfkToggle = false
local NoclipToggle = false
local WalkToggle = false
local fastSprintSpeed = 28
local instantInteractEnabled = false
local interactLoop
local Noclip = nil
local Clip = nil

local function getIngredientFolder()
	local player = game.Players.LocalPlayer
	local ordersFolder = player:WaitForChild("PlayerGui"):WaitForChild("Orders"):WaitForChild("Orders")

	for _, order in ipairs(ordersFolder:GetChildren()) do
		local success, ingredients = pcall(function()
			return order:WaitForChild("Ingredients", 2)
		end)
		if success and ingredients then
			return ingredients
		end
	end

	return nil
end

function teleportToNeededBeetle()
	local player = game.Players.LocalPlayer
	local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if not root then return end

	local beetlesFolder = workspace.Forest.BeetleWaypoints.Beetles

	local ingredientFolder = nil
	for i = 0, 10000 do
		local order = player:FindFirstChild("PlayerGui")
			and player.PlayerGui:FindFirstChild("Orders")
			and player.PlayerGui.Orders:FindFirstChild("Orders")
			and player.PlayerGui.Orders.Orders:FindFirstChild(tostring(i))
		
		if order and order:FindFirstChild("Ingredients") then
			ingredientFolder = order.Ingredients
			break
		end
	end

	if not ingredientFolder then
		print("No Ingredients folder found in any order.")
		return
	end

	local beetleMap = {
		["BlueBeetle"] = "beetle_blue",
		["YellowBeetle"] = "beetle_yellow",
		["PurpleBeetle"] = "beetle_purple",
		["GreenBeetle"] = "beetle_green"
	}

	for ingredientName, beetleModelName in pairs(beetleMap) do
		if ingredientFolder:FindFirstChild(ingredientName) then
			local beetleModel = beetlesFolder:FindFirstChild(beetleModelName)
			if beetleModel then
				local target = beetleModel:FindFirstChild("HumanoidRootPart") or beetleModel:FindFirstChildWhichIsA("BasePart")
				if target then
					root.CFrame = target.CFrame + Vector3.new(0, 5, 0)

					task.delay(0.25, function()
						for _, v in pairs(beetleModel:GetDescendants()) do
							if v:IsA("ProximityPrompt") then
								fireproximityprompt(v)
								root.CFrame = CFrame.new(position)
								break
							end
						end
					end)

					break
				end
			end
		end
	end
end

function teleportToNeededFish(player)
	local fishModel = nil
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("Model") and string.lower(obj.Name) == "fish" then
			fishModel = obj
			break
		end
	end

	if not fishModel then
		print("No fish model found in workspace.")
		return
	end

	root.CFrame = fishModel:GetPivot() + Vector3.new(0, 5, 0)

	task.delay(0.25, function()
		for _, part in ipairs(fishModel:GetDescendants()) do
			if part:IsA("ProximityPrompt") then
				fireproximityprompt(part)
				root.CFrame = CFrame.new(position)
				break
			end
		end
	end)
end

function teleportToNeededJelly(player)
	local fishModel = nil
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("Model") and string.lower(obj.Name) == "jellyfish" then
			fishModel = obj
			break
		end
	end

	if not fishModel then
		print("No fish model found in workspace.")
		return
	end

	root.CFrame = fishModel:GetPivot() + Vector3.new(0, 5, 0)

	task.delay(0.25, function()
		for _, part in ipairs(fishModel:GetDescendants()) do
			if part:IsA("ProximityPrompt") then
				fireproximityprompt(part)
				root.CFrame = CFrame.new(position)
				break
			end
		end
	end)
end

function teleportToNeededClam(player)
	local fishModel = nil
	for _, obj in ipairs(workspace:GetDescendants()) do
		if string.lower(obj.Name) == "clam" then
			fishModel = obj
			break
		end
	end

	if not fishModel then
		print("No fish model found in workspace.")
		return
	end

	root.CFrame = fishModel:GetPivot() + Vector3.new(0, 5, 0)

	task.delay(0.25, function()
		for _, part in ipairs(fishModel:GetDescendants()) do
			if part:IsA("ProximityPrompt") then
				fireproximityprompt(part)
				root.CFrame = CFrame.new(position)
				break
			end
		end
	end)
end

local function noclip()
	Clip = false
	if Noclip then Noclip:Disconnect() end
	Noclip = RunService.Stepped:Connect(function()
		if Clip == false and lp.Character then
			for _, v in ipairs(lp.Character:GetDescendants()) do
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

if game.PlaceId == 16454414227 or game.PlaceId == 17820412646 then
TabHandles.Main:Button({
        Title = "Teleport To Workspace",
        Desc = "Teleports to your cooking station.",
        Locked = false,
	Callback = function()
		root.CFrame = CFrame.new(position)
	end
})
TabHandles.Main:Button({
	Title = "Teleport To Conveyor",
	Desc = "Teleports to food conveyor.",
	Locked = false,
	Callback = function()
		root.CFrame = CFrame.new(7, 6, 67)
	end
})

TabHandles.Main:Button({
	Title = "Teleport To Rice",
	Locked = false,
	Callback = function()
		root.CFrame = CFrame.new(-178, 10, 82)
	end
})
TabHandles.Main:Button({
	Title = "Teleport To Nori",
	Locked = false,
	Callback = function()
		root.CFrame = CFrame.new(-178, 10, 50)
	end
})

TabHandles.Main:Button({
	Title = "Teleport To Salmon",
	Locked = false,
	Callback = function()
		root.CFrame = CFrame.new(-140, 7, 234)
	end
})
TabHandles.Main:Button({
       Title = "Teleport To Tuna",
       Locked = false,
	Callback = function()
		root.CFrame = CFrame.new(-156, 7, 266)
	end
})
TabHandles.Main:Button({
	Title = "Teleport To Flounder",
	Locked = false,
	Callback = function()
		root.CFrame = CFrame.new(-201, 7, 268)
	end
})
TabHandles.Main:Button({
	Title = "Teleport To Eel",
	Locked = false,
	Callback = function()
		root.CFrame = CFrame.new(-220, 7, 233)
	end
})

TabHandles.Main:Button({
	Title = "Teleport To Vegetables",
	Locked = false,
	Callback = function()
		root.CFrame = CFrame.new(-180, 7, -119)
	end
})

TabHandles.Main:Button({
	Title = "Teleport To Secret",
	Locked = false,
	Callback = function()
		root.CFrame = CFrame.new(-616, 19, 41)
	end
})
TabHandles.Main:Button({
	Title = "Teleport To Elevator",
	Locked = false,
	Callback = function()
		root.CFrame = CFrame.new(-272, 6, 67)
	end
})
elseif game.PlaceId == 17821427181 then
TabHandles.Main:Button({
        Title = "Teleport To Workspace",
        Desc = "Teleports to your cooking station.",
        Locked = false,
	Callback = function()
		root.CFrame = CFrame.new(position)
	end
})

TabHandles.Main:Button({
	Title = "Teleport To Rice",
	Locked = false,
	Callback = function()
		root.CFrame = CFrame.new(-700, -152, 776)
	end
})
TabHandles.Main:Button({
	Title = "Teleport To Nori",
	Locked = false,
	Callback = function()
		root.CFrame = CFrame.new(-693, -152, 554)
	end
})

TabHandles.Main:Button({
	Title = "Catch Required Beetle",
	Locked = false,
	Callback = function()
		teleportToNeededBeetle()
	end
})

TabHandles.Main:Button({
	Title = "Teleport To Fish",
	Locked = false,
	Callback = function()
		teleportToNeededFish()
	end
})
TabHandles.Main:Button({
	Title = "Teleport To Jellyfish",
	Locked = false,
	Callback = function()
		teleportToNeededJelly()
	end
})
TabHandles.Main:Button({
	Title = "Teleport To Clam",
	Locked = false,
	Callback = function()
		teleportToNeededClam()
	end
})

TabHandles.Main:Button({
	Title = "Teleport To Fungus",
	Locked = false,
	Callback = function()
		root.CFrame = CFrame.new(-271, 67, -631)
	end
})

end
local instantHandle = TabHandles.Player:Toggle({
	Title = "Instant Interact",
	Value = false,
	Callback = function(Value)
		instantInteractEnabled = Value

		if instantInteractEnabled then
			interactLoop = task.spawn(function()
				while instantInteractEnabled do
					for _, v in ipairs(workspace:GetDescendants()) do
						if v:IsA("ProximityPrompt") then
							v.HoldDuration = 0
						end
					end
					task.wait(1)
				end
			end)
		else
			if interactLoop then
				task.cancel(interactLoop)
			end
		end
	end
})

TabHandles.Player:Button({
	Title = "Infinite Jump",
	Locked = false,
	Callback = function()
	      local InfiniteJumpEnabled = true
game:GetService("UserInputService").JumpRequest:connect(function()
             if InfiniteJumpEnabled then
             game:GetService"Players".LocalPlayer.Character:FindFirstChildOfClass'Humanoid':ChangeState("Jumping")
             end
         end)
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
	Callback = function(Value)
		WalkToggle = Value
	end
})
local WsSliderHandle = TabHandles.Player:Slider({
	Title = "WalkSpeed",
	Value = { Min = 28, Max = 100, Default = 28 },
	Step = 1,
	Callback = function(Value)
		fastSprintSpeed = Value
	end
})

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
				if plr ~= lp and (table.find(blacklist, plr.UserId) or bannedRanks[plr:GetRoleInGroup(gid)]) then
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
            configFile:Register("instantHandle", instantHandle)
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
local autoLoadFile = "AZUREHUB_ALC_SS.txt"
local ALC = false

if ConfigManager then
    ConfigManager:Init(Window)
    
    configFile = ConfigManager:CreateConfig(configName)
    configFile:Register("instantHandle", instantHandle)
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
                configFile:Register("instantHandle", instantHandle)
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

local function setupHumanoid()
	if not humanoid then return end

	local walkWatcher = RunService.Heartbeat:Connect(function()
		if humanoid and humanoid.Health > 0 then
			humanoid.WalkSpeed = WalkToggle and fastSprintSpeed or 16
		end
	end)

	humanoid.Died:Connect(function()
		walkWatcher:Disconnect()
	end)
end

lp.CharacterAdded:Connect(function(char)
	local hum = char:WaitForChild("Humanoid", 5)
	if hum then
		humanoid = hum
		setupHumanoid()
	end
end)

task.spawn(function()
	local char = lp.Character or lp.CharacterAdded:Wait()
	local hum = char:WaitForChild("Humanoid", 5)
	if hum then
		humanoid = hum
		setupHumanoid()
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