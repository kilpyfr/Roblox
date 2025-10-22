local RunService = game:GetService("RunService")
local httpService = game:GetService("HttpService")
local Debris = game:GetService("Debris")
local RS = game:GetService("ReplicatedStorage")

local HumanoidSettings = require(RS.HumanoidSettings)


local failPrediction = RS.PredictionFail
local entityRemote = RS.EntityHandling
local vfxpart = RS.VFXPart
local failPredict = RS.PredictionFail


local TotalHandler = {}


local ALL_ENTITY_IDS = {}
local ID_TO_CHARACTER = {}


local freeIds = {}

for i = 1, 60 ,1 do
	table.insert(freeIds, i)
end

local StunnedCharacters = {}
local StunEndTime = {}
local stunIndexMap = {}



local M1Character = {}
local M1Debounce = {}
local M1Number = {}
local M1IndexMap = {}


local BlockingCharacters = {}
local BlockStaminas = {}
local IsBlocking = {}
local BlockResetTimes = {}
local blockIndexMap = {}


local function getNextEntityId()
	
	
	
	
	return freeIds[1]
end



RunService.Heartbeat:Connect(function()
	
	for i = #StunnedCharacters, 1, -1 do

		if time() >= StunEndTime[i] then
			
			local char = StunnedCharacters[i]
				if i < #StunnedCharacters then
			local lastIndex = #StunnedCharacters
			local lastChar = StunnedCharacters[lastIndex]
			StunnedCharacters[i] = lastChar
			StunEndTime[i] = StunEndTime[lastIndex] 
			stunIndexMap[lastChar] = i	
			
			
					StunnedCharacters[lastIndex] = nil
					StunEndTime[lastIndex] = nil
				else
					StunnedCharacters[i] = nil
					StunEndTime[i] = nil
					
					
				end
			
			stunIndexMap[char] = nil
			HumanoidSettings.ResetHumanoid(char)
				TotalHandler.UpdateState(char, "Idle")
		
				
			
		end
	end
	
	for i = #BlockingCharacters, 1, -1 do
		if time() >= BlockResetTimes[i] and BlockResetTimes[i] ~= 0 then
			if not IsBlocking[i] then
				BlockStaminas[i] = 3
				BlockResetTimes[i] = 0
			end
		end
	end
	
	
end)

function TotalHandler.ClientSync(table1,table2)
	ALL_ENTITY_IDS = table1
	ID_TO_CHARACTER = table2
end

function TotalHandler.FullSync(plr)
	
		
	entityRemote:FireClient(plr, "ClientSync", nil, nil, ALL_ENTITY_IDS, ID_TO_CHARACTER)
	
	
	
end

function TotalHandler.GetIdFromCharacter(char)
	
	return ALL_ENTITY_IDS[char.Name]
end

function TotalHandler.GetCharacterFromId(id)
	
	return workspace.Alive:FindFirstChild(ID_TO_CHARACTER[id])
end

function TotalHandler.AddEntity(char, id)
	if not id then
	id = getNextEntityId()
		table.remove(freeIds, 1)
	end
	print(RunService:IsClient())
	ALL_ENTITY_IDS[char.Name] = id
	ID_TO_CHARACTER[id] = char.Name
	
	if RunService:IsServer() then
	entityRemote:FireAllClients("AddEntity", char, id)
	end
end

function TotalHandler.RemoveEntity(char)
	if not ALL_ENTITY_IDS[char.Name] then return end
	local id = ALL_ENTITY_IDS[char.Name]
	table.insert(freeIds, id)
	
	ID_TO_CHARACTER[id] = nil
	ALL_ENTITY_IDS[char.Name] = nil
	
	
	
	if RunService:IsServer() then
	entityRemote:FireAllClients("RemoveEntity", char)
	end
end




function TotalHandler.CheckBlock(char)
	local index = blockIndexMap[char]
	
	
	return IsBlocking[index]
end


function TotalHandler.MinusBlockStamina(char, amount)
	local index = blockIndexMap[char]
	if not index then return end 
	
	BlockStaminas[index] -= amount
	
	if BlockStaminas[index] <= 0 then
		TotalHandler.EndBlock(char)
		TotalHandler.Stun(char, 3)
		for i,v in pairs(char.Humanoid.Animator:GetPlayingAnimationTracks()) do
			if v.Animation.AnimationId == "rbxassetid://75274270994166" then
				v:Stop()
				if game.Players:GetPlayerFromCharacter(char) then
					failPredict:FireClient(game.Players:GetPlayerFromCharacter(char), "Block")
				end
			end
		end
	end
	
	
	local BlockGui = char:FindFirstChild("BlockStaminaGui")
	if BlockGui then
		BlockGui.BlockStaminaFill.Size = UDim2.new(BlockStaminas[index]/10, 0, 0.051, 0)
	end
end

function TotalHandler.EndBlock(char)
	
	if not TotalHandler.CheckBlock(char) then return end
	if (TotalHandler.CheckStun(char) or char:GetAttribute("State") == "M1") then return end
	
	
	local index = blockIndexMap[char]
	if not index then
		return 
	end
IsBlocking[index] = false
if BlockStaminas[index] <= 0 then
	BlockStaminas[index] = 3
end

