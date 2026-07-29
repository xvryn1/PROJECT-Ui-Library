--!strict
-- AtomicUI Separator Component

local Theme = require(script.Parent.Parent.Theme)

local Separator = {}
Separator.__index = Separator

type SeparatorProps = {
	Parent: GuiObject,
}

function Separator.new(props: SeparatorProps): table
	local self = setmetatable({}, Separator)
	self._props = props
	self._connections = {}
	
	self:_buildSeparator()
	
	return self
end

function Separator:_buildSeparator()
	local sep = Instance.new("Frame")
	sep.Name = "Separator"
	sep.Size = UDim2.new(1, 0, 0, 1)
	sep.BackgroundColor3 = Theme.GetCurrent().Border
	sep.BorderSizePixel = 0
	sep.Parent = self._props.Parent
	
	self._sep = sep
end

return Separator
