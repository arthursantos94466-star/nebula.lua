-- Rayfield Loader
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "Nebula Hub",
    LoadingTitle = "Nebula Hub",
    LoadingSubtitle = "Mobile Edition",
    ConfigurationSaving = {Enabled = false},
    Discord = {Enabled = false},
    KeySystem = false
})

-- Services
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer

-- Helpers
local function getChar()
    return player.Character or player.CharacterAdded:Wait()
end

local function getHum()
    return getChar():WaitForChild("Humanoid")
end

local function getRoot()
    return getChar():WaitForChild("HumanoidRootPart")
end

-- Variáveis de controle
local walkspeed = 16
local jumppower = 50
local flySpeed = 60

----------------------------------------------------------------
-- PLAYER TAB
----------------------------------------------------------------

local PlayerTab = Window:CreateTab("Player")

-- WalkSpeed (slider corrigido)
PlayerTab:CreateSlider({
Name = "WalkSpeed",
Range = {16,200},
Increment = 1,
CurrentValue = 16,
Callback = function(v)
walkspeed = v
getHum().WalkSpeed = walkspeed
end
})

-- JumpPower (slider corrigido)
PlayerTab:CreateSlider({
Name = "JumpPower",
Range = {50,200},
Increment = 1,
CurrentValue = 50,
Callback = function(v)
jumppower = v
getHum().JumpPower = jumppower
end
})

-- Reaplicar valores se o personagem respawnar
player.CharacterAdded:Connect(function()
task.wait(1)
getHum().WalkSpeed = walkspeed
getHum().JumpPower = jumppower
end)

----------------------------------------------------------------
-- INFINITE JUMP
----------------------------------------------------------------

local infJump=false

PlayerTab:CreateToggle({
Name="Infinite Jump",
CurrentValue=false,
Callback=function(v)
infJump=v
end
})

UIS.JumpRequest:Connect(function()
if infJump then
getHum():ChangeState("Jumping")
end
end)

----------------------------------------------------------------
-- FLY FUNCIONAL
----------------------------------------------------------------

local flying=false
local bv
local bg

PlayerTab:CreateToggle({
Name="Fly",
CurrentValue=false,
Callback=function(state)

flying=state

if flying then

local root=getRoot()

bg=Instance.new("BodyGyro")
bg.P=9e4
bg.MaxTorque=Vector3.new(9e9,9e9,9e9)
bg.CFrame=root.CFrame
bg.Parent=root

bv=Instance.new("BodyVelocity")
bv.Velocity=Vector3.new(0,0,0)
bv.MaxForce=Vector3.new(9e9,9e9,9e9)
bv.Parent=root

RunService.RenderStepped:Connect(function()

if flying and bv then
bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * flySpeed
bg.CFrame = workspace.CurrentCamera.CFrame
end

end)

else

if bv then bv:Destroy() end
if bg then bg:Destroy() end

end

end
})

PlayerTab:CreateSlider({
Name="Fly Speed",
Range={20,200},
Increment=5,
CurrentValue=60,
Callback=function(v)
flySpeed=v
end
})

----------------------------------------------------------------
-- MOVEMENT TAB
----------------------------------------------------------------

local MoveTab = Window:CreateTab("Movement")

-- Noclip
local noclip=false

MoveTab:CreateToggle({
Name="Noclip",
CurrentValue=false,
Callback=function(v)
noclip=v
end
})

RunService.Stepped:Connect(function()
if noclip then
for _,p in pairs(getChar():GetDescendants()) do
if p:IsA("BasePart") then
p.CanCollide=false
end
end
end
end)

-- Dash
MoveTab:CreateButton({
Name="Dash Forward",
Callback=function()

local root=getRoot()

root.Velocity = workspace.CurrentCamera.CFrame.LookVector * 200

end
})

-- High Jump
MoveTab:CreateButton({
Name="High Jump",
Callback=function()

getRoot().Velocity = Vector3.new(0,120,0)

end
})

----------------------------------------------------------------
-- TELEPORT TAB
----------------------------------------------------------------

local TpTab = Window:CreateTab("Teleport")

-- Click Teleport
local clickTp=false

TpTab:CreateToggle({
Name="Click Teleport",
CurrentValue=false,
Callback=function(v)
clickTp=v
end
})

player:GetMouse().Button1Down:Connect(function()

if clickTp then

local pos = player:GetMouse().Hit.Position
getRoot().CFrame = CFrame.new(pos + Vector3.new(0,3,0))

end

end)

-- Teleport Spawn
TpTab:CreateButton({
Name="Teleport Spawn",
Callback=function()

for _,v in pairs(workspace:GetDescendants()) do

if v:IsA("SpawnLocation") then
getRoot().CFrame = v.CFrame + Vector3.new(0,5,0)
break
end

end

end
})

----------------------------------------------------------------
-- AUTO FARM TAB
----------------------------------------------------------------

local FarmTab = Window:CreateTab("Auto Farm")

local autofarm=false

FarmTab:CreateToggle({
Name="Auto Farm Coins",
CurrentValue=false,
Callback=function(v)

autofarm=v

while autofarm do

for _,item in pairs(workspace:GetDescendants()) do

if item.Name=="Coin"
or item.Name=="Cash"
or item.Name=="Gem"
or item.Name=="Drop" then

if item:IsA("Part") or item:IsA("MeshPart") then

getRoot().CFrame = item.CFrame + Vector3.new(0,3,0)

task.wait(0.15)

end

end

end

task.wait()

end

end
})

----------------------------------------------------------------
-- FUN TAB
----------------------------------------------------------------

local FunTab = Window:CreateTab("Fun")

FunTab:CreateButton({
Name="Sit",
Callback=function()
getHum().Sit=true
end
})

FunTab:CreateButton({
Name="Create Platform",
Callback=function()

local p=Instance.new("Part")

p.Size=Vector3.new(10,1,10)
p.Anchored=true
p.Position=getRoot().Position-Vector3.new(0,3,0)
p.Parent=workspace

end
})

----------------------------------------------------------------
-- EXTRA TAB
----------------------------------------------------------------

local ExtraTab = Window:CreateTab("Extras")

ExtraTab:CreateButton({
Name="Reset Character",
Callback=function()
getChar():BreakJoints()
end
})

ExtraTab:CreateButton({
Name="Rejoin Server",
Callback=function()
TeleportService:Teleport(game.PlaceId,player)
end
})

ExtraTab:CreateButton({
Name="Destroy GUI",
Callback=function()
Rayfield:Destroy()
end
})
