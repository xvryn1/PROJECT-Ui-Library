--!strict
-- AtomicUI Dialog System

local Theme = require(script.Parent.Theme)
local Animation = require(script.Parent.Animation)
local Utility = require(script.Parent.Utility)

local Dialog = {}
Dialog.__index = Dialog

type DialogProps = {
	Title: string,
	Message: string,
	Buttons: { { Text: string, Callback: (() -> ())? } },
	Type: string?,
}

local activeDialogs = {}

function Dialog.Show(props: DialogProps)
	local self = setmetatable({}, Dialog)
	self._props = props
	self._connections = {}
	self:_buildDialog()
	self:_show()
	return self
end

function Dialog:_buildDialog()
	local screenGui = game:GetService("Players").LocalPlayer.PlayerGui
	
	local overlay = Instance.new("Frame")
	overlay.Name = "DialogOverlay"
	overlay.Size = UDim2.new(1, 0, 1, 0)
	overlay.BackgroundColor3 = Theme.GetCurrent().Background
	overlay.BackgroundTransparency = 0.6
	overlay.BorderSizePixel = 0
	overlay.Visible = false
	overlay.Parent = screenGui
	
	local container = Instance.new("Frame")
	container.Name = "DialogContainer"
	container.Size = UDim2.fromOffset(400, 0)
	container.Position = UDim2.fromScale(0.5, 0.5)
	container.AnchorPoint = Vector2.new(0.5, 0.5)
	container.BackgroundColor3 = Theme.GetCurrent().Surface
	container.BackgroundTransparency = 0
	container.BorderSizePixel = 0
	container.ClipsDescendants = true
	container.Visible = false
	container.Parent = overlay
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = container
	
	local shadow = Instance.new("Frame")
	shadow.Name = "Shadow"
	shadow.Size = container.Size + UDim2.fromOffset(20, 20)
	shadow.Position = UDim2.fromOffset(-10, -10)
	shadow.AnchorPoint = Vector2.new(0.5, 0.5)
	shadow.BackgroundColor3 = Theme.GetCurrent().Shadow
	shadow.BackgroundTransparency = 0.7
	shadow.BorderSizePixel = 0
	shadow.ZIndex = 0
	shadow.Parent = overlay
	
	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(1, -32, 0, 48)
	title.Position = UDim2.fromOffset(16, 0)
	title.BackgroundTransparency = 1
	title.Text = self._props.Title or "Dialog"
	title.TextColor3 = Theme.GetCurrent().Text
	title.TextSize = 18
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Font = Enum.Font.GothamBold
	title.Parent = container
	
	local message = Instance.new("TextLabel")
	message.Name = "Message"
	message.Size = UDim2.new(1, -32, 0, 0)
	message.Position = UDim2.fromOffset(16, 48)
	message.BackgroundTransparency = 1
	message.Text = self._props.Message or ""
	message.TextColor3 = Theme.GetCurrent().TextSecondary
	message.TextSize = 14
	message.TextWrapped = true
	message.TextXAlignment = Enum.TextXAlignment.Left
	message.Font = Enum.Font.Gotham
	message.AutomaticSize = Enum.AutomaticSize.Y
	message.Parent = container
	
	local buttonsFrame = Instance.new("Frame")
	buttonsFrame.Name = "Buttons"
	buttonsFrame.Size = UDim2.new(1, -32, 0, 48)
	buttonsFrame.Position = UDim2.fromOffset(16, 0)
	buttonsFrame.BackgroundTransparency = 1
	buttonsFrame.Parent = container
	
	local buttonLayout = Instance.new("UIListLayout")
	buttonLayout.FillDirection = Enum.FillDirection.Horizontal
	buttonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	buttonLayout.Padding = UDim.new(0, 8)
	buttonLayout.Parent = buttonsFrame
	
	local buttonPadding = Instance.new("UIPadding")
	buttonPadding.PaddingTop = UDim.new(0, 8)
	buttonPadding.PaddingBottom = UDim.new(0, 8)
	buttonPadding.Parent = buttonsFrame
	
	local totalHeight = 48 + message.AbsoluteSize.Y + 56
	container.Size = UDim2.fromOffset(400, totalHeight)
	buttonsFrame.Position = UDim2.fromOffset(16, totalHeight - 56)
	
	for _, btnData in self._props.Buttons do
		local btn = Instance.new("TextButton")
		btn.Name = "Button_" .. btnData.Text
		btn.Size = UDim2.fromOffset(80, 32)
		btn.BackgroundColor3 = Theme.GetCurrent().Primary
		btn.BackgroundTransparency = 0
		btn.BorderSizePixel = 0
		btn.Text = btnData.Text
		btn.TextColor3 = Theme.GetCurrent().Text
		btn.TextSize = 14
		btn.Font = Enum.Font.GothamSemibold
		btn.Parent = buttonsFrame
		
		local btnCorner = Instance.new("UICorner")
		btnCorner.CornerRadius = UDim.new(0, 6)
		btnCorner.Parent = btn
		
		btn.MouseButton1Click:Connect(function()
			if btnData.Callback then
				btnData.Callback()
			end
			self:_close()
		end)
	end
	
	self._overlay = overlay
	self._container = container
	self._shadow = shadow
end

function Dialog:_show()
	self._overlay.Visible = true
	self._container.Visible = true
	Animation.Play(Animation.FadeIn(self._overlay, 0.2))
	Animation.Play(Animation.Scale(self._container, 1, 0.3))
end

function Dialog:_close()
	Animation.Play(Animation.FadeOut(self._overlay, 0.2), function()
		self._overlay:Destroy()
	end)
	Animation.Play(Animation.Scale(self._container, 0.8, 0.2), function()
		self._container:Destroy()
	end)
end

return Dialog
