-- // ⚙ SERVICES
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

print("[DEBUG] Script Loaded - Initializing UI...")

-- // 🌍 GLOBAL SETTINGS
_G.settings = _G.settings or {
    headHitboxSize = Vector3.new(21, 21, 21),
    headTransparency = 1,
}

-- // 📜 SCRIPT URLS
local scripts = {
    Aimbot = "https://raw.githubusercontent.com/rustbuilderz/RBS/main/misc/aimbot.lua",
    ESP = "https://raw.githubusercontent.com/rustbuilderz/RBS/main/misc/esp.lua",
    Fly = "https://raw.githubusercontent.com/rustbuilderz/RBS/main/misc/fly.lua",
    InfiniteJump = "https://raw.githubusercontent.com/rustbuilderz/RBS/main/misc/infinitejump.lua",
    Rejoin = "https://raw.githubusercontent.com/rustbuilderz/RBS/main/misc/rejoin.lua",
    HeadHitbox = "https://raw.githubusercontent.com/rustbuilderz/RBS/main/misc/headhitbox.lua"
}

-- Function to load scripts dynamically
local function loadScript(url)
    if not url or url == "" then
        warn("[ERROR] Invalid Script URL!")
        return
    end
    local success, response = pcall(function()
        return game:HttpGet(url, true)
    end)
    if not success or not response or response == "" then
        warn("[ERROR] Failed to Fetch Script:", url)
        return
    end
    local executed, errorMsg = pcall(loadstring(response))
    if not executed then
        warn("[ERROR] Execution Failed:", errorMsg)
    else
        print("[DEBUG] Script Executed Successfully.")
    end
end

-- // 🎨 UI CREATION
local screenGui = Instance.new("ScreenGui", CoreGui)
screenGui.Name = "CheatMenuUI"
screenGui.IgnoreGuiInset = true

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 350, 0, 400)
frame.Position = UDim2.new(0.05, 0, 0.05, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 2
frame.Active = true
frame.Draggable = true
frame.Visible = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "🔥 Cheat Menu 🔥"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 22
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.BorderSizePixel = 0

local scrollingFrame = Instance.new("ScrollingFrame", frame)
scrollingFrame.Size = UDim2.new(1, 0, 1, -45)
scrollingFrame.Position = UDim2.new(0, 0, 0, 45)
scrollingFrame.CanvasSize = UDim2.new(0, 0, 1, 0)

local layout = Instance.new("UIListLayout", scrollingFrame)

local function createButton(text, callback)
    local button = Instance.new("TextButton", scrollingFrame)
    button.Size = UDim2.new(1, 0, 0, 40)
    button.Text = text
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 18
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.MouseButton1Click:Connect(callback)
end

for name, url in pairs(scripts) do
    createButton("Load " .. name, function()
        loadScript(url)
    end)
end

-- Customization Inputs
local function createTextBox(labelText, defaultValue, onTextChanged)
    local label = Instance.new("TextLabel", scrollingFrame)
    label.Size = UDim2.new(1, 0, 0, 30)
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.BackgroundTransparency = 1
    
    local textBox = Instance.new("TextBox", scrollingFrame)
    textBox.Size = UDim2.new(1, 0, 0, 30)
    textBox.Text = defaultValue
    textBox.ClearTextOnFocus = false
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    textBox.FocusLost:Connect(function()
        onTextChanged(textBox.Text)
    end)
end

createTextBox("Head Hitbox Size (X, Y, Z)", "21,21,21", function(text)
    local values = {text:match("(%d+),(%d+),(%d+)")}
    if #values == 3 then
        _G.settings.headHitboxSize = Vector3.new(tonumber(values[1]), tonumber(values[2]), tonumber(values[3]))
        print("[DEBUG] Updated Head Hitbox Size:", _G.settings.headHitboxSize)
    end
end)

createTextBox("Head Transparency (0-1)", "1", function(text)
    local value = tonumber(text)
    if value and value >= 0 and value <= 1 then
        _G.settings.headTransparency = value
        print("[DEBUG] Updated Head Transparency:", _G.settings.headTransparency)
    end
end)

-- Toggle UI Visibility with Insert Key
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        frame.Visible = not frame.Visible
    end
end)

print("[DEBUG] All Features Loaded & Running!")
