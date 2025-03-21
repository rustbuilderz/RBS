local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

-- ⚙ Script URLs
local scripts = {
    Aimbot = "https://raw.githubusercontent.com/rustbuilderz/RBS/main/misc/aimbot.lua",
    ESP = "https://raw.githubusercontent.com/rustbuilderz/RBS/main/misc/esp.lua",
    Fly = "https://raw.githubusercontent.com/rustbuilderz/RBS/main/misc/fly.lua",
    HeadHitbox = "https://raw.githubusercontent.com/rustbuilderz/RBS/main/misc/headhitbox.lua",
    InfiniteJump = "https://raw.githubusercontent.com/rustbuilderz/RBS/main/misc/infinitejump.lua",
    Rejoin = "https://raw.githubusercontent.com/rustbuilderz/RBS/main/misc/rejoin.lua"
}

-- 🎯 Default Aimbot Settings (Global)
_G.AimbotSettings = {
    Enabled = true,
    AimKey = Enum.UserInputType.MouseButton2, -- Default: Right Click
    FOV = 100,
    LockStrength = 0.8,
    PredictionFactor = 0.08,
    TargetPart = "Head"
}

-- 🔄 Function to Load External Scripts
local function loadScript(url)
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)
    if success then
        print("[DEBUG] Loaded: " .. url)
        loadstring(response)()
    else
        warn("[ERROR] Failed to load script: " .. url)
    end
end

-- 🎯 Auto-load Aimbot on Startup
loadScript(scripts.Aimbot)

-- 🛠 UI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 360) -- Increased height
frame.Position = UDim2.new(0.1, 0, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Parent = screenGui

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Parent = frame

-- 🖥 Create Buttons for Scripts
local function createButton(text, scriptUrl)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 30)
    button.Text = text
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Parent = frame

    button.MouseButton1Click:Connect(function()
        loadScript(scriptUrl)
    end)
end

for name, url in pairs(scripts) do
    createButton(name, url)
end

-- 📌 Dropdown for Aim Body Part
local bodyParts = {"Head", "Torso", "HumanoidRootPart"}
local currentPartIndex = 1

local bodyPartDropdown = Instance.new("TextButton", frame)
bodyPartDropdown.Size = UDim2.new(1, -10, 0, 30)
bodyPartDropdown.Text = "Target: " .. _G.AimbotSettings.TargetPart
bodyPartDropdown.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
bodyPartDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)

bodyPartDropdown.MouseButton1Click:Connect(function()
    currentPartIndex = (currentPartIndex % #bodyParts) + 1
    _G.AimbotSettings.TargetPart = bodyParts[currentPartIndex]
    bodyPartDropdown.Text = "Target: " .. _G.AimbotSettings.TargetPart
end)

bodyPartDropdown.Parent = frame

-- 📌 Dropdown for Aim Key
local AimKeys = {
    ["F"] = Enum.KeyCode.F,
    ["RMB"] = Enum.UserInputType.MouseButton2,
    ["CTRL"] = Enum.KeyCode.LeftControl
}

local keyOptions = {"F", "RMB", "CTRL"}
local keyIndex = 2

local AimKeyDropdown = Instance.new("TextButton", frame)
AimKeyDropdown.Size = UDim2.new(1, -10, 0, 30)
AimKeyDropdown.Text = "Aim Key: RMB"
AimKeyDropdown.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
AimKeyDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)

AimKeyDropdown.MouseButton1Click:Connect(function()
    keyIndex = (keyIndex % #keyOptions) + 1
    local selectedKey = keyOptions[keyIndex]

    _G.AimbotSettings.AimKey = AimKeys[selectedKey]
    AimKeyDropdown.Text = "Aim Key: " .. selectedKey
end)

AimKeyDropdown.Parent = frame

-- 🔧 Create Sliders for Settings
local function createSlider(name, min, max, default, settingKey)
    local sliderFrame = Instance.new("Frame", frame)
    sliderFrame.Size = UDim2.new(1, 0, 0, 50)
    sliderFrame.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", sliderFrame)
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Text = name .. ": " .. default
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.SourceSans
    label.TextSize = 16

    local slider = Instance.new("TextBox", sliderFrame)
    slider.Size = UDim2.new(1, -10, 0, 20)
    slider.Position = UDim2.new(0, 5, 0, 25)
    slider.Text = tostring(default)
    slider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    slider.TextColor3 = Color3.fromRGB(255, 255, 255)
    slider.Font = Enum.Font.SourceSans
    slider.TextSize = 14

    slider.FocusLost:Connect(function()
        local newValue = tonumber(slider.Text)
        if newValue then
            newValue = math.clamp(newValue, min, max)
            _G.AimbotSettings[settingKey] = newValue
            slider.Text = tostring(newValue)
            label.Text = name .. ": " .. newValue
        else
            slider.Text = tostring(default)
        end
    end)

    sliderFrame.Parent = frame
end

createSlider("FOV", 10, 500, _G.AimbotSettings.FOV, "FOV")
createSlider("Lock Strength", 0.1, 1, _G.AimbotSettings.LockStrength, "LockStrength")
createSlider("Prediction", 0, 0.2, _G.AimbotSettings.PredictionFactor, "PredictionFactor")

-- 🔘 Toggle Aimbot
local ToggleButton = Instance.new("TextButton", frame)
ToggleButton.Size = UDim2.new(1, -10, 0, 30)
ToggleButton.Text = "Aimbot: ON"
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)

ToggleButton.MouseButton1Click:Connect(function()
    _G.AimbotSettings.Enabled = not _G.AimbotSettings.Enabled
    ToggleButton.Text = "Aimbot: " .. (_G.AimbotSettings.Enabled and "ON" or "OFF")
    ToggleButton.BackgroundColor3 = _G.AimbotSettings.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end)

ToggleButton.Parent = frame
