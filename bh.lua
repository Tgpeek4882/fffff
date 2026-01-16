local cloneref = cloneref or function(o) return o end
local Players = cloneref(game:GetService("Players"))
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local RunService = cloneref(game:GetService("RunService"))
local ServerScriptService = cloneref(game:GetService("ServerScriptService"))
local RunService = cloneref(game:GetService("RunService"))
local lp = Players.LocalPlayer
local username = lp.Name
local Camera = workspace.CurrentCamera
local UserInputService = cloneref(game:GetService("UserInputService"))
local PlayerGUI = lp:FindFirstChildOfClass("PlayerGui")
local VIM = cloneref(game:GetService("VirtualInputManager"))
local GuiService = cloneref(game:GetService("GuiService"))

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

local blacklist = {}
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/azurelw/azurehub/refs/heads/main/main.lua"))()

local playerNames = {}

local function updatePlayerList()
    playerNames = {}
    for _, player in pairs(game.Players:GetPlayers()) do
        table.insert(playerNames, player.Name)
    end
end

updatePlayerList()

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

local gid = 3104358
local bannedRanks = {
    ["Moderator"] = true,
    ["Content Creator"] = true,
    ["Senior Moderator"] = true,
    ["QA Alts"] = true,
    ["Voldex QA"] = true,
    ["QA Lead"] = true,
    ["External"] = true,
    ["Marketing"] = true,
    ["Analytics"] = true,
    ["Game Design"] = true,
    ["Tech Art"] = true,
    ["Developer"] = true,
    ["Admin"] = true,
    ["LT"] = true,
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
    Title = "Azure Hub | Brookhaven " .. getTag(lp.Name),
    Author = "discord.gg/QmvpbPdw9J",
    Folder = "BrookhavenHub",
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
     Misc = Tabs.Features:Tab({ Title = "|  Misc", Icon = "layout-grid" }),
     Config = Tabs.Utilities:Tab({ Title = "|  Configuration", Icon = "settings" })
}

local updparagraph = Logs:Paragraph({
    Title = "Update Logs",
    Desc = "18.12.25\n[/] Fixed Lags Every Second\n\n7.11.25\n[+] Brookhaven",
    Locked = false,
    Buttons = {
        {
            Icon = "clipboard",
            Title = "Discord Server",
            Callback = function() setclipboard(discordLink) WindUI:Notify({ Title = "Discord Server", Content = "Link Copied!", Icon = "info", Duration = 2 }) end,
        }
    }
})

local selectedPlayer = ""
local selectedTPlayer = ""
local LoopFling = false
local LoopTP = false

local WalkToggle = false
local currentSpeed = 16
local Noclip = nil
local Clip = nil
local NoclipToggle = false

local antiAfkToggle = false
local FlingToggle = false
local antiFlingToggle = false
local flingThread

local hasCouch = false

local function loopfling()
    spawn(function()
        local savedCF = root.CFrame
        while LoopFling do
            task.wait(0.01)
            local hasCouch = false
            local couchTool = nil
            
            for _, item in pairs(lp.Backpack:GetChildren()) do
                if item.Name == "Couch" then
                    hasCouch = true
                    couchTool = item
                    break
                end
            end
            
            if not hasCouch and lp.Character then
                for _, item in pairs(lp.Character:GetChildren()) do
                    if item:IsA("Tool") and item.Name == "Couch" then
                        hasCouch = true
                        couchTool = item
                        break
                    end
                end
            end
            
            if not hasCouch then
                local args = {
                    "PickingTools",
                    "Couch"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("RE"):WaitForChild("1Too1l"):InvokeServer(unpack(args))
            end
            
            if couchTool and couchTool.Parent == lp.Backpack then
                couchTool.Parent = lp.Character
            end
            
            if selectedPlayer and selectedPlayer.Character then
                if (root.Position - selectedPlayer.Character.HumanoidRootPart.Position).Magnitude < 5000 then
                    savedCF = root.CFrame
                end
                
                local seat1 = couchTool and couchTool:FindFirstChild("Seat1")
                local seat2 = couchTool and couchTool:FindFirstChild("Seat2")
                
                if seat1 and seat1.Occupant then
                    root.CFrame = CFrame.new(9999999, 9999999, 9999999)
                    task.wait(0.5)
                    if couchTool and couchTool.Parent == lp.Character then
                        couchTool.Parent = lp.Backpack
                    end
                    task.wait(0.5)
                    root.CFrame = savedCF
                    
                    repeat task.wait() until selectedPlayer and selectedPlayer.Character and (selectedPlayer.Character.HumanoidRootPart.Position - root.Position).Magnitude < 1000
                elseif seat2 and seat2.Occupant then
                    root.CFrame = CFrame.new(9999999, 9999999, 9999999)
                    task.wait(1)
                    if couchTool and couchTool.Parent == lp.Character then
                        couchTool.Parent = lp.Backpack
                    end
                    task.wait(1)
                    root.CFrame = savedCF
                    
                    repeat task.wait() until selectedPlayer and selectedPlayer.Character and (selectedPlayer.Character.HumanoidRootPart.Position - root.Position).Magnitude < 1000
                else
                    if (selectedPlayer.Character.HumanoidRootPart) then root.CFrame = selectedPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2) + Vector3.new(0, -5, 0) end
                end
            end
        end
    end)
