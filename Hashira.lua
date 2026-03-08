-------------------------------------------------
-- HASHIRAS HUB
-------------------------------------------------

-------------------------------------------------
-- SERVICES
-------------------------------------------------

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local UIS = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Stats = game:GetService("Stats")
local VirtualUser = game:GetService("VirtualUser")

local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-------------------------------------------------
-- CHARACTER
-------------------------------------------------

local function GetChar()
return LP.Character
end

local function GetHum()
local char = GetChar()
return char and char:FindFirstChildOfClass("Humanoid")
end

local function GetRoot()
local char = GetChar()
return char and char:FindFirstChild("HumanoidRootPart")
end

-------------------------------------------------
-- LOAD RAYFIELD
-------------------------------------------------

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
Name = "Hashiras Hub",
LoadingTitle = "Hashiras Hub",
LoadingSubtitle = "Rayfield Edition",
ConfigurationSaving = {Enabled = false}
})

-------------------------------------------------
-- TABS
-------------------------------------------------

local Movement = Window:CreateTab("Movement")
local Combat = Window:CreateTab("Combat")
local Visual = Window:CreateTab("Visual")
local TeleportTab = Window:CreateTab("Teleport")
local ServerTab = Window:CreateTab("Server")

-------------------------------------------------
-- MOVEMENT
-------------------------------------------------

Movement:CreateSlider({
Name = "WalkSpeed",
Range = {16,150},
Increment = 1,
CurrentValue = 16,
Callback = function(v)
local hum = GetHum()
if hum then hum.WalkSpeed = v end
end
})

Movement:CreateSlider({
Name = "JumpPower",
Range = {50,200},
Increment = 1,
CurrentValue = 50,
Callback = function(v)
local hum = GetHum()
if hum then hum.JumpPower = v end
end
})

-------------------------------------------------
-- HIGH JUMP
-------------------------------------------------

Movement:CreateButton({
Name = "High Jump",
Callback = function()
local root = GetRoot()
if root then
root.Velocity = Vector3.new(0,150,0)
end
end
})

-------------------------------------------------
-- DASH
-------------------------------------------------

Movement:CreateButton({
Name = "Dash Button",
Callback = function()

local gui = Instance.new("ScreenGui",game.CoreGui)

local dash = Instance.new("TextButton")
dash.Size = UDim2.new(0,80,0,80)
dash.Position = UDim2.new(0.85,0,0.75,0)
dash.Text = "Dash"
dash.Parent = gui

dash.MouseButton1Click:Connect(function()

local root = GetRoot()

if root then
root.Velocity = Camera.CFrame.LookVector * 120
end

end)

end
})

-------------------------------------------------
-- INFINITE JUMP
-------------------------------------------------

local InfiniteJump = false

Movement:CreateToggle({
Name = "Infinite Jump",
CurrentValue = false,
Callback = function(v)
InfiniteJump = v
end
})

UIS.JumpRequest:Connect(function()

if InfiniteJump then
local hum = GetHum()
if hum then
hum:ChangeState("Jumping")
end
end

end)

-------------------------------------------------
-- NOCLIP
-------------------------------------------------

local Noclip = false

Movement:CreateToggle({
Name = "Noclip",
CurrentValue = false,
Callback = function(v)
Noclip = v
end
})

RunService.Stepped:Connect(function()

if Noclip and GetChar() then
for _,v in pairs(GetChar():GetDescendants()) do
if v:IsA("BasePart") then
v.CanCollide = false
end
end
end

end)

-------------------------------------------------
-- FLY GUI (REPLACED)
-------------------------------------------------

Movement:CreateButton({
Name = "Fly GUI",
Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
end
})

-------------------------------------------------
-- ANTI AFK
-------------------------------------------------

Movement:CreateToggle({
Name = "Anti AFK",
CurrentValue = true,
Callback = function(v)

if v then

LP.Idled:Connect(function()
VirtualUser:Button2Down(Vector2.new(0,0),Camera.CFrame)
task.wait(1)
VirtualUser:Button2Up(Vector2.new(0,0),Camera.CFrame)
end)

end

end
})

-------------------------------------------------
-- COMBAT
-------------------------------------------------

Combat:CreateButton({
Name = "Aimbot",
Callback = function()
loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Aimbot-universal-111551"))()
end
})

