-- ⚙ Services
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 🛠 Function to Modify Hitboxes
local function ModifyHitbox(character)
    if not character then return end

    local hitboxParts = {
        "HumanoidRootPart", "Torso", "UpperTorso", "LowerTorso", -- Standard parts
        "RightUpperLeg", "LeftUpperLeg", "RightLeg", "LeftLeg", -- Legs
        "HeadHB" -- Custom hitboxes (like Arsenal)
    }

    for _, partName in ipairs(hitboxParts) do
        local part = character:FindFirstChild(partName)
        if part then
            part.CanCollide = false
            part.Transparency = 0.2
            part.Size = Vector3.new(30, 30, 30)
        end
    end

    -- Hide Head
    local head = character:FindFirstChild("Head")
    if head then
        head.Transparency = 1
        head.CanCollide = false
    end

    -- Hide Face
    local face = head and head:FindFirstChild("face")
    if face then
        face.Transparency = 1
    end

    print("[DEBUG] Hitbox Modification Applied!")
end

-- 🔄 Loop to Continuously Apply Changes
RunService.RenderStepped:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
            if player.Character.Humanoid.Health > 0 then
                ModifyHitbox(player.Character)
            end
        end
    end
end)

-- 🆕 Apply Modifications When a Player Spawns
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        task.wait(1) -- Small delay to allow loading
        ModifyHitbox(character)
    end)
end)

print("[DEBUG] Hitbox Modification Script Running!")
