local cloneref = cloneref or function(o) return o end
local Players = cloneref(game:GetService("Players"))
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local RunService = cloneref(game:GetService("RunService"))
local lp = Players.LocalPlayer
local username = lp.Name
local Camera = workspace.CurrentCamera
local UserInputService = cloneref(game:GetService("UserInputService"))

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

local gid = 32847485
local bannedRanks = {
    ["Tester"] = true,
    ["Contributor"] = true,
    ["Developer"] = true,
    ["Lead Developer"] = true,
    ["Group Holder"] = true
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
    Title = "Azure Hub | Demonology ".. getTag(lp.Name),
    Author = "discord.gg/QmvpbPdw9J",
    Folder = "DemonologyHub",
    Size = UDim2.fromOffset(500, 300),
    Theme = "Dark",
    User = {
        Enabled = true,
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
     Main = Tabs.Features:Tab({ Title = "|  Helper", Icon = "hammer" }),
     Esp = Tabs.Features:Tab({ Title = "|  ESP", Icon = "eye" }),
     Player = Tabs.Features:Tab({ Title = "|  Player", Icon = "users-round" }),
     Misc = Tabs.Features:Tab({ Title = "|  Misc", Icon = "layout-grid" }),
     Config = Tabs.Utilities:Tab({ Title = "|  Configuration", Icon = "settings" })
}

local updparagraph = Logs:Paragraph({
    Title = "Update Logs",
    Desc = "1.12.25\n[/] Updated To Latest Data\n[/] Main > Helper\n[+] Grab Items (Helper>Items)\n[+] Auto Hide On Haunt\n\n7.09.25\n[+] Demonology",
    Locked = false,
    Buttons = {
        {
            Icon = "clipboard",
            Title = "Discord Server",
            Callback = function() setclipboard(discordLink) WindUI:Notify({ Title = "Discord Server", Content = "Link Copied!", Icon = "info", Duration = 2 }) end,
        }
    }
})

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
local ESPObjects = {}
local esp = {}
local tracers = {}
local boxes = {}
local names = {}
local studs = {}
local DrawingAvailable = (type(Drawing) == "table" or type(Drawing) == "userdata")
local GhostToggle = false
local AutoHideToggle = false

local function contains(tbl, val)
    if not tbl or type(tbl) ~= "table" then return false end
    for _, v in ipairs(tbl) do
        if v == val then return true end
    end
    return false
end

local function isPlayerObject(obj)
    local child = obj:FindFirstChild("Health")
    return child and child:IsA("Script")
end

local function isGhostObject(obj)
    local ghost = obj:FindFirstChild("VisibleParts")
    return ghost and ghost:IsA("Model")
end

local function isItem(obj)
    return obj:IsA("BasePart") and obj.Name == "Handle" and obj.Parent and obj.Parent.Parent and obj.Parent.Parent.Name == "Items"
end

local function isHandprint(obj)
    return obj:IsA("BasePart") and obj.Parent and obj.Parent.Name == "Handprints"
end

local function isOrb(obj)
    return obj:IsA("BasePart") and obj.Parent and obj.Parent.Name == "Workspace" -- Using your specific orb logic
end

local function passesDropdownFilter(obj)
    if not selectedESPTypes or #selectedESPTypes == 0 then
        return false
    end
    if contains(selectedESPTypes, "Players") and isPlayerObject(obj) then return true end
    if contains(selectedESPTypes, "Ghosts") and isGhostObject(obj) then return true end
    if contains(selectedESPTypes, "Items") and isItem(obj) then return true end
    if contains(selectedESPTypes, "Handprints") and isHandprint(obj) then return true end
    if contains(selectedESPTypes, "Ghost Orb") and isOrb(obj) then return true end
    return false
end

local function getObjColor(obj)
    if isItem(obj) then return Color3.fromRGB(255, 255, 0) end      -- Yellow
    if isGhostObject(obj) then return Color3.fromRGB(255, 0, 0) end -- Red
    if isHandprint(obj) then return Color3.fromRGB(0, 128, 0) end   -- Green
    if isOrb(obj) then return Color3.fromRGB(0, 0, 0) end           -- Black
    return Color3.fromRGB(0, 255, 0)                           
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
        local itemsFolder = workspace:FindFirstChild("Items")
        if itemsFolder then
            for _, item in ipairs(itemsFolder:GetChildren()) do
                if passesDropdownFilter(item) then ensureAllFor(item) end
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

Workspace.ChildAdded:Connect(function(child)
    task.wait(0.5)
    if passesDropdownFilter(child) then ensureAllFor(child) end
end)

Workspace.ChildRemoved:Connect(function(child)
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

local originalStates = {}
local function cacheGhost()
    local ghost = workspace:FindFirstChild("Ghost")
    if not ghost then return end

    local visibleParts = ghost:FindFirstChild("VisibleParts")
    if not visibleParts then return end

    for _, obj in ipairs(visibleParts:GetDescendants()) do
        if obj:IsA("BasePart") then
            if not originalStates[obj] then
                originalStates[obj] = {
                    Transparency = obj.Transparency,
                    LocalTransparencyModifier = obj.LocalTransparencyModifier,
                    Decals = {}
                }
                for _, decal in ipairs(obj:GetDescendants()) do
                    if decal:IsA("Decal") then
                        originalStates[obj].Decals[decal] = decal.Transparency
                    end
                end
            end
        end
    end
end

local function restoreOriginal()
    for obj, state in pairs(originalStates) do
        if obj and obj:IsA("BasePart") then
            obj.Transparency = state.Transparency
            obj.LocalTransparencyModifier = state.LocalTransparencyModifier
            for decal, oldT in pairs(state.Decals) do
                if decal and decal:IsA("Decal") then
                    decal.Transparency = oldT
                end
            end
        end
    end
end

local toolRE = game.ReplicatedStorage.Events.RequestItemPickup
local ItemsSection = TabHandles.Main:Section({ 
    Title = "Items",
    Icon = "pickaxe"
})
ItemsSection:Button({
	Title = "Grab Video Camera",
	Callback = function()
	      toolRE:FireServer(workspace:WaitForChild("Items"):WaitForChild("1"))
	end
})
ItemsSection:Button({
	Title = "Grab Thermometer",
	Callback = function()
	      toolRE:FireServer(workspace:WaitForChild("Items"):WaitForChild("2"))
	end
})
ItemsSection:Button({
	Title = "Grab Spirit Book",
	Callback = function()
	      toolRE:FireServer(workspace:WaitForChild("Items"):WaitForChild("3"))
	end
})
ItemsSection:Button({
	Title = "Grab Blacklight",
	Callback = function()
	      toolRE:FireServer(workspace:WaitForChild("Items"):WaitForChild("4"))
	end
})
ItemsSection:Button({
	Title = "Grab Spirit Box",
	Callback = function()
	      toolRE:FireServer(workspace:WaitForChild("Items"):WaitForChild("5"))
	end
})
ItemsSection:Button({
	Title = "Grab EMF Reader",
	Callback = function()
	      toolRE:FireServer(workspace:WaitForChild("Items"):WaitForChild("6"))
	end
})
ItemsSection:Button({
	Title = "Grab Flashlight",
	Callback = function()
	      toolRE:FireServer(workspace:WaitForChild("Items"):WaitForChild("7"))
	end
})
ItemsSection:Button({
	Title = "Grab Laser Projector",
	Callback = function()
	      toolRE:FireServer(workspace:WaitForChild("Items"):WaitForChild("8"))
	end
})
ItemsSection:Button({
	Title = "Grab Flower Pot",
	Callback = function()
	      toolRE:FireServer(workspace:WaitForChild("Items"):WaitForChild("9"))
	end
})
local GhostHandle = TabHandles.Main:Toggle({
    Title = "Visible Ghost",
    Desc = "Forces ghost to be fully visible so you could track him.",
    Value = false,
    Callback = function(state)
        if not state then restoreOriginal() end
        GhostToggle = state
    end
})
local AutoHideHandle = TabHandles.Main:Toggle({
    Title = "Auto Hide (Haunt)",
    Desc = "Teleports you to Base Camp when Ghost starts haunting.",
    Value = false,
    Callback = function(state)
        AutoHideToggle = state
    end
})
local orbparagraph = TabHandles.Main:Paragraph({
    Title = "GhostOrb Status:",
    Desc = "Finds ghost orb in the map, used for evidence.",
    Locked = false
})
local handprintparagraph = TabHandles.Main:Paragraph({
    Title = "Handprints Status:",
    Desc = "Finds handprints in the map, used for evidence.",
    Locked = false
})

TabHandles.Esp:Button({
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
       Values = { "Ghosts", "Players", "Items", "Handprints", "Ghost Orb" },
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
	Value = { Min = 16, Max = 100, Default = 16 },
	Callback = function(Value)
		currentSpeed = Value
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
            configFile:Register("GhostHandle", GhostHandle)
            configFile:Register("AutoHideHandle", AutoHideHandle)
            configFile:Register("ESPDropdownHandle", ESPDropdownHandle)
            configFile:Register("ESPHighlightHandle", ESPHighlightHandle)
            configFile:Register("ESPTracersHandle", ESPTracersHandle)
            configFile:Register("ESPBoxesHandle", ESPBoxesHandle)
            configFile:Register("ESPStudsHandle", ESPStudsHandle)
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
local autoLoadFile = "AZUREHUB_ALC_DM.txt"
local ALC = false

if ConfigManager then
    ConfigManager:Init(Window)
    
    configFile = ConfigManager:CreateConfig(configName)
    configFile:Register("GhostHandle", GhostHandle)
    configFile:Register("AutoHideHandle", AutoHideHandle)
    configFile:Register("ESPDropdownHandle", ESPDropdownHandle)
            configFile:Register("ESPHighlightHandle", ESPHighlightHandle)
            configFile:Register("ESPTracersHandle", ESPTracersHandle)
            configFile:Register("ESPBoxesHandle", ESPBoxesHandle)
            configFile:Register("ESPStudsHandle", ESPStudsHandle)
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
                configFile:Register("AutoHideHandle", AutoHideHandle)
                configFile:Register("GhostHandle", GhostHandle)
                configFile:Register("ESPDropdownHandle", ESPDropdownHandle)
            configFile:Register("ESPHighlightHandle", ESPHighlightHandle)
            configFile:Register("ESPTracersHandle", ESPTracersHandle)
            configFile:Register("ESPBoxesHandle", ESPBoxesHandle)
            configFile:Register("ESPStudsHandle", ESPStudsHandle)
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

task.spawn(function()
    while task.wait(1) do
        if GhostToggle then
            local ghost = workspace:FindFirstChild("Ghost")
            if ghost then
                local visibleParts = ghost:FindFirstChild("VisibleParts")
                if visibleParts then
                    for _, obj in ipairs(visibleParts:GetDescendants()) do
                        if obj:IsA("BasePart") then
                            obj.Transparency = 0
                            obj.LocalTransparencyModifier = 0
                            for _, decal in ipairs(obj:GetDescendants()) do
                                if decal:IsA("Decal") then
                                    decal.Transparency = 0
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

local lastDoorState = nil

task.spawn(function()
    while task.wait(1) do
        local orb = workspace:FindFirstChild("GhostOrb")
        if orb and orb:IsA("BasePart") then
            orbparagraph:SetDesc("Status: FOUND")
        else
            orbparagraph:SetDesc("Status: NOT FOUND")
        end

        local hpFolder = workspace:FindFirstChild("Handprints")
        local foundHandprint = false

        if hpFolder and hpFolder:IsA("Folder") then
            for _, obj in ipairs(hpFolder:GetDescendants()) do
                if obj:IsA("BasePart") then
                    foundHandprint = true
                    break
                end
            end
        end

        if foundHandprint then
            handprintparagraph:SetDesc("Status: FOUND")
        else
            handprintparagraph:SetDesc("Status: NOT FOUND")
        end
        
        if AutoHideToggle then
            local exitDoor = workspace:FindFirstChild("Doors")
            exitDoor = exitDoor and exitDoor:FindFirstChild("ExitDoor")
            local isLocked = exitDoor and exitDoor:GetAttribute("Locked") or exitDoor and exitDoor:FindFirstChild("Locked")
            
            if exitDoor then
                if lastDoorState == false and isLocked == true then
                    local targetLocation = workspace:FindFirstChild("Map")
                    targetLocation = targetLocation and targetLocation:FindFirstChild("Rooms")
                    targetLocation = targetLocation and targetLocation:FindFirstChild("Base Camp")
                    targetLocation = targetLocation and targetLocation:FindFirstChild("EnergyMonitorFeed")
                    
                    if targetLocation and targetLocation:IsA("BasePart") then
                        local character = game.Players.LocalPlayer.Character
                        if character and character:FindFirstChild("HumanoidRootPart") then
                            character.HumanoidRootPart.CFrame = targetLocation.CFrame + Vector3.new(0, 5, 0)
                        end
                    end
                end
                lastDoorState = isLocked
            else
                lastDoorState = nil
            end
        else
            lastDoorState = nil
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