Combat:CreateButton({
Name = "Hitbox Expander",
Callback = function()
loadstring(game:HttpGet("https://github.com/RectangularObject/UniversalHBE/releases/latest/download/main.lua"))()
end
})

-------------------------------------------------
-- TELEPORT
-------------------------------------------------

TeleportTab:CreateButton({
Name = "Teleport Spawn",
Callback = function()

local spawn = workspace:FindFirstChildWhichIsA("SpawnLocation")

if spawn then
GetRoot().CFrame = spawn.CFrame + Vector3.new(0,5,0)
end

end
})

TeleportTab:CreateButton({
Name = "Teleport NPC",
Callback = function()

for _,v in pairs(workspace:GetDescendants()) do

if v:IsA("Humanoid") and v.Parent ~= LP.Character then

local root = v.Parent:FindFirstChild("HumanoidRootPart")

if root then
GetRoot().CFrame = root.CFrame
break
end

end

end

end
})

TeleportTab:CreateButton({
Name = "Teleport Loot / Item",
Callback = function()

for _,v in pairs(workspace:GetDescendants()) do

if v:IsA("Tool") then

if v:FindFirstChild("Handle") then
GetRoot().CFrame = v.Handle.CFrame
break
end

end

end

end
})

-------------------------------------------------
-- VISUAL ESP
-------------------------------------------------

local ESP = false

Visual:CreateToggle({
Name = "Player ESP",
CurrentValue = false,
Callback = function(v)
ESP = v
end
})

RunService.RenderStepped:Connect(function()

if ESP then

for _,p in pairs(Players:GetPlayers()) do

if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then

if not p.Character:FindFirstChild("ESPBox") then

local box = Instance.new("BoxHandleAdornment")
box.Name = "ESPBox"
box.Adornee = p.Character.HumanoidRootPart
box.Size = Vector3.new(4,6,1)
box.AlwaysOnTop = true
box.Color3 = Color3.new(1,0,0)
box.Parent = p.Character

end

end

end

end

end)

-------------------------------------------------
-- SERVER INFO
-------------------------------------------------

local PlayerLabel = ServerTab:CreateLabel("Players: loading")
local PingLabel = ServerTab:CreateLabel("Ping: loading")

RunService.RenderStepped:Connect(function()

PlayerLabel:Set("Players: "..#Players:GetPlayers())

local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
PingLabel:Set("Ping: "..ping)

end)

-------------------------------------------------
-- REJOIN
-------------------------------------------------

ServerTab:CreateButton({
Name = "Rejoin",
Callback = function()
TeleportService:Teleport(game.PlaceId,LP)
end
})

-------------------------------------------------
-- SERVER HOP
-------------------------------------------------

local function ServerHop(low)

local Place = game.PlaceId
local Job = game.JobId

local url = "https://games.roblox.com/v1/games/"..Place.."/servers/Public?limit=100"

local data = HttpService:JSONDecode(game:HttpGet(url))

for _,server in pairs(data.data) do

if server.id ~= Job then

if low then

if server.playing <= 3 then
TeleportService:TeleportToPlaceInstance(Place,server.id,LP)
break
end

else

TeleportService:TeleportToPlaceInstance(Place,server.id,LP)
break

end

end

end

end

ServerTab:CreateButton({
Name = "Server Hop",
Callback = function()
ServerHop(false)
end
})

ServerTab:CreateButton({
Name = "Server Hop (Quase vazio)",
Callback = function()
ServerHop(true)
end
})

-------------------------------------------------
-- AUTO SERVER HOP
-------------------------------------------------

ServerTab:CreateToggle({
Name = "Auto Server Hop",
CurrentValue = false,
Callback = function(v)

while v do
task.wait(15)
ServerHop(false)
end

end
})

-------------------------------------------------
-- SERVER LIST
-------------------------------------------------

ServerTab:CreateButton({
Name = "Print Server List",
Callback = function()

local url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?limit=100"

local data = HttpService:JSONDecode(game:HttpGet(url))

for _,server in pairs(data.data) do
print(server.id.." | "..server.playing.."/"..server.maxPlayers)
end

end
})

-------------------------------------------------
-- JOIN SERVER BY ID
-------------------------------------------------

ServerTab:CreateInput({
Name = "Join Server (JobId)",
PlaceholderText = "server id",
RemoveTextAfterFocusLost = false,
Callback = function(text)

TeleportService:TeleportToPlaceInstance(game.PlaceId,text,LP)

end
})
