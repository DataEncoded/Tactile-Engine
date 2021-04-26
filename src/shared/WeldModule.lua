local module = {}

function module.weldModel(model)
	assert(model, '[WeldModule] Model required as argument 1.')
	assert(model:IsA('Model'), '[WeldModule] Model given needs to be a model.')
	local primaryPart = model.PrimaryPart
	assert(primaryPart, '[WeldModule] Model to weld needs a primary part.')

	local objects = model:GetChildren()

	for _, object in ipairs(objects) do
		if object:IsA('BasePart') and object ~= primaryPart then
			local weld = Instance.new('WeldConstraint')
			weld.Part0 = primaryPart
			weld.Part1 = object
			weld.Parent = primaryPart
		end
	end
end

return module