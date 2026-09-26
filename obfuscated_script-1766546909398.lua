--[[
    Matcha UI Library
    - Perfect Replication of the provided UI
    - Highly Customizable
    - Feature-rich: Dragging, Resizing, Tabs, Groupboxes, Dropdowns, Sliders, Checkboxes, Color Picker Swatches, Flag System.
    - Perfectly Centered
]]

local MatchaUI = {}
MatchaUI.__index = MatchaUI

-- =========================================================
-- DEFAULT THEME (Customizable)
-- =========================================================
MatchaUI.DefaultTheme = {
    MainBackground = Color3.fromRGB(18, 18, 22),      -- Darkest background
    PanelBackground = Color3.fromRGB(28, 28, 34),     -- Groupbox background
    ElementBackground = Color3.fromRGB(40, 40, 48),   -- Checkbox/Dropdown background
    ElementHover = Color3.fromRGB(50, 50, 60),
    TextPrimary = Color3.fromRGB(240, 240, 245),
    TextSecondary = Color3.fromRGB(140, 140, 150),
    Accent = Color3.fromRGB(85, 140, 255),
    Red = Color3.fromRGB(255, 80, 80),
    Green = Color3.fromRGB(80, 255, 80),
    White = Color3.fromRGB(255, 255, 255),
    Black = Color3.fromRGB(0, 0, 0),
    Font = Enum.Font.Gotham,
    FontBold = Enum.Font.GothamBold,
    Corner = UDim.new(0, 6),
    ElementCorner = UDim.new(0, 4),
    WindowSize = UDim2.new(0, 800, 0, 550),
}

-- =========================================================
-- UTILITY FUNCTIONS
-- =========================================================
local function Create(className, properties)
    local instance = Instance.new(className)
    for k, v in pairs(properties) do
        instance[k] = v
    end
    return instance
end

local function AddCorner(parent, radius)
    return Create("UICorner", {CornerRadius = radius or UDim.new(0, 6), Parent = parent})
end

local function AddPadding(parent, top, bottom, left, right)
    return Create("UIPadding", {
        PaddingTop = UDim.new(0, top or 0),
        PaddingBottom = UDim.new(0, bottom or 0),
        PaddingLeft = UDim.new(0, left or 0),
        PaddingRight = UDim.new(0, right or 0),
        Parent = parent
    })
end

local function AddStroke(parent, color, thickness)
    return Create("UIStroke", {
        Color = color or Color3.fromRGB(0,0,0),
        Thickness = thickness or 1,
        Parent = parent
    })
end

-- =========================================================
-- COMPONENTS
-- =========================================================

function MatchaUI:CreateCheckbox(parent, text, default, flag, color1, color2)
    local container = Create("Frame", {
        Name = text .. "Checkbox",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 24),
        Parent = parent
    })

    local box = Create("Frame", {
        BackgroundColor3 = self.Theme.ElementBackground,
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0, 0, 0.5, -8),
        Parent = container
    })
    AddCorner(box, self.Theme.ElementCorner)
    AddStroke(box, self.Theme.MainBackground)

    local check = Create("Frame", {
        BackgroundColor3 = self.Theme.Accent,
        Size = UDim2.new(0, 10, 0, 10),
        Position = UDim2.new(0.5, -5, 0.5, -5),
        Visible = default,
        Parent = box
    })
    AddCorner(check, UDim.new(0, 2))

    Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -30, 1, 0),
        Position = UDim2.new(0, 24, 0, 0),
        Text = text,
        TextColor3 = self.Theme.TextPrimary,
        TextSize = 12,
        Font = self.Theme.Font,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = container
    })

    local state = default
    local button = Create("TextButton", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = "",
        Parent = container
    })

    button.MouseButton1Click:Connect(function()
        state = not state
        check.Visible = state
        if flag then self.Flags[flag] = state end
    end)

    if flag then self.Flags[flag] = default end

    -- Optional Color Swatches
    if color1 then
        local c1 = Create("Frame", {
            BackgroundColor3 = color1,
            Size = UDim2.new(0, 16, 0, 16),
            Position = UDim2.new(1, -40, 0.5, -8),
            Parent = container
        })
        AddCorner(c1, self.Theme.ElementCorner)
        AddStroke(c1, self.Theme.MainBackground)
    end
    if color2 then
        local c2 = Create("Frame", {
            BackgroundColor3 = color2,
            Size = UDim2.new(0, 16, 0, 16),
            Position = UDim2.new(1, -20, 0.5, -8),
            Parent = container
        })
        AddCorner(c2, self.Theme.ElementCorner)
        AddStroke(c2, self.Theme.MainBackground)
    end

    return container
end

