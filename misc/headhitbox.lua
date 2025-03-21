-- // ⚙ SERVICES
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local MenuVisible = false

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
        task.wait(1) -- Delay for loading
        ModifyHeadHitbox(character)
    end)
end)

print("[DEBUG] Head Hitbox Script Running!")

-- // 🖥 CUSTOMIZATION UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HeadHitboxUI"
screenGui.Parent = CoreGui
screenGui.Enabled = false -- Hidden initially

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 180)
frame.Position = UDim2.new(0.4, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 2
frame.Draggable = true
frame.Active = true
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "🎯 Head Hitbox Settings"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
title.Parent = frame

-- // 🛠 SLIDER FUNCTION
local function createSlider(labelText, minValue, maxValue, defaultValue, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 50)
    container.BackgroundTransparency = 1
    container.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Text = labelText .. ": " .. tostring(defaultValue)
    label.TextSize = 14
    label.Font = Enum.Font.SourceSans
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.BackgroundTransparency = 1
    label.Parent = container

    local slider = Instance.new("TextButton")
    slider.Size = UDim2.new(1, 0, 0, 30)
    slider.Text = "⬅ Drag to Adjust ➡"
    slider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    slider.TextColor3 = Color3.fromRGB(255, 255, 255)
    slider.Parent = container

    local dragging = false

    slider.MouseButton1Down:Connect(function()
        dragging = true
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mouseX = input.Position.X
            local screenWidth = game:GetService("Workspace").CurrentCamera.ViewportSize.X
            local percentage = math.clamp(mouseX / screenWidth, 0, 1)
            local value = math.floor(minValue + (maxValue - minValue) * percentage)
            label.Text = labelText .. ": " .. tostring(value)
            callback(value)
        end
    end)
end

-- // 🎯 HITBOX SIZE SLIDER
createSlider("Hitbox Size", 5, 50, 21, function(value)
    HitboxSize = Vector3.new(value, value, value)
end)

-- // 🔄 TRANSPARENCY SLIDER
createSlider("Transparency", 0, 1, 0, function(value)
    HitboxTransparency = value
end)

-- // 🚀 TOGGLE MENU WITH INSERT
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        MenuVisible = not MenuVisible
        screenGui.Enabled = MenuVisible
        print("[DEBUG] UI Toggled:", MenuVisible)
    end
end)

print("[DEBUG] Customization UI Ready!")
