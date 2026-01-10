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
local Net = require(ReplicatedStorage:WaitForChild("Packages").Net)
local UseItem = Net:RemoteEvent("UseItem")

local character
local hum
local root

local function uCR(char)
    if not char then return end
    character = char
    root = character:WaitForChild("HumanoidRootPart", true)
    hum = character:WaitForChild("Humanoid", true)
    local Plots = workspace:FindFirstChild("Plots")
if Plots then
     for _, Plot in ipairs(Plots:GetChildren()) do
        local PlotSign = Plot:FindFirstChild("PlotSign")
        if PlotSign then
            local YourBase = PlotSign:FindFirstChild("YourBase")
            if YourBase and YourBase.Enabled then
                local hitbox = Plot:FindFirstChild("DeliveryHitbox")
                if hitbox then
                    local att0 = Instance.new("Attachment", root)
                    local att1 = Instance.new("Attachment", workspace.Terrain)
                    att1.WorldPosition = hitbox.Position
                    local beam = Instance.new("Beam", root)
                    beam.Attachment0 = att0
                    beam.Attachment1 = att1
                    beam.FaceCamera = true
                    beam.Width0 = 0.5
                    beam.Width1 = 0.5
                    beam.Color = ColorSequence.new(Color3.fromRGB(114, 254, 0))
                end
            end
        end
    end
end
end

uCR(lp.Character or lp.CharacterAdded:Wait())
lp.CharacterAdded:Connect(function(newChar)
    uCR(newChar)
end)

lp:GetPropertyChangedSignal("Character"):Connect(function()
    if lp.Character then
        uCR(lp.Character)
    end
end)

local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/Tgpeek4882/fffff/refs/heads/main/sablib.lua'))()

-- prioritized locals (functions)
local SavedPosition = root.Position
local AimbotToggle = false
local InstantStealToggle = false
local WebNoclipToggle = false
local InfiniteJumpToggle = false
local JumpBoostToggle = false
local XRayToggle = false
local EspHighestToggle = false
local EspPlayersToggle = false
local EspTimersToggle = false

-- trash locals (non functions)
local Desynced = false
local connections = {}
local anim = Instance.new("Animation")
anim.AnimationId = "rbxassetid://126995783634131"
local loadedAnim = nil
local Noclip = nil
local Clip = nil
local NoclipToggle = false
local isInvisible
local isPlatform
local slabPart
local isBoost
local isDesync

local Plots = workspace:FindFirstChild("Plots")
if Plots then
     for _, Plot in ipairs(Plots:GetChildren()) do
        local PlotSign = Plot:FindFirstChild("PlotSign")
        if PlotSign then
            local YourBase = PlotSign:FindFirstChild("YourBase")
            if YourBase and YourBase.Enabled then
                local hitbox = Plot:FindFirstChild("DeliveryHitbox")
                if hitbox then
                    local att0 = Instance.new("Attachment", root)
                    local att1 = Instance.new("Attachment", workspace.Terrain)
                    att1.WorldPosition = hitbox.Position
                    local beam = Instance.new("Beam", root)
                    beam.Attachment0 = att0
                    beam.Attachment1 = att1
                    beam.FaceCamera = true
                    beam.Width0 = 0.5
                    beam.Width1 = 0.5
                    beam.Color = ColorSequence.new(Color3.fromRGB(114, 254, 0))
                end
            end
        end
    end
end
            

local lR, rI = 0, 1
local animalsModule = game:GetService("ReplicatedStorage"):FindFirstChild("Datas") and game:GetService("ReplicatedStorage").Datas:FindFirstChild("Animals")
local AnimalsData = {}
if animalsModule then
    local s, r = pcall(require, animalsModule)
    if s then AnimalsData = r end
end

