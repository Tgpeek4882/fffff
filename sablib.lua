local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Lucide = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/lucide/dist/Icons.lua"))()

-- [ Save System Helpers ]
local SaveFileName = "UILib_Default.json"
local CurrentSettings = {}

local function LoadSettings(name)
    if not name then return end
    SaveFileName = name .. ".json"
    if isfile and isfile(SaveFileName) then
        local Success, Result = pcall(function()
            return HttpService:JSONDecode(readfile(SaveFileName))
        end)
        if Success then CurrentSettings = Result end
    end
end

local function SaveSettings()
    if writefile then
        writefile(SaveFileName, HttpService:JSONEncode(CurrentSettings))
    end
end

local function Create(class, props)
    local instance = Instance.new(class)
    for k, v in pairs(props) do
        if k ~= "Parent" then instance[k] = v end
    end
    if props.Parent then instance.Parent = props.Parent end
    return instance
end

local function MakeDraggable(topbarobject, object)
    local Dragging, DragInput, DragStart, StartPos
    local function Update(input)
        local Delta = input.Position - DragStart
        object.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
    end
    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true; DragStart = input.Position; StartPos = object.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then Dragging = false end end)
        end
    end)
    topbarobject.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then DragInput = input end end)
    UserInputService.InputChanged:Connect(function(input) if input == DragInput and Dragging then Update(input) end end)
end

local function hgui(gui)
    if gethui then gui.Parent = gethui() elseif game:GetService("CoreGui") then gui.Parent = game:GetService("CoreGui") else gui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
end

