-- GUI SIMPLES - PARA HITBOX BASEADO NO CHATGPT
-- Interface minimalista e funcional

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Verifica se o script principal foi carregado
if not _G.VolleyballHitboxSimples then
    warn("❌ Script Hitbox Simples não carregado!")
    return
end

local api = _G.VolleyballHitboxSimples

-- Remove GUI anterior
local existingGui = playerGui:FindFirstChild("VolleyballSimplesGUI")
if existingGui then
    existingGui:Destroy()
end

-- Criar GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VolleyballSimplesGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Frame principal
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 280, 0, 200)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Cantos arredondados
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

-- Título
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "📦 HITBOX SIMPLES"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

-- Subtítulo
local subtitle = Instance.new("TextLabel")
subtitle.Name = "Subtitle"
subtitle.Size = UDim2.new(1, 0, 0, 15)
subtitle.Position = UDim2.new(0, 0, 0, 25)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Baseado no código do ChatGPT"
subtitle.TextColor3 = Color3.fromRGB(180, 180, 180)
subtitle.TextScaled = true
subtitle.Font = Enum.Font.Gotham
subtitle.Parent = mainFrame

-- Toggle Hitbox
local hitboxToggle = Instance.new("TextButton")
hitboxToggle.Name = "HitboxToggle"
hitboxToggle.Size = UDim2.new(0.85, 0, 0, 35)
hitboxToggle.Position = UDim2.new(0.075, 0, 0, 50)
hitboxToggle.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
hitboxToggle.Text = "HITBOX: OFF"
hitboxToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
hitboxToggle.TextScaled = true
hitboxToggle.Font = Enum.Font.GothamBold
hitboxToggle.Parent = mainFrame

local hitboxCorner = Instance.new("UICorner")
hitboxCorner.CornerRadius = UDim.new(0, 8)
hitboxCorner.Parent = hitboxToggle

-- Slider de tamanho
local sizeLabel = Instance.new("TextLabel")
sizeLabel.Name = "SizeLabel"
sizeLabel.Size = UDim2.new(1, 0, 0, 15)
sizeLabel.Position = UDim2.new(0, 0, 0, 95)
sizeLabel.BackgroundTransparency = 1
sizeLabel.Text = "Tamanho: 8"
sizeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
sizeLabel.TextScaled = true
sizeLabel.Font = Enum.Font.Gotham
sizeLabel.Parent = mainFrame

local sizeSlider = Instance.new("Frame")
sizeSlider.Name = "SizeSlider"
sizeSlider.Size = UDim2.new(0.85, 0, 0, 15)
sizeSlider.Position = UDim2.new(0.075, 0, 0, 115)
sizeSlider.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
sizeSlider.Parent = mainFrame

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(0, 8)
sliderCorner.Parent = sizeSlider

local sliderButton = Instance.new("TextButton")
sliderButton.Name = "SliderButton"
sliderButton.Size = UDim2.new(0, 15, 1, 0)
sliderButton.Position = UDim2.new(0.15, -7, 0, 0) -- 8 de 50
sliderButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
sliderButton.Text = ""
sliderButton.Parent = sizeSlider

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = sliderButton

-- Botões de teste
local testRaycastButton = Instance.new("TextButton")
testRaycastButton.Name = "TestRaycastButton"
testRaycastButton.Size = UDim2.new(0.4, 0, 0, 25)
testRaycastButton.Position = UDim2.new(0.075, 0, 0, 140)
testRaycastButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
testRaycastButton.Text = "TESTE RAYCAST"
testRaycastButton.TextColor3 = Color3.fromRGB(255, 255, 255)
testRaycastButton.TextScaled = true
testRaycastButton.Font = Enum.Font.Gotham
testRaycastButton.Parent = mainFrame

local testCorner = Instance.new("UICorner")
testCorner.CornerRadius = UDim.new(0, 4)
testCorner.Parent = testRaycastButton

-- Ball ESP Toggle
local ballESPToggle = Instance.new("TextButton")
ballESPToggle.Name = "BallESPToggle"
ballESPToggle.Size = UDim2.new(0.4, 0, 0, 25)
ballESPToggle.Position = UDim2.new(0.525, 0, 0, 140)
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
statusLabel.Position = UDim2.new(0.075, 0, 0, 175)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "💡 Ative a hitbox e se aproxime da bola!"
statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = mainFrame

-- Variáveis de estado
local hitboxEnabled = false
local ballESPEnabled = false
local currentSize = 8

-- Função para atualizar slider
local function updateSlider(value)
    currentSize = math.floor(value)
    sizeLabel.Text = "Tamanho: " .. currentSize
    api.setHitboxSize(currentSize)
    
    -- Atualiza posição do botão (4 a 50)
    local percentage = (value - 4) / (50 - 4)
    sliderButton.Position = UDim2.new(percentage, -7, 0, 0)
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
        local sliderPos = sizeSlider.AbsolutePosition
        local sliderSize = sizeSlider.AbsoluteSize
        
        local relativeX = mousePos.X - sliderPos.X
        local percentage = math.clamp(relativeX / sliderSize.X, 0, 1)
        
        local value = 4 + (percentage * (50 - 4)) -- 4 a 50
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
        statusLabel.Text = "✅ Hitbox ativa! Se aproxime da bola!"
    else
        hitboxToggle.Text = "HITBOX: OFF"
        hitboxToggle.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        statusLabel.Text = "❌ Hitbox desativada"
    end
end)

-- Teste Raycast
testRaycastButton.MouseButton1Click:Connect(function()
    api.testRaycast()
    statusLabel.Text = "🎯 Teste Raycast executado!"
    
    task.spawn(function()
        task.wait(2)
        if hitboxEnabled then
            statusLabel.Text = "✅ Hitbox ativa! Se aproxime da bola!"
        else
            statusLabel.Text = "💡 Ative a hitbox e se aproxime da bola!"
        end
    end)
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

print("✅ GUI SIMPLES carregada!")
print("🎮 Pressione INSERT para abrir/fechar")
print("📦 Baseada no método do ChatGPT!")

return true