local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

local Target = nil
local AimbotEnabled = false
local EspEnabled = false

-- إنشاء الواجهة البرمجية (CARTEL HUB)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CartelUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 180)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -90)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = MainFrame

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(255, 0, 0)
Stroke.Thickness = 1.5
Stroke.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundTransparency = 1
Title.Text = "CARTEL HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- زر التثبيت والتتبع (Aimbot)
local AimbotBtn = Instance.new("TextButton")
AimbotBtn.Size = UDim2.new(0.85, 0, 0, 32)
AimbotBtn.Position = UDim2.new(0.075, 0, 0.25, 0)
AimbotBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
AimbotBtn.Text = "التثبيت والتتبع: إيقاف"
AimbotBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
AimbotBtn.TextSize = 12
AimbotBtn.Font = Enum.Font.GothamMedium
AimbotBtn.Parent = MainFrame

local AimbotCorner = Instance.new("UICorner")
AimbotCorner.CornerRadius = UDim.new(0, 6)
AimbotCorner.Parent = AimbotBtn

-- زر كشف اللاعبين (ESP)
local EspBtn = Instance.new("TextButton")
EspBtn.Size = UDim2.new(0.85, 0, 0, 32)
EspBtn.Position = UDim2.new(0.075, 0, 0.48, 0)
EspBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
EspBtn.Text = "كشف اللاعبين (ESP): إيقاف"
EspBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
EspBtn.TextSize = 12
EspBtn.Font = Enum.Font.GothamMedium
EspBtn.Parent = MainFrame

local EspCorner = Instance.new("UICorner")
EspCorner.CornerRadius = UDim.new(0, 6)
EspCorner.Parent = EspBtn

-- أحداث الأزرار
AimbotBtn.MouseButton1Click:Connect(function()
    AimbotEnabled = not AimbotEnabled
    if AimbotEnabled then
        AimbotBtn.Text = "التثبيت والتتبع: تشغيل"
        AimbotBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        AimbotBtn.Text = "التثبيت والتتبع: إيقاف"
        AimbotBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
        Target = nil
    end
end)

EspBtn.MouseButton1Click:Connect(function()
    EspEnabled = not EspEnabled
    if EspEnabled then
        EspBtn.Text = "كشف اللاعبين (ESP): تشغيل"
        EspBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        EspBtn.Text = "كشف اللاعبين (ESP): إيقاف"
        EspBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

-- وظيفة البحث عن أقرب لاعب
local function GetClosestPlayer()
    local ClosestDistance = math.huge
    local ClosestPlayer = nil
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChildOfClass("Humanoid") and player.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
            local RootPart = player.Character.HumanoidRootPart
            local ScreenPos, OnScreen = Camera:WorldToViewportPoint(RootPart.Position)
            if OnScreen then
                local MouseDistance = (Vector2.new(ScreenPos.X, ScreenPos.Y) - Camera.ViewportSize / 2).Magnitude
                if MouseDistance < ClosestDistance then
                    ClosestDistance = MouseDistance
                    ClosestPlayer = player
                end
            end
        end
    end
    return ClosestPlayer
end

-- التحديث المستمر (RenderStepped)
RunService.RenderStepped:Connect(function()
    if AimbotEnabled then
        if not Target or not Target.Character or not Target.Character:FindFirstChild("HumanoidRootPart") or Target.Character:FindFirstChildOfClass("Humanoid").Health <= 0 then
            Target = GetClosestPlayer()
        end
        if Target and Target.Character and Target.Character:FindFirstChild("Head") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Target.Character.Head.Position)
        end
    end

    if EspEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and not player.Character:FindFirstChild("Highlight") then
                local Highlight = Instance.new("Highlight")
                Highlight.Name = "Highlight"
                Highlight.FillColor = Color3.fromRGB(255, 0, 0)
                Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                Highlight.FillTransparency = 0.5
                Highlight.OutlineTransparency = 0
                Highlight.Adornee = player.Character
                Highlight.Parent = player.Character
            end
        end
    else
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("Highlight") then
                player.Character.Highlight:Destroy()
            end
        end
    end
end)
