-- // ⚙ SERVICES
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local MenuVisible = true -- UI starts visible

print("[DEBUG] Head Hitbox Script Loaded - Running...")

-- // 🎨 DEFAULT SETTINGS
local HitboxSize = Vector3.new(21, 21, 21)
local HitboxTransparency = 0

-- // 🛠 FUNCTION TO MODIFY HEAD HITBOX
local function ModifyHeadHitbox(character)
    if not character then return end
    local head = character:FindFirstChild("Head")
    
    if head then
        head.Size = HitboxSize
        head.Transparency = HitboxTransparency
        head.CanCollide = false
        head.Massless = true

        -- Hide face decal if exists
        local face = head:FindFirstChild("face")
        if face then
            face.Transparency = 1
        end
    end
end

-- // 🔄 APPLY TO ALL PLAYERS
task.spawn(function()
    while true do
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
                if player.Character.Humanoid.Health > 0 then
                    ModifyHeadHitbox(player.Character)
                end
            end
        end
        task.wait(0.1) -- Updates every 0.1 seconds
    end
end)

-- // 🆕 APPLY WHEN PLAYER SPAWNS
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        task.wait(1) -- Allow character to fully load
        ModifyHeadHitbox(character)
    end)
end)

-- // 🖥 CREATE UI
local screenGui = Instance.new("ScreenGui", CoreGui)
screenGui.Name = "HeadHitboxUI"

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 250, 0, 150)
frame.Position = UDim2.new(0.1, 0, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 2
frame.Visible = true

local sizeInput = Instance.new("TextBox", frame)
sizeInput.Size = UDim2.new(1, 0, 0, 30)
sizeInput.Position = UDim2.new(0, 0, 0, 10)
sizeInput.PlaceholderText = "Enter hitbox size (e.g., 21,21,21)"
sizeInput.Text = "21,21,21"

local transparencyInput = Instance.new("TextBox", frame)
transparencyInput.Size = UDim2.new(1, 0, 0, 30)
transparencyInput.Position = UDim2.new(0, 0, 0, 50)
transparencyInput.PlaceholderText = "Enter transparency (0-1)"
transparencyInput.Text = "0"

local applyButton = Instance.new("TextButton", frame)
applyButton.Size = UDim2.new(1, 0, 0, 30)
applyButton.Position = UDim2.new(0, 0, 0, 90)
applyButton.Text = "Apply"

applyButton.MouseButton1Click:Connect(function()
    local sizeValues = {}
    for value in string.gmatch(sizeInput.Text, "%d+") do
        table.insert(sizeValues, tonumber(value))
    end
    if #sizeValues == 3 then
        HitboxSize = Vector3.new(sizeValues[1], sizeValues[2], sizeValues[3])
    end

    local transparencyValue = tonumber(transparencyInput.Text)
    if transparencyValue then
        HitboxTransparency = math.clamp(transparencyValue, 0, 1)
    end

    print("[DEBUG] Applied New Hitbox Settings: Size = ", HitboxSize, ", Transparency = ", HitboxTransparency)
end)

-- // ⌨️ TOGGLE UI WITH INSERT
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Insert then
        frame.Visible = not frame.Visible
    end
end)

print("[DEBUG] Head Hitbox UI Loaded & Running!")