function Library:CreateWindow(Config)
    local Window = {}
    local IsOpen = true
    local IsPC = UserInputService.KeyboardEnabled and UserInputService.MouseEnabled
    local AllElements = {} -- Stores all buttons/toggles for search
    
    -- Load Configs
    if Config.SaveName then LoadSettings(Config.SaveName) end
    local MainBgTrans = Config.BackgroundTransparency or 0
    local ElemBgTrans = Config.ElementsTransparency or 0
    local HasSearchBar = Config.SearchBar or false

    local ScreenGui = Create("ScreenGui", {
        Name = tostring(math.random(0, 1000000)), ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, IgnoreGuiInset = true, DisplayOrder = 10000
    })
    if syn and syn.protect then syn.protect(ScreenGui); ScreenGui.Parent = game:GetService("CoreGui") else hgui(ScreenGui) end

    local NotifyHolder = Create("Frame", {
        Parent = ScreenGui, Size = UDim2.new(0, 300, 1, -20), Position = UDim2.new(0.5, -150, 0, 0), BackgroundTransparency = 1, ZIndex = 100
    })
    Create("UIListLayout", {Parent = NotifyHolder, SortOrder = "LayoutOrder", Padding = UDim.new(0, 8), VerticalAlignment = "Bottom", HorizontalAlignment = "Center"})

    local MinimizedFrame = Create("TextButton", {
        Parent = ScreenGui, Size = UDim2.new(0, 35, 0, 35), Position = UDim2.new(0.1, 0, 0.1, 0),
        BackgroundColor3 = Color3.fromRGB(15, 15, 15), Text = "", AutoButtonColor = false,
        Visible = not IsPC, Active = true, ZIndex = 200
    })
    Create("UICorner", {Parent = MinimizedFrame, CornerRadius = UDim.new(0, 12)})
    MakeDraggable(MinimizedFrame, MinimizedFrame)

    local MainFrame = Create("Frame", {
        Parent = ScreenGui, Size = UDim2.new(0, 360, 0, 230), Position = UDim2.new(0.5, -180, 0.5, -115),
        BackgroundColor3 = Color3.fromRGB(20, 20, 20), BackgroundTransparency = MainBgTrans, BorderSizePixel = 0, ClipsDescendants = true, Active = true
    })
    Create("UICorner", {Parent = MainFrame, CornerRadius = UDim.new(0, 16)})
    MakeDraggable(MainFrame, MainFrame)

    local TitleLabel = Create("TextLabel", {
        Parent = MainFrame, Size = UDim2.new(0, 0, 0, 25), Position = UDim2.new(0, 12, 0, 2), BackgroundTransparency = 1,
        Text = Config.Title or "UI Library", TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 13, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left, AutomaticSize = Enum.AutomaticSize.X
    })

    -- [ Search Bar ]
    local SearchInput, SearchPage
    if HasSearchBar then
        local SearchIcon = Create("ImageButton", {
            Parent = MainFrame, Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(1, -30, 0, 6),
            BackgroundTransparency = 1, Image = Lucide.search, ImageColor3 = Color3.fromRGB(150, 150, 150)
        })
        
        SearchInput = Create("TextBox", {
            Parent = MainFrame, Size = UDim2.new(0, 0, 0, 20), Position = UDim2.new(1, -32, 0, 5),
            BackgroundTransparency = 1, BackgroundColor3 = Color3.fromRGB(30,30,30), Text = "", 
            TextColor3 = Color3.fromRGB(255,255,255), Font = Enum.Font.Gotham, TextSize = 12, 
            PlaceholderText = "Search...", PlaceholderColor3 = Color3.fromRGB(100,100,100),
            TextXAlignment = "Left", ClipsDescendants = true, Visible = false
        })
        Create("UICorner", {Parent = SearchInput, CornerRadius = UDim.new(0,4)})
        Create("UIPadding", {Parent = SearchInput, PaddingLeft = UDim.new(0,5)})

        local SearchOpen = false
        SearchIcon.MouseButton1Click:Connect(function()
            SearchOpen = not SearchOpen
            if SearchOpen then
                SearchIcon.Visible = false; SearchInput.Visible = true
                TweenService:Create(SearchInput, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 140, 0, 20)}):Play()
                SearchInput:CaptureFocus()
            end
        end)

        SearchInput.FocusLost:Connect(function()
            if SearchInput.Text == "" then
                TweenService:Create(SearchInput, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 0, 0, 20)}):Play()
                task.wait(0.2)
                SearchInput.Visible = false; SearchIcon.Visible = true; SearchOpen = false
            end
        end)
    end

    local Container = Create("Frame", {
        Parent = MainFrame, Size = UDim2.new(1, 0, 1, -30), Position = UDim2.new(0, 0, 0, 30), BackgroundTransparency = 1
    })

    local Sidebar = Create("ScrollingFrame", {
        Parent = Container, Size = UDim2.new(0, 54, 1, 0), Position = UDim2.new(0, 4, 0, 0),
        BackgroundTransparency = 1, ScrollBarThickness = 0, CanvasSize = UDim2.new(0,0,0,0)
    })
    Create("UIListLayout", {Parent = Sidebar, SortOrder = "LayoutOrder", Padding = UDim.new(0, 6), HorizontalAlignment = "Center", VerticalAlignment = "Top"})
    
    Create("Frame", {
        Parent = Container, Size = UDim2.new(0, 1, 1, -10), Position = UDim2.new(0, 62, 0, 5),
        BackgroundColor3 = Color3.fromRGB(40, 40, 40), BorderSizePixel = 0
    })

    local ContentHolder = Create("Frame", {
        Parent = Container, Size = UDim2.new(1, -70, 1, -5), Position = UDim2.new(0, 68, 0, 0), BackgroundTransparency = 1
    })

    local SearchResults = Create("ScrollingFrame", {
        Parent = ContentHolder, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ScrollBarThickness = 2,
        ScrollBarImageColor3 = Color3.fromRGB(60,60,60), Visible = false, AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(0,0,0,0)
    })
    Create("UIListLayout", {Parent = SearchResults, SortOrder = "LayoutOrder", Padding = UDim.new(0, 4)})
    Create("UIPadding", {Parent = SearchResults, PaddingRight = UDim.new(0, 4), PaddingTop = UDim.new(0,2)})

    -- [ SEARCH LOGIC ]
    if HasSearchBar and SearchInput then
        SearchInput:GetPropertyChangedSignal("Text"):Connect(function()
            local Text = SearchInput.Text:lower()
            if #Text > 0 then
                for _, v in pairs(ContentHolder:GetChildren()) do 
                    if v:IsA("ScrollingFrame") and v ~= SearchResults then v.Visible = false end 
                end
                SearchResults.Visible = true
                for _, itemData in pairs(AllElements) do
                    if itemData.Title:lower():find(Text) then itemData.Frame.Parent = SearchResults else itemData.Frame.Parent = itemData.OriginalParent end
                end
            else
                SearchResults.Visible = false
                for _, itemData in pairs(AllElements) do itemData.Frame.Parent = itemData.OriginalParent end
                for _, v in pairs(ContentHolder:GetChildren()) do if v.Name == "ActivePage" then v.Visible = true end end
            end
        end)
    end

    local function ToggleUI()
        IsOpen = not IsOpen
        if IsOpen then
            MainFrame.Visible = true; MainFrame.Size = UDim2.new(0, 360, 0, 0)
            local TargetSize = MainFrame:GetAttribute("TargetSize") or UDim2.new(0, 360, 0, 230)
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = TargetSize}):Play()
        else
            local tween = TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 360, 0, 0)})
            tween:Play(); tween.Completed:Connect(function() if not IsOpen then MainFrame.Visible = false end end)
        end
    end
    MinimizedFrame.MouseButton1Click:Connect(ToggleUI)
    UserInputService.InputBegan:Connect(function(input, gpe) if IsPC and not gpe and input.KeyCode == Enum.KeyCode.K then ToggleUI() end end)

    Window.UI = {}

    function Window.UI.SetSize(size)
        MainFrame:SetAttribute("TargetSize", size)
        if IsOpen then TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = size}):Play() end
    end

    function Window.UI.AddTag(TagConfig)
        local TagFrame = Create("Frame", {
            Parent = MainFrame, Size = UDim2.new(0, 0, 0, 16), BackgroundColor3 = TagConfig.BgColor or Color3.fromRGB(0, 100, 255), Position = UDim2.new(0, TitleLabel.AbsoluteSize.X + 20, 0, 6)
        })
        Create("UICorner", {Parent = TagFrame, CornerRadius = UDim.new(0, 4)})
        Create("TextLabel", {
            Parent = TagFrame, Size = UDim2.new(0, 0, 1, 0), BackgroundTransparency = 1, Text = TagConfig.Name or "Tag", TextColor3 = Color3.fromRGB(255,255,255), Font = Enum.Font.GothamBold, TextSize = 10, AutomaticSize = Enum.AutomaticSize.X
        }); Create("UIPadding", {Parent = TagFrame, PaddingLeft = UDim.new(0,5), PaddingRight = UDim.new(0,5)})
        TitleLabel:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() TagFrame.Position = UDim2.new(0, TitleLabel.AbsoluteSize.X + 20, 0, 6) end)
    end

    function Window.UI.SendNotification(Config)
        local Title, Content, IconStr = Config.Title or "Notification", Config.Content or "Message", Config.Icon or "info"
        local Duration = Config.Duration or 3
        local Notif = Create("Frame", { Parent = NotifyHolder, Size = UDim2.new(0, 260, 0, 55), BackgroundColor3 = Color3.fromRGB(25, 25, 25), BackgroundTransparency = 1 })
        Create("UICorner", {Parent = Notif, CornerRadius = UDim.new(0, 12)})
        local IcoId = (Lucide and Lucide[IconStr]) or ""
        local IconImg = Create("ImageLabel", { Parent = Notif, Size = UDim2.new(0, 22, 0, 22), Position = UDim2.new(0, 12, 0.5, -11), BackgroundTransparency = 1, Image = IcoId, ImageColor3 = Color3.fromRGB(220, 220, 220), ImageTransparency = 1 })
        local TitLbl = Create("TextLabel", { Parent = Notif, Size = UDim2.new(1, -75, 0, 20), Position = UDim2.new(0, 42, 0, 8), BackgroundTransparency = 1, Text = Title, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, TextTransparency = 1 })
        local ConLbl = Create("TextLabel", { Parent = Notif, Size = UDim2.new(1, -75, 0, 20), Position = UDim2.new(0, 42, 0, 26), BackgroundTransparency = 1, Text = Content, TextColor3 = Color3.fromRGB(160, 160, 160), Font = Enum.Font.Gotham, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, TextTransparency = 1 })
        local Bar = Create("Frame", { Parent = Notif, Size = UDim2.new(0, 0, 0, 2), Position = UDim2.new(0, 10, 1, -4), BackgroundColor3 = Color3.fromRGB(0, 200, 100), BorderSizePixel = 0, BackgroundTransparency = 1 })
        Create("UICorner", {Parent = Bar, CornerRadius = UDim.new(1,0)})
        TweenService:Create(Notif, TweenInfo.new(0.3), {BackgroundTransparency = 0.1}):Play(); TweenService:Create(IconImg, TweenInfo.new(0.3), {ImageTransparency = 0}):Play(); TweenService:Create(TitLbl, TweenInfo.new(0.3), {TextTransparency = 0}):Play(); TweenService:Create(ConLbl, TweenInfo.new(0.3), {TextTransparency = 0}):Play(); TweenService:Create(Bar, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
        TweenService:Create(Bar, TweenInfo.new(Duration, Enum.EasingStyle.Linear), {Size = UDim2.new(1, -20, 0, 2)}):Play()
        task.delay(Duration, function()
            TweenService:Create(Notif, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play(); TweenService:Create(IconImg, TweenInfo.new(0.3), {ImageTransparency = 1}):Play(); TweenService:Create(TitLbl, TweenInfo.new(0.3), {TextTransparency = 1}):Play(); TweenService:Create(ConLbl, TweenInfo.new(0.3), {TextTransparency = 1}):Play(); TweenService:Create(Bar, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            task.wait(0.3); Notif:Destroy()
        end)
    end
    function Window.UI.TestPcMode(bool) if bool == nil then bool = true end; IsPC = bool; if IsPC then MinimizedFrame.Visible = false else MinimizedFrame.Visible = true end end
    if IsPC then task.spawn(function() task.wait(1.5); Window.UI.SendNotification({Title = "Azure Hub", Content = "Use 'K' Button To Open/Close UI.", Icon = "info", Duration = 5}) end) end

    local function CreateElementFunctions(Interface, ParentContainer, AddToSearch)
        local function CreateKeybind(Parent, DefaultKey, Callback)
            if not IsPC then return end
            local KeybindBtn = Create("TextButton", {
                Parent = Parent, Size = UDim2.new(0, 20, 0, 16), Position = UDim2.new(1, -65, 0.5, -8),
                BackgroundColor3 = Color3.fromRGB(40, 40, 40), Text = DefaultKey and DefaultKey.Name:sub(1,1) or "None",
                TextColor3 = Color3.fromRGB(150, 150, 150), Font = Enum.Font.Code, TextSize = 10, AutoButtonColor = false
            })
            Create("UICorner", {Parent = KeybindBtn, CornerRadius = UDim.new(0, 4)})
            local Binding, CurrentKey = false, DefaultKey
            KeybindBtn.MouseButton1Click:Connect(function() Binding = true; KeybindBtn.Text = "..."; KeybindBtn.TextColor3 = Color3.fromRGB(255, 200, 50) end)
            UserInputService.InputBegan:Connect(function(input, gpe)
                if Binding and input.UserInputType == Enum.UserInputType.Keyboard then
                    CurrentKey = input.KeyCode; KeybindBtn.Text = CurrentKey.Name:gsub("Left", "L"):gsub("Right", "R"):sub(1, 2)
                    KeybindBtn.TextColor3 = Color3.fromRGB(150, 150, 150); Binding = false
                elseif not Binding and not gpe and input.KeyCode == CurrentKey and Callback then Callback() end
            end)
            return KeybindBtn
        end

        -- [ MODIFIED CREATETOGGLE FUNCTION ]
        function Interface.CreateToggle(Config)
            local SaveKey = Config.Title; if CurrentSettings[SaveKey] ~= nil then Config.Value = CurrentSettings[SaveKey] end
            local ToggleFrame = Create("Frame", { Parent = ParentContainer, Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = Color3.fromRGB(25, 25, 25), BackgroundTransparency = ElemBgTrans })
            Create("UICorner", {Parent = ToggleFrame, CornerRadius = UDim.new(0, 6)})
            Create("TextLabel", { Parent = ToggleFrame, Text = Config.Title, Size = UDim2.new(1, -70, 0, 16), Position = UDim2.new(0, 8, 0, 3), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(240, 240, 240), TextXAlignment = "Left", Font = Enum.Font.GothamMedium, TextSize = 12 })
            if Config.Desc then Create("TextLabel", { Parent = ToggleFrame, Text = Config.Desc, Size = UDim2.new(1, -70, 0, 10), Position = UDim2.new(0, 8, 0, 18), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(120, 120, 120), TextXAlignment = "Left", Font = Enum.Font.Gotham, TextSize = 10 }) end
            local SwitchBG = Create("TextButton", { Parent = ToggleFrame, Size = UDim2.new(0, 34, 0, 16), Position = UDim2.new(1, -40, 0.5, -8), BackgroundColor3 = Config.Value and Color3.fromRGB(40, 200, 80) or Color3.fromRGB(50, 50, 50), Text = "", AutoButtonColor = false })
            Create("UICorner", {Parent = SwitchBG, CornerRadius = UDim.new(1, 0)})
            local Circle = Create("Frame", { Parent = SwitchBG, Size = UDim2.new(0, 12, 0, 12), Position = Config.Value and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6), BackgroundColor3 = Color3.fromRGB(255, 255, 255) })
            Create("UICorner", {Parent = Circle, CornerRadius = UDim.new(1, 0)})
            
            local Enabled = Config.Value or false
            
            -- Visual Update Function (Exposed to Callback)
            local function SetState(NewState)
                Enabled = NewState
                TweenService:Create(SwitchBG, TweenInfo.new(0.2), {BackgroundColor3 = Enabled and Color3.fromRGB(40, 200, 80) or Color3.fromRGB(50, 50, 50)}):Play()
                TweenService:Create(Circle, TweenInfo.new(0.2), {Position = Enabled and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)}):Play()
                CurrentSettings[SaveKey] = Enabled
                SaveSettings()
                -- Note: We do NOT call Config.Callback here to avoid infinite loops if the user sets state inside callback
            end

            -- Initial Trigger
            if Enabled and Config.Callback then task.spawn(function() Config.Callback(Enabled, SetState) end) end
            
            local function ToggleLogic()
                local NewValue = not Enabled
                SetState(NewValue)
                if Config.Callback then Config.Callback(NewValue, SetState) end
            end
            
            SwitchBG.MouseButton1Click:Connect(ToggleLogic)
            if Config.Keybind then local KbBtn = CreateKeybind(ToggleFrame, Config.Keybind, ToggleLogic); if KbBtn then KbBtn.Position = UDim2.new(1, -70, 0.5, -8) end end
            if AddToSearch then table.insert(AllElements, {Frame = ToggleFrame, Title = Config.Title, OriginalParent = ParentContainer}) end
        end

        function Interface.CreateButton(Config)
            local BtnFrame = Create("TextButton", { Parent = ParentContainer, Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = Color3.fromRGB(25, 25, 25), Text = "", AutoButtonColor = false, BackgroundTransparency = ElemBgTrans })
            Create("UICorner", {Parent = BtnFrame, CornerRadius = UDim.new(0, 6)})
            Create("TextLabel", { Parent = BtnFrame, Text = Config.Title, Size = UDim2.new(1, 0, 0, 16), Position = UDim2.new(0, 8, 0, 3), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(240, 240, 240), TextXAlignment = "Left", Font = Enum.Font.GothamMedium, TextSize = 12 })
            if Config.Desc then Create("TextLabel", { Parent = BtnFrame, Text = Config.Desc, Size = UDim2.new(1, 0, 0, 10), Position = UDim2.new(0, 8, 0, 18), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(120, 120, 120), TextXAlignment = "Left", Font = Enum.Font.Gotham, TextSize = 10 }) end
            local function RunCallback() TweenService:Create(BtnFrame, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play(); task.wait(0.1); TweenService:Create(BtnFrame, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}):Play(); if Config.Callback then Config.Callback() end end
            BtnFrame.MouseButton1Click:Connect(RunCallback)
            if Config.Keybind then local KbBtn = CreateKeybind(BtnFrame, Config.Keybind, RunCallback); if KbBtn then KbBtn.Position = UDim2.new(1, -30, 0.5, -8) end end
            if AddToSearch then table.insert(AllElements, {Frame = BtnFrame, Title = Config.Title, OriginalParent = ParentContainer}) end
        end

        function Interface.CreateSlider(Config)
            local SaveKey = Config.Title; if CurrentSettings[SaveKey] ~= nil then Config.Values.DefaultValue = CurrentSettings[SaveKey] end
            local SliderFrame = Create("Frame", { Parent = ParentContainer, Size = UDim2.new(1, 0, 0, 42), BackgroundColor3 = Color3.fromRGB(25, 25, 25), BackgroundTransparency = ElemBgTrans })
            Create("UICorner", {Parent = SliderFrame, CornerRadius = UDim.new(0, 6)})
            Create("TextLabel", { Parent = SliderFrame, Text = Config.Title, Size = UDim2.new(1, -40, 0, 16), Position = UDim2.new(0, 8, 0, 3), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(240, 240, 240), TextXAlignment = "Left", Font = Enum.Font.GothamMedium, TextSize = 12 })
            if Config.Desc then Create("TextLabel", { Parent = SliderFrame, Text = Config.Desc, Size = UDim2.new(1, -40, 0, 10), Position = UDim2.new(0, 8, 0, 17), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(120, 120, 120), TextXAlignment = "Left", Font = Enum.Font.Gotham, TextSize = 10 }) end
            local SliderBG = Create("TextButton", { Parent = SliderFrame, Size = UDim2.new(1, -16, 0, 5), Position = UDim2.new(0, 8, 0, 30), BackgroundColor3 = Color3.fromRGB(45, 45, 45), Text = "", AutoButtonColor = false })
            Create("UICorner", {Parent = SliderBG, CornerRadius = UDim.new(0, 3)})
            local SliderFill = Create("Frame", { Parent = SliderBG, Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = Color3.fromRGB(0, 140, 255), BorderSizePixel = 0 })
            Create("UICorner", {Parent = SliderFill, CornerRadius = UDim.new(0, 3)})
            local ValueLabel = Create("TextLabel", { Parent = SliderFrame, Size = UDim2.new(0, 30, 0, 16), Position = UDim2.new(1, -35, 0, 3), BackgroundTransparency = 1, Text = tostring(Config.Values.DefaultValue), TextColor3 = Color3.fromRGB(200, 200, 200), Font = Enum.Font.Code, TextSize = 11 })
            local Min, Max = Config.Values.MinValue, Config.Values.MaxValue; local Default = math.clamp(Config.Values.DefaultValue, Min, Max); local Step = Config.Step or 1; local Percent = (Default - Min) / (Max - Min); SliderFill.Size = UDim2.new(Percent, 0, 1, 0)
            if Config.Callback then task.spawn(function() Config.Callback(Default) end) end
            local Dragging = false
            local function Update(input)
                local SizeX = math.clamp((input.Position.X - SliderBG.AbsolutePosition.X) / SliderBG.AbsoluteSize.X, 0, 1); local NewValue = math.floor(((SizeX * (Max - Min)) + Min) / Step + 0.5) * Step
                TweenService:Create(SliderFill, TweenInfo.new(0.05), {Size = UDim2.new(SizeX, 0, 1, 0)}):Play(); ValueLabel.Text = tostring(NewValue)
                CurrentSettings[SaveKey] = NewValue; SaveSettings(); if Config.Callback then Config.Callback(NewValue) end
            end
            SliderBG.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then Dragging = true; Update(input); local c; c = UserInputService.InputChanged:Connect(function(input) if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then Update(input) end end); local e; e = UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then Dragging = false; c:Disconnect(); e:Disconnect() end end) end end)
            if AddToSearch then table.insert(AllElements, {Frame = SliderFrame, Title = Config.Title, OriginalParent = ParentContainer}) end
        end
    end

    local FirstTab = true
    local TabsList = {} 

    function Window.UI.CreateTab(TabConfig)
        local Tab = {}
        local IconId = TabConfig.Icon; if Lucide and Lucide[IconId] then IconId = Lucide[IconId] end
        local TabBtn = Create("ImageButton", { Parent = Sidebar, Size = UDim2.new(0, 38, 0, 38), BackgroundColor3 = Color3.fromRGB(30, 30, 30), Image = IconId or "", ImageColor3 = Color3.fromRGB(150, 150, 150), AutoButtonColor = false })
        Create("UICorner", {Parent = TabBtn, CornerRadius = UDim.new(0, 12)})
        table.insert(TabsList, TabBtn)
        local Page = Create("ScrollingFrame", { Parent = ContentHolder, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ScrollBarThickness = 2, ScrollBarImageColor3 = Color3.fromRGB(60,60,60), Visible = false, AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(0,0,0,0) })
        Create("UIListLayout", {Parent = Page, SortOrder = "LayoutOrder", Padding = UDim.new(0, 4)}); Create("UIPadding", {Parent = Page, PaddingRight = UDim.new(0, 4), PaddingTop = UDim.new(0,2)})
        local function Activate()
            for _, btn in pairs(TabsList) do TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 30), ImageColor3 = Color3.fromRGB(150, 150, 150)}):Play() end
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50), ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            for _, v in pairs(ContentHolder:GetChildren()) do if v:IsA("ScrollingFrame") and v ~= SearchResults then v.Visible = false; if v.Name == "ActivePage" then v.Name = "Page" end end end
            Page.Visible = true; Page.Name = "ActivePage"
        end
        TabBtn.MouseButton1Click:Connect(Activate)
        if FirstTab then FirstTab = false; Activate() end

        CreateElementFunctions(Tab, Page, true)

        function Tab.CreateSection(SectionConfig)
            local Section = {}
            local SectionTitle = SectionConfig.Title or "Section"
            local SectionIcon = SectionConfig.Icon or ""
            if Lucide and Lucide[SectionConfig.Icon] then SectionIcon = Lucide[SectionConfig.Icon] end
            
            local SectionFrame = Create("Frame", {
                Parent = Page, Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1, ClipsDescendants = true
            })
            
            local Header = Create("TextButton", {
                Parent = SectionFrame, Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = Color3.fromRGB(25, 25, 25), BackgroundTransparency = ElemBgTrans, Text = "", AutoButtonColor = false
            })
            Create("UICorner", {Parent = Header, CornerRadius = UDim.new(0, 6)})
            
            local TitleText = SectionTitle
            if SectionConfig.Icon and not Lucide[SectionConfig.Icon] then TitleText = SectionConfig.Icon .. " " .. SectionTitle end
            
            local TitleLabel = Create("TextLabel", {
                Parent = Header, Size = UDim2.new(1, -40, 1, 0), Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1, Text = TitleText, TextColor3 = Color3.fromRGB(255, 255, 255),
                Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left
            })
            
            if Lucide and Lucide[SectionConfig.Icon] then
                TitleLabel.Position = UDim2.new(0, 34, 0, 0)
                Create("ImageLabel", {
                    Parent = Header, Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(0, 8, 0.5, -9),
                    BackgroundTransparency = 1, Image = SectionIcon, ImageColor3 = Color3.fromRGB(255, 255, 255)
                })
            end
            
            local Arrow = Create("ImageLabel", {
                Parent = Header, Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(1, -26, 0.5, -8),
                BackgroundTransparency = 1, Image = Lucide.chevronDown or "rbxassetid://6034818372",
                ImageColor3 = Color3.fromRGB(150, 150, 150)
            })
            
            local Content = Create("Frame", {
                Parent = SectionFrame, Size = UDim2.new(1, -10, 0, 0), Position = UDim2.new(0, 5, 0, 36),
                BackgroundTransparency = 1
            })
            local ContentLayout = Create("UIListLayout", {Parent = Content, SortOrder = "LayoutOrder", Padding = UDim.new(0, 4)})
            
            local Expanded = false
            function Section:Toggle(Force)
                if Force ~= nil then Expanded = Force else Expanded = not Expanded end
                local ContentHeight = ContentLayout.AbsoluteContentSize.Y
                local TargetHeight = Expanded and (ContentHeight + 42) or 32
                
                TweenService:Create(SectionFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(1, 0, 0, TargetHeight)}):Play()
                TweenService:Create(Arrow, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Rotation = Expanded and 180 or 0}):Play()
            end
            
            Header.MouseButton1Click:Connect(function() Section:Toggle() end)
            
            ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                if Expanded then
                    local ContentHeight = ContentLayout.AbsoluteContentSize.Y
                    TweenService:Create(SectionFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(1, 0, 0, ContentHeight + 42)}):Play()
                end
            end)
            CreateElementFunctions(Section, Content, true)
            return Section
        end

        return Tab
    end
    return Window
end
return Library
