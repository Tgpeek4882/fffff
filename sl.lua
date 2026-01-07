local cloneref = cloneref or function(o) return o end
local Players = cloneref(game:GetService("Players"))
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local RunService = cloneref(game:GetService("RunService"))
local ServerScriptService = cloneref(game:GetService("ServerScriptService"))
local lp = Players.LocalPlayer
local username = lp.Name
local Camera = workspace.CurrentCamera
local UserInputService = cloneref(game:GetService("UserInputService"))
local PlayerGUI = lp:FindFirstChildOfClass("PlayerGui")
local VIM = cloneref(game:GetService("VirtualInputManager"))
local GuiService = cloneref(game:GetService("GuiService"))
local rollargs = { buffer.fromstring("\000\001"), {}}
local rollremote = ReplicatedStorage.ZAP.SPIN_RELIABLE

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

local blacklist = {"Tatlis"}
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

local gid = 1032198460
local bannedRanks = {"Owner", "Admin", "Community Managers", "MODERATOR", "Support", "Tester"}

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
    Title = "Azure Hub | Slap " .. getTag(lp.Name),
    Author = "discord.gg/QmvpbPdw9J",
    Folder = "SlapHub",
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
     Attacker = Tabs.Features:Tab({ Title = "|  Attacker", Icon = "swords" }),
     Defender = Tabs.Features:Tab({ Title = "|  Defender", Icon = "shield" }),
     Lobby = Tabs.Features:Tab({ Title = "| Lobby", Icon = "orbit" }),
     Player = Tabs.Features:Tab({ Title = "|  Player", Icon = "users-round" }),
     Misc = Tabs.Features:Tab({ Title = "|  Misc", Icon = "layout-grid" }),
     Config = Tabs.Utilities:Tab({ Title = "|  Configuration", Icon = "settings" })
}

local updparagraph = Logs:Paragraph({
    Title = "Update Logs",
    Desc = "3.12.25\n[+] Fake Feint\n[+] Fake Slap\n[+] Auto Demon Fox\n[+] Auto Bat (Untested)\n[+] Auto Roll Style\n[+] Target Style\n\n28.12.25\n[/] Updated To Latest Data\n[+] Auto Counter Slap\n- Must have demon fox/heavyweight.\n\n21.12.25\n[+] Auto Dodge: Demon Fox\n[/] Updated To Latest Data\n\n16.12.25\n[/] Improved Auto Dodge (Bat)\n[/] Fixed Bugs\n\n14.12.25\n[+] Randomized Buffers (Premium, No Detections)\n[/] Improve Auto Dodge\n- Supported Auto Dodge: Slap, Ninja, Swap, Heavyweight, Bat, Demon Fox.\n\n13.12.25\n[+] Slap\n[+] Features\n[+] Fixed Detections",
    Locked = false,
    Buttons = {
        {
            Icon = "clipboard",
            Title = "Discord Server",
            Callback = function() setclipboard(discordLink) WindUI:Notify({ Title = "Discord Server", Content = "Link Copied!", Icon = "info", Duration = 2 }) end,
        }
    }
})

local AutoCounterToggle = false
local AutoDodgeToggle = false
local AutoDodgeChance = 100
local AutoFoxToggle = false
local AutoHeavyweightToggle = false
local AutoBatToggle = false
local NotifyOnFail = false
local AutoRollToggle = false
local AutoRollType = {}
local lastPress = 0

local WalkToggle = false
local currentSpeed = 16
local Noclip = nil
local Clip = nil
local NoclipToggle = false

local antiAfkToggle = false
local FlingToggle = false
local antiFlingToggle = false
local flingThread

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

local function getQTEContainer()
    local gui = lp.PlayerGui:FindFirstChild("SlapGameUI")
    if not gui then return nil end
    
    local huds = {"InGameHUD", "InGameHUD_Mobile"}
    for _, hudName in ipairs(huds) do
        local hud = gui:FindFirstChild(hudName)
        if hud then
            local qte = hud:FindFirstChild("QuickTimeEvent")
            if qte and qte.Visible and qte:FindFirstChild("Container") and qte.Container.Visible then
                return qte.Container
            end
        end
    end
    return nil
