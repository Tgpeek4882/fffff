local cloneref = cloneref or function(o) return o end
local PlayersFolder = workspace:WaitForChild("Game"):WaitForChild("Players")
local Players = cloneref(game:GetService("Players"))
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local RunService = cloneref(game:GetService("RunService"))
local lp = Players.LocalPlayer
local username = lp.Name
local Camera = workspace.CurrentCamera
local timer

local character
local hum
local root
local timerActive = false

local function uCR(char)
    character = char
    root = character:WaitForChild("HumanoidRootPart", 5)
    hum = character:WaitForChild("Humanoid", 5)
end

local function nextbotsExist()
    if not PlayersFolder then return false end
    for _, model in ipairs(PlayersFolder:GetChildren()) do
        if model:IsA("Model") and model:FindFirstChild("Hitbox") then
            return true
        end
    end
    return false
end

spawn(function()
    while true do
        if nextbotsExist() and not timerActive then
            timer = 180
            timerActive = true
        end

        if timerActive and timer > 0 then
            timer -= 1
        elseif timerActive and timer <= 0 then
            timer = nil
            timerActive = false
        end

        wait(1)
    end
end)

uCR(lp.Character or lp.CharacterAdded:Wait())
lp.CharacterAdded:Connect(function(newChar)
    uCR(newChar)
end)

