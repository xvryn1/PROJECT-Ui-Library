--!strict
-- AtomicUI Toggle Component

local Theme = require(script.Parent.Parent.Theme)
local Animation = require(script.Parent.Parent.Animation)

local Toggle = {}
Toggle.__index = Toggle

type ToggleProps = {
	Label: string,
	Default: boolean?,
	OnChanged: ((value: boolean) -> ())?,
	Parent: GuiObject,
}

function Toggle.new(props: ToggleProps): table
	local self = setmetatable({}, Toggle)
	self._props = props
	self._value = props.Default or false
	self._connections = {}
	
	self:_buildToggle()
	
	return self
end

function Toggle:_buildToggle()
	local container = Instance.new("Frame")
	container.Name = "Toggle_" .. self._props.Label
	container.Size = UDim2.new(1, 0, 0, 40)
	container.BackgroundTransparency = 1
	container.Parent = self._props.Parent
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -80, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = self._props.Label
	label.TextColor3 = Theme.GetCurrent().Text
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Font = Enum.Font.Gotham
	label.Parent = container
	
	local track = Instance.new("Frame")
	track.Name = "Track"
	track.Size = UDim2.fromOffset(48, 26)
	track.Position = UDim2.new(1, -48, 0.5, -13)
	track.BackgroundColor3 = Theme.GetCurrent().Surface2
	track.BackgroundTransparency = 0
	track.BorderSizePixel = 0
	track.Parent = container
	
	local trackCorner = Instance.new("UICorner")
	trackCorner.CornerRadius = UDim.new(1, 0)
	trackCorner.Parent = track
	
	local knob = Instance.new("Frame")
	knob.Name = "Knob"
	knob.Size = UDim2.fromOffset(20, 20)
	knob.Position = UDim2.fromOffset(3, 3)
	knob.BackgroundColor3 = Theme.GetCurrent().Text
	knob.BackgroundTransparency = 0
	knob.BorderSizePixel = 0
	knob.Parent = track
	
	local knobCorner = Instance.new("UICorner")
	knobCorner.CornerRadius = UDim.new(1, 0)
	knobCorner.Parent = knob
	
	if self._value then
		track.BackgroundColor3 = Theme.GetCurrent().Primary
		knob.Position = UDim2.fromOffset(25, 3)
	end
	
	local btn = Instance.new("ImageButton")
	btn.Size = UDim2.new(1, 0, 1, 0)
	btn.BackgroundTransparency = 1
	btn.Parent = track
	
	btn.MouseButton1Click:Connect(function()
		self:Toggle()
	end)
	
	self._container = container
	self._track = track
	self._knob = knob
end

function Toggle:Toggle()
	self._value = not self._value
	
	if self._value then
		local trackTween = Animation.Create(self._track, {
			BackgroundColor3 = Theme.GetCurrent().Primary,
		}, { Duration = 0.2 })
		trackTween:Play()
		
		local knobTween = Animation.Create(self._knob, {
			Position = UDim2.fromOffset(25, 3),
		}, { Duration = 0.2 })
		knobTween:Play()
	else
		local trackTween = Animation.Create(self._track, {
			BackgroundColor3 = Theme.GetCurrent().Surface2,
		}, { Duration = 0.2 })
		trackTween:Play()
		
		local knobTween = Animation.Create(self._knob, {
			Position = UDim2.fromOffset(3, 3),
		}, { Duration = 0.2 })
		knobTween:Play()
	end
	
	if self._props.OnChanged then
		self._props.OnChanged(self._value)
	end
end

function Toggle:GetValue(): boolean
	return self._value
end

function Toggle:SetValue(value: boolean)
	if self._value ~= value then
		self._value = value
		self:Toggle()
	end
end

return Toggle