local LastBestBrainrot = nil
game:GetService("RunService").Heartbeat:Connect(function()
    local now = tick()
    if now - lR > rI then
        lR = now

        local character = lp.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")

        for _, obj in ipairs(workspace:GetChildren()) do
            if EspPlayersToggle then
                if obj:IsA("Model") and obj:FindFirstChild("Head") then
                    for _, part in ipairs(obj:GetChildren()) do
                        if part:IsA("BasePart") and part.Name ~= "__HITBOX" then
                            part.Transparency = 0
                        end
                    end
                    
                    local isClone = string.find(string.lower(obj.Name), "clone")
                    local highlight = obj:FindFirstChild("ESPHighlight")
                    if not highlight then
                        highlight = Instance.new("Highlight")
                        highlight.Name = "ESPHighlight"
                        highlight.FillTransparency = 0.5
                        highlight.OutlineTransparency = 0
                        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        highlight.Adornee = obj
                        highlight.Parent = obj
                    end
                    highlight.OutlineColor = Color3.new(1, 1, 1)
                    if isClone then highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    else highlight.FillColor = Color3.fromRGB(0, 255, 0) end
                end
            else
                if obj:FindFirstChild("ESPHighlight") then obj.ESPHighlight:Destroy() end
            end
        end

        local plotsFolder = workspace:FindFirstChild("Plots")
        
        if plotsFolder and EspTimersToggle then
            for _, plot in ipairs(plotsFolder:GetChildren()) do
                local purchases = plot:FindFirstChild("Purchases")
                local plotBlock = purchases and purchases:FindFirstChild("PlotBlock")
                local mainPart = plotBlock and plotBlock:FindFirstChild("Main")
                if mainPart then
                    local originalGui = mainPart:FindFirstChild("BillboardGui")
                    local originalLabel = originalGui and originalGui:FindFirstChild("RemainingTime")
                    if originalLabel then
                        local timerEsp = mainPart:FindFirstChild("TimerESP")
                        if not timerEsp then
                            timerEsp = Instance.new("BillboardGui")
                            timerEsp.Name = "TimerESP"
                            timerEsp.Size = UDim2.new(0, 100, 0, 40)
                            timerEsp.StudsOffset = Vector3.new(0, 5, 0)
                            timerEsp.AlwaysOnTop = true
                            timerEsp.Adornee = mainPart
                            timerEsp.Parent = mainPart
                            local label = Instance.new("TextLabel")
                            label.Name = "TimeLabel"
                            label.Size = UDim2.new(1, 0, 1, 0)
                            label.BackgroundTransparency = 1
                            label.TextStrokeTransparency = 0
                            label.Font = Enum.Font.GothamBold
                            label.TextScaled = true
                            label.Parent = timerEsp
                        end
                        local timeValue = originalLabel.Text
                        local textLabel = timerEsp:FindFirstChild("TimeLabel")
                        if timeValue == "0" or timeValue == "" then
                            textLabel.Text = "Unlocked"
                            textLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                        else
                            textLabel.Text = timeValue
                            textLabel.TextColor3 = Color3.new(1, 1, 1)
                        end
                    end
                end
            end
        end

        if EspHighestToggle and plotsFolder then
            local bestGen = -1
            local bestObj = nil
            local bestData = nil

            for _, plot in ipairs(plotsFolder:GetChildren()) do
                local plotSign = plot:FindFirstChild("PlotSign")
                local yourBase = plotSign and plotSign:FindFirstChild("YourBase")
                if yourBase and yourBase.Enabled then
                    continue 
                end

                for _, item in ipairs(plot:GetChildren()) do
                    if item:IsA("Model") then
                        for _, data in pairs(AnimalsData) do
                            if data.DisplayName and item.Name == data.DisplayName then 
                                if data.Generation and data.Generation > bestGen then
                                    bestGen = data.Generation
                                    bestObj = item
                                    bestData = data
                                end
                                break 
                            end
                        end
                    end
                end
            end
            
            if LastBestBrainrot and LastBestBrainrot ~= bestObj then
                if LastBestBrainrot:FindFirstChild("BestESP") then LastBestBrainrot.BestESP:Destroy() end
                if LastBestBrainrot:FindFirstChild("BestBeam") then LastBestBrainrot.BestBeam:Destroy() end
            end
            LastBestBrainrot = bestObj

            if bestObj and bestData then
                local bRoot = bestObj:FindFirstChild("RootPart") or bestObj:FindFirstChild("FakeRootPart") or bestObj.PrimaryPart
                if bRoot then
                    local esp = bestObj:FindFirstChild("BestESP")
                    if not esp then
                        esp = Instance.new("BillboardGui")
                        esp.Name = "BestESP"
                        esp.Size = UDim2.new(0, 200, 0, 60) 
                        esp.StudsOffset = Vector3.new(0, 3, 0)
                        esp.AlwaysOnTop = true
                        esp.Parent = bestObj
                        esp.Adornee = bRoot
                        local tl = Instance.new("TextLabel")
                        tl.Size = UDim2.new(1,0,1,0)
                        tl.BackgroundTransparency = 1
                        tl.RichText = true
                        tl.Font = Enum.Font.GothamBold
                        tl.TextScaled = false
                        tl.TextSize = 18
                        tl.TextStrokeTransparency = 0
                        tl.Parent = esp
                    end
                    
                    if root then
                        local beam = bestObj:FindFirstChild("BestBeam")
                        
                        local att0 = root:FindFirstChild("BeamAtt0")
                        if not att0 then
                            att0 = Instance.new("Attachment")
                            att0.Name = "BeamAtt0"
                            att0.Parent = root
                        end

                        local att1 = bRoot:FindFirstChild("BeamAtt1")
                        if not att1 then
                            att1 = Instance.new("Attachment")
                            att1.Name = "BeamAtt1"
                            att1.Parent = bRoot
                        end

                        if not beam then
                            beam = Instance.new("Beam")
                            beam.Name = "BestBeam"
                            beam.Parent = bestObj
                            beam.FaceCamera = true
                            beam.Width0 = 0.5
                            beam.Width1 = 0.5
                            beam.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
                        end
                        beam.Attachment0 = att0
                        beam.Attachment1 = att1
                    end

                    local str = bestData.DisplayName or ""
                    local cleanName = ""
                    for i = 1, #str do
                        local b = string.byte(str, i)
                        if b >= 192 and b <= 197 then cleanName = cleanName .. "A"
                        elseif b == 199 then cleanName = cleanName .. "C"
                        elseif b >= 200 and b <= 203 then cleanName = cleanName .. "E"
                        elseif b >= 204 and b <= 207 then cleanName = cleanName .. "I"
                        elseif b >= 210 and b <= 216 then cleanName = cleanName .. "O"
                        elseif b >= 217 and b <= 220 then cleanName = cleanName .. "U"
                        elseif b >= 224 and b <= 229 then cleanName = cleanName .. "a"
                        elseif b == 231 then cleanName = cleanName .. "c"
                        elseif b >= 232 and b <= 235 then cleanName = cleanName .. "e"
                        elseif b >= 236 and b <= 239 then cleanName = cleanName .. "i"
                        elseif b >= 242 and b <= 248 then cleanName = cleanName .. "o"
                        elseif b >= 249 and b <= 252 then cleanName = cleanName .. "u"
                        else cleanName = cleanName .. string.char(b) end
                    end

                    local r = string.lower(tostring(bestData.Rarity or ""))
                    local rarityCol = "rgb(255, 255, 255)"
                    if r == "common" then rarityCol = "rgb(0, 100, 0)" 
                    elseif r == "rare" then rarityCol = "rgb(0, 0, 139)"
                    elseif r == "epic" then rarityCol = "rgb(75, 0, 130)"
                    elseif r == "legendary" then rarityCol = "rgb(255, 255, 0)"
                    elseif r == "mythic" then rarityCol = "rgb(139, 0, 0)"
                    elseif string.find(r, "brainrotgod") or string.find(r, "brainrot god") then
                        local t = tick() * 5; local col = Color3.fromHSV((t % 1), 1, 1)
                        rarityCol = string.format("rgb(%d, %d, %d)", col.R*255, col.G*255, col.B*255)
                    elseif r == "secret" then rarityCol = "rgb(255, 255, 255)" 
                    elseif r == "og" then rarityCol = "rgb(255, 215, 0)" end
                    
                    local function fmt(n)
                        n = tonumber(n) or 0
                        if n >= 1e9 then return string.format("%.2fB", n/1e9)
                        elseif n >= 1e6 then return string.format("%.2fM", n/1e6)
                        elseif n >= 1e3 then return string.format("%.2fK", n/1e3)
                        else return tostring(n) end
                    end

                    local line1 = string.format('<font color="%s">%s</font>', rarityCol, cleanName)
                    local line2 = string.format('<font color="rgb(0,255,0)">$%s</font> / <font color="rgb(255,255,0)">$%s</font>', fmt(bestData.Price), fmt(bestData.Generation))
                    
                    esp:FindFirstChild("TextLabel").Text = line1 .. "\n" .. line2
                end
            end
        elseif LastBestBrainrot then
            if LastBestBrainrot:FindFirstChild("BestESP") then LastBestBrainrot.BestESP:Destroy() end
            if LastBestBrainrot:FindFirstChild("BestBeam") then LastBestBrainrot.BestBeam:Destroy() end
            LastBestBrainrot = nil
        end
    end
end)

local function getClosest()
    local closestPlayer = nil
    local shortestDistance = math.huge
    
    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer ~= lp then
            local targetChar = targetPlayer.Character
            local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
            if targetHRP then
                local distance = (targetHRP.Position - root.Position).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestPlayer = targetPlayer
                end
            end
        end
    end
    return closestPlayer
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

