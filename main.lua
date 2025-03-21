local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

-- ⚙ Script URLs
local scripts = {
    Aimbot = "https://raw.githubusercontent.com/rustbuilderz/RBS/main/misc/aimbot.lua",
    ESP = "https://raw.githubusercontent.com/rustbuilderz/RBS/main/misc/esp.lua",
    Fly = "https://raw.githubusercontent.com/rustbuilderz/RBS/main/misc/fly.lua",
    HeadHitbox = "https://raw.githubusercontent.com/rustbuilderz/RBS/main/misc/headinvisible.lua",
    InfiniteJump = "https://raw.githubusercontent.com/rustbuilderz/RBS/main/misc/infinitejump.lua",
    Rejoin = "https://raw.githubusercontent.com/rustbuilderz/RBS/main/misc/rejoin.lua"
}

-- 🎯 Global Aimbot Settings
_G.AimbotSettings = {
    Enabled = true,
    AimKey = Enum.UserInputType.MouseButton2,
    FOV = 100,
    LockStrength = 0.8,
    PredictionFactor = 0.08,
    TargetPart = "Head"
}

-- 🏆 Global Hitbox Settings
_G.HitboxSettings = {
    Size = Vector3.new(30, 30, 30),
    Transparency = 0.5,
    HideHead = true,
    HideFace = true
}

-- 📜 Function to Load Scripts
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

-- 🎯 Load Aimbot & Hitbox Scripts on Startup
loadScript(scripts.Aimbot)
loadScript(scripts.HeadHitbox)

-- 🖥 UI Creation
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = CoreGui

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 250, 0, 430) -- Increased height
frame.Position = UDim2.new(0.1, 0, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local uiListLayout = Instance.new("UIListLayout", frame)

-- 🖥 Create Script Buttons
local function createButton(text, scriptUrl)
    local button = Instance.new("TextButton", frame)
    button.Size = UDim2.new(1, 0, 0, 30)
    button.Text = text
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)

    button.MouseButton1Click:Connect(function()
        loadScript(scriptUrl)
    end)
end

for name, url in pairs(scripts) do
    createButton(name, url)
end

-- 📌 Target Body Part Dropdown
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

-- 📌 Aim Key Selection Dropdown
local AimKeys = {
    ["F"] = Enum.KeyCode.F,
    ["RMB"] = Enum.UserInputType.MouseButton2,
    ["CTRL"] = Enum.KeyCode.LeftControl
}

local keyOptions = {"F", "RMB", "CTRL"}
local keyIndex = 2

local aimKeyDropdown = Instance.new("TextButton", frame)
aimKeyDropdown.Size = UDim2.new(1, -10, 0, 30)
aimKeyDropdown.Text = "Aim Key: RMB"
aimKeyDropdown.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
aimKeyDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
aimKeyDropdown.Parent = frame

aimKeyDropdown.MouseButton1Click:Connect(function()
    keyIndex = (keyIndex % #keyOptions) + 1
    local selectedKey = keyOptions[keyIndex]

    _G.AimbotSettings.AimKey = AimKeys[selectedKey]
    aimKeyDropdown.Text = "Aim Key: " .. selectedKey
end)

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
end

createSlider("FOV", 10, 500, _G.AimbotSettings.FOV, "FOV")
createSlider("Lock Strength", 0.1, 1, _G.AimbotSettings.LockStrength, "LockStrength")
createSlider("Prediction", 0, 0.2, _G.AimbotSettings.PredictionFactor, "PredictionFactor")

-- 🔘 Toggle Aimbot
local toggleButton = Instance.new("TextButton", frame)
toggleButton.Size = UDim2.new(1, -10, 0, 30)
toggleButton.Text = "Aimbot: ON"
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)

toggleButton.MouseButton1Click:Connect(function()
    _G.AimbotSettings.Enabled = not _G.AimbotSettings.Enabled
    toggleButton.Text = "Aimbot: " .. (_G.AimbotSettings.Enabled and "ON" or "OFF")
    toggleButton.BackgroundColor3 = _G.AimbotSettings.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end)
