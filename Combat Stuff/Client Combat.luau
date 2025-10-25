
-- ╔════════════════════════════╗
-- ║  ⚔️  CLIENT COMBAT CORE    ║
-- ╚════════════════════════════╝

local RS = game:GetService("ReplicatedStorage")
local runSevice = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local CAS = game:GetService("ContextActionService")
local contentProvider = game:GetService("ContentProvider")

local plr = game.Players.LocalPlayer
local char = script.Parent
local hum = char:WaitForChild("Humanoid")

local animator = hum:FindFirstChild("Animator")

local m1Hitbox = RS.Hitboxes.M1Hitbox
local entityRemote = RS.EntityHandling
local delayRemote = RS.DelayCheck
local m1Remote = RS.M1Remote
local knockEvent = RS.knockback
local blockEvent = RS.BlockEvent
local VFXEvent = RS.VFXEvent
local failPrediction = RS.PredictionFail


local Handler = require(RS.TotalHandler)
local hitboxclass = require(RS.HitboxClass)
local cacheHandler = require(RS.cacheHandler)
local AnimationHandler = require(RS.AnimationManager)
local InputManager = require(script.InputHandler)
local VFXHandler = require(RS.VFXHandler)
local HumanoidManager = require(RS.HumanoidSettings)

cacheHandler.Initialize(char)

local blocking = false
local fakeStunned = false

local loadTable = {}
for _,v in script.Animations:GetChildren() do
		table.insert(loadTable, v)
end
contentProvider:PreloadAsync(loadTable)

HumanoidManager.SetUp(char)

local KeyBinds = {
	Block = Enum.KeyCode.F,
	M1 = Enum.UserInputType.MouseButton1,
	Dash = Enum.KeyCode.Q,
}

local RollBackAnimamations = {
	["Block"] = {script.Animations.block.AnimationId},
	["M1"] = script.Animations.M1Animations:GetChildren(),

}

InputManager.SetUpInput("M1", char)
InputManager.SetUpInput("Block", char)
InputManager.SetUpInput("Dash", char)

delayRemote.OnClientEvent:Connect(function(p, t)
	if p == plr then return end 
	local delayt = workspace:GetServerTimeNow() - t
	local m1ids = script.Animations.M1Animations:GetChildren()
	local con
	 con = p.Character.Humanoid.Animator.AnimationPlayed:Connect(function(animtrack)
		if table.find(m1ids, animtrack.Animation.AnimationId) then
			
		animtrack.TimePosition += delayt
		con:Disconnect()
		
		end
	 end)
	 
	 
	 print(delayt)
end)

m1Remote.OnClientEvent:Connect(function(num)
	
	AnimationHandler.PlayAnimation(char, 1, AnimationHandler.M1VICTIMANIMS[num])
end)

knockEvent.OnClientEvent:Connect(function(kb, duration)
	
	local char = plr.Character
	Handler.Knockback(char, kb, duration)
	
end)

failPrediction.OnClientEvent:Connect(function(Type)

	AnimationHandler.StopAnimation(char, RollBackAnimamations[Type])
end)

VFXEvent.OnClientEvent:Connect(function(Buffer)
	local entityId = buffer.readu8(Buffer, 0)
	local Type = buffer.readstring(Buffer, 1, buffer.len(Buffer) - 1)
	local vfxchar = Handler.GetCharacterFromId(entityId)
	
	VFXHandler[Type.."VFX"](vfxchar)
end)

entityRemote.OnClientEvent:Connect(function(callBack, echar, id, table1, table2)
	if callBack == "AddEntity" and game.Players:GetPlayerFromCharacter(echar) and game.Players:GetPlayerFromCharacter(echar) == plr then return end
	
	if callBack == "ClientSync" then
	Handler.ClientSync(table1, table2)
	return
	end
	
	Handler[callBack](echar, id)
end)
