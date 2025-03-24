-- ⚙ Services
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- 🌍 Ensure Global Settings Exist
_G.GlobalSettings = _G.GlobalSettings or {
    AimbotEnabled = true,  -- ✅ Toggle via UI
    AimKey = Enum.KeyCode.F, -- Default to 'F' key
    FOV = 100,              -- ✅ Field of View for target selection
    LockStrength = 0.3,     -- ✅ How strong the aim assist is (0.0 - 1.0)
    PredictionFactor = 0.1, -- ✅ Adjusts for movement
    TargetPart = "Head",    -- ✅ Aim at Head (can be set to "Torso")
    KeepTarget = true,      -- ✅ New: Keeps target until key is released
    Smoothing = 5           -- ✅ NEW: Smoothness factor (higher = smoother, lower = snappier)
}

-- 🔄 Current Target Variable
local currentTarget = nil

-- 🎯 Function: Get Closest Player in FOV
local function GetClosestPlayer()
    if _G.GlobalSettings.KeepTarget and currentTarget and currentTarget.Character and currentTarget.Character:FindFirstChild(_G.GlobalSettings.TargetPart) then
        return currentTarget -- Keeps the locked target if valid
    end

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

-- 🔥 Function: Aim at Target (Now with Smoothing)
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

            -- ✅ Apply Smoothing
            local smoothFactor = _G.GlobalSettings.Smoothing
            moveX = moveX / smoothFactor
            moveY = moveY / smoothFactor

            -- ✅ Clamp the movement to prevent excessive movement
            moveX = math.clamp(moveX, -10, 10)
            moveY = math.clamp(moveY, -10, 10)

            -- ✅ Move the mouse gradually
            mousemoverel(moveX, moveY)
        end
    end
end

-- 🔄 Track Key Release to Reset Target
UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == _G.GlobalSettings.AimKey then
        currentTarget = nil -- Release target when key is released
    end
end)

-- 🔄 Main Aimbot Loop
RunService.RenderStepped:Connect(function()
    if _G.GlobalSettings.AimbotEnabled then
        local aimKey = _G.GlobalSettings.AimKey
        local isKeyDown = (typeof(aimKey) == "EnumItem" and aimKey.EnumType == Enum.KeyCode and UserInputService:IsKeyDown(aimKey))
        local isMouseDown = (typeof(aimKey) == "EnumItem" and aimKey.EnumType == Enum.UserInputType and UserInputService:IsMouseButtonPressed(aimKey))

        if isKeyDown or isMouseDown then
            if not currentTarget or not _G.GlobalSettings.KeepTarget then
                currentTarget = GetClosestPlayer() -- Only update target if not locked
            end

            if currentTarget then
                AimAtTarget(currentTarget)
            end
        end
    end
end)
