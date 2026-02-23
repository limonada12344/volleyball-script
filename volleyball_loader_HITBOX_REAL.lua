-- LOADER PARA HITBOX REAL
-- Carrega o script de hitbox verdadeiro + GUI

print("🔄 Carregando Volleyball Hitbox Real...")

-- Carrega o script principal primeiro
local success1, result1 = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/limonada12344/volleyball-script/refs/heads/main/volleyball_legends_HITBOX_VERDADEIRO.lua"))()
end)

if not success1 then
    warn("❌ Erro ao carregar script principal:", result1)
    return
end

print("✅ Script principal carregado")

-- Aguarda um pouco
wait(1)

-- Carrega a GUI
local success2, result2 = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/limonada12344/volleyball-script/refs/heads/main/volleyball_gui_HITBOX_REAL.lua"))()
end)

if not success2 then
    warn("❌ Erro ao carregar GUI:", result2)
    return
end

print("✅ GUI carregada")
print("🎮 Pressione INSERT para abrir a interface")
print("🎯 TESTE: Ative o hitbox e tente bater na bola de longe!")

return true