local function Enable()
    if not setfflag then return end
    setfflag("GameNetPVHeaderRotationalVelocityZeroCutoffExponent", "-5000")
    setfflag("LargeReplicatorWrite5", "true")
    setfflag("LargeReplicatorEnabled9", "true")
    setfflag("TimestepArbiterVelocityCriteriaThresholdTwoDt", "2147483646")
    setfflag("S2PhysicsSenderRate", "15000")
    setfflag("DisableDPIScale", "true")
    setfflag("MaxDataPacketPerSend", "2147483647")
    setfflag("PhysicsSenderMaxBandwidthBps", "20000")
    setfflag("CheckPVCachedVelThresholdPercent", "10")
    setfflag("MaxMissedWorldStepsRemembered", "-2147483648")
    setfflag("WorldStepMax", "30")
    setfflag("StreamJobNOUVolumeLengthCap", "2147483647")
    setfflag("DebugSendDistInSteps", "-2147483648")
    setfflag("LargeReplicatorRead5", "true")
    setfflag("GameNetDontSendRedundantNumTimes", "1")
    setfflag("CheckPVLinearVelocityIntegrateVsDeltaPositionThresholdPercent", "1")
    setfflag("LargeReplicatorSerializeRead3", "true")
    setfflag("NextGenReplicatorEnabledWrite4", "true")
    setfflag("AngularVelociryLimit", "360")
    setfflag("CheckPVDifferencesForInterpolationMinRotVelThresholdRadsPerSecHundredth", "1")
    setfflag("GameNetDontSendRedundantDeltaPositionMillionth", "1")
    setfflag("InterpolationFrameVelocityThresholdMillionth", "5")
    setfflag("StreamJobNOUVolumeCap", "2147483647")
    setfflag("InterpolationFrameRotVelocityThresholdMillionth", "5")
    setfflag("CheckPVDifferencesForInterpolationMinVelThresholdStudsPerSecHundredth", "1")
    setfflag("ReplicationFocusNouExtentsSizeCutoffForPauseStuds", "2147483647")
    setfflag("InterpolationFramePositionThresholdMillionth", "5")
    setfflag("TimestepArbiterHumanoidTurningVelThreshold", "1")
    setfflag("SimOwnedNOUCountThresholdMillionth", "2147483647")
    setfflag("GameNetPVHeaderLinearVelocityZeroCutoffExponent", "-5000")
    setfflag("CheckPVCachedRotVelThresholdPercent", "10")
    setfflag("TimestepArbiterOmegaThou", "1073741823")
    setfflag("MaxAcceptableUpdateDelay", "1")
    setfflag("LargeReplicatorSerializeWrite4", "true")
end

local function Disable()
    if not setfflag then return end
    setfflag("GameNetPVHeaderRotationalVelocityZeroCutoffExponent", "-2")
    setfflag("LargeReplicatorWrite5", "true")
    setfflag("LargeReplicatorEnabled9", "true")
    setfflag("AngularVelociryLimit", "240")
    setfflag("TimestepArbiterVelocityCriteriaThresholdTwoDt", "250")
    setfflag("S2PhysicsSenderRate", "15")
    setfflag("DisableDPIScale", "false")
    setfflag("MaxDataPacketPerSend", "1")
    setfflag("PhysicsSenderMaxBandwidthBps", "38760")
    setfflag("CheckPVCachedVelThresholdPercent", "75")
    setfflag("MaxMissedWorldStepsRemembered", "16")
    setfflag("WorldStepMax", "30")
    setfflag("StreamJobNOUVolumeLengthCap", "100")
    setfflag("DebugSendDistInSteps", "5")
    setfflag("LargeReplicatorRead5", "true")
    setfflag("GameNetDontSendRedundantNumTimes", "5")
    setfflag("CheckPVLinearVelocityIntegrateVsDeltaPositionThresholdPercent", "1000")
    setfflag("LargeReplicatorSerializeRead3", "true")
    setfflag("NextGenReplicatorEnabledWrite4", "true")
    setfflag("CheckPVDifferencesForInterpolationMinVelThresholdStudsPerSecHundredth", "100")
    setfflag("CheckPVDifferencesForInterpolationMinRotVelThresholdRadsPerSecHundredth", "300")
    setfflag("GameNetDontSendRedundantDeltaPositionMillionth", "3000")
    setfflag("InterpolationFrameVelocityThresholdMillionth", "100")
    setfflag("StreamJobNOUVolumeCap", "10000")
    setfflag("InterpolationFrameRotVelocityThresholdMillionth", "100")
    setfflag("ReplicationFocusNouExtentsSizeCutoffForPauseStuds", "128")
    setfflag("InterpolationFramePositionThresholdMillionth", "100")
    setfflag("TimestepArbiterHumanoidTurningVelThreshold", "17")
    setfflag("CheckPVCachedRotVelThresholdPercent", "250")
    setfflag("GameNetPVHeaderLinearVelocityZeroCutoffExponent", "-2")
    setfflag("SimOwnedNOUCountThresholdMillionth", "1000")
    setfflag("TimestepArbiterOmegaThou", "10000")
    setfflag("MaxAcceptableUpdateDelay", "15")
    setfflag("LargeReplicatorSerializeWrite4", "true")
end

local function laser()
    if not root then return end
    local tool = (function() local items = {}; for _, c in pairs({lp.Backpack, character}) do for _, v in pairs(c:GetChildren()) do if v:IsA("Tool") then table.insert(items, v) end end end for _, n in pairs({"laser cape"}) do for _, v in pairs(items) do if v.Name:lower():find(n) then return v end end end end)()
            
    if tool and tool.Parent == lp.Backpack then
        hum:EquipTool(tool)
    end
            
    local closest = nil
    local maxDist = math.huge

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local Phum = p.Character:FindFirstChild("Humanoid")
            if Phum and Phum.Health > 0 then
                local dist = (root.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if dist < maxDist then
                    maxDist = dist
                    closest = p.Character.HumanoidRootPart
                end
            end
        end
    end

    if closest then
        local pos = closest.Position
        local args = {
            vector.create(pos.X, pos.Y, pos.Z),
            closest
        }
        UseItem:FireServer(unpack(args))
    end
end

local function fireaimbot(tool)
    if not character or not root then return end
    local closestPlayer = nil
    local closestChar = nil
    local maxDist = math.huge
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp and p.Character then
            local pRoot = p.Character:FindFirstChild("HumanoidRootPart")
            local pHum = p.Character:FindFirstChild("Humanoid")
            
            if pRoot and pHum and pHum.Health > 0 then
                local dist = (root.Position - pRoot.Position).Magnitude
                if dist < maxDist then
                    maxDist = dist
                    closestPlayer = p
                    closestChar = p.Character
                end
            end
        end
    end

    if closestPlayer and closestChar then
        local toolName = tool.Name:lower()
        local args = {}
        if toolName:find("laser") then
            local pos = closestChar.HumanoidRootPart.Position
            args = {
                vector.create(pos.X, pos.Y, pos.Z),
                closestChar.HumanoidRootPart
            }
        elseif toolName:find("web") or toolName:find("slinger") then
            local pos = closestChar.HumanoidRootPart.Position
            args = {
                vector.create(pos.X, pos.Y, pos.Z),
                closestChar.HumanoidRootPart
            }
        elseif toolName:find("beehive") then
            args = {
                closestPlayer
            }
        elseif toolName:find("taser") then
            local targetPart = closestChar:FindFirstChild("UpperTorso") or closestChar:FindFirstChild("HumanoidRootPart")
            args = {
                targetPart
            }
        end
        if #args > 0 then
            UseItem:FireServer(unpack(args))
        end
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if character and AimbotToggle then
            local tool = character:FindFirstChildWhichIsA("Tool")
            if tool then
                local name = tool.Name:lower()
                if name:find("laser") or name:find("beehive") or name:find("web") or name:find("slinger") or name:find("taser") then
                    fireaimbot(tool)
                end
            end
        end
    end
end)

