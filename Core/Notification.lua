--!strict
-- AtomicUI Notification System

local Theme = require(script.Parent.Theme)
local Animation = require(script.Parent.Animation)

local Notification = {}
Notification.__index = Notification

type NotificationProps = {
	Message: string,
	Type: string?,
	Duration: number?,
}

local queue = {}
local isShowing = false

function Notification.Show(props: NotificationProps)
	local message = props.Message
	local type = props.Type or "info"
	local duration = props.Duration or 3
	
	table.insert(queue, { message = message, type = type, duration = duration })
	
	if not isShowing then
		Notification:_processQueue()
	end
end

function Notification:_processQueue()
	if #queue == 0 then
		isShowing = false
		return
	end
	
	isShowing = true
	local data = table.remove(queue, 1)
	
	local notification = Notification:_createNotification(data.message, data.type)
	
	task.wait(data.duration)
	
	Animation.Play(Animation.FadeOut(notification, 0.3), function()
		notification:Destroy()
		Notification:_processQueue()
	end)
end

function Notification:_createNotification(message: string, type: string): Frame
	local screen = Instance.new("Frame")
	screen.Name = "Notification"
	screen.Size = UDim2.fromOffset(360, 64)
	screen.Position = UDim2.new(1, -380, 0, 20)
	screen.BackgroundColor3 = Theme.GetCurrent().Surface
	screen.BackgroundTransparency = 1
	screen.BorderSizePixel = 0
	screen.Parent = game:GetService("Players").LocalPlayer.PlayerGui
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = screen
	
	local shadow = Instance.new("Frame")
	shadow.Size = screen.Size + UDim2.fromOffset(10, 10)
	shadow.Position = UDim2.fromOffset(-5, 5)
	shadow.BackgroundColor3 = Theme.GetCurrent().Shadow
	shadow.BackgroundTransparency = 0.7
	shadow.BorderSizePixel = 0
	shadow.ZIndex = 0
	shadow.Parent = screen
	
	local text = Instance.new("TextLabel")
	text.Size = UDim2.new(1, -32, 1, 0)
	text.Position = UDim2.fromOffset(16, 0)
	text.BackgroundTransparency = 1
	text.Text = message
	text.TextColor3 = Theme.GetCurrent().Text
	text.TextSize = 14
	text.TextWrapped = true
	text.Font = Enum.Font.Gotham
	text.Parent = screen
	
	local colors = {
		info = Theme.GetCurrent().Primary,
		success = Theme.GetCurrent().Success,
		warning = Theme.GetCurrent().Warning,
		error = Theme.GetCurrent().Danger,
	}
	
	local accent = Instance.new("Frame")
	accent.Size = UDim2.fromOffset(4, 1)
	accent.BackgroundColor3 = colors[type] or Theme.GetCurrent().Primary
	accent.BorderSizePixel = 0
	accent.Parent = screen
	
	Animation.Play(Animation.FadeIn(screen, 0.3))
	
	return screen
end

return Notification
