local networkClient = {}
networkClient.__index = networkClient

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local modules = ReplicatedStorage.Common
local virtualModules = modules.VirtualReality

local clientHand = require(virtualModules.ClientHand)
local alignmentClass = require(modules.AlignmentClass)
local weldModule = require(modules.WeldModule)

function networkClient.new(player, leftHandModel, rightHandModel, headModel)
    local newClient = {}
    setmetatable(newClient, networkClient)

    newClient._headTrack = Instance.new('Part')

	newClient._headTrack.Size = Vector3.new(1,1,1)
	newClient._headTrack.Transparency = 1
	newClient._headTrack.CanCollide = false

    newClient._headModel = headModel:Clone()

    weldModule.weldModel(newClient._headModel)

    newClient._headAlignment = alignmentClass.new(newClient._headModel, newClient._headTrack)

    return newClient
end

return networkClient