end

local function bring()
    local oldPos = root.CFrame
    local hasCouch = false
    local couchTool = nil
            
    for _, item in pairs(lp.Backpack:GetChildren()) do
        if item.Name == "Couch" then
            hasCouch = true
            couchTool = item
            break
        end
    end
            
    if not hasCouch and lp.Character then
        for _, item in pairs(lp.Character:GetChildren()) do
            if item:IsA("Tool") and item.Name == "Couch" then
                hasCouch = true
                couchTool = item
                break
            end
        end
    end
            
    if not hasCouch then
        local args = {
            "PickingTools",
            "Couch"
        }
        game:GetService("ReplicatedStorage"):WaitForChild("RE"):WaitForChild("1Too1l"):InvokeServer(unpack(args))
    end
            
    if couchTool and couchTool.Parent == lp.Backpack then
        couchTool.Parent = lp.Character
    end
            
    while selectedPlayer and selectedPlayer.Character do
        local seat1 = couchTool and couchTool:FindFirstChild("Seat1")
        local seat2 = couchTool and couchTool:FindFirstChild("Seat2")
        
        if (seat1 and seat1.Occupant) or (seat2 and seat2.Occupant) then
            root.CFrame = oldPos
            task.wait(1)
            if couchTool and couchTool.Parent == lp.Character then
                couchTool.Parent = lp.Backpack
            end
            break
        end
        
        if selectedPlayer.Character.HumanoidRootPart then 
            root.CFrame = selectedPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2) + Vector3.new(0, -5, 0) 
        end
        
        task.wait()
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

local Trolling = TabHandles.Main:Section({
    Title = "Trolling",
    Icon = "skull"
})
local TrollingTarget = Trolling:Dropdown({
       Title = "Choose Target",
       Values = playerNames,
       Value = "",
       Multi = false,
       AllowNone = true,
       Callback = function(option)
             selectedPlayer = game.Players:FindFirstChild(option)
       end
})
local TrollingFling = Trolling:Toggle({
       Title = "Loop Fling Target",
       Value = false,
       Callback = function(state)
             LoopFling = state
             if state then loopfling() end
       end
})
Trolling:Button({
	Title = "Bring Target",
	Callback = function()
	       bring()
	end
})

local Teleports = TabHandles.Main:Section({
    Title = "Teleports",
    Icon = "orbit"
})
local TeleportsTarget = Teleports:Dropdown({
       Title = "Choose Target",
       Values = playerNames,
       Value = "",
       Multi = false,
       AllowNone = true,
       Callback = function(option)
             selectedTPlayer = game.Players:FindFirstChild(option)
       end
})
Teleports:Button({
	Title = "Teleport To Target",
	Callback = function()
	       local target = game.Players:FindFirstChild(selectedTPlayer)
	       
	       root.CFrame = selectedTPlayer.Character:FindFirstChild("Head").CFrame
	end
})
local TeleportsTeleport = Teleports:Toggle({
       Title = "Loop Teleport To Target",
       Value = false,
       Callback = function(state)
             LoopTP = state
             while LoopTP and task.wait(0.01) do
                 root.CFrame = selectedTPlayer.Character:FindFirstChild("Head").CFrame
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
	end
})
local WsSliderHandle = TabHandles.Player:Slider({
       Title = "WalkSpeed",
	Value = { Min = 16, Max = 100, Default = 16 },
	Callback = function(Value)
		currentSpeed = Value
	end
})

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
        if state then
            AntiAfk()
        end
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
local autoLoadFile = "AZUREHUB_ALC_US.txt"
local ALC = false

if ConfigManager then
    ConfigManager:Init(Window)
    
    configFile = ConfigManager:CreateConfig(configName)
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

game.Players.PlayerAdded:Connect(function(player)
    table.insert(playerNames, player.Name)
    TrollingTarget:Refresh(playerNames)
    TeleportsTarget:Refresh(playerNames)
end)

game.Players.PlayerRemoving:Connect(function(player)
    for i, name in pairs(playerNames) do
        if name == player.Name then
            table.remove(playerNames, i)
            TrollingTarget:Refresh(playerNames)
            TeleportsTarget:Refresh(playerNames)
            break
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