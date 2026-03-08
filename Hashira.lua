-- Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Hashiras Hub",
   LoadingTitle = "Hashiras Hub",
   LoadingSubtitle = "Rayfield",
   ConfigurationSaving = {Enabled = false},
   KeySystem = false
})

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Stats = game:GetService("Stats")

-- Tabs
local CombatTab = Window:CreateTab("Combat",4483362458)
local MovementTab = Window:CreateTab("Movement",4483362458)
local VisualTab = Window:CreateTab("Visual",4483362458)
local TeleportTab = Window:CreateTab("Teleport",4483362458)
local ServerTab = Window:CreateTab("Server",4483362458)
local ExtraTab = Window:CreateTab("Extra",4483362458)

---------------------------------------------------
-- COMBAT
---------------------------------------------------

CombatTab:CreateButton({
Name="Aimbot (External)",
Callback=function()
loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Aimbot-universal-111551"))()
})

CombatTab:CreateButton({
Name="Hitbox (External)",
Callback=function()

for _,v in pairs(Players:GetPlayers()) do
if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
v.Character.HumanoidRootPart.Size = Vector3.new(10,10,10)
v.Character.HumanoidRootPart.Transparency = 0.7
v.Character.HumanoidRootPart.CanCollide = false
end
end

end
})

---------------------------------------------------
-- MOVEMENT
---------------------------------------------------

MovementTab:CreateSlider({
Name="WalkSpeed",
Range={0,200},
Increment=1,
CurrentValue=16,
Callback=function(Value)
LocalPlayer.Character.Humanoid.WalkSpeed = Value
end
})

MovementTab:CreateSlider({
Name="Jump Power",
Range={0,200},
Increment=1,
CurrentValue=50,
Callback=function(Value)
LocalPlayer.Character.Humanoid.JumpPower = Value
end
})

MovementTab:CreateButton({
Name="Fly (External)",
Callback=function()
loadstring(game:HttpGet("https://pastebin.com/raw/6gC8Qq7D"))()
end
})

-- Infinite Jump
local InfiniteJump=false

MovementTab:CreateToggle({
Name="Infinite Jump",
CurrentValue=false,
Callback=function(v)
InfiniteJump=v
end
})

UIS.JumpRequest:Connect(function()
if InfiniteJump then
LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
end
end)

-- Noclip
local noclip=false

MovementTab:CreateToggle({
Name="Noclip",
CurrentValue=false,
Callback=function(v)
noclip=v
end
})

RunService.Stepped:Connect(function()
if noclip then
for _,v in pairs(LocalPlayer.Character:GetDescendants()) do
if v:IsA("BasePart") then
v.CanCollide=false
end
end
end
end)

---------------------------------------------------
-- DASH ESTILO ANIME
---------------------------------------------------

local dashGui = Instance.new("ScreenGui")
dashGui.Parent = game.CoreGui

local dashButton = Instance.new("TextButton")
dashButton.Parent = dashGui
dashButton.Size = UDim2.new(0,120,0,45)
dashButton.Position = UDim2.new(0.45,0,0.75,0)
dashButton.Text = "⚡ DASH"
dashButton.BackgroundColor3 = Color3.fromRGB(25,25,25)
dashButton.TextColor3 = Color3.new(1,1,1)
dashButton.TextScaled = true
dashButton.Active = true
dashButton.Draggable = true

dashButton.MouseButton1Click:Connect(function()

local char = LocalPlayer.Character
local hrp = char:FindFirstChild("HumanoidRootPart")

if hrp then

local bv = Instance.new("BodyVelocity")
bv.MaxForce = Vector3.new(9e9,9e9,9e9)
bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * 600
bv.Parent = hrp

local trail = Instance.new("Trail")
local a0 = Instance.new("Attachment", hrp)
local a1 = Instance.new("Attachment", hrp)

trail.Attachment0 = a0
trail.Attachment1 = a1
trail.Lifetime = 0.15
trail.Parent = hrp

task.wait(0.18)

bv:Destroy()
trail:Destroy()
a0:Destroy()
a1:Destroy()

end

end)

---------------------------------------------------
-- VISUAL
---------------------------------------------------

VisualTab:CreateButton({
Name="ESP",
Callback=function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Infinite-Store/Infinite-Store/main/ESP.lua"))()
end
})

