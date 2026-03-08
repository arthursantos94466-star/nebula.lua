-- [[ NEBULA HUB V6 - DEFINITIVE EDITION ]] --
if not game:IsLoaded() then game.Loaded:Wait() end
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Nebula Hub | V6 FINAL",
    LoadingTitle = "Carregando Sistemas...",
    LoadingSubtitle = "ESP Style & Touch TP",
    ConfigurationSaving = {Enabled = false}
})

-- SERVIÇOS
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting") -- ADICIONADO PARA FULLBRIGHT

local Vars = {
    Aimbot = false, Smoothness = 0.2, Fov = 100, FovVis = false,
    EspBox = false, EspInfo = false, 
    Ws = 16, Jp = 50, Fly = false, FlySpeed = 2,
    FullBright = false
}

-- SALVAR ILUMINAÇÃO ORIGINAL
local OriginalLighting = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    FogEnd = Lighting.FogEnd,
    GlobalShadows = Lighting.GlobalShadows,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient
}

-- FUNÇÃO FULLBRIGHT
local function ApplyFullBright()
    Lighting.Brightness = 3
    Lighting.ClockTime = 14
    Lighting.FogEnd = 100000
    Lighting.GlobalShadows = false
    Lighting.Ambient = Color3.fromRGB(255,255,255)
    Lighting.OutdoorAmbient = Color3.fromRGB(255,255,255)
end

local function ResetLighting()
    for i,val in pairs(OriginalLighting) do
        Lighting[i] = val
    end
end

-- SISTEMA DE TELEPORTE POR TOQUE
local function CreateTPTool()
    local tool = Instance.new("Tool")
    tool.Name = "Teleport Tool"
    tool.RequiresHandle = false
    tool.Parent = LP.Backpack

    tool.Activated:Connect(function()
        local mouse = LP:GetMouse()
        if mouse.Target and LP.Character then
            LP.Character:MoveTo(mouse.Hit.p)
        end
    end)
end

-- FUNÇÃO PARA CALCULAR ALVO MAIS PRÓXIMO
local function GetClosest()
    local target = nil
    local dist = Vars.Fov
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            if p.Character:FindFirstChildOfClass("Humanoid") and p.Character.Humanoid.Health <= 0 then continue end
            local pos, screen = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if screen then
                local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                if mag < dist then
                    target = p.Character.HumanoidRootPart
                    dist = mag
                end
            end
        end
    end
    return target
end

-- SISTEMA DE ESP NATIVO
local function CreateESP(p)
    local box = Drawing.new("Square")
    local healthBar = Drawing.new("Line")
    local info = Drawing.new("Text")
    
    local function Update()
        local c = RS.RenderStepped:Connect(function()
            if Vars.EspBox and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p ~= LP then
                local root = p.Character.HumanoidRootPart
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                local pos, screen = Camera:WorldToViewportPoint(root.Position)
                
                if screen and hum then
                    local sizeX = 2000 / pos.Z
                    local sizeY = 3000 / pos.Z
                    local x = pos.X - sizeX / 2
                    local y = pos.Y - sizeY / 2
                    
                    box.Visible = true
                    box.Color = Color3.new(1, 1, 1)
                    box.Size = Vector2.new(sizeX, sizeY)
                    box.Position = Vector2.new(x, y)
                    box.Thickness = 1
                    
                    healthBar.Visible = true
                    healthBar.Color = Color3.fromRGB(0, 255, 0)
                    healthBar.Thickness = 2
                    healthBar.From = Vector2.new(x - 5, y + sizeY)
                    healthBar.To = Vector2.new(x - 5, y + sizeY - (sizeY * (hum.Health / hum.MaxHealth)))
                    
                    local dist = math.floor((LP.Character.HumanoidRootPart.Position - root.Position).Magnitude)
                    info.Visible = true
                    info.Text = string.format("%s\n[%d m]", p.Name, dist)
                    info.Size = 14
                    info.Center = true
                    info.Outline = true
                    info.Position = Vector2.new(pos.X, y + sizeY + 5)
                else
                    box.Visible = false
                    healthBar.Visible = false
                    info.Visible = false
                end
            else
                box.Visible = false
                healthBar.Visible = false
                info.Visible = false
                if not p.Parent then 
                    box:Remove() healthBar:Remove() info:Remove() 
                end
            end
        end)
    end
    coroutine.wrap(Update)()
end

-- INTERFACE RAYFIELD
local TabCombat = Window:CreateTab("Combat")
TabCombat:CreateToggle({Name = "Aimbot (Mira Suave)", CurrentValue = false, Callback = function(v) Vars.Aimbot = v end})
TabCombat:CreateSlider({Name = "Suavidade (Aimbot)", Range = {0, 1}, Increment = 0.1, CurrentValue = 0.2, Callback = function(v) Vars.Smoothness = v end})

local TabVisuals = Window:CreateTab("Visuals")
TabVisuals:CreateToggle({Name = "ESP Box (Simples)", CurrentValue = false, Callback = function(v) Vars.EspBox = v end})

-- FULL BRIGHT
TabVisuals:CreateToggle({
    Name = "Full Bright (Optimized)",
    CurrentValue = false,
    Callback = function(v)
        Vars.FullBright = v
        if v then
            ApplyFullBright()
        else
            ResetLighting()
        end
    end
})

TabVisuals:CreateButton({
    Name = "Ativar ESP Universal (Avançado)",
    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Esp-universal-49905"))()
    end
})

local TabUtil = Window:CreateTab("Utility")
TabUtil:CreateButton({
    Name = "Ativar Fly GUI",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
    end
})

TabUtil:CreateButton({Name = "Pegar Item de Teleporte", Callback = function() CreateTPTool() end})
TabUtil:CreateSlider({Name = "Velocidade (WalkSpeed)", Range = {16, 250}, Increment = 1, CurrentValue = 16, Callback = function(v) Vars.Ws = v end})
TabUtil:CreateSlider({Name = "Pulo (JumpPower)", Range = {50, 500}, Increment = 1, CurrentValue = 50, Callback = function(v) Vars.Jp = v end})
TabUtil:CreateButton({
    Name = "Infinite Yield", 
    Callback = function() loadstring(game:HttpGet('https://raw.githubusercontent.com'))() end
})

-- PROTEÇÃO FULL BRIGHT (caso o jogo altere iluminação)
Lighting:GetPropertyChangedSignal("Brightness"):Connect(function() if Vars.FullBright then ApplyFullBright() end end)
Lighting:GetPropertyChangedSignal("ClockTime"):Connect(function() if Vars.FullBright then ApplyFullBright() end end)
Lighting:GetPropertyChangedSignal("FogEnd"):Connect(function() if Vars.FullBright then ApplyFullBright() end end)
Lighting:GetPropertyChangedSignal("GlobalShadows"):Connect(function() if Vars.FullBright then ApplyFullBright() end end)

-- LOOP PRINCIPAL
RS.RenderStepped:Connect(function()
    if Vars.Aimbot then
        local target = GetClosest()
        if target then
            local targetPos = CFrame.new(Camera.CFrame.Position, target.Position)
            Camera.CFrame = Camera.CFrame:Lerp(targetPos, Vars.Smoothness)
        end
    end
    
    if LP.Character and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid.WalkSpeed = Vars.Ws
        LP.Character.Humanoid.JumpPower = Vars.Jp
    end
end)

-- Inicializa ESP Nativo
for _, p in pairs(Players:GetPlayers()) do CreateESP(p) end
Players.PlayerAdded:Connect(CreateESP)

Rayfield:Notify({Title = "Nebula V6", Content = "Sistemas Prontos!", Duration = 5})