end

local function isMatch(indicatorRot, targetRot)
    local startZone = (targetRot + 4) % 360
    local endZone = (targetRot + 34) % 360
    local curr = indicatorRot % 360
    
    if startZone < endZone then
        return curr >= startZone and curr <= endZone
    else
        return curr >= startZone or curr <= endZone
    end
end

local Minigames = TabHandles.Attacker:Section({ 
    Title = "Minigames",
    Icon = "joystick"
})
local HeavyweightHandle = Minigames:Toggle({
	Title = "Auto Perfect Heavyweight",
	Desc = "Clicks if bar is in green zone in heavyweight minigame.",
	Value = false,
	Callback = function(state)
		AutoHeavyweightToggle = state
	end
})
local BatHandle = Minigames:Toggle({
	Title = "Auto Perfect Bat",
	Desc = "Perfectly completes bat QTE.",
	Value = false,
	Callback = function(state)
		AutoBatToggle = state
	end
})
local Exploits = TabHandles.Attacker:Section({ 
    Title = "Exploits",
    Icon = "cpu"
})
Exploits:Button({
    Title = "Fake Feint",
    Callback = function()
        local anim = Instance.new("Animation")
        anim.AnimationId = "rbxassetid://124993162767405"
        local track = hum:LoadAnimation(anim)
        track:Play()
    end
})
Exploits:Button({
    Title = "Fake Slap",
    Callback = function()
        local anim = Instance.new("Animation")
        anim.AnimationId = "rbxassetid://78039768731258"
        local track = hum:LoadAnimation(anim)
        track:Play()
    end
})

local Dodging = TabHandles.Defender:Section({ 
    Title = "Dodging",
    Icon = "shield"
})
local DodgeHandle = Dodging:Toggle({
	Title = "Auto Dodge",
	Desc = "Dodges opponent's slap.",
	Value = false,
	Callback = function(state)
		AutoDodgeToggle = state
	end
})
local DodgeChanceHandle = Dodging:Slider({
       Title = "Dodging Chance",
       Desc = "Chance of successfully dodging opponent's slap.",
       Step = 1,
	Value = { Min = 0, Max = 100, Default = 100 },
	Callback = function(Value)
		AutoDodgeChance = tonumber(Value)
	end
})
local NotifyOnFailHandle = Dodging:Toggle({
	Title = "Notify On Fail",
	Desc = "You'll get notified if dodging fails (chance > " .. AutoDodgeChance .. ")",
	Value = false,
	Callback = function(state)
		NotifyOnFail = state
	end
})
local Countering = TabHandles.Defender:Section({ 
    Title = "Countering",
    Icon = "swords"
})
local CounterHandle = Countering:Toggle({
	Title = "Auto Counter Slap",
	Desc = "Counters opponent's slap if you have counter style.",
	Value = false,
	Callback = function(state)
		AutoCounterToggle = state
	end
})
local DemonFoxHandle = Countering:Toggle({
	Title = "Auto Demon Fox",
	Desc = "Perfectly completes demon fox QTE.",
	Value = false,
	Callback = function(state)
		AutoFoxToggle = state
	end
})

