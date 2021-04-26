local module = {}
module.__index = module

local function ensureAttachment(object)
	local attachment = object:FindFirstChild('TrackingAttachment')
	
	if not attachment or not attachment:IsA('Attachment') then
		attachment = Instance.new('Attachment')
		attachment.Name = 'TemporaryTrackingAttachment'
		attachment.Parent = object
	end
	
	return attachment
end

function module.new(mainPart, trackingPart)
	local newModule = {}
	setmetatable(newModule, module)

	newModule._mainAttachment = ensureAttachment(mainPart)
	newModule._trackingAttachment = ensureAttachment(trackingPart)
	newModule._alignPosition = Instance.new('AlignPosition')
	newModule._alignOrientation = Instance.new('AlignOrientation')

	--Configure tracking alignments
	newModule._alignPosition.Attachment0 = newModule._mainAttachment
	newModule._alignPosition.Attachment1 = newModule._trackingAttachment
	newModule._alignPosition.RigidityEnabled = true
	newModule._alignPosition.Parent = mainPart

	newModule._alignOrientation.Attachment0 = newModule._mainAttachment
	newModule._alignOrientation.Attachment1 = newModule._trackingAttachment
	newModule._alignOrientation.RigidityEnabled = true
	newModule._alignOrientation.Parent = mainPart

	return newModule
end

function module:Destroy()
	self._alignPosition:Destroy()
	self._alignOrientation:Destroy()
	self._alignPosition = nil
	self._alignOrientation = nil

	if self._mainAttachment.Name == 'TemporaryTrackingAttachment' then
		self._mainAttachment:Destroy()
	end

	if self._trackingAttachment.Name == 'TemporaryTrackingAttachment' then
		self._trackingAttachment:Destroy()
	end

	self._mainAttachment = nil
	self._trackingAttachment = nil

	setmetatable(self, nil)

end


return module
