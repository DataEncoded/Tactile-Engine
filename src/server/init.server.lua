local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage.Remotes

local virtualRealityPlayers = {}

local updatePlayers, getPlayers = remotes.UpdatePlayers, remotes.GetPlayers



--VR player invisibility logic
--Update players logic
updatePlayers.OnServerEvent:Connect(function(p)
    if not table.find(virtualRealityPlayers, p) then
        table.insert(virtualRealityPlayers, #virtualRealityPlayers + 1, p)
        updatePlayers:FireAllClients(p)
    end
end)

--Get Players logic
local function returnPlayers()
    return virtualRealityPlayers
end

getPlayers.OnServerInvoke = returnPlayers

--Leaving player logic
local function playerLeaving(p)
    local index = table.find(virtualRealityPlayers, p)
    if index then
        table.remove(virtualRealityPlayers, index)
    end
end

game.Players.PlayerRemoving:Connect(playerLeaving)