local function flytobasegui()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local CoreGui = game:GetService("CoreGui")
    local LocalPlayer = Players.LocalPlayer

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = tostring(math.random(1, 1000000))
    ScreenGui.ResetOnSpawn = false
    
    if gethui then 
        ScreenGui.Parent = gethui() 
    elseif CoreGui then 
        ScreenGui.Parent = CoreGui 
    else 
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") 
    end

    local FlyButton = Instance.new("TextButton")
    FlyButton.Name = "ToggleBtn"
    FlyButton.Size = UDim2.new(0, 100, 0, 35)
    FlyButton.Position = UDim2.new(1, -110, 0, 10)
    FlyButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    FlyButton.Text = "Fly to Base (B)"
    FlyButton.TextColor3 = Color3.new(1, 1, 1)
    FlyButton.Font = Enum.Font.GothamBold
    FlyButton.TextSize = 12
    FlyButton.AutoButtonColor = true
    FlyButton.Parent = ScreenGui

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = FlyButton

    local IsFlying = false
    local FlyLoop = nil
    local InputConnection = nil

    local function ToggleFlight()
        if IsFlying then
            IsFlying = false
            if FlyLoop then FlyLoop:Disconnect() FlyLoop = nil end
            
            FlyButton.Text = "Fly to Base (B)"
            FlyButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            
            local Char = LocalPlayer.Character
            if Char and Char:FindFirstChild("Humanoid") then
                Char.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        else
            if not root or not hum then return end

            local TargetPart = nil
            local Plots = workspace:FindFirstChild("Plots")
            if Plots then
                for _, Plot in ipairs(Plots:GetChildren()) do
                    local PlotSign = Plot:FindFirstChild("PlotSign")
                    if PlotSign then
                        local YourBase = PlotSign:FindFirstChild("YourBase")
                        if YourBase and YourBase.Enabled then
                            TargetPart = Plot:FindFirstChild("DeliveryHitbox", true)
                            break
                        end
                    end
                end
            end

            if not TargetPart then
                FlyButton.Text = "No Base Found!"
                FlyButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
                task.delay(1, function() 
                    if not IsFlying then 
                        FlyButton.Text = "Fly to Base (B)" 
                        FlyButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                    end 
                end)
                return
            end

            IsFlying = true
            FlyButton.Text = "Stop (B)"
            FlyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
            
            hum:ChangeState(Enum.HumanoidStateType.Physics)
            
            FlyLoop = RunService.Heartbeat:Connect(function()
                if not IsFlying or not root then return end
                
                local TargetPos = TargetPart.Position
                local CurrentPos = root.Position
                
                local rel = TargetPart.CFrame:PointToObjectSpace(CurrentPos)
                local size = TargetPart.Size
                local inX = math.abs(rel.X) < (size.X / 2)
                local inZ = math.abs(rel.Z) < (size.Z / 2)
                local inY = math.abs(rel.Y) < (size.Y / 2) + 4
                local Dist = (TargetPos - CurrentPos).Magnitude

                if (inX and inZ and inY) or Dist < 4 then
                    ToggleFlight()
                    return
                end
                
                local Dir = (TargetPos - CurrentPos).Unit
                root.Velocity = Vector3.new(Dir.X * 26, -1.2, Dir.Z * 26)
            end)
        end
    end

    FlyButton.MouseButton1Click:Connect(ToggleFlight)

    InputConnection = UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Enum.KeyCode.B then
            ToggleFlight()
        end
    end)

    local function Destroy()
        if IsFlying then ToggleFlight() end
        if InputConnection then InputConnection:Disconnect() end
        ScreenGui:Destroy()
    end

    return Destroy
end

local function instantstealgui()
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local CoreGui = game:GetService("CoreGui")
    local LocalPlayer = Players.LocalPlayer
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = tostring(math.random(1, 1000000))
    ScreenGui.ResetOnSpawn = false
    
    if gethui then 
        ScreenGui.Parent = gethui() 
    elseif CoreGui then 
        ScreenGui.Parent = CoreGui 
    else 
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") 
    end

    local FlyCorner = Instance.new("UICorner")
    FlyCorner.CornerRadius = UDim.new(0, 8)
    FlyCorner.Parent = FlyButton

    local SetPosButton = Instance.new("TextButton")
    SetPosButton.Name = "SetPosBtn"
    SetPosButton.Size = UDim2.new(0, 100, 0, 35)
    SetPosButton.Position = UDim2.new(1, -220, 0, 10)
    SetPosButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    SetPosButton.Text = "Set Position (P)"
    SetPosButton.TextColor3 = Color3.new(1, 1, 1)
    SetPosButton.Font = Enum.Font.GothamBold
    SetPosButton.TextSize = 12
    SetPosButton.AutoButtonColor = true
    SetPosButton.Parent = ScreenGui

    local SetPosCorner = Instance.new("UICorner")
    SetPosCorner.CornerRadius = UDim.new(0, 8)
    SetPosCorner.Parent = SetPosButton

    local InputConnection = nil

    -- Define these OUTSIDE the function so we can access/delete them later
local CurrentBeam = nil
local CurrentAtt0 = nil
local CurrentAtt1 = nil

local function SetCurrentPosition()
    if not root then return end
    if CurrentBeam then CurrentBeam:Destroy() end
    if CurrentAtt0 then CurrentAtt0:Destroy() end
    if CurrentAtt1 then CurrentAtt1:Destroy() end
    
    SavedPosition = root.Position
    CurrentAtt0 = Instance.new("Attachment", root)
    CurrentAtt1 = Instance.new("Attachment", workspace.Terrain)
    CurrentAtt1.WorldPosition = root.Position
    
    CurrentBeam = Instance.new("Beam", root)
    CurrentBeam.Attachment0 = CurrentAtt0
    CurrentBeam.Attachment1 = CurrentAtt1
    CurrentBeam.FaceCamera = true
    CurrentBeam.Width0 = 0.2
    CurrentBeam.Width1 = 0.2
    CurrentBeam.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
    
    SetPosButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    SetPosButton.Text = "Position Saved!"
    
    task.delay(0.5, function()
        SetPosButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        SetPosButton.Text = "Set Position (P)"
    end)
end

    SetPosButton.MouseButton1Click:Connect(SetCurrentPosition)

    InputConnection = UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe then
            if input.KeyCode == Enum.KeyCode.P then
                SetCurrentPosition()
            end
        end
    end)

    local function Destroy()
        if InputConnection then InputConnection:Disconnect() end
        ScreenGui:Destroy()
    end

    return Destroy
end