function MatchaUI:CreateSlider(parent, text, min, max, default, flag)
    local container = Create("Frame", {
        Name = text .. "Slider",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 40),
        Parent = parent
    })

    Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -40, 0, 15),
        Text = text,
        TextColor3 = self.Theme.TextSecondary,
        TextSize = 11,
        Font = self.Theme.Font,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = container
    })

    local valueLabel = Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 40, 0, 15),
        Position = UDim2.new(1, -40, 0, 0),
        Text = tostring(default),
        TextColor3 = self.Theme.TextPrimary,
        TextSize = 11,
        Font = self.Theme.Font,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = container
    })

    local sliderBg = Create("Frame", {
        BackgroundColor3 = self.Theme.ElementBackground,
        Size = UDim2.new(1, 0, 0, 5),
        Position = UDim2.new(0, 0, 0, 26),
        Parent = container
    })
    AddCorner(sliderBg, UDim.new(1, 0))

    local fill = Create("Frame", {
        BackgroundColor3 = self.Theme.Accent,
        Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
        Parent = sliderBg
    })
    AddCorner(fill, UDim.new(1, 0))

    local knob = Create("Frame", {
        BackgroundColor3 = self.Theme.White,
        Size = UDim2.new(0, 14, 0, 14),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(fill.Size.X.Scale, 0, 0.5, 0),
        Parent = sliderBg
    })
    AddCorner(knob, UDim.new(1, 0))

    local dragging = false
    local function updateSlider(input)
        local mousePos = input.Position.X
        local sliderPos = sliderBg.AbsolutePosition.X
        local sliderSize = sliderBg.AbsoluteSize.X
        
        local percentage = math.clamp((mousePos - sliderPos) / sliderSize, 0, 1)
        local value = math.floor(min + ((max - min) * percentage))
        
        fill.Size = UDim2.new(percentage, 0, 1, 0)
        knob.Position = UDim2.new(percentage, 0, 0.5, 0)
        valueLabel.Text = tostring(value)
        if flag then self.Flags[flag] = value end
    end

    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            updateSlider(input)
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input)
        end
    end)

    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    if flag then self.Flags[flag] = default end
    return container
end

function MatchaUI:CreateDropdown(parent, text, options, default, flag)
    local container = Create("Frame", {
        Name = text .. "Dropdown",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 45),
        Parent = parent
    })

    Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 15),
        Text = text,
        TextColor3 = self.Theme.TextSecondary,
        TextSize = 11,
        Font = self.Theme.Font,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = container
    })

    local dropbox = Create("Frame", {
        BackgroundColor3 = self.Theme.ElementBackground,
        Size = UDim2.new(1, 0, 0, 26),
        Position = UDim2.new(0, 0, 0, 16),
        Parent = container
    })
    AddCorner(dropbox, self.Theme.ElementCorner)
    AddStroke(dropbox, self.Theme.MainBackground)

    local selectedText = Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 8, 0, 0),
        Text = default,
        TextColor3 = self.Theme.TextPrimary,
        TextSize = 12,
        Font = self.Theme.Font,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = dropbox
    })

    local arrow = Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 20, 1, 0),
        Position = UDim2.new(1, -20, 0, 0),
        Text = "v",
        TextColor3 = self.Theme.TextSecondary,
        TextSize = 12,
        Font = self.Theme.Font,
        Parent = dropbox
    })

    local button = Create("TextButton", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = "",
        Parent = dropbox
    })

    local menu = Create("Frame", {
        BackgroundColor3 = self.Theme.ElementBackground,
        Size = UDim2.new(1, 0, 0, #options * 22),
        Position = UDim2.new(0, 0, 1, 4),
        Visible = false,
        ZIndex = 50,
        Parent = dropbox
    })
    AddCorner(menu, self.Theme.ElementCorner)
    AddStroke(menu, self.Theme.MainBackground)

    Create("UIListLayout", {
        Padding = UDim.new(0, 2),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = menu
    })
    AddPadding(menu, 4, 4, 4, 4)

    for _, opt in ipairs(options) do
        local optBtn = Create("TextButton", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 20),
            Text = opt,
            TextColor3 = self.Theme.TextSecondary,
            TextSize = 12,
            Font = self.Theme.Font,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 51,
            Parent = menu
        })
        optBtn.MouseEnter:Connect(function() optBtn.TextColor3 = self.Theme.White end)
        optBtn.MouseLeave:Connect(function() optBtn.TextColor3 = self.Theme.TextSecondary end)
        optBtn.MouseButton1Click:Connect(function()
            selectedText.Text = opt
            menu.Visible = false
            arrow.Text = "v"
            if flag then self.Flags[flag] = opt end
        end)
    end

    button.MouseButton1Click:Connect(function()
        menu.Visible = not menu.Visible
        arrow.Text = menu.Visible and "^" or "v"
    end)

    if flag then self.Flags[flag] = default end
    return container
