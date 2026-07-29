--!strict
-- AtomicUI Groupbox Component

local Theme = require(script.Parent.Parent.Theme)

local Groupbox = {}
Groupbox.__index = Groupbox

type GroupboxProps = {
	Title: string,
	Parent: GuiObject,
}

function Groupbox.new(props: GroupboxProps): table
	local self = setmetatable({}, Groupbox)
	self._props = props
	self._children = {}
	self._connections = {}
	
	self:_buildGroupbox()
	
	return self
end

function Groupbox:_buildGroupbox()
	local container = Instance.new("Frame")
	container.Name = "Groupbox_" .. self._props.Title
	container.Size = UDim2.new(1, 0, 0, 0)
	container.BackgroundColor3 = Theme.GetCurrent().Surface2
	container.BackgroundTransparency = 0.5
	container.BorderSizePixel = 0
	container.AutomaticSize = Enum.AutomaticSize.Y
	container.Parent = self._props.Parent
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = container
	
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -32, 0, 28)
	title.Position = UDim2.fromOffset(16, 8)
	title.BackgroundTransparency = 1
	title.Text = self._props.Title
	title.TextColor3 = Theme.GetCurrent().TextSecondary
	title.TextSize = 14
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Font = Enum.Font.GothamBold
	title.Parent = container
	
	local content = Instance.new("Frame")
	content.Name = "Content"
	content.Size = UDim2.new(1, -32, 0, 0)
	content.Position = UDim2.fromOffset(16, 40)
	content.BackgroundTransparency = 1
	content.AutomaticSize = Enum.AutomaticSize.Y
	content.Parent = container
	
	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 8)
	layout.Parent = content
	
	self._container = container
	self._content = content
end

function Groupbox:AddElement(element: table)
	table.insert(self._children, element)
end

function Groupbox:GetContainer(): Frame
	return self._content
end

return Groupbox
