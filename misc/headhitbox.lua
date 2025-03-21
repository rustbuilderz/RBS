-- ⚙ Services
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

print("[DEBUG] Head Hitbox Script Loaded - Running...")

-- 🛠 Function to Modify Head Hitbox and Hide All Heads
local function ModifyHeadHitbox(character)
    if not character then return end

    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end

    -- Detect R6 and R15 Head Types
    local head = character:FindFirstChild("Head") -- Standard R6/R15 Head
    local meshHead = character:FindFirstChildOfClass("MeshPart") -- UGC / Custom Heads

    -- Modify R6/R15 Standard Head
    if head and head:IsA("BasePart") then
        head.Size = Vector3.new(21, 21, 21) -- Enlarged Hitbox
        head.CanCollide = false
        head.Massless = true
        head.Transparency = 1 -- Make head invisible

        -- Hide Face if Exists
        local face = head:FindFirstChild("face")
        if face then
            face.Transparency = 1
        end

        -- Hide SpecialMesh Heads (Like "Circle" Heads)
        local specialMesh = head:FindFirstChildOfClass("SpecialMesh")
        if specialMesh then
            specialMesh.TextureId = "" -- Remove Texture
            specialMesh.VertexColor = Vector3.new(0, 0, 0) -- Black to hide
        end
    end

    -- Modify UGC / Custom Mesh Heads
    if meshHead and meshHead:IsA("MeshPart") then
        meshHead.Transparency = 1 -- Make UGC Heads Invisible
        meshHead.CanCollide = false
        meshHead.Massless = true
    end

    print("[DEBUG] Head Modified for:", character.Name)
end

-- 🔄 Constantly Modify Head Hitbox
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
