--[[
    Nebula Hub - Fixed & Adapted
]]

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local UIS = game:GetService("UserInputService")

local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

---------------------------------------------------
-- VARIÁVEIS
---------------------------------------------------

local Vars = {
    WalkSpeed = 16,
    JumpPower = 50,
    InfiniteJump = false,
    Noclip = false,
    Hitbox = false,
    ESPEnabled = false,
    CarESP = false,
    WheelAimbot = false,
    SavedPosition = nil
}

---------------------------------------------------
-- FUNÇÕES
---------------------------------------------------

local function GetCharacter()
    return LP.Character
end

local function GetHumanoid()
    local char = GetCharacter()
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function GetRoot()
    local char = GetCharacter()
    return char and char:FindFirstChild("HumanoidRootPart")
end

---------------------------------------------------
-- UI
---------------------------------------------------

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "Hashiras Hub",
    LoadingTitle = "Hashiras Hub",
    LoadingSubtitle = "Hub em atualização",
    ConfigurationSaving = {Enabled = false}
})

local Combat = Window:CreateTab("Combate")
local Movement = Window:CreateTab("Movemento")
local Visuals = Window:CreateTab("Visuais")
local TeleportTab = Window:CreateTab("Teleporte")
local ServerTab = Window:CreateTab("Server")

---------------------------------------------------
-- COMBAT
---------------------------------------------------

Combat:CreateToggle({
    Name = "Hitbox Expander",
    CurrentValue = false,
    Callback = function(v)
        Vars.Hitbox = v
    end
})

Combat:CreateToggle({
    Name = "Wheel Aimbot",
    CurrentValue = false,
    Callback = function(v)
        Vars.WheelAimbot = v
    end
})

Combat:CreateButton({
    Name = "Aimbot External",
    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Aimbot-universal-111551"))()
    end
})

---------------------------------------------------
-- MOVEMENT
---------------------------------------------------

Movement:CreateSlider({
    Name = "WalkSpeed",
    Range = {16,300},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(v)
        Vars.WalkSpeed = v
    end
})

Movement:CreateSlider({
    Name = "JumpPower",
    Range = {50,400},
    Increment = 1,
    CurrentValue = 50,
    Callback = function(v)
        Vars.JumpPower = v
    end
})

Movement:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Callback = function(v)
        Vars.InfiniteJump = v
    end
})

Movement:CreateToggle({
    Name = "NoClip",
    CurrentValue = false,
    Callback = function(v)
        Vars.Noclip = v
    end
})

---------------------------------------------------
-- VISUALS
---------------------------------------------------

Visuals:CreateToggle({
    Name = "FullBright",
    CurrentValue = false,
    Callback = function(v)
        if v then
            Lighting.Ambient = Color3.fromRGB(255,255,255)
            Lighting.Brightness = 2
        else
            Lighting.Ambient = Color3.fromRGB(127,127,127)
            Lighting.Brightness = 1
        end
    end
})

Visuals:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Callback = function(v)
        Vars.ESPEnabled = v
    end
})

Visuals:CreateToggle({
    Name = "Car ESP",
    CurrentValue = false,
    Callback = function(v)
        Vars.CarESP = v
    end
})

---------------------------------------------------
-- TELEPORT PLAYERS
---------------------------------------------------

local PlayerList = {}
local SelectedPlayer = nil

local function UpdatePlayerList()

    PlayerList = {}

    for _,p in pairs(Players:GetPlayers()) do
        if p ~= LP then
            table.insert(PlayerList,p.Name)
        end
    end

end

UpdatePlayerList()

local PlayerDropdown = TeleportTab:CreateDropdown({
    Name = "Players",
    Options = PlayerList,
    CurrentOption = nil,
    Callback = function(opt)
        SelectedPlayer = opt
    end
})

TeleportTab:CreateButton({
    Name = "Update Player List",
    Callback = function()
        UpdatePlayerList()
        PlayerDropdown:Refresh(PlayerList)
    end
})

TeleportTab:CreateButton({
    Name = "Teleport To Player",
    Callback = function()

        if not SelectedPlayer then return end

        local target = Players:FindFirstChild(SelectedPlayer)

        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            GetRoot().CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
        end

    end
})

