-- ⚙ Servicess
local workspace = game:GetService("Workspace")
local runService = game:GetService("RunService")
local camera = workspace.CurrentCamera

-- Function to create a smooth connected tracer
local function createTracer(bullet)
    if not bullet:IsA("Part") and not bullet:IsA("MeshPart") then return end

    local tracerPoints = {} -- Stores world positions
    local maxTrailLength = 30 -- Adjust for longer/shorter tracer
    local tracerLines = {} -- Stores Drawing objects

    local connection
    connection = runService.RenderStepped:Connect(function()
        -- Remove everything if bullet no longer exists
        if not bullet.Parent then
            connection:Disconnect()
            for _, line in pairs(tracerLines) do
                line:Remove()
            end
            tracerLines = {} -- Ensure memory is freed
            return
        end

        local bulletPos = bullet.Position
        local screenPos, onScreen = camera:WorldToViewportPoint(bulletPos)

        -- Remove tracers if bullet goes off-screen or disappears
        if not onScreen then
            connection:Disconnect()
            for _, line in pairs(tracerLines) do
                line:Remove()
            end
            tracerLines = {} -- Clean up memory
            return
        end

        -- Store the new position
        table.insert(tracerPoints, bulletPos)

        -- Limit trail length
        if #tracerPoints > maxTrailLength then
            table.remove(tracerPoints, 1)
        end

        -- Remove old lines
        for _, line in pairs(tracerLines) do
            line:Remove()
        end
        tracerLines = {}

        -- Draw smooth connected lines
        for i = 1, #tracerPoints - 1 do
            local startPos, vis1 = camera:WorldToViewportPoint(tracerPoints[i])
            local endPos, vis2 = camera:WorldToViewportPoint(tracerPoints[i + 1])

            if vis1 and vis2 then
                local line = Drawing.new("Line")
                line.From = Vector2.new(startPos.X, startPos.Y)
                line.To = Vector2.new(endPos.X, endPos.Y)
                line.Thickness = 2
                line.Color = Color3.fromRGB(255, 0, 0) -- Red
                line.Transparency = math.max(i / #tracerPoints, 0.1) -- Smooth fade

                table.insert(tracerLines, line)
            end
        end
    end)
end

-- ✅ Detect New Bullets
workspace.DescendantAdded:Connect(function(child)
    if child.Name:lower():match("bullet") or (child:IsA("Part") and child.Velocity.Magnitude > 50) then
        createTracer(child)
    end
end)
