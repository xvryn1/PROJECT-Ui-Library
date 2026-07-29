--!strict
-- AtomicUI Acrylic Effect

local Acrylic = {}
Acrylic.__index = Acrylic

function Acrylic.Apply(frame: Frame, blurSize: number?, tintColor: Color3?, tintTransparency: number?)
	blurSize = blurSize or 12
	tintColor = tintColor or Color3.fromRGB(255, 255, 255)
	tintTransparency = tintTransparency or 0.85
	
	local screenGui = frame.Parent
	while screenGui and not screenGui:IsA("ScreenGui") do
		screenGui = screenGui.Parent
	end
	
	if not screenGui then return end
	
	local blur = Instance.new("BlurEffect")
	blur.Size = blurSize
	blur.Parent = screenGui
	
	local tint = Instance.new("Frame")
	tint.Name = "AcrylicTint"
	tint.Size = frame.Size
	tint.Position = frame.Position
	tint.AnchorPoint = frame.AnchorPoint
	tint.BackgroundColor3 = tintColor
	tint.BackgroundTransparency = tintTransparency
	tint.BorderSizePixel = 0
	tint.Parent = screenGui
	
	frame.BackgroundTransparency = 0.3
	
	return function()
		blur:Destroy()
		tint:Destroy()
	end
end

function Acrylic.Remove(frame: Frame)
	local screenGui = frame.Parent
	while screenGui and not screenGui:IsA("ScreenGui") do
		screenGui = screenGui.Parent
	end
	
	if screenGui then
		for _, child in screenGui:GetChildren() do
			if child:IsA("BlurEffect") then
				child:Destroy()
			end
			if child:IsA("Frame") and child.Name == "AcrylicTint" then
				child:Destroy()
			end
		end
	end
	
	frame.BackgroundTransparency = 0
end

return Acrylic
