-- GUI DEFINITIVA - BASEADA NO CÓDIGO REAL
-- Interface simples e funcional

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Verifica se o script principal foi carregado
if not _G.VolleyballDefinitivo then
    warn("❌ Script DEFINITIVO não carregado!")
    return
end

local api = _G.VolleyballDefinitivo

-- Remove GUI anterior
local existingGui = playerGui:FindFirstChild("VolleyballDefinitivoGUI")
if existingGui then
    existingGui:Destroy()
end

-- Criar GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VolleyballDefinitivoGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Frame principal
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 220)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -110)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Cantos arredondados
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

-- Título
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 35)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🔥 HITBOX DEFINITIVO"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

-- Subtítulo
local subtitle = Instance.new("TextLabel")
subtitle.Name = "Subtitle"
subtitle.Size = UDim2.new(1, 0, 0, 20)
subtitle.Position = UDim2.new(0, 0, 0, 30)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Baseado no código cliente real"
subtitle.TextColor3 = Color3.fromRGB(180, 180, 180)
subtitle.TextScaled = true
subtitle.Font = Enum.Font.Gotham
subtitle.Parent = mainFrame

-- Toggle Hitbox (PRINCIPAL)
local hitboxToggle = Instance.new("TextButton")
hitboxToggle.Name = "HitboxToggle"
hitboxToggle.Size = UDim2.new(0.85, 0, 0, 40)
hitboxToggle.Position = UDim2.new(0.075, 0, 0, 60)
hitboxToggle.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
hitboxToggle.Text = "HITBOX: OFF"
hitboxToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
hitboxToggle.TextScaled = true
hitboxToggle.Font = Enum.Font.GothamBold
hitboxToggle.Parent = mainFrame

local hitboxCorner = Instance.new("UICorner")
hitboxCorner.CornerRadius = UDim.new(0, 8)
hitboxCorner.Parent = hitboxToggle

-- Slider de distância
local distanceLabel = Instance.new("TextLabel")
distanceLabel.Name = "DistanceLabel"
distanceLabel.Size = UDim2.new(1, 0, 0, 20)
distanceLabel.Position = UDim2.new(0, 0, 0, 110)
distanceLabel.BackgroundTransparency = 1
distanceLabel.Text = "Distância: 30 studs"
distanceLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
distanceLabel.TextScaled = true
distanceLabel.Font = Enum.Font.Gotham
distanceLabel.Parent = mainFrame

local distanceSlider = Instance.new("Frame")
distanceSlider.Name = "DistanceSlider"
distanceSlider.Size = UDim2.new(0.85, 0, 0, 20)
distanceSlider.Position = UDim2.new(0.075, 0, 0, 135)
distanceSlider.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
distanceSlider.Parent = mainFrame

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(0, 10)
sliderCorner.Parent = distanceSlider

local sliderButton = Instance.new("TextButton")
sliderButton.Name = "SliderButton"
sliderButton.Size = UDim2.new(0, 20, 1, 0)
sliderButton.Position = UDim2.new(0.25, -10, 0, 0) -- 30 de 100
sliderButton.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
sliderButton.Text = ""
sliderButton.Parent = distanceSlider

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 10)
buttonCorner.Parent = sliderButton

-- Botão de teste manual
local testButton = Instance.new("TextButton")
testButton.Name = "TestButton"
testButton.Size = UDim2.new(0.4, 0, 0, 25)
testButton.Position = UDim2.new(0.075, 0, 0, 165)
testButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
testButton.Text = "TESTE MANUAL"
testButton.TextColor3 = Color3.fromRGB(255, 255, 255)
testButton.TextScaled = true
testButton.Font = Enum.Font.Gotham
testButton.Parent = mainFrame

local testCorner = Instance.new("UICorner")
testCorner.CornerRadius = UDim.new(0, 4)
testCorner.Parent = testButton

