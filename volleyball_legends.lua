--[[
    VOLLEYBALL LEGENDS - LEGIT SCRIPT
    Versão: 1.0.0
    Executor: Velocity / Xeno
    
    Funcionalidades:
    - Aimbot Dive (Legit)
    - Hitbox Extender
    - Ball ESP
    - Player ESP
    - Auto Serve
    - Auto Block
    - Prediction
    - Anti-AFK
]]

-- Verificar se já está carregado
if _G.VolleyballLegendsLoaded then
    warn("⚠️ Script já está carregado!")
    return
end

_G.VolleyballLegendsLoaded = true

print("╔════════════════════════════════════╗")
print("║   VOLLEYBALL LEGENDS - LOADING...  ║")
print("╚════════════════════════════════════╝")

-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Variáveis locais
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Configurações
local Config = {
    -- Aimbot
    AimbotEnabled = false,
    AimbotFOV = 200,
    AimbotSmoothing = 0.15, -- Quanto maior, mais suave (legit)
    AimbotPrediction = true,
    
    -- Hitbox
    HitboxEnabled = false,
    HitboxSize = 15, -- Tamanho da hitbox
    HitboxTransparency = 0.7,
    
    -- ESP
    BallESPEnabled = false,
    PlayerESPEnabled = false,
    ESPColor = Color3.fromRGB(255, 0, 0),
    
    -- Auto Features
    AutoServeEnabled = false,
    AutoBlockEnabled = false,
    AutoBlockTiming = 0.3, -- Delay antes de bloquear
    
    -- Misc
    AntiAFK = true,
    ShowStats = false,
    
    -- Humanização
    RandomizeDelay = true,
    MinDelay = 0.05,
    MaxDelay = 0.15
}

-- Utilitários
local Utils = {}

function Utils:GetCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

function Utils:GetHumanoid()
    local char = self:GetCharacter()
    return char and char:FindFirstChildOfClass("Humanoid")
end

function Utils:GetRootPart()
    local char = self:GetCharacter()
    return char and char:FindFirstChild("HumanoidRootPart")
end

function Utils:HumanWait()
    if Config.RandomizeDelay then
        wait(Config.MinDelay + (math.random() * (Config.MaxDelay - Config.MinDelay)))
    else
        wait(0.1)
    end
end

-- Cache da bola para não procurar toda hora
local cachedBall = nil
local lastBallCheck = 0

function Utils:GetBall()
    -- Verificar cache (atualiza a cada 1 segundo)
    local currentTime = tick()
    if cachedBall and cachedBall.Parent and (currentTime - lastBallCheck) < 1 then
        return cachedBall
    end
    
    lastBallCheck = currentTime
    
    -- Procurar pela bola no workspace
    local ball = Workspace:FindFirstChild("Ball") or 
                 Workspace:FindFirstChild("Volleyball") or
                 Workspace:FindFirstChild("ball") or
                 Workspace:FindFirstChild("VolleyBall")
    
    if not ball then
        -- Procurar em descendentes
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and (
                obj.Name:lower():find("ball") or
                obj.Name:lower():find("volley")
            ) then
                ball = obj
                break
            end
        end
    end
    
    cachedBall = ball
    return ball
end

function Utils:PredictBallPosition(ball, time)
    if not ball or not ball:IsA("BasePart") then return nil end
    
    local velocity = ball.AssemblyLinearVelocity or ball.Velocity
    local currentPos = ball.Position
    
    -- Prever posição futura
    local predictedPos = currentPos + (velocity * time)
    
    return predictedPos
end

function Utils:IsInFOV(position, fov)
    local screenPoint, onScreen = Camera:WorldToViewportPoint(position)
    
    if not onScreen then return false end
    
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local screenPos = Vector2.new(screenPoint.X, screenPoint.Y)
    local distance = (screenCenter - screenPos).Magnitude
    
    return distance <= fov
end

-- Sistema de ESP
local ESP = {}
ESP.Objects = {}

function ESP:CreateBallESP(ball)
    if not ball or ESP.Objects[ball] then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "BallESP"
    highlight.FillColor = Color3.fromRGB(255, 255, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 200, 0)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Parent = ball
    
    ESP.Objects[ball] = highlight
end

function ESP:CreatePlayerESP(player)
    if not player.Character or ESP.Objects[player] then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "PlayerESP"
    highlight.FillColor = Config.ESPColor
    highlight.OutlineColor = Config.ESPColor
    highlight.FillTransparency = 0.6
    highlight.OutlineTransparency = 0
    highlight.Parent = player.Character
    
    ESP.Objects[player] = highlight
end

