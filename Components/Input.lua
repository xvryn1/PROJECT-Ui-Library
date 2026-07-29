--!strict
-- AtomicUI Input Component

local Theme = require(script.Parent.Parent.Theme)

local Input = {}
Input.__index = Input

type InputProps = {
	Label: string,
	Placeholder: string?,
	Default: string?,
	OnChanged: ((value: string) -> ())?,
	Parent: GuiObject,
}

function Input.new(props: InputProps): table
	local self = setmetatable({}, Input)
	self._props = props
	self._connections = {}
	
	self:_buildInput()
	
	return self
end

function Input:_buildInput()
	local container = Instance.new("Frame")
	container.Name = "Input_" .. self._props.Label
	container.Size = UDim2.new(1, 0, 0, 60)
	container.BackgroundTransparency = 1
	container.Parent = self._props.Parent
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 20)
	label.BackgroundTransparency = 1
	label.Text = self._props.Label
	label.TextColor3 = Theme.GetCurrent().Text
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Font = Enum.Font.Gotham
	label.Parent = container
	
	local box = Instance.new("TextBox")
	box.Size = UDim2.new(1, 0, 0, 36)
	box.Position = UDim2.fromOffset(0, 24)
	box.BackgroundColor3 = Theme.GetCurrent().Surface2
	box.BorderSizePixel = 0
	box.Text = self._props.Default or ""
	box.TextColor3 = Theme.GetCurrent().Text
	box.TextSize = 14
	box.Font = Enum.Font.Gotham
	box.PlaceholderText = self._props.Placeholder or "Enter text..."
	box.PlaceholderColor3 = Theme.GetCurrent().TextMuted
	box.Parent = container
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = box
	
	box:GetPropertyChangedSignal("Text"):Connect(function()
		if self._props.OnChanged then
			self._props.OnChanged(box.Text)
		end
	end)
	
	self._container = container
	self._box = box
end

function Input:GetValue(): string
	return self._box.Text
end

function Input:SetValue(value: string)
	self._box.Text = value
end

function Input:Clear()
	self._box.Text = ""
end

return Input
