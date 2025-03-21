-- ⚙ Services
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

print("[DEBUG] Head Hitbox Script Loaded - Running...")

-- 🏷️ Table for Known Head Types
local HeadTypes = {
    ["Head"] = true, -- Standard R6/R15 head
    ["MeshPart"] = true, -- UGC or custom mesh head
    ["SpecialMesh"] = true -- Custom special-mesh head
}

-- 🛠 Function to Modify Head Hitbox and Ensure Visibility is Disabled
local function ModifyHeadHitbox(character)
    if not character then return end

    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end

    -- Check for Different Head Types
    for _, obj in pairs(character:GetChildren()) do
        if HeadTypes[obj.ClassName] then
            -- Modify Hitbox Size
            obj.Size = Vector3.new(21, 21, 21)
            obj.CanCollide = false
            obj.Massless = true
            obj.Transparency = 1 -- Fully Invisible

            -- Hide Decals or Textures (Faces, UGC Skins, etc.)
            for _, child in pairs(obj:GetChildren()) do
                if child:IsA("Decal") or child:IsA("Texture") then
                    child.Transparency = 1
                elseif child:IsA("SpecialMesh") then
                    child.TextureId = "" -- Remove Custom Mesh Textures
                    child.VertexColor = Vector3.new(0, 0, 0) -- Hide SpecialMesh
                end
            end

            print("[DEBUG] Head Modified for:", character.Name)
        end
    end
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
