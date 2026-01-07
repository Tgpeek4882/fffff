local cloneref = cloneref or function(o) return o end
local Players = cloneref(game:GetService("Players"))
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local RunService = cloneref(game:GetService("RunService"))
local lp = Players.LocalPlayer
local username = lp.Name
local Camera = workspace.CurrentCamera
local UserInputService = cloneref(game:GetService("UserInputService"))
local UIS = cloneref(game:GetService("UserInputService"))
local cam = workspace.CurrentCamera

local character
local hum
local root

local speed = 20
local flying = false
local bind = Enum.KeyCode.F
local gui
local connections = {}

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

if hookfunction then
local getinfo = getinfo or debug.getinfo
local Hooked = {}
local Detected, Kill
if setthreadidentity then setthreadidentity(2) else warn("[AzureHub] Executor doesnt support setthreadidentity.") end
for i, v in getgc(true) do
    if typeof(v) == "table" then
        local DetectFunc = rawget(v, "Detected")
        local KillFunc = rawget(v, "Kill")
    
        if typeof(DetectFunc) == "function" and not Detected then
            Detected = DetectFunc
            
            local Old; Old = hookfunction(Detected, function(Action, Info, NoCrash)
                if Action ~= "_" then end
                
                return true
            end)
            table.insert(Hooked, Detected)
        end

        if rawget(v, "Variables") and rawget(v, "Process") and typeof(KillFunc) == "function" and not Kill then
            Kill = KillFunc
            local Old; Old = hookfunction(Kill, function(Info)
            end)
            table.insert(Hooked, Kill)
        end
    end
end

local Old; Old = hookfunction(getrenv().debug.info, newcclosure(function(...)
    local LevelOrFunc, Info = ...

    if Detected and LevelOrFunc == Detected then
        return coroutine.yield(coroutine.running())
    end
    
    return Old(...)
end))
if setthreadidentity then setthreadidentity(7) else warn("[AzureHub] Executor doesnt support setthreadidentity.") end
else
warn("[AzureHub] Failed to bypass adonis, executor doesnt support hookfunction.")
end

local kickAvoidCount = 0
local ac1 = nil
if hookmetamethod then
ac1 = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    if method:lower() == "kick" and self == game.Players.LocalPlayer then
        kickAvoidCount += 1
        WindUI:Notify({
            Title = "Anti Client Kick",
            Content = "Total kicks avoided: " .. tostring(kickAvoidCount),
            Icon = "info",
            Duration = 2
        })
        return
    end
    return ac1(self, ...)
end)
else
warn("[AzureHub] Executor doesnt support hookmetamethod, anti kick will not work.")
end

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

local bannedRanks = {}
local gid
if game.CreatorType == Enum.CreatorType.Group then
    gid = game.CreatorId

    local success, groupInfo = pcall(function()
        return game:GetService("GroupService"):GetGroupInfoAsync(gid)
    end)

    if success and groupInfo then
        for _, role in ipairs(groupInfo.Roles) do
            if role.Rank ~= 1 then
                bannedRanks[role.Name] = true
            end
        end
    end
end

local rankName = gid and lp:GetRoleInGroup(gid)
if rankName and bannedRanks[rankName] then
    lp:Kick("Exploiting")
end

print("Loaded (Universal Script)!\nAzureHub By Cat\nDiscord: https://discord.gg/QmvpbPdw9J")

