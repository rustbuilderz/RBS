local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

-- Ensure UI can be parented correctly
local function getUIParent()
    return LocalPlayer:FindFirstChildOfClass("PlayerGui") or game:GetService("CoreGui")
end

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

-- 🎯 Load Scripts on Startup
task.spawn(function()
    loadScript(scripts.Aimbot)
    loadScript(scripts.HeadHitbox)
end)

-- 🖥 UI Creation
task.wait(0.1) -- Prevent race condition

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AimbotUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = getUIParent()

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 430)
frame.Position = UDim2.new(0.1, 0, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Parent = frame

-- 🖥 Create Script Buttons
local function createButton(text, scriptUrl)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 30)
    button.Text = text
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Active = true
    button.Parent = frame

    button.MouseButton1Click:Connect(function()
        loadScript(scriptUrl)
    end)
end

for name, url in pairs(scripts) do
    createButton(name, url)
end

-- ✅ Debug Confirmation
print("[DEBUG] UI Loaded Successfully!")

-- 📌 Target Body Part Dropdown
local bodyParts = {"Head", "Torso", "HumanoidRootPart"}
local currentPartIndex = 1

local bodyPartDropdown = Instance.new("TextButton")
bodyPartDropdown.Size = UDim2.new(1, -10, 0, 30)
bodyPartDropdown.Text = "Target: " .. _G.AimbotSettings.TargetPart
bodyPartDropdown.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
bodyPartDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
bodyPartDropdown.Active = true
bodyPartDropdown.Parent = frame

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

local aimKeyDropdown = Instance.new("TextButton")
aimKeyDropdown.Size = UDim2.new(1, -10, 0, 30)
aimKeyDropdown.Text = "Aim Key: RMB"
aimKeyDropdown.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
aimKeyDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
aimKeyDropdown.Active = true
aimKeyDropdown.Parent = frame

aimKeyDropdown.MouseButton1Click:Connect(function()
    keyIndex = (keyIndex % #keyOptions) + 1
    local selectedKey = keyOptions[keyIndex]

    _G.AimbotSettings.AimKey = AimKeys[selectedKey]
    aimKeyDropdown.Text = "Aim Key: " .. selectedKey
end)

-- 🔘 Toggle Aimbot
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(1, -10, 0, 30)
toggleButton.Text = "Aimbot: ON"
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Active = true
toggleButton.Parent = frame

toggleButton.MouseButton1Click:Connect(function()
    _G.AimbotSettings.Enabled = not _G.AimbotSettings.Enabled
    toggleButton.Text = "Aimbot: " .. (_G.AimbotSettings.Enabled and "ON" or "OFF")
    toggleButton.BackgroundColor3 = _G.AimbotSettings.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end)

-- ✅ UI is now selectable & draggable!
