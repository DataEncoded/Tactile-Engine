local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage.Remotes

local updatePlayers, getPlayers = remotes.UpdatePlayers, remotes.GetPlayers

--Table management
local VRPlayers = getPlayers:InvokeServer()

updatePlayers.OnClientEvent:Connect(function(p)
    table.insert(VRPlayers, #VRPlayers + 1, p)
end)

--Entering and leaving logic

game.Players.PlayerAdded:Connect(function(p)

    p.CharacterAdded:Connect(function(c)
        if table.find(VRPlayers, p) then
            c.Parent = ReplicatedStorage
        end
    end)
end)

game.Players.PlayerAdded:Connect(function(p)
    local index = table.find(VRPlayers, p)
    if index then
        table.remove(VRPlayers, index)
    end
end)