-- Matcha UI Library
-- Replicates the UI design from the provided image
-- Author: AI Assistant
-- Environment: Roblox (ScreenGui based)

local MatchaUI = {}
MatchaUI.__index = MatchaUI

-- =========================================================
-- THEME CONFIGURATION
-- =========================================================
MatchaUI.Theme = {
    Background = Color3.fromRGB(20, 20, 24),
    Main = Color3.fromRGB(28, 28, 34),
    Groupbox = Color3.fromRGB(36, 36, 43),
    Element = Color3.fromRGB(45, 45, 54),
    ElementHover = Color3.fromRGB(55, 55, 65),
    Text = Color3.fromRGB(230, 230, 235),
    SubText = Color3.fromRGB(150, 150, 160),
    Accent = Color3.fromRGB(90, 150, 255),
    Red = Color3.fromRGB(255, 90, 90),
    Green = Color3.fromRGB(90, 255, 90),
    White = Color3.fromRGB(255, 255, 255),
    Black = Color3.fromRGB(0, 0, 0),
    Font = Enum.Font.GothamMedium,
    FontBold = Enum.Font.GothamBold,
    CornerRadius = UDim.new(0, 6),
    Padding = 10,
    ElementHeight = 24
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
    return Create("UICorner", {CornerRadius = radius or MatchaUI.Theme.CornerRadius, Parent = parent})
end

local function AddPadding(parent, padding)
    return Create("UIPadding", {
        PaddingTop = UDim.new(0, padding),
        PaddingBottom = UDim.new(0, padding),
        PaddingLeft = UDim.new(0, padding),
        PaddingRight = UDim.new(0, padding),
        Parent = parent
    })
end

local function AddStroke(parent, color, thickness)
    return Create("UIStroke", {
        Color = color or MatchaUI.Theme.Background,
        Thickness = thickness or 1,
        Parent = parent
    })
end

-- =========================================================
-- COMPONENT CREATION
-- =========================================================

-- Checkbox Component
function MatchaUI:CreateCheckbox(parent, text, default, color1, color2)
    local container = Create("Frame", {
        Name = text .. "Checkbox",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, MatchaUI.Theme.ElementHeight),
        Parent = parent
    })

    local box = Create("Frame", {
        Name = "Box",
        BackgroundColor3 = MatchaUI.Theme.Element,
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0, 0, 0.5, -8),
        Parent = container
    })
    AddCorner(box, UDim.new(0, 4))
    AddStroke(box, MatchaUI.Theme.Background)

    local check = Create("Frame", {
        Name = "Check",
        BackgroundColor3 = MatchaUI.Theme.Accent,
        Size = UDim2.new(0, 10, 0, 10),
        Position = UDim2.new(0.5, -5, 0.5, -5),
        Visible = default,
        Parent = box
    })
    AddCorner(check, UDim.new(0, 2))

    local label = Create("TextLabel", {
        Name = "Label",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -30, 1, 0),
        Position = UDim2.new(0, 24, 0, 0),
        Text = text,
        TextColor3 = MatchaUI.Theme.Text,
        TextSize = 12,
        Font = MatchaUI.Theme.Font,
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
        if self.OnChanged then self.OnChanged(state) end
    end)

    -- Optional Color Pickers
    if color1 then
        local c1 = Create("Frame", {
            BackgroundColor3 = color1,
            Size = UDim2.new(0, 16, 0, 16),
            Position = UDim2.new(1, -40, 0.5, -8),
            Parent = container
        })
        AddCorner(c1, UDim.new(0, 4))
        AddStroke(c1, MatchaUI.Theme.Background)
    end
    if color2 then
        local c2 = Create("Frame", {
            BackgroundColor3 = color2,
            Size = UDim2.new(0, 16, 0, 16),
            Position = UDim2.new(1, -20, 0.5, -8),
            Parent = container
        })
        AddCorner(c2, UDim.new(0, 4))
        AddStroke(c2, MatchaUI.Theme.Background)
    end

    return container
end

