-- Script Custom Grok para Steal a Brainrot | Fly + Speed + NoClip + ESP
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootpart = character:WaitForChild("HumanoidRootPart")

-- Speed Hack
humanoid.WalkSpeed = 100  -- Mude pra mais rápido

-- NoClip
local noclip = false
RunService.Heartbeat:Connect(function()
    if noclip then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.N then
        noclip = not noclip
        print("NoClip: " .. (noclip and "ON" or "OFF"))
    end
end)

-- Fly (Tecla F)
local flying = false
local flySpeed = 50
local bodyVelocity = Instance.new("BodyVelocity")
local bodyGyro = Instance.new("BodyGyro")
bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
bodyVelocity.Velocity = Vector3.new(0, 0, 0)
bodyGyro.MaxTorque = Vector3.new(4000, 4000, 4000)
bodyGyro.CFrame = rootpart.CFrame

local function toggleFly()
    flying = not flying
    if flying then
        bodyVelocity.Parent = rootpart
        bodyGyro.Parent = rootpart
    else
        bodyVelocity.Parent = nil
        bodyGyro.Parent = nil
    end
end
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F then
        toggleFly()
        print("Fly: " .. (flying and "ON" or "OFF"))
    end
end)
RunService.Heartbeat:Connect(function()
    if flying then
        local cam = workspace.CurrentCamera
        local move = humanoid.MoveDirection * flySpeed
        bodyVelocity.Velocity = Vector3.new(move.X, 0, move.Z)
        bodyGyro.CFrame = cam.CFrame
    end
end)

-- ESP Básico (Players e Bases - destaque vermelhos)
for _, plr in pairs(Players:GetPlayers()) do
    if plr ~= player and plr.Character then
        local highlight = Instance.new("Highlight")
        highlight.FillColor = Color3.new(1, 0, 0)
        highlight.OutlineColor = Color3.new(1, 1, 1)
        highlight.Parent = plr.Character
    end
end
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        local highlight = Instance.new("Highlight")
        highlight.FillColor = Color3.new(1, 0, 0)
        highlight.OutlineColor = Color3.new(1, 1, 1)
        highlight.Parent = char
    end)
end)

print("Script Custom Carregado! | F=Fly | N=NoClip | Speed=100")
