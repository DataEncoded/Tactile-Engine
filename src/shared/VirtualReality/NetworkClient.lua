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
    newClient._headTrack.Anchored = true
    newClient._headTrack.Parent = newClient._model

    newClient._headTrack.CFrame = starterPositionTable.Head

    newClient._leftHand = clientHand.new(leftHandOpened, leftHandClosed, starterPositionTable.Left, newClient._model)
    newClient._rightHand = clientHand.new(rightHandOpened, rightHandClosed, starterPositionTable.Right, newClient._model)

    newClient._leftHand:openHand()
    newClient._rightHand:openHand()

    newClient._headModel = headModel:Clone()

    weldModule.weldModel(newClient._headModel)

    newClient._headModel.Parent = newClient._model
    newClient._headModel:SetPrimaryPartCFrame(starterPositionTable.Head)
    newClient._headModel.Name = player.Name

    newClient._headAlignment = alignmentClass.new(newClient._headModel.PrimaryPart, newClient._headTrack)

    return newClient
end

function networkClient:updatePosition(starterPositionTable)
    self._headTrack.CFrame = starterPositionTable.Head
    self._leftHand:updatePosition(starterPositionTable.Left)
    self._rightHand:updatePosition(starterPositionTable.Right)
    if starterPositionTable.leftOpen ~= self._leftHand.handClosed then
        self:handGrip(self._leftHand, starterPositionTable.leftOpen)
    end
    if starterPositionTable.rightOpen ~= self._rightHand.handClosed then
        self:handGrip(self._rightHand, starterPositionTable.rightOpen)
    end
end

function networkClient:handGrip(hand, state)

    assert(hand == self._leftHand or hand == self._rightHand, "[NetworkClient] handGrip update called with non-hand object!")

    if state == true then --Close hand
        hand:closeHand()
    else
        hand:openHand()
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