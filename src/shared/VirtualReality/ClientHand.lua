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

function hand.new(openHandModel, closeHandModel, starterPosition, parent)
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
	newHand._tracker = Instance.new('Part')

	--Declare public latestCFrame
	newHand.latestCFrame = CFrame.new(0,0,0)

	newHand._tracker.Size = Vector3.new(1, 1, 1)
	newHand._tracker.Anchored = true
	newHand._tracker.CanCollide = false
	newHand._tracker.Transparency = 1
	newHand._tracker.Parent = parent

	weldModule.weldModel(newHand._openModel)
	weldModule.weldModel(newHand._closeModel)
	newHand._openModel.Parent = parent
	newHand._closeModel.Parent = parent

	newHand._openAlignment = AlignmentClass.new(newHand._openPrimaryPart, newHand._tracker)
	newHand._closeAlignment = AlignmentClass.new(newHand._closePrimaryPart, newHand._tracker)

	newHand.latestCFrame = starterPosition
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

function hand:updatePosition(position)
	self.latestCFrame = position
	self._tracker.CFrame = self.latestCFrame
end

function hand:Destroy()
	self._openAlignment:Destroy()
	self._openAlignment = nil
	self._closeAlignment:Destroy()
	self._closeAlignment = nil

	self._openModel:Destroy()
	self._openModel = nil
	self._openPrimaryPart = nil

	self._closeModel:Destroy()
	self._closeModel = nil
	self._closePrimaryPart = nil

	self.latestCFrame = nil

	self._tracker:Destroy()
	self._tracker = nil

	self._handClosed = nil

	setmetatable(self, nil)
end

return hand