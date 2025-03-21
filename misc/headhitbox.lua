-- ⚙ Services
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 🛠 Local Settings
local hitboxEnabled = true -- Controls execution
local hitboxSize = Vector3.new(30, 30, 30) -- Default size
local hitboxTransparency = 0.2 -- Default transparency (0 = visible, 1 = invisible)
local hideHead = true -- Hide the head
local hideFace = true -- Hide the face

-- 🛠 Function to Modify Hitboxes
local function ModifyHitbox(character)
    local hitboxParts = {
        "HumanoidRootPart", "Torso", "UpperTorso", "LowerTorso", -- Standard parts
        "RightUpperLeg", "LeftUpperLeg", "RightLeg", "LeftLeg", -- Legs
        "HeadHB" -- Custom hitboxes (like Arsenal)
    }

    -- Resize standard hitboxes
    for _, partName in ipairs(hitboxParts) do
        local part = character:FindFirstChild(partName)
        if part then
            part.CanCollide = false
            part.Transparency = hitboxTransparency
            part.Size = hitboxSize
        end
    end

    -- Hide Head
    if hideHead then
        local head = character:FindFirstChild("Head")
        if head then
            head.Transparency = 1
            head.CanCollide = false
        end
    end

    -- Hide Face
    if hideFace then
        local face = character:FindFirstChild("Head") and character.Head:FindFirstChild("face")
        if face then
            face.Transparency = 1
        end
    end
end

-- 🔄 Loop to Continuously Apply Changes **ONLY WHEN ENABLED**
RunService.RenderStepped:Connect(function()
    if hitboxEnabled then -- ✅ Only run when hitbox is enabled
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
                if player.Character.Humanoid.Health > 0 then -- Ensure player is alive
                    ModifyHitbox(player.Character) -- Apply changes
                end
            end
        end
    end
end)

-- 🛠 Function to Toggle Hitbox
local function ToggleHitbox()
    hitboxEnabled = not hitboxEnabled
    print("[DEBUG] Hitbox Enabled:", hitboxEnabled)
end

-- Example of how to bind a key to toggle hitbox
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.H then -- Press "H" to toggle
        ToggleHitbox()
    end
end)
