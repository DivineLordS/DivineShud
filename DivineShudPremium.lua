-- TOMMY HUB PREMIUM | loadstring ready
-- Subir a GitHub como archivo raw y usar:
-- loadstring(game:HttpGet("URL_RAW_AQUI"))()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ==================== ESP ====================
local ESPEnabled = false
local ESPObjects = {}

local function CreateESP(target)
    if not target:FindFirstChild("Head") then return end
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "TommyESP"
    billboard.Adornee = target:FindFirstChild("Head")
    billboard.Size = UDim2.new(0, 100, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = target:FindFirstChild("Head")
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Text = target.Name
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.TextColor3 = Color3.new(0, 1, 1)
    label.TextStrokeTransparency = 0
    label.Parent = billboard
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
    local enemies = workspace:FindFirstChild("Enemies")
    if enemies then
        for _, npc in pairs(enemies:GetChildren()) do
            CreateESP(npc)
        end
    end
end

-- ==================== FPS BOOST ====================
local FPSBoostEnabled = false

local function ApplyFPSBoost()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Material = Enum.Material.Plastic
            v.Reflectance = 0
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v.Transparency = 1
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Enabled = false
        end
    end

    local Lighting = game:GetService("Lighting")
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9

    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

    workspace.Terrain.WaterWaveSize = 0
    workspace.Terrain.WaterWaveSpeed = 0
    workspace.Terrain.WaterReflectance = 0
    workspace.Terrain.WaterTransparency = 0
end

local function RemoveFPSBoost()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
end

-- ==================== FAST ATTACK ====================
local FastAttackEnabled = false
local FastAttackRange = 5000
local FastAttackConnection = nil

local Net = ReplicatedStorage:WaitForChild("Modules", 5) and
            ReplicatedStorage.Modules:WaitForChild("Net", 5)
local RegisterHit = Net and pcall(function() return Net["RE/RegisterHit"] end) and Net["RE/RegisterHit"]
local RegisterAttack = Net and pcall(function() return Net["RE/RegisterAttack"] end) and Net["RE/RegisterAttack"]

local function AttackMultipleTargets(targets)
    if not RegisterHit or not RegisterAttack then return end
    pcall(function()
        if not targets or #targets == 0 then return end
        local allTargets = {}
        for _, char in pairs(targets) do
            local head = char:FindFirstChild("Head")
            if head then table.insert(allTargets, {char, head}) end
        end
        if #allTargets == 0 then return end
        RegisterAttack:FireServer(0)
        RegisterHit:FireServer(allTargets[1][2], allTargets)
    end)
end

local function StartFastAttack()
    if FastAttackConnection then task.cancel(FastAttackConnection) end
    FastAttackConnection = task.spawn(function()
        while FastAttackEnabled do
            RunService.Stepped:Wait()
            local myChar = Players.LocalPlayer.Character
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if not myHRP then continue end
            local targets = {}
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= Players.LocalPlayer and player.Character then
                    local hum = player.Character:FindFirstChild("Humanoid")
                    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                    if hum and hrp and hum.Health > 0 and
                        (hrp.Position - myHRP.Position).Magnitude <= FastAttackRange then
                        table.insert(targets, player.Character)
                    end
                end
            end
            local enemies = workspace:FindFirstChild("Enemies")
            if enemies then
                for _, npc in pairs(enemies:GetChildren()) do
                    local hum = npc:FindFirstChild("Humanoid")
                    local hrp = npc:FindFirstChild("HumanoidRootPart")
                    if hum and hrp and hum.Health > 0 and
                        (hrp.Position - myHRP.Position).Magnitude <= FastAttackRange then
                        table.insert(targets, npc)
                    end
                end
            end
            if #targets > 0 then AttackMultipleTargets(targets) end
        end
    end)
end

-- ==================== GUI ====================
local pgui = Players.LocalPlayer:WaitForChild("PlayerGui")
if pgui:FindFirstChild("TommyHub_Premium") then pgui.TommyHub_Premium:Destroy() end

local screenGui = Instance.new("ScreenGui", pgui)
screenGui.Name = "TommyHub_Premium"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
local normalSize = UDim2.new(0, 420, 0, 550)
local minimizedSize = UDim2.new(0, 150, 0, 40)
mainFrame.Size = normalSize
mainFrame.Position = UDim2.new(0.5, -210, 0.15, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 28)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.BorderSizePixel = 0

local tabContainer = Instance.new("Frame", mainFrame)
tabContainer.Size = UDim2.new(1, -20, 0, 45)
tabContainer.Position = UDim2.new(0, 10, 0, 60)
tabContainer.BackgroundTransparency = 1

local contentFrame = Instance.new("Frame", mainFrame)
contentFrame.Size = UDim2.new(1, -20, 1, -130)
contentFrame.Position = UDim2.new(0, 10, 0, 115)
contentFrame.BackgroundTransparency = 1

local function createPage(name)
    local p = Instance.new("ScrollingFrame", contentFrame)
    p.Name = name
    p.Size = UDim2.new(1, 0, 1, 0)
    p.BackgroundTransparency = 1
    p.Visible = false
    Instance.new("UIListLayout", p)
    return p
end

local combatPage = createPage("Combat")
local movePage   = createPage("Movement")
local sea2Page   = createPage("Sea2")
local sea3Page   = createPage("Sea3")
local visualPage = createPage("Visual")

local function showPage(page)
    for _, v in pairs(contentFrame:GetChildren()) do
        if v:IsA("ScrollingFrame") then v.Visible = false end
    end
    page.Visible = true
end

local function createTab(label, page)
    local btn = Instance.new("TextButton", tabContainer)
    btn.Size = UDim2.new(0, 90, 0, 38)
    btn.Text = label
    btn.MouseButton1Click:Connect(function() showPage(page) end)
end

createTab("⚔️ Combate", combatPage)
createTab("🏃 Mov", movePage)
createTab("🌊 Sea 2", sea2Page)
createTab("🏰 Sea 3", sea3Page)
createTab("👁️ Visuales", visualPage)

showPage(combatPage)

local function addBtn(txt, parent)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Text = txt
    return btn
end

-- ===== VISUALES =====
local fpsBtn = addBtn("🎮 FPS Boost: OFF", visualPage)

fpsBtn.MouseButton1Click:Connect(function()
    FPSBoostEnabled = not FPSBoostEnabled
    fpsBtn.Text = FPSBoostEnabled and "🎮 FPS Boost: ON" or "🎮 FPS Boost: OFF"

    if FPSBoostEnabled then
        ApplyFPSBoost()
    else
        RemoveFPSBoost()
    end
end)

print("✅ Tommy Hub Premium cargado correctamente")
