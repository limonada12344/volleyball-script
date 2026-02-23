-- CAPTURADOR DE HITBOX - ENGENHARIA REVERSA EXTREMA
-- Execute ESTE script PRIMEIRO, depois execute o Luarmor e ative o hitbox
-- Este script vai capturar TUDO que o Luarmor faz

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

print("=== CAPTURADOR DE HITBOX INICIADO ===")
print("Agora execute o script Luarmor e ative o hitbox")
print("Este script vai mostrar TUDO que acontece")

-- Encontrar a bola
local function findBall()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name == "Ball" and obj.Shape == Enum.PartType.Ball then
            return obj
        end
    end
end

local ball = findBall()
if not ball then
    warn("Bola não encontrada!")
    return
end

print("Bola encontrada:", ball:GetFullName())

-- Monitorar TODAS as propriedades da bola
local ballProperties = {
    "Size", "Position", "Velocity", "AssemblyLinearVelocity",
    "CanCollide", "Transparency", "Anchored", "Massless",
    "CustomPhysicalProperties"
}

for _, prop in ipairs(ballProperties) do
    local lastValue = ball[prop]
    RunService.Heartbeat:Connect(function()
        local currentValue = ball[prop]
        if currentValue ~= lastValue then
            print(string.format("[BOLA] %s mudou: %s -> %s", prop, tostring(lastValue), tostring(currentValue)))
            lastValue = currentValue
        end
    end)
end

-- Monitorar novos objetos criados na bola
ball.ChildAdded:Connect(function(child)
    print("[BOLA] Novo objeto adicionado:", child.Name, child.ClassName)
    if child:IsA("BodyMover") or child:IsA("Constraint") then
        print("  -> IMPORTANTE! Tipo:", child.ClassName)
        for _, prop in pairs(child:GetProperties()) do
            print("    Propriedade:", prop, "=", child[prop])
        end
    end
end)

-- Monitorar o HumanoidRootPart do jogador
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

print("HumanoidRootPart encontrado:", hrp:GetFullName())

-- Monitorar posição do jogador
local lastPlayerPos = hrp.Position
RunService.Heartbeat:Connect(function()
    local currentPos = hrp.Position
    local distance = (currentPos - lastPlayerPos).Magnitude
    
    if distance > 0.5 then -- Movimento significativo
        local ballDistance = (ball.Position - currentPos).Magnitude
        print(string.format("[PLAYER] Moveu %.2f studs | Distância da bola: %.2f", distance, ballDistance))
        lastPlayerPos = currentPos
    end
end)

-- Monitorar novos objetos no HumanoidRootPart
hrp.ChildAdded:Connect(function(child)
    print("[PLAYER] Novo objeto no HumanoidRootPart:", child.Name, child.ClassName)
    if child:IsA("BodyMover") or child:IsA("Constraint") then
        print("  -> IMPORTANTE! Tipo:", child.ClassName)
        task.wait(0.1)
        for prop, value in pairs(child:GetAttributes()) do
            print("    Atributo:", prop, "=", value)
        end
    end
end)

-- Monitorar conexões de eventos (detectar quando algo conecta ao Heartbeat/RenderStepped)
local originalConnect = RunService.Heartbeat.Connect
RunService.Heartbeat.Connect = function(self, func)
    print("[EVENTO] Nova conexão ao Heartbeat detectada!")
    return originalConnect(self, func)
end

-- Monitorar distância bola-jogador constantemente
local lastDistance = 999
RunService.Heartbeat:Connect(function()
    local distance = (ball.Position - hrp.Position).Magnitude
    
    if math.abs(distance - lastDistance) > 5 then
        print(string.format("[DISTÂNCIA] Bola está a %.2f studs do jogador", distance))
        lastDistance = distance
    end
    
    -- Detectar quando o jogador se aproxima da bola rapidamente
    if distance < 30 and (hrp.Position - lastPlayerPos).Magnitude > 2 then
        print("!!! MOVIMENTO RÁPIDO EM DIREÇÃO À BOLA !!!")
        print("  Velocidade do HRP:", hrp.AssemblyLinearVelocity)
        print("  Posição da bola:", ball.Position)
        print("  Posição do player:", hrp.Position)
    end
end)

print("=== MONITORAMENTO ATIVO ===")
print("Execute o Luarmor agora e ative o hitbox")
print("Observe o console para ver o que acontece!")
