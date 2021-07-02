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
local networkClient = require(virtualRealityModules.NetworkClient)

local leftModelOpen, rightModelOpen = virtualObjects.LeftHandOpened, virtualObjects.RightHandOpened
local leftModelClose, rightModelClose = virtualObjects.LeftHandClosed, virtualObjects.RightHandClosed
local headModel = virtualObjects.Head

if VRService.VREnabled then

    StarterGui:SetCore("VRLaserPointerMode", 0)
    StarterGui:SetCore("VREnableControllerModels", false)


    local leftHand, rightHand = hand.new(leftModelOpen, leftModelClose, VRPosition.getPosition(Enum.UserCFrame.LeftHand)), hand.new(rightModelOpen, rightModelClose, VRPosition.getPosition(Enum.UserCFrame.RightHand))

    leftHand:openHand()
    rightHand:openHand()

    local function updatePosition()
        rightHand:updatePosition(VRPosition.getPosition(Enum.UserCFrame.RightHand))
        leftHand:updatePosition(VRPosition.getPosition(Enum.UserCFrame.LeftHand))
    end

    local function closeHandle(name, inputState, _)
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

    local function replicate()
        while true do
            wait(0.05)
            local positions = {Left = leftHand.latestCFrame, Right = rightHand.latestCFrame, Head = VRPosition.getPosition(Enum.UserCFrame.Head), leftOpen = leftHand.handClosed, rightOpen = rightHand.handClosed}

            VRUpdate:FireServer(positions)
        end
    end

    coroutine.wrap(replicate)()

end

--Replication logic

local VRPlayers = {}

VRUpdate.OnClientEvent:Connect(function(user, actionType, ...)
    if user ~= game.Players.LocalPlayer then
        if actionType == 'position' then
            if not VRPlayers[user] then
                --Temporary head until asset is made
                VRPlayers[user] = networkClient.new(user, leftModelOpen, leftModelClose, rightModelOpen, rightModelClose, headModel, ...)
                if user.Character then
                    user.Character.Parent = ReplicatedStorage
                end
            else
                VRPlayers[user]:updatePosition(...)
            end
        end
    end
end)

--Invisibility logic
game.Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function(c)
        if VRPlayers[p] then
            c.Parent = ReplicatedStorage
        end
    end)
end)