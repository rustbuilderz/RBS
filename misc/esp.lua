
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer


local ESPSettings = {
    Enabled = true,
    BoxColor = Color3.fromRGB(255, 0, 0), -- Red
    NameColor = Color3.fromRGB(255, 255, 255), -- White
    TracerColor = Color3.fromRGB(0, 255, 0) -- Green
}


local ESPObjects = {}


local function CreateESP(player)
    if player == LocalPlayer or ESPObjects[player] then return end

    local box = Drawing.new("Square")
    local name = Drawing.new("Text")
    local tracer = Drawing.new("Line")

    ESPObjects[player] = {Box = box, Name = name, Tracer = tracer}

    box.Color = ESPSettings.BoxColor
    box.Thickness = 2
    box.Filled = false
    box.Visible = false

    name.Color = ESPSettings.NameColor
    name.Size = 18
    name.Center = true
    name.Outline = true
    name.Visible = false

    tracer.Color = ESPSettings.TracerColor
    tracer.Thickness = 1.5
    tracer.Visible = false
end

local function RemoveESP(player)
    if ESPObjects[player] then
        for _, obj in pairs(ESPObjects[player]) do
            obj:Remove()
        end
        ESPObjects[player] = nil
    end
end


task.spawn(function()
    while true do
        if ESPSettings.Enabled then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
                    local humanoid = player.Character.Humanoid

                    if humanoid.Health > 0 then -- Only update for alive players
                        if not ESPObjects[player] then
                            CreateESP(player)
                        end

                        local esp = ESPObjects[player]
                        local rootPart = player.Character.HumanoidRootPart
                        local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)

                        if onScreen then -- Hide ESP if player is off-screen
                            local size = math.clamp(3000 / (Camera.CFrame.Position - rootPart.Position).Magnitude, 40, 120)

                            esp.Box.Size = Vector2.new(size, size * 2)
                            esp.Box.Position = Vector2.new(screenPos.X - size / 2, screenPos.Y - size / 2)
                            esp.Box.Visible = true

                            esp.Name.Text = player.Name
                            esp.Name.Position = Vector2.new(screenPos.X, screenPos.Y - size / 2 - 15)
                            esp.Name.Visible = true

                            esp.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                            esp.Tracer.To = Vector2.new(screenPos.X, screenPos.Y)
                            esp.Tracer.Visible = true
                        else
                            esp.Box.Visible = false
                            esp.Name.Visible = false
                            esp.Tracer.Visible = false
                        end
                    else
                        RemoveESP(player)
                    end
                else
                    RemoveESP(player)
                end
            end
        end
        task.wait(0.007) 
    end
end)


Players.PlayerRemoving:Connect(RemoveESP)
