-- ⚙ Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- 🌍 Global Settings for ESP
_G.GlobalSettings = _G.GlobalSettings or {
    ESPEnabled = false,
    ESPBox = false,
    ESPName = false,
    ESPTracer = false,
    BoxColor = Color3.fromRGB(255, 0, 0), -- Red
    NameColor = Color3.fromRGB(255, 255, 255), -- White
    TracerColor = Color3.fromRGB(0, 255, 0) -- Green
}

-- 📌 Global ESP Objects
_G.GlobalESPObjects = _G.GlobalESPObjects or {}

-- 🎯 Create ESP for a Player
local function CreateESP(player)
    if player == LocalPlayer or _G.GlobalESPObjects[player] then return end

    local box = Drawing.new("Square")
    local name = Drawing.new("Text")
    local tracer = Drawing.new("Line")

    _G.GlobalESPObjects[player] = {Box = box, Name = name, Tracer = tracer}

    -- 🔲 Box
    box.Color = _G.GlobalSettings.BoxColor
    box.Thickness = 2
    box.Filled = false
    box.Visible = false

    -- 🔤 Name
    name.Color = _G.GlobalSettings.NameColor
    name.Size = 18
    name.Center = true
    name.Outline = true
    name.Visible = false

    -- ➖ Tracer
    tracer.Color = _G.GlobalSettings.TracerColor
    tracer.Thickness = 1.5
    tracer.Visible = false
end

-- ❌ Remove ESP for a Player
local function RemoveESP(player)
    if _G.GlobalESPObjects[player] then
        for _, obj in pairs(_G.GlobalESPObjects[player]) do
            obj:Remove()
        end
        _G.GlobalESPObjects[player] = nil
    end
end

-- 🔄 Update ESP Every Frame
task.spawn(function()
    while true do
        if _G.GlobalSettings.ESPEnabled then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
                    local humanoid = player.Character.Humanoid

                    if humanoid.Health > 0 then -- Only update for alive players
                        if not _G.GlobalESPObjects[player] then
                            CreateESP(player)
                        end

                        local esp = _G.GlobalESPObjects[player]
                        local rootPart = player.Character.HumanoidRootPart
                        local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)

                        if onScreen then -- Hide ESP if player is off-screen
                            local size = math.clamp(3000 / (Camera.CFrame.Position - rootPart.Position).Magnitude, 40, 120)

                            -- 🔲 ESP Box
                            esp.Box.Size = Vector2.new(size, size * 2)
                            esp.Box.Position = Vector2.new(screenPos.X - size / 2, screenPos.Y - size / 2)
                            esp.Box.Visible = _G.GlobalSettings.ESPBox

                            -- 🔤 Name Tag
                            esp.Name.Text = player.Name
                            esp.Name.Position = Vector2.new(screenPos.X, screenPos.Y - size / 2 - 15)
                            esp.Name.Visible = _G.GlobalSettings.ESPName

                            -- ➖ Tracer
                            esp.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                            esp.Tracer.To = Vector2.new(screenPos.X, screenPos.Y)
                            esp.Tracer.Visible = _G.GlobalSettings.ESPTracer
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
        else
            -- 🔴 If ESP is Disabled, Hide All Elements
            for _, esp in pairs(_G.GlobalESPObjects) do
                esp.Box.Visible = false
                esp.Name.Visible = false
                esp.Tracer.Visible = false
            end
        end
        task.wait(0.007) 
    end
end)

-- 🚀 Handle Player Removal
Players.PlayerRemoving:Connect(RemoveESP)
