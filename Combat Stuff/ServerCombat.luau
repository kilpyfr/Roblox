

local replicatedStorage = game:GetService("ReplicatedStorage")

local totalHandler = require(replicatedStorage.TotalHandler)
local ServerM1Handler = require(game:GetService("ServerStorage").ServerM1Handler)

local delayRemote = replicatedStorage.DelayCheck
local m1Remote = replicatedStorage.M1Remote
local entityremote = replicatedStorage.EntityHandling
local knockEvent = replicatedStorage:FindFirstChild("knockback")
local blockEvent = replicatedStorage:FindFirstChild("BlockEvent")
local failPrediction = replicatedStorage:FindFirstChild("PredictionFail")
local VFXEvent = replicatedStorage:FindFirstChild("VFXEvent")

local npc = workspace.Alive:WaitForChild("Rig")
local blockingnpc = workspace.Alive:WaitForChild("BlockingRig")

totalHandler.AddEntity(blockingnpc)

game.Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function(char)
		char.Parent = workspace.Alive
		totalHandler.AddEntity(char)
		
		totalHandler.FullSync(plr)
	end)
	
	plr.CharacterRemoving:Connect(function(char)
		
		totalHandler.RemoveM1Character(char)
		totalHandler.RemoveEntity(char)
		
	end)
end)

m1Remote.OnServerEvent:Connect(function(plr, hitconnected, enityId, Num)
	local char = plr.Character
	totalHandler.AddM1Character(char)
	if hitconnected then
	local predictedVictim = totalHandler.GetCharacterFromId(enityId)

	ServerM1Handler.InitiateM1(plr, char, predictedVictim, tonumber(Num))
	
	else
		ServerM1Handler.PrepareM1(plr, char, tonumber(Num))
		
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
