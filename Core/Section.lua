--!strict
-- AtomicUI Section System

local Theme = require(script.Parent.Theme)

local Section = {}
Section.__index = Section

type SectionProps = {
	Name: string,
	Parent: any,
	Column: number?,
}

function Section.new(props: SectionProps): table
	local self = setmetatable({}, Section)
	
	self._name = props.Name
	self._parent = props.Parent
	self._column = props.Column or 1
	self._children = {}
	
	self:_buildSection()
	
	return self
end

function Section:_buildSection()
	local container = Instance.new("Frame")
	container.Name = "Section_" .. self._name
	container.Size = UDim2.new(1, 0, 0, 0)
	container.BackgroundTransparency = 1
	container.AutomaticSize = Enum.AutomaticSize.Y
	container.Parent = self._parent
	
	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(1, 0, 0, 24)
	title.BackgroundTransparency = 1
	title.Text = self._name
	title.TextColor3 = Theme.GetCurrent().TextSecondary
	title.TextSize = 14
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Font = Enum.Font.GothamBold
	title.Parent = container
	
	local content = Instance.new("Frame")
	content.Name = "Content"
	content.Size = UDim2.new(1, 0, 0, 0)
	content.BackgroundTransparency = 1
	content.AutomaticSize = Enum.AutomaticSize.Y
	content.Parent = container
	
	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 8)
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout.Parent = content
	
	self._container = container
	self._content = content
	self._layout = layout
end

function Section:AddElement(element: table)
	table.insert(self._children, element)
end

function Section:GetContainer(): Frame
	return self._content
end

return Section
