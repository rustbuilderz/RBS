-- ⚙ Services
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- 🌍 Load Global Aimbot Settings
_G.AimbotSettings = _G.AimbotSettings or {
    Enabled = true,
    AimKey = Enum.KeyCode.F,
    FOV = 100,
    LockStrength = 0.8,
    PredictionFactor = 0.08,
    TargetPart = "Head"
}

-- 🎯 Get Closest Target in FOV
local function GetClosestPlayer()
    local closestPlayer = nil
    local closestDist = _G.AimbotSettings.FOV or 100

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(_G.AimbotSettings.TargetPart) and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local part = player.Character[_G.AimbotSettings.TargetPart]
            local root = player.Character:FindFirstChild("HumanoidRootPart")

            if root then
                local velocity = root.Velocity * _G.AimbotSettings.PredictionFactor
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

-- 🔥 Aim at Target
local function AimAtTarget(player)
    if player and player.Character and player.Character:FindFirstChild(_G.AimbotSettings.TargetPart) then
        local part = player.Character[_G.AimbotSettings.TargetPart]
        local root = player.Character:FindFirstChild("HumanoidRootPart")

        if root then
            local velocity = root.Velocity * _G.AimbotSettings.PredictionFactor
            local predictedPos = part.Position + velocity
            local targetPos = Camera:WorldToViewportPoint(predictedPos)

            local mousePos = UserInputService:GetMouseLocation()
            local moveX = (targetPos.X - mousePos.X) * _G.AimbotSettings.LockStrength
            local moveY = (targetPos.Y - mousePos.Y) * _G.AimbotSettings.LockStrength

            moveX = math.clamp(moveX, -5, 5)
            moveY = math.clamp(moveY, -5, 5)

            mousemoverel(moveX, moveY)
        end
    end
end

-- 🚀 Main Aimbot Loop
RunService.RenderStepped:Connect(function()
    if _G.AimbotSettings.Enabled then
        local aimKey = _G.AimbotSettings.AimKey

        local isKeyDown = (typeof(aimKey) == "EnumItem" and aimKey.EnumType == Enum.KeyCode and UserInputService:IsKeyDown(aimKey))
        local isMouseDown = (typeof(aimKey) == "EnumItem" and aimKey.EnumType == Enum.UserInputType and UserInputService:IsMouseButtonPressed(aimKey))

        if isKeyDown or isMouseDown then
            local target = GetClosestPlayer()
            AimAtTarget(target)
        end
    end
end)