local blacklist = {
    [2752873842] = true,
    [209546354] = true,
    [49468107] = true,
    [14137866] = true,
    [399758209] = true,
    [25356207] = true,
    [34959963] = true,
    [196842650] = true,
    [66395569] = true,
    [1744079096] = true,
    [687889103] = true,
    [1468991039] = true,
    [111073039] = true,
    [381484072] = true,
    [88784078] = true,
    [721993047] = true
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

local gid = 5693735
local bannedRanks = {
    ["UGC Manager"] = true,
    ["TBZ Tester"] = true,
    ["Evade Tester"] = true,
    ["Prim Tester"] = true,
    ["Omni Tester"] = true,
    ["Admin"] = true,
    ["Lower Developer"] = true,
    ["Business Developer"] = true,
    ["Developer"] = true,
    ["Main Developer"] = true,
    ["Group Owner"] = true
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
    Title = "Azure Hub | Evade ".. getTag(lp.Name),
    Author = "discord.gg/QmvpbPdw9J",
    Folder = "EvadeHub",
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
     Auto = Tabs.Features:Tab({ Title = "|  Auto", Icon = "cpu" }),
     Esp = Tabs.Features:Tab({ Title = "|  ESP", Icon = "eye" }),
     Player = Tabs.Features:Tab({ Title = "|  Player", Icon = "users-round" }),
     Misc = Tabs.Features:Tab({ Title = "|  Misc", Icon = "layout-grid" }),
     Config = Tabs.Utilities:Tab({ Title = "|  Configuration", Icon = "settings" })
}

local updparagraph = Logs:Paragraph({
    Title = "Update Logs",
    Desc = "24.09.25\n[+] Bypass Speed\n[+] Improved EDash\n[/] Optimised ESP\n\n1.08.25\n[+] Evade\n[+] Auto EDash\n[+] Force Speed",
    Locked = false,
    Buttons = {
        {
            Icon = "clipboard",
            Title = "Discord Server",
            Callback = function() setclipboard(discordLink) WindUI:Notify({ Title = "Discord Server", Content = "Link Copied!", Icon = "info", Duration = 2 }) end,
        }
    }
})

local clicked = false
local farmToggle = false
local WalkToggle = false
local currentSpeed = 28
local Noclip = nil
local Clip = nil
local NoclipToggle = false
local selectedESPTypes = {}
local ESPHighlight = false
local ESPTracers = false
local ESPNames = false
local ESPBoxes = false
local ESPStuds = false
local espObjects = {}
local esp = {}
local tracers = {}
local boxes = {}
local names = {}
local studs = {}
local AntiNextbot = false
local AutoObj = false
local AutoRev = false
local emoteVSpeed = 40

local DrawingAvailable = (type(Drawing) == "table" or type(Drawing) == "userdata")

local function contains(tbl, val)
    if not tbl or type(tbl) ~= "table" then return false end
    for _, v in ipairs(tbl) do
        if v == val then return true end
    end
    return false
end

local function isPlayerObject(obj)
    return type(obj.Name) == "string" and not obj.Name:find(" ") and not obj:FindFirstChild("Revives") and obj.Parent.Name == "Game" 
end

local function isNextbotObject(obj)
    return obj:FindFirstChild("Hitbox") and obj.Hitbox:IsA("BasePart")
end

local function isInjuredPlayer(obj)
    return type(obj.Name) == "string" and not obj.Name:find(" ") and obj:FindFirstChild("Revives")
end

-- Configurable Filter
local function passesDropdownFilter(obj)
    if not selectedESPTypes or #selectedESPTypes == 0 then
        return false
    end
    if contains(selectedESPTypes, "Players") and isPlayerObject(obj) then return true end
    if contains(selectedESPTypes, "Nextbots") and isNextbotObject(obj) then return true end
    if contains(selectedESPTypes, "Injured Players") and isInjuredPlayer(obj) then return true end
    return false
end

-- Your Requested Colors (from 2nd code)
local function getObjColor(obj)
    if isInjuredPlayer(obj) then return Color3.fromRGB(255, 255, 0) end -- Yellow
    if isNextbotObject(obj) then return Color3.fromRGB(255, 0, 0) end   -- Red
    return Color3.fromRGB(0, 255, 0) -- Green (Players)
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

workspace.ChildAdded:Connect(function(child)
    task.wait(0.5)
    if passesDropdownFilter(child) then ensureAllFor(child) end
end)

workspace.ChildRemoved:Connect(function(child)
    removeESP(child)
end)

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

local function teleportAndCreateBase(text)
    root.CFrame = CFrame.new(0, 9999, 0)
    
    local basePart = Instance.new("Part")
    basePart.Size = Vector3.new(5000, 1, 5000)
    basePart.Position = root.Position - Vector3.new(0, root.Size.Y/2 + 0.5, 0)
    basePart.Anchored = true
    basePart.CanCollide = true
    basePart.Parent = workspace

    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = basePart
    billboard.Size = UDim2.new(0, 200, 0, 60)
    billboard.StudsOffset = Vector3.new(0,7,0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 5000
    billboard.Parent = basePart

    -- AFK Zone Label
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,0,0.6,0)
    label.Position = UDim2.new(0,0,0,0)
    label.BackgroundTransparency = 1
    label.Text = text or "Azure Hub\nAFK Zone"
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = billboard

    -- Timer Label
    local timerLabel = Instance.new("TextLabel")
    timerLabel.Size = UDim2.new(1,0,0.4,0)
    timerLabel.Position = UDim2.new(0,0,0.6,0) -- below the AFK label
    timerLabel.BackgroundTransparency = 1
    timerLabel.TextColor3 = Color3.fromRGB(255,255,255)
    timerLabel.TextScaled = true
    timerLabel.Font = Enum.Font.GothamBold
    timerLabel.Text = "Intermission"
    timerLabel.Parent = billboard

    spawn(function()
        while basePart.Parent do
            if timer == nil then
                timerLabel.Text = "Intermission"
            else
                timerLabel.Text = "Round end: " .. tostring(timer)
            end
            wait(1)
        end
    end)
end

spawn(function()
    while true do
        task.wait(0.5)
        if AntiNextbot and root.Position.Y < 9990 then
            teleportAndCreateBase("Azure Hub\nAFK Zone")
        end
    end
end)

local normalConn, emoteConn
local function applyBypassSpeed()
    if normalConn then normalConn:Disconnect() end

    normalConn = RunService.Heartbeat:Connect(function()
        if not WalkToggle or not character then return end

        if not hum or not root then return end

        for _, conn in ipairs(getconnections(hum:GetPropertyChangedSignal("WalkSpeed"))) do
            conn:Disable()
        end

        local dir = hum.MoveDirection
        if dir.Magnitude > 0 then
            local speed = root:FindFirstChild("EmoteSound") and emoteVSpeed or currentSpeed
            local move = Vector3.new(dir.X, 0, dir.Z).Unit * speed
            root.AssemblyLinearVelocity = Vector3.new(move.X, root.AssemblyLinearVelocity.Y, move.Z)
        else
            root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y, 0)
        end
    end)
