local VRService = game:GetService("VRService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")

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

    local leftHand, rightHand = hand.new(leftModelOpen, leftModelClose, Enum.UserCFrame.LeftHand), hand.new(rightModelOpen, leftModelClose, Enum.UserCFrame.RightHand)

    local function updatePosition()
        leftHand:updatePosition()
        rightHand:updatePosition()
    end

    RunService:BindToRenderStep('UpdatePosition', 100, updatePosition)

    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.ButtonR1 then
            --Fire server logic here
            rightHand:closeHand()
        elseif input.KeyCode == Enum.KeyCode.ButtonL1 then
            leftHand:closeHand()
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.ButtonR1 then
            --Fire server logic here
            rightHand:openHand()
        elseif input.KeyCode == Enum.KeyCode.ButtonL1 then
            leftHand:openHand()
        end
    end)

    --Send position information to the server
    --[[coroutine.wrap(function()
        while true do
            VRUpdate:FireServer({head = VRPosition.getPosition(Enum.UserCFrame.Head), right = rightHand.latestCFrame, left = leftHand.latestCFrame})
            wait(0.05)
        end
    end)()]]

end

--Replication logic

local VRPlayers = {}

VRUpdate.OnClientEvent:Connect(function(user, positions)
    if user ~= game.Players.LocalPlayer then
        if not VRPlayers[user] then
            
        end
    end
end)