---------------------------------------------------
-- TELEPORT CARS
---------------------------------------------------

local CarList = {}
local SelectedCar = nil

local function UpdateCarList()

    CarList = {}

    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("VehicleSeat") then
            table.insert(CarList,v:GetFullName())
        end
    end

end

UpdateCarList()

local CarDropdown = TeleportTab:CreateDropdown({
    Name = "Cars",
    Options = CarList,
    CurrentOption = nil,
    Callback = function(opt)
        SelectedCar = opt
    end
})

TeleportTab:CreateButton({
    Name = "Update Car List",
    Callback = function()
        UpdateCarList()
        CarDropdown:Refresh(CarList)
    end
})

TeleportTab:CreateButton({
    Name = "Teleport Driver Seat",
    Callback = function()

        if not SelectedCar then return end

        local seat = workspace:FindFirstChild(SelectedCar,true)

        if seat then
            GetRoot().CFrame = seat.CFrame + Vector3.new(0,2,0)
        end

    end
})

---------------------------------------------------
-- SERVER
---------------------------------------------------

ServerTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        TeleportService:Teleport(game.PlaceId,LP)
    end
})

---------------------------------------------------
-- MOVEMENT LOOP (CORRIGIDO)
---------------------------------------------------

RunService.Heartbeat:Connect(function()

    local char = GetCharacter()
    local hum = GetHumanoid()

    if hum then

        hum.UseJumpPower = true

        if hum.WalkSpeed ~= Vars.WalkSpeed then
            hum.WalkSpeed = Vars.WalkSpeed
        end

        if hum.JumpPower ~= Vars.JumpPower then
            hum.JumpPower = Vars.JumpPower
        end

    end

    if char and Vars.Noclip then
        for _,v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end

end)

---------------------------------------------------
-- COMBAT / ESP / AIMBOT
---------------------------------------------------

task.spawn(function()

    while task.wait(0.15) do

        for _,p in pairs(Players:GetPlayers()) do

            if p ~= LP and p.Character then

                ---------------------------------------------------
                -- PLAYER ESP
                ---------------------------------------------------

                if Vars.ESPEnabled and not p.Character:FindFirstChild("Highlight") then
                    local h = Instance.new("Highlight")
                    h.FillColor = Color3.fromRGB(255,0,0)
                    h.Parent = p.Character
                end

                ---------------------------------------------------
                -- HITBOX
                ---------------------------------------------------

                if Vars.Hitbox and p.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = p.Character.HumanoidRootPart
                    hrp.Size = Vector3.new(10,10,10)
                    hrp.Transparency = 0.6
                    hrp.Massless = true
                end

            end

        end

        ---------------------------------------------------
        -- CAR ESP
        ---------------------------------------------------

        if Vars.CarESP then
            for _,v in pairs(workspace:GetDescendants()) do

                if v:IsA("VehicleSeat") and not v:FindFirstChild("CarESP") then

                    local h = Instance.new("Highlight")
                    h.Name = "CarESP"
                    h.FillColor = Color3.fromRGB(0,255,255)
                    h.Parent = v

                end

            end
        end

        ---------------------------------------------------
        -- WHEEL AIMBOT
        ---------------------------------------------------

        if Vars.WheelAimbot then

            local closest = nil
            local dist = math.huge

            for _,v in pairs(workspace:GetDescendants()) do

                if v:IsA("BasePart") then

                    local name = string.lower(v.Name)

                    if string.find(name,"wheel") or string.find(name,"tire") then

                        local d = (Camera.CFrame.Position - v.Position).Magnitude

                        if d < dist then
                            dist = d
                            closest = v
                        end

                    end

                end

            end

            if closest then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, closest.Position)
            end

        end

    end

end)

---------------------------------------------------
-- INFINITE JUMP
---------------------------------------------------

UIS.JumpRequest:Connect(function()

    if Vars.InfiniteJump then

        local hum = GetHumanoid()

        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end

    end

end)

---------------------------------------------------
-- NOTIFY
---------------------------------------------------

Rayfield:Notify({
    Title = "Nebula Hub",
    Content = "Script Loaded Successfully!",
    Duration = 5
})