-- Dropdown Component
function MatchaUI:CreateDropdown(parent, text, options, default)
    local container = Create("Frame", {
        Name = text .. "Dropdown",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 45),
        Parent = parent
    })

    local label = Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 15),
        Text = text,
        TextColor3 = MatchaUI.Theme.SubText,
        TextSize = 11,
        Font = MatchaUI.Theme.Font,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = container
    })

    local dropbox = Create("Frame", {
        BackgroundColor3 = MatchaUI.Theme.Element,
        Size = UDim2.new(1, 0, 0, 25),
        Position = UDim2.new(0, 0, 0, 18),
        Parent = container
    })
    AddCorner(dropbox, UDim.new(0, 4))

    local selectedText = Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 8, 0, 0),
        Text = default,
        TextColor3 = MatchaUI.Theme.Text,
        TextSize = 12,
        Font = MatchaUI.Theme.Font,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = dropbox
    })

    local arrow = Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 20, 1, 0),
        Position = UDim2.new(1, -20, 0, 0),
        Text = "v",
        TextColor3 = MatchaUI.Theme.SubText,
        TextSize = 12,
        Font = MatchaUI.Theme.Font,
        Parent = dropbox
    })

    local button = Create("TextButton", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = "",
        Parent = dropbox
    })

    -- Simple dropdown logic (in a real library, this would spawn a scrolling frame)
    local isOpen = false
    button.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        -- Placeholder for dropdown options logic
        if isOpen then
            arrow.Text = "^"
        else
            arrow.Text = "v"
        end
    end)

    return container
end

-- Slider Component
function MatchaUI:CreateSlider(parent, text, min, max, default)
    local container = Create("Frame", {
        Name = text .. "Slider",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 35),
        Parent = parent
    })

    local label = Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -40, 0, 15),
        Text = text,
        TextColor3 = MatchaUI.Theme.SubText,
        TextSize = 11,
        Font = MatchaUI.Theme.Font,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = container
    })

    local valueLabel = Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 40, 0, 15),
        Position = UDim2.new(1, -40, 0, 0),
        Text = tostring(default),
        TextColor3 = MatchaUI.Theme.Text,
        TextSize = 11,
        Font = MatchaUI.Theme.Font,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = container
    })

    local sliderBg = Create("Frame", {
        BackgroundColor3 = MatchaUI.Theme.Element,
        Size = UDim2.new(1, 0, 0, 6),
        Position = UDim2.new(0, 0, 0, 22),
        Parent = container
    })
    AddCorner(sliderBg, UDim.new(0, 3))

    local fill = Create("Frame", {
        BackgroundColor3 = MatchaUI.Theme.Accent,
        Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
        Parent = sliderBg
    })
    AddCorner(fill, UDim.new(0, 3))

    local knob = Create("Frame", {
        BackgroundColor3 = MatchaUI.Theme.White,
        Size = UDim2.new(0, 12, 0, 12),
        Position = UDim2.new(fill.Size.X.Scale, -6, 0.5, -6),
        Parent = sliderBg
    })
    AddCorner(knob, UDim.new(1, 0))

    -- Dragging logic would go here (MouseButton1Down, MouseMoved, etc.)
    -- Omitted for brevity, but standard Roblox slider logic applies.
    return container
end

-- =========================================================
-- WINDOW & TABS
-- =========================================================

