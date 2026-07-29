--!strict
-- AtomicUI Tooltip System

local Theme = require(script.Parent.Theme)
local Animation = require(script.Parent.Animation)

local Tooltip = {}
Tooltip.__index = Tooltip

local activeTooltip = nil

function Tooltip.Show(text: string, parent: GuiObject, position: Vector2)
	if activeTooltip then
		activeTooltip:Destroy()
	end
	
	local screenGui = game:GetService("Players").LocalPlayer.PlayerGui
	
	local frame = Instance.new("Frame")
	frame.Name = "Tooltip"
	frame.Size = UDim2.fromOffset(0, 32)
	frame.Position = UDim2.fromOffset(position.X, position.Y - 40)
	frame.BackgroundColor3 = Theme.GetCurrent().Surface2
	frame.BackgroundTransparency = 0
	frame.BorderSizePixel = 0
	frame.Visible = false
	frame.Parent = screenGui
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = frame
	
	local shadow = Instance.new("Frame")
	shadow.Size = frame.Size + UDim2.fromOffset(10, 10)
	shadow.Position = UDim2.fromOffset(-5, 5)
	shadow.BackgroundColor3 = Theme.GetCurrent().Shadow
	shadow.BackgroundTransparency = 0.7
	shadow.BorderSizePixel = 0
	shadow.ZIndex = 0
	shadow.Parent = frame
	
	local label = Instance.new("TextLabel")
	label.Name = "Label"
	label.Size = UDim2.new(1, -16, 1, 0)
	label.Position = UDim2.fromOffset(8, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Theme.GetCurrent().Text
	label.TextSize = 13
	label.Font = Enum.Font.Gotham
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = frame
	
	local textBounds = label.TextBounds
	frame.Size = UDim2.fromOffset(textBounds.X + 24, 32)
	shadow.Size = frame.Size + UDim2.fromOffset(10, 10)
	
	frame.Visible = true
	Animation.Play(Animation.FadeIn(frame, 0.15))
	
	activeTooltip = frame
	
	return frame
end

function Tooltip.Hide()
	if activeTooltip then
		Animation.Play(Animation.FadeOut(activeTooltip, 0.15), function()
			activeTooltip:Destroy()
			activeTooltip = nil
		end)
	end
end

function Tooltip.BindToObject(text: string, object: GuiObject)
	local connections = {}
	
	local showConn = object.MouseEnter:Connect(function()
		local pos = object.AbsolutePosition
		Tooltip.Show(text, object, pos)
	end)
	table.insert(connections, showConn)
	
	local hideConn = object.MouseLeave:Connect(function()
		Tooltip.Hide()
	end)
	table.insert(connections, hideConn)
	
	return function()
		for _, conn in connections do
			conn:Disconnect()
		end
	end
end

return Tooltip