function ESP:RemoveESP(object)
    if ESP.Objects[object] then
        ESP.Objects[object]:Destroy()
        ESP.Objects[object] = nil
    end
end

function ESP:ClearAll()
    for obj, highlight in pairs(ESP.Objects) do
        highlight:Destroy()
    end
    ESP.Objects = {}
end

function ESP:UpdateBallESP()
    if not Config.BallESPEnabled then
        -- Remover apenas ESP da bola
        for obj, highlight in pairs(self.Objects) do
            if not obj:IsA("Player") then
                pcall(function() highlight:Destroy() end)
                self.Objects[obj] = nil
            end
        end
        return
    end
    
    local ball = Utils:GetBall()
    if ball then
        -- Se já existe, garantir que a cor está correta
        if self.Objects[ball] then
            pcall(function()
                self.Objects[ball].FillColor = Color3.fromRGB(255, 255, 0)
                self.Objects[ball].OutlineColor = Color3.fromRGB(255, 200, 0)
            end)
        else
            -- Criar novo ESP
            self:CreateBallESP(ball)
        end
    end
end

function ESP:UpdatePlayerESP()
    if not Config.PlayerESPEnabled then
        -- Remover apenas ESP de jogadores
        for player, _ in pairs(ESP.Objects) do
            if player:IsA("Player") then
                self:RemoveESP(player)
            end
        end
        return
    end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and not self.Objects[player] then
            self:CreatePlayerESP(player)
        end
    end
end

-- Sistema de Hitbox (MAGNETISMO AGRESSIVO - IGUAL STERLING)
local Hitbox = {}
Hitbox.Connection = nil

function Hitbox:Start()
    if self.Connection then return end
    
    print("🎯 Iniciando Hitbox Extender (Magnetismo Agressivo)...")
    
    -- Usar Heartbeat para movimento suave
    self.Connection = RunService.Heartbeat:Connect(function()
        if not Config.HitboxEnabled then return end
        
        local char = Utils:GetCharacter()
        if not char then return end
        
        local hrp = Utils:GetRootPart()
        if not hrp then return end
        
        local ball = Utils:GetBall()
        if not ball then return end
        
        -- Calcular distância
        local distance = (ball.Position - hrp.Position).Magnitude
        
        -- Raio de ação baseado no slider (quanto maior, mais longe funciona)
        local actionRadius = Config.HitboxSize
        
        -- Se a bola está dentro do raio
        if distance <= actionRadius and distance > 1 then
            -- Direção da bola
            local direction = (ball.Position - hrp.Position).Unit
            
            -- FORÇA DO PUXÃO (ajustável)
            -- Quanto mais perto da bola, mais forte o puxão
            local pullStrength = math.clamp((actionRadius - distance) / actionRadius, 0, 1)
            
            -- Multiplicador de força (quanto maior, mais agressivo)
            local forceMultiplier = 2.5
            
            -- Calcular movimento
            local movement = direction * pullStrength * forceMultiplier
            
            -- APLICAR MOVIMENTO (múltiplos métodos para garantir)
            pcall(function()
                -- Método 1: CFrame (mais suave)
                hrp.CFrame = hrp.CFrame + movement
                
                -- Método 2: Velocity (mais natural)
                if distance < actionRadius / 2 then
                    hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity + (movement * 10)
                end
            end)
        end
    end)
    
    print("✅ Hitbox ativado! Raio:", Config.HitboxSize)
    print("💡 Modo: Magnetismo Agressivo (puxa você para a bola)")
    print("� Quanto maior o slider, maior o alcance!")
end

function Hitbox:Stop()
    if self.Connection then
        self.Connection:Disconnect()
        self.Connection = nil
    end
    
    print("❌ Hitbox desativado")
end

function Hitbox:Update()
    if Config.HitboxEnabled then
        self:Start()
    else
        self:Stop()
    end
end

-- Sistema de Aimbot
local Aimbot = {}
Aimbot.Target = nil

function Aimbot:GetTarget()
    local ball = Utils:GetBall()
    
    if not ball then return nil end
    
    -- Verificar se está no FOV
    if not Utils:IsInFOV(ball.Position, Config.AimbotFOV) then
        return nil
    end
    
    return ball
end

