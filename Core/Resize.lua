--!strict
-- AtomicUI Resize System

local Resize = {}
Resize.__index = Resize

function Resize.Enable(object: GuiObject, handle: GuiObject?, minSize: Vector2?, maxSize: Vector2?)
	local resizeHandle = handle or object
	local input = game:GetService("UserInputService")
	local isResizing = false
	local resizeStart = Vector2.new()
	local startSize = UDim2.new()
	
	resizeHandle.InputBegan:Connect(function(inputObj)
		if inputObj.UserInputType == Enum.UserInputType.MouseButton1 then
			isResizing = true
			resizeStart = inputObj.Position
			startSize = object.Size
		end
	end)
	
	resizeHandle.InputEnded:Connect(function(inputObj)
		if inputObj.UserInputType == Enum.UserInputType.MouseButton1 then
			isResizing = false
		end
	end)
	
	input.InputChanged:Connect(function(inputObj)
		if isResizing and inputObj.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = inputObj.Position - resizeStart
			local newWidth = math.max(
				startSize.X.Offset + delta.X,
				minSize and minSize.X or 100
			)
			local newHeight = math.max(
				startSize.Y.Offset + delta.Y,
				minSize and minSize.Y or 100
			)
			
			if maxSize then
				newWidth = math.min(newWidth, maxSize.X)
				newHeight = math.min(newHeight, maxSize.Y)
			end
			
			object.Size = UDim2.fromOffset(newWidth, newHeight)
		end
	end)
	
	return function()
		-- cleanup
	end
end

return Resize
