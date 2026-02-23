-- HITBOX SIMPLES FUNCIONAL - BASEADO NO CHATGPT
-- Cria uma parte invisível que detecta toque com a bola

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

-- Configurações
local config = {
    hitboxEnabled = false,
    hitboxSize = 8, -- Tamanho da hitbox
    hitboxDistance = 3, -- Distância na frente do jogador
    playerESP = false,
    ballESP = false
}

-- Variáveis
local hitboxPart = nil
local connections = {}
local espObjects = {}
local lastHit = 0

-- Encontrar RemoteEvent
local function getHitEvent()
    local commonNames = {"Hit", "HitBall", "Strike", "Spike", "Attack", "Serve", "Block"}
    
    for _, name in ipairs(commonNames) do
        local remote = ReplicatedStorage:FindFirstChild(name)
        if remote and remote:IsA("RemoteEvent") then
            return remote
        end
    end
    
    -- Se não encontrou, pega o primeiro RemoteEvent
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            return obj
        end
    end
    
    return nil
end

-- Criar hitbox invisível
local function createHitbox()
    local character = player.Character
    if not character then return end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    -- Remove hitbox anterior
    if hitboxPart then
        hitboxPart:Destroy()
        hitboxPart = nil
    end
    
    -- Cria nova hitbox
    hitboxPart = Instance.new("Part")
    hitboxPart.Name = "HitboxPart"
    hitboxPart.Size = Vector3.new(config.hitboxSize, config.hitboxSize, config.hitboxSize)
    hitboxPart.Transparency = 1 -- Invisível
    hitboxPart.CanCollide = false
    hitboxPart.Anchored = true
    hitboxPart.Parent = workspace
    
    -- Posiciona na frente do jogador
    hitboxPart.CFrame = hrp.CFrame * CFrame.new(0, 0, -config.hitboxDistance)
    
    -- Detecta toque com a bola
    hitboxPart.Touched:Connect(function(hit)
        if hit.Name == "Ball" and tick() - lastHit > 0.25 then
            lastHit = tick()
            
            print("🎯 HITBOX TOCOU A BOLA!")
            
            -- Dispara o RemoteEvent
            local hitEvent = getHitEvent()
            if hitEvent then
                pcall(function()
                    hitEvent:FireServer(hit.Position)
                    print("✅ RemoteEvent disparado:", hitEvent.Name)
                end)
            else
                print("❌ RemoteEvent não encontrado")
            end
        end
    end)
    
    print("✅ Hitbox criada - Tamanho:", config.hitboxSize)
end

-- Atualizar posição da hitbox
local function updateHitboxPosition()
    if not config.hitboxEnabled or not hitboxPart then return end
    
    local character = player.Character
    if not character then return end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    -- Atualiza posição da hitbox para seguir o jogador
    hitboxPart.CFrame = hrp.CFrame * CFrame.new(0, 0, -config.hitboxDistance)
end

-- Ativar/Desativar hitbox
local function toggleHitbox(enabled)
    config.hitboxEnabled = enabled
    
    if enabled then
        createHitbox()
        
        -- Loop para atualizar posição
        connections.updatePosition = RunService.Heartbeat:Connect(updateHitboxPosition)
        
        -- Recria hitbox quando o personagem respawna
        connections.characterAdded = player.CharacterAdded:Connect(function()
            task.wait(1) -- Espera carregar
            createHitbox()
        end)
        
        print("✅ Hitbox ativada!")
    else
        -- Remove hitbox
        if hitboxPart then
            hitboxPart:Destroy()
            hitboxPart = nil
        end
        
        -- Desconecta loops
        for _, connection in pairs(connections) do
            if connection then
                connection:Disconnect()
            end
        end
        connections = {}
        
        print("❌ Hitbox desativada")
    end
end

-- Definir tamanho da hitbox
local function setHitboxSize(size)
    config.hitboxSize = size
    
    -- Atualiza hitbox existente
    if hitboxPart then
        hitboxPart.Size = Vector3.new(size, size, size)
    end
    
    print("📏 Tamanho da hitbox:", size)
end

-- Definir distância da hitbox
local function setHitboxDistance(distance)
    config.hitboxDistance = distance
    print("📏 Distância da hitbox:", distance)
end

-- ESP da bola
local function toggleBallESP(enabled)
    config.ballESP = enabled
    
    if enabled then
        local ball = workspace:FindFirstChild("Ball")
        if ball and not espObjects.ball then
            local esp = Instance.new("Highlight")
            esp.Name = "BallESP"
            esp.FillColor = Color3.fromRGB(255, 255, 0)
            esp.OutlineColor = Color3.fromRGB(255, 200, 0)
            esp.FillTransparency = 0.5
            esp.OutlineTransparency = 0
            esp.Parent = ball
            espObjects.ball = esp
        end
    else
        if espObjects.ball then
            espObjects.ball:Destroy()
            espObjects.ball = nil
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
    else
        for p, esp in pairs(espObjects) do
            if p ~= "ball" then
                esp:Destroy()
                espObjects[p] = nil
            end
        end
    end
end

-- Teste manual com Raycast (como no código do ChatGPT)
local function testRaycast()
    local character = player.Character
    if not character then return end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local origin = hrp.Position
    local direction = hrp.CFrame.LookVector * 20 -- 20 studs na frente
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    
    local result = workspace:Raycast(origin, direction, raycastParams)
    
    if result and result.Instance.Name == "Ball" then
        print("🎯 RAYCAST ACERTOU A BOLA!")
        
        local hitEvent = getHitEvent()
        if hitEvent then
            pcall(function()
                hitEvent:FireServer(result.Instance.Position)
                print("✅ RemoteEvent disparado via Raycast")
            end)
        end
    else
        print("❌ Raycast não acertou a bola")
    end
end

-- Limpeza quando sai
player.CharacterRemoving:Connect(function()
    if hitboxPart then
        hitboxPart:Destroy()
        hitboxPart = nil
    end
    
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
_G.VolleyballHitboxSimples = {
    toggleHitbox = toggleHitbox,
    setHitboxSize = setHitboxSize,
    setHitboxDistance = setHitboxDistance,
    toggleBallESP = toggleBallESP,
    togglePlayerESP = togglePlayerESP,
    testRaycast = testRaycast,
    config = config
}

print("✅ Hitbox SIMPLES FUNCIONAL carregado!")
print("🎯 Baseado no código do ChatGPT")
print("📦 Cria parte invisível que detecta toque")
print("📱 Aguardando GUI...")

return true