function Aimbot:AimAt(target)
    if not target then return end
    
    local rootPart = Utils:GetRootPart()
    if not rootPart then return end
    
    local targetPos = target.Position
    
    -- Aplicar predição
    if Config.AimbotPrediction then
        local predictedPos = Utils:PredictBallPosition(target, 0.2)
        if predictedPos then
            targetPos = predictedPos
        end
    end
    
    -- Calcular direção
    local direction = (targetPos - rootPart.Position).Unit
    local targetCFrame = CFrame.new(rootPart.Position, rootPart.Position + direction)
    
    -- Aplicar suavização (legit)
    local currentCFrame = rootPart.CFrame
    local smoothedCFrame = currentCFrame:Lerp(targetCFrame, Config.AimbotSmoothing)
    
    -- Aplicar rotação
    rootPart.CFrame = CFrame.new(rootPart.Position) * (smoothedCFrame - smoothedCFrame.Position)
end

function Aimbot:Update()
    if not Config.AimbotEnabled then return end
    
    self.Target = self:GetTarget()
    
    if self.Target then
        self:AimAt(self.Target)
    end
end

-- Sistema de Auto Features
local Auto = {}

function Auto:Serve()
    if not Config.AutoServeEnabled then return end
    
    -- Implementar lógica de auto serve
    -- Isso depende de como o jogo funciona
    Utils:HumanWait()
    
    -- Exemplo genérico:
    local args = {
        [1] = "Serve"
    }
    
    pcall(function()
        -- Procurar pelo remote de serve
        local remote = ReplicatedStorage:FindFirstChild("ServeRemote") or
                      ReplicatedStorage:FindFirstChild("Serve")
        
        if remote and remote:IsA("RemoteEvent") then
            remote:FireServer(unpack(args))
        end
    end)
end

function Auto:Block()
    if not Config.AutoBlockEnabled then return end
    
    local ball = Utils:GetBall()
    if not ball then return end
    
    local rootPart = Utils:GetRootPart()
    if not rootPart then return end
    
    -- Verificar distância
    local distance = (ball.Position - rootPart.Position).Magnitude
    
    if distance < 15 then -- Distância para bloquear
        wait(Config.AutoBlockTiming) -- Delay humanizado
        
        -- Disparar remote de block
        pcall(function()
            local remote = ReplicatedStorage:FindFirstChild("BlockRemote") or
                          ReplicatedStorage:FindFirstChild("Block")
            
            if remote and remote:IsA("RemoteEvent") then
                remote:FireServer()
            end
        end)
    end
end

-- Anti-AFK
local function setupAntiAFK()
    if not Config.AntiAFK then return end
    
    local VirtualUser = game:GetService("VirtualUser")
    
    LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
    
    print("✅ Anti-AFK ativado")
end

-- Loop principal (SUPER OTIMIZADO - SEM LAG)
local function mainLoop()
    -- Loop de Aimbot (moderado - 20 FPS)
    spawn(function()
        while wait(0.05) do
            if Config.AimbotEnabled then
                pcall(function()
                    Aimbot:Update()
                end)
            else
                wait(0.5) -- Esperar mais quando desativado
            end
        end
    end)
    
    -- Loop de ESP (lento - atualiza a cada 2 segundos para não piscar)
    spawn(function()
        while wait(2) do
            if Config.BallESPEnabled or Config.PlayerESPEnabled then
                pcall(function()
                    if Config.BallESPEnabled then
                        ESP:UpdateBallESP()
                    end
                    if Config.PlayerESPEnabled then
                        ESP:UpdatePlayerESP()
                    end
                end)
            else
                wait(3) -- Esperar mais quando desativado
            end
        end
    end)
    
    -- Loop de auto features (muito lento)
    spawn(function()
        while wait(1) do
            if Config.AutoServeEnabled or Config.AutoBlockEnabled then
                pcall(function()
                    if Config.AutoServeEnabled then
                        Auto:Serve()
                    end
                    if Config.AutoBlockEnabled then
                        Auto:Block()
                    end
                end)
            else
                wait(2) -- Esperar mais quando desativado
            end
        end
    end)
    
    print("✅ Loops otimizados iniciados")
end

-- Notificações
local function notify(title, message, duration)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = message,
        Duration = duration or 3
    })
end

-- Inicialização
local function initialize()
    -- Configurar anti-AFK
    setupAntiAFK()
    
    -- Iniciar loop principal
    mainLoop()
    
    -- Notificar sucesso
    notify(
        "Volleyball Legends",
        "Script carregado! Pressione INSERT para abrir o menu.",
        5
    )
    
    print("╔════════════════════════════════════╗")
    print("║   SCRIPT CARREGADO COM SUCESSO!    ║")
    print("╚════════════════════════════════════╝")
end

-- Exportar configurações para GUI
_G.VolleyballConfig = Config
_G.VolleyballESP = ESP
_G.VolleyballHitbox = Hitbox
_G.VolleyballAimbot = Aimbot

-- Inicializar
initialize()

return true
