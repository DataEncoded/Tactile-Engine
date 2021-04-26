local module = {}

local VRService = game:GetService("VRService")

function module.getPosition(EnumUserCFrame) --A function that returns the user's world position in VR.
    local userCFrame = VRService:GetUserCFrame(EnumUserCFrame)

    return (workspace.CurrentCamera.CFrame * CFrame.new(userCFrame.Position)) * CFrame.fromEulerAnglesXYZ(userCFrame:ToEulerAnglesXYZ())
end

return module