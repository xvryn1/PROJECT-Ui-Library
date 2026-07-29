--!strict
-- AtomicUI Tab System

local Theme = require(script.Parent.Theme)
local Utility = require(script.Parent.Utility)

local Tab = {}
Tab.__index = Tab

type TabProps = {
	Name: string,
	Icon: string?,
	Parent: any,
}

function Tab.new(props: TabProps): table
	local self = setmetatable({}, Tab)
	
	self._name = props.Name
	self._icon = props.Icon
	self._parent = props.Parent
	self._sections = {}
	self._elements = {}
	
	self:_buildTab()
	
	return self
end

function Tab:_buildTab()
	local container = Instance.new("ScrollingFrame")
	container.Name = "Tab_" .. self._name
	container.Size = UDim2.new(1, 0, 1, 0)
	container.BackgroundTransparency = 1
	container.BorderSizePixel = 0
	container.ScrollBarThickness = 4
	container.ScrollBarImageColor3 = Theme.GetCurrent().Primary
	container.VerticalScrollBarInset = Enum.ScrollBarInset.Always
	container.Parent = self._parent
	
	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 8)
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout.Parent = container
	
	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 16)
	padding.PaddingBottom = UDim.new(0, 16)
	padding.PaddingLeft = UDim.new(0, 16)
	padding.PaddingRight = UDim.new(0, 16)
	padding.Parent = container
	
	self._container = container
	self._layout = layout
end

function Tab:AddSection(name: string): table
	return nil -- handled by Section module
end

function Tab:AddElement(element: table)
	table.insert(self._elements, element)
end

function Tab:GetContainer(): ScrollingFrame
	return self._container
end

return Tab