local AutoRollHandle
AutoRollHandle = TabHandles.Lobby:Toggle({
	Title = "Auto Roll Style",
	Desc = "Automatically spins for you, stops once target style drops.",
	Value = false,
	Callback = function(state)
		if not AutoRollType then
		    WindUI:Notify({ Title = "Azure Hub", Content = "Choose Target Style.", Icon = "triangle-alert", Duration = 2 })
		    AutoRollToggle = false
		    AutoRollHandle:Set(false)
		else
		    AutoRollToggle = state
		end
	end
})
local RollDropdownHandle = TabHandles.Lobby:Dropdown({
        Title = "Target Style",
        Values = { "Ninja", "Magician", "All or Nothing", "Mind Reader", "Rabbit", "Swap", "Heavyweight", "Bat", "Demon Fox", "Copy" },
        Value = { "" },
        Multi = true,
        AllowNone = false,
        Callback = function(option)
              AutoRollType = option
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
       Step = 1,
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
            configFile:Register("RollDropdownHandle", RollDropdownHandle)
            configFile:Register("AutoRollHandle", AutoRollHandle)
            configFile:Register("NotifyOnFailHandle", NotifyOnFailHandle)
            configFile:Register("DodgeChanceHandle", DodgeChanceHandle)
            configFile:Register("CounterHandle", CounterHandle)
            configFile:Register("DodgeHandle", DodgeHandle)
            configFile:Register("DemonFoxHandle", DemonFoxHandle)
            configFile:Register("BatHandle", BatHandle)
            configFile:Register("HeavyweightHandle", HeavyweightHandle)
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
local autoLoadFile = "AZUREHUB_ALC_SL.txt"
local ALC = false

if ConfigManager then
    ConfigManager:Init(Window)
    
    configFile = ConfigManager:CreateConfig(configName)
    configFile:Register("RollDropdownHandle", RollDropdownHandle)
    configFile:Register("AutoRollHandle", AutoRollHandle)
    configFile:Register("NotifyOnFailHandle", NotifyOnFailHandle)
    configFile:Register("DodgeChanceHandle", DodgeChanceHandle)
    configFile:Register("CounterHandle", CounterHandle)
    configFile:Register("DodgeHandle", DodgeHandle)
    configFile:Register("DemonFoxHandle", DemonFoxHandle)
    configFile:Register("BatHandle", BatHandle)
    configFile:Register("HeavyweightHandle", HeavyweightHandle)
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
                configFile:Register("RollDropdownHandle", RollDropdownHandle)
                configFile:Register("AutoRollHandle", AutoRollHandle)
                configFile:Register("NotifyOnFailHandle", NotifyOnFailHandle)
                configFile:Register("DodgeChanceHandle", DodgeChanceHandle)
                configFile:Register("CounterHandle", CounterHandle)
                configFile:Register("DodgeHandle", DodgeHandle)
                configFile:Register("DemonFoxHandle", DemonFoxHandle)
                configFile:Register("BatHandle", BatHandle)
                configFile:Register("HeavyweightHandle", HeavyweightHandle)
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

workspace.ChildAdded:Connect(function(obj)
    local gui = lp:FindFirstChildOfClass("PlayerGui")
    local slapGameUI = gui and gui:FindFirstChild("SlapGameUI")
    if not slapGameUI then return end
    
    local inGameHUD = slapGameUI:FindFirstChild("InGameHUD") or slapGameUI:FindFirstChild("InGameHUD_Mobile")
    local container = inGameHUD and inGameHUD:FindFirstChild("BattleOptions") and inGameHUD.BattleOptions:FindFirstChild("Container")
    local feint = container and (container:FindFirstChild("Feint") or container:FindFirstChild("feint"))
    local abilityLabel = container and container:FindFirstChild("Ability"):FindFirstChild("Contents"):FindFirstChild("Text")
    
    if not feint then return end
    
    local dodgeSounds = {
        "71441046303493", "74444335852537", "110521080732746", 
        "124228381910843", "132891780242917", "78547033616792"
    }
    local counterSounds = {
        "71441046303493", "74444335852537", "110521080732746", 
        "124228381910843", "132891780242917"
    }

    local targetSound = nil
    if obj:IsA("Sound") then
        targetSound = obj
    elseif obj:IsA("BasePart") or obj:IsA("Model") then
        targetSound = obj:FindFirstChildOfClass("Sound")
    end

    if targetSound then
        if AutoDodgeToggle and not feint.Visible then
            local idMatch = false
            for _, id in ipairs(dodgeSounds) do
                if targetSound.SoundId:find(id) then
                    idMatch = true
                    break
                end
            end

            if idMatch then
                local chance = math.random(0, 99)
                if chance <= AutoDodgeChance then
                    local randomT = math.random(5, 10) / 100
                    task.spawn(function()
                        task.wait(randomT)
                        
                        local bufferToUse
                        if getTag(lp.Name) == "[ PREMIUM ]" then
                            local premiumBuffers = {
                                buffer.fromstring("\001;\140\017R\160O\218A"),
                                buffer.fromstring("\001.\174vI\160O\218A"), 
                                buffer.fromstring("\001|\r\195o\160O\218A"),
                                buffer.fromstring("\001j\222\169\220|O\218A")
                            }
                            bufferToUse = premiumBuffers[math.random(#premiumBuffers)]
                        else
                            bufferToUse = buffer.fromstring("\001j\222\169\220|O\218A")
                        end
                        
                        local zap = game:GetService("ReplicatedStorage"):FindFirstChild("ZAP")
                        local combat = zap and zap:FindFirstChild("COMBAT_RELIABLE")
                        if combat then
                            combat:FireServer(bufferToUse, {})
                        end
                    end)
                else
                    WindUI:Notify({
                        Title = "Asure Hub",
                        Content = chance .. " > " .. AutoDodgeChance .. " (Dodge Failed)",
                        Icon = "triangle-alert",
                        Duration = 1.5
                    })
                end
            end
        end
        
        if AutoCounterToggle and abilityLabel and not feint.Visible then
            local isCounterSound = false
            for _, id in ipairs(counterSounds) do
                if targetSound.SoundId:find(id) then
                    isCounterSound = true
                    break
                end
            end
            
            if isCounterSound then
                local rawText = abilityLabel.ContentText or ""
                local cleanText = string.lower(string.gsub(rawText, "[^%w]", ""))

                if cleanText == "demonfox" or cleanText == "brace" then
                    local realtext = cleanText
                    local lengthByte = "\b"

if cleanText == "brace" then
    realtext = "heavyweight"
    lengthByte = "\v"
end

local args = {
    buffer.fromstring("\000" .. lengthByte .. "\000" .. realtext),
    {}
}
                    
                    local zap = game:GetService("ReplicatedStorage"):FindFirstChild("ZAP")
                    local abilityRel = zap and zap:FindFirstChild("ABILITY_RELIABLE")
                    
                    if abilityRel then
                        abilityRel:FireServer(unpack(args))
                    end
                end
            end
        end
    end
end)

local highPingNotified = false
local lastPingCheck = 0

local qteArea = nil
local wasQTEVisible = false
local batLoopActive = false
local lastBatFire = 0
local visibilityStartTime = 0

local function fireBat()
    local args = { buffer.fromstring("\001"), {} }
    game:GetService("ReplicatedStorage"):WaitForChild("ZAP"):WaitForChild("BAT_RELIABLE"):FireServer(unpack(args))
end

RunService.Heartbeat:Connect(function()
    if not character then return end
    if AutoDodgeToggle then
        local head = character:FindFirstChild("Head")
        if head then
            for _, model in pairs(workspace:GetChildren()) do
                if model:IsA("Model") and model:FindFirstChild("Bat") then
                    local bat = model.Bat
                    local batPart = bat:IsA("BasePart") and bat or bat:FindFirstChildWhichIsA("BasePart")
                    
                    if batPart and (head.Position - batPart.Position).Magnitude <= 2 then
                        local bufferToUse
                        if getTag(lp.Name) == "[ PREMIUM ]" then
                            local premiumBuffers = {
                                buffer.fromstring("\001;\140\017R\160O\218A"),
                                buffer.fromstring("\001.\174vI\160O\218A"), 
                                buffer.fromstring("\001|\r\195o\160O\218A"),
                                buffer.fromstring("\001j\222\169\220|O\218A")
                            }
                            bufferToUse = premiumBuffers[math.random(#premiumBuffers)]
                        else
                            bufferToUse = buffer.fromstring("\001j\222\169\220|O\218A")
                        end
                        
                        game:GetService("ReplicatedStorage"):WaitForChild("ZAP"):WaitForChild("COMBAT_RELIABLE"):FireServer(bufferToUse, {})
                        break
                    end
                end
            end
        end
    end
    
    local gui = lp:FindFirstChildOfClass("PlayerGui")
    local slapGameUI = gui and gui:FindFirstChild("SlapGameUI")
    local inGameHUD = slapGameUI and (slapGameUI:FindFirstChild("InGameHUD") or slapGameUI:FindFirstChild("InGameHUD_Mobile"))

    if inGameHUD then
        if AutoHeavyweightToggle then
            local frame = inGameHUD:FindFirstChild("HeavyweightSlider")
            if frame and frame.Visible then
                local spot = frame:FindFirstChild("Spot")
                local marker = frame:FindFirstChild("Marker")
                
                if spot and marker and spot.Visible and marker.Visible then
                    local mPos = marker.AbsolutePosition
                    local mSize = marker.AbsoluteSize
                    local sPos = spot.AbsolutePosition
                    local sSize = spot.AbsoluteSize
    
                    local markerInSpot = mPos.X >= sPos.X and mPos.X + mSize.X <= sPos.X + sSize.X and mPos.Y >= sPos.Y and mPos.Y + mSize.Y <= sPos.Y + sSize.Y
    
                    if markerInSpot then
                        local battleOptions = inGameHUD:FindFirstChild("BattleOptions")
                        local container = battleOptions and battleOptions:FindFirstChild("Container")
                        local slap = container and (container:FindFirstChild("Slap") or container:FindFirstChild("slap"))
                        
                        if slap and slap.Visible then
                            local slapPos = slap.AbsolutePosition
                            local slapSize = slap.AbsoluteSize
                            local clickX = slapPos.X + slapSize.X/2
                            local clickY = slapPos.Y + slapSize.Y/2
    
                            task.spawn(function()
                                VIM:SendMouseButtonEvent(clickX, clickY, 0, true, game, 0)
                                VIM:SendMouseButtonEvent(clickX, clickY, 0, false, game, 0)
                            end)
                        end
                    end
                end
            end
        end

        if AutoFoxToggle then
            local qteEvent = inGameHUD:FindFirstChild("QuickTimeEvent")
            local container = qteEvent and qteEvent:FindFirstChild("Container")
            
            if qteEvent and qteEvent.Visible and container and container.Visible then
                local indicator = container:FindFirstChild("Indicator")
                local target = container:FindFirstChild("Target")
            
                if indicator and target then
                    local indRot = indicator.Rotation
                    local tgtRot = target.Rotation
                
                    if isMatch(indRot, tgtRot) then
                        if os.clock() - lastPress > 0.05 then
                            VIM:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                            task.wait()
                            VIM:SendKeyEvent(false, Enum.KeyCode.Space, false, game)               
                            lastPress = os.clock()
                        end
                    end
                end
            end
        end

        if AutoBatToggle then
            local qteArea = inGameHUD:FindFirstChild("QTEArea")
            if qteArea then
                for _, child in ipairs(qteArea:GetChildren()) do
                    if (child:IsA("GuiButton") or child:IsA("ImageButton")) and child.Visible then
                        task.spawn(function()
                            fireBat()
                        end)
                    end
                end
            end
        end
    end
end)

task.spawn(function()
   while task.wait(0.1) do
       if lp and AutoRollToggle then
        local gui = lp:FindFirstChildOfClass("PlayerGui")
        if not gui then return end

        local slapGameUI = gui:FindFirstChild("SlapGameUI")
        if not slapGameUI then return end

        local StyleHUD = slapGameUI:FindFirstChild("StyleHUD")
        if not StyleHUD then return end
        
        local Path = StyleHUD:FindFirstChild("CurrentStyle"):FindFirstChild("Style"):FindFirstChild("TopLayer"):FindFirstChild("TextLabel")
        if not Path then return end
        
        local Current = Path.ContentText
        if not table.find(AutoRollType, Current) then
            rollremote:FireServer(buffer.fromstring("\000\001"))
            rollremote:FireServer(buffer.fromstring("\000\003"))
            task.wait(0.1)
        end
    end
   end
end)

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