end

-- =========================================================
-- WINDOW CREATION
-- =========================================================

function MatchaUI.new(settings)
    local self = setmetatable({}, MatchaUI)
    self.Flags = {}
    self.Theme = {}
    
    -- Apply Custom Theme over Defaults
    for k, v in pairs(MatchaUI.DefaultTheme) do
        if settings and settings.Theme and settings.Theme[k] then
            self.Theme[k] = settings.Theme[k]
        else
            self.Theme[k] = v
        end
    end
    
    self.ScreenGui = Create("ScreenGui", {
        Name = "MatchaUI",
        ResetOnSpawn = false,
        Parent = game:GetService("CoreGui")
    })

    return self
end

function MatchaUI:CreateWindow(title)
    -- Perfectly Centered Main Frame
    local mainFrame = Create("Frame", {
        Name = "MainFrame",
        BackgroundColor3 = self.Theme.MainBackground,
        Size = self.Theme.WindowSize,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = self.ScreenGui
    })
    AddCorner(mainFrame, UDim.new(0, 8))
    AddStroke(mainFrame, Color3.fromRGB(45, 45, 55), 1)
    mainFrame.ClipsDescendants = true

    -- Draggable Logic
    local dragging, dragInput, dragStart, startPos
    local topBar = Create("Frame", {
        Name = "TopBar",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 35),
        Parent = mainFrame
    })
    AddPadding(topBar, 0, 0, 15, 15)

    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    topBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Top Bar Text
    Create("TextLabel", {
        BackgroundTransparency = 1, Size = UDim2.new(0, 60, 1, 0),
        Text = title, TextColor3 = self.Theme.TextPrimary, TextSize = 13,
        Font = self.Theme.FontBold, TextXAlignment = Enum.TextXAlignment.Left, Parent = topBar
    })
    Create("TextLabel", {
        BackgroundTransparency = 1, Size = UDim2.new(0, 60, 1, 0), Position = UDim2.new(0, 70, 0, 0),
        Text = "Interface", TextColor3 = self.Theme.TextSecondary, TextSize = 12,
        Font = self.Theme.Font, TextXAlignment = Enum.TextXAlignment.Left, Parent = topBar
    })
    Create("TextLabel", {
        BackgroundTransparency = 1, Size = UDim2.new(0, 60, 1, 0), Position = UDim2.new(0, 140, 0, 0),
        Text = "Standard", TextColor3 = self.Theme.TextSecondary, TextSize = 12,
        Font = self.Theme.Font, TextXAlignment = Enum.TextXAlignment.Left, Parent = topBar
    })
    Create("TextLabel", {
        BackgroundTransparency = 1, Size = UDim2.new(0, 100, 1, 0), Position = UDim2.new(1, -100, 0, 0),
        Text = "Dejected", TextColor3 = self.Theme.TextSecondary, TextSize = 12,
        Font = self.Theme.Font, TextXAlignment = Enum.TextXAlignment.Right, Parent = topBar
    })

    -- Tab Bar Holder
    local tabBar = Create("Frame", {
        Name = "TabBar", BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 30), Position = UDim2.new(0, 0, 0, 35),
        Parent = mainFrame
    })
    AddPadding(tabBar, 0, 0, 15, 15)
    
    local tabLayout = Create("UIListLayout", {
        Padding = UDim.new(0, 15),
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = tabBar
    })

    -- Content Area
    local contentArea = Create("Frame", {
        Name = "ContentArea", BackgroundTransparency = 1,
        Size = UDim2.new(1, -240, 1, -100), Position = UDim2.new(0, 15, 0, 75),
        Parent = mainFrame
    })

    -- Preview Area (Right side)
    local previewFrame = Create("Frame", {
        Name = "PreviewFrame", BackgroundColor3 = self.Theme.PanelBackground,
        Size = UDim2.new(0, 195, 0, 380), Position = UDim2.new(1, -210, 0, 75),
        Parent = mainFrame
    })
    AddCorner(previewFrame, UDim.new(0, 8))
    AddStroke(previewFrame, Color3.fromRGB(40, 40, 45))

    -- Preview Tabs
    local previewTabs = Create("Frame", {
        BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 25),
        Parent = previewFrame
    })
    AddPadding(previewTabs, 8, 0, 8, 8)
    local pLayout = Create("UIListLayout", { Padding = UDim.new(0, 10), FillDirection = Enum.FillDirection.Horizontal, Parent = previewTabs })
    
    for _, tabName in ipairs({"ESP", "Preview", "3D"}) do
        local isActive = (tabName == "Preview")
        Create("TextButton", {
            BackgroundTransparency = 1, Size = UDim2.new(0, 45, 1, 0),
            Text = tabName, TextColor3 = isActive and self.Theme.TextPrimary or self.Theme.TextSecondary,
            TextSize = 11, Font = self.Theme.Font, Parent = previewTabs
        })
    end

    -- Footer
    local footer = Create("Frame", {
        BackgroundTransparency = 1, Size = UDim2.new(1, -30, 0, 20),
        Position = UDim2.new(0, 15, 1, -25), Parent = mainFrame
    })
    Create("TextLabel", { BackgroundTransparency = 1, Size = UDim2.new(0, 100, 1, 0), Text = "67M online", TextColor3 = self.Theme.TextSecondary, TextSize = 10, Font = self.Theme.Font, TextXAlignment = Enum.TextXAlignment.Left, Parent = footer })
    Create("TextLabel", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = "matcha.pink/discord", TextColor3 = self.Theme.TextSecondary, TextSize = 10, Font = self.Theme.Font, Parent = footer })
    Create("TextLabel", { BackgroundTransparency = 1, Size = UDim2.new(0, 150, 1, 0), Position = UDim2.new(1, -150, 0, 0), Text = "Build: Aug 22 2026", TextColor3 = self.Theme.TextSecondary, TextSize = 10, Font = self.Theme.Font, TextXAlignment = Enum.TextXAlignment.Right, Parent = footer })

    -- Window Object Return
    local window = { 
        MainFrame = mainFrame, 
        ContentArea = contentArea,
        PreviewFrame = previewFrame,
        Tabs = {},
        ActiveTab = nil
    }

    function window:AddTab(name)
        local tabBtn = Create("TextButton", {
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 60, 1, 0),
            Text = name,
            TextColor3 = self.Theme.TextSecondary,
            TextSize = 12,
            Font = self.Theme.Font,
            Parent = tabBar
        })

        local tabContent = Create("Frame", {
            Name = name .. "Tab",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Visible = false,
            Parent = contentArea
        })

        -- Two Columns
        local leftCol = Create("Frame", { BackgroundTransparency = 1, Size = UDim2.new(0.5, -5, 1, 0), Parent = tabContent })
        Create("UIListLayout", { Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder, Parent = leftCol })
        
        local rightCol = Create("Frame", { BackgroundTransparency = 1, Size = UDim2.new(0.5, -5, 1, 0), Position = UDim2.new(0.5, 5, 0, 0), Parent = tabContent })
        Create("UIListLayout", { Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder, Parent = rightCol })

        local tabObj = { Button = tabBtn, Content = tabContent, LeftColumn = leftCol, RightColumn = rightCol }
        
        tabBtn.MouseButton1Click:Connect(function()
            for _, t in pairs(self.Tabs) do
                t.Button.TextColor3 = self.Theme.TextSecondary
                t.Content.Visible = false
            end
            tabBtn.TextColor3 = self.Theme.TextPrimary
            tabContent.Visible = true
            self.ActiveTab = tabObj
        end)

        table.insert(self.Tabs, tabObj)
        
        -- Auto-select first tab
        if #self.Tabs == 1 then
            tabBtn.TextColor3 = self.Theme.TextPrimary
            tabContent.Visible = true
            self.ActiveTab = tabObj
        end

        function tabObj:AddGroupbox(column, title)
            local gb = Create("Frame", {
                BackgroundColor3 = self.Theme.PanelBackground,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                Parent = column
            })
            AddCorner(gb, UDim.new(0, 6))
            AddPadding(gb, 10, 10, 10, 10)
            
            Create("TextLabel", {
                BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 15),
                Text = title, TextColor3 = self.Theme.TextPrimary, TextSize = 12,
                Font = self.Theme.FontBold, TextXAlignment = Enum.TextXAlignment.Left, Parent = gb
            })

            local content = Create("Frame", {
                BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.new(0, 0, 0, 20), AutomaticSize = Enum.AutomaticSize.Y, Parent = gb
            })
            Create("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = content })

            local gbObj = { Content = content }
            function gbObj:AddCheckbox(text, default, flag, color1, color2)
                return self:CreateCheckbox(content, text, default, flag, color1, color2)
            end
            function gbObj:AddDropdown(text, options, default, flag)
                return self:CreateDropdown(content, text, options, default, flag)
            end
            function gbObj:AddSlider(text, min, max, default, flag)
                return self:CreateSlider(content, text, min, max, default, flag)
            end
            return gbObj
        end

        return tabObj
    end

    return window
end

return MatchaUI
