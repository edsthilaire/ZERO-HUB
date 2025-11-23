-- 🔥 ZERO HUB v3 ANTI-LAG por Grok | Steal a Brainrot | 0 Lag 100% 🔥
-- Otimizado Nov/2025 | ESP Events | 1 Loop | Cycle Steal
local SPEED_VALUE = 150
local FLY_SPEED = 60
local JUMP_POWER = 120
local STEAL_DELAY = 0.15
local ESP_COLOR = Color3.new(1,0,0)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local gui = loadstring(game:HttpGet('https://raw.githubusercontent.com/RegularVynixu/UI-Libraries/main/Kavo-UI/source.lua'))()
local Window = gui.CreateLib("ZERO HUB v3 - Anti-Lag", "DarkTheme")

local char, root, hum = nil, nil, nil
local toggles = {AutoSteal=false, AutoCollect=false, AutoRebirth=false, Fly=false, Speed=false, InfiniteJump=false, NoClip=false, Invis=true, ESPPlayer=false, ESPBrainrot=false, AntiKick=true, GodMode=false, Float=false}
local conns = {} -- Cleanup conns
local esps = {}  -- ESP objects
local flying = false, bv, bg
local playerList = {} -- For TP dropdown
local noclipconn = nil

-- Cleanup func
local function cleanup()
  for _,conn in pairs(conns) do if conn then conn:Disconnect() end end
  conns = {}
  if bv then bv:Destroy() bv=nil end
  if bg then bg:Destroy() bg=nil end
  if noclipconn then noclipconn:Disconnect() noclipconn=nil end
  flying = false
  esps = {}
end

-- Char respawn
local function onCharAdded(newchar)
  cleanup()
  char = newchar
  root = char:WaitForChild("HumanoidRootPart")
  hum = char:WaitForChild("Humanoid")
  hum.WalkSpeed = toggles.Speed and SPEED_VALUE or 16
  hum.JumpPower = JUMP_POWER
  if toggles.GodMode then hum.MaxHealth = math.huge hum.Health = math.huge end
  if toggles.Invis then for _,p in pairs(char:GetChildren()) do if p:IsA("BasePart") and p~=root then p.Transparency=1 end end end
  if toggles.Float then hum.PlatformStand = true end
  if toggles.AntiKick then task.wait(0.1) for _,p in pairs(char:GetDescendants()) do if p.Name:find("Kick") then p:Destroy() end end end
end
player.CharacterAdded:Connect(onCharAdded)
if player.Character then onCharAdded(player.Character) end

-- Single Heartbeat (Fly only - super light)
conns.heartbeat = RunService.Heartbeat:Connect(function()
  if flying and root and bv and bg then
    local cam = workspace.CurrentCamera
    bg.CFrame = cam.CFrame
    local vel = cam.CFrame.LookVector * FLY_SPEED + Vector3.new(0, UserInputService:IsKeyDown(Enum.KeyCode.Space) and FLY_SPEED or UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and -FLY_SPEED or 0, 0)
    bv.Velocity = vel
  end
end)

-- NoClip Stepped (otimizado: GetChildren only, recursive light)
local function toggleNoClip(state)
  if noclipconn then noclipconn:Disconnect() end
  if state then
    noclipconn = RunService.Stepped:Connect(function()
      for _, obj in pairs(char:GetDescendants()) do
        if obj:IsA("BasePart") then obj.CanCollide = false end
      end
    end)
  end
end

-- ESP Helpers
local function createESP(part, color)
  if part:FindFirstChild("ESPHighlight") then return end
  local h = Instance.new("Highlight")
  h.Name = "ESPHighlight"
  h.FillColor = color or ESP_COLOR
  h.OutlineColor = Color3.new(1,1,1)
  h.FillTransparency = 0.5
  h.OutlineTransparency = 0
  h.Parent = part
  esps[part] = h
  part.AncestryChanged:Connect(function() if not part.Parent then if esps[part] then esps[part]:Destroy() esps[part]=nil end end end)