WindUI:SetNotificationLower(true)
local Window = WindUI:CreateWindow({
    Title = "Azure Hub | Universal Script ".. getTag(lp.Name),
    Author = "discord.gg/QmvpbPdw9J",
    Folder = "UniversalScriptHub",
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

Window:CreateTopbarButton("theme-switcher", "moon", function()
    WindUI:SetTheme(WindUI:GetCurrentTheme() == "Dark" and "Light" or "Dark")
    WindUI:Notify({
        Title = "Theme Changed",
        Content = "Current theme: "..WindUI:GetCurrentTheme(),
        Duration = 2
    })
end, 990)
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

local Logs = Window:Tab({ Title = "|  Update Logs", Icon = "scroll-text" })
Window:Divider()

local Tabs = {
    Features = Window:Section({ Title = "Features", Opened = true }),
    Utilities = Window:Section({ Title = "Utilities", Opened = true })
}

local TabHandles = {
     Universal = Tabs.Features:Tab({ Title = "|  Universal", Icon = "orbit" }),
     Player = Tabs.Features:Tab({ Title = "|  Player", Icon = "users-round" }),
     Misc = Tabs.Features:Tab({ Title = "|  Misc", Icon = "layout-grid" }),
     Config = Tabs.Utilities:Tab({ Title = "|  Configuration", Icon = "settings" })
}

local updparagraph = Logs:Paragraph({
    Title = "Update Logs",
    Desc = "30.12.25\n[+] Universal Script\n[+] Adonis Bypasser\n[+] Anti Client Kick (High UNC Exec)",
    Locked = false,
    Buttons = {
        {
            Icon = "clipboard",
            Title = "Discord Server",
            Callback = function() setclipboard(discordLink) WindUI:Notify({ Title = "Discord Server", Content = "Link Copied!", Icon = "info", Duration = 2 }) end,
        }
    }
})

local WsMethod = "Default"
local WalkToggle = false
local currentSpeed = 28
local Noclip = nil
local Clip = nil
local NoclipToggle = false

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

local function DestroyGui()
    for _, conn in pairs(connections) do
        if conn then conn:Disconnect() end
    end
    connections = {}

    flying = false
    if lp.Character then
        local root = lp.Character:FindFirstChild("HumanoidRootPart")
        local hum = lp.Character:FindFirstChild("Humanoid")
        
        if root then
            for _, v in pairs(root:GetChildren()) do
                if v:IsA("BodyVelocity") then v:Destroy() end
            end
        end
        if hum then hum.PlatformStand = false end
    end

    if gui then
        gui:Destroy()
        gui = nil
    end
end

local function CreateGui()
    if gui then DestroyGui() end

    local h = (gethui and gethui()) or game:GetService("CoreGui")
    gui = Instance.new("ScreenGui", h)
    gui.Name = tostring(math.random(0,1000000))
    gui.ResetOnSpawn = false

    local bg = Instance.new("Frame", gui)
    bg.Size = UDim2.new(0, 190, 0, 90)
    bg.Position = UDim2.new(0, 10, 0, 10)
    bg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    bg.BackgroundTransparency = 0.2
    bg.BorderSizePixel = 0
    bg.Active = true
    bg.Draggable = true

    local function create(cls, props)
        local i = Instance.new(cls, props.Par)
        for k, v in pairs(props) do if k ~= "Par" then i[k] = v end end
        return i
    end

    local layout = create("UIListLayout", {Par=bg, Padding=UDim.new(0,5), SortOrder="LayoutOrder", HorizontalAlignment="Center"})
    create("UIPadding", {Par=bg, PaddingTop=UDim.new(0,5), PaddingLeft=UDim.new(0,5), PaddingRight=UDim.new(0,5)})

    local statBtn = create("TextButton", {
        Par=bg, Size=UDim2.new(1, 0, 0, 20), BackgroundTransparency=1,
        Text="Flight: [ OFF ]", TextColor3=Color3.new(1,0.3,0.3), Font=Enum.Font.Code, TextSize=14, TextXAlignment="Left"
    })

    local spdFrame = create("Frame", {Par=bg, Size=UDim2.new(1, 0, 0, 20), BackgroundTransparency=1})
    create("TextLabel", {Par=spdFrame, Size=UDim2.new(0, 50, 1, 0), BackgroundTransparency=1, Text="Speed:", TextColor3=Color3.new(1,1,1), Font=Enum.Font.Code, TextSize=14, TextXAlignment="Left"})
    local sub = create("TextButton", {Par=spdFrame, Size=UDim2.new(0, 20, 1, 0), Position=UDim2.new(0,55,0,0), BackgroundColor3=Color3.fromRGB(40,40,40), Text="-", TextColor3=Color3.new(1,1,1)})
    local add = create("TextButton", {Par=spdFrame, Size=UDim2.new(0, 20, 1, 0), Position=UDim2.new(0,125,0,0), BackgroundColor3=Color3.fromRGB(40,40,40), Text="+", TextColor3=Color3.new(1,1,1)})
    local spdBox = create("TextBox", {
        Par=spdFrame, Size=UDim2.new(0, 40, 1, 0), Position=UDim2.new(0,80,0,0), BackgroundColor3=Color3.fromRGB(30,30,30),
        Text=tostring(speed), TextColor3=Color3.new(1,1,0), Font=Enum.Font.Code, TextSize=14, ClearTextOnFocus=true
    })

    local bindFrame = create("Frame", {Par=bg, Size=UDim2.new(1, 0, 0, 20), BackgroundTransparency=1})
    local bindLayout = create("UIListLayout", {Par=bindFrame, FillDirection="Horizontal", SortOrder="LayoutOrder", Padding=UDim.new(0, 5)})

    local bindLbl = create("TextLabel", {
        Par=bindFrame, Size=UDim2.new(0, 0, 1, 0), BackgroundTransparency=1, 
        Text="Keybind: " .. bind.Name, TextColor3=Color3.new(1,1,1), Font=Enum.Font.Code, TextSize=14, 
        AutomaticSize="X", LayoutOrder=1
    })

    local changeBtn = create("TextButton", {
        Par=bindFrame, Size=UDim2.new(0, 60, 1, 0), BackgroundColor3=Color3.fromRGB(40,40,40), 
        Text="Change", TextColor3=Color3.new(1,1,1), Font=Enum.Font.Code, TextSize=12,
        LayoutOrder=2
    })

    local function toggleFly()
        flying = not flying
        statBtn.Text = "Flight: [ " .. (flying and "ON" or "OFF") .. " ]"
        statBtn.TextColor3 = flying and Color3.new(0.3,1,0.3) or Color3.new(1,0.3,0.3)
        
        local char = lp.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChild("Humanoid")
        if not root or not hum then return end

        if flying then
            hum.PlatformStand = true
            
            local bv = Instance.new("BodyVelocity")
            bv.Velocity = Vector3.zero
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bv.Parent = root
            
            task.spawn(function()
                while flying and root.Parent do
                    local delta = RunService.RenderStepped:Wait()
                    
                    local moveDir = hum.MoveDirection
                    local finalCFrame = root.CFrame
                    
                    if moveDir.Magnitude > 0 then
                        local camCFrame = cam.CFrame
                        
                        local travel = moveDir * (speed * delta * 60 * 0.1)
                        if (moveDir - camCFrame.LookVector * Vector3.new(1,0,1)).Magnitude < 1 then
                            travel = camCFrame.LookVector * (speed * delta * 60 * 0.1)
                        elseif (moveDir - -camCFrame.LookVector * Vector3.new(1,0,1)).Magnitude < 1 then
                            travel = -camCFrame.LookVector * (speed * delta * 60 * 0.1)
                        else
                            travel = moveDir * (speed * delta * 60 * 0.1)
                        end
                        
                        root.CFrame = root.CFrame + travel
                    end
                    bv.Velocity = Vector3.zero 
                end
                
                bv:Destroy()
                hum.PlatformStand = false
            end)
        else
            for _, v in pairs(root:GetChildren()) do
                if v:IsA("BodyVelocity") then v:Destroy() end
            end
            hum.PlatformStand = false
        end
    end

    table.insert(connections, statBtn.MouseButton1Click:Connect(toggleFly))

    table.insert(connections, sub.MouseButton1Click:Connect(function() 
        speed = math.max(1, speed - 5) 
        spdBox.Text = tostring(speed) 
    end))

    table.insert(connections, add.MouseButton1Click:Connect(function() 
        speed = math.min(500, speed + 5) 
        spdBox.Text = tostring(speed) 
    end))

    table.insert(connections, spdBox.FocusLost:Connect(function()
        local num = tonumber(spdBox.Text)
        if num then speed = num else spdBox.Text = tostring(speed) end
    end))

    local changingBind = false
    table.insert(connections, changeBtn.MouseButton1Click:Connect(function()
        changingBind = true
        changeBtn.Text = "..."
    end))

    table.insert(connections, UIS.InputBegan:Connect(function(input, gpe)
        if changingBind then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                bind = input.KeyCode
                bindLbl.Text = "Keybind: " .. bind.Name
                changeBtn.Text = "Change"
                changingBind = false
            end
        elseif input.KeyCode == bind and not gpe then
            toggleFly()
        end
    end))
end

local flyToggleHandle = TabHandles.Universal:Toggle({
    Title = "Fly GUI",
    Desc = "Dont use in games that has anti-fly, etc.",
    Value = false,
    Callback = function(state)
        if state then
            CreateGui()
        else
            DestroyGui()
        end
    end
})

local WsMethodHandle = TabHandles.Player:Dropdown({
       Title = "WalkSpeed Method",
       Desc = "Use manipulating method if default doesnt work, need high unc executor.",
       Values = { "Default", "Manipulating" },
       Value = WsMethod,
       Multi = false,
       AllowNone = false,
       Callback = function(option)
             WsMethod = option
             if option == "Manipulating" then
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
                    warn("[AzureHub] Executor does not support metatable hooking. Bypass skipped.")
                end
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
		if WalkToggle then applyBypassSpeed() end
	end
})
local WsSliderHandle = TabHandles.Player:Slider({
       Title = "WalkSpeed",
	Value = { Min = 16, Max = 100, Default = 16 },
	Callback = function(Value)
		currentSpeed = Value
		applyBypassSpeed()
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
                    for _, part in ipairs(plr.Character:GetDescendants()) do
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
		       if not gid then continue end
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
            configFile:Register("flyToggleHandle", flyToggleHandle)
            configFile:Register("WsMethodHandle", WsMethodHandle)
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
    configFile:Register("flyToggleHandle", flyToggleHandle)
    configFile:Register("WsMethodHandle", WsMethodHandle)
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
                configFile:Register("flyToggleHandle", flyToggleHandle)
                configFile:Register("WsMethodHandle", WsMethodHandle)
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