local hand = {}
hand.__index = hand

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local modules = ReplicatedStorage.Common
local virtualModules = ReplicatedStorage.Common.VirtualReality

--Get Modules
local AlignmentClass = require(modules.AlignmentClass)
local weldModule = require(modules.WeldModule)
local VRPosition = require(virtualModules.VRPosition)
local modelTools = require(modules.ModelTools)

function hand.new(openHandModel, closeHandModel, handEnum, parent)
	assert(openHandModel, '[ClientHand] hand.new needs a model as it\'s first argument.')
	assert(openHandModel:IsA('Model'), '[ClientHand] hand.new needs a model as it\'s first argument.')
	assert(openHandModel.PrimaryPart, '[ClientHand] hand.new needs a model with a PrimaryPart.')

	if not parent then --Default parent value
		parent = workspace
	end

	local newHand = {}
	setmetatable(newHand, hand)

	newHand._handClosed = false

	newHand._openModel = openHandModel:Clone()
	newHand._openPrimaryPart = newHand._openModel.PrimaryPart
	newHand._closeModel = closeHandModel:Clone()
	newHand._closePrimaryPart = newHand._closeModel.PrimaryPart
	newHand._handEnum = handEnum
	newHand._openTracker = Instance.new('Part')

	--Declare public latestCFrame
	newHand.latestCFrame = CFrame.new(0,0,0)

	newHand._openTracker.Size = Vector3.new(1, 1, 1)
	newHand._openTracker.Anchored = true
	newHand._openTracker.CanCollide = false
	newHand._openTracker.Transparency = 1
	newHand._openTracker.Parent = parent

	newHand._closedTracker = newHand._openTracker:Clone()

	newHand._closedTracker.Parent = parent

	weldModule.weldModel(newHand._openModel)
	weldModule.weldModel(newHand._closeModel)
	newHand._openModel.Parent = parent
	newHand._closeModel.Parent = parent

	newHand._openAlignment = AlignmentClass.new(newHand._openPrimaryPart, newHand._openTracker)
	newHand._closeAlignment = AlignmentClass.new(newHand._closePrimaryPart, newHand._closedTracker)

	newHand.latestCFrame = VRPosition.getPosition(newHand._handEnum)
	newHand._openModel:SetPrimaryPartCFrame(newHand.latestCFrame)
	newHand._closeModel:SetPrimaryPartCFrame(newHand.latestCFrame)

	return newHand
end

function hand:openHand()
	self._handClosed = false

	modelTools.setPropertyOfPartType(self._openModel, 'BasePart', 'Transparency', 0)
	modelTools.setPropertyOfPartType(self._closeModel, 'BasePart', 'Transparency', 1)
end

function hand:closeHand()
	self._handClosed = true

	modelTools.setPropertyOfPartType(self._openModel, 'BasePart', 'Transparency', 1)
	modelTools.setPropertyOfPartType(self._closeModel, 'BasePart', 'Transparency', 0)
end

function hand:updatePosition()
	self.latestCFrame = VRPosition.getPosition(self._handEnum)
	self._openTracker.CFrame = self.latestCFrame
	self._closedTracker.CFrame = self.latestCFrame
end

function hand:Destroy() --MAKE SURE TO UPDATE THIS, I'm too tired right now :( ---Note to self, do not write unplanned crucial code while extremely tired at 2 am.--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	self._openAlignment:Destroy()
	self._openAlignment = nil

	self._openModel:Destroy()
	self._openModel = nil
	self._openPrimaryPart = nil

	self._openTracker:Destroy()
	self._openTracker = nil

	self._handEnum = nil
end

return hand