-- GUI PARA HITBOX REAL
-- Interface simples para testar o hitbox verdadeiro

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Verifica se o script principal foi carregado
if not _G.VolleyballHitboxReal then
    warn("Script principal não carregado!")
    return
end

local api = _G.VolleyballHitboxReal

-- Remove GUI anterior se existir
local existingGui = playerGui:FindFirstChild("VolleyballHitboxGUI")
if existingGui then
    existingGui:Destroy()
end

-- Criar GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VolleyballHitboxGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Frame principal
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Cantos arredondados
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- Título
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "HITBOX REAL - TESTE"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

-- Toggle Hitbox
local hitboxToggle = Instance.new("TextButton")
hitboxToggle.Name = "HitboxToggle"
hitboxToggle.Size = UDim2.new(0.8, 0, 0, 30)
hitboxToggle.Position = UDim2.new(0.1, 0, 0, 50)
hitboxToggle.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
hitboxToggle.Text = "HITBOX: OFF"
hitboxToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
hitboxToggle.TextScaled = true
hitboxToggle.Font = Enum.Font.Gotham
hitboxToggle.Parent = mainFrame

local hitboxCorner = Instance.new("UICorner")
hitboxCorner.CornerRadius = UDim.new(0, 6)
hitboxCorner.Parent = hitboxToggle

-- Slider de tamanho
local sizeLabel = Instance.new("TextLabel")
sizeLabel.Name = "SizeLabel"
sizeLabel.Size = UDim2.new(1, 0, 0, 20)
sizeLabel.Position = UDim2.new(0, 0, 0, 90)
sizeLabel.BackgroundTransparency = 1
sizeLabel.Text = "Tamanho: 30"
sizeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
sizeLabel.TextScaled = true
sizeLabel.Font = Enum.Font.Gotham
sizeLabel.Parent = mainFrame

local sizeSlider = Instance.new("Frame")
sizeSlider.Name = "SizeSlider"
sizeSlider.Size = UDim2.new(0.8, 0, 0, 20)
sizeSlider.Position = UDim2.new(0.1, 0, 0, 115)
sizeSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
sizeSlider.Parent = mainFrame

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(0, 10)
sliderCorner.Parent = sizeSlider

local sliderButton = Instance.new("TextButton")
sliderButton.Name = "SliderButton"
sliderButton.Size = UDim2.new(0, 20, 1, 0)
sliderButton.Position = UDim2.new(0.5, -10, 0, 0) -- Posição inicial (meio)
sliderButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
sliderButton.Text = ""
sliderButton.Parent = sizeSlider

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 10)
buttonCorner.Parent = sliderButton

-- ESP Toggles
local ballESPToggle = Instance.new("TextButton")
ballESPToggle.Name = "BallESPToggle"
ballESPToggle.Size = UDim2.new(0.35, 0, 0, 25)
ballESPToggle.Position = UDim2.new(0.1, 0, 0, 150)
ballESPToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
ballESPToggle.Text = "Ball ESP: OFF"
ballESPToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
ballESPToggle.TextScaled = true
ballESPToggle.Font = Enum.Font.Gotham
ballESPToggle.Parent = mainFrame

local ballESPCorner = Instance.new("UICorner")
ballESPCorner.CornerRadius = UDim.new(0, 4)
ballESPCorner.Parent = ballESPToggle

local playerESPToggle = Instance.new("TextButton")
playerESPToggle.Name = "PlayerESPToggle"
playerESPToggle.Size = UDim2.new(0.35, 0, 0, 25)
playerESPToggle.Position = UDim2.new(0.55, 0, 0, 150)
playerESPToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
playerESPToggle.Text = "Player ESP: OFF"
playerESPToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
playerESPToggle.TextScaled = true
playerESPToggle.Font = Enum.Font.Gotham
playerESPToggle.Parent = mainFrame

local playerESPCorner = Instance.new("UICorner")
playerESPCorner.CornerRadius = UDim.new(0, 4)
playerESPCorner.Parent = playerESPToggle

-- Variáveis de estado
local hitboxEnabled = false
local ballESPEnabled = false
local playerESPEnabled = false
local currentSize = 30

-- Função para atualizar slider
local function updateSlider(value)
    currentSize = math.floor(value)
    sizeLabel.Text = "Tamanho: " .. currentSize
    api.setHitboxSize(currentSize)
    
    -- Atualiza posição do botão do slider
    local percentage = (value - 5) / (100 - 5) -- 5 a 100
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
        local sliderPos = sizeSlider.AbsolutePosition
        local sliderSize = sizeSlider.AbsoluteSize
        
        local relativeX = mousePos.X - sliderPos.X
        local percentage = math.clamp(relativeX / sliderSize.X, 0, 1)
        
        local value = 5 + (percentage * (100 - 5)) -- 5 a 100
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
    else
        hitboxToggle.Text = "HITBOX: OFF"
        hitboxToggle.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
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

-- Toggle Player ESP
playerESPToggle.MouseButton1Click:Connect(function()
    playerESPEnabled = not playerESPEnabled
    api.togglePlayerESP(playerESPEnabled)
    
    if playerESPEnabled then
        playerESPToggle.Text = "Player ESP: ON"
        playerESPToggle.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
    else
        playerESPToggle.Text = "Player ESP: OFF"
        playerESPToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
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

print("✅ GUI Hitbox Real carregada!")
print("🎮 Pressione INSERT para abrir/fechar")
print("🎯 Teste o hitbox agora!")

return true