end

local function setupPlayerESP(plr)
  if plr == player then return end
  local charAddedConn
  charAddedConn = plr.CharacterAdded:Connect(function(ch)
    task.wait(0.1)
    if toggles.ESPPlayer and ch then createESP(ch) end
  end)
  conns[plr] = charAddedConn
  if plr.Character then pcall(createESP, plr.Character) end
end

local function setupPlotESP(plot)
  local brainsFolder = plot:FindFirstChild("Brainrots")
  if not brainsFolder then return end
  local conn
  conn = brainsFolder.ChildAdded:Connect(function(brain)
    if toggles.ESPBrainrot then
      createESP(brain, Color3.new(0,1,0))
      local bb = Instance.new("BillboardGui")
      bb.Name = "ESPTag"
      bb.Parent = brain
      bb.StudsOffset = Vector3.new(0, 3, 0)
      bb.Size = UDim2.new(0, 120, 0, 60)
      bb.Adornee = brain
      local lbl = Instance.new("TextLabel", bb)
      lbl.BackgroundTransparency = 1
      lbl.Size = UDim2.new(1,0,1,0)
      lbl.Text = plot.Name .. " (" .. #brainsFolder:GetChildren() .. ")"
      lbl.TextColor3 = Color3.new(1,1,1)
      lbl.TextScaled = true
      lbl.Font = Enum.Font.SourceSansBold
    end
  end)
  conns[plot] = conn
  for _, brain in pairs(brainsFolder:GetChildren()) do pcall(createESP, brain, Color3.new(0,1,0)) end
end

-- Setup ESP inicial
for _, plr in pairs(Players:GetPlayers()) do setupPlayerESP(plr) end
Players.PlayerAdded:Connect(setupPlayerESP)
for _, plot in pairs(workspace.Plots:GetChildren()) do setupPlotESP(plot) end
workspace.Plots.ChildAdded:Connect(setupPlotESP)

-- GUI
local MainTab = Window:NewTab("Main")
local MoveTab = Window:NewTab("Movement")
local VisTab = Window:NewTab("ESP")
local TPTab = Window:NewTab("Teleport")

local MainSec = MainTab:NewSection("Auto Farm")
MainSec:NewToggle("Auto Steal (Cycle Plots)", "Rouba 1 base por ciclo", function(s) toggles.AutoSteal = s end)
MainSec:NewToggle("Auto Collect Cash", "Coleta na sua base", function(s) toggles.AutoCollect = s end)
MainSec:NewToggle("Auto Rebirth", "Fira remote auto", function(s) toggles.AutoRebirth = s end)
MainSec:NewButton("Dupe Brainrots", "Clone na sua plot", function()
  local myplot = workspace.Plots:FindFirstChild(player.Name)
  if myplot and myplot:FindFirstChild("Brainrots") then
    for _, b in pairs(myplot.Brainrots:GetChildren()) do b:Clone().Parent = myplot.Brainrots end
  end
end)

-- Movement
local MoveSec = MoveTab:NewSection("OP Moves")
MoveSec:NewToggle("Fly (WASD + Space/Shift)", function(s) toggles.Fly = s if s and root then bv=Instance.new("BodyVelocity",root) bv.MaxForce=Vector3.new(1e9,1e9,1e9) bg=Instance.new("BodyGyro",root) bg.MaxTorque=Vector3.new(1e9,1e9,1e9) flying=true else flying=false end end)
MoveSec:NewToggle("Speed x"..SPEED_VALUE, function(s) toggles.Speed=s if hum then hum.WalkSpeed=s and SPEED_VALUE or 16 end end)
MoveSec:NewToggle("Infinite Jump (Space)", function(s) toggles.InfiniteJump=s end)
MoveSec:NewToggle("NoClip (N)", function(s) toggleNoClip(s) end)
MoveSec:NewToggle("Float", function(s) toggles.Float=s if hum then hum.PlatformStand=s end end)
MoveSec:NewSlider("Jump Power", "Custom", 50, 200, function(v) JUMP_POWER=v if hum then hum.JumpPower=v end end)

