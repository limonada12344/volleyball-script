-- LOADER DEFINITIVO - VERSÃO FINAL
-- Baseado no código cliente real que funciona!

print("🔥 Carregando HITBOX DEFINITIVO...")
print("💯 Baseado no código cliente REAL!")
print("🎯 Método 100% funcional!")

-- Carrega o script principal
local success1, result1 = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/limonada12344/volleyball-script/refs/heads/main/volleyball_legends_DEFINITIVO.lua"))()
end)

if not success1 then
    warn("❌ Erro ao carregar script DEFINITIVO:", result1)
    return
end

print("✅ Script DEFINITIVO carregado")

-- Aguarda um pouco
wait(1)

-- Carrega a GUI
local success2, result2 = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/limonada12344/volleyball-script/refs/heads/main/volleyball_gui_DEFINITIVO.lua"))()
end)

if not success2 then
    warn("❌ Erro ao carregar GUI:", result2)
    return
end

print("✅ GUI carregada")
print("")
print("🎮 INSTRUÇÕES:")
print("1. Pressione INSERT para abrir a GUI")
print("2. Ative 'HITBOX: ON'")
print("3. Ajuste a distância (recomendado: 30-50)")
print("4. Entre numa partida")
print("5. Fique perto da bola (dentro da distância)")
print("6. O script dispara automaticamente o hit!")
print("")
print("🔥 COMO FUNCIONA:")
print("- Monitora a distância da bola constantemente")
print("- Quando você fica dentro da distância configurada")
print("- Dispara automaticamente o RemoteEvent 'Hit'")
print("- Cooldown de 0.25s para não spammar")
print("")
print("💡 BASEADO NO CÓDIGO REAL:")
print("- Mesmo método que os scripts funcionais usam")
print("- Apenas aumentamos a distância de 5 para 30+ studs")
print("- Funciona com o sistema original do jogo")
print("")
print("🎯 HITBOX DEFINITIVO ATIVO!")
print("🔥 ESTE É O MÉTODO QUE FUNCIONA!")

return true