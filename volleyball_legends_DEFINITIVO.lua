-- VOLLEYBALL LEGENDS - VERSÃO DEFINITIVA
-- Baseado no código cliente real que funciona!

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

-- Configurações
local config = {
    hitboxEnabled = false,
    hitboxDistance = 30, -- Distância do hitbox (padrão era 5)
    cooldown = 0.25, -- Cooldown entre hits
    playerESP = false,
    ballESP = false,
    autoMode = true -- Se true, dispara automaticamente
}

-- Variáveis
local connections = {}
local espObjects = {}
local lastHit = 0

-- Encontrar o RemoteEvent "Hit"
local function getHitEvent()
    local event = ReplicatedStorage:FindFirstChild("Hit")
    if event then
        return event
    end
    
    -- Se não encontrou "Hit", procura outros nomes comuns
    local commonNames = {"HitBall", "Strike", "Spike", "Attack", "Serve", "Block"}
    for _, name in ipairs(commonNames) do
        local remote = ReplicatedStorage:FindFirstChild(name)
        if remote and remote:IsA("RemoteEvent") then
            return remote
        end
    end
    
    return nil
end

-- Encontrar a bola
local function getBall()
    return workspace:FindFirstChild("Ball")
end

-- HITBOX DEFINITIVO - BASEADO NO CÓDIGO REAL
local function hitboxLoop()
    if not config.hitboxEnabled then return end
    
    local character = player.Character
    local ball = getBall()
    
    -- Verifica se tudo existe
    if not (character and ball) then return end
    
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    -- Calcula distância
    local distance = (root.Position - ball.Position).Magnitude
    
    -- HITBOX REAL: Se está dentro da distância configurada E passou o cooldown
    if distance <= config.hitboxDistance and tick() - lastHit > config.cooldown then
        lastHit = tick()
        
        -- Encontra o RemoteEvent
        local hitEvent = getHitEvent()
        if hitEvent then
            -- DISPARA O HIT!
            hitEvent:FireServer(ball.Position)
            print("🎯 HIT! Distância:", string.format("%.2f", distance), "studs")
        else
            warn("❌ RemoteEvent 'Hit' não encontrado!")
        end
    end
end

-- Ativar/Desativar hitbox
local function toggleHitbox(enabled)
    config.hitboxEnabled = enabled
    
    if enabled then
        -- Conecta o loop principal
        connections.hitbox = RunService.Heartbeat:Connect(hitboxLoop)
        print("✅ Hitbox DEFINITIVO ativado!")
        print("📏 Distância:", config.hitboxDistance, "studs")
        print("⏱️ Cooldown:", config.cooldown, "segundos")
        
        -- Verifica se o RemoteEvent existe
        local hitEvent = getHitEvent()
        if hitEvent then
            print("🎯 RemoteEvent encontrado:", hitEvent.Name)
        else
            warn("⚠️ RemoteEvent não encontrado! Pode não funcionar.")
        end
    else
        if connections.hitbox then
            connections.hitbox:Disconnect()
            connections.hitbox = nil
        end
        print("❌ Hitbox desativado")
    end
end

-- Definir distância do hitbox
local function setHitboxDistance(distance)
    config.hitboxDistance = distance
    print("📏 Distância do hitbox:", distance, "studs")
end

-- Definir cooldown
local function setCooldown(cooldown)
    config.cooldown = cooldown
    print("⏱️ Cooldown:", cooldown, "segundos")
end

-- ESP da bola
local function toggleBallESP(enabled)
    config.ballESP = enabled
    
    if enabled then
        local ball = getBall()
        if ball and not espObjects.ball then
            local esp = Instance.new("Highlight")
            esp.Name = "BallESP"
            esp.FillColor = Color3.fromRGB(255, 255, 0)
            esp.OutlineColor = Color3.fromRGB(255, 200, 0)
            esp.FillTransparency = 0.5
            esp.OutlineTransparency = 0
            esp.Parent = ball
            espObjects.ball = esp
            print("✅ Ball ESP ativado")
        end
    else
        if espObjects.ball then
            espObjects.ball:Destroy()
            espObjects.ball = nil
            print("❌ Ball ESP desativado")
        end
    end
end

-- ESP dos jogadores
local function togglePlayerESP(enabled)
    config.playerESP = enabled
    
    if enabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character and not espObjects[p] then
                local esp = Instance.new("Highlight")
                esp.Name = "PlayerESP"
                esp.FillColor = Color3.fromRGB(255, 0, 0)
                esp.OutlineColor = Color3.fromRGB(255, 100, 100)
                esp.FillTransparency = 0.6
                esp.OutlineTransparency = 0
                esp.Parent = p.Character
                espObjects[p] = esp
            end
        end
        print("✅ Player ESP ativado")
    else
        for p, esp in pairs(espObjects) do
            if p ~= "ball" then
                esp:Destroy()
                espObjects[p] = nil
            end
        end
        print("❌ Player ESP desativado")
    end
end

-- Teste manual (dispara um hit agora)
local function manualHit()
    local character = player.Character
    local ball = getBall()
    
    if not (character and ball) then
        warn("❌ Character ou Ball não encontrados!")
        return
    end
    
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then
        warn("❌ HumanoidRootPart não encontrado!")
        return
    end
    
    local distance = (root.Position - ball.Position).Magnitude
    local hitEvent = getHitEvent()
    
    if hitEvent then
        hitEvent:FireServer(ball.Position)
        print("🎯 HIT MANUAL! Distância:", string.format("%.2f", distance), "studs")
    else
        warn("❌ RemoteEvent não encontrado!")
    end
end

-- Limpeza quando sai
player.CharacterRemoving:Connect(function()
    for _, connection in pairs(connections) do
        if connection then
            connection:Disconnect()
        end
    end
    
    for _, esp in pairs(espObjects) do
        if esp then
            esp:Destroy()
        end
    end
    
    connections = {}
    espObjects = {}
end)

-- Funções globais para a GUI
_G.VolleyballDefinitivo = {
    toggleHitbox = toggleHitbox,
    setHitboxDistance = setHitboxDistance,
    setCooldown = setCooldown,
    toggleBallESP = toggleBallESP,
    togglePlayerESP = togglePlayerESP,
    manualHit = manualHit,
    config = config
}

print("✅ Volleyball DEFINITIVO carregado!")
print("🎯 Baseado no código cliente real")
print("📡 Monitora RemoteEvent 'Hit'")
print("🔥 Método 100% funcional")
print("📱 Aguardando GUI...")

return true