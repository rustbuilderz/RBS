-- ⚙ Services
local CoreGui = game:GetService("CoreGui")

print("[DEBUG] Script Loaded - Initializing UI...")

-- ⚙ Script URLs
local scripts = {
    Aimbot = "https://raw.githubusercontent.com/rustbuilderz/RBS/main/misc/aimbot.lua",
    ESP = "https://raw.githubusercontent.com/rustbuilderz/RBS/main/misc/esp.lua",
    Fly = "https://raw.githubusercontent.com/rustbuilderz/RBS/main/misc/fly.lua",
    InfiniteJump = "https://raw.githubusercontent.com/rustbuilderz/RBS/main/misc/infinitejump.lua",
    Rejoin = "https://raw.githubusercontent.com/rustbuilderz/RBS/main/misc/rejoin.lua",
    HeadHitbox = "https://raw.githubusercontent.com/rustbuilderz/RBS/main/misc/headhitbox.lua"
}

-- 📜 Function to Load Scripts On Demand
local function loadScript(url)
    print("[DEBUG] Fetching script from:", url)
    local success, response = pcall(function()
        return game:HttpGet(url, true) -- Force HTTP request
    end)

    if success and response then
        print("[DEBUG] Script fetched successfully.")
        local loadedSuccess, errorMessage = pcall(function()
            return loadstring(response)()
        end)

        if not loadedSuccess then
            warn("[ERROR] Script Execution Failed:", errorMessage)
        else
            print("[DEBUG] Script Executed Successfully.")
        end
    else
        warn("[ERROR] Failed to load script:", url)
    end
end

-- 🖥 UI Creation
print("[DEBUG] Creating UI...")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CheatMenuUI"
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 280) -- Adjusted size to fit buttons
frame.Position = UDim2.new(0.1, 0, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 2
frame.Active = true
frame.Draggable = true
frame.ZIndex = 10
frame.Parent = screenGui
print("[DEBUG] UI Created!")

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Parent = frame

-- 🖥 Create Buttons to Load Scripts
local function createButton(text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 30)
    button.Text = text
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.ZIndex = 20
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

-- 🔘 Create Buttons for Features
for name, url in pairs(scripts) do
    if name ~= "HeadHitbox" then -- Ensure the Head Hitbox button is separate
        createButton("Load " .. name, function()
            print("[DEBUG] Button Clicked:", name)
            loadScript(url)
        end)
    end
end

-- 🔘 Single Button for Head Hitbox
createButton("Enable Head Hitbox", function()
    print("[DEBUG] Button Clicked: Enable Head Hitbox")
    if scripts.HeadHitbox then
        print("[DEBUG] Head Hitbox Script URL:", scripts.HeadHitbox)
        loadScript(scripts.HeadHitbox)
    else
        warn("[ERROR] HeadHitbox script URL not found!")
    end
end)

-- 📌 Keep UI on Top (Reparent if it gets lost)
task.spawn(function()
    while task.wait(1) do
        if screenGui.Parent ~= CoreGui then
            screenGui.Parent = CoreGui
            print("[DEBUG] UI Reparented to Stay on Top")
        end
    end
end)

print("[DEBUG] All Features Loaded & Running!")