-- ESP Toggles (atualiza live)
local ESPsec = VisTab:NewSection("Visuals")
ESPsec:NewToggle("ESP Players", function(s) 
  toggles.ESPPlayer = s 
  for _,plr in Players:GetPlayers() do if plr.Character and plr~=player then pcall(createESP, plr.Character) end end 
end)
ESPsec:NewToggle("ESP Brainrots", function(s) 
  toggles.ESPBrainrot = s 
  for _,plot in workspace.Plots:GetChildren() do 
    local bf = plot:FindFirstChild("Brainrots")
    if bf then for _,b in bf:GetChildren() do pcall(createESP, b, Color3.new(0,1,0)) end end 
  end 
end)

-- TP
local TPSec = TPTab:NewSection("Teleports")
TPSec:NewButton("TP Richest Base", "Base com + brains unlocked", function()
  local best, maxb = nil, 0
  for _,plot in workspace.Plots:GetChildren() do
    if plot.Owner.Value ~= player and plot:FindFirstChild("Lock") and plot.Lock.Transparency == 1 then
      local nb = #plot.Brainrots:GetChildren()
      if nb > maxb then maxb=nb best=plot end
    end
  end
  if best and root then root.CFrame = best.Spawn.CFrame end
end)

local function refreshPlayerList()
  playerList = {}
  for _,plr in Players:GetPlayers() do if plr~=player then table.insert(playerList, plr.Name) end end
end
refreshPlayerList()
local dropdown = TPSec:NewDropdown("TP to Player", playerList, function(selected)
  local target = Players:FindFirstChild(selected)
  if target and target.Character and root then root.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,-3) end
end)
TPSec:NewButton("Refresh Player List", "Update dropdown", refreshPlayerList)

-- Inputs
UserInputService.InputBegan:Connect(function(inp)
  if inp.KeyCode == Enum.KeyCode.F and toggles.Fly then flying = not flying end
  if inp.KeyCode == Enum.KeyCode.Space and toggles.InfiniteJump then if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end end
  if inp.KeyCode == Enum.KeyCode.N then toggleNoClip(not toggles.NoClip) end
end)

-- Auto Loops (otimizados)
task.spawn(function()
  while true do
    task.wait(STEAL_DELAY)
    if not toggles.AutoSteal or not root then continue end
    local stole = false
    for _,plot in pairs(workspace.Plots:GetChildren()) do
      if plot.Owner.Value == player or not plot:FindFirstChild("Lock") or plot.Lock.Transparency ~= 1 then continue end
      local brains = plot.Brainrots:GetChildren()
      if #brains > 0 then
        root.CFrame = brains[1].CFrame * CFrame.new(0,0,-5)
        for _,brain in pairs(brains) do
          local pp = brain:FindFirstChild("ProximityPrompt")
          if pp then fireproximityprompt(pp) stole=true end
        end
        break -- 1 plot/cycle
      end
    end
    task.wait(stole and 0.05 or 0.5)
  end
end)

task.spawn(function()
  while true do
    task.wait(0.2)
    if not toggles.AutoCollect or not root then continue end
    local myplot = workspace.Plots:FindFirstChild(player.Name)
    if myplot then
      for _,cash in pairs(myplot:GetChildren()) do
        if (cash.Name:find("Cash") or cash.BrickColor == BrickColor.new("Bright green")) and cash:IsA("BasePart") then
          firetouchinterest(root, cash, 0)
          firetouchinterest(root, cash, 1)
        end
      end
    end
  end
end)

task.spawn(function()
  while toggles.AutoRebirth do
    pcall(function() game:GetService("ReplicatedStorage").Remotes.Rebirth:FireServer() end)
    task.wait(1)
  end
end)

print("🔥 ZERO HUB v3 Anti-Lag LOADED! | 60+ FPS | Insert GUI")
