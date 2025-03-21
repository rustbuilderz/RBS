-- ⚙ Services
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

print("[DEBUG] Head Hitbox Script Loaded - Running...")

-- 🛠 Function to Modify Head Hitbox
local function ModifyHeadHitbox(character)
    if not character then return end

    local head = character:FindFirstChild("Head")
    if head then
        head.Size = Vector3.new(21, 21, 21) -- Enlarged Head Hitbox
        head.CanCollide = false
        head.Massless = true
        print("[DEBUG] Head Hitbox Modified for:", character.Name)
    end
end

-- 🔄 Loop to Constantly Modify Head Hitbox
task.spawn(function()
    while true do
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
                if player.Character.Humanoid.Health > 0 then
                    ModifyHeadHitbox(player.Character)
                end
            end
        end
        task.wait(0.1) -- Runs every 0.1 seconds
    end
end)

-- 🆕 Apply Modifications When a Player Spawns
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        task.wait(1) -- Delay for character to fully load
        ModifyHeadHitbox(character)
    end)
end)

print("[DEBUG] Head Hitbox Script Running!")
