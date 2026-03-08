-------------------------------------------------
-- HASHIRAS HUB (Rayfield)
-------------------------------------------------

---------------- SERVICES ----------------
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local UIS = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Stats = game:GetService("Stats")
local VirtualUser = game:GetService("VirtualUser")

local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

---------------- CHARACTER HELPERS ----------------
local function Char() return LP.Character or LP.CharacterAdded:Wait() end
local function Hum() return Char():FindFirstChildOfClass("Humanoid") end
local function Root() return Char():FindFirstChild("HumanoidRootPart") end

---------------- RAYFIELD ----------------
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
Name = "Hashiras Hub",
LoadingTitle = "Hashiras Hub",
LoadingSubtitle = "Professional",
ConfigurationSaving = {Enabled = false}
})

local Movement = Window:CreateTab("Movement")
local Combat = Window:CreateTab("Combat")
local Visual = Window:CreateTab("Visual")
local TeleportTab = Window:CreateTab("Teleport")
local ServerTab = Window:CreateTab("Server")
local ExtraTab = Window:CreateTab("Extra")

-------------------------------------------------
-- MOVEMENT
-------------------------------------------------

local WalkSpeed = 16
local JumpPower = 50
local InfiniteJump = false
local Noclip = false

local function ApplyMovement()
local h = Hum()
if h then
h.WalkSpeed = WalkSpeed
h.UseJumpPower = true
h.JumpPower = JumpPower
end
end

LP.CharacterAdded:Connect(function()
task.wait(1)
ApplyMovement()
end)

Movement:CreateSlider({
Name = "WalkSpeed",
Range = {16,150},
Increment = 1,
CurrentValue = 16,
Callback = function(v)
WalkSpeed = v
ApplyMovement()
end
})

Movement:CreateSlider({
Name = "JumpPower",
Range = {50,200},
Increment = 1,
CurrentValue = 50,
Callback = function(v)
JumpPower = v
ApplyMovement()
end
})

Movement:CreateToggle({
Name = "Infinite Jump",
CurrentValue = false,
Callback = function(v)
InfiniteJump = v
end
})

UIS.JumpRequest:Connect(function()
if InfiniteJump then
local h = Hum()
if h then h:ChangeState("Jumping") end
end
end)

Movement:CreateToggle({
Name = "Noclip",
CurrentValue = false,
Callback = function(v)
Noclip = v
end
})

RunService.Stepped:Connect(function()
if Noclip then
for _,v in pairs(Char():GetDescendants()) do
if v:IsA("BasePart") then
v.CanCollide = false
end
end
end
end)

Movement:CreateButton({
Name = "High Jump",
Callback = function()
Root().Velocity = Vector3.new(0,120,0)
end
})

Movement:CreateButton({
Name = "Dash Button",
Callback = function()

local gui = Instance.new("ScreenGui", game.CoreGui)

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0,70,0,70)
btn.Position = UDim2.new(0.82,0,0.6,0)
btn.Text = "Dash"
btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
btn.TextColor3 = Color3.new(1,1,1)
btn.Active = true
btn.Draggable = true
btn.Parent = gui

btn.MouseButton1Click:Connect(function()
Root().Velocity = Camera.CFrame.LookVector * 85
end)

end
})

Movement:CreateButton({
Name = "Fly GUI",
Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
end
})

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
-- VISUAL ESP
-------------------------------------------------

local ESPEnabled = false

local function CreateESP(player)

if player == LP then return end

local Billboard = Instance.new("BillboardGui")
Billboard.Size = UDim2.new(0,100,0,40)
Billboard.AlwaysOnTop = true

local Text = Instance.new("TextLabel")
Text.BackgroundTransparency = 1
Text.TextColor3 = Color3.new(1,0,0)
Text.TextScaled = true
Text.Font = Enum.Font.SourceSansBold
Text.Size = UDim2.new(1,0,1,0)
Text.Parent = Billboard

RunService.RenderStepped:Connect(function()

if not ESPEnabled then
Billboard.Parent = nil
return
end

if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then

local root = player.Character.HumanoidRootPart
Billboard.Parent = root

local dist = math.floor((root.Position - Camera.CFrame.Position).Magnitude)
Text.Text = player.Name.." ["..dist.."]"

end

end)

end

Visual:CreateToggle({
Name = "Player ESP",
CurrentValue = false,
Callback = function(v)
ESPEnabled = v
end
})

for _,p in pairs(Players:GetPlayers()) do
CreateESP(p)
end

Players.PlayerAdded:Connect(CreateESP)

