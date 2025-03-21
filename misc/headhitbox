-- ⚙ Services
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 🛠 Function to Resize Hitboxes
local function ResizeHitbox(character)
    -- Detect R6 or R15 parts
    local hitboxParts = {
        "Head", "HumanoidRootPart", "Torso", "UpperTorso", "LowerTorso", -- Standard parts
        "RightUpperLeg", "LeftUpperLeg", "RightLeg", "LeftLeg", -- Legs
        "HeadHB" -- Custom hitboxes (like Arsenal)
    }

    for _, partName in ipairs(hitboxParts) do
        local part = character:FindFirstChild(partName)
        if part then
            part.CanCollide = false
            part.Transparency = 0.2 -- More visible than 1
            part.Size = Vector3.new(30, 30, 30) -- Expands hitbox
        end
    end
end

-- 🔄 Loop to Apply Hitbox Expander Continuously
RunService.RenderStepped:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
            if player.Character.Humanoid.Health > 0 then -- Ensure player is alive
                ResizeHitbox(player.Character) -- Apply hitbox expansion
            end
        end
    end
end)
