-- FireHub - Advanced Blox Fruits Script
-- Theme: Red & Black
-- Features: Floating Toggle, Combat, Movement, Utility, Teleportation

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- Player
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

-- == GUI CREATION ==

-- Main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FireHub"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

-- Floating Toggle Button
local ToggleButton = Instance.new("ImageButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ScreenGui
ToggleButton.Size = UDim2.new(0, 60, 0, 60)
ToggleButton.Position = UDim2.new(0, 10, 0, 10)
ToggleButton.BackgroundTransparency = 1
ToggleButton.Image = "https://i.imgur.com/hV5UQBo.png"
ToggleButton.Draggable = true

-- Main GUI (Initially Hidden)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.Visible = false
MainFrame.Size = UDim2.new(0, 650, 0, 500)
MainFrame.Position = UDim2.new(0.5, -325, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleBarCorner = Instance.new("UICorner")
TitleBarCorner.CornerRadius = UDim.new(0, 12)
TitleBarCorner.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "FireHub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = TitleBar

-- Tab Buttons
local TabFrame = Instance.new("Frame")
TabFrame.Size = UDim2.new(1, 0, 0, 40)
TabFrame.Position = UDim2.new(0, 0, 0, 45)
TabFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TabFrame.BorderSizePixel = 0
TabFrame.Parent = MainFrame

local function createTabButton(text, position)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 1, 0)
    btn.Position = position
    btn.BackgroundTransparency = 1
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    btn.Font = Enum.Font.Gotham
    btn.TextScaled = true
    btn.Parent = TabFrame
    return btn
end

local CombatTab = createTabButton("Combat", UDim2.new(0, 10, 0, 0))
local MovementTab = createTabButton("Movement", UDim2.new(0, 120, 0, 0))
local UtilityTab = createTabButton("Utility", UDim2.new(0, 230, 0, 0))
local TeleportTab = createTabButton("Teleport", UDim2.new(0, 340, 0, 0))

-- Content Frames (one for each tab)
local function createContentFrame(name)
    local frame = Instance.new("ScrollingFrame")
    frame.Name = name
    frame.Size = UDim2.new(1, -20, 1, -95)
    frame.Position = UDim2.new(0, 10, 0, 95)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BorderSizePixel = 0
    frame.Visible = false
    frame.ScrollBarThickness = 8
    frame.Parent = MainFrame
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 10)
    list.Parent = frame
    return frame
end
local CombatContent = createContentFrame("CombatContent")
local MovementContent = createContentFrame("MovementContent")
local UtilityContent = createContentFrame("UtilityContent")
local TeleportContent = createContentFrame("TeleportContent")

-- Button Creation Function for content
local function createFeatureButton(text, parent)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextScaled = true
    btn.Parent = parent
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    return btn
end

-- == CREATE FEATURE BUTTONS ==

-- Combat Tab
local AutoFarmBtn = createFeatureButton("Auto Farm: OFF", CombatContent)
local FastAttackBtn = createFeatureButton("Fast Attack: ON", CombatContent)
local BringFruitsBtn = createFeatureButton("Bring Fruits: ON", CombatContent)

-- Movement Tab
local NoClipBtn = createFeatureButton("No Clip: OFF", MovementContent)
local FlyBtn = createFeatureButton("Fly: OFF", MovementContent)
local WalkSpeedBtn = createFeatureButton("WalkSpeed: [Slider]", MovementContent)
local JumpPowerBtn = createFeatureButton("JumpPower: [Slider]", MovementContent)

-- Utility Tab
local QuestFarmBtn = createFeatureButton("Quest Farm: OFF", UtilityContent)
local PlayerESPBtn = createFeatureButton("Player ESP: OFF", UtilityContent)
local ItemESPBtn = createFeatureButton("Item ESP: OFF", UtilityContent)

-- Teleport Tab
local IslandDropdown = Instance.new("TextButton")
IslandDropdown.Size = UDim2.new(1, 0, 0, 35)
IslandDropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
IslandDropdown.BorderSizePixel = 0
IslandDropdown.Text = "Select Island..."
IslandDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
IslandDropdown.Font = Enum.Font.Gotham
IslandDropdown.TextScaled = true
IslandDropdown.Parent = TeleportContent
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 6)
corner.Parent = IslandDropdown

-- == TOGGLE LOGIC ==
local guiOpen = false
ToggleButton.MouseButton1Click:Connect(function()
    guiOpen = not guiOpen
    MainFrame.Visible = guiOpen
end)

-- == TAB LOGIC ==
local activeTab = CombatTab
local activeContent = CombatContent

local function switchTab(tab, content)
    activeTab.TextColor3 = Color3.fromRGB(180, 180, 180)
    activeContent.Visible = false
    tab.TextColor3 = Color3.fromRGB(255, 255, 255)
    content.Visible = true
   