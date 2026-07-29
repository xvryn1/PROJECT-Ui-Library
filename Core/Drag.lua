--!strict
-- AtomicUI Drag System

local Drag = {}
Drag.__index = Drag

function Drag.Enable(object: GuiObject, dragHandle: GuiObject?): () -> ()
	local handle = dragHandle or object
	local input = game:GetService("UserInputService")
	local isDragging = false
	local dragStart = Vector2.new()
	local startPos = UDim2.new()
	
	handle.InputBegan:Connect(function(inputObj)
		if inputObj.UserInputType == Enum.UserInputType.MouseButton1 then
			isDragging = true
			dragStart = inputObj.Position
			startPos = object.Position
		end
	end)
	
	handle.InputEnded:Connect(function(inputObj)
		if inputObj.UserInputType == Enum.UserInputType.MouseButton1 then
			isDragging = false
		end
	end)
	
	input.InputChanged:Connect(function(inputObj)
		if isDragging and inputObj.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = inputObj.Position - dragStart
			object.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)
	
	return function()
		-- cleanup connections would be here if stored
	end
end

function Drag.Disable(object: GuiObject)
	-- Disable drag by removing references
end

return Drag
