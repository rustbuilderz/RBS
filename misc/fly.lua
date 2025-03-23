-- ⚙ Services
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

-- 🌍 Ensure Global Settings Exist
_G.GlobalSettings = _G.GlobalSettings or {
    FlyEnabled = false,
    FlySpeed = 50,
    FlyKeybind = Enum.KeyCode.F -- Default keybind (Changeable in UI)
}

-- ✈️ Fly Variables
local flying = false
local flyVelocity

-- 🔄 Update Fly Speed Dynamically
local function UpdateFlySpeed(speed)
    _G.GlobalSettings.FlySpeed = speed
    if flying and flyVelocity then
        flyVelocity.Velocity = Vector3.new(0, speed, 0)
    end
end

-- 🚀 Toggle Fly Function
local function ToggleFly(state)
    if state == nil then
        flying = not flying
    else
        flying = state
    end

    if flying then
        if not HumanoidRootPart then return end

        -- 🛠️ Create BodyVelocity for Flight
        flyVelocity = Instance.new("BodyVelocity")
        flyVelocity.Velocity = Vector3.new(0, _G.GlobalSettings.FlySpeed, 0)
        flyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        flyVelocity.Parent = HumanoidRootPart

        print("🚀 Fly Enabled")
    else
        if flyVelocity then
            flyVelocity:Destroy()
            flyVelocity = nil
        end

        print("🛑 Fly Disabled")
    end
end

-- 🎮 Keybind Listener for Fly Toggle
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == _G.GlobalSettings.FlyKeybind then
        ToggleFly()
    end
end)

-- 🔄 Update Fly Speed in Real-Time
RunService.RenderStepped:Connect(function()
    if flying and flyVelocity then
        flyVelocity.Velocity = Vector3.new(0, _G.GlobalSettings.FlySpeed, 0)
    end
end)

-- 🌍 Public Functions
_G.SetFly = ToggleFly
_G.UpdateFlySpeed = UpdateFlySpeed

print("✅ Fly Script Loaded Successfully")