end
applyBypassSpeed()

local function createAutoJumpUI()
    if game.CoreGui:FindFirstChild("AutoJumpGUI") then
        game.CoreGui:FindFirstChild("AutoJumpGUI"):Destroy()
    end
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "AutoJumpGUI"
    ScreenGui.Parent = game.CoreGui

    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.new(0, 140, 0, 40)
    Toggle.Position = UDim2.new(0.68, 0, 0.05, 0) -- left of leaderboard
    Toggle.Text = "Auto Jump: OFF"
    Toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Toggle.TextColor3 = Color3.new(1,1,1)
    Toggle.Font = Enum.Font.SourceSansBold
    Toggle.TextSize = 18
    Toggle.Parent = ScreenGui

    -- make draggable
    Toggle.Active = true
    Toggle.Draggable = true

    local autoJump = false
    local conn

    local function startAutoJump()
        if conn then conn:Disconnect() end
        conn = RunService.Heartbeat:Connect(function()
            if hum and hum.FloorMaterial ~= Enum.Material.Air then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end

    local function stopAutoJump()
        if conn then conn:Disconnect() end
    end

    Toggle.MouseButton1Click:Connect(function()
        autoJump = not autoJump
        if autoJump then
            Toggle.Text = "Auto Jump: ON"
            startAutoJump()
        else
            Toggle.Text = "Auto Jump: OFF"
            stopAutoJump()
        end
    end)
end

local function createGravityUI()
    if game.CoreGui:FindFirstChild("GravityGUI") then
        game.CoreGui:FindFirstChild("GravityGUI"):Destroy()
    end
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "GravityGUI"
    ScreenGui.Parent = game.CoreGui

    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.new(0, 140, 0, 40)
    Toggle.Position = UDim2.new(0.68, 0, 0.05, 0)
    Toggle.Text = "Gravity: OFF"
    Toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Toggle.TextColor3 = Color3.new(1,1,1)
    Toggle.Font = Enum.Font.SourceSansBold
    Toggle.TextSize = 18
    Toggle.Parent = ScreenGui

    Toggle.Active = true
    Toggle.Draggable = true
    
    local defaultGravity = workspace.Gravity
    local gravity = false
    local conn

    local function startGravity()
        if conn then conn:Disconnect() end
        conn = RunService.Heartbeat:Connect(function()
            if workspace.Gravity ~= 30 then
                workspace.Gravity = 30
            end
        end)
    end

    local function stopGravity()
        if conn then conn:Disconnect() end
        workspace.Gravity = defaultGravity
    end

    Toggle.MouseButton1Click:Connect(function()
        gravity = not gravity
        if gravity then
            Toggle.Text = "Gravity: ON"
            startGravity()
        else
            Toggle.Text = "Gravity: OFF"
            stopGravity()
        end
    end)
end

local AutoObjHandle = TabHandles.Auto:Toggle({
       Title = "Auto Objectives",
       Desc = "Automatically does map objectives for you. (works with AFK farm)",
       Value = false,
       Callback = function(state)
             AutoObj = state
       end
})
local AutiRevHandle = TabHandles.Auto:Toggle({
       Title = "Auto Revive",
       Desc = "Automatically revives downed players. (works with AFK farm)",
       Value = false,
       Callback = function(state)
             AutoRev = state
       end
})
local AntiNextbotHandle = TabHandles.Auto:Toggle({
       Title = "AFK Farm",
       Desc = "Teleports you to sky where you can win farm.",
       Value = false,
       Callback = function(state)
             AntiNextbot = state
       end
})
TabHandles.Auto:Button({
	Title = "Auto Jump UI",
	Callback = function()
	       createAutoJumpUI()
	end
})
TabHandles.Auto:Button({
	Title = "Gravity UI",
	Callback = function()
	       createGravityUI()
	end
})
TabHandles.Auto:Button({
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
       Values = { "Injured Players", "Players", "Nextbots" },
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
	Value = { Min = 0, Max = 150, Default = 28 },
	Callback = function(Value)
		currentSpeed = Value
	end
})
local velocitySliderHandle = TabHandles.Player:Slider({
       Title = "Emote Speed",
       Desc = "Helps with emote dash, emote hop and etc.",
	Value = { Min = 0, Max = 300, Default = 28 },
	Callback = function(Value)
		emoteVSpeed = Value
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
TabHandles.Misc:Button({
	Title = "Bypass Anti Speed (Optional)",
	Desc = "Allows modifying WS/VS but disables bounces.",
	Callback = function()
	for _, obj in ipairs(root:GetChildren()) do
	if obj:IsA("LinearVelocity") then
        obj:Destroy()
        end
        end
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
            configFile:Register("AutoObjHandle", AutoObjHandle)
            configFile:Register("AutoRevHandle", AutoRevHandle)
            configFile:Register("AntiNextbotHandle", AntiNextbotHandle)
            configFile:Register("ESPDropdownHandle", ESPDropdownHandle)
            configFile:Register("ESPHighlightHandle", ESPHighlightHandle)
            configFile:Register("ESPTracersHandle", ESPTracersHandle)
            configFile:Register("ESPBoxesHandle", ESPBoxesHandle)
            configFile:Register("ESPStudsHandle", ESPStudsHandle)
            configFile:Register("NoclipHandle", NoclipHandle)
            configFile:Register("WsToggleHandle", WsToggleHandle)
            configFile:Register("WsSliderHandle", WsSliderHandle)
            configFile:Register("velocitySliderHandle", velocitySliderHandle)
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
local autoLoadFile = "AZUREHUB_ALC_EV.txt"
local ALC = false

if ConfigManager then
    ConfigManager:Init(Window)
    
    configFile = ConfigManager:CreateConfig(configName)
    configFile:Register("AutoObjHandle", AutoObjHandle)
    configFile:Register("AutoRevHandle", AutoRevHandle)
    configFile:Register("AntiNextbotHandle", AntiNextbotHandle)
    configFile:Register("ESPDropdownHandle", ESPDropdownHandle)
            configFile:Register("ESPHighlightHandle", ESPHighlightHandle)
            configFile:Register("ESPTracersHandle", ESPTracersHandle)
            configFile:Register("ESPBoxesHandle", ESPBoxesHandle)
            configFile:Register("ESPStudsHandle", ESPStudsHandle)
    configFile:Register("NoclipHandle", NoclipHandle)
    configFile:Register("WsToggleHandle", WsToggleHandle)
    configFile:Register("WsSliderHandle", WsSliderHandle)
    configFile:Register("velocitySliderHandle", velocitySliderHandle)
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
                configFile:Register("AutoObjHandle", AutoObjHandle)
                configFile:Register("AutoRevHandle", AutoRevHandle)
                configFile:Register("AntiNextbotHandle", AntiNextbotHandle)
                configFile:Register("ESPDropdownHandle", ESPDropdownHandle)
            configFile:Register("ESPHighlightHandle", ESPHighlightHandle)
            configFile:Register("ESPTracersHandle", ESPTracersHandle)
            configFile:Register("ESPBoxesHandle", ESPBoxesHandle)
            configFile:Register("ESPStudsHandle", ESPStudsHandle)
                configFile:Register("NoclipHandle", NoclipHandle)
                configFile:Register("WsToggleHandle", WsToggleHandle)
                configFile:Register("WsSliderHandle", WsSliderHandle)
                configFile:Register("velocitySliderHandle", velocitySliderHandle)
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