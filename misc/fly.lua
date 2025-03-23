-- ⚙ Services
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Wait for character to load
repeat wait() until LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

local Character = LocalPlayer.Character
local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
local Humanoid = Character:FindFirstChildOfClass("Humanoid")

-- 🌍 Ensure Global Settings Exist
_G.GlobalSettings = _G.GlobalSettings or {
    FlyEnabled = false,
    FlySpeed = 50,
    FlyKeybind = Enum.KeyCode.E -- Default Keybind
}

-- ✈️ Fly Variables
local flying = false
local flyVelocity
local flyGyro

-- 🛠️ Fly Control Function
local function ToggleFly(state)
    if not HumanoidRootPart then return end

    if state == nil then
        flying = not flying
    else
        flying = state
    end

    if flying then
        -- 🚀 Create BodyVelocity to Move Freely
        flyVelocity = Instance.new("BodyVelocity")
        flyVelocity.Velocity = Vector3.new(0, 0, 0) -- No forced movement
        flyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        flyVelocity.Parent = HumanoidRootPart

        -- 🌀 Create BodyGyro to Keep Player Stable
        flyGyro = Instance.new("BodyGyro")
        flyGyro.CFrame = HumanoidRootPart.CFrame
        flyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        flyGyro.P = 9000
        flyGyro.Parent = HumanoidRootPart

        print("🚀 Fly Enabled")
    else
        if flyVelocity then flyVelocity:Destroy() flyVelocity = nil end
        if flyGyro then flyGyro:Destroy() flyGyro = nil end

        print("🛑 Fly Disabled")
    end
end

-- 🔄 Update Fly Speed Dynamically
local function UpdateFlySpeed(speed)
    _G.GlobalSettings.FlySpeed = speed
end

-- 🕹️ Handle Player Movement While Flying
RunService.RenderStepped:Connect(function()
    if flying and HumanoidRootPart then
        local direction = Vector3.zero

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            direction = direction + (Camera.CFrame.LookVector * _G.GlobalSettings.FlySpeed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            direction = direction - (Camera.CFrame.LookVector * _G.GlobalSettings.FlySpeed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            direction = direction - (Camera.CFrame.RightVector * _G.GlobalSettings.FlySpeed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            direction = direction + (Camera.CFrame.RightVector * _G.GlobalSettings.FlySpeed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            direction = direction + Vector3.new(0, _G.GlobalSettings.FlySpeed, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            direction = direction - Vector3.new(0, _G.GlobalSettings.FlySpeed, 0)
        end

        flyVelocity.Velocity = direction
        flyGyro.CFrame = Camera.CFrame
    end
end)

-- 🎮 Keybind Listener for Fly Toggle
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == _G.GlobalSettings.FlyKeybind then
        ToggleFly()
    end
end)

-- 🌍 Public Functions
_G.SetFly = ToggleFly
_G.UpdateFlySpeed = UpdateFlySpeed

print("✅ Fly Script Loaded Successfully")
