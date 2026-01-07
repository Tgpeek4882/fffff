local cloneref = cloneref or function(o) return o end
local Players = cloneref(game:GetService("Players"))
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local lp = Players.LocalPlayer
local username = lp.Name
local RunService = cloneref(game:GetService("RunService"))
local Http = cloneref(game:GetService("HttpService"))
local vim = cloneref(game:GetService("VirtualInputManager"))

local humanoid
local root
local character

local function uCR(char)
    character = char
    root = character:WaitForChild("HumanoidRootPart", 5)
    humanoid = character:WaitForChild("Humanoid", 5)
end

uCR(lp.Character or lp.CharacterAdded:Wait())
lp.CharacterAdded:Connect(function(newChar)
    uCR(newChar)
end)

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

local gid = 36015593
local bannedRanks = {
    ["Support Staff"] = true,
    ["Admin"] = true,
    ["Manager"] = true,
    ["Head Of Support"] = true,
    ["Dev"] = true,
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
    Title = "Azure Hub | Hunty Zombie ".. getTag(lp.Name),
    Author = "discord.gg/QmvpbPdw9J",
    Folder = "HuntyZombieHub",
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

local Combat
local Lobby
local Exploit
local inGame = game.PlaceId == 86076978383613
local inLobby = game.PlaceId == 103754275310547

if inGame then Combat = Tabs.Features:Tab({ Title = "|  Combat", Icon = "swords" }) end
if inLobby then 
    Lobby = Tabs.Features:Tab({ Title = "|  Lobby", Icon = "house" }) 
    Exploit = Tabs.Features:Tab({ Title = "|  Exploits", Icon = "cpu" })
end

local TabHandles = {
     Player = Tabs.Features:Tab({ Title = "|  Player", Icon = "users-round" }),
     Misc = Tabs.Features:Tab({ Title = "|  Misc", Icon = "layout-grid" }),
     Config = Tabs.Utilities:Tab({ Title = "|  Configuration", Icon = "settings" })
}

local updparagraph = Logs:Paragraph({
    Title = "Update Logs",
    Desc = "30.11.25\n[+] Updated To Latest Data\n[-] Equip Any Weapon (Patched) \n\n18.11.25\n[+] Updated To Latest Data\n[+] Mode Support: Payload\n[/] Objectives: Fix Wheels\n[/] Collect items: Boosts\n\n18.10.25\n[+] Equip Any Weapon (Premium, Detected)\n[+] Auto Hide On Low HP\n[/] Faster Attack\n\n11.10.25\n[+] In-Built God Mode (Raid Boss)\n[+] Auto Objectives\n[/] Weapons Studs Range (Auto Farm)\n[/] Various Bug Fixes\n\n6.10.25\n[+] Auto Perk\n[+] Auto Abillities\n[+] Auto Ultimate\n[/] Improved Everything\n\n5.10.25\n[+] Hunty Zombie",
    Locked = false,
    Buttons = {
        {
            Icon = "clipboard",
            Title = "Discord Server",
            Callback = function() setclipboard(discordLink) WindUI:Notify({ Title = "Discord Server", Content = "Link Copied!", Icon = "info", Duration = 2 }) end,
        }
    }
})

local loadinggui = lp.PlayerGui:FindFirstChild("LoadingMapGUI")
if loadinggui then loadinggui:Destroy() end

local antiAfkToggle = false
local NoclipToggle = false
local WalkToggle = false
local currentSpeed = 33
local Noclip = nil
local Clip = nil

local tool = character:FindFirstChildOfClass("Tool", true)
local DefaultAttackSpeed = tool and tool:GetAttribute("attackspeed")
local FastAttackSpeed = DefaultAttackSpeed

local Farming = false
local Collecting = false
local Opening = false
local Hiding = false
local AutoDoorsToggle = false
local AutoCollectToggle = false
local AutoFarmToggle = false
local AutoAttackToggle = true
local AutoPerkToggle = true
local AutoAbillitiesToggle = false
local AutoUltimateToggle = false
local AutoReplayToggle = false
local AutoObjectivesToggle = false
local AutoHideToggle = false
local SkillSelection = {}
local studsaway = 2
local studsdown = 0
local chosenweapon = ""
local chosenslot = 1
local chosenatkmode = "Untouchable"

character.ChildAdded:Connect(function(obj)
	if obj:IsA("Tool") then
		tool = obj
		DefaultAttackSpeed = tool:GetAttribute("attackspeed")
		tool:SetAttribute("attackspeed", FastAttackSpeed)
		
		local hasBoss = false
		for _, item in pairs(workspace:GetChildren()) do
			if item.Name == "Graveyard" or item.Name == "Shogun Castle" then
				hasBoss = true
				break
			end
		end
		
		if obj.Name == "Bow" then 
		    studsaway = 10
		    studsdown = hasBoss and 5 or 0
		elseif obj.Name == "Halloween Sword" then
		    studsaway = 7
		    studsdown = hasBoss and 5 or 0
		else 
		    studsaway = 2
		    studsdown = 0
		end
	end
end)

local function autohide()
       task.spawn(function()
              while AutoHideToggle do
                     task.wait(0.05)
                     if humanoid.Health <= 10 then
                        root.CFrame = root.CFrame + Vector3.new(0, 100, 0)
                        Hiding = true
                     else
                        Hiding = false
                     end
              end
       end)
end

local function collect()
    task.spawn(function()
        while AutoCollectToggle do
            task.wait(0.05)
            if Farming or Opening or Hiding then
                repeat task.wait(0.1) until not (Farming or Opening)
            end
            if not root then continue end

            local targetItem = nil

            local itemsFolder = workspace:FindFirstChild("Items")
            if itemsFolder then
                for _, item in ipairs(itemsFolder:GetDescendants()) do
                    if item:IsA("BasePart") and string.lower(item.Name):find("hitbox") then
                        targetItem = item
                        break
                    end
                end
            end
            
            if not targetItem then
                local dropsFolder = workspace:FindFirstChild("DropItems")
                if dropsFolder then
                    local drops = dropsFolder:GetChildren()
                    if #drops > 0 then
                        targetItem = drops[1]
                    end
                end
            end

            if not targetItem then
                Collecting = false
                task.wait(0.1)
                continue
            end

            Collecting = true
            
            local startTime = tick()
            while targetItem and targetItem.Parent and AutoCollectToggle and not Farming and not Opening do
                root.CFrame = targetItem.CFrame + Vector3.new(0, 0, 0)
                
                if tick() - startTime > 1 then
                    local offset = math.sin(tick() * 10) > 0 and 1 or -1
                    root.CFrame = targetItem.CFrame + Vector3.new(0, offset, 0)
                end
                
                task.wait(0.05)
                
                if not targetItem.Parent then
                    break
                end
            end
            
            Collecting = false
        end
    end)
end

local function attack()
    local buffers = {
        "\t\006\001",
        "\t\004\001",
        "\t\a\001",
        "\t\t\001"
    }

    for _, bufStr in ipairs(buffers) do
        local byteNet = ReplicatedStorage:FindFirstChild("ByteNetReliable")
        local buf = buffer.fromstring(bufStr)
        local timestamp = os.time()
        byteNet:FireServer(buf, {timestamp})
    end
end

local function autoattack()
	task.spawn(function()
		while AutoAttackToggle do
		       attack()
		       task.wait()
		end
	end)
end

local function autoabillities()
       local pg = lp:FindFirstChild("PlayerGui")
	task.spawn(function()
		while AutoAbillitiesToggle or AutoUltimateToggle or AutoPerkToggle do
			task.wait()
			local MS = pg:FindFirstChild("MainScreen")
			
		if SkillSelection or #SkillSelection > 0 then
			local map = {
				["Abillity 1 (Z)"] = "\t\002\001",
				["Abillity 2 (X)"] = "\t\005\001",
				["Abillity 3 (C)"] = "\t\001\001",
				["Abillity 4 (V)"] = "\t\b\001",
			}
			local mapnum = {
				["Abillity 1 (Z)"] = "1",
				["Abillity 2 (X)"] = "2",
				["Abillity 3 (C)"] = "3",
				["Abillity 4 (V)"] = "SP4Ability",
			}

			for _, skillName in ipairs(SkillSelection) do
				local bufStr = map[skillName]
				local numStr = mapnum[skillName]
				if bufStr and numStr then
				    local AH = MS:FindFirstChild("AbilityHotbar")
				    if numStr == "SP4Ability" then
				        local sp4 = MS:FindFirstChild("SP4Ability")
				        if sp4 then
			                   local detail = sp4:FindFirstChild("Detail")
			                    if detail then
				                 local tween = detail:FindFirstChild("tween_CD")
				                 if tween and tween.Offset.X >= 1 then
				                     local buf = buffer.fromstring(bufStr)
				                     local timestamp = os.time()
				game.ReplicatedStorage.ByteNetReliable:FireServer(buf, { timestamp })
				                 end
			                    end
		                       end
	                          else
		                    local slot = AH:FindFirstChild(numStr)
		                    if slot then
			                 local cd = slot:FindFirstChild("Cooldown")
			                 if cd then
				             local fr = cd:FindFirstChild("Frame")
				             if fr and fr.AbsoluteSize.Y >= 54 then
				                 local buf = buffer.fromstring(bufStr)
				                 local timestamp = os.time()
				game.ReplicatedStorage.ByteNetReliable:FireServer(buf, { timestamp })
				             end
			                 end
		                     end
	                          end
		               end
			end
		end

			if AutoUltimateToggle then
			       local fill = MS:FindFirstChild("UltBar"):FindFirstChild("Fill")
			       if fill and fill.AbsoluteSize.X >= 200 and fill.AbsoluteSize.Y >= 20 then
				    local ultBuf = buffer.fromstring("\t\003\001")
				    local timestamp = os.time()
				game.ReplicatedStorage.ByteNetReliable:FireServer(ultBuf, { timestamp })
				end
			end
			
			if AutoPerkToggle then
			       local fill = MS:FindFirstChild("LeftSide"):FindFirstChild("PlayerHUD"):FindFirstChild("Bars"):FindFirstChild("Perk"):FindFirstChild("Fill")
			       if fill and fill.AbsoluteSize.X >= 149 and fill.AbsoluteSize.Y >= 13 then
			           local perkBuf = buffer.fromstring("\014")
			           local timestamp = os.time()
			       game.ReplicatedStorage.ByteNetReliable:FireServer(perkBuf, { timestamp })
			       end
			end
		end
	end)
end

local Rooms
local function farmenemies()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name == "Rooms" and obj.Parent ~= workspace and obj.Parent:IsA("Model") then
            Rooms = obj
            break
        end
    end
    
    task.spawn(function()
        while AutoFarmToggle or AutoObjectivesToggle do
            task.wait()
            if Hiding then
                repeat task.wait() until not Hiding
            end

            local wheel = workspace.Terrain:FindFirstChild("Wheel")
            if wheel and AutoObjectivesToggle then
                local rootPart = wheel:FindFirstChild("Root") or wheel:FindFirstChildWhichIsA("BasePart")
                local prompt
                for _, desc in ipairs(wheel:GetDescendants()) do
                    if desc:IsA("ProximityPrompt") then
                        prompt = desc
                        break
                    end
                end
                
                if rootPart and prompt then
                    root.CFrame = rootPart.CFrame
                    fireproximityprompt(prompt, 999)
                    task.wait(0.5)
                    continue
                end
            end
            
            local entities = workspace:FindFirstChild("Entities")
            local zombieFolder = entities and entities:FindFirstChild("Zombie")
            
            local target
            local shortestDist = math.huge
            local hrp = root
            
            if zombieFolder then
                for _, z in ipairs(zombieFolder:GetChildren()) do
                    local zh = z:FindFirstChild("HumanoidRootPart")
                    if zh then
                        local dist = (zh.Position - hrp.Position).Magnitude
                        if dist < shortestDist then
                            shortestDist = dist
                            target = z
                        end
                    end
                end
            end
            
            if not target then
                local city = workspace:FindFirstChild("City")
                if city and AutoObjectivesToggle then
                    local hitboxPart
                    for _, desc in ipairs(city:GetDescendants()) do
                        if desc:IsA("BasePart") and 
                           string.lower(desc.Name):find("hitbox") and 
                           desc.Parent and desc.Parent.Name == "Base" then
                            hitboxPart = desc
                            break
                        end
                    end
                    
                    if hitboxPart then
                        while hitboxPart and hitboxPart.Parent and AutoObjectivesToggle and not target do
                            root.CFrame = hitboxPart.CFrame
                            task.wait()
                            
                            if zombieFolder then
                                for _, z in ipairs(zombieFolder:GetChildren()) do
                                    local zh = z:FindFirstChild("HumanoidRootPart")
                                    if zh then
                                        local dist = (zh.Position - hrp.Position).Magnitude
                                        if dist < 10 then
                                            target = z
                                            break
                                        end
                                    end
                                end
                            end
                        end
                        if target then continue end 
                    end
                end
            end

            if not target then
                local BR = Rooms and (Rooms:FindFirstChild("BossRoom") or Rooms:FindFirstChild("RooftopBoss"))
                if BR and AutoObjectivesToggle and not Collecting then
                    local gen = BR:FindFirstChild("generator") or BR:FindFirstChild("RadioObjective")
                    if gen then
                        local tpPart = gen:FindFirstChild("PrimaryPart") or gen:FindFirstChildWhichIsA("BasePart")
                        if tpPart then
                            root.CFrame = tpPart.CFrame * CFrame.new(0, 2, 0)
                            for _, obj in ipairs(gen:GetDescendants()) do
                                if obj:IsA("ProximityPrompt") then 
                                    task.spawn(function()
                                        fireproximityprompt(obj, 999) 
                                        task.wait()
                                        gen:Destroy()
                                    end)
                                end
                            end
                        end
                    end
                end
                Farming = false
                continue
            end

            Farming = true
            while AutoFarmToggle and target do
                local hrp = target:FindFirstChild("HumanoidRootPart")
                local head = target:FindFirstChild("Head")
                if not hrp or not head then break end

                local eh = head:FindFirstChild("EntityHealth")
                if eh then
                    local hb = eh:FindFirstChild("HealthBar")
                    if hb then
                        local b = hb:FindFirstChild("Bar")
                        if b then
                            local y = b.AbsoluteSize.Y
                            local x = b.AbsoluteSize.X
                            if x == 0 and y <= 4 and y > 0 then
                                target:Destroy()
                                break
                            end
                        end
                    end
                end
                local offsetPos = hrp.Position + hrp.CFrame.LookVector * (10 + studsaway) - Vector3.new(0, studsdown, 0)
                if chosenatkmode == "Untouchable" then root.CFrame = hrp.CFrame * CFrame.new(0, 0, studsaway) end
                if chosenatkmode == "Damage" then root.CFrame = CFrame.new(offsetPos, hrp.Position) end
                if not AutoAttackToggle then attack() end
                task.wait()
            end

            Farming = false
        end
    end)
end

local function opendoors()
	task.spawn(function()
		while AutoDoorsToggle do
			task.wait(0.5)
			if Collecting or not root then continue end

			local byteNet = ReplicatedStorage:WaitForChild("ByteNetReliable")
			local doorsFolder

			for _, obj in ipairs(workspace:GetDescendants()) do
				if obj.Name == "Doors" and obj:IsA("Folder") then
					doorsFolder = obj
					break
				end
			end

			if doorsFolder then
				for _, door in ipairs(doorsFolder:GetChildren()) do
					if door:IsA("Model") and not door.Name:find("_done") then
						task.delay(3, function()
							if AutoDoorsToggle and door.Parent and not door.Name:find("_done") then
								local buf = buffer.fromstring("\b\001")
								byteNet:FireServer(buf, { door })
								door.Name = door.Name .. "_done"
							end
						end)
					end
				end
			end
		end
	end)
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

local AutoFarmHandle
local FastAttackSliderHandle
local AutoCollectHandle
local AutoDoorsHandle
local AutoAttackHandle
local AutoPerkHandle
local AutoUltimateHandle
local AutoAbillitiesHandle
local AutoReplayHandle
local AutoObjectivesHandle
local AutoHideHandle

if inGame then
local WeaponSection = Combat:Section({
       Title = "Combat",
       Icon = "axe"
})
AutoFarmHandle = WeaponSection:Toggle({
       Title = "Auto Farm",
       Desc = "Automatically teleports to enemies and kills them.",
       Callback = function(state)
              AutoFarmToggle = state
              if state then farmenemies() end
       end
})
AutoAttackHandle = WeaponSection:Toggle({
       Title = "Auto Attack",
       Desc = "Automatically attacks all zombies near you.",
       Callback = function(state)
              AutoAttackToggle = state
              if state then autoattack() end
       end
})
FastAttackSliderHandle = WeaponSection:Slider({
       Title = "Fast Attack",
       Desc = "Sets your weapon's attack speed to slider's value.",
       Step = 0.1,
       Value = { Min = 0, Max = 100, Default = DefaultAttackSpeed },
       Callback = function(Value)
              FastAttackSpeed = Value
              if tool then
                  tool:SetAttribute("attackspeed", FastAttackSpeed);
              end
       end
})
AutoPerkHandle = WeaponSection:Toggle({
       Title = "Auto Perk (E)",
       Desc = "Automatically uses perk when the bar is ready.",
       Callback = function(state)
              AutoPerkToggle = state
              if state then autoabillities() end
       end
})
AutoUltimateHandle = WeaponSection:Toggle({
       Title = "Auto Ultimate (G)",
       Desc = "Automatically uses ultimate skill when the bar is ready.",
       Callback = function(state)
              AutoUltimateToggle = state
              if state then autoabillities() end
       end
})
AutoAbillitiesHandle = WeaponSection:Dropdown({
    Title = "Auto Abillities",
    Desc = "Automatically uses chosen abillities from the list.",
    Values = { "Abillity 1 (Z)", "Abillity 2 (X)", "Abillity 3 (C)", "Abillity 4 (V)" },
    Value = { "" },
    Multi = true,
    AllowNone = true,
    Callback = function(option)
        SkillSelection = option
        if #SkillSelection > 0 then
        AutoAbillitiesToggle = true
        autoabillities()
        end
    end
})

local GameplaySection = Combat:Section({
       Title = "Gameplay",
       Icon = "joystick"
})
AutoReplayHandle = GameplaySection:Toggle({
       Title = "Auto Replay",
       Desc = "Automatically presses replay button after the round ends.",
       Callback = function(state)
              AutoReplayToggle = state
       end
})
AutoObjectivesHandle = GameplaySection:Toggle({
       Title = "Auto Objectives",
       Desc = "Automatically complete objectives, for example radio/generator.",
       Callback = function(state)
              AutoObjectivesToggle = state
       end
})
AutoCollectHandle = GameplaySection:Toggle({
       Title = "Auto Collect Items",
       Desc = "Automatically collects dropped items by entities (coins/items/hps).",
       Callback = function(state)
              AutoCollectToggle = state
              if state then collect() end
       end
})
AutoDoorsHandle = GameplaySection:Toggle({
       Title = "Auto Open Doors",
       Desc = "Automatically opens doors.",
       Callback = function(state)
              AutoDoorsToggle = state
              if state then opendoors() end
       end
})

local MiscSection = Combat:Section({
       Title = "Misc",
       Icon = "layout-grid"
})
AutoHideHandle = MiscSection:Toggle({
       Title = "Auto Hide On Low HP",
       Desc = "Teleports you to the safe spot if your HP < 10.",
       Callback = function(state)
              AutoHideToggle = state
              if state then autohide() end
              if not state then Hiding = false end
       end
})
MiscSection:Dropdown({
       Title = "Auto Farm Mode",
       Values = { "Untouchable", "Damage" },
       Value = "Untouchable",
       AllowNone = true,
       Callback = function(option)
           chosenatkmode = option
       end
})
MiscSection:Button({
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

AutoAttackHandle:Set(true)
AutoPerkHandle:Set(true)
end

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
	Value = { Min = 16, Max = 100, Default = 33 },
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
            configFile:Register("AutoObjectivesHandle", AutoObjectivesHandle)
            configFile:Register("AutoReplayHandle", AutoReplayHandle)
            configFile:Register("AutoPerkHandle", AutoPerkHandle)
            configFile:Register("AutoAbillitiesHandle", AutoAbillitiesHandle)
            configFile:Register("AutoUltimateHandle", AutoUltimateHandle)
            configFile:Register("AutoAttackHandle", AutoAttackHandle)
            configFile:Register("AutoFarmHandle", AutoFarmHandle)
            configFile:Register("AutoCollectHandle", AutoCollectHandle)
            configFile:Register("AutoDoorsHandle", AutoDoorsHandle)
            configFile:Register("FastAttackSliderHandle", FastAttackSliderHandle)
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
local autoLoadFile = "AZUREHUB_ALC_HZ.txt"
local ALC = false

if ConfigManager then
    ConfigManager:Init(Window)

    configFile = ConfigManager:CreateConfig(configName)
    configFile:Register("AutoObjectivesHandle", AutoObjectivesHandle)
    configFile:Register("AutoReplayHandle", AutoReplayHandle)
    configFile:Register("AutoPerkHandle", AutoPerkHandle)
    configFile:Register("AutoAbillitiesHandle", AutoAbillitiesHandle)
    configFile:Register("AutoUltimateHandle", AutoUltimateHandle)
    configFile:Register("AutoAttackHandle", AutoAttackHandle)
    configFile:Register("AutoFarmHandle", AutoFarmHandle)
    configFile:Register("AutoCollectHandle", AutoCollectHandle)
    configFile:Register("AutoDoorsHandle", AutoDoorsHandle)
    configFile:Register("FastAttackSliderHandle", FastAttackSliderHandle)
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
                Content = "Saved as: " .. configName,
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
            end
            local loadedData = configFile:Load()
            if loadedData then
                WindUI:Notify({ 
                    Title = "Load Config", 
                    Content = "Loaded: " .. configName .. "\nLast save: " .. (loadedData.lastSave or "Unknown"),
                    Icon = "refresh-cw",
                    Duration = 5
                })
            else
                WindUI:Notify({ 
                    Title = "Load Config", 
                    Content = "Failed to load config: " .. configName,
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