-- Ball ESP Toggle
local ballESPToggle = Instance.new("TextButton")
ballESPToggle.Name = "BallESPToggle"
ballESPToggle.Size = UDim2.new(0.4, 0, 0, 25)
ballESPToggle.Position = UDim2.new(0.525, 0, 0, 165)
ballESPToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
ballESPToggle.Text = "Ball ESP: OFF"
ballESPToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
ballESPToggle.TextScaled = true
ballESPToggle.Font = Enum.Font.Gotham
ballESPToggle.Parent = mainFrame

local ballESPCorner = Instance.new("UICorner")
ballESPCorner.CornerRadius = UDim.new(0, 4)
ballESPCorner.Parent = ballESPToggle

-- Status
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(0.85, 0, 0, 20)
statusLabel.Position = UDim2.new(0.075, 0, 0, 195)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "💡 Ative o hitbox e entre numa partida!"
statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = mainFrame

-- Variáveis de estado
local hitboxEnabled = false
local ballESPEnabled = false
local currentDistance = 30

-- Função para atualizar slider
local function updateSlider(value)
    currentDistance = math.floor(value)
    distanceLabel.Text = "Distância: " .. currentDistance .. " studs"
    api.setHitboxDistance(currentDistance)
    
    -- Atualiza posição do botão (5 a 100 studs)
    local percentage = (value - 5) / (100 - 5)
    sliderButton.Position = UDim2.new(percentage, -10, 0, 0)
end

-- Sistema de slider
local dragging = false
sliderButton.MouseButton1Down:Connect(function()
    dragging = true
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = UserInputService:GetMouseLocation()
        local sliderPos = distanceSlider.AbsolutePosition
        local sliderSize = distanceSlider.AbsoluteSize
        
        local relativeX = mousePos.X - sliderPos.X
        local percentage = math.clamp(relativeX / sliderSize.X, 0, 1)
        
        local value = 5 + (percentage * (100 - 5)) -- 5 a 100 studs
        updateSlider(value)
    end
end)

-- Toggle Hitbox
hitboxToggle.MouseButton1Click:Connect(function()
    hitboxEnabled = not hitboxEnabled
    api.toggleHitbox(hitboxEnabled)
    
    if hitboxEnabled then
        hitboxToggle.Text = "HITBOX: ON"
        hitboxToggle.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
        statusLabel.Text = "✅ Hitbox ativo! Tente bater na bola de longe!"
    else
        hitboxToggle.Text = "HITBOX: OFF"
        hitboxToggle.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        statusLabel.Text = "❌ Hitbox desativado"
    end
end)

-- Teste Manual
testButton.MouseButton1Click:Connect(function()
    api.manualHit()
    statusLabel.Text = "🎯 Teste manual executado!"
    
    -- Volta ao status normal após 2 segundos
    task.wait(2)
    if hitboxEnabled then
        statusLabel.Text = "✅ Hitbox ativo! Tente bater na bola de longe!"
    else
        statusLabel.Text = "💡 Ative o hitbox e entre numa partida!"
    end
end)

-- Toggle Ball ESP
ballESPToggle.MouseButton1Click:Connect(function()
    ballESPEnabled = not ballESPEnabled
    api.toggleBallESP(ballESPEnabled)
    
    if ballESPEnabled then
        ballESPToggle.Text = "Ball ESP: ON"
        ballESPToggle.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
    else
        ballESPToggle.Text = "Ball ESP: OFF"
        ballESPToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    end
end)

-- Fechar com INSERT
UserInputService.InputBegan:Connect(function(key)
    if key.KeyCode == Enum.KeyCode.Insert then
        screenGui.Enabled = not screenGui.Enabled
    end
end)

-- Tornar arrastável
local draggingFrame = false
local dragStart = nil
local startPos = nil

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingFrame = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and draggingFrame then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

mainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingFrame = false
    end
end)

print("✅ GUI DEFINITIVA carregada!")
print("🎮 Pressione INSERT para abrir/fechar")
print("🔥 Baseada no código cliente real!")

return true