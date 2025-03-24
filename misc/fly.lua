-- ⚙ Services
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 🌍 Ensure Global Settings Exist
_G.GlobalSettings = _G.GlobalSettings or {
    FlyEnabled = false,
    FlySpeed = 50,
    FlyKeybind = Enum.KeyCode.F -- Default keybind (Changeable in UI)
}

-- ✈️ Fly Variables
local flying = false
local flyVelocity
local flyGyro
local movementDirection = Vector3.new(0, 0, 0)
local HumanoidRootPart

-- 🔄 Function to get the latest HumanoidRootPart after respawn
local function UpdateCharacter()
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart") -- Ensure we have a valid part
end

-- Detect Character Respawn
LocalPlayer.CharacterAdded:Connect(function()
    UpdateCharacter()
    if _G.GlobalSettings.FlyEnabled then
        ToggleFly(true) -- Re-enable fly after respawn
    end
end)

-- 🔄 Update Fly Speed Dynamically
local function UpdateFlySpeed(speed)
    _G.GlobalSettings.FlySpeed = speed
end

-- 🚀 Toggle Fly Function
local function ToggleFly(state)
    if not HumanoidRootPart then
        UpdateCharacter() -- Ensure we have the right character part
    end

    if state == nil then
        flying = not flying
    else
        flying = state
    end

    if flying then
        if not HumanoidRootPart then return end

        -- 🛠️ Create BodyVelocity for Movement
        flyVelocity = Instance.new("BodyVelocity")
        flyVelocity.Velocity = Vector3.zero
        flyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        flyVelocity.Parent = HumanoidRootPart

        -- 🔄 Keeps character stable
        flyGyro = Instance.new("BodyGyro")
        flyGyro.CFrame = HumanoidRootPart.CFrame
        flyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        flyGyro.Parent = HumanoidRootPart

    else
        if flyVelocity then
            flyVelocity:Destroy()
            flyVelocity = nil
        end

        if flyGyro then
            flyGyro:Destroy()
            flyGyro = nil
        end

        movementDirection = Vector3.new(0, 0, 0)

    end
end

-- 🎮 Keybind Listener for Fly Toggle
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == _G.GlobalSettings.FlyKeybind then
        ToggleFly()
    end
end)

-- 🎮 Handle Movement Input
local function UpdateMovement()
    movementDirection = Vector3.new(0, 0, 0)

    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
        movementDirection = movementDirection + Vector3.new(0, 0, -1) -- Move forward
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
        movementDirection = movementDirection + Vector3.new(0, 0, 1) -- Move backward
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
        movementDirection = movementDirection + Vector3.new(-1, 0, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
        movementDirection = movementDirection + Vector3.new(1, 0, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        movementDirection = movementDirection + Vector3.new(0, 1, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        movementDirection = movementDirection + Vector3.new(0, -1, 0)
    end

    -- Normalize direction to prevent diagonal speed boost
    if movementDirection.Magnitude > 0 then
        movementDirection = movementDirection.Unit
    end
end

-- 🔄 Update Fly Movement in Real-Time
RunService.RenderStepped:Connect(function()
    if flying and flyVelocity and HumanoidRootPart then
        UpdateMovement()
        local camDirection = workspace.CurrentCamera.CFrame.LookVector
        local rightVector = workspace.CurrentCamera.CFrame.RightVector
        local moveVector = (camDirection * -movementDirection.Z) + (rightVector * movementDirection.X) + (Vector3.new(0, 1, 0) * movementDirection.Y)

        flyVelocity.Velocity = moveVector * _G.GlobalSettings.FlySpeed
        flyGyro.CFrame = workspace.CurrentCamera.CFrame
    end
end)

-- 🌍 Public Functions
_G.SetFly = ToggleFly
_G.UpdateFlySpeed = UpdateFlySpeed

-- Initialize Character on Script Load
UpdateCharacter()

