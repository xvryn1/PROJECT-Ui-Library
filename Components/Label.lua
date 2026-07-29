--!strict
-- AtomicUI Label Component

local Theme = require(script.Parent.Parent.Theme)

local Label = {}
Label.__index = Label

type LabelProps = {
	Text: string,
	Size: UDim2?,
	Color: Color3?,
	Bold: boolean?,
	Parent: GuiObject,
}

function Label.new(props: LabelProps): table
	local self = setmetatable({}, Label)
	self._props = props
	self._connections = {}
	
	self:_buildLabel()
	
	return self
end

function Label:_buildLabel()
	local label = Instance.new("TextLabel")
	label.Name = "Label"
	label.Size = self._props.Size or UDim2.new(1, 0, 0, 24)
	label.BackgroundTransparency = 1
	label.Text = self._props.Text
	label.TextColor3 = self._props.Color or Theme.GetCurrent().Text
	label.TextSize = self._props.Bold and 16 or 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Font = self._props.Bold and Enum.Font.GothamBold or Enum.Font.Gotham
	label.Parent = self._props.Parent
	
	self._label = label
end

function Label:SetText(text: string)
	self._label.Text = text
end

function Label:SetColor(color: Color3)
	self._label.TextColor3 = color
end

return Label