VisualTab:CreateToggle({
Name="FullBright",
CurrentValue=false,
Callback=function(Value)

if Value then
Lighting.Brightness=2
Lighting.ClockTime=14
Lighting.FogEnd=100000
Lighting.GlobalShadows=false
else
Lighting.Brightness=1
end

end
})

---------------------------------------------------
-- TELEPORT
---------------------------------------------------

local selectedPlayer=nil

local dropdown = TeleportTab:CreateDropdown({
Name="Player List",
Options={},
CurrentOption={},
Callback=function(v)
selectedPlayer=v
end
})

local function refreshPlayers()

local list={}

for _,v in pairs(Players:GetPlayers()) do
if v~=LocalPlayer then
table.insert(list,v.Name)
end
end

dropdown:Set(list)

end

refreshPlayers()
Players.PlayerAdded:Connect(refreshPlayers)
Players.PlayerRemoving:Connect(refreshPlayers)

TeleportTab:CreateButton({
Name="Teleport To Player",
Callback=function()

if selectedPlayer then
local target = Players:FindFirstChild(selectedPlayer)

if target and target.Character then
LocalPlayer.Character.HumanoidRootPart.CFrame =
target.Character.HumanoidRootPart.CFrame
end
end

end
})

---------------------------------------------------
-- TP ATRÁS DO PLAYER
---------------------------------------------------

TeleportTab:CreateButton({
Name="Teleport Behind Player",
Callback=function()

local target = Players:FindFirstChild(selectedPlayer)

if target and target.Character then

local hrp = target.Character:FindFirstChild("HumanoidRootPart")
local myhrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

if hrp and myhrp then
myhrp.CFrame = hrp.CFrame * CFrame.new(0,0,3)
end

end

end
})

---------------------------------------------------
-- SPECTATE
---------------------------------------------------

TeleportTab:CreateButton({
Name="Spectate Player",
Callback=function()

local target=Players:FindFirstChild(selectedPlayer)

if target and target.Character then
workspace.CurrentCamera.CameraSubject =
target.Character:FindFirstChild("Humanoid")
end

end
})

---------------------------------------------------
-- CLICK TELEPORT RÁPIDO
---------------------------------------------------

local clicktp=false
local mouse = LocalPlayer:GetMouse()

TeleportTab:CreateToggle({
Name="Click Teleport",
CurrentValue=false,
Callback=function(v)
clicktp=v
end
})

mouse.Button1Down:Connect(function()

if clicktp then

local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

if hrp then
hrp.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0,3,0))
end

end

end)

---------------------------------------------------
-- TELEPORT TOOL
---------------------------------------------------

TeleportTab:CreateButton({
Name="Teleport Tool",
Callback=function()

local tool=Instance.new("Tool")
tool.Name="Teleport Tool"
tool.RequiresHandle=false

tool.Activated:Connect(function()

local mouse=LocalPlayer:GetMouse()
LocalPlayer.Character:MoveTo(mouse.Hit.p)

end)

tool.Parent=LocalPlayer.Backpack

end
})

---------------------------------------------------
-- SERVER
---------------------------------------------------

ServerTab:CreateButton({
Name="Rejoin",
Callback=function()
TeleportService:Teleport(game.PlaceId,LocalPlayer)
end
})

ServerTab:CreateButton({
Name="Server Hop",
Callback=function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Infinity2346/Tect-Menu/main/ServerHop"))()
end
})

ServerTab:CreateInput({
Name="Join Server (JobId)",
PlaceholderText="Paste JobId",
RemoveTextAfterFocusLost=false,
Callback=function(text)

TeleportService:TeleportToPlaceInstance(
game.PlaceId,
text,
LocalPlayer
)

end
})

---------------------------------------------------
-- SERVER INFO
---------------------------------------------------

task.spawn(function()

while true do

local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
local players = #Players:GetPlayers()

Rayfield:Notify({
Title="Server Info",
Content="Players: "..players.." | Ping: "..ping,
Duration=4
})

task.wait(10)

end

end)

---------------------------------------------------
-- EXTRA
---------------------------------------------------

ExtraTab:CreateButton({
Name="Infinite Yield",
Callback=function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end
})
