-- Example Script to replicate the image
local MatchaUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/your-repo/matcha-ui/main/MatchaUI.lua"))() -- Replace with actual loadstring or paste the library above directly.

local Window = MatchaUI:CreateWindow("Matcha")

-- =========================================================
-- LEFT COLUMN
-- =========================================================

-- ESP Groupbox
local espGroup = Window:AddGroupbox(Window.LeftColumn, "ESP")
espGroup:AddCheckbox("Enabled")
espGroup:AddCheckbox("Team Check")
espGroup:AddCheckbox("Visible Check", false, Color3.fromRGB(90, 150, 255), Color3.fromRGB(255, 90, 90))
espGroup:AddCheckbox("Team Based Color")
espGroup:AddCheckbox("Text Gradient", false, Color3.fromRGB(255, 255, 255))
espGroup:AddCheckbox("Text Background", false, Color3.fromRGB(0, 0, 0))
espGroup:AddCheckbox("Outline", false, Color3.fromRGB(0, 0, 0))
espGroup:AddCheckbox("Glow")
espGroup:AddCheckbox("Self ESP")
espGroup:AddDropdown("Sizing Type", {"Bounding", "Static"}, "Bounding")
espGroup:AddSlider("Render Distance", 0, 1000, 500)

-- Box Groupbox
local boxGroup = Window:AddGroupbox(Window.LeftColumn, "Box")
boxGroup:AddCheckbox("Enabled", true)
boxGroup:AddCheckbox("Fill Box")
boxGroup:AddDropdown("Box Type", {"2D", "3D", "Corner"}, "2D")

-- Name Groupbox
local nameGroup = Window:AddGroupbox(Window.LeftColumn, "Name")
nameGroup:AddCheckbox("Enabled", true)
nameGroup:AddDropdown("Type", {"Name", "Display", "Username"}, "Name")

-- =========================================================
-- RIGHT COLUMN
-- =========================================================

-- Indicators Groupbox
local indGroup = Window:AddGroupbox(Window.RightColumn, "Indicators")
indGroup:AddCheckbox("Distance", true, Color3.fromRGB(255, 255, 255))
indGroup:AddCheckbox("Equipped Item", true, Color3.fromRGB(255, 255, 255))
indGroup:AddCheckbox("Skeleton", true, Color3.fromRGB(255, 255, 255))
indGroup:AddCheckbox("Head Dot", true, Color3.fromRGB(255, 255, 255))
indGroup:AddCheckbox("Head Dot Glow", true, Color3.fromRGB(255, 255, 255))
indGroup:AddCheckbox("Profile Picture", true, Color3.fromRGB(255, 255, 255))

-- Health Groupbox
local healthGroup = Window:AddGroupbox(Window.RightColumn, "Health")
healthGroup:AddCheckbox("Health Bar", true, Color3.fromRGB(90, 255, 90))
healthGroup:AddCheckbox("Health Based")
healthGroup:AddCheckbox("Health Text")
healthGroup:AddDropdown("Text Pos", {"Above Name", "Below Name", "Left", "Right"}, "Above Name")

-- Chams Groupbox
local chamsGroup = Window:AddGroupbox(Window.RightColumn, "Chams")
chamsGroup:AddDropdown("Mode", {"Default", "Wireframe", "Textured"}, "Default")
chamsGroup:AddCheckbox("Enabled", true, Color3.fromRGB(255, 255, 255), Color3.fromRGB(0, 0, 0))
chamsGroup:AddCheckbox("Filled", true, Color3.fromRGB(255, 255, 255), Color3.fromRGB(0, 0, 0))
chamsGroup:AddDropdown("Rendering Type", {"Static", "Dynamic"}, "Static")

-- Tracer Groupbox
local tracerGroup = Window:AddGroupbox(Window.RightColumn, "Tracer")
tracerGroup:AddCheckbox("Enabled")
tracerGroup:AddDropdown("Origin", {"Bottom", "Top", "Mouse"}, "Bottom")

-- =========================================================
-- PREVIEW WINDOW SETUP
-- =========================================================

-- Add tabs to the preview window (ESP, Preview, 3D)
local previewTabs = Create("Frame", {
    Name = "PreviewTabs",
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 0, 25),
    Parent = Window.PreviewFrame
})
AddPadding(previewTabs, 5)

local tabs = {"ESP", "Preview", "3D"}
for i, tabName in ipairs(tabs) do
    local isActive = (tabName == "Preview")
    Create("TextButton", {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 50, 1, 0),
        Position = UDim2.new(0, (i-1) * 55, 0, 0),
        Text = tabName,
        TextColor3 = isActive and MatchaUI.Theme.Text or MatchaUI.Theme.SubText,
        TextSize = 11,
        Font = MatchaUI.Theme.Font,
        Parent = previewTabs
    })
end

-- Add a placeholder image for the avatar preview
Create("ImageLabel", {
    BackgroundTransparency = 1,
    Size = UDim2.new(0.8, 0, 0.8, 0),
    Position = UDim2.new(0.1, 0, 0.15, 0),
    Image = "rbxassetid://0", -- Replace with an actual avatar render asset ID
    ScaleType = Enum.ScaleType.Fit,
    Parent = Window.PreviewFrame
})

print("Matcha UI Loaded Successfully.")
