-- ⚙ Services
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 🛠 Hitbox Modification Function (Runs in a Loop)
local function ModifyHitbox()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
            if player.Character.Humanoid.Health > 0 then -- Ensure player is alive
                local hitboxParts = {
                    "HumanoidRootPart", "Torso", "UpperTorso", "LowerTorso", -- Standard parts
                    "RightUpperLeg", "LeftUpperLeg", "RightLeg", "LeftLeg", -- Legs
                    "HeadHB" -- Custom hitboxes (like Arsenal)
                }

                for _, partName in ipairs(hitboxParts) do
                    local part = player.Character:FindFirstChild(partName)
                    if part then
                        part.CanCollide = false
                        part.Transparency = 0.2
                        part.Size = Vector3.new(30, 30, 30)
                    end
                end

                -- Hide Head
                local head = player.Character:FindFirstChild("Head")
                if head then
                    head.Transparency = 1
                    head.CanCollide = false
                end

                -- Hide Face
                local face = head and head:FindFirstChild("face")
                if face then
                    face.Transparency = 1
                end
            end
        end
    end
end

-- 🔄 Start Loop Automatically
RunService.RenderStepped:Connect(ModifyHitbox)
