--!strict
-- AtomicUI Canvas Component

local Theme = require(script.Parent.Parent.Theme)

local Canvas = {}
Canvas.__index = Canvas

type CanvasProps = {
	Width: number?,
	Height: number?,
	Background: Color3?,
	Parent: GuiObject,
}

function Canvas.new(props: CanvasProps): table
	local self = setmetatable({}, Canvas)
	self._props = props
	self._connections = {}
	self._objects = {}
	
	self:_buildCanvas()
	
	return self
end

function Canvas:_buildCanvas()
	local frame = Instance.new("Frame")
	frame.Name = "Canvas"
	frame.Size = UDim2.fromOffset(
		self._props.Width or 400,
		self._props.Height or 300
	)
	frame.BackgroundColor3 = self._props.Background or Theme.GetCurrent().Surface2
	frame.BackgroundTransparency = 0.5
	frame.BorderSizePixel = 0
	frame.ClipsDescendants = true
	frame.Parent = self._props.Parent
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = frame
	
	self._frame = frame
end

function Canvas:AddObject(object: GuiObject)
	object.Parent = self._frame
	table.insert(self._objects, object)
end

function Canvas:Clear()
	for _, obj in self._objects do
		obj:Destroy()
	end
	self._objects = {}
end

function Canvas:GetFrame(): Frame
	return self._frame
end

return Canvas
