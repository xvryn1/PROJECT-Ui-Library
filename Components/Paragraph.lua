--!strict
-- AtomicUI Paragraph Component

local Theme = require(script.Parent.Parent.Theme)
local Utility = require(script.Parent.Parent.Utility)

local Paragraph = {}
Paragraph.__index = Paragraph

type ParagraphProps = {
	Text: string,
	MaxWidth: number?,
	Parent: GuiObject,
}

function Paragraph.new(props: ParagraphProps): table
	local self = setmetatable({}, Paragraph)
	self._props = props
	self._connections = {}
	
	self:_buildParagraph()
	
	return self
end

function Paragraph:_buildParagraph()
	local container = Instance.new("Frame")
	container.Name = "Paragraph"
	container.Size = UDim2.new(1, 0, 0, 0)
	container.BackgroundTransparency = 1
	container.AutomaticSize = Enum.AutomaticSize.Y
	container.Parent = self._props.Parent
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = self._props.Text
	label.TextColor3 = Theme.GetCurrent().TextSecondary
	label.TextSize = 14
	label.TextWrapped = true
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Font = Enum.Font.Gotham
	label.AutomaticSize = Enum.AutomaticSize.Y
	label.Parent = container
	
	self._container = container
	self._label = label
end

function Paragraph:SetText(text: string)
	self._label.Text = text
end

function Paragraph:GetText(): string
	return self._label.Text
end

return Paragraph