local function invisibilitygui()
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local CoreGui = game:GetService("CoreGui")
    local lp = Players.LocalPlayer
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = tostring(math.random(1, 1000000))
    ScreenGui.ResetOnSpawn = false
    
    if gethui then 
        ScreenGui.Parent = gethui() 
    elseif CoreGui then 
        ScreenGui.Parent = CoreGui 
    else 
        ScreenGui.Parent = lp:WaitForChild("PlayerGui") 
    end

    local InvisButton = Instance.new("TextButton")
    InvisButton.Name = "InvisBtn"
    InvisButton.Size = UDim2.new(0, 100, 0, 35)
    InvisButton.Position = UDim2.new(1, -110, 0, 55)
    InvisButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    InvisButton.Text = "Invisibility (I)"
    InvisButton.TextColor3 = Color3.new(1, 1, 1)
    InvisButton.Font = Enum.Font.GothamBold
    InvisButton.TextSize = 12
    InvisButton.Parent = ScreenGui

    local SetPosCorner = Instance.new("UICorner")
    SetPosCorner.CornerRadius = UDim.new(0, 8)
    SetPosCorner.Parent = InvisButton
    
    local function ToggleInvisibility()
        local char = lp.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end

        isInvisible = not isInvisible

        if isInvisible then
            InvisButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
            InvisButton.Text = "ON (I)"
            
            for _, v in ipairs(character:GetChildren()) do
                if v:IsA("BasePart") then
                    v.Transparency = 1
                end
            end
            task.wait(0.1)
            if not loadedAnim then loadedAnim = hum:LoadAnimation(anim) end
            loadedAnim:Play()
            
            if noclip then noclip() end
        else
            InvisButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            InvisButton.Text = "Invisibility (I)"
            
            if loadedAnim then loadedAnim:Stop() end
            if clip then clip() end
            task.wait(0.1)
            for _, v in ipairs(character:GetChildren()) do
                if v:IsA("BasePart") and v.Name ~= "__HITBOX" then
                    v.Transparency = 0
                end
            end
        end
    end

    InvisButton.MouseButton1Click:Connect(ToggleInvisibility)
    
    local InputConnection = UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Enum.KeyCode.I then
            ToggleInvisibility()
        end
    end)

    local function Destroy()
        if InputConnection then InputConnection:Disconnect() end
        ScreenGui:Destroy()
    end
    
    return Destroy
end

local function platformgui()
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local CoreGui = game:GetService("CoreGui")
    local lp = Players.LocalPlayer
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = tostring(math.random(1, 1000000))
    ScreenGui.ResetOnSpawn = false
    
    if gethui then 
        ScreenGui.Parent = gethui() 
    elseif CoreGui then 
        ScreenGui.Parent = CoreGui 
    else 
        ScreenGui.Parent = lp:WaitForChild("PlayerGui") 
    end

    local platformButton = Instance.new("TextButton")
    platformButton.Name = "PlatformBtn"
    platformButton.Size = UDim2.new(0, 100, 0, 35)
    platformButton.Position = UDim2.new(1, -220, 0, 55)
    platformButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    platformButton.Text = "Platform (L)"
    platformButton.TextColor3 = Color3.new(1, 1, 1)
    platformButton.Font = Enum.Font.GothamBold
    platformButton.TextSize = 12
    platformButton.Parent = ScreenGui

    local SetPosCorner = Instance.new("UICorner")
    SetPosCorner.CornerRadius = UDim.new(0, 8)
    SetPosCorner.Parent = platformButton
    
    local function TogglePlatform()
        if not root then return end
        isPlatform = not isPlatform

        if isPlatform then
            platformButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
            platformButton.Text = "ON (L)"
            
            if slabPart then slabPart:Destroy() end
            slabPart = Instance.new("Part")
            slabPart.Size = Vector3.new(6,0.5,6)
            slabPart.Anchored = true
            slabPart.CanCollide = true
            slabPart.Material = Enum.Material.Plastic
            slabPart.Color = Color3.fromRGB(0,0,0)
            slabPart.Parent = Workspace
        else
            platformButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            platformButton.Text = "Platform (L)"
            if slabPart then slabPart:Destroy(); slabPart=nil end
        end
    end

    platformButton.MouseButton1Click:Connect(TogglePlatform)
    
    local InputConnection = UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Enum.KeyCode.L then
            TogglePlatform()
        end
    end)

    local function Destroy()
        if InputConnection then InputConnection:Disconnect() end
        ScreenGui:Destroy()
    end
    
    return Destroy
end

local function boostgui()
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local CoreGui = game:GetService("CoreGui")
    local lp = Players.LocalPlayer
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = tostring(math.random(1, 1000000))
    ScreenGui.ResetOnSpawn = false
    
    if gethui then 
        ScreenGui.Parent = gethui() 
    elseif CoreGui then 
        ScreenGui.Parent = CoreGui 
    else 
        ScreenGui.Parent = lp:WaitForChild("PlayerGui") 
    end

    local BoostButton = Instance.new("TextButton")
    BoostButton.Name = "BoostBtn"
    BoostButton.Size = UDim2.new(0, 100, 0, 35)
    BoostButton.Position = UDim2.new(1, -110, 0, 100)
    BoostButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    BoostButton.Text = "Speed Boost (E)"
    BoostButton.TextColor3 = Color3.new(1, 1, 1)
    BoostButton.Font = Enum.Font.GothamBold
    BoostButton.TextSize = 12
    BoostButton.Parent = ScreenGui

    local SetPosCorner = Instance.new("UICorner")
    SetPosCorner.CornerRadius = UDim.new(0, 8)
    SetPosCorner.Parent = BoostButton
    
    local function ToggleBoost()
        if not hum then return end

        isBoost = not isBoost

        if isBoost then
            BoostButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
            BoostButton.Text = "ON (E)"
        else
            BoostButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            BoostButton.Text = "Speed Boost (E)"
        end
    end

    BoostButton.MouseButton1Click:Connect(ToggleBoost)
    
    local InputConnection = UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Enum.KeyCode.E then
            ToggleBoost()
        end
    end)

    local function Destroy()
        if InputConnection then InputConnection:Disconnect() end
        ScreenGui:Destroy()
    end
    
    return Destroy
end

local function noclipgui()
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local CoreGui = game:GetService("CoreGui")
    local LocalPlayer = Players.LocalPlayer
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = tostring(math.random(1, 1000000))
    ScreenGui.ResetOnSpawn = false
    
    if gethui then 
        ScreenGui.Parent = gethui() 
    elseif CoreGui then 
        ScreenGui.Parent = CoreGui 
    else 
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") 
    end

    local FlyCorner = Instance.new("UICorner")
    FlyCorner.CornerRadius = UDim.new(0, 8)
    FlyCorner.Parent = FlyButton

    local NoclipButton = Instance.new("TextButton")
    NoclipButton.Name = "NoclipBtn"
    NoclipButton.Size = UDim2.new(0, 100, 0, 35)
    NoclipButton.Position = UDim2.new(1, -220, 0, 100)
    NoclipButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    NoclipButton.Text = "Noclip (N)"
    NoclipButton.TextColor3 = Color3.new(1, 1, 1)
    NoclipButton.Font = Enum.Font.GothamBold
    NoclipButton.TextSize = 12
    NoclipButton.AutoButtonColor = true
    NoclipButton.Parent = ScreenGui

    local SetPosCorner = Instance.new("UICorner")
    SetPosCorner.CornerRadius = UDim.new(0, 8)
    SetPosCorner.Parent = NoclipButton

    local InputConnection = nil

    local function ToggleNoclip()
            NoclipButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
            NoclipButton.Text = "Activated!"
            
            local target = getClosest()
        if target then
        local targetHRP = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
        if targetHRP then
            local tool = lp.Backpack:FindFirstChild("Web Slinger") or character:FindFirstChild("Web Slinger")
            if tool then
                if tool.Parent == lp.Backpack then
                    hum:EquipTool(tool)
                end
                
                UseItem:FireServer(targetHRP.Position, targetHRP)
                task.wait(5)
                local originalPosition = root.Position
                
                root.Anchored = true
                root.CFrame = CFrame.new(0, -9999999999999999999999999999999999999999999999999999999999999999, 0)
                task.wait(0.5)
                
                root.CFrame = CFrame.new(originalPosition)
                root.Anchored = false
            end
        end
        end
                
            task.delay(0.5, function()
                NoclipButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                NoclipButton.Text = "Noclip (N)"
            end)
    end

    NoclipButton.MouseButton1Click:Connect(ToggleNoclip)

    InputConnection = UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe then
            if input.KeyCode == Enum.KeyCode.N then
                ToggleNoclip()
            end
        end
    end)

    local function Destroy()
        if InputConnection then InputConnection:Disconnect() end
        ScreenGui:Destroy()
    end

    return Destroy
