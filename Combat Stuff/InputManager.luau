local CAS = game:GetService("ContextActionService")
local replicatedStorage = game:GetService("ReplicatedStorage")

local DashHandler = require(script.Parent.ClientDashHandler)
local M1Handler = require(script.Parent.ClientM1Handler)
local AnimationHandler = require(replicatedStorage.AnimationManager)
local TotalHandler = require(replicatedStorage.TotalHandler)
local BlockHandler = require(script.Parent.ClientBlockHandler)

local blockEvent = replicatedStorage.BlockEvent

local KeyBinds = {
	Block = Enum.KeyCode.F,
	M1 = Enum.UserInputType.MouseButton1,
	Dash = Enum.KeyCode.Q,
}

local InputHandler = {}

local char

local m1Repeating = false
local blocking = false

local InputFunctions = {
	M1 = function(name, inputState, inputObject)
		m1Repeating = (inputState == Enum.UserInputState.Begin)

		while m1Repeating do
			M1Handler.InitiateM1(char)
			task.wait()
		end
	end,
	Block = function(name, inputState, inputObject)
		if char.Humanoid.PlatformStand then return end
		blocking = (inputState == Enum.UserInputState.Begin)

		BlockHandler.InitiateBlock(blocking, char)
	end,
	Dash = function(name, inputState, inputObject)
		DashHandler.Dash(char)
	end,

}

function InputHandler.SetUpInput(Name, PassedChar)
	if not InputFunctions[Name] then warn("Passed input name is not valid! Input Name: ".. Name) return end
	char = PassedChar
	CAS:BindAction(Name, InputFunctions[Name], false, KeyBinds[Name])
	
end

return InputHandler
