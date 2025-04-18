-- ⚙ Services
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 🌍 Global Silent Aim & Hitbox Size Variables
_G.SilentAimEnabled = _G.SilentAimEnabled or false
_G.HeadHitboxSize = _G.HeadHitboxSize or Vector3.new(5, 5, 5) -- Default size

-- 🛠 Function to Modify Head Hitbox Dynamically
local function ModifyHeadHitbox(character)
    if not _G.SilentAimEnabled then return end -- Stop if SilentAim is disabled
    if not character then return end

    local hitboxSize = _G.HeadHitboxSize -- Use global size
    local transparency = _G.settings and _G.settings.headTransparency or 1

    for _, part in pairs(character:GetChildren()) do
        if (part:IsA("MeshPart") or part:IsA("Part")) and part.Name == "Head" then
            -- Apply Hitbox Modifications
            part.Size = hitboxSize
            part.CanCollide = false
            part.Massless = true
            part.Transparency = transparency

            -- Hide Face Textures
            for _, child in pairs(part:GetChildren()) do
                if child:IsA("Decal") or child:IsA("Texture") then
                    child.Transparency = transparency
                end
            end
        end
    end
end

-- 🔄 Constantly Modify Head Hitbox Based on Settings
task.spawn(function()
    while true do
        if _G.SilentAimEnabled then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
                    if player.Character.Humanoid.Health > 0 then
                        ModifyHeadHitbox(player.Character)
                    end
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
