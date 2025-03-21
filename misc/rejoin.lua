local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local placeId = game.PlaceId 

local function RejoinLobby()
    TeleportService:Teleport(placeId, player)
end

RejoinLobby() 
