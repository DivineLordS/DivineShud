-- TOMMY HUB PREMIUM | VISUALS + FPS BOOST PRO

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

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
        elseif v:IsA("Explosion") then
            v.BlastPressure = 1
            v.BlastRadius = 1
        end
    end

    -- Lighting optimization
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.Brightness = 1

    -- Terrain optimization
    if workspace:FindFirstChildOfClass("Terrain") then
        local t = workspace:FindFirstChildOfClass("Terrain")
        t.WaterWaveSize = 0
        t.WaterWaveSpeed = 0
        t.WaterReflectance = 0
        t.WaterTransparency = 1
    end
end

local function RemoveFPSBoost()
    Lighting.GlobalShadows = true
end

-- ==================== GUI ====================
local pgui = Players.LocalPlayer:WaitForChild("PlayerGui")

if pgui:FindFirstChild("TommyHub") then
    pgui.TommyHub:Destroy()
end

local gui = Instance.new("ScreenGui", pgui)
gui.Name = "TommyHub"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 420, 0, 350)
main.Position = UDim2.new(0.5, -210, 0.2, 0)
main.BackgroundColor3 = Color3.fromRGB(20,20,30)
main.Active = true
main.Draggable = true

-- Tabs
local tabFrame = Instance.new("Frame", main)
tabFrame.Size = UDim2.new(1,0,0,40)
tabFrame.BackgroundTransparency = 1

local content = Instance.new("Frame", main)
content.Size = UDim2.new(1,0,1,-40)
content.Position = UDim2.new(0,0,0,40)
content.BackgroundTransparency = 1

local function createPage()
    local p = Instance.new("Frame", content)
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
    local btn = Instance.new("TextButton", tabFrame)
    btn.Size = UDim2.new(0,150,1,0)
    btn.Position = pos
    btn.Text = text
    btn.MouseButton1Click:Connect(function()
        showPage(page)
    end)
end

createTab("⚔️ Combat", combatPage, UDim2.new(0,0,0,0))
createTab("👁️ Visuals", visualPage, UDim2.new(0,150,0,0))

showPage(combatPage)

local function addBtn(text, parent, y)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.8,0,0,40)
    btn.Position = UDim2.new(0.1,0,0,y)
    btn.Text = text
    return btn
end

-- ==================== VISUALS ====================
local fpsBtn = addBtn("🎮 FPS BOOST: OFF", visualPage, 20)

fpsBtn.MouseButton1Click:Connect(function()
    FPSBoostEnabled = not FPSBoostEnabled
    fpsBtn.Text = FPSBoostEnabled and "🎮 FPS BOOST: ON" or "🎮 FPS BOOST: OFF"

    if FPSBoostEnabled then
        ApplyFPSBoost()
    else
        RemoveFPSBoost()
    end
end)

print("✅ HUB CON FPS BOOST PRO LISTO")