end

local function slapgui()
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local CoreGui = game:GetService("CoreGui")
    local LocalPlayer = Players.LocalPlayer
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = tostring(math.random(1, 1000000))
    ScreenGui.ResetOnSpawn = false
    
    if gethui then 
        ScreenGui.Parent = gethui() 
    elseif CoreGui then 
        ScreenGui.Parent = CoreGui 
    else 
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") 
    end

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = FlyButton

    local NoclipButton = Instance.new("TextButton")
    NoclipButton.Name = "SlapBtn"
    NoclipButton.Size = UDim2.new(0, 100, 0, 35)
    NoclipButton.Position = UDim2.new(1, -110, 0, 145)
    NoclipButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    NoclipButton.Text = "Slap (A)"
    NoclipButton.TextColor3 = Color3.new(1, 1, 1)
    NoclipButton.Font = Enum.Font.GothamBold
    NoclipButton.TextSize = 12
    NoclipButton.AutoButtonColor = true
    NoclipButton.Parent = ScreenGui

    local SetPosCorner = Instance.new("UICorner")
    SetPosCorner.CornerRadius = UDim.new(0, 8)
    SetPosCorner.Parent = NoclipButton

    local InputConnection = nil

    local function ToggleNoclip()
            local tool = (function() local items = {}; for _, c in pairs({lp.Backpack, lp.character}) do for _, v in pairs(c:GetChildren()) do if v:IsA("Tool") then table.insert(items, v) end end end for _, n in pairs({"slap", "bat"}) do for _, v in pairs(items) do if v.Name:lower():find(n) then return v end end end end)()
            
            if tool and tool.Parent == lp.Backpack then
                hum:EquipTool(tool)
            end
            if tool then
                tool:Activate()
                hum:UnequipTools(tool)
                NoclipButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
                NoclipButton.Text = "Activated!"
            else
                NoclipButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                NoclipButton.Text = "Need Slap/Bat!"
                return
            end
                
            task.delay(0.3, function()
                NoclipButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                NoclipButton.Text = "Slap (A)"
            end)
    end

    NoclipButton.MouseButton1Click:Connect(ToggleNoclip)

    InputConnection = UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe then
            if input.KeyCode == Enum.KeyCode.A then
                ToggleSlap()
            end
        end
    end)

    local function Destroy()
        if InputConnection then InputConnection:Disconnect() end
        ScreenGui:Destroy()
    end

    return Destroy
end

local function desyncgui()
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local CoreGui = game:GetService("CoreGui")
    local lp = Players.LocalPlayer
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = tostring(math.random(1, 1000000))
    ScreenGui.ResetOnSpawn = false
    
    if gethui then 
        ScreenGui.Parent = gethui() 
    elseif CoreGui then 
        ScreenGui.Parent = CoreGui 
    else 
        ScreenGui.Parent = lp:WaitForChild("PlayerGui") 
    end

    local BoostButton = Instance.new("TextButton")
    BoostButton.Name = "BoostBtn"
    BoostButton.Size = UDim2.new(0, 100, 0, 35)
    BoostButton.Position = UDim2.new(1, -220, 0, 145)
    BoostButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    BoostButton.Text = "Desync (G)"
    BoostButton.TextColor3 = Color3.new(1, 1, 1)
    BoostButton.Font = Enum.Font.GothamBold
    BoostButton.TextSize = 12
    BoostButton.Parent = ScreenGui

    local SetPosCorner = Instance.new("UICorner")
    SetPosCorner.CornerRadius = UDim.new(0, 8)
    SetPosCorner.Parent = BoostButton
    
    local function ToggleBoost()
        if not hum then return end

        isDesync = not isDesync
        if isDesync then
            BoostButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
            BoostButton.Text = "ON (G)"
            Enable()
        else
            BoostButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            BoostButton.Text = "Desync (G)"
            Disable()
        end
    end

    BoostButton.MouseButton1Click:Connect(ToggleBoost)
    
    local InputConnection = UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Enum.KeyCode.G then
            ToggleBoost()
        end
    end)

    local function Destroy()
        if InputConnection then InputConnection:Disconnect() end
        ScreenGui:Destroy()
    end
    
    return Destroy
end

local Window = Library:CreateWindow({ 
    Title = "Azure Hub | Steal A Brainrot",
    SaveName = "AzureHubSab",
    SearchBar = true,
    BackgroundTransparency = 0.1,
    ElementsTransparency = 0.1
})
--Window.UI.TestPcMode(true)

local Tabs = {
   Main = Window.UI.CreateTab({ Name = "Main", Icon = "house" }),
   Esp = Window.UI.CreateTab({ Name = "ESP", Icon = "eye" }),
   Player = Window.UI.CreateTab({ Name = "Player", Icon = "user-round" })
}

local Stealing = Tabs.Main.CreateSection({
    Title = "Stealing",
    Icon = "circle-dollar-sign"
})
Stealing.CreateToggle({
    Title = "Auto Fly To Base",
    Desc = "When pressed fly's to your base.",
    Value = false,
    Keybind = Enum.KeyCode.B,
    Callback = function(v, Set)
       if v then
           getgenv().RemoveFlyGui = flytobasegui()
       else
           getgenv().RemoveFlyGui()
           getgenv().RemoveFlyGui = nil
       end
    end
})
Stealing.CreateToggle({
    Title = "Invisibility",
    Desc = "When pressed turns you invisible.",
    Keybind = Enum.KeyCode.I,
    Callback = function(v, Set)
        if v then
           getgenv().RemoveInvisGui = invisibilitygui()
       else
           getgenv().RemoveInvisGui()
           getgenv().RemoveInvisGui = nil
       end
    end
})
Stealing.CreateToggle({
    Title = "Platform",
    Desc = "When pressed platform picks you up.",
    Keybind = Enum.KeyCode.L,
    Callback = function(v, Set)
        if v then
           getgenv().RemovePlatformGui = platformgui()
       else
           getgenv().RemovePlatformGui()
           getgenv().RemovePlatformGui = nil
       end
    end
})
Stealing.CreateToggle({
    Title = "Speed Boost",
    Desc = "When boosts your speed up.",
    Keybind = Enum.KeyCode.E,
    Callback = function(v, Set)
        if v then
           getgenv().RemoveBoostGui = boostgui()
       else
           getgenv().RemoveBoostGui()
           getgenv().RemoveBoostGui = nil
       end
    end
})

