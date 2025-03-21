-- ⚙ Services
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local modifyingHitbox = false -- Toggle for modifying hitbox

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

    -- Modify Head Size (if exists)
    local head = character:FindFirstChild("Head")
    if head then
        head.Size = Vector3.new(10, 10, 10) -- Adjust head size
        head.Transparency = 1
        head.CanCollide = false
    end

    -- Hide Face
    local face = head and head:FindFirstChild("face")
    if face then
        face.Transparency = 1
    end
end

-- 🔄 Loop to Continuously Modify Hitboxes When Enabled
local function StartHitboxLoop()
    if modifyingHitbox then return end
    modifyingHitbox = true

    task.spawn(function()
        while modifyingHitbox do
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
                    if player.Character.Humanoid.Health > 0 then
                        ModifyHitbox(player.Character)
                    end
                end
            end
            task.wait(0.1) -- Small delay to optimize performance
        end
    end)
end

-- 🆕 Modify Players on Respawn
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        task.wait(1) -- Delay for character to fully load
        ModifyHitbox(character)
    end)
end)

-- 🖥 Create UI Button for Hitbox Modification
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 100)
frame.Position = UDim2.new(0.1, 0, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Parent = screenGui

local hitboxButton = Instance.new("TextButton")
hitboxButton.Size = UDim2.new(1, 0, 0, 30)
hitboxButton.Text = "Modify Hitbox"
hitboxButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
hitboxButton.TextColor3 = Color3.fromRGB(255, 255, 255)
hitboxButton.Parent = frame

hitboxButton.MouseButton1Click:Connect(function()
    print("[DEBUG] Button Clicked: Modify Hitbox")
    StartHitboxLoop() -- Start modifying hitboxes on button press
end)

print("[DEBUG] Hitbox Modification Script Running!")
