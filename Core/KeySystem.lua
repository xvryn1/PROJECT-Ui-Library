--!strict
-- AtomicUI Key System

local KeySystem = {}
KeySystem.__index = KeySystem

type KeySystemProps = {
	Key: string,
	Callback: (success: boolean) -> (),
}

local keys = {}

function KeySystem.Validate(props: KeySystemProps)
	local input = game:GetService("UserInputService")
	
	local dialog = Instance.new("Frame")
	dialog.Name = "KeySystem"
	dialog.Size = UDim2.fromOffset(400, 200)
	dialog.Position = UDim2.fromScale(0.5, 0.5)
	dialog.AnchorPoint = Vector2.new(0.5, 0.5)
	dialog.BackgroundColor3 = require(script.Parent.Theme).GetCurrent().Surface
	dialog.BorderSizePixel = 0
	dialog.Parent = game:GetService("Players").LocalPlayer.PlayerGui
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = dialog
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -32, 0, 30)
	label.Position = UDim2.fromOffset(16, 16)
	label.BackgroundTransparency = 1
	label.Text = "Enter Key"
	label.TextColor3 = require(script.Parent.Theme).GetCurrent().Text
	label.TextSize = 20
	label.Font = Enum.Font.GothamBold
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = dialog
	
	local inputBox = Instance.new("TextBox")
	inputBox.Size = UDim2.new(1, -32, 0, 40)
	inputBox.Position = UDim2.fromOffset(16, 56)
	inputBox.BackgroundColor3 = require(script.Parent.Theme).GetCurrent().Surface2
	inputBox.BorderSizePixel = 0
	inputBox.Text = ""
	inputBox.TextColor3 = require(script.Parent.Theme).GetCurrent().Text
	inputBox.TextSize = 16
	inputBox.Font = Enum.Font.Gotham
	inputBox.PlaceholderText = "Enter key..."
	inputBox.PlaceholderColor3 = require(script.Parent.Theme).GetCurrent().TextMuted
	inputBox.Parent = dialog
	
	local inputCorner = Instance.new("UICorner")
	inputCorner.CornerRadius = UDim.new(0, 8)
	inputCorner.Parent = inputBox
	
	local submit = Instance.new("TextButton")
	submit.Size = UDim2.fromOffset(120, 36)
	submit.Position = UDim2.new(1, -136, 1, -52)
	submit.BackgroundColor3 = require(script.Parent.Theme).GetCurrent().Primary
	submit.BorderSizePixel = 0
	submit.Text = "Submit"
	submit.TextColor3 = require(script.Parent.Theme).GetCurrent().Text
	submit.TextSize = 16
	submit.Font = Enum.Font.GothamSemibold
	submit.Parent = dialog
	
	local submitCorner = Instance.new("UICorner")
	submitCorner.CornerRadius = UDim.new(0, 6)
	submitCorner.Parent = submit
	
	submit.MouseButton1Click:Connect(function()
		local success = inputBox.Text == props.Key
		props.Callback(success)
		if success then
			keys[inputBox.Text] = true
		end
		dialog:Destroy()
	end)
	
	inputBox.FocusLost:Connect(function(enterPressed)
		if enterPressed then
			submit.MouseButton1Click:Fire()
		end
	end)
end

function KeySystem.IsValid(key: string): boolean
	return keys[key] == true
end

function KeySystem.RegisterKey(key: string)
	keys[key] = true
end

return KeySystem
