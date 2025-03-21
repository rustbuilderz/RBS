-- ⚙ Services
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 🛠 Global Settings (Can be modified from main.lua)
_G.HitboxEnabled = _G.HitboxEnabled or True -- Controls execution
_G.HitboxSize = _G.HitboxSize or Vector3.new(30, 30, 30) -- Default size
_G.HitboxTransparency = _G.HitboxTransparency or 0.2 -- Default transparency (0 = visible, 1 = invisible)
_G.HideHead = _G.HideHead or true -- Hide the head
_G.HideFace = _G.HideFace or true -- Hide the face

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
            part.Transparency = _G.HitboxTransparency
            part.Size = _G.HitboxSize
        end
    end

    -- Hide Head
    if _G.HideHead then
        local head = character:FindFirstChild("Head")
        if head then
            head.Transparency = 1
            head.CanCollide = false
        end
    end

    -- Hide Face
    if _G.HideFace then
        local face = character:FindFirstChild("Head") and character.Head:FindFirstChild("face")
        if face then
            face.Transparency = 1
        end
    end
end

-- 🔄 Loop to Continuously Apply Changes **ONLY WHEN ENABLED**
RunService.RenderStepped:Connect(function()
    if _G.HitboxEnabled then -- ✅ Only run when Hitbox is enabled
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
                if player.Character.Humanoid.Health > 0 then -- Ensure player is alive
                    ModifyHitbox(player.Character) -- Apply changes
                end
            end
        end
    end
end)
