--!strict
-- AtomicUI ColorPicker Component

local Theme = require(script.Parent.Parent.Theme)
local Utility = require(script.Parent.Parent.Utility)

local ColorPicker = {}
ColorPicker.__index = ColorPicker

type ColorPickerProps = {
	Label: string,
	Default: Color3?,
	OnChanged: ((color: Color3) -> ())?,
	Parent: GuiObject,
}

function ColorPicker.new(props: ColorPickerProps): table
	local self = setmetatable({}, ColorPicker)
	self._props = props
	self._color = props.Default or Color3.new(1, 0, 0)
	self._connections = {}
	
	self:_buildColorPicker()
	
	return self
end

function ColorPicker:_buildColorPicker()
	local container = Instance.new("Frame")
	container.Name = "ColorPicker_" .. self._props.Label
	container.Size = UDim2.new(1, 0, 0, 48)
	container.BackgroundTransparency = 1
	container.Parent = self._props.Parent
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -60, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = self._props.Label
	label.TextColor3 = Theme.GetCurrent().Text
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Font = Enum.Font.Gotham
	label.Parent = container
	
	local preview = Instance.new("Frame")
	preview.Name = "Preview"
	preview.Size = UDim2.fromOffset(40, 40)
	preview.Position = UDim2.new(1, -40, 0.5, -20)
	preview.BackgroundColor3 = self._color
	preview.BorderSizePixel = 0
	preview.Parent = container
	
	local previewCorner = Instance.new("UICorner")
	previewCorner.CornerRadius = UDim.new(0, 8)
	previewCorner.Parent = preview
	
	local btn = Instance.new("ImageButton")
	btn.Size = UDim2.new(1, 0, 1, 0)
	btn.BackgroundTransparency = 1
	btn.Parent = preview
	
	btn.MouseButton1Click:Connect(function()
		self:OpenPicker()
	end)
	
	self._container = container
	self._preview = preview
end

function ColorPicker:OpenPicker()
	local picker = Instance.new("Frame")
	picker.Name = "ColorPickerModal"
	picker.Size = UDim2.fromOffset(300, 340)
	picker.Position = UDim2.fromScale(0.5, 0.5)
	picker.AnchorPoint = Vector2.new(0.5, 0.5)
	picker.BackgroundColor3 = Theme.GetCurrent().Surface
	picker.BorderSizePixel = 0
	picker.Parent = game:GetService("Players").LocalPlayer.PlayerGui
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = picker
	
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -32, 0, 40)
	title.Position = UDim2.fromOffset(16, 8)
	title.BackgroundTransparency = 1
	title.Text = "Choose Color"
	title.TextColor3 = Theme.GetCurrent().Text
	title.TextSize = 18
	title.Font = Enum.Font.GothamBold
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = picker
	
	local colorWheel = Instance.new("Frame")
	colorWheel.Size = UDim2.fromOffset(200, 200)
	colorWheel.Position = UDim2.fromOffset(50, 52)
	colorWheel.BackgroundColor3 = Color3.new(1, 0, 0)
	colorWheel.BorderSizePixel = 0
	colorWheel.Parent = picker
	
	local wheelCorner = Instance.new("UICorner")
	wheelCorner.CornerRadius = UDim.new(1, 0)
	wheelCorner.Parent = colorWheel
	
	local hue = Instance.new("Frame")
	hue.Size = UDim2.fromOffset(16, 200)
	hue.Position = UDim2.new(1, -50, 0, 52)
	hue.BackgroundColor3 = Color3.new(1, 0, 0)
	hue.BorderSizePixel = 0
	hue.Parent = picker
	
	local hueCorner = Instance.new("UICorner")
	hueCorner.CornerRadius = UDim.new(0, 8)
	hueCorner.Parent = hue
	
	-- Simplified color picker - full implementation would have gradient image labels
	-- For production, use ImageLabel with gradient textures
	
	local close = Instance.new("TextButton")
	close.Size = UDim2.fromOffset(80, 32)
	close.Position = UDim2.new(0.5, -40, 1, -44)
	close.BackgroundColor3 = Theme.GetCurrent().Primary
	close.BorderSizePixel = 0
	close.Text = "Confirm"
	close.TextColor3 = Theme.GetCurrent().Text
	close.TextSize = 14
	close.Font = Enum.Font.GothamSemibold
	close.Parent = picker
	
	local closeCorner = Instance.new("UICorner")
	closeCorner.CornerRadius = UDim.new(0, 6)
	closeCorner.Parent = close
	
	close.MouseButton1Click:Connect(function()
		local color = colorWheel.BackgroundColor3
		self._color = color
		self._preview.BackgroundColor3 = color
		if self._props.OnChanged then
			self._props.OnChanged(color)
		end
		picker:Destroy()
	end)
end

function ColorPicker:GetColor(): Color3
	return self._color
end

return ColorPicker
