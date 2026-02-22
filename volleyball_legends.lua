--[[
    VOLLEYBALL LEGENDS - SPRING SYSTEM
    Versão: 4.0.0 - DEFINITIVA
    Sistema: Spring Physics (Lei de Hooke)
    
    ESTE É O MÉTODO QUE O STERLING USA!
    
    Movimento SUAVE e NATURAL usando física de mola.
    Muito melhor que força bruta!
]]

-- Verificar se já está carregado
if _G.VolleyballLegendsLoaded then
    warn("⚠️ Script já está carregado!")
    return
end

_G.VolleyballLegendsLoaded = true

print("╔════════════════════════════════════╗")
print("║   VOLLEYBALL LEGENDS - SPRING      ║")
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

-- ═══════════════════════════════════════════════════════════
-- SPRING SYSTEM (Lei de Hooke)
-- ═══════════════════════════════════════════════════════════
local Spring = {}
Spring.__index = Spring

function Spring.new(initial)
    local p0 = initial or Vector3.zero
    
    return setmetatable({
        _clock = tick,
        _time0 = tick(),
        _position0 = p0,
        _velocity0 = Vector3.zero,
        _target = p0,
        _damper = 1,
        _speed = 1,
    }, Spring)
end

function Spring:_positionVelocity(now)
    local p0 = self._position0
    local v0 = self._velocity0
    local p1 = self._target
    local d = self._damper
    local s = self._speed
    
    local t = s * (now - self._time0)
    local d2 = d * d
    
    local h, si, co
    if d2 < 1 then
        h = math.sqrt(1 - d2)
        local ep = math.exp(-d * t) / h
        co, si = ep * math.cos(h * t), ep * math.sin(h * t)
    elseif d2 == 1 then
        h = 1
        local ep = math.exp(-d * t) / h
        co, si = ep, ep * t
    else
        h = math.sqrt(d2 - 1)
        local u = math.exp((-d + h) * t) / (2 * h)
        local v = math.exp((-d - h) * t) / (2 * h)
        co, si = u + v, u - v
    end
    
    local a0 = h * co + d * si
    local a1 = 1 - (h * co + d * si)
    local a2 = si / s
    
    local b0 = -s * si
    local b1 = s * si
    local b2 = h * co - d * si
    
    return a0 * p0 + a1 * p1 + a2 * v0,
           b0 * p0 + b1 * p1 + b2 * v0
end

function Spring:SetTarget(value)
    local now = tick()
    local position, velocity = self:_positionVelocity(now)
    self._position0 = position
    self._velocity0 = velocity
    self._target = value
    self._time0 = now
end

function Spring:GetPosition()
    local position, _ = self:_positionVelocity(tick())
    return position
end

function Spring:SetSpeed(speed)
    local now = tick()
    local position, velocity = self:_positionVelocity(now)
    self._position0 = position
    self._velocity0 = velocity
    self._speed = math.max(0, speed)
    self._time0 = now
end

function Spring:SetDamper(damper)
    local now = tick()
    local position, velocity = self:_positionVelocity(now)
    self._position0 = position
    self._velocity0 = velocity
    self._damper = damper
    self._time0 = now
end

