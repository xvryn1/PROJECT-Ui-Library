--!strict
-- AtomicUI Button Component

local Theme = require(script.Parent.Parent.Theme)
local Animation = require(script.Parent.Parent.Animation)
local Tooltip = require(script.Parent.Parent.Core.Tooltip)

local Button = {}
Button.__index = Button

type ButtonProps = {
	Text: string,
	Size: UDim2?,
	Position: UDim2?,
	Type: string?,
	Icon: string?,
	Tooltip: string?,
	OnClick: (() -> ())?,
	Parent: GuiObject,
}

function Button.new(props: ButtonProps): table
	local self = setmetatable({}, Button)
	self._props = props
	self._connections = {}
	
	self:_buildButton()
	
	return self
end

function Button:_buildButton()
	local btn = Instance.new("TextButton")
	btn.Name = "Button_" .. self._props.Text
	btn.Size = self._props.Size or UDim2.fromOffset(120, 36)
	btn.Position = self._props.Position or UDim2.fromOffset(0, 0)
	btn.BackgroundColor3 = Theme.GetCurrent().Primary
	btn.BackgroundTransparency = 0
	btn.BorderSizePixel = 0
	btn.Text = self._props.Text
	btn.TextColor3 = Theme.GetCurrent().Text
	btn.TextSize = 14
	btn.Font = Enum.Font.GothamSemibold
	btn.Parent = self._props.Parent
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = btn
	
	local shadow = Instance.new("Frame")
	shadow.Name = "Shadow"
	shadow.Size = btn.Size + UDim2.fromOffset(8, 8)
	shadow.Position = UDim2.fromOffset(-4, 4)
	shadow.BackgroundColor3 = Theme.GetCurrent().Shadow
	shadow.BackgroundTransparency = 0.6
	shadow.BorderSizePixel = 0
	shadow.ZIndex = 0
	shadow.Parent = btn
	
	if self._props.Tooltip then
		Tooltip.BindToObject(self._props.Tooltip, btn)
	end
	
	btn.MouseButton1Click:Connect(function()
		if self._props.OnClick then
			self._props.OnClick()
		end
	end)
	
	btn.MouseEnter:Connect(function()
		local tween = Animation.Create(btn, {
			BackgroundColor3 = Theme.GetCurrent().PrimaryLight,
		}, { Duration = 0.15 })
		tween:Play()
	end)
	
	btn.MouseLeave:Connect(function()
		local tween = Animation.Create(btn, {
			BackgroundColor3 = Theme.GetCurrent().Primary,
		}, { Duration = 0.15 })
		tween:Play()
	end)
	
	self._btn = btn
	self._shadow = shadow
end

function Button:SetText(text: string)
	self._btn.Text = text
end

function Button:SetEnabled(enabled: boolean)
	self._btn.Active = enabled
	self._btn.BackgroundTransparency = enabled and 0 or 0.5
end

function Button:Destroy()
	for _, conn in self._connections do
		conn:Disconnect()
	end
	self._btn:Destroy()
end

return Button
