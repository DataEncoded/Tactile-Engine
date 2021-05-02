local VRService = game:GetService("VRService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local ContextActionService = game:GetService("ContextActionService")

local virtualObjects = ReplicatedStorage.VirtualRealityObjects
local modules = ReplicatedStorage.Common
local virtualRealityModules = modules.VirtualReality
local remotes = ReplicatedStorage.Remotes
local VRUpdate = remotes.VirtualRealityUpdate

local hand = require(virtualRealityModules.ClientHand)
local VRPosition = require(virtualRealityModules.VRPosition)


if VRService.VREnabled then
    local leftModelOpen, rightModelOpen = virtualObjects.LeftHandOpened, virtualObjects.RightHandOpened
    local leftModelClose, rightModelClose = virtualObjects.LeftHandClosed, virtualObjects.RightHandClosed

    StarterGui:SetCore("VRLaserPointerMode", 0)
    StarterGui:SetCore("VREnableControllerModels", false)


    local leftHand, rightHand = hand.new(leftModelOpen, leftModelClose, Enum.UserCFrame.LeftHand), hand.new(rightModelOpen, rightModelClose, Enum.UserCFrame.RightHand)


    local function updatePosition()
        rightHand:updatePosition()
        leftHand:updatePosition()
    end

    local function closeHandle(name, inputState, inputObject)
        local inputHand

        if name == 'LeftHandClose' then
            inputHand = leftHand
        elseif name == 'RightHandClose' then
            inputHand = rightHand
        end

        if inputState == Enum.UserInputState.Begin then
            inputHand:closeHand()
        elseif inputState == Enum.UserInputState.End then
            inputHand:openHand()
        end
    end

    RunService:BindToRenderStep('UpdatePosition', 100, updatePosition)

    ContextActionService:BindAction('LeftHandClose', closeHandle, false, Enum.KeyCode.ButtonL1)
    ContextActionService:BindAction('RightHandClose', closeHandle, false, Enum.KeyCode.ButtonR1)


end

--Replication logic

local VRPlayers = {}

VRUpdate.OnClientEvent:Connect(function(user, positions)
    if user ~= game.Players.LocalPlayer then
        if not VRPlayers[user] then
            
        end
    end
end)