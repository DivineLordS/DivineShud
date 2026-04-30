-- TOMMY HUB PREMIUM | FIX + VISUALES

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

-- ==================== ESP ====================
local ESPEnabled = false
local ESPObjects = {}

local function CreateESP(target)
    if not target:FindFirstChild("Head") then return end
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "TommyESP"
    billboard.Adornee = target.Head
    billboard.Size = UDim2.new(0, 100, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = target.Head

    local label = Instance.new("TextLabel", billboard)
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Text = target.Name
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.TextColor3 = Color3.new(0, 1, 1)
    label.TextStrokeTransparency = 0

    table.insert(ESPObjects, billboard)
end

local function ClearESP()
    for _, obj in pairs(ESPObjects) do
        if obj then obj:Destroy() end
    end
    ESPObjects = {}
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
local FPSBoostEnabled = false

local function ApplyFPSBoost()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Material = Enum.Material.SmoothPlastic
            v.Reflectance = 0
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v.Transparency = 1
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Enabled = false
        end
    end

    Lighting.GlobalShadows = false
    Lighting.Brightness = 1
end

local function RemoveFPSBoost()
    Lighting.GlobalShadows = true
end

-- ==================== GUI ====================
local pgui = Players.LocalPlayer:WaitForChild("PlayerGui")
if pgui:FindFirstChild("TommyHub_Premium") then
    pgui.TommyHub_Premium:Destroy()
end

local screenGui = Instance.new("ScreenGui", pgui)
screenGui.Name = "TommyHub_Premium"

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 420, 0, 400)
mainFrame.Position = UDim2.new(0.5, -210, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20,20,35)
mainFrame.Active = true
mainFrame.Draggable = true

local tabContainer = Instance.new("Frame", mainFrame)
tabContainer.Size = UDim2.new(1,0,0,40)
tabContainer.BackgroundTransparency = 1

local contentFrame = Instance.new("Frame", mainFrame)
contentFrame.Size = UDim2.new(1,0,1,-40)
contentFrame.Position = UDim2.new(0,0,0,40)
contentFrame.BackgroundTransparency = 1

local function createPage()
    local p = Instance.new("Frame", contentFrame)
    p.Size = UDim2.new(1,0,1,0)
    p.Visible = false
    return p
end

local combatPage = createPage()
local visualPage = createPage()

local function showPage(p)
    combatPage.Visible = false
    visualPage.Visible = false
    p.Visible = true
end

local function createTab(text, page, pos)
    local btn = Instance.new("TextButton", tabContainer)
    btn.Size = UDim2.new(0,120,1,0)
    btn.Position = pos
    btn.Text = text
    btn.MouseButton1Click:Connect(function()
        showPage(page)
    end)
end

createTab("⚔️ Combate", combatPage, UDim2.new(0,0,0,0))
createTab("👁️ Visuales", visualPage, UDim2.new(0,130,0,0))

showPage(combatPage)

local function addBtn(txt, parent, y)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.8,0,0,40)
    btn.Position = UDim2.new(0.1,0,0,y)
    btn.Text = txt
    return btn
end

-- COMBAT
local espBtn = addBtn("ESP OFF", combatPage, 20)
espBtn.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    espBtn.Text = ESPEnabled and "ESP ON" or "ESP OFF"
    UpdateESP()
end)

-- VISUALES
local fpsBtn = addBtn("FPS BOOST OFF", visualPage, 20)
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