local Combat = Tabs.Main.CreateSection({
    Title = "Combat",
    Icon = "swords"
})
--[[Combat.CreateToggle({
    Title = "Instant Steal",
    Desc = "Must have carpet, useful in pvps.",
    Value = false,
    Keybind = Enum.KeyCode.S,
    Callback = function(v, Set)
       InstantStealToggle = v
       if v then
           local carpet = lp.Backpack:FindFirstChild("Flying Carpet") or character:FindFirstChild("Flying Carpet")
           if not carpet then
               Window.UI.SendNotification({
                    Title = "Azure Hub",
                    Content = "Flying Carpet Not Found.",
                    Icon = "triangle-alert",
                    Duration = 3
                })
                Set(false)
                InstantStealToggle = false
           else
               getgenv().RemoveStealGui = instantstealgui()
           end
       else
           getgenv().RemoveStealGui()
           getgenv().RemoveStealGui = nil
       end
    end
})]]
Combat.CreateToggle({
    Title = "Aimbot Nearest",
    Desc = "Hits nearest player with attacking tools.",
    Value = false,
    Keybind = Enum.KeyCode.O,
    Callback = function(v, Set)
        AimbotToggle = v
    end
})
Combat.CreateToggle({
    Title = "Melee Aura",
    Desc = "Slaps player near you. Works while stealing.",
    Value = false,
    Keybind = Enum.KeyCode.A,
    Callback = function(v, Set)
        if v then
           getgenv().RemoveSlapGui = slapgui()
       else
           getgenv().RemoveSlapGui()
           getgenv().RemoveSlapGui = nil
       end
    end
})
Combat.CreateToggle({
    Title = "Noclip",
    Desc = "Must have web slinger.",
    Value = false,
    Keybind = Enum.KeyCode.N,
    Callback = function(v, Set)
       WebNoclipToggle = v
       if v then
           local slinger = lp.Backpack:FindFirstChild("Web Slinger") or character:FindFirstChild("Web Slinger")
           if not slinger then
               Window.UI.SendNotification({
                    Title = "Azure Hub",
                    Content = "Web Slinger Not Found.",
                    Icon = "triangle-alert",
                    Duration = 3
                })
                Set(false)
                WebNoclipToggle = false
           else
                Window.UI.SendNotification({
                     Title = "Azure Hub",
                     Content = "Make sure you're desynced.",
                     Icon = "info",
                     Duration = 2
                 })
                 getgenv().RemoveNoclipGui = noclipgui()
           end
       else
           getgenv().RemoveNoclipGui()
           getgenv().RemoveNoclipGui = nil
       end
    end
})

local Misc = Tabs.Main.CreateSection({
    Title = "Misc",
    Icon = "layout-grid"
})
Misc.CreateButton({
    Title = "Desync (Respawn)",
    Desc = "Makes you desync, will stay on rejoining.",
    Keybind = Enum.KeyCode.D,
    Callback = function()
        if not setfflag then
            Window.UI.SendNotification({
                Title = "Azure Hub",
                Content = "Desync Failed, Executor doesn't support.",
                Icon = "triangle-alert",
                Duration = 3
            })
            return
        end

        setfflag("GameNetPVHeaderRotationalVelocityZeroCutoffExponent", "-5000")
    setfflag("LargeReplicatorWrite5", "true")
    setfflag("LargeReplicatorEnabled9", "true")
    setfflag("TimestepArbiterVelocityCriteriaThresholdTwoDt", "2147483646")
    setfflag("S2PhysicsSenderRate", "15000")
    setfflag("DisableDPIScale", "true")
    setfflag("MaxDataPacketPerSend", "2147483647")
    setfflag("PhysicsSenderMaxBandwidthBps", "20000")
    setfflag("CheckPVCachedVelThresholdPercent", "10")
    setfflag("MaxMissedWorldStepsRemembered", "-2147483648")
    setfflag("WorldStepMax", "30")
    setfflag("StreamJobNOUVolumeLengthCap", "2147483647")
    setfflag("DebugSendDistInSteps", "-2147483648")
    setfflag("LargeReplicatorRead5", "true")
    setfflag("GameNetDontSendRedundantNumTimes", "1")
    setfflag("CheckPVLinearVelocityIntegrateVsDeltaPositionThresholdPercent", "1")
    setfflag("LargeReplicatorSerializeRead3", "true")
    setfflag("NextGenReplicatorEnabledWrite4", "true")
    setfflag("AngularVelociryLimit", "360")
    setfflag("CheckPVDifferencesForInterpolationMinRotVelThresholdRadsPerSecHundredth", "1")
    setfflag("GameNetDontSendRedundantDeltaPositionMillionth", "1")
    setfflag("InterpolationFrameVelocityThresholdMillionth", "5")
    setfflag("StreamJobNOUVolumeCap", "2147483647")
    setfflag("InterpolationFrameRotVelocityThresholdMillionth", "5")
    setfflag("CheckPVDifferencesForInterpolationMinVelThresholdStudsPerSecHundredth", "1")
    setfflag("ReplicationFocusNouExtentsSizeCutoffForPauseStuds", "2147483647")
    setfflag("InterpolationFramePositionThresholdMillionth", "5")
    setfflag("TimestepArbiterHumanoidTurningVelThreshold", "1")
    setfflag("SimOwnedNOUCountThresholdMillionth", "2147483647")
    setfflag("GameNetPVHeaderLinearVelocityZeroCutoffExponent", "-5000")
    setfflag("CheckPVCachedRotVelThresholdPercent", "10")
    setfflag("TimestepArbiterOmegaThou", "1073741823")
    setfflag("MaxAcceptableUpdateDelay", "1")
    setfflag("LargeReplicatorSerializeWrite4", "true")

        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Dead)
            character:ClearAllChildren()
            local DummyModel = Instance.new("Model")
            DummyModel.Parent = Workspace
            lp.Character = DummyModel
            task.wait()
            lp.Character = Character
            DummyModel:Destroy()
            Window.UI.SendNotification({
                Title = "Azure Hub",
                Content = "Desync Success.",
                Icon = "info",
                Duration = 3
            })
            Desynced = true
        end
    end
})
Misc.CreateToggle({
    Title = "Desync Toggle",
    Desc = "Makes you desyncable with toggle.",
    Value = false,
    Keybind = Enum.KeyCode.G,
    Callback = function(v, Set)
        if v then
            getgenv().RemoveDesyncGui = desyncgui()
            if not getgenv().Desynced then
                getgenv().Desynced = true
                Enable()
                if character and hum then
                hum:ChangeState(Enum.HumanoidStateType.Dead)
                    character:ClearAllChildren()
                    local Dummy = Instance.new("Model")
                    Dummy.Parent = workspace
                    lp.Character = Dummy
                    task.wait()
                    lp.Character = character
                    Dummy:Destroy()
                    lp.CharacterAdded:Wait()
                    task.wait(0.5)
                    Disable()
                end
            end
        else
            getgenv().RemoveDesyncGui()
            getgenv().RemoveDesyncGui = nil
        end
    end
})
Misc.CreateToggle({
    Title = "Unwalk",
    Desc = "Removes walking animation.",
    Value = false,
    Keybind = Enum.KeyCode.U,
    Callback = function(v, Set)
        if v then
            local Idle = character:WaitForChild("Animate"):WaitForChild("idle"):FindFirstChildWhichIsA("Animation").AnimationId
            for _, v in pairs(character:GetDescendants()) do if v:IsA("Animation") then v.AnimationId = Idle end end
            for _, v in pairs(lp.Backpack:GetDescendants()) do if v:IsA("Animation") then v.AnimationId = Idle end end
            getgenv().IdleLoop =
            lp.CharacterAdded:Connect(function(c)
                local i = c:WaitForChild("Animate"):WaitForChild("idle"):FindFirstChildWhichIsA("Animation").AnimationId
                for _, v in pairs(c:GetDescendants()) do if v:IsA("Animation") then v.AnimationId = i end end
            end)
        else
            if getgenv().IdleLoop then getgenv().IdleLoop:Disconnect() getgenv().IdleLoop = nil end
            game:GetService("Players").LocalPlayer.Character.Humanoid.Health = 0
        end
    end
})
Misc.CreateToggle({
    Title = "Anti Ragdoll",
    Desc = "Prevents ragdolling.",
    Value = false,
    Keybind = Enum.KeyCode.R,
    Callback = function(v, Set)
        if connections.Ragdoll then connections.Ragdoll:Disconnect() end
        if connections.CharAdded then connections.CharAdded:Disconnect() end

        if v then
            if character then
                if hum then
                    connections.Ragdoll = hum.StateChanged:Connect(function(oldState, newState)
                        if newState == Enum.HumanoidStateType.Ragdoll or 
                           newState == Enum.HumanoidStateType.FallingDown or 
                           newState == Enum.HumanoidStateType.Physics then
                            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                        end
                    end)
                end
            end

            connections.CharAdded = lp.CharacterAdded:Connect(function(newChar)
                local humanoid = newChar:WaitForChild("Humanoid", 10)
                if humanoid then
                    if connections.Ragdoll then connections.Ragdoll:Disconnect() end
                    
                    connections.Ragdoll = humanoid.StateChanged:Connect(function(oldState, newState)
                        if newState == Enum.HumanoidStateType.Ragdoll or 
                           newState == Enum.HumanoidStateType.FallingDown or 
                           newState == Enum.HumanoidStateType.Physics then
                            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                        end
                    end)
                end
            end)
            for _, v in pairs(root:GetChildren()) do
	         if --[[v:IsA("Attachment") or]] v.Name == "OriginalSize" then v:Destroy() end
	    end
           root.ChildAdded:Connect(function(v)
	        if --[[v:IsA("Attachment") or]] v.Name == "OriginalSize" then
		     task.wait()
		    v:Destroy()
	        end
           end)
        end
    end
})
Misc.CreateToggle({
    Title = "Infinite Jump",
    Desc = "Makes you able to jump infinitely.",
    Value = false,
    Keybind = Enum.KeyCode.J,
    Callback = function(v, Set)
        InfiniteJumpToggle = v
    end
})
Misc.CreateToggle({
    Title = "Jump Boost",
    Desc = "Slightly increases jump height.",
    Value = false,
    Keybind = Enum.KeyCode.B,
    Callback = function(v, Set)
        JumpBoostToggle = v
    end
})

