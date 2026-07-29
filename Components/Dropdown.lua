--!strict
-- AtomicUI Dropdown Component

local Theme = require(script.Parent.Parent.Theme)
local Animation = require(script.Parent.Parent.Animation)

local Dropdown = {}
Dropdown.__index = Dropdown

type DropdownProps = {
	Label: string,
	Options: { string },
	Default: string?,
	OnChanged: ((value: string) -> ())?,
	Parent: GuiObject,
}

function Dropdown.new(props: DropdownProps): table
	local self = setmetatable({}, Dropdown)
	self._props = props
	self._options = props.Options or {}
	self._selected = props.Default or self._options[1] or ""
	self._isOpen = false
	self._connections = {}
	
	self:_buildDropdown()
	
	return self
end

function Dropdown:_buildDropdown()
	local container = Instance.new("Frame")
	container.Name = "Dropdown_" .. self._props.Label
	container.Size = UDim2.new(1, 0, 0, 60)
	container.BackgroundTransparency = 1
	container.Parent = self._props.Parent
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 20)
	label.BackgroundTransparency = 1
	label.Text = self._props.Label
	label.TextColor3 = Theme.GetCurrent().Text
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Font = Enum.Font.Gotham
	label.Parent = container
	
	local main = Instance.new("Frame")
	main.Name = "Main"
	main.Size = UDim2.new(1, 0, 0, 36)
	main.Position = UDim2.fromOffset(0, 24)
	main.BackgroundColor3 = Theme.GetCurrent().Surface2
	main.BorderSizePixel = 0
	main.Parent = container
	
	local mainCorner = Instance.new("UICorner")
	mainCorner.CornerRadius = UDim.new(0, 8)
	mainCorner.Parent = main
	
	local text = Instance.new("TextLabel")
	text.Size = UDim2.new(1, -32, 1, 0)
	text.Position = UDim2.fromOffset(12, 0)
	text.BackgroundTransparency = 1
	text.Text = self._selected
	text.TextColor3 = Theme.GetCurrent().Text
	text.TextSize = 14
	text.TextXAlignment = Enum.TextXAlignment.Left
	text.Font = Enum.Font.Gotham
	text.Parent = main
	
	local arrow = Instance.new("ImageLabel")
	arrow.Size = UDim2.fromOffset(16, 16)
	arrow.Position = UDim2.new(1, -24, 0.5, -8)
	arrow.BackgroundTransparency = 1
	arrow.Image = "rbxassetid://12345692"
	arrow.ImageColor3 = Theme.GetCurrent().TextSecondary
	arrow.Parent = main
	
	local dropdown = Instance.new("Frame")
	dropdown.Name = "Dropdown"
	dropdown.Size = UDim2.new(1, 0, 0, 0)
	dropdown.Position = UDim2.fromOffset(0, 36)
	dropdown.BackgroundColor3 = Theme.GetCurrent().Surface
	dropdown.BackgroundTransparency = 0
	dropdown.BorderSizePixel = 0
	dropdown.Visible = false
	dropdown.ClipsDescendants = true
	dropdown.Parent = container
	
	local dropdownCorner = Instance.new("UICorner")
	dropdownCorner.CornerRadius = UDim.new(0, 8)
	dropdownCorner.Parent = dropdown
	
	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 2)
	listLayout.Parent = dropdown
	
	for _, option in self._options do
		local btn = Instance.new("TextButton")
		btn.Name = "Option_" .. option
		btn.Size = UDim2.new(1, 0, 0, 32)
		btn.BackgroundTransparency = 1
		btn.Text = option
		btn.TextColor3 = Theme.GetCurrent().Text
		btn.TextSize = 14
		btn.TextXAlignment = Enum.TextXAlignment.Left
		btn.Font = Enum.Font.Gotham
		btn.Parent = dropdown
		
		btn.MouseButton1Click:Connect(function()
			self._selected = option
			text.Text = option
			self:Close()
			if self._props.OnChanged then
				self._props.OnChanged(option)
			end
		end)
		
		btn.MouseEnter:Connect(function()
			btn.BackgroundTransparency = 0.9
		end)
		btn.MouseLeave:Connect(function()
			btn.BackgroundTransparency = 1
		end)
	end
	
	local btn = Instance.new("ImageButton")
	btn.Size = UDim2.new(1, 0, 1, 0)
	btn.BackgroundTransparency = 1
	btn.Parent = main
	
	btn.MouseButton1Click:Connect(function()
		if self._isOpen then
			self:Close()
		else
			self:Open()
		end
	end)
	
	self._container = container
	self._dropdown = dropdown
	self._arrow = arrow
end

function Dropdown:Open()
	self._isOpen = true
	self._dropdown.Visible = true
	local height = #self._options * 34 + 8
	Animation.Play(Animation.Create(self._dropdown, {
		Size = UDim2.fromOffset(0, height),
	}, { Duration = 0.2 }))
	Animation.Play(Animation.Create(self._arrow, {
		Rotation = 180,
	}, { Duration = 0.2 }))
end

function Dropdown:Close()
	self._isOpen = false
	Animation.Play(Animation.Create(self._dropdown, {
		Size = UDim2.fromOffset(0, 0),
	}, { Duration = 0.2 }), function()
		self._dropdown.Visible = false
	end)
	Animation.Play(Animation.Create(self._arrow, {
		Rotation = 0,
	}, { Duration = 0.2 }))
end

function Dropdown:GetValue(): string
	return self._selected
end

return Dropdown
