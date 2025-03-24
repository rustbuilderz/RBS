-- ⚙ Services
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- 🌍 Ensure Global Settings Exist
_G.GlobalSettings = _G.GlobalSettings or {
    AimbotEnabled = true,
    AimKey = Enum.KeyCode.F, -- Default keybind
    FOV = 100,              -- ✅ Field of View
    LockStrength = 0.3,     -- ✅ Adjusts aim pull strength
    PredictionFactor = 0.1, -- ✅ Adjusts for movement
    TargetPart = "Head",    -- ✅ Head by default
    Smoothing = 5           -- ✅ Smooth aim movement
}

local lockedTarget = nil -- Stores the locked player
local isHoldingAimKey = false -- Tracks if key is held

-- 🎯 Get Closest Player in FOV
local function GetClosestPlayer()
    local closestPlayer = nil
    local closestDist = _G.GlobalSettings.FOV

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(_G.GlobalSettings.TargetPart) then
            local part = player.Character[_G.GlobalSettings.TargetPart]
            local root = player.Character:FindFirstChild("HumanoidRootPart")

            if root and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                local velocity = root.Velocity * _G.GlobalSettings.PredictionFactor
                local predictedPos = part.Position + velocity
                local screenPos, onScreen = Camera:WorldToViewportPoint(predictedPos)

                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - UserInputService:GetMouseLocation()).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closestPlayer = player
                    end
                end
            end
        end
    end

    return closestPlayer
end

-- 🔥 Aim at Target with Smoothing
local function AimAtTarget(player)
    if player and player.Character and player.Character:FindFirstChild(_G.GlobalSettings.TargetPart) then
        local part = player.Character[_G.GlobalSettings.TargetPart]
        local root = player.Character:FindFirstChild("HumanoidRootPart")

        if root then
            local velocity = root.Velocity * _G.GlobalSettings.PredictionFactor
            local predictedPos = part.Position + velocity
            local targetPos = Camera:WorldToViewportPoint(predictedPos)

            local mousePos = UserInputService:GetMouseLocation()
            local moveX = (targetPos.X - mousePos.X) * _G.GlobalSettings.LockStrength
            local moveY = (targetPos.Y - mousePos.Y) * _G.GlobalSettings.LockStrength

            -- Apply Smoothing
            local smoothingFactor = math.clamp(_G.GlobalSettings.Smoothing / 10, 0.1, 1)
            moveX = moveX * smoothingFactor
            moveY = moveY * smoothingFactor

            -- Move mouse
            mousemoverel(moveX, moveY)
        end
    end
end

-- 🛠 Detect Aim Key Press
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == _G.GlobalSettings.AimKey then
        isHoldingAimKey = true
        lockedTarget = GetClosestPlayer() -- Lock onto the first target found
    end
end)

-- 🛠 Detect Aim Key Release
UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.KeyCode == _G.GlobalSettings.AimKey then
        isHoldingAimKey = false
        lockedTarget = nil -- ✅ RESET TARGET IMMEDIATELY ON KEY RELEASE
    end
end)

-- 🔄 Main Aimbot Loop
RunService.RenderStepped:Connect(function()
    if _G.GlobalSettings.AimbotEnabled and isHoldingAimKey then
        if lockedTarget then
            AimAtTarget(lockedTarget)
        end
    end
end)
--test
