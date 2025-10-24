-- ╔════════════════════════════╗
-- ║  ⚔️  SERVER COMBAT CORE    ║
-- ╚════════════════════════════╝

local RP = game:GetService("ReplicatedStorage")


local ragdoll = require(RP.Ragdoll)
local totalHandler = require(RP.TotalHandler)
local ServerM1Handler = require(game:GetService("ServerStorage").ServerM1Handler)

local delayRemote = RP.DelayCheck
local m1Remote = RP.M1Remote
local entityremote = RP.EntityHandling
local knockEvent = RP:FindFirstChild("knockback")
local blockEvent = RP:FindFirstChild("BlockEvent")
local failPrediction = RP:FindFirstChild("PredictionFail")
local VFXEvent = RP:FindFirstChild("VFXEvent")
local ragdollPredict = RP.RagdollPredict



local npc = workspace.Alive:WaitForChild("Rig")
local blockingnpc = workspace.Alive:WaitForChild("BlockingRig")



totalHandler.AddEntity(blockingnpc)


ragdoll.SetUpRagdollCollision(npc)
ragdoll.SetUpRagdollCollision(blockingnpc)




game.Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function(char)
		ragdoll.SetUpRagdollCollision(char)
		char.Humanoid.RequiresNeck = false
		char.Parent = workspace.Alive
		totalHandler.AddEntity(char)
		
		totalHandler.FullSync(plr)
	end)
	
	plr.CharacterRemoving:Connect(function(char)
		
		totalHandler.RemoveM1Character(char)
		totalHandler.RemoveEntity(char)
		
	end)
end)

m1Remote.OnServerEvent:Connect(function(plr, hitconnected, infoBuffer, num)
	local char = plr.Character
	totalHandler.AddM1Character(char)
	if hitconnected then
	
	
		local num = tonumber(buffer.readstring(infoBuffer, 0, 1))
	local id = buffer.readu8(infoBuffer, 1)
	
	local predictedvictim = totalHandler.GetCharacterFromId(id)
	
	
	ServerM1Handler.InitiateM1(plr, char, predictedvictim, num)
		
	else

		ServerM1Handler.PrepareM1(plr, char, tonumber(num))
		
	end
end)


blockEvent.OnServerEvent:Connect(function(plr, status)
	local char = plr.Character
	local hum = char.Humanoid
	
	
	totalHandler[status](char)
	

end)

delayRemote.OnServerEvent:Connect(function(plr, t)
	delayRemote:FireAllClients(plr, t)
	
end)
