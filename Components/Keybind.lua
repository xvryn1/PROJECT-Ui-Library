--!strict
-- AtomicUI Keybind Component

local Theme = require(script.Parent.Parent.Theme)
local Animation = require(script.Parent.Parent.Animation)

local Keybind = {}
Keybind.__index = Keybind

type KeybindProps = {
	Label: string,
	Default: Enum.KeyCode?,
	OnChanged: ((key: Enum.KeyCode) -> ())?,
	Parent: GuiObject,
}

function Keybind.new(props: KeybindProps): table
	local self = setmetatable({}, Keybind)
	self._props = props
	self._key = props.Default or Enum.KeyCode.None
	self._listening = false
	self._connections = {}
	
	self:_buildKeybind()
	
	return self
end

function Keybind:_buildKeybind()
	local container = Instance.new("Frame")
	container.Name = "Keybind_" .. self._props.Label
	container.Size = UDim2.new(1, 0, 0, 40)
	container.BackgroundTransparency = 1
	container.Parent = self._props.Parent
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -120, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = self._props.Label
	label.TextColor3 = Theme.GetCurrent().Text
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Font = Enum.Font.Gotham
	label.Parent = container
	
	local box = Instance.new("Frame")
	box.Name = "Box"
	box.Size = UDim2.fromOffset(100, 32)
	box.Position = UDim2.new(1, -100, 0.5, -16)
	box.BackgroundColor3 = Theme.GetCurrent().Surface2
	box.BorderSizePixel = 0
	box.Parent = container
	
	local boxCorner = Instance.new("UICorner")
	boxCorner.CornerRadius = UDim.new(0, 6)
	boxCorner.Parent = box
	
	local text = Instance.new("TextLabel")
	text.Size = UDim2.new(1, 0, 1, 0)
	text.BackgroundTransparency = 1
	text.Text = self._key.Name or "None"
	text.TextColor3 = Theme.GetCurrent().Text
	text.TextSize = 14
	text.Font = Enum.Font.Gotham
	text.Parent = box
	
	local btn = Instance.new("ImageButton")
	btn.Size = UDim2.new(1, 0, 1, 0)
	btn.BackgroundTransparency = 1
	btn.Parent = box
	
	local input = game:GetService("UserInputService")
	
	btn.MouseButton1Click:Connect(function()
		if not self._listening then
			self._listening = true
			text.Text = "Press key..."
			box.BackgroundColor3 = Theme.GetCurrent().Primary
		else
			self._listening = false
			box.BackgroundColor3 = Theme.GetCurrent().Surface2
		end
	end)
	
	input.InputBegan:Connect(function(inputObj, gameProcessed)
		if self._listening and not gameProcessed then
			local key = inputObj.KeyCode
			if key ~= Enum.KeyCode.None then
				self._key = key
				text.Text = key.Name
				self._listening = false
				box.BackgroundColor3 = Theme.GetCurrent().Surface2
				
				if self._props.OnChanged then
					self._props.OnChanged(key)
				end
			end
		end
	end)
	
	self._container = container
	self._box = box
	self._text = text
end

function Keybind:GetKey(): Enum.KeyCode
	return self._key
end

function Keybind:SetKey(key: Enum.KeyCode)
	self._key = key
	self._text.Text = key.Name
end

return Keybind
