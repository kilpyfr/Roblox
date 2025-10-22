local RS = game:GetService("ReplicatedStorage")
local AnimationHandler = require(RS.AnimationManager)
local cacheHandler = require(RS.cacheHandler)
local hitboxclass = require(RS.HitboxClass)
local AllHandler = require(RS.TotalHandler)
local VFXHandler = require(RS.VFXHandler)

local HumanoidSettings = require(RS.HumanoidSettings)

local DashHandler = {}

local DASHDEBOUNCE = 2


local DEBOUNCE = false

local DashAnimations = {
	[1] = script.frontDash,
	[2] = script.rightDash,
	[3] = script.leftDash,
	[4] = script.backDash
}

local Directions = {
	[0] = "RightVector",
	[1] = "LookVector"
	
}

local DashData = {                     
	["-1,0"] = { anim = script.backDash,  dir = -1, force = -70, dur = 0.2 },
	["1,0"] = { anim = script.frontDash, dir =  1, force =  50, dur = 0.4 },
	["0,-1"] = { anim = script.leftDash,  dir =  0, force = -70, dur = 0.2 },
	["0,1"] = { anim = script.rightDash, dir =  0, force =  70, dur = 0.2 },
}


local function ApplyVelocity(char, duration, direction, force)
	
	
	
	local linearVelocity = Instance.new("LinearVelocity")
	local linearAtt = Instance.new("Attachment")
	local rootPart = char.HumanoidRootPart

	linearAtt.Parent = rootPart
	linearVelocity.Parent = linearAtt
	linearVelocity.Attachment0 = linearAtt

	linearVelocity.ForceLimitMode = Enum.ForceLimitMode.PerAxis
	linearVelocity.MaxAxesForce = Vector3.new(100000,0,100000)
	linearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
	HumanoidSettings.ZeroAll(char)
	VFXHandler.DashVFX(char)
	task.spawn(function()
		while linearVelocity.Parent ~= nil do
			if char:GetAttribute("State") == "Stunned"   then linearAtt:Destroy() return end
			linearVelocity.VectorVelocity = rootPart.CFrame[Directions[math.abs(direction)]] * force 
			task.wait()
		end
		HumanoidSettings.ResetHumanoid(char)
	end)
	
	

	game:GetService("Debris"):AddItem(linearAtt, duration)
	
end


function DashHandler.Dash(char)
	if DEBOUNCE or not char.Humanoid then return end
	if char.Humanoid.WalkSpeed == 0 then return end
	if char:GetAttribute("State") == "Stunned" or char:GetAttribute("State") == "Blocking" or char:GetAttribute("State") == "M1" then return end
	DEBOUNCE = true
	local Root: Part = char.HumanoidRootPart
	local Humanoid: Humanoid = char.Humanoid
	local initionLV: Vector3 = Root.CFrame.LookVector
	local initionRV: Vector3 = Root.CFrame.RightVector
	
	local inObjectSpaceMD = Root.CFrame:VectorToObjectSpace(Humanoid.MoveDirection)
	
	local frontDirection = math.round(Humanoid.MoveDirection:Dot(initionLV)) 
	local rightDirection = math.round(Humanoid.MoveDirection:Dot(initionRV)) 
	
	
	if math.abs(frontDirection) == 1 then
		rightDirection = 0
	end
	local formattedString = string.format("%d,%d", frontDirection, rightDirection)
	local data = DashData[formattedString]
	if not data then DEBOUNCE = false return end
	
	AnimationHandler.PlayAnimation(char, 1, data.anim)
	ApplyVelocity(char, data.dur, data.dir, data.force)
	

	
	
	task.wait(DASHDEBOUNCE)
	DEBOUNCE = false
	
	
	
	
	
	
end





return DashHandler
