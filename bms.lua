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

local blacklist = {"bLockerman666"}
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

local gid = 0
local bannedRanks = {}
local rankName = lp:GetRoleInGroup(0)

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
    Title = "Azure Hub | Mineswepeer " .. getTag(lp.Name),
    Author = "discord.gg/QmvpbPdw9J",
    Folder = "FischHub",
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
    Desc = "28.11.25\n[+] Blockerman's Minesweeper\n[+] Features",
    Locked = false,
    Buttons = {
        {
            Icon = "clipboard",
            Title = "Discord Server",
            Callback = function() setclipboard(discordLink) WindUI:Notify({ Title = "Discord Server", Content = "Link Copied!", Icon = "info", Duration = 2 }) end,
        }
    }
})

local AntiExplodeToggle = false
local HighlightToggle = false

local WalkToggle = false
local currentSpeed = 16
local Noclip = nil
local Clip = nil
local NoclipToggle = false

local antiAfkToggle = false
local FlingToggle = false
local antiFlingToggle = false
local flingThread

local data = {cells={all={},numbered={},toFlag={},toClear={},guess={}},cache={xs_centers_cached=nil,zs_centers_cached=nil},grid={w=0,h=0},ui={PROB_FLAG_THRESHOLD=0.7,PROB_SAFE_THRESHOLD=0.3},timing={lastPlanTick=0,planIntervalMs=100},highlights={}};
local abs, floor, huge = math.abs, math.floor, math.huge;
local sort = table.sort;
local function isNumber(str)
	return tonumber(str) ~= nil;
end
local function key(ix, iz)
	return tostring(ix) .. ":" .. tostring(iz);
end
local function clusterSorted(sorted_list, epsilon)
	local clusters = {};
	if (#sorted_list == 0) then
		return clusters;
	end
	local current_center = sorted_list[1];
	local current_count = 1;
	for i = 2, #sorted_list do
		local v = sorted_list[i];
		if (abs(v - current_center) <= epsilon) then
			current_count = current_count + 1;
			current_center = current_center + ((v - current_center) / current_count);
		else
			table.insert(clusters, current_center);
			current_center = v;
			current_count = 1;
		end
	end
	table.insert(clusters, current_center);
	return clusters;
end
local function median(tbl)
	if (#tbl == 0) then
		return nil;
	end
	sort(tbl);
	local mid = floor((#tbl + 1) / 2);
	return tbl[mid];
end
local function typicalSpacing(sorted_centers)
	if (#sorted_centers < 2) then
		return 4;
	end
	local diffs = {};
	for i = 2, #sorted_centers do
		diffs[#diffs + 1] = abs(sorted_centers[i] - sorted_centers[i - 1]);
	end
	return median(diffs) or 4;
end
local function nearestIndex(v, centers)
	local bestI = 1;
	local bestD = huge;
	for i = 1, #centers do
		local d = abs(v - centers[i]);
		if (d < bestD) then
			bestD = d;
			bestI = i;
		end
	end
	return bestI - 1;
end
local function isCoveredCell(cell)
	if not cell then
		return false;
	end
	if ((cell.state == "number") or (cell.state == "flagged")) then
		return false;
	end
	return cell.covered ~= false;
end
local function isPartFlagged(part)
	if (not part or not part.GetChildren) then
		return false;
	end
	local children = part:GetChildren();
	for _, child in pairs(children) do
		local name = child and child.Name;
		if (name and (string.sub(name, 1, 4) == "Flag")) then
			return true;
		end
	end
	return false;
end
local function buildGrid()
	data.cells.all = {};
	data.cells.numbered = {};
	data.cells.grid = {};
	local root = game.Workspace:FindFirstChild("Flag");
	if not root then
		warn("Cannot find workspace.Flag");
		return;
	end
	local partsFolder = root:FindFirstChild("Parts");
	if not partsFolder then
		warn("Cannot find workspace.Flag.Parts");
		return;
	end
	local parts = partsFolder:GetChildren();
	local raw = {};
	local sumY, countY = 0, 0;
	for _, part in pairs(parts) do
		local pos = part and part.Position;
		if pos then
			table.insert(raw, {part=part,pos=pos});
			sumY = sumY + pos.Y;
			countY = countY + 1;
		end
	end
	local centersX, centersZ = {}, {};
	for _, item in ipairs(raw) do
		centersX[#centersX + 1] = item.pos.X;
		centersZ[#centersZ + 1] = item.pos.Z;
	end
	sort(centersX);
	sort(centersZ);
	local typicalWX = typicalSpacing(centersX);
	local typicalWZ = typicalSpacing(centersZ);
	local epsX = typicalWX * 0.6;
	local epsZ = typicalWZ * 0.6;
	data.cache.xs_centers_cached = clusterSorted(centersX, epsX);
	data.cache.zs_centers_cached = clusterSorted(centersZ, epsZ);
	data.grid.w = #data.cache.xs_centers_cached;
	data.grid.h = #data.cache.zs_centers_cached;
	local planeY = ((countY > 0) and (sumY / countY)) or 0;
	for iz = 0, data.grid.h - 1 do
		for ix = 0, data.grid.w - 1 do
			local k = key(ix, iz);
			local row = data.cells.grid[ix];
			if not row then
				row = {};
				data.cells.grid[ix] = row;
			end
			local cell = {ix=ix,iz=iz,part=nil,pos=Vector3.new(data.cache.xs_centers_cached[ix + 1] or 0, planeY, data.cache.zs_centers_cached[iz + 1] or 0),state="unknown",number=nil,k=k,covered=true,neigh=nil};
			data.cells.all[k] = cell;
			row[iz] = cell;
		end
	end
	for _, item in ipairs(raw) do
		local part = item.part;
		local pos = item.pos;
		local ix = nearestIndex(pos.X, data.cache.xs_centers_cached);
		local iz = nearestIndex(pos.Z, data.cache.zs_centers_cached);
		if ((ix >= 0) and (ix < data.grid.w) and (iz >= 0) and (iz < data.grid.h)) then
			local k = key(ix, iz);
			local cell = data.cells.all[k];
			if not cell.part then
				cell.part = part;
				cell.pos = pos;
			else
				local cur_d = abs(((cell.part and cell.part.Position.X) or cell.pos.X) - data.cache.xs_centers_cached[ix + 1]) + abs(((cell.part and cell.part.Position.Z) or cell.pos.Z) - data.cache.zs_centers_cached[iz + 1]);
				local new_d = abs(pos.X - data.cache.xs_centers_cached[ix + 1]) + abs(pos.Z - data.cache.zs_centers_cached[iz + 1]);
				if (new_d < cur_d) then
					cell.part = part;
					cell.pos = pos;
				end
			end
			if part.Color then
				local color = part.Color;
				local r = color.R or color.r or color[1];
				local g = color.G or color.g or color[2];
				local b = color.B or color.b or color[3];
				if (r and (r <= 1)) then
					r = math.floor((r * 255) + 0.5);
				end
				if (g and (g <= 1)) then
					g = math.floor((g * 255) + 0.5);
				end
				if (b and (b <= 1)) then
					b = math.floor((b * 255) + 0.5);
				end
				cell.color = {R=r,G=g,B=b};
			end
			local ngui = part:FindFirstChild("NumberGui");
			if ngui then
				local textLabel = ngui:FindFirstChild("TextLabel");
				if (textLabel and textLabel.Text and isNumber(textLabel.Text)) then
					cell.number = tonumber(textLabel.Text);
					cell.covered = false;
				end
			end
			if (cell.color and cell.color.R and cell.color.G and cell.color.B) then
				if ((cell.color.R == 255) and (cell.color.G == 255) and (cell.color.B == 125)) then
					cell.covered = false;
				end
			end
			if isPartFlagged(part) then
				cell.state = "flagged";
			end
			if (cell.number and not cell.covered) then
				cell.state = "number";
				table.insert(data.cells.numbered, cell);
			end
		end
	end
	for iz = 0, data.grid.h - 1 do
		for ix = 0, data.grid.w - 1 do
			local c = data.cells.grid[ix][iz];
			local neigh = {};
			for dz = -1, 1 do
				for dx = -1, 1 do
					if not ((dx == 0) and (dz == 0)) then
						local jx, jz = ix + dx, iz + dz;
						if ((jx >= 0) and (jx < data.grid.w) and (jz >= 0) and (jz < data.grid.h)) then
							local row = data.cells.grid[jx];
							local n = row and row[jz];
							if n then
								neigh[#neigh + 1] = n;
							end
						end
					end
				end
			end
			c.neigh = neigh;
		end
	end
end
local function neighbors(ix, iz)
	local row = data.cells.grid[ix];
	local c = row and row[iz];
	return (c and c.neigh) or {};
end
local function planMove()
	if (not data.cache.xs_centers_cached or not data.cache.zs_centers_cached or (data.grid.w == 0) or (data.grid.h == 0)) then
		return;
	end
	if (#data.cells.numbered == 0) then
		data.cells.toFlag = {};
		data.cells.toClear = {};
		data.cells.guess = {};
		return;
	end
	data.cells.toFlag = {};
	data.cells.toClear = {};
	data.cells.guess = {};
	local knownFlag = {};
	for _, cell in pairs(data.cells.all) do
		if (cell.state == "flagged") then
			knownFlag[cell] = true;
		end
	end
	local knownClear = {};
	local scratch = {};
	local function computeUnknowns(c)
		local nbs = neighbors(c.ix, c.iz);
		for i = 1, #scratch do
			scratch[i] = nil;
		end
		local flaggedCount = 0;
		for i = 1, #nbs do
			local nb = nbs[i];
			if (knownFlag[nb] or (nb.state == "flagged")) then
				flaggedCount = flaggedCount + 1;
			elseif (not knownClear[nb] and isCoveredCell(nb)) then
				scratch[#scratch + 1] = nb;
			end
		end
		return scratch, flaggedCount;
	end
	local changed = true;
	local guard = 0;
	while changed and (guard < 64) do
		changed = false;
		guard = guard + 1;
		for _, cell in ipairs(data.cells.numbered) do
			local num = cell.number or 0;
			local unknowns, flaggedCount = computeUnknowns(cell);
			local remaining = num - flaggedCount;
			if ((remaining > 0) and (remaining == #unknowns)) then
				for i = 1, #unknowns do
					local u = unknowns[i];
					if not knownFlag[u] then
						knownFlag[u] = true;
						data.cells.toFlag[u] = true;
						changed = true;
					end
				end
			elseif ((remaining == 0) and (#unknowns > 0)) then
				for i = 1, #unknowns do
					local u = unknowns[i];
					if not knownClear[u] then
						knownClear[u] = true;
						data.cells.toClear[u] = true;
						changed = true;
					end
				end
			end
		end
	end
	local accum = {};
	for _, cell in ipairs(data.cells.numbered) do
		local num = cell.number or 0;
		local unknowns, flaggedCount = computeUnknowns(cell);
		local remaining = num - flaggedCount;
		if ((remaining > 0) and (#unknowns > 0)) then
			local p_each = remaining / #unknowns;
			for i = 1, #unknowns do
				local u = unknowns[i];
				if (not knownFlag[u] and not knownClear[u]) then
					local e = accum[u];
					if not e then
						e = {sum=0,w=0};
						accum[u] = e;
					end
					e.sum = e.sum + p_each;
					e.w = e.w + 1;
				end
			end
		end
	end
	local pflag = data.ui.PROB_FLAG_THRESHOLD;
	for cell, e in pairs(accum) do
		local p = ((e.w > 0) and (e.sum / e.w)) or 0;
		if knownFlag[cell] then
			data.cells.toFlag[cell] = true;
		elseif (p >= pflag) then
			data.cells.toFlag[cell] = true;
			knownFlag[cell] = true;
		else
			data.cells.guess[cell] = p;
		end
	end
	for cell, _ in pairs(data.cells.toFlag) do
		data.cells.toClear[cell] = nil;
		data.cells.guess[cell] = nil;
	end
	for cell, _ in pairs(data.cells.toClear) do
		data.cells.toFlag[cell] = nil;
		data.cells.guess[cell] = nil;
	end
	for cell, _ in pairs(data.cells.guess) do
		if knownFlag[cell] then
			data.cells.guess[cell] = nil;
		end
	end
end
local function clearHighlights()
	for _, highlight in pairs(data.highlights) do
		if (highlight and highlight.Parent) then
			highlight:Destroy();
		end
	end
	data.highlights = {};
end
local function createHighlight(part, color)
    if color == Color3.new(1, 0, 0) then
        local explosion = Instance.new("BillboardGui");
        explosion.Size = UDim2.new(2, 0, 2, 0);
        explosion.AlwaysOnTop = true;
        explosion.Adornee = part;
        explosion.Parent = part;
        explosion.StudsOffset = Vector3.new(0, 3, 0)
        
        local label = Instance.new("TextLabel");
        label.Text = "💥";
        label.Size = UDim2.new(1, 0, 1, 0);
        label.BackgroundTransparency = 1;
        label.TextScaled = true;
        label.Font = Enum.Font.SourceSansBold;
        label.TextColor3 = Color3.new(1, 1, 1);
        label.Parent = explosion;
        
    elseif color == Color3.new(0, 1, 0) then
        local checkmark = Instance.new("BillboardGui");
        checkmark.Size = UDim2.new(2, 0, 2, 0);
        checkmark.AlwaysOnTop = true;
        checkmark.Adornee = part;
        checkmark.Parent = part;
        checkmark.StudsOffset = Vector3.new(0, 3, 0)
        
        local label = Instance.new("TextLabel");
        label.Text = "✅";
        label.Size = UDim2.new(1, 0, 1, 0);
        label.BackgroundTransparency = 1;
        label.TextScaled = true;
        label.Font = Enum.Font.SourceSansBold;
        label.TextColor3 = Color3.new(1, 1, 1);
        label.Parent = checkmark;
    end
end
local function highlightCells()
	clearHighlights();
	local safeCount = 0;
	local mineCount = 0;
	for cell, _ in pairs(data.cells.toClear or {}) do
		if cell.part then
			local highlight = createHighlight(cell.part, Color3.fromRGB(0, 255, 0));
			table.insert(data.highlights, highlight);
			safeCount = safeCount + 1;
		end
	end
	for cell, _ in pairs(data.cells.toFlag or {}) do
		if cell.part then
		        if AntiExplodeToggle then
		                cell.part.CanTouch = false
		        end
			local highlight = createHighlight(cell.part, Color3.fromRGB(255, 0, 0));
			table.insert(data.highlights, highlight);
			mineCount = mineCount + 1;
		end
	end
end
local lastBuild = 0;
local function onUpdate()
	local now = tick();
	if ((now - lastBuild) > 0.033) then
		buildGrid();
		lastBuild = now;
	end
	if ((data.grid.w == 0) or not data.cache.xs_centers_cached or not data.cache.zs_centers_cached) then
		return;
	end
       planMove();
       highlightCells();
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
            local char = game.Players.LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            
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

local AntiExplodeHandle = TabHandles.Main:Toggle({
	Title = "Anti Explode",
	Desc = "Stepping to uncorrect block doesnt explode the whole map and you dont lose.",
	Value = false,
	Callback = function(state)
		AntiExplodeToggle = state
	end
})
local EspHandle = TabHandles.Main:Toggle({
	Title = "Highlight Blocks",
	Desc = "Highlights blocks in colors, green is safe to step, red is not.",
	Value = false,
	Callback = function(state)
		HighlightToggle = state
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
            configFile:Register("EspHandle", EspHandle)
            configFile:Register("AntiExplodeHandle", AntiExplodeHandle)
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
local autoLoadFile = "AZUREHUB_ALC_BMS.txt"
local ALC = false

if ConfigManager then
    ConfigManager:Init(Window)
    
    configFile = ConfigManager:CreateConfig(configName)
    configFile:Register("EspHandle", EspHandle)
    configFile:Register("AntiExplodeHandle", AntiExplodeHandle)
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
                configFile:Register("EspHandle", EspHandle)
                configFile:Register("AntiExplodeHandle", AntiExplodeHandle)
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

local lastupdate = 0
game:GetService("RunService").Heartbeat:Connect(function()
    if HighlightToggle and tick() - lastupdate > 0.2 then
        onUpdate()
        lastupdate = tick()
    end
end)