-- Nexus Hub for Blox Fruits
-- A modern, feature-rich script hub

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")

-- Player
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- GUI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 550, 0, 400)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Corner for rounded edges
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Nexus Hub"
Title.TextColor3 = Color3.fromRGB(100, 200, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Button Creation Function
local function createButton(text, position)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 200, 0, 40)
    btn.Position = position
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextScaled = true
    btn.Parent = MainFrame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn

    -- Hover effect
    local hoverTween = TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(65, 65, 75)})
    local normalTween = TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 55)})

    btn.MouseEnter:Connect(function() hoverTween:Play() end)
    btn.MouseLeave:Connect(function() normalTween:Play() end)

    return btn
end

-- Create Buttons
local AutoFarmBtn = createButton("Auto Farm: OFF", UDim2.new(0, 30, 0, 80))
local FastAttackBtn = createButton("Fast Attack: OFF", UDim2.new(0, 30, 0, 140))
local BringFruitsBtn = createButton("Bring Fruits: ON", UDim2.new(0, 320, 0, 80))
local QuestFarmBtn = createButton("Quest Farm: OFF", UDim2.new(0, 320, 0, 140))


-- Toggle Variables
_G.AutoFarm = false
_G.FastAttack = false
_G.BringFruits = true
_G.QuestFarm = false


-- == FUNCTIONS ==

-- Find Nearest Enemy
local function getNearestEnemy()
    local MaxDistance = 300
    local Nearest = nil
    for _, v in ipairs(workspace.Enemies:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            local Dist = (HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
            if Dist < MaxDistance then
                MaxDistance = Dist
                Nearest = v
            end
        end
    end
    return Nearest
end

-- Auto Farm Loop
spawn(function()
    while wait() do
        if _G.AutoFarm then
            local Enemy = getNearestEnemy()
            if Enemy and Enemy.HumanoidRootPart then
                -- Teleport to enemy
                HumanoidRootPart.CFrame = Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
                -- Attack
                VirtualUser:CaptureController()
                VirtualUser:Button1Down(Vector2.new(0,0))
                wait(0.1)
                VirtualUser:Button1Up(Vector2.new(0,0))
            end
        end
    end
end)

-- Fast Attack
spawn(function()
    while wait() do
        if _G.FastAttack then
            local Combat = require(Player.PlayerScripts.CombatFramework)
            local activeController = Combat.activeController
            if activeController then
                activeController.hitboxMagnitude = 50 -- Increase hitbox size
                activeController.timeToNextAttack = 0 -- Remove cooldown
            end
        end
    end
end)

-- Bring Fruits
spawn(function()
    while wait(1) do
        if _G.BringFruits then
            for _, v in ipairs(workspace:GetChildren()) do
                if v:IsA("Tool") then
                    local Handle = v:FindFirstChild("Handle")
                    if Handle and Handle:FindFirstChild("TouchInterest") then
                        Handle.CFrame = HumanoidRootPart.CFrame
                    end
                end
            end
        end
    end
end)

-- Quest Farm
spawn(function()
    while wait() do
        if _G.QuestFarm then
            -- Simplified Quest Farm: Finds and accepts quest from nearest NPC
            for _, v in ipairs(workspace:GetChildren()) do
                if string.find(v.Name, "QuestGiver") then
                    HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame
                    wait(1.5) -- Wait for dialogue
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AcceptQuest")
                    break
                end
            end
        end
    end
end)


-- == BUTTON LOGIC ==

-- Auto Farm Button
AutoFarmBtn.MouseButton1Click:Connect(function()
    _G.AutoFarm = not _G.AutoFarm
    if _G.AutoFarm then
        AutoFarmBtn.Text = "Auto Farm: ON"
        AutoFarmBtn.BackgroundColor3 = Color3.fromRGB(25, 150, 25)
    else
        AutoFarmBtn.Text = "Auto Farm: OFF"
        AutoFarmBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    end
end)

-- Fast Attack Button
FastAttackBtn.MouseButton1Click:Connect(function()
    _G.FastAttack = not _G.FastAttack
    if _G.FastAttack then
        FastAttackBtn.Text = "Fast Attack: ON"
        FastAttackBtn.BackgroundColor3 = Color3.fromRGB(25, 150, 25)
    else
        FastAttackBtn.Text = "Fast Attack: OFF"
        FastAttackBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    end
end)

-- Bring Fruits Button
BringFruitsBtn.MouseButton1Click:Connect(function()
    _G.BringFruits = not _G.BringFruits
    if _G.BringFruits then
        BringFruitsBtn.Text = "Bring Fruits: ON"
        BringFruitsBtn.BackgroundColor3 = Color3.fromRGB(25, 150, 25)
    else
        BringFruitsBtn.Text = "Bring Fruits: OFF"
        BringFruitsBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    end
end)

-- Quest Farm Button
QuestFarmBtn.MouseButton1Click:Connect(function()
    _G.QuestFarm = not _G.QuestFarm
    if _G.QuestFarm then
        QuestFarmBtn.Text = "Quest Farm: ON"
        QuestFarmBtn.BackgroundColor3 = Color3.fromRGB(25, 150, 25)
    else
        QuestFarmBtn.Text = "Quest Farm: OFF"
        QuestFarmBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    end
end