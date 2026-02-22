--[[
    VOLLEYBALL LEGENDS - LOADER
    
    Execute este script no Velocity/Xeno:
     loadstring(game:HttpGet("URL_DESTE_ARQUIVO"))()
]]

-- Verificar se está no jogo certo
local gameId = game.PlaceId

-- IDs do Volleyball Legends (você precisa verificar o ID correto)
local validGameIds = {
    -- Adicione os IDs corretos aqui
    -- Exemplo: 123456789
}

-- Função para verificar jogo (descomente quando tiver os IDs)
--[[
local function isCorrectGame()
    for _, id in ipairs(validGameIds) do
        if gameId == id then
            return true
        end
    end
    return false
end

if not isCorrectGame() then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "❌ Erro",
        Text = "Este script é apenas para Volleyball Legends!",
        Duration = 5
    })
    return
end
]]

-- Verificar se já está carregado
if _G.VolleyballLegendsLoaded then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "⚠️ Aviso",
        Text = "Script já está carregado!",
        Duration = 3
    })
    return
end

-- Notificação de carregamento
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "🏐 Volleyball Legends",
    Text = "Carregando script...",
    Duration = 3
})

print("╔════════════════════════════════════╗")
print("║  VOLLEYBALL LEGENDS - CARREGANDO   ║")
print("╚════════════════════════════════════╝")

-- Carregar script principal
local success1, err1 = pcall(function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/limonada12344/volleyball-script/refs/heads/main/volleyball_legends.lua"))()
end)

if not success1 then
    warn("❌ Erro ao carregar script principal:", err1)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "❌ Erro",
        Text = "Falha ao carregar script principal!",
        Duration = 5
    })
    return
end

wait(1)

-- Carregar GUI
local success2, err2 = pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/limonada12344/volleyball-script/refs/heads/main/volleyball_gui.lua"))()
end)

if not success2 then
    warn("❌ Erro ao carregar GUI:", err2)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "❌ Erro",
        Text = "Falha ao carregar GUI!",
        Duration = 5
    })
    return
end

-- Sucesso
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "✅ Sucesso",
    Text = "Script carregado! Pressione INSERT para abrir.",
    Duration = 5
})

print("╔════════════════════════════════════╗")
print("║     CARREGADO COM SUCESSO!         ║")
print("║   Pressione INSERT para abrir      ║")
print("╚════════════════════════════════════╝")



