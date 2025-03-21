local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

print("[DEBUG] Script Loaded - Initializing UI")

-- 🏆 Ensure UI is Parented Correctly
local function getUIParent()
    if syn and syn.protect_gui then
        local gui = Instance.new("ScreenGui")
        syn.protect_gui(gui)
        gui.Parent = CoreGui
        return gui
    else
        return CoreGui
    end
end

-- ⚙ Script URLs
local scripts = {
    Aimbot = "https://raw.githubusercontent.com/rustbuilderz/RBS/main/misc/aimbot.lua",
    ESP = "https://raw.githubusercontent.com/rustbuilderz/RBS/main/misc/esp.lua",
    Fly = "https://raw.githubusercontent.com/rustbuilderz/RBS/main/misc/fly.lua",
    Hitbox = "https://raw.githubusercontent.com/rustbuilderz/RBS/main/misc/headhitbox.lua",
    InfiniteJump = "https://raw.githubusercontent.com/rustbuilderz/RBS/main/misc/infinitejump.lua",
    Rejoin = "https://raw.githubusercontent.com/rustbuilderz/RBS/main/misc/rejoin.lua"
}

-- 📜 Function to Load Scripts
local function loadScript(url)
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)
    if success then
        print("[DEBUG] Loaded:", url)
        local loadedSuccess, errorMessage = pcall(loadstring(response))
        if not loadedSuccess then
            warn("[ERROR] Script Execution Failed:", errorMessage)
        end
    else
        warn("[ERROR] Failed to load script:", url)
    end
end

-- 🎯 Load Aimbot & Hitbox Scripts on Startup
print("[DEBUG] Loading Scripts...")
loadScript(scripts.Aimbot)
loadScript(scripts.Hitbox)
print("[DEBUG] Scripts Loaded!")

-- 🖥 UI Creation
print("[DEBUG] Creating UI...")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CheatMenuUI"
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 500)
frame.Position = UDim2.new(0.1, 0, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 2
frame.Active = true
frame.Draggable = false
frame.ZIndex = 10 -- Ensure it's on top
frame.Parent = screenGui
print("[DEBUG] UI Created!")

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Parent = frame

-- 🖥 Create Buttons
local function createButton(text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 30)
    button.Text = text
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.ZIndex = 20 -- Keep above everything
    button.Parent = frame

    local success, errorMessage = pcall(function()
        button.MouseButton1Click:Connect(callback)
    end)
    if not success then
        warn("[ERROR] Failed to Bind Button Event:", errorMessage)
    else
        print("[DEBUG] Button Created: " .. text)
    end
end

-- 🔘 Load Scripts Buttons
for name, url in pairs(scripts) do
    createButton("Load " .. name, function()
        print("[DEBUG] Button Clicked:", name)
        loadScript(url)
    end)
end

-- 📌 Keep UI on Top (Reparent if it gets lost)
task.spawn(function()
    while task.wait(1) do
        if screenGui.Parent ~= CoreGui then
            screenGui.Parent = CoreGui
            print("[DEBUG] UI Reparented to Stay on Top")
        end
    end
end)

print("[DEBUG] UI is Fixed & Fully Interactive!")
