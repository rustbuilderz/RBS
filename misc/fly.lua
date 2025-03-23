-- 🌍 Ensure Fly Settings Exist
_G.FlySettings = _G.FlySettings or {
    FlyEnabled = false,
    FlySpeed = 50
}

-- ⚙ Services
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- 🏃 Fly Variables
local flying = false
local bodyVelocity
local bodyGyro

-- 🎮 Function: Start/Stop Flying
local function SetFly(state)
    if state and not flying then
        flying = true

        -- 🚀 Create Flight Mechanics
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVelocity.Parent = HumanoidRootPart

        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.CFrame = HumanoidRootPart.CFrame
        bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodyGyro.Parent = HumanoidRootPart

        -- 🎯 Flight Control
        RunService.RenderStepped:Connect(function()
            if flying then
                local moveVector = Vector3.new(0, 0, 0)

                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    moveVector = moveVector + (workspace.CurrentCamera.CFrame.LookVector * _G.FlySettings.FlySpeed)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    moveVector = moveVector - (workspace.CurrentCamera.CFrame.LookVector * _G.FlySettings.FlySpeed)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    moveVector = moveVector - (workspace.CurrentCamera.CFrame.RightVector * _G.FlySettings.FlySpeed)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    moveVector = moveVector + (workspace.CurrentCamera.CFrame.RightVector * _G.FlySettings.FlySpeed)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    moveVector = moveVector + Vector3.new(0, _G.FlySettings.FlySpeed, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                    moveVector = moveVector - Vector3.new(0, _G.FlySettings.FlySpeed, 0)
                end

                bodyVelocity.Velocity = moveVector
                bodyGyro.CFrame = workspace.CurrentCamera.CFrame
            end
        end)
    elseif not state and flying then
        flying = false
        if bodyVelocity then bodyVelocity:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
    end
end

-- 🎛️ UI Toggle for Fly
_G.ToggleFly = function()
    _G.FlySettings.FlyEnabled = not _G.FlySettings.FlyEnabled
    SetFly(_G.FlySettings.FlyEnabled)
    print(_G.FlySettings.FlyEnabled and "🚀 Flying Enabled" or "⛔ Flying Disabled")
end

-- 🏁 Keybind for Fly (Press 'F' to toggle)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F then
        _G.ToggleFly()
    end
end)

print("✅ Fly Script Loaded")
