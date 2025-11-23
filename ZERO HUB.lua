-- SCRIPT SÚPER SIMPLE - STEAL A BRAINROT
-- Solo pega esto y ya robas todo automático + fly + speed

repeat wait() until game:IsLoaded()
local player = game.Players.LocalPlayer
local root = player.Character and player.Character:WaitForChild("HumanoidRootPart")

-- Speed + Fly + NoClip instantáneo
game:GetService("RunService").Heartbeat:Connect(function()
    if player.Character then
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = 120
            hum.JumpPower = 100
        end
        for _,v in pairs(player.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
        if root then
            root.Velocity = Vector3.new(0,0,0) -- Fly básico
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
                root.CFrame += Vector3.new(0,2,0)
            end
        end
    end
end)

-- AUTO STEAL TODO (el más rápido y simple)
spawn(function()
    while wait(0.15) do
        for _,plot in pairs(workspace.Plots:GetChildren()) do
            if plot:FindFirstChild("Lock") and plot.Lock.Transparency == 1 then -- base abierta
                for _,brain in pairs(plot.Brainrots:GetChildren()) do
                    if brain:FindFirstChild("ProximityPrompt") then
                        player.Character.HumanoidRootPart.CFrame = brain.CFrame
                        fireproximityprompt(brain.ProximityPrompt)
                    end
                end
            end
        end
    end
end)

print("Script SIMPLE activado - estás robando todo + fly + speed")
