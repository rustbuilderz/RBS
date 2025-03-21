local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Load Global Aimbot Settings
local AimSettings = _G.AimbotSettings or {
    Enabled = true,
    AimKey = Enum.UserInputType.MouseButton2,
    FOV = 100,
    LockStrength = 0.8,
    PredictionFactor = 0.08,
    TargetPart = "Head"
}

local function GetClosestPlayer()
    local closestPlayer = nil
    local closestDist = AimSettings.FOV

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(AimSettings.TargetPart) and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local part = player.Character[AimSettings.TargetPart]
            local root = player.Character:FindFirstChild("HumanoidRootPart")

            if root then
                local velocity = root.Velocity * AimSettings.PredictionFactor
                local predictedPos = part.Position + velocity

                local screenPos, onScreen = Camera:WorldToViewportPoint(predictedPos)

                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - UserInputService:GetMouseLocation()).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closestPlayer = player -- Store the player, not just position
                    end
                end
            end
        end
    end

    return closestPlayer
end

local function AimAtTarget(player)
    if player and player.Character and player.Character:FindFirstChild(AimSettings.TargetPart) then
        local part = player.Character[AimSettings.TargetPart]
        local root = player.Character:FindFirstChild("HumanoidRootPart")

        if root then
            local velocity = root.Velocity * AimSettings.PredictionFactor
            local predictedPos = part.Position + velocity
            local targetPos = Camera:WorldToViewportPoint(predictedPos)

            local mousePos = UserInputService:GetMouseLocation()
            local moveX = (targetPos.X - mousePos.X) * AimSettings.LockStrength
            local moveY = (targetPos.Y - mousePos.Y) * AimSettings.LockStrength

            moveX = math.clamp(moveX, -5, 5)
            moveY = math.clamp(moveY, -5, 5)

            mousemoverel(moveX, moveY)
        end
    end
end

RunService.RenderStepped:Connect(function()
    if AimSettings.Enabled then
        local aimKey = AimSettings.AimKey

        local isKeyDown = (typeof(aimKey) == "EnumItem" and aimKey.EnumType == Enum.KeyCode and UserInputService:IsKeyDown(aimKey))
        local isMouseDown = (typeof(aimKey) == "EnumItem" and aimKey.EnumType == Enum.UserInputType and UserInputService:IsMouseButtonPressed(aimKey))

        if isKeyDown or isMouseDown then
            local target = GetClosestPlayer()
            AimAtTarget(target)
        end
    end
end)
