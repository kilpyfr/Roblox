local AliveFolder = workspace:WaitForChild("Alive")

local referenceHitbox = game:GetService("ReplicatedStorage").Hitboxes.M1Hitbox



local hitbox = {}

hitbox.__index = hitbox


local function pythagoreanTheorem(x,z)
	return math.sqrt(x^2 + z^2) 
end


function hitbox.New(owner, cframe, size, debug: boolean)
	local newReference = referenceHitbox:Clone()
	if size then
		referenceHitbox.Size = size
	end
	referenceHitbox.CFrame = cframe
	if debug then 
		newReference.Transparency = 0.7
	else
		newReference.Transparency = 1
	end
	
	
	return setmetatable({Size = size or referenceHitbox.Size,
						Owner = owner,
						CFrame = cframe,
						Part = newReference,
						startTime = time(),
						
							}, hitbox)
end



function hitbox:GetTouchingCharacters(cacheTable)
	self.Part.Parent = workspace
	self.Part.Anchored = true
	
	local hitCharacters = {}
	
	local activetime = 0
	
	local hyp = pythagoreanTheorem(self.Size.X, self.Size.Z)
	
	
	for i,v in pairs(cacheTable) do
		if (self.CFrame.Position - v).Magnitude < hyp/2 and i ~= self.Owner then
		
				hitCharacters[#hitCharacters + 1] = i
			
		end

	end

return hitCharacters

end

function hitbox:Delete()
	self.Part:Destroy()
	self.Part = nil
end

return hitbox
