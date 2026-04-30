-- TOMMY HUB LITE (FUNCIONAL DELTA)

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")

-- ==================== VARIABLES ====================
local ESPEnabled = false
local FPSBoostEnabled = false
local ESPObjects = {}

-- ==================== ESP ====================
local function ClearESP()
    for _, v in pairs(ESPObjects) do
        if v then v:Destroy() end
    end
    ESPObjects = {}
end

local function CreateESP(char)
    if not char:FindFirstChild("Head") then return end

    local bill = Instance.new("BillboardGui")
    bill.Size = UDim2.new(0,100,0,40)
    bill.Adornee = char.Head
    bill.AlwaysOnTop = true
    bill.Parent = char.Head

    local txt = Instance.new("TextLabel", bill)
    txt.Size = UDim2.new(1,0,1,0)
    txt.BackgroundTransparency = 1
    txt.Text = char.Name
    txt.TextColor3 = Color3.new(0,1,1)

    table.insert(ESPObjects, bill)
end

local function UpdateESP()
    ClearESP()
    if not ESPEnabled then return end

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= Players.LocalPlayer and p.Character then
            CreateESP(p.Character)
        end
    end
end

-- ==================== FPS BOOST ====================
local function ApplyFPSBoost()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Material = Enum.Material.SmoothPlastic
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v.Transparency = 1
        elseif v:IsA("ParticleEmitter") then
            v.Enabled = false
        end
    end

    Lighting.GlobalShadows = false
end

local function RemoveFPSBoost()
    Lighting.GlobalShadows = true
end

-- ==================== GUI ====================
local gui = Instance.new("ScreenGui", Players.LocalPlayer.PlayerGui)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,300,0,200)
frame.Position = UDim2.new(0.5,-150,0.5,-100)
frame.BackgroundColor3 = Color3.fromRGB(20,20,30)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,40)
title.Text = "TOMMY HUB"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1

-- ESP BUTTON
local espBtn = Instance.new("TextButton", frame)
espBtn.Size = UDim2.new(0.8,0,0,40)
espBtn.Position = UDim2.new(0.1,0,0.3,0)
espBtn.Text = "ESP OFF"

espBtn.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    espBtn.Text = ESPEnabled and "ESP ON" or "ESP OFF"
    UpdateESP()
end)

-- FPS BUTTON
local fpsBtn = Instance.new("TextButton", frame)
fpsBtn.Size = UDim2.new(0.8,0,0,40)
fpsBtn.Position = UDim2.new(0.1,0,0.6,0)
fpsBtn.Text = "FPS BOOST OFF"

fpsBtn.MouseButton1Click:Connect(function()
    FPSBoostEnabled = not FPSBoostEnabled
    fpsBtn.Text = FPSBoostEnabled and "FPS BOOST ON" or "FPS BOOST OFF"

    if FPSBoostEnabled then
        ApplyFPSBoost()
    else
        RemoveFPSBoost()
    end
end)

print("✅ HUB FUNCIONANDO")
