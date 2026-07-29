--!strict
-- AtomicUI Card Component

local Theme = require(script.Parent.Parent.Theme)

local Card = {}
Card.__index = Card

type CardProps = {
	Title: string?,
	Description: string?,
	Parent: GuiObject,
}

function Card.new(props: CardProps): table
	local self = setmetatable({}, Card)
	self._props = props
	self._connections = {}
	
	self:_buildCard()
	
	return self
end

function Card:_buildCard()
	local container = Instance.new("Frame")
	container.Name = "Card"
	container.Size = UDim2.new(1, 0, 0, 0)
	container.BackgroundColor3 = Theme.GetCurrent().Surface
	container.BorderSizePixel = 0
	container.AutomaticSize = Enum.AutomaticSize.Y
	container.Parent = self._props.Parent
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = container
	
	local shadow = Instance.new("Frame")
	shadow.Name = "Shadow"
	shadow.Size = container.Size + UDim2.fromOffset(10, 10)
	shadow.Position = UDim2.fromOffset(-5, 5)
	shadow.BackgroundColor3 = Theme.GetCurrent().Shadow
	shadow.BackgroundTransparency = 0.7
	shadow.BorderSizePixel = 0
	shadow.ZIndex = 0
	shadow.Parent = container
	
	local content = Instance.new("Frame")
	content.Name = "Content"
	content.Size = UDim2.new(1, -32, 0, 0)
	content.Position = UDim2.fromOffset(16, 16)
	content.BackgroundTransparency = 1
	content.AutomaticSize = Enum.AutomaticSize.Y
	content.Parent = container
	
	if self._props.Title then
		local title = Instance.new("TextLabel")
		title.Size = UDim2.new(1, 0, 0, 28)
		title.BackgroundTransparency = 1
		title.Text = self._props.Title
		title.TextColor3 = Theme.GetCurrent().Text
		title.TextSize = 18
		title.TextXAlignment = Enum.TextXAlignment.Left
		title.Font = Enum.Font.GothamBold
		title.Parent = content
	end
	
	if self._props.Description then
		local desc = Instance.new("TextLabel")
		desc.Size = UDim2.new(1, 0, 0, 0)
		desc.BackgroundTransparency = 1
		desc.Text = self._props.Description
		desc.TextColor3 = Theme.GetCurrent().TextSecondary
		desc.TextSize = 14
		desc.TextWrapped = true
		desc.TextXAlignment = Enum.TextXAlignment.Left
		desc.Font = Enum.Font.Gotham
		desc.AutomaticSize = Enum.AutomaticSize.Y
		desc.Parent = content
	end
	
	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 8)
	layout.Parent = content
	
	self._container = container
	self._content = content
	self._shadow = shadow
end

function Card:GetContainer(): Frame
	return self._content
end

return Card
