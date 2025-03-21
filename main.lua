-- // ⚙ SERVICES
local CoreGui = game:GetService("CoreGui")

print("[DEBUG] Script Loaded - Initializing UI...")

-- // 📜 SCRIPT URLS
local scripts = {
    Aimbot = "https://raw.githubusercontent.com/rustbuilderz/RBS/main/misc/aimbot.lua",
    ESP = "https://raw.githubusercontent.com/rustbuilderz/RBS/main/misc/esp.lua",
    Fly = "https://raw.githubusercontent.com/rustbuilderz/RBS/main/misc/fly.lua",
    InfiniteJump = "https://raw.githubusercontent.com/rustbuilderz/RBS/main/misc/infinitejump.lua",
    Rejoin = "https://raw.githubusercontent.com/rustbuilderz/RBS/main/misc/rejoin.lua",
    HeadHitbox = "https://raw.githubusercontent.com/rustbuilderz/RBS/main/misc/headhitbox.lua"
}

-- // 📥 FUNCTION TO LOAD SCRIPTS
local function loadScript(url)
    print("[DEBUG] Fetching:", url)

    local success, response = pcall(function()
        return game:HttpGet(url, true) -- Force HTTP request
    end)

    if success and response then
        print("[DEBUG] Script Fetched Successfully.")

        local executed, errorMsg = pcall(function()
            return loadstring(response)()
        end)

        if not executed then
            warn("[ERROR] Execution Failed:", errorMsg)
        else
            print("[DEBUG] Script Executed Successfully.")
        end
    else
        warn("[ERROR] Failed to Load Script:", url)
    end
end

-- // 🎨 UI CREATION
print("[DEBUG] Creating UI...")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CheatMenuUI"
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = CoreGui

-- // 🖼 MAIN FRAME
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 350) -- Wider layout
frame.Position = UDim2.new(0.05, 0, 0.05, 0)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 2
frame.Active = true
frame.Draggable = true
frame.ZIndex = 10
frame.Parent = screenGui

-- // 📌 UI TITLE
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "🔥 Cheat Menu 🔥"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 22
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.BorderSizePixel = 0
title.Parent = frame

-- // 📜 SCROLLING FRAME
local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, 0, 1, -45)
scrollingFrame.Position = UDim2.new(0, 0, 0, 45)
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.BorderSizePixel = 0
scrollingFrame.CanvasSize = UDim2.new(0, 0, 1, 0)
scrollingFrame.Parent = frame

-- // 📌 UI LAYOUT (GRID)
local gridLayout = Instance.new("UIGridLayout")
gridLayout.CellSize = UDim2.new(0, 140, 0, 40) -- Buttons in 2 columns
gridLayout.CellPadding = UDim2.new(0, 10, 0, 10)
gridLayout.Parent = scrollingFrame

print("[DEBUG] UI Created!")

-- // 🔘 FUNCTION TO CREATE BUTTONS
local function createButton(text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 130, 0, 40) -- Uniform button size
    button.Text = text
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 18
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.BorderSizePixel = 1
    button.Parent = scrollingFrame

    button.MouseButton1Click:Connect(callback)
    print("[DEBUG] Button Created:", text)
end

-- // 🛠 CREATE BUTTONS FOR FEATURES
for name, url in pairs(scripts) do
    if name ~= "HeadHitbox" then -- Ensure Head Hitbox has its own button
        createButton("Load " .. name, function()
            print("[DEBUG] Button Clicked:", name)
            loadScript(url)
        end)
    end
end

-- // 🎯 SINGLE BUTTON FOR HEAD HITBOX
createButton("Enable Head Hitbox", function()
    print("[DEBUG] Button Clicked: Enable Head Hitbox")
    if scripts.HeadHitbox then
        print("[DEBUG] Loading Head Hitbox Script...")
        loadScript(scripts.HeadHitbox)
    else
        warn("[ERROR] HeadHitbox script URL not found!")
    end
end)

-- // 📌 KEEP UI ON TOP
task.spawn(function()
    while task.wait(1) do
        if screenGui.Parent ~= CoreGui then
            screenGui.Parent = CoreGui
            print("[DEBUG] UI Reparented to Stay on Top")
        end
    end
end)

print("[DEBUG] All Features Loaded & Running!")