-------------------------------------------------
-- TELEPORT
-------------------------------------------------

TeleportTab:CreateButton({
Name = "Teleport Spawn",
Callback = function()
for _,v in pairs(workspace:GetDescendants()) do
if v:IsA("SpawnLocation") then
Root().CFrame = v.CFrame + Vector3.new(0,5,0)
break
end
end
end
})

TeleportTab:CreateButton({
Name = "Teleport NPC",
Callback = function()
for _,v in pairs(workspace:GetDescendants()) do
if v:IsA("Humanoid") and v.Parent ~= LP.Character then
local r = v.Parent:FindFirstChild("HumanoidRootPart")
if r then
Root().CFrame = r.CFrame
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
if v:IsA("Tool") and v:FindFirstChild("Handle") then
Root().CFrame = v.Handle.CFrame
break
end
end
end
})

TeleportTab:CreateButton({
Name = "Teleport Sky",
Callback = function()
Root().CFrame = Root().CFrame + Vector3.new(0,500,0)
end
})

TeleportTab:CreateButton({
Name = "Teleport Under Map",
Callback = function()
Root().CFrame = Root().CFrame - Vector3.new(0,200,0)
end
})

TeleportTab:CreateButton({
Name = "Create Platform",
Callback = function()

local part = Instance.new("Part")
part.Size = Vector3.new(20,1,20)
part.Anchored = true
part.Position = Root().Position - Vector3.new(0,4,0)
part.Parent = workspace

end
})

-------------------------------------------------
-- TELEPORT PLAYER LIST (IN HUB)
-------------------------------------------------

local PlayerList = {}
local SelectedPlayer = nil

local function RefreshPlayers()

PlayerList = {}

for _,p in pairs(Players:GetPlayers()) do
if p ~= LP then
table.insert(PlayerList, p.Name)
end
end

end

RefreshPlayers()

local Dropdown = TeleportTab:CreateDropdown({
Name = "Player List",
Options = PlayerList,
CurrentOption = {},
Callback = function(option)
SelectedPlayer = option[1]
end
})

TeleportTab:CreateButton({
Name = "Refresh Player List",
Callback = function()
RefreshPlayers()
Dropdown:Refresh(PlayerList)
end
})

TeleportTab:CreateButton({
Name = "Teleport To Player",
Callback = function()

if SelectedPlayer then

local p = Players:FindFirstChild(SelectedPlayer)

if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
Root().CFrame = p.Character.HumanoidRootPart.CFrame
end

end

end
})

-------------------------------------------------
-- SPECTATE
-------------------------------------------------

TeleportTab:CreateInput({
Name = "Spectate Player",
PlaceholderText = "Player name",
Callback = function(text)

local p = Players:FindFirstChild(text)

if p and p.Character and p.Character:FindFirstChild("Humanoid") then
Camera.CameraSubject = p.Character.Humanoid
end

end
})

TeleportTab:CreateButton({
Name = "Stop Spectate",
Callback = function()
Camera.CameraSubject = Hum()
end
})

-------------------------------------------------
-- SERVER
-------------------------------------------------

local PlayerLabel = ServerTab:CreateLabel("Players: loading")
local PingLabel = ServerTab:CreateLabel("Ping: loading")

RunService.RenderStepped:Connect(function()

PlayerLabel:Set("Players: "..#Players:GetPlayers())

local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
PingLabel:Set("Ping: "..ping)

end)

ServerTab:CreateButton({
Name = "Rejoin",
Callback = function()
TeleportService:Teleport(game.PlaceId, LP)
end
})

local function ServerHop(low)

local PlaceId = game.PlaceId
local cursor = ""

repeat

local url = "https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?limit=100&cursor="..cursor
local data = HttpService:JSONDecode(game:HttpGet(url))

for _,server in pairs(data.data) do

if server.id ~= game.JobId then

if low then
if server.playing <= 3 then
TeleportService:TeleportToPlaceInstance(PlaceId, server.id, LP)
return
end
else
TeleportService:TeleportToPlaceInstance(PlaceId, server.id, LP)
return
end

end

end

cursor = data.nextPageCursor

until not cursor

end

ServerTab:CreateButton({
Name = "Server Hop",
Callback = function()
ServerHop(false)
end
})

ServerTab:CreateButton({
Name = "Server Hop (Low)",
Callback = function()
ServerHop(true)
end
})

-------------------------------------------------
-- EXTRA
-------------------------------------------------

ExtraTab:CreateButton({
Name = "Infinity Yield",
Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end
})
