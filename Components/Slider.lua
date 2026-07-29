--!strict
-- AtomicUI Slider Component

local Theme = require(script.Parent.Parent.Theme)
local Animation = require(script.Parent.Parent.Animation)
local Utility = require(script.Parent.Parent.Utility)

local Slider = {}
Slider.__index = Slider

type SliderProps = {
	Label: string,
	Min: number?,
	Max: number?,
	Default: number?,
	Step: number?,
	OnChanged: ((value: number) -> ())?,
	Parent: GuiObject,
}

function Slider.new(props: SliderProps): table
	local self = setmetatable({}, Slider)
	self._props = props
	self._min = props.Min or 0
	self._max = props.Max or 100
	self._step = props.Step or 1
	self._value = props.Default or (self._min + self._max) / 2
	self._connections = {}
	
	self:_buildSlider()
	
	return self
end

function Slider:_buildSlider()
	local container = Instance.new("Frame")
	container.Name = "Slider_" .. self._props.Label
	container.Size = UDim2.new(1, 0, 0, 56)
	container.BackgroundTransparency = 1
	container.Parent = self._props.Parent
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -100, 0, 20)
	label.BackgroundTransparency = 1
	label.Text = self._props.Label
	label.TextColor3 = Theme.GetCurrent().Text
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Font = Enum.Font.Gotham
	label.Parent = container
	
	local valueLabel = Instance.new("TextLabel")
	valueLabel.Size = UDim2.fromOffset(80, 20)
	valueLabel.Position = UDim2.new(1, -80, 0, 0)
	valueLabel.BackgroundTransparency = 1
	valueLabel.Text = tostring(self._value)
	valueLabel.TextColor3 = Theme.GetCurrent().TextSecondary
	valueLabel.TextSize = 14
	valueLabel.TextXAlignment = Enum.TextXAlignment.Right
	valueLabel.Font = Enum.Font.Gotham
	valueLabel.Parent = container
	
	local track = Instance.new("Frame")
	track.Name = "Track"
	track.Size = UDim2.new(1, 0, 0, 4)
	track.Position = UDim2.fromOffset(0, 36)
	track.BackgroundColor3 = Theme.GetCurrent().Surface2
	track.BorderSizePixel = 0
	track.Parent = container
	
	local trackCorner = Instance.new("UICorner")
	trackCorner.CornerRadius = UDim.new(1, 0)
	trackCorner.Parent = track
	
	local fill = Instance.new("Frame")
	fill.Name = "Fill"
	fill.Size = UDim2.fromScale(0.5, 1)
	fill.BackgroundColor3 = Theme.GetCurrent().Primary
	fill.BorderSizePixel = 0
	fill.Parent = track
	
	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(1, 0)
	fillCorner.Parent = fill
	
	local knob = Instance.new("Frame")
	knob.Name = "Knob"
	knob.Size = UDim2.fromOffset(16, 16)
	knob.Position = UDim2.fromScale(0.5, 0.5)
	knob.AnchorPoint = Vector2.new(0.5, 0.5)
	knob.BackgroundColor3 = Theme.GetCurrent().Primary
	knob.BorderSizePixel = 0
	knob.Parent = track
	
	local knobCorner = Instance.new("UICorner")
	knobCorner.CornerRadius = UDim.new(1, 0)
	knobCorner.Parent = knob
	
	local input = game:GetService("UserInputService")
	local isDragging = false
	
	local function updateSlider(position: Vector2)
		local absoluteSize = track.AbsoluteSize
		local absolutePos = track.AbsolutePosition
		local localX = position.X - absolutePos.X
		local percent = Utility.Clamp(localX / absoluteSize.X, 0, 1)
		
		local rawValue = self._min + (self._max - self._min) * percent
		local steppedValue = math.floor(rawValue / self._step + 0.5) * self._step
		self._value = Utility.Clamp(steppedValue, self._min, self._max)
		
		fill.Size = UDim2.fromScale(percent, 1)
		knob.Position = UDim2.fromScale(percent, 0.5)
		valueLabel.Text = tostring(self._value)
		
		if self._props.OnChanged then
			self._props.OnChanged(self._value)
		end
	end
	
	knob.InputBegan:Connect(function(inputObj)
		if inputObj.UserInputType == Enum.UserInputType.MouseButton1 then
			isDragging = true
		end
	end)
	
	knob.InputEnded:Connect(function(inputObj)
		if inputObj.UserInputType == Enum.UserInputType.MouseButton1 then
			isDragging = false
		end
	end)
	
	track.InputBegan:Connect(function(inputObj)
		if inputObj.UserInputType == Enum.UserInputType.MouseButton1 then
			updateSlider(inputObj.Position)
		end
	end)
	
	input.InputChanged:Connect(function(inputObj)
		if isDragging and inputObj.UserInputType == Enum.UserInputType.MouseMovement then
			updateSlider(inputObj.Position)
		end
	end)
	
	self._container = container
	self._fill = fill
	self._knob = knob
	self._valueLabel = valueLabel
	self._track = track
	self._updateSlider = updateSlider
end

function Slider:GetValue(): number
	return self._value
end

function Slider:SetValue(value: number)
	self._value = Utility.Clamp(value, self._min, self._max)
	local percent = (self._value - self._min) / (self._max - self._min)
	self._fill.Size = UDim2.fromScale(percent, 1)
	self._knob.Position = UDim2.fromScale(percent, 0.5)
	self._valueLabel.Text = tostring(self._value)
end

return Slider