function MatchaUI:CreateWindow(title)
    local screenGui = Create("ScreenGui", {
        Name = "MatchaUI",
        ResetOnSpawn = false,
        Parent = game:GetService("CoreGui")
    })

    local mainFrame = Create("Frame", {
        Name = "MainFrame",
        BackgroundColor3 = MatchaUI.Theme.Main,
        Size = UDim2.new(0, 700, 0, 500),
        Position = UDim2.new(0.5, -350, 0.5, -250),
        Parent = screenGui
    })
    AddCorner(mainFrame, UDim.new(0, 8))
    AddStroke(mainFrame, MatchaUI.Theme.Background, 1)

    -- Top Bar (Matcha, Interface, Standard, Dejected)
    local topBar = Create("Frame", {
        Name = "TopBar",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 30),
        Parent = mainFrame
    })
    AddPadding(topBar, 10)

    Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 50, 1, 0),
        Text = title,
        TextColor3 = MatchaUI.Theme.Text,
        TextSize = 12,
        Font = MatchaUI.Theme.FontBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = topBar
    })
    
    local interfaceBtn = Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 60, 1, 0),
        Position = UDim2.new(0, 60, 0, 0),
        Text = "Interface",
        TextColor3 = MatchaUI.Theme.SubText,
        TextSize = 12,
        Font = MatchaUI.Theme.Font,
        Parent = topBar
    })

    -- Tab Bar (Combat, Visuals, World, etc.)
    local tabBar = Create("Frame", {
        Name = "TabBar",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0, 30),
        Parent = mainFrame
    })
    AddPadding(tabBar, 10)

    local tabs = {"Combat", "Visuals", "World", "Character", "Options", "Configs", "NPC", "Teams"}
    local tabButtons = {}
    local currentTab = "Visuals"

    for i, tabName in ipairs(tabs) do
        local tabBtn = Create("TextButton", {
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 60, 1, 0),
            Position = UDim2.new(0, (i-1) * 65, 0, 0),
            Text = tabName,
            TextColor3 = (tabName == currentTab) and MatchaUI.Theme.Text or MatchaUI.Theme.SubText,
            TextSize = 12,
            Font = MatchaUI.Theme.Font,
            Parent = tabBar
        })
        table.insert(tabButtons, tabBtn)
        
        tabBtn.MouseButton1Click:Connect(function()
            currentTab = tabName
            for _, btn in ipairs(tabButtons) do
                btn.TextColor3 = (btn.Text == currentTab) and MatchaUI.Theme.Text or MatchaUI.Theme.SubText
            end
            -- Logic to swap tab content would go here
        end)
    end

    -- Content Area
    local contentArea = Create("Frame", {
        Name = "ContentArea",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 1, -100),
        Position = UDim2.new(0, 10, 0, 70),
        Parent = mainFrame
    })

    -- Two Columns for Groupboxes
    local leftColumn = Create("Frame", {
        Name = "LeftColumn",
        BackgroundTransparency = 1,
        Size = UDim2.new(0.5, -5, 1, 0),
        Parent = contentArea
    })
    local leftLayout = Create("UIListLayout", {
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = leftColumn
    })

    local rightColumn = Create("Frame", {
        Name = "RightColumn",
        BackgroundTransparency = 1,
        Size = UDim2.new(0.5, -5, 1, 0),
        Position = UDim2.new(0.5, 5, 0, 0),
        Parent = contentArea
    })
    local rightLayout = Create("UIListLayout", {
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = rightColumn
    })

    -- Preview Area (Right side panel)
    local previewFrame = Create("Frame", {
        Name = "PreviewFrame",
        BackgroundColor3 = MatchaUI.Theme.Main,
        Size = UDim2.new(0, 200, 0, 300),
        Position = UDim2.new(1, 20, 0, 70),
        Parent = mainFrame
    })
    AddCorner(previewFrame, UDim.new(0, 8))
    AddStroke(previewFrame, MatchaUI.Theme.Background)

    -- Bottom Bar
    local bottomBar = Create("Frame", {
        Name = "BottomBar",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 0, 20),
        Position = UDim2.new(0, 10, 1, -30),
        Parent = mainFrame
    })
    
    Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 100, 1, 0),
        Text = "67M online",
        TextColor3 = MatchaUI.Theme.SubText,
        TextSize = 10,
        Font = MatchaUI.Theme.Font,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = bottomBar
    })
    
    Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = "matcha.pink/discord",
        TextColor3 = MatchaUI.Theme.SubText,
        TextSize = 10,
        Font = MatchaUI.Theme.Font,
        Parent = bottomBar
    })

    Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 150, 1, 0),
        Position = UDim2.new(1, -150, 0, 0),
        Text = "Build: Aug 22 2026",
        TextColor3 = MatchaUI.Theme.SubText,
        TextSize = 10,
        Font = MatchaUI.Theme.Font,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = bottomBar
    })

    -- Return the window object to allow adding groupboxes
    local window = {
        MainFrame = mainFrame,
        LeftColumn = leftColumn,
        RightColumn = rightColumn,
        PreviewFrame = previewFrame,
        Groupboxes = {}
    }

    function window:AddGroupbox(column, title)
        local gb = Create("Frame", {
            Name = title .. "Groupbox",
            BackgroundColor3 = MatchaUI.Theme.Groupbox,
            Size = UDim2.new(1, 0, 0, 40), -- Height will be auto-adjusted by UIListLayout
            AutomaticSize = Enum.AutomaticSize.Y,
            Parent = column
        })
        AddCorner(gb, UDim.new(0, 6))
        
        local gbPadding = AddPadding(gb, 10)
        
        local gbTitle = Create("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 15),
            Text = title,
            TextColor3 = MatchaUI.Theme.Text,
            TextSize = 12,
            Font = MatchaUI.Theme.FontBold,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = gb
        })

        local contentFrame = Create("Frame", {
            Name = "Content",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0),
            Position = UDim2.new(0, 0, 0, 20),
            AutomaticSize = Enum.AutomaticSize.Y,
            Parent = gb
        })
        
        local contentLayout = Create("UIListLayout", {
            Padding = UDim.new(0, 5),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = contentFrame
        })

        local gbObj = {
            Frame = gb,
            Content = contentFrame
        }
        
        function gbObj:AddCheckbox(text, default, color1, color2)
            return MatchaUI:CreateCheckbox(self.Content, text, default, color1, color2)
        end
        
        function gbObj:AddDropdown(text, options, default)
            return MatchaUI:CreateDropdown(self.Content, text, options, default)
        end
        
        function gbObj:AddSlider(text, min, max, default)
            return MatchaUI:CreateSlider(self.Content, text, min, max, default)
        end

        table.insert(self.Groupboxes, gbObj)
        return gbObj
    end

    return window
end

return MatchaUI
