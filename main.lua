-- ⚙ Services
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local PlaceId = game.PlaceId -- Get current game ID

-- 🌍 Ensure Global Settings Exist
_G.GlobalSettings = _G.GlobalSettings or {
    -- ESP Settings
    ESPEnabled = false,
    ESPBox = false,
    ESPName = false,
    ESPTracer = false,
    BoxColor = Color3.fromRGB(255, 0, 0), -- Red
    NameColor = Color3.fromRGB(255, 255, 255), -- White
    TracerColor = Color3.fromRGB(0, 255, 0), -- Green



    -- Aimbot Settings
    AimbotEnabled = false,
    AimKey = Enum.KeyCode.F,
    FOV = 100,
    LockStrength = 0.8,
    PredictionFactor = 0.08,
    TargetPart = "Head",
    SilentAim = false,

    -- Fly Settings
    FlyEnabled = false, -- Default Off
    FlySpeed = 50,
    FlyKeybind = Enum.KeyCode.E -- Default X

}

-- 🎯 Load Aimbot
local successAimbot, AimbotScript = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/rustbuilderz/RBS/main/misc/aimbot.lua"))()
end)
if not successAimbot then warn("❌ Failed to load Aimbot!") end

local successHitbox, HeadHitboxScript = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/rustbuilderz/RBS/main/misc/headhitbox.lua"))()
end)
if not successHitbox then warn("❌ Failed to load Head Hitbox Script!") end
-- 👀 Load ESP
local successESP, ESPScript = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/rustbuilderz/RBS/main/misc/esp.lua"))()
end)
if not successESP then warn("❌ Failed to load ESP!") end

-- ✈️ Load Fly Script
local successFly, FlyScript = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/rustbuilderz/RBS/main/misc/fly.lua"))()
end)
if not successFly then warn("❌ Failed to load Fly Script!") end

-- 🖥️ Load UI Library
local successUI, UILib = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/rustbuilderz/RBS/main/lib/library.lua"))()
end)
if not successUI then warn("❌ Failed to load UI Library!") end

-- 🎛️ Create UI
local Main = UILib:Main("Script Menu")

-- Ensure Silent Aim Globals Exist
_G.SilentAimEnabled = _G.SilentAimEnabled or false
_G.HeadHitboxSize = _G.HeadHitboxSize or Vector3.new(5, 5, 5) -- Default size

-- 🎯 Aimbot Tab
local AimbotTab = Main:NewTab("Aimbot")

AimbotTab:NewToggle("Aimbot", function(state)
    _G.GlobalSettings.AimbotEnabled = state
end, _G.GlobalSettings.AimbotEnabled)

AimbotTab:NewToggle("Keep Target", function(state)
    _G.GlobalSettings.KeepTarget = state
end, _G.GlobalSettings.KeepTarget)

AimbotTab:NewSlider("Smoothing", 1, 20, 1, function(value)
    _G.GlobalSettings.Smoothing = value
end, _G.GlobalSettings.Smoothing or 5)

AimbotTab:NewSlider("Lock Strength", 1, 100, 1, function(value)
    _G.GlobalSettings.LockStrength = value / 100
end, (_G.GlobalSettings.LockStrength or 0.3) * 100)

AimbotTab:NewSlider("Prediction Factor", 0, 100, 1, function(value)
    _G.GlobalSettings.PredictionFactor = value / 100
end, (_G.GlobalSettings.PredictionFactor or 0.1) * 100)

AimbotTab:NewDropdown("Target Part", {"Head", "Torso", "Legs"}, function(selected)
    _G.GlobalSettings.TargetPart = selected
end, _G.GlobalSettings.TargetPart or "Head")

AimbotTab:NewDropdown("Aim Key", {"Right Mouse Button", "Left Mouse Button", "X", "C"}, function(selected)
    local keyMap = {
        ["Right Mouse Button"] = Enum.UserInputType.MouseButton2,
        ["Left Mouse Button"] = Enum.UserInputType.MouseButton1,
        ["X"] = Enum.KeyCode.X,
        ["C"] = Enum.KeyCode.C
    }
    _G.GlobalSettings.AimKey = keyMap[selected] or Enum.KeyCode.F
end, "Right Mouse Button")

-- 🟢 ESP Tab
local ESPTab = Main:NewTab("ESP")

ESPTab:NewToggle("ESP", function(state)
    _G.GlobalSettings.ESPEnabled = state
end, _G.GlobalSettings.ESPEnabled)

ESPTab:NewToggle("ESP Box", function(state)
    _G.GlobalSettings.ESPBox = state
end, _G.GlobalSettings.ESPBox)

ESPTab:NewToggle("ESP Name", function(state)
    _G.GlobalSettings.ESPName = state
end, _G.GlobalSettings.ESPName)

ESPTab:NewToggle("ESP Tracer", function(state)
    _G.GlobalSettings.ESPTracer = state
end, _G.GlobalSettings.ESPTracer)

-- 🚀 Movement Tab
local MovementTab = Main:NewTab("Movement")

local InfiniteJumpEnabled = false

MovementTab:NewToggle("Infinite Jump", function(state)
    InfiniteJumpEnabled = state
    _G.GlobalSettings.InfiniteJump = state
end, _G.GlobalSettings.InfiniteJump)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfiniteJumpEnabled then
        local humanoid = game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState("Jumping")
        end
    end
end)


MovementTab:NewToggle("Fly", function(state)
    _G.GlobalSettings.FlyEnabled = state
    if _G.SetFly then
        _G.SetFly(state)
    end
end, _G.GlobalSettings.FlyEnabled)
MovementTab:NewButton("Refresh Fly", function()
    print("🔄 Reloading Fly Script...")
    local successFly, FlyScript = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/rustbuilderz/RBS/main/misc/fly.lua"))()
    end)
    if not successFly then
        warn("❌ Failed to reload Fly Script!")
    else
        _G.SetFly = FlyScript.SetFly
        _G.UpdateFlySpeed = FlyScript.UpdateFlySpeed
        print("✅ Fly Script Reloaded Successfully!")
    end
end)


MovementTab:NewSlider("Fly Speed", 10, 100, 5, function(value)
    _G.GlobalSettings.FlySpeed = value
    if _G.UpdateFlySpeed then
        _G.UpdateFlySpeed(value)
    end
end, _G.GlobalSettings.FlySpeed)

MovementTab:NewDropdown("Fly Keybind", {"F", "B", "E", "C"}, function(selected)
    local keyMap = {
        ["F"] = Enum.KeyCode.F,
        ["B"] = Enum.KeyCode.B,
        ["E"] = Enum.KeyCode.E,
        ["C"] = Enum.KeyCode.C
    }
    _G.GlobalSettings.FlyKeybind = keyMap[selected] or Enum.KeyCode.E
end, "E")


-- 🔧 Miscellaneous Tab
local MiscTab = Main:NewTab("Misc")

MiscTab:NewButton("Rejoin Lobby", function()
    print("🔄 Rejoining...")
    TeleportService:Teleport(PlaceId, LocalPlayer)
end)

MiscTab:NewButton("Bullet Tracer WARNING THIS IS EXPERIMENTAL", function()
    print("⚠️ Loading Bullet Tracer Script...")
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/rustbuilderz/RBS/main/misc/tracer.lua"))()
end)


-- 🔄 Sync ESP in Real-Time
RunService.RenderStepped:Connect(function()
    if _G.GlobalSettings.ESPEnabled and ESPScript then
        if typeof(ESPScript.UpdateESP) == "function" then
            ESPScript.UpdateESP(_G.GlobalSettings)
        end
    end
end)

-- 🔄 Sync Aimbot in Real-Time
RunService.RenderStepped:Connect(function()
    if _G.GlobalSettings.AimbotEnabled and AimbotScript then
        if typeof(AimbotScript.UpdateAimbot) == "function" then
            AimbotScript.UpdateAimbot(_G.GlobalSettings)
        end
    end
end)
