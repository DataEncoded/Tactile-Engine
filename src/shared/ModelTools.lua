local module = {}

function module.setPropertyOfPartType(model, partType, property, value)
    assert(model and model:IsA('model'), '[ModelTools] setPropertyOfPartType requires a model as first arguement.')
    assert(partType and type(partType) == 'string', '[ModelTools] setPropertyOfPartType requires a string as second arguement')
    assert(property and type(property) == 'string', '[ModelTools] setPropertyOfPartType requires a string as thire arguement')


    local descendants = model:GetDescendants()

    for _, v in ipairs(descendants) do
        if v:IsA(partType) then
            if v[property] then
                v[property] = value
            else
                warn('[ModelTools] Part ' .. v.Name .. ' has no property ' .. property ..'!')
            end
        end
    end

end


return module