Misc.CreateToggle({
    Title = "X-Ray",
    Desc = "Makes bases transparent.",
    Value = false,
    Keybind = Enum.KeyCode.X,
    Callback = function(v, Set)
        XRayToggle = v
        local trans = 0
        if v then trans = 0.5 end
        for _, plot in pairs(workspace.Plots:GetChildren()) do
            if plot:FindFirstChild("Decorations") then
                for _, part in pairs(plot.Decorations:GetDescendants()) do
                    if part:IsA("BasePart") then 
                        part.Transparency = trans 
                    end
                end
            end
            if plot:FindFirstChild("Skin") then
                for _, folder in pairs(plot.Skin:GetDescendants()) do
                    if string.find(folder.Name, "Decoration") then
                        for _, part in pairs(folder:GetDescendants()) do
                            if part:IsA("BasePart") then 
                                part.Transparency = trans 
                            end
                        end
                    end
                end
            end
        end
        if v then
            if not getgenv().XRayConnection then
                getgenv().XRayConnection = workspace.Plots.DescendantAdded:Connect(function(child)
                    if XRayToggle and child:IsA("BasePart") then
                        task.wait()
                        if child.Parent and (child.Parent.Name == "Decorations" or string.find(child.Parent.Name, "Decoration")) then
                            child.Transparency = 0.5
                        end
                    end
                end)
            end
        else
            if getgenv().XRayConnection then 
                getgenv().XRayConnection:Disconnect()
                getgenv().XRayConnection = nil
            end
        end
    end
})

Tabs.Esp.CreateToggle({
    Title = "ESP Highest Value",
    Value = false,
    Keybind = Enum.KeyCode.V,
    Callback = function(v, Set)
       EspHighestToggle = v
    end
})
Tabs.Esp.CreateToggle({
    Title = "ESP Players",
    Value = false,
    Keybind = Enum.KeyCode.P,
    Callback = function(v, Set)
        EspPlayersToggle = v
    end
})
Tabs.Esp.CreateToggle({
    Title = "ESP Timers",
    Value = false,
    Keybind = Enum.KeyCode.T,
    Callback = function(v, Set)
        EspTimersToggle = v
    end
})

--[[CombatSection.CreateSlider({
    Title = "Range",
    Values = {MinValue = 1, MaxValue = 20, DefaultValue = 15},
    Callback = function(v) print(v) end
})]]

ProximityPromptService.PromptButtonHoldBegan:Connect(function(Prompt, PlayerWhoTriggered)
    if PlayerWhoTriggered == lp and InstantStealToggle then
        local Backpack = lp:FindFirstChild("Backpack")

        if hum and Backpack then
            hum:UnequipTools()
            local Carpet = Backpack:FindFirstChild("Flying Carpet")
            if Carpet then
                hum:EquipTool(Carpet)
            end
        end
    end
end)

ProximityPromptService.PromptButtonHoldEnded:Connect(function(Prompt, PlayerWhoTriggered)
    if PlayerWhoTriggered == lp and InstantStealToggle then
        if SavedPosition then
            if root then
                root.CFrame = CFrame.new(SavedPosition)
            end
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if character and root then
        if InfiniteJumpToggle or JumpBoostToggle then
            local base = 50
            local extra = JumpBoostToggle and 30 or 0
            root.Velocity = Vector3.new(root.Velocity.X, base+extra, root.Velocity.Z)
        end
    end
end)

local rn, cd = 0, 0.5
RunService.Heartbeat:Connect(function()
    if not root or not hum then return end
    if isPlatform and slabPart then
        slabPart.Position = Vector3.new(
            root.Position.X,
            root.Position.Y - 3,
            root.Position.Z
        )
        if tick() - rn > cd then laser() rn = tick() end
    end
    
    if isBoost then
        local dir = hum.MoveDirection
        if dir.Magnitude > 0.05 then
            root.AssemblyLinearVelocity = Vector3.new(dir.X*28, root.AssemblyLinearVelocity.Y, dir.Z*28)
        end
    end
end)