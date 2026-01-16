local cloneref = cloneref or function(o) return o end
local Players = cloneref(game:GetService("Players"))
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local lp = Players.LocalPlayer
local username = lp.Name
local RunService = cloneref(game:GetService("RunService"))

local humanoid
local root
local character

local RarityPriority = {
	["Contrast"] = 1,
	["Volcanic"] = 2,
	["Tesla"] = 3,
	["Heart"] = 4,
	["Spirit"] = 5,
	["Cursed"] = 6,
	["Fairy"] = 7,
	["Frost"] = 8,
	["Galatic"] = 9,
	["Shimmer"] = 10,
	["Lightning"] = 11,
	["Pyronova"] = 12,
	["Inferno"] = 13,
	["Divine"] = 14,
}

local function uCR(char)
    character = char
    root = character:WaitForChild("HumanoidRootPart", 5)
    humanoid = character:WaitForChild("Humanoid", 5)
end

uCR(lp.Character or lp.CharacterAdded:Wait())
lp.CharacterAdded:Connect(function(newChar)
    uCR(newChar)
end)

local anti = workspace:FindFirstChild(username):FindFirstChild("LocalScript")
local blacklist = {
  [8424373409] = true,
  [71552399] = true
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

local gid = 166229263
local bannedRanks = {
    ["Partner"] = true,
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
    Title = "Azure Hub | Aura Trade ".. getTag(lp.Name),
    Author = "discord.gg/QmvpbPdw9J",
    Folder = "AuraHub",
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

local updparagraph = Logs:Paragraph({
    Title = "Update Logs",
    Desc = "27.07.25\n[+] Bypassed Anti-Cheat\n[/] 95% Snipe Auras\n\n26.07.25\n[+] Aura Trade\n[+] Summon Rain [EXPLOIT]\n[+] Snipe Auras",
    Locked = false,
    Buttons = {
        {
            Icon = "clipboard",
            Title = "Discord Server",
            Callback = function() setclipboard(discordLink) WindUI:Notify({ Title = "Discord Server", Content = "Link Copied!", Icon = "info", Duration = 2 }) end,
        }
    }
})

local bestToggle = false
local antiAfkToggle = false
local snipeToggle = false
local NoclipToggle = false
local WalkToggle = false
local currentSpeed = 25
local selectedSnipeTypes = nil
local selectedTypes = {}
local tpAuraExploit = false
local Noclip = nil
local Clip = nil

if anti then
   anti:Destroy()
   WindUI:Notify({
        Title = "Azure Hub",
        Content = "Successfully bypassed anti-cheat, enjoy the script.",
        Icon = "info",
        Duration = 3
    })
else
    WindUI:Notify({
        Title = "Azure Hub",
        Content = "Failed to bypass anti-cheat, report bug in our discord server.",
        Icon = "warning",
        Duration = 3
    })
end

function rainUI()
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

    local events = {
        {Name = "Spawn_GALATIC", Interval = 0.01, Type = "RemoteEvent"},
        {Name = "Spawn_FROST", Interval = 0.01, Type = "RemoteEvent"},
        {Name = "Lightning_Strike", Interval = 0.01, Type = "RemoteEvent"},
    }

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MultiEventUI"
    screenGui.Parent = playerGui
    screenGui.ResetOnSpawn = false

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 180, 0, 160)
    frame.Position = UDim2.new(0.5, -90, 0.5, -80)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    frame.Active = true
    frame.Draggable = true

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 25)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "Aura Rain UI"
    titleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.TextSize = 20
    titleLabel.Parent = frame

    local function createToggle(name, yPos)
        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Size = UDim2.new(0, 160, 0, 25)
        toggleBtn.Position = UDim2.new(0, 10, 0, yPos)
        toggleBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        toggleBtn.TextColor3 = Color3.new(1, 1, 1)
        toggleBtn.Font = Enum.Font.SourceSansBold
        toggleBtn.TextSize = 18
        toggleBtn.Text = name .. ": OFF"
        toggleBtn.Parent = frame
        return toggleBtn
    end

    local toggles = {}

    local function fireEventLoop(eventInstance, interval, toggledRef, eventType)
        while toggledRef.Toggled do
            if eventType == "RemoteEvent" then
                eventInstance:FireServer()
            elseif eventType == "BindableEvent" then
                eventInstance:Fire()
            end
            task.wait()
        end
    end

    for i, eventData in ipairs(events) do
        local toggleBtn = createToggle(eventData.Name, 25 + (i - 1) * 27)
        toggles[eventData.Name] = {Button = toggleBtn, Toggled = false}
    end

    for _, eventData in ipairs(events) do
        local eventInstance = ReplicatedStorage:FindFirstChild(eventData.Name)
        if not eventInstance then
            warn(eventData.Name .. " event not found in ReplicatedStorage!")
        else
            local toggleData = toggles[eventData.Name]
            toggleData.Button.MouseButton1Click:Connect(function()
                toggleData.Toggled = not toggleData.Toggled
                toggleData.Button.Text = eventData.Name .. (toggleData.Toggled and ": ON" or ": OFF")
                if toggleData.Toggled then
                    task.spawn(fireEventLoop, eventInstance, eventData.Interval, toggleData, eventData.Type)
                end
            end)
        end
    end
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

local function getAuraScore(toolName)
	for aura, score in pairs(RarityPriority) do
		if string.find(string.lower(toolName), string.lower(aura)) then
			return score
		end
	end
	return nil
end

local function findBestAuras()
	local found = {}

	for _, plrModel in ipairs(workspace:GetChildren()) do
		if plrModel.Name ~= lp.Name then
			local char = plrModel
			local backpack = plrModel:FindFirstChild("Backpack")

			local tool = char:FindFirstChildWhichIsA("Tool")
			if tool then
				local score = getAuraScore(tool.Name)
				if score then
					table.insert(found, {player = plrModel.Name, tool = tool.Name, score = score})
				end
			end

			if backpack then
				for _, tool in ipairs(backpack:GetChildren()) do
					if tool:IsA("Tool") then
						local score = getAuraScore(tool.Name)
						if score then
							table.insert(found, {player = plrModel.Name, tool = tool.Name, score = score})
						end
					end
				end
			end
		end
	end

	table.sort(found, function(a, b)
		return a.score > b.score
	end)

	for i = 1, math.min(2, #found) do
		WindUI:Notify({
			Title = "Azure Hub",
			Content = "Found best aura: " .. found[i].tool .. "\nAura Owner: " .. found[i].player,
			Duration = 2,
			Icon = "info"
		 })
	end
end

TabHandles.Exploit:Button({
	Title = "Aura Rain (EXPLOIT)",
	Desc = "Has 3 types of aura rains, galatic, frost, lightning.",
	Locked = false,
	Callback = function(state)
		rainUI()
	end
})
local tpAuraHandle = TabHandles.Exploit:Toggle({
	Title = "Teleport To Rained Aura",
	Desc = "Collects stage 5 auras that spawned by aura rain.",
	Value = false,
	Callback = function(state)
		tpAuraExploit = state
	end
})
local bestAuraHandle = TabHandles.Main:Toggle({
	Title = "Equip Best Aura",
	Desc = "Equips best aura in your inventory, filtered by algorithm.",
	Value = false,
	Callback = function(state)
		bestToggle = state
	end
})
local snipeAuraHandle = TabHandles.Main:Toggle({
	Title = "Snipe Auras",
	Desc = "Snipes auras from dropdown below, 95% to snipe dropped aura.",
	Value = false,
	Callback = function(state)
		snipeToggle = state
	end
})
local snipeTypeHandle = TabHandles.Main:Dropdown({
   Title = "Snipe Type",
   Values = { "Contrast", "Volcanic", "Tesla", "Heart", "Spirit", "Cursed", "Fairy", "Frost", "Galatic", "Shimmer", "Lightning", "Pyronova", "Inferno", "Werewolf", "Bionic", "Divine" },
   Value = { "" },
   Multi = true,
   AllowNone = true,
   Callback = function(option)
      selectedTypes = option
   end
})
TabHandles.Main:Button({
	Title = "Find Best Aura",
	Desc = "Finds best auras in player inventories, filtered by algorithm.",
	Callback = function()
	  findBestAuras()
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
	Step = 1,
	Callback = function(Value)
		currentSpeed = Value
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
            configFile:Register("bestAuraHandle", bestAuraHandle)
            configFile:Register("snipeAuraHandle", snipeAuraHandle)
            configFile:Register("snipeTypeHandle", snipeTypeHandle)
            configFile:Register("NoclipHandle", NoclipHandle)
            configFile:Register("WsToggleHandle", WsToggleHandle)
            configFile:Register("WsSliderHandle", WsSliderHandle)
            configFile:Register("ProtectIdentityHandle", ProtectIdentityHandle)
            configFile:Register("antiAfkHandle", antiAfkHandle)
            configFile:Register("antiFlingHandle", antiFlingHandle)
            configFile:Register("FlingHandle", FlingHandle)
            configFile:Register("tpAuraHandle", tpAuraHandle)
            configFile:Register("antiAdminHandle", antiAdminHandle)
        end
    end
})

local ConfigManager = Window.ConfigManager
local configFile
local autoLoadFile = "AZUREHUB_ALC_AT.txt"
local ALC = false

if ConfigManager then
    ConfigManager:Init(Window)
    
    configFile = ConfigManager:CreateConfig(configName)
    configFile:Register("bestAuraHandle", bestAuraHandle)
    configFile:Register("snipeAuraHandle", snipeAuraHandle)
    configFile:Register("snipeTypeHandle", snipeTypeHandle)
    configFile:Register("NoclipHandle", NoclipHandle)
    configFile:Register("WsToggleHandle", WsToggleHandle)
    configFile:Register("WsSliderHandle", WsSliderHandle)
    configFile:Register("ProtectIdentityHandle", ProtectIdentityHandle)
    configFile:Register("antiAfkHandle", antiAfkHandle)
    configFile:Register("antiFlingHandle", antiFlingHandle)
    configFile:Register("FlingHandle", FlingHandle)
    configFile:Register("tpAuraHandle", tpAuraHandle)
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
                configFile:Register("bestAuraHandle", bestAuraHandle)
                configFile:Register("snipeAuraHandle", snipeAuraHandle)
                configFile:Register("snipeTypeHandle", snipeTypeHandle)
                configFile:Register("NoclipHandle", NoclipHandle)
                configFile:Register("WsToggleHandle", WsToggleHandle)
                configFile:Register("WsSliderHandle", WsSliderHandle)
                configFile:Register("ProtectIdentityHandle", ProtectIdentityHandle)
                configFile:Register("antiAfkHandle", antiAfkHandle)
                configFile:Register("antiFlingHandle", antiFlingHandle)
                configFile:Register("FlingHandle", FlingHandle)
                configFile:Register("tpAuraHandle", tpAuraHandle)
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
	while true do
		if WalkToggle then
			humanoid.WalkSpeed = currentSpeed
		end
		wait()
	end
end)

local sniped = {}

task.spawn(function()
	while true do
		task.wait()
		if not snipeToggle or #selectedTypes == 0 then continue end

		local character = lp.Character
		if not character then continue end

		local rootPart = character:FindFirstChild("HumanoidRootPart")
		if not rootPart then continue end

		local found = false

		for _, v in ipairs(Workspace:GetChildren()) do
			if v:IsA("Tool") and not sniped[v] then
			       local toolName = v.Name
				local lowerName = v.Name:lower()
				for _, type in ipairs(selectedTypes) do
					if type ~= "" and lowerName:find(type:lower(), 1, true) then
						local handle = v:FindFirstChild("Handle") or v:FindFirstChildWhichIsA("BasePart")
						if handle then
							rootPart.CFrame = handle.CFrame + Vector3.new(0, 1, 0)
							sniped[v] = true
							found = true
							WindUI:Notify({
								Title = "Sniped",
								Content = toolName,
								Duration = 2,
								Icon = "info"
							})
							break
						end
					end
				end
				if found then break end
			end
		end

		if not found then end
	end
end)

local function getRootPart()
    local player = Players.LocalPlayer
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        repeat
            player.CharacterAdded:Wait()
            character = player.Character
        until character and character:FindFirstChild("HumanoidRootPart")
    end
    return character:FindFirstChild("HumanoidRootPart")
end

task.spawn(function()
    while true do
        task.wait()
        if not tpAuraExploit then continue end
        if not root then continue end

        for _, tool in ipairs(workspace:GetChildren()) do
            if tool:IsA("Tool") and tool.Name == "5" and not sniped[tool] then
                local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart")
                if handle then
                    root.CFrame = handle.CFrame + Vector3.new(0, 1, 0)
                    sniped[tool] = true
                    task.wait(0.1)
                end
            end
        end
    end
end)

local StageOverrides = {
	["Shimmer"] = { [5] = "Lightning" },
	["Lightning"] = {
		[5] = { "Pyronova", 3 },
		[5] = { "Inferno", 2 }
	},
	["Pyronova"] = { [4] = { "Inferno", 3 } },
	["Frost"] = { [5] = { "Galatic", 4 } },
	["Fairy"] = { [5] = { "Frost", 3 } },
	["Galatic"] = {
		[5] = { "Shimmer", 3 },
		[5] = { "Frost", 3 }
	}
}

local function getToolInfo(tool)
	local name = tool.Name
	local rarity, stage = name:match("^(%w+)%s%[STAGE%s(%d+)%]")
	if not rarity or not stage then return nil, 0 end
	return rarity, tonumber(stage)
end

local function isBetter(rarity1, stage1, rarity2, stage2)
	local overrides = StageOverrides[rarity1]
	if overrides and overrides[stage1] then
		local compareRarity, maxStage = table.unpack(overrides[stage1])
		if rarity2 == compareRarity and stage2 <= maxStage then
			return true
		end
	end
	local rank1 = RarityPriority[rarity1] or 0
	local rank2 = RarityPriority[rarity2] or 0
	if rank1 ~= rank2 then
		return rank1 > rank2
	else
		return stage1 > stage2
	end
end

local function equipBestTool(player)
	local backpack = player:FindFirstChild("Backpack")
	local char = player.Character
	if not backpack or not char then return end

	local bestTool
	local bestRarity, bestStage

	-- Check both Backpack and Character
	for _, container in ipairs({ backpack, char }) do
		for _, tool in ipairs(container:GetChildren()) do
			if tool:IsA("Tool") then
				local rarity, stage = getToolInfo(tool)
				if rarity and (not bestTool or isBetter(rarity, stage, bestRarity, bestStage)) then
					bestTool = tool
					bestRarity = rarity
					bestStage = stage
				end
			end
		end
	end

	if bestTool then
		local equippedTool = char:FindFirstChildOfClass("Tool")

		if equippedTool and equippedTool.Name ~= bestTool.Name then
			equippedTool.Parent = backpack
		end

		if not equippedTool or equippedTool.Name ~= bestTool.Name then
			bestTool.Parent = char
		end
	end
end

task.spawn(function()
	while true do
		task.wait(1)
		if bestToggle then
			for _, player in ipairs(Players:GetPlayers()) do
				pcall(function()
					if player.Character then
						equipBestTool(player)
					end
				end)
			end
		end
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