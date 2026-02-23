-- LOADER SIMPLES - BASEADO NO CHATGPT
-- Método mais direto e funcional

print("📦 Carregando HITBOX SIMPLES...")
print("🤖 Baseado no código do ChatGPT!")
print("✨ Método: Parte invisível + Touched event")

-- Carrega o script principal
local success1, result1 = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/limonada12344/volleyball-script/refs/heads/main/volleyball_hitbox_SIMPLES_FUNCIONAL.lua"))()
end)

if not success1 then
    warn("❌ Erro ao carregar Hitbox Simples:", result1)
    return
end

print("✅ Hitbox Simples carregado")

-- Aguarda um pouco
wait(1)

-- Carrega a GUI
local success2, result2 = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/limonada12344/volleyball-script/refs/heads/main/volleyball_gui_SIMPLES.lua"))()
end)

if not success2 then
    warn("❌ Erro ao carregar GUI:", result2)
    return
end

print("✅ GUI carregada")
print("")
print("🎮 COMO USAR:")
print("1. Pressione INSERT para abrir a GUI")
print("2. Ative 'HITBOX: ON'")
print("3. Ajuste o tamanho (padrão: 8)")
print("4. Entre numa partida")
print("5. Se aproxime da bola - a hitbox detecta automaticamente!")
print("")
print("📦 COMO FUNCIONA:")
print("- Cria uma parte invisível na sua frente")
print("- Quando a bola toca essa parte, dispara o hit")
print("- Método mais simples e direto possível")
print("- Baseado no código que o ChatGPT fez")
print("")
print("🎯 VANTAGENS:")
print("- Muito simples de entender")
print("- Usa eventos nativos do Roblox (Touched)")
print("- Não depende de loops complexos")
print("- Funciona com qualquer RemoteEvent")
print("")
print("📦 HITBOX SIMPLES ATIVO!")
print("🤖 Obrigado ChatGPT pela inspiração!")

return true