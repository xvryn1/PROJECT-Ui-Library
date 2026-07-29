--!strict
-- AtomicUI Animation Engine

local TweenService = game:GetService("TweenService")

local Animation = {}
Animation.__index = Animation

type TweenSpec = {
	Duration: number?,
	EasingStyle: Enum.EasingStyle?,
	EasingDirection: Enum.EasingDirection?,
	RepeatCount: number?,
	Reverses: boolean?,
	DelayTime: number?,
}

local function buildTweenInfo(spec: TweenSpec?): TweenInfo
	local duration = if spec and spec.Duration then spec.Duration else 0.3
	local easingStyle = if spec and spec.EasingStyle then spec.EasingStyle else Enum.EasingStyle.Quad
	local easingDirection = if spec and spec.EasingDirection then spec.EasingDirection else Enum.EasingDirection.Out
	local repeatCount = if spec and spec.RepeatCount then spec.RepeatCount else 0
	local reverses = if spec and spec.Reverses then spec.Reverses else false
	local delayTime = if spec and spec.DelayTime then spec.DelayTime else 0
	return TweenInfo.new(duration, easingStyle, easingDirection, repeatCount, reverses, delayTime)
end

function Animation.Create(instance: Instance, properties: { [string]: any }, spec: TweenSpec?): Tween
	assert(typeof(instance) == "Instance", "Animation.Create: instance must be Instance")
	assert(type(properties) == "table", "Animation.Create: properties must be table")
	local info = buildTweenInfo(spec)
	return TweenService:Create(instance, info, properties)
end

function Animation.Play(tween: Tween, onComplete: (() -> ())?): () -> ()
	assert(typeof(tween) == "Tween", "Animation.Play: tween must be Tween")
	local conn: RBXScriptConnection?
	local called = false
	if onComplete then
		conn = tween.Completed:Connect(function(...)
			if called then return end
			called = true
			task.spawn(onComplete)
			if conn then
				conn:Disconnect()
			end
		end)
	end
	tween:Play()
	return function()
		if conn and conn.Connected then
			conn:Disconnect()
		end
	end
end

function Animation.Stop(tween: Tween)
	assert(typeof(tween) == "Tween", "Animation.Stop: tween must be Tween")
	tween:Cancel()
end

local function isPropertyTweenable(instance: Instance, property: string): boolean
	local ok = pcall(function()
		local _ = (instance :: any)[property]
	end)
	return ok
end

function Animation.FadeIn(gui: GuiObject, duration: number?): { Tween }?
	assert(gui and gui:IsA("GuiObject"), "Animation.FadeIn requires GuiObject")
	local d = duration or 0.25
	local tweens: { Tween } = {}

	if gui.Visible == false then
		gui.Visible = true
	end

	if isPropertyTweenable(gui, "BackgroundTransparency") then
		table.insert(tweens, Animation.Create(gui, { BackgroundTransparency = 0 }, { Duration = d }))
	end
	if gui:IsA("ImageLabel") or gui:IsA("ImageButton") then
		if isPropertyTweenable(gui, "ImageTransparency") then
			table.insert(tweens, Animation.Create(gui, { ImageTransparency = 0 }, { Duration = d }))
		end
	end
	for _, desc in ipairs(gui:GetDescendants()) do
		if desc:IsA("TextLabel") or desc:IsA("TextButton") or desc:IsA("TextBox") then
			if isPropertyTweenable(desc, "TextTransparency") then
				table.insert(tweens, Animation.Create(desc, { TextTransparency = 0 }, { Duration = d }))
			end
		elseif desc:IsA("ImageLabel") or desc:IsA("ImageButton") then
			if isPropertyTweenable(desc, "ImageTransparency") then
				table.insert(tweens, Animation.Create(desc, { ImageTransparency = 0 }, { Duration = d }))
			end
		end
	end

	for _, t in ipairs(tweens) do
		Animation.Play(t)
	end
	return tweens
end

function Animation.FadeOut(gui: GuiObject, duration: number?): { Tween }?
	assert(gui and gui:IsA("GuiObject"), "Animation.FadeOut requires GuiObject")
	local d = duration or 0.25
	local tweens: { Tween } = {}

	if isPropertyTweenable(gui, "BackgroundTransparency") then
		table.insert(tweens, Animation.Create(gui, { BackgroundTransparency = 1 }, { Duration = d }))
	end
	if gui:IsA("ImageLabel") or gui:IsA("ImageButton") then
		if isPropertyTweenable(gui, "ImageTransparency") then
			table.insert(tweens, Animation.Create(gui, { ImageTransparency = 1 }, { Duration = d }))
		end
	end
	for _, desc in ipairs(gui:GetDescendants()) do
		if desc:IsA("TextLabel") or desc:IsA("TextButton") or desc:IsA("TextBox") then
			if isPropertyTweenable(desc, "TextTransparency") then
				table.insert(tweens, Animation.Create(desc, { TextTransparency = 1 }, { Duration = d }))
			end
		elseif desc:IsA("ImageLabel") or desc:IsA("ImageButton") then
			if isPropertyTweenable(desc, "ImageTransparency") then
				table.insert(tweens, Animation.Create(desc, { ImageTransparency = 1 }, { Duration = d }))
			end
		end
	end

	local remaining = #tweens
	if remaining == 0 then
		gui.Visible = false
		return {}
	end

	for _, t in ipairs(tweens) do
		Animation.Play(t, function()
			remaining = remaining - 1
			if remaining <= 0 then
				if gui and gui.Parent then
					gui.Visible = false
				end
			end
		end)
	end
	return tweens
end

local function safeGetSizeOffsets(gui: GuiObject): Vector2
	local abs = gui.AbsoluteSize
	if abs.X > 0 and abs.Y > 0 then
		return abs
	end
	local size = gui.Size
	local x = 0
	local y = 0
	if typeof(size) == "UDim2" then
		x = size.X.Offset
		y = size.Y.Offset
	end
	if x <= 0 then x = 100 end
	if y <= 0 then y = 100 end
	return Vector2.new(x, y)
end

function Animation.Scale(gui: GuiObject, scale: number, duration: number?): Tween?
	assert(gui and gui:IsA("GuiObject"), "Animation.Scale requires GuiObject")
	assert(type(scale) == "number" and scale > 0, "scale must be positive number")
	local d = duration or 0.2
	local abs = safeGetSizeOffsets(gui)
	local newW = math.max(1, math.floor(abs.X * scale + 0.5))
	local newH = math.max(1, math.floor(abs.Y * scale + 0.5))
	local tween = Animation.Create(gui, { Size = UDim2.fromOffset(newW, newH) }, { Duration = d })
	Animation.Play(tween)
	return tween
end

function Animation.Slide(gui: GuiObject, position: UDim2, duration: number?): Tween
	assert(gui and gui:IsA("GuiObject"), "Animation.Slide requires GuiObject")
	assert(typeof(position) == "UDim2", "position must be UDim2")
	local d = duration or 0.25
	local tween = Animation.Create(gui, { Position = position }, { Duration = d })
	Animation.Play(tween)
	return tween
end

function Animation.Ripple(button: GuiButton, duration: number?): Tween?
	assert(button and (button:IsA("TextButton") or button:IsA("ImageButton")), "Ripple requires a Button")
	local d = duration or 0.6
	local ripple = Instance.new("Frame")
	ripple.Name = "Atomic_Ripple"
	ripple.BackgroundColor3 = Color3.new(1, 1, 1)
	ripple.BackgroundTransparency = 0.6
	ripple.Size = UDim2.fromOffset(0, 0)
	ripple.Position = UDim2.fromScale(0.5, 0.5)
	ripple.AnchorPoint = Vector2.new(0.5, 0.5)
	ripple.BorderSizePixel = 0
	ripple.ZIndex = (button.ZIndex or 1) + 50
	ripple.Parent = button
	local maxSize = math.max(1, math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 0.8)
	local tween = Animation.Create(ripple, { Size = UDim2.fromOffset(maxSize, maxSize), BackgroundTransparency = 1 }, { Duration = d, EasingStyle = Enum.EasingStyle.Quad })
	Animation.Play(tween, function()
		if ripple and ripple.Parent then
			ripple:Destroy()
		end
	end)
	return tween
end

return Animation