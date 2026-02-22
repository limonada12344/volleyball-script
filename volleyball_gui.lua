--[[
    VOLLEYBALL LEGENDS - GUI
    Interface moderna e fácil de usar
]]

-- Verificar se o script foi carregado
if not _G.VolleyballConfig then
    warn("❌ Script principal não foi carregado!")
    return
end

local Config = _G.VolleyballConfig
local ESP = _G.VolleyballESP
local Hitbox = _G.VolleyballHitbox
local Aimbot = _G.VolleyballAimbot

-- Serviços
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Cores
local Colors = {
    Primary = Color3.fromRGB(88, 101, 242),
    Secondary = Color3.fromRGB(67, 78, 191),
    Background = Color3.fromRGB(32, 34, 37),
    Sidebar = Color3.fromRGB(47, 49, 54),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(185, 187, 190),
    Success = Color3.fromRGB(67, 181, 129),
    Danger = Color3.fromRGB(240, 71, 71),
    Warning = Color3.fromRGB(250, 166, 26)
}

-- Criar ScreenGui
local function createScreenGui()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "VolleyballLegendsGUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    if gethui then
        screenGui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(screenGui)
        screenGui.Parent = game:GetService("CoreGui")
    else
        screenGui.Parent = game:GetService("CoreGui")
    end
    
    return screenGui
end

-- Criar janela principal
local screenGui = createScreenGui()

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 500, 0, 350)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
mainFrame.BackgroundColor3 = Colors.Background
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = false
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

-- Header
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 45)
header.BackgroundColor3 = Colors.Primary
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 10)
headerCorner.Parent = header

local headerBottom = Instance.new("Frame")
headerBottom.Size = UDim2.new(1, 0, 0, 10)
headerBottom.Position = UDim2.new(0, 0, 1, -10)
headerBottom.BackgroundColor3 = Colors.Primary
headerBottom.BorderSizePixel = 0
headerBottom.Parent = header

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 300, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🏐 VOLLEYBALL LEGENDS"
title.TextColor3 = Colors.Text
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- Versão
local version = Instance.new("TextLabel")
version.Size = UDim2.new(0, 100, 1, 0)
version.Position = UDim2.new(0, 280, 0, 0)
version.BackgroundTransparency = 1
version.Text = "v1.0.0"
version.TextColor3 = Colors.TextDark
version.TextSize = 12
version.Font = Enum.Font.Gotham
version.TextXAlignment = Enum.TextXAlignment.Left
version.Parent = header

-- Botão fechar
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.Position = UDim2.new(1, -40, 0, 5)
closeBtn.BackgroundColor3 = Colors.Danger
closeBtn.Text = "×"
closeBtn.TextColor3 = Colors.Text
closeBtn.TextSize = 20
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.Parent = header

local closeBtnCorner = Instance.new("UICorner")
closeBtnCorner.CornerRadius = UDim.new(0, 6)
closeBtnCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

-- Container de conteúdo
local content = Instance.new("ScrollingFrame")
content.Name = "Content"
content.Size = UDim2.new(1, -20, 1, -60)
content.Position = UDim2.new(0, 10, 0, 50)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ScrollBarThickness = 4
content.ScrollBarImageColor3 = Colors.Primary
content.Parent = mainFrame

local contentLayout = Instance.new("UIListLayout")
contentLayout.Padding = UDim.new(0, 8)
contentLayout.Parent = content

-- Função para criar seção
local function createSection(name)
    local section = Instance.new("Frame")
    section.Name = name
    section.Size = UDim2.new(1, -10, 0, 30)
    section.BackgroundTransparency = 1
    section.Parent = content
    
    local sectionLabel = Instance.new("TextLabel")
    sectionLabel.Size = UDim2.new(1, 0, 1, 0)
    sectionLabel.BackgroundTransparency = 1
    sectionLabel.Text = "━━ " .. name .. " ━━"
    sectionLabel.TextColor3 = Colors.Primary
    sectionLabel.TextSize = 14
    sectionLabel.Font = Enum.Font.GothamBold
    sectionLabel.Parent = section
    
    return section
end

-- Função para criar toggle
local function createToggle(name, description, defaultValue, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, -10, 0, 50)
    toggleFrame.BackgroundColor3 = Colors.Sidebar
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = content
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 8)
    toggleCorner.Parent = toggleFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -70, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Colors.Text
    label.TextSize = 13
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleFrame
    
    local desc = Instance.new("TextLabel")
    desc.Size = UDim2.new(1, -70, 0, 15)
    desc.Position = UDim2.new(0, 10, 0, 25)
    desc.BackgroundTransparency = 1
    desc.Text = description
    desc.TextColor3 = Colors.TextDark
    desc.TextSize = 10
    desc.Font = Enum.Font.Gotham
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.Parent = toggleFrame
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 45, 0, 22)
    toggleButton.Position = UDim2.new(1, -52, 0.5, -11)
    toggleButton.BackgroundColor3 = defaultValue and Colors.Success or Colors.TextDark
    toggleButton.Text = ""
    toggleButton.BorderSizePixel = 0
    toggleButton.Parent = toggleFrame
    
    local toggleBtnCorner = Instance.new("UICorner")
    toggleBtnCorner.CornerRadius = UDim.new(1, 0)
    toggleBtnCorner.Parent = toggleButton
    
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 18, 0, 18)
    indicator.Position = defaultValue and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    indicator.BackgroundColor3 = Colors.Text
    indicator.BorderSizePixel = 0
    indicator.Parent = toggleButton
    
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(1, 0)
    indicatorCorner.Parent = indicator
    
    local toggled = defaultValue
    
    toggleButton.MouseButton1Click:Connect(function()
        toggled = not toggled
        
        TweenService:Create(toggleButton, TweenInfo.new(0.2), {
            BackgroundColor3 = toggled and Colors.Success or Colors.TextDark
        }):Play()
        
        TweenService:Create(indicator, TweenInfo.new(0.2), {
            Position = toggled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
        }):Play()
        
        if callback then
            callback(toggled)
        end
    end)
    
    return toggleFrame
end

-- Função para criar slider
local function createSlider(name, min, max, default, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, -10, 0, 50)
    sliderFrame.BackgroundColor3 = Colors.Sidebar
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = content
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 8)
    sliderCorner.Parent = sliderFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Colors.Text
    label.TextSize = 13
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sliderFrame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.3, -10, 0, 20)
    valueLabel.Position = UDim2.new(0.7, 0, 0, 5)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Colors.Primary
    valueLabel.TextSize = 13
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = sliderFrame
    
    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(1, -20, 0, 4)
    sliderBar.Position = UDim2.new(0, 10, 1, -15)
    sliderBar.BackgroundColor3 = Colors.Background
    sliderBar.BorderSizePixel = 0
    sliderBar.Parent = sliderFrame
    
    local sliderBarCorner = Instance.new("UICorner")
    sliderBarCorner.CornerRadius = UDim.new(1, 0)
    sliderBarCorner.Parent = sliderBar
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Colors.Primary
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBar
    
    local sliderFillCorner = Instance.new("UICorner")
    sliderFillCorner.CornerRadius = UDim.new(1, 0)
    sliderFillCorner.Parent = sliderFill
    
    local dragging = false
    
    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    sliderBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = input.Position.X
            local barPos = sliderBar.AbsolutePosition.X
            local barSize = sliderBar.AbsoluteSize.X
            
            local value = math.clamp((mousePos - barPos) / barSize, 0, 1)
            local actualValue = math.floor(min + (value * (max - min)))
            
            sliderFill.Size = UDim2.new(value, 0, 1, 0)
            valueLabel.Text = tostring(actualValue)
            
            if callback then
                callback(actualValue)
            end
        end
    end)
    
    return sliderFrame
end

-- ===== CRIAR INTERFACE =====

-- Seção: Aimbot
createSection("🎯 AIMBOT")

createToggle("Aimbot Dive", "Mira automática na bola (legit)", Config.AimbotEnabled, function(value)
    Config.AimbotEnabled = value
    print("Aimbot:", value)
end)

createSlider("FOV", 50, 500, Config.AimbotFOV, function(value)
    Config.AimbotFOV = value
end)

createSlider("Suavização", 1, 50, Config.AimbotSmoothing * 100, function(value)
    Config.AimbotSmoothing = value / 100
end)

createToggle("Predição", "Prever onde a bola vai estar", Config.AimbotPrediction, function(value)
    Config.AimbotPrediction = value
end)

-- Seção: Hitbox
createSection("📦 HITBOX")

createToggle("Hitbox Extender", "Aumentar área de acerto", Config.HitboxEnabled, function(value)
    Config.HitboxEnabled = value
    print("Hitbox:", value)
end)

createSlider("Tamanho", 5, 100, Config.HitboxSize, function(value)
    Config.HitboxSize = value
end)

-- Seção: Visual
createSection("👁️ VISUAL")

createToggle("Ball ESP", "Ver a bola através de paredes", Config.BallESPEnabled, function(value)
    Config.BallESPEnabled = value
    if not value then
        ESP:ClearAll()
    end
end)

createToggle("Player ESP", "Ver jogadores através de paredes", Config.PlayerESPEnabled, function(value)
    Config.PlayerESPEnabled = value
end)

-- Seção: Auto Features
createSection("⚡ AUTO FEATURES")

createToggle("Auto Serve", "Sacar automaticamente", Config.AutoServeEnabled, function(value)
    Config.AutoServeEnabled = value
end)

createToggle("Auto Block", "Bloquear automaticamente", Config.AutoBlockEnabled, function(value)
    Config.AutoBlockEnabled = value
end)

-- Seção: Misc
createSection("⚙️ MISC")

createToggle("Anti-AFK", "Evitar ser kickado por inatividade", Config.AntiAFK, function(value)
    Config.AntiAFK = value
end)

-- Toggle GUI com INSERT
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.Insert then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

-- Mostrar GUI
mainFrame.Visible = true

print("✅ GUI carregada! Pressione INSERT para abrir/fechar")
