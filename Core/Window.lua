--!strict
-- AtomicUI Window Core

local Theme = require(script.Parent.Theme)
local Utility = require(script.Parent.Utility)
local Animation = require(script.Parent.Animation)
local IconManager = require(script.Parent.IconManager)

local Window = {}
Window.__index = Window

type WindowProps = {
	Title: string,
	Size: Vector2?,
	MinSize: Vector2?,
	MaxSize: Vector2?,
	Resizable: boolean?,
	Draggable: boolean?,
	Acrylic: boolean?,
	Theme: string?,
}

function Window.new(props: WindowProps): table
	local self = setmetatable({}, Window)
	
	self._props = props or {}
	self._connections = {}
	self._children = {}
	self._isOpen = true
	self._isMinimized = false
	self._isMaximized = false
	
	self:_buildWindow()
	self:_setupDrag()
	self:_setupResize()
	
	return self
end

function Window:_buildWindow()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "AtomicUI"
	screenGui.ResetOnSpawn = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.Parent = game:GetService("Players").LocalPlayer.PlayerGui
	
	local main = Instance.new("Frame")
	main.Name = "Main"
	main.Size = UDim2.fromOffset(
		self._props.Size and self._props.Size.X or 800,
		self._props.Size and self._props.Size.Y or 600
	)
	main.Position = UDim2.fromScale(0.5, 0.5)
	main.AnchorPoint = Vector2.new(0.5, 0.5)
	main.BackgroundColor3 = Theme.GetCurrent().Surface
	main.BackgroundTransparency = self._props.Acrylic and 0.3 or 0
	main.BorderSizePixel = 0
	main.ClipsDescendants = true
	main.Parent = screenGui
	
	if self._props.Acrylic then
		local blur = Instance.new("BlurEffect")
		blur.Size = 12
		blur.Parent = screenGui
		local background = Instance.new("Frame")
		background.Size = main.Size
		background.Position = main.Position
		background.AnchorPoint = main.AnchorPoint
		background.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		background.BackgroundTransparency = 0.85
		background.BorderSizePixel = 0
		background.Parent = screenGui
		main:SetAttribute("_acrylicBg", background)
	end
	
	local shadow = Instance.new("Frame")
	shadow.Name = "Shadow"
	shadow.Size = main.Size + UDim2.fromOffset(20, 20)
	shadow.Position = main.Position + UDim2.fromOffset(-10, -10)
	shadow.AnchorPoint = main.AnchorPoint
	shadow.BackgroundColor3 = Theme.GetCurrent().Shadow
	shadow.BackgroundTransparency = 0.7
	shadow.BorderSizePixel = 0
	shadow.ZIndex = 0
	shadow.Parent = screenGui
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = main
	
	local titleBar = Instance.new("Frame")
	titleBar.Name = "TitleBar"
	titleBar.Size = UDim2.new(1, 0, 0, 48)
	titleBar.BackgroundColor3 = Theme.GetCurrent().Surface2
	titleBar.BackgroundTransparency = 0.5
	titleBar.BorderSizePixel = 0
	titleBar.Parent = main
	
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.Size = UDim2.new(1, -100, 1, 0)
	titleLabel.Position = UDim2.fromOffset(16, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = self._props.Title or "Atomic UI"
	titleLabel.TextColor3 = Theme.GetCurrent().Text
	titleLabel.TextSize = 18
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.Parent = titleBar
	
	self:_createWindowButtons(titleBar)
	
	local content = Instance.new("Frame")
	content.Name = "Content"
	content.Size = UDim2.new(1, 0, 1, -48)
	content.Position = UDim2.fromOffset(0, 48)
	content.BackgroundTransparency = 1
	content.Parent = main
	
	self._screenGui = screenGui
	self._main = main
	self._shadow = shadow
	self._content = content
	self._titleBar = titleBar
	self._titleLabel = titleLabel
	self._isDragging = false
end

function Window:_createWindowButtons(parent: Frame)
	local buttons = { "Minimize", "Maximize", "Close" }
	local colors = {
		Minimize = Color3.fromRGB(251, 191, 36),
		Maximize = Color3.fromRGB(52, 211, 153),
		Close = Color3.fromRGB(239, 68, 68),
	}
	
	for i, name in buttons do
		local btn = Instance.new("ImageButton")
		btn.Name = name
		btn.Size = UDim2.fromOffset(32, 32)
		btn.Position = UDim2.new(1, -(i * 36), 0, 8)
		btn.BackgroundColor3 = colors[name]
		btn.BackgroundTransparency = 0.8
		btn.BorderSizePixel = 0
		btn.Image = IconManager.GetIcon(name)
		btn.ImageColor3 = Theme.GetCurrent().Text
		btn.ImageTransparency = 0.3
		btn.Parent = parent
		
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(1, 0)
		corner.Parent = btn
		
		btn.MouseButton1Click:Connect(function()
			if name == "Close" then
				self:Close()
			elseif name == "Minimize" then
				self:Minimize()
			elseif name == "Maximize" then
				self:Maximize()
			end
		end)
	end
end

function Window:_setupDrag()
	local drag = Instance.new("Frame")
	drag.Name = "DragArea"
	drag.Size = UDim2.new(1, -100, 1, 0)
	drag.BackgroundTransparency = 1
	drag.Parent = self._titleBar
	
	local input = game:GetService("UserInputService")
	local isDragging = false
	local dragStart = Vector2.new()
	local startPos = UDim2.new()
	
	drag.InputBegan:Connect(function(inputObj)
		if inputObj.UserInputType == Enum.UserInputType.MouseButton1 then
			isDragging = true
			dragStart = inputObj.Position
			startPos = self._main.Position
		end
	end)
	
	drag.InputEnded:Connect(function(inputObj)
		if inputObj.UserInputType == Enum.UserInputType.MouseButton1 then
			isDragging = false
		end
	end)
	
	input.InputChanged:Connect(function(inputObj)
		if isDragging and inputObj.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = inputObj.Position - dragStart
			self._main.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
			if self._shadow then
				self._shadow.Position = self._main.Position + UDim2.fromOffset(-10, -10)
			end
		end
	end)
end

function Window:_setupResize()
	if not self._props.Resizable then return end
	
	local resize = Instance.new("Frame")
	resize.Name = "ResizeHandle"
	resize.Size = UDim2.fromOffset(16, 16)
	resize.Position = UDim2.new(1, -16, 1, -16)
	resize.BackgroundTransparency = 1
	resize.ZIndex = 999
	resize.Parent = self._main
	
	local input = game:GetService("UserInputService")
	local isResizing = false
	local resizeStart = Vector2.new()
	local startSize = UDim2.new()
	
	resize.InputBegan:Connect(function(inputObj)
		if inputObj.UserInputType == Enum.UserInputType.MouseButton1 then
			isResizing = true
			resizeStart = inputObj.Position
			startSize = self._main.Size
		end
	end)
	
	resize.InputEnded:Connect(function(inputObj)
		if inputObj.UserInputType == Enum.UserInputType.MouseButton1 then
			isResizing = false
		end
	end)
	
	input.InputChanged:Connect(function(inputObj)
		if isResizing and inputObj.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = inputObj.Position - resizeStart
			local newSize = UDim2.fromOffset(
				math.max(startSize.X.Offset + delta.X, self._props.MinSize and self._props.MinSize.X or 400),
				math.max(startSize.Y.Offset + delta.Y, self._props.MinSize and self._props.MinSize.Y or 300)
			)
			self._main.Size = newSize
			if self._shadow then
				self._shadow.Size = newSize + UDim2.fromOffset(20, 20)
			end
			if self._props.Acrylic then
				local bg = self._main:GetAttribute("_acrylicBg")
				if bg then
					bg.Size = newSize
				end
			end
		end
	end)
end

function Window:AddTab(name: string): table
	return nil -- handled by Tab module
end

function Window:Open()
	self._isOpen = true
	self._main.Visible = true
end

function Window:Close()
	self._isOpen = false
	self._main.Visible = false
	for _, conn in self._connections do
		conn:Disconnect()
	end
end

function Window:Minimize()
	self._isMinimized = not self._isMinimized
	self._main.Visible = not self._isMinimized
end

function Window:Maximize()
	self._isMaximized = not self._isMaximized
	if self._isMaximized then
		self._main.Size = UDim2.new(1, 0, 1, 0)
		self._main.Position = UDim2.fromOffset(0, 0)
		self._main.AnchorPoint = Vector2.new(0, 0)
	else
		self._main.Size = self._props.Size and UDim2.fromOffset(self._props.Size.X, self._props.Size.Y) or UDim2.fromOffset(800, 600)
		self._main.Position = UDim2.fromScale(0.5, 0.5)
		self._main.AnchorPoint = Vector2.new(0.5, 0.5)
	end
end

function Window:Notify(message: string, type: string)
	-- handled by Notification module
end

function Window:ShowDialog(options: {})
	-- handled by Dialog module
end

return Window
