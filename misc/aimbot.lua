local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

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
                        closestPlayer = predictedPos
                    end
                end
            end
        end
    end

    return closestPlayer
end

local function AimAtTarget(target)
    if target then
        local targetPos = Camera:WorldToViewportPoint(target)
        local mousePos = UserInputService:GetMouseLocation()

        local moveX = (targetPos.X - mousePos.X) * AimSettings.LockStrength
        local moveY = (targetPos.Y - mousePos.Y) * AimSettings.LockStrength

        moveX = math.clamp(moveX, -4, 4)
        moveY = math.clamp(moveY, -4, 4)

        mousemoverel(moveX, moveY)
    end
end

RunService.RenderStepped:Connect(function()
    if AimSettings.Enabled and UserInputService:IsMouseButtonPressed(AimSettings.AimKey) then
        local target = GetClosestPlayer()
        AimAtTarget(target)
    end
end)