-- Configurações
local Config = {
    -- Aimbot
    AimbotEnabled = false,
    AimbotFOV = 200,
    AimbotSmoothing = 0.15,
    AimbotPrediction = true,
    
    -- Hitbox (Spring)
    HitboxEnabled = false,
    HitboxSize = 15,
    HitboxSpeed = 20, -- Velocidade da mola (quanto maior, mais rápido)
    HitboxDamper = 0.5, -- Amortecimento (< 1 = bounce, 1 = crítico, > 1 = lento)
    
    -- ESP
    BallESPEnabled = false,
    PlayerESPEnabled = false,
    ESPColor = Color3.fromRGB(255, 0, 0),
    
    -- Auto Features
    AutoServeEnabled = false,
    AutoBlockEnabled = false,
    AutoBlockTiming = 0.3,
    
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

-- Cache da bola
local cachedBall = nil
local lastBallCheck = 0

function Utils:GetBall()
    local currentTime = tick()
    if cachedBall and cachedBall.Parent and (currentTime - lastBallCheck) < 1 then
        return cachedBall
    end
    
    lastBallCheck = currentTime
    
    local ball = Workspace:FindFirstChild("Ball") or 
                 Workspace:FindFirstChild("Volleyball") or
                 Workspace:FindFirstChild("ball") or
                 Workspace:FindFirstChild("VolleyBall")
    
    if not ball then
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
    
    local gravity = Vector3.new(0, -196.2, 0)
    local predictedPos = currentPos + (velocity * time) + (0.5 * gravity * time * time)
    
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
        if self.Objects[ball] then
            pcall(function()
                self.Objects[ball].FillColor = Color3.fromRGB(255, 255, 0)
                self.Objects[ball].OutlineColor = Color3.fromRGB(255, 200, 0)
            end)
        else
            self:CreateBallESP(ball)
        end
    end
end

function ESP:UpdatePlayerESP()
    if not Config.PlayerESPEnabled then
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

-- Sistema de Hitbox SPRING (DEFINITIVO!)
local Hitbox = {}
Hitbox.Connection = nil
Hitbox.PositionSpring = nil

function Hitbox:Start()
    if self.Connection then return end
    
    print("🎯 Iniciando Hitbox Extender SPRING...")
    print("💡 Usando física de mola (Lei de Hooke)")
    
    -- Criar spring para posição suave
    local hrp = Utils:GetRootPart()
    if hrp then
        self.PositionSpring = Spring.new(hrp.Position)
        self.PositionSpring:SetSpeed(Config.HitboxSpeed)
        self.PositionSpring:SetDamper(Config.HitboxDamper)
    end
    
    -- Usar RenderStepped para máxima suavidade
    self.Connection = RunService.RenderStepped:Connect(function()
        if not Config.HitboxEnabled then return end
        
        local char = Utils:GetCharacter()
        if not char then return end
        
        local hrp = Utils:GetRootPart()
        if not hrp then return end
        
        local ball = Utils:GetBall()
        if not ball then return end
        
        -- Calcular distância
        local distance = (ball.Position - hrp.Position).Magnitude
        
        -- Raio de ação (slider * 4 para bom alcance)
        local actionRadius = Config.HitboxSize * 4
        
        -- Se a bola está dentro do raio
        if distance <= actionRadius and distance > 2 then
            -- Predição: onde a bola VAI estar
            local targetPos = ball.Position
            local predictedPos = Utils:PredictBallPosition(ball, 0.15)
            if predictedPos then
                targetPos = predictedPos
            end
            
            -- Calcular posição alvo (perto da bola)
            local direction = (targetPos - hrp.Position).Unit
            local desiredPos = targetPos - (direction * 3) -- 3 studs da bola
            
            -- Atualizar spring target
            if not self.PositionSpring then
                self.PositionSpring = Spring.new(hrp.Position)
                self.PositionSpring:SetSpeed(Config.HitboxSpeed)
                self.PositionSpring:SetDamper(Config.HitboxDamper)
            end
            
            self.PositionSpring:SetTarget(desiredPos)
            
            -- Obter posição suave do spring
            local smoothPos = self.PositionSpring:GetPosition()
            
            -- Aplicar movimento SUAVE
            pcall(function()
                -- Movimento suave via spring
                hrp.CFrame = CFrame.new(smoothPos)
                
                -- Velocity adicional para ajudar
                local velocityDir = (smoothPos - hrp.Position).Unit
                hrp.AssemblyLinearVelocity = velocityDir * Config.HitboxSpeed
            end)
        else
            -- Fora do raio: spring volta para posição atual
            if self.PositionSpring then
                self.PositionSpring:SetTarget(hrp.Position)
            end
        end
    end)
    
    print("✅ Hitbox SPRING ativado!")
    print("📏 Raio:", Config.HitboxSize * 4, "studs")
    print("⚡ Speed:", Config.HitboxSpeed, "| Damper:", Config.HitboxDamper)
    print("🌊 Movimento SUAVE e NATURAL!")
end

function Hitbox:Stop()
    if self.Connection then
        self.Connection:Disconnect()
        self.Connection = nil
    end
    
    self.PositionSpring = nil
    
    print("❌ Hitbox desativado")
end

function Hitbox:Update()
    if Config.HitboxEnabled then
        self:Start()
    else
        self:Stop()
    end
end

function Hitbox:UpdateSettings()
    if self.PositionSpring then
        self.PositionSpring:SetSpeed(Config.HitboxSpeed)
        self.PositionSpring:SetDamper(Config.HitboxDamper)
        print("🔧 Spring atualizado: Speed =", Config.HitboxSpeed, "| Damper =", Config.HitboxDamper)
    end
end

-- Sistema de Aimbot
local Aimbot = {}
Aimbot.Target = nil

function Aimbot:GetTarget()
    local ball = Utils:GetBall()
    
    if not ball then return nil end
    
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
    
    if Config.AimbotPrediction then
        local predictedPos = Utils:PredictBallPosition(target, 0.2)
        if predictedPos then
            targetPos = predictedPos
        end
    end
    
    local direction = (targetPos - rootPart.Position).Unit
    local targetCFrame = CFrame.new(rootPart.Position, rootPart.Position + direction)
    
    local currentCFrame = rootPart.CFrame
    local smoothedCFrame = currentCFrame:Lerp(targetCFrame, Config.AimbotSmoothing)
    
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
    
    Utils:HumanWait()
    
    local args = {
        [1] = "Serve"
    }
    
    pcall(function()
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
    
    local distance = (ball.Position - rootPart.Position).Magnitude
    
    if distance < 15 then
        wait(Config.AutoBlockTiming)
        
        pcall(function()
            local remote = ReplicatedStorage:FindFirstChild("BlockRemote") or
                          ReplicatedStorage:FindFirstChild("Block")
            
            if remote and remote:IsA("RemoteEvent") then
                remote:FireServer()
            end
        end)
    end
end

-- Anti-AFK (Napoleon Style)
local function setupAntiAFK()
    if not Config.AntiAFK then return end
    
    local getconnections = getconnections or get_signal_cons
    if getconnections then
        for i, v in pairs(getconnections(LocalPlayer.Idled)) do
            if v["Disable"] then
                v["Disable"](v)
            elseif v["Disconnect"] then
                v["Disconnect"](v)
            end
        end
        print("✅ Anti-AFK ativado (Napoleon Style)")
    else
        local VirtualUser = game:GetService("VirtualUser")
        
        LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
        
        print("✅ Anti-AFK ativado (VirtualUser)")
    end
end

-- Loop principal
local function mainLoop()
    -- Loop de Aimbot
    spawn(function()
        while wait(0.05) do
            if Config.AimbotEnabled then
                pcall(function()
                    Aimbot:Update()
                end)
            else
                wait(0.5)
            end
        end
    end)
    
    -- Loop de ESP
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
                wait(3)
            end
        end
    end)
    
    -- Loop de auto features
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
                wait(2)
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
    setupAntiAFK()
    mainLoop()
    
    notify(
        "Volleyball Legends",
        "Spring System carregado! Pressione INSERT.",
        5
    )
    
    print("╔════════════════════════════════════╗")
    print("║   SPRING SYSTEM - CARREGADO!       ║")
    print("║   Movimento SUAVE e NATURAL!       ║")
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