BlockResetTimes[index] = time() + 2
	TotalHandler.UpdateState(char, "Idle")
	HumanoidSettings.ResetHumanoid(char)

	local BlockGui = char:FindFirstChild("BlockStaminaGui")
	if BlockGui then
		BlockGui:Destroy()
	end

end


function TotalHandler.DestroyBlock(char)
	local index = blockIndexMap[char]
	if not index then
		return 
	end
	if index < #BlockingCharacters then
		local lastIndex = #BlockingCharacters
		local lastChar = BlockingCharacters[lastIndex]
		BlockingCharacters[index] = lastChar
		BlockStaminas[index] = BlockStaminas[lastIndex]
		IsBlocking[index] = IsBlocking[lastIndex]
		blockIndexMap[lastChar] = index
		BlockStaminas[lastIndex] = nil
		BlockingCharacters[lastIndex] = nil
		IsBlocking[lastIndex] = nil
	else
		BlockingCharacters[index] = nil
		BlockStaminas[index] = nil
		IsBlocking[index] = nil
	end
	blockIndexMap[char] = nil
--	TotalHandler.UpdateState(char, "Idle")
	
	
	local BlockGui = char:FindFirstChild("BlockStaminaGui")
	if BlockGui then
		BlockGui:Destroy()
	end
	
end


function TotalHandler.StartBlock(char)
	local blockingPlayer = game.Players:GetPlayerFromCharacter(char)
	
	if (TotalHandler.CheckStun(char) or  char:GetAttribute("State") == "M1") and blockingPlayer then failPrediction:FireClient(blockingPlayer, "Block") return end
	
	local index = blockIndexMap[char]
	if not index then
		index = #BlockingCharacters + 1
		blockIndexMap[char] = index
		BlockingCharacters[index] = char
		BlockStaminas[index] = 3
		BlockResetTimes[index] = 0
		IsBlocking[index] = true
	else
		IsBlocking[index] = true
	end

	TotalHandler.UpdateState(char, "Blocking")
	HumanoidSettings.BlockSettings(char)
	
	
	local BlockGui = game.StarterGui.BlockStaminaGui:Clone()
	BlockGui.Parent = char
	BlockGui.Enabled = true
	BlockGui.Adornee = char
	BlockGui.BlockStaminaFill.Size = UDim2.new(BlockStaminas[index]/10, 0, 0.051, 0)
end


function TotalHandler.CheckStun(char)
	local index = stunIndexMap[char]
	

	
	return StunnedCharacters[index]
end

function TotalHandler.Stun(char, StunTime)

	local index = stunIndexMap[char]
	if not index then
		index = #StunnedCharacters +1
		stunIndexMap[char] = index
	end
	StunnedCharacters[index] = char
	StunEndTime[index] = time() + StunTime
	HumanoidSettings.ZeroAll(char)
	TotalHandler.UpdateState(char, "Stunned")
end


function TotalHandler.FetchM1Data(char, WhatToFetch)
	local index = M1IndexMap[char]
	
	if not index then
		return nil
	end
	
	if WhatToFetch == "Debounce" then
		return M1Debounce[index]
	elseif WhatToFetch == "Number" then
		return M1Number[index]
	end

end

function TotalHandler.RemoveM1Character(char)
	local index = M1IndexMap[char]
	if not index then
		return
	end
	local lastIndex = #M1Character
	if index < lastIndex then
		
		local lastChar = M1Character[lastIndex]
		M1Character[index] = lastChar
		M1Debounce[index] = M1Debounce[lastIndex]
		M1Number[index] = M1Number[lastIndex]
		M1IndexMap[lastChar] = index
		
		M1Debounce[lastIndex] = nil
		M1Number[lastIndex] = nil
		M1Character[lastIndex] = nil
		
	else
		M1Character[index] = nil
		M1Debounce[index] = nil
		M1Number[index] = nil
		
	end
	M1IndexMap[char] = nil
	
end

function TotalHandler.ChangeM1Info(char, change, changevalue)
	local index = M1IndexMap[char]
	if not index then
		return 
	end
	if change == "Debounce" then
		M1Debounce[index] = changevalue
	elseif change == "Number" then
		M1Number[index] = changevalue
	end
	
	
end


function TotalHandler.AddM1Character(char)
	local index = M1IndexMap[char]
	if not index then
		index = #M1Character + 1
		M1IndexMap[char] = index
	end
	
	M1Character[index] = char
	
end



function TotalHandler.Knockback(char, kb, duration)
	local linearVelocity = Instance.new("LinearVelocity")
	local linearAtt = Instance.new("Attachment")
	local rootPart = char.HumanoidRootPart
	
	linearAtt.Parent = rootPart
	linearVelocity.Parent = linearAtt
	linearVelocity.Attachment0 = linearAtt
	
	linearVelocity.ForceLimitMode = Enum.ForceLimitMode.PerAxis
	linearVelocity.MaxAxesForce = Vector3.new(100000,0,100000)
	linearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
	linearVelocity.VectorVelocity = kb
	
	Debris:AddItem(linearAtt, duration)
	
	task.spawn(function()
		char.Humanoid.AutoRotate = false
		task.wait(duration)
		char.Humanoid.AutoRotate = true
	end)
end



function TotalHandler.UpdateState(char, state)
	char:SetAttribute("State", state)
end


return TotalHandler



