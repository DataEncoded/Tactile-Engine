local networkClient = {}
networkClient.__index = networkClient

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local modules = ReplicatedStorage.Common
local virtualModules = modules.VirtualReality

local clientHand = require(virtualModules.ClientHand)
local alignmentClass = require(modules.AlignmentClass)
local weldModule = require(modules.WeldModule)

function networkClient.new(player, leftHandOpened, leftHandClosed, rightHandOpened, rightHandClosed, headModel, starterPositionTable)
    local newClient = {}
    setmetatable(newClient, networkClient)

    newClient._model = Instance.new("Model")
    newClient._model.Name = player.Name
    newClient._model.Parent = workspace

    newClient._headTrack = Instance.new('Part')

	newClient._headTrack.Size = Vector3.new(1,1,1)
	newClient._headTrack.Transparency = 1
	newClient._headTrack.CanCollide = false

    newClient._leftHand = clientHand.new(leftHandOpened, leftHandClosed, starterPositionTable.Left, newClient._model)
    newClient._rightHand = clientHand.new(rightHandOpened, rightHandClosed, starterPositionTable.Right, newClient._model)

    newClient._headModel = headModel:Clone()

    weldModule.weldModel(newClient._headModel)

    newClient._headAlignment = alignmentClass.new(newClient._headModel, newClient._headTrack)

    return newClient
end

function networkClient:updatePosition(starterPositionTable)
    self._headTrack.CFrame = starterPositionTable.Head
    self._leftHand:updatePosition(starterPositionTable.Left)
    self._rightHand:updatePosition(starterPositionTable.Right)
end

function networkClient:handGrip(hand, state)
    local inputHand
    if hand == 'left' then
        inputHand = self._leftHand
    elseif hand == 'right' then
        inputHand = self._rightHand
    else
        return
    end

    if state == true then --Close hand
        inputHand:closeHand()
    else
        inputHand:openHand()
    end

end

function networkClient:Destroy()

    self._headAlignment:Destroy()
    self._headAlignment = nil

    self._model:Destroy()
    self._model = nil

    self._headTrack:Destroy()
    self._headTrack = nil

    self._headModel:Destroy()
    self._headModel = nil

    self._leftHand:Destroy()
    self._leftHand = nil

    self._rightHand:Destroy()
    self._rightHand = nil

end

return networkClient