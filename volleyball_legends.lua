--[[
    VOLLEYBALL LEGENDS - VERSÃO FINAL
    Versão: 7.0.0 - TELEPORTE AGRESSIVO
    
    Método: Detecção de distância + Teleporte direto
    SEM hitbox part, SEM física, APENAS teleporte!
]]

if _G.VolleyballLegendsLoaded then
    warn("⚠️ Script já está carregado!")
    return
end

_G.VolleyballLegendsLoaded = true

print("╔════════════════════════════════════╗")
print("║   VOLLEYBALL LEGENDS - FINAL       ║")
print("╚════════════════════════════════════╝")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local Config = {
    AimbotEnabled = false,
    AimbotFOV = 200,
    AimbotSmoothing = 0.15,
    AimbotPrediction = true,
    
    HitboxEnabled = false,
    HitboxSize = 30,
    
    BallESPEnabled = false,
    PlayerESPEnabled = false,
    ESPColor = Color3.fromRGB(255, 0, 0),
    
    AutoServeEnabled = false,
    AutoBlockEnabled = false,
    AutoBlockTiming = 0.3,
    
    AntiAFK = true,
    ShowStats = false,
    
    RandomizeDelay = true,
    MinDelay = 0.05,
    MaxDelay = 0.15
}

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

-- ESP
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

-- HITBOX FINAL - TELEPORTE DIRETO E AGRESSIVO!
local Hitbox = {}
Hitbox.Connection = nil
Hitbox.LastTeleport = 0

function Hitbox:Start()
    if self.Connection then return end
    
    print("🎯 Iniciando Hitbox FINAL...")
    print("💥 TELEPORTE DIRETO - MÁXIMA AGRESSIVIDADE!")
    
    -- Usar RenderStepped para máxima velocidade
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
        
        -- Alcance baseado no slider
        local actionRadius = Config.HitboxSize
        
        -- Se a bola está dentro do alcance
        if distance <= actionRadius and distance > 1 then
            -- Cooldown de 0.1s entre teleportes (evita spam)
            local currentTime = tick()
            if (currentTime - self.LastTeleport) < 0.1 then
                return
            end
            
            self.LastTeleport = currentTime
            
            -- Direção para a bola
            local direction = (ball.Position - hrp.Position).Unit
            
            -- Posição alvo: 1.5 studs da bola
            local targetPos = ball.Position - (direction * 1.5)
            
            -- TELEPORTE DIRETO!
            pcall(function()
                -- Método 1: Teleporte CFrame
                hrp.CFrame = CFrame.new(targetPos, ball.Position)
                
                -- Método 2: Zerar velocidade
                hrp.AssemblyLinearVelocity = Vector3.zero
                
                -- Método 3: Aplicar velocidade na direção da bola
                task.wait(0.01)
                hrp.AssemblyLinearVelocity = direction * 80
                
                -- Debug
                print("💥 TELEPORTADO! Distância:", math.floor(distance), "studs")
            end)
        end
    end)
    
    print("✅ Hitbox FINAL ativado!")
    print("📏 Alcance:", Config.HitboxSize, "studs")
    print("⚡ Teleporte direto quando bola entrar no alcance!")
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

-- Aimbot
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

-- Auto Features
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

-- Anti-AFK
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

-- Main Loop
local function mainLoop()
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
        "VERSÃO FINAL carregada! Pressione INSERT.",
        5
    )
    
    print("╔════════════════════════════════════╗")
    print("║   VERSÃO FINAL - CARREGADO!        ║")
    print("║   Teleporte direto e agressivo!    ║")
    print("╚════════════════════════════════════╝")
end

_G.VolleyballConfig = Config
_G.VolleyballESP = ESP
_G.VolleyballHitbox = Hitbox
_G.VolleyballAimbot = Aimbot

initialize()

return true
