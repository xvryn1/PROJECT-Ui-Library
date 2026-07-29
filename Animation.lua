--!strict
-- AtomicUI Animation Engine

local TweenService = game:GetService("TweenService")

local Animation = {}

type TweenInfo = {
	Duration: number,
	EasingStyle: Enum.EasingStyle?,
	EasingDirection: Enum.EasingDirection?,
	RepeatCount: number?,
	Reverses: boolean?,
	DelayTime: number?,
}

type TweenAnimation = {
	Object: Instance,
	Tween: Tween,
	Callbacks: { [string]: { () -> () } },
}

local activeAnimations: { TweenAnimation } = {}

function Animation.Create(object: Instance, properties: { any }, tweenInfo: TweenInfo): Tween
	local info = TweenInfo.new(
		tweenInfo.Duration or 0.3,
		tweenInfo.EasingStyle or Enum.EasingStyle.Quad,
		tweenInfo.EasingDirection or Enum.EasingDirection.Out,
		tweenInfo.RepeatCount or 0,
		tweenInfo.Reverses or false,
		tweenInfo.DelayTime or 0
	)
	return TweenService:Create(object, info, properties)
end

function Animation.Play(animation: Tween, onComplete: (() -> ())?): () -> ()
	if onComplete then
		animation.Completed:Once(function()
			task.spawn(onComplete)
		end)
	end
	animation:Play()
end

function Animation.Stop(animation: Tween)
	animation:Cancel()
end

function Animation.FadeIn(gui: GuiObject, duration: number?): Tween
	return Animation.Create(gui, {
		BackgroundTransparency = 0,
		Visible = true,
	}, {
		Duration = duration or 0.3,
		EasingStyle = Enum.EasingStyle.Quad,
	})
end

function Animation.FadeOut(gui: GuiObject, duration: number?): Tween
	return Animation.Create(gui, {
		BackgroundTransparency = 1,
	}, {
		Duration = duration or 0.3,
		EasingStyle = Enum.EasingStyle.Quad,
	})
end

function Animation.Scale(gui: GuiObject, scale: number, duration: number?): Tween
	local currentSize = gui.Size
	local newSize = currentSize * scale
	return Animation.Create(gui, {
		Size = newSize,
	}, {
		Duration = duration or 0.2,
		EasingStyle = Enum.EasingStyle.Quad,
	})
end

function Animation.Slide(gui: GuiObject, position: UDim2, duration: number?): Tween
	return Animation.Create(gui, {
		Position = position,
	}, {
		Duration = duration or 0.3,
		EasingStyle = Enum.EasingStyle.Quad,
	})
end

function Animation.Ripple(button: GuiButton, duration: number?)
	local ripple = Instance.new("Frame")
	ripple.Name = "Ripple"
	ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ripple.BackgroundTransparency = 0.6
	ripple.Size = UDim2.fromOffset(0, 0)
	ripple.Position = UDim2.fromScale(0.5, 0.5)
	ripple.AnchorPoint = Vector2.new(0.5, 0.5)
	ripple.ZIndex = 999
	ripple.Parent = button

	local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 0.8
	local tween = Animation.Create(ripple, {
		Size = UDim2.fromOffset(maxSize, maxSize),
		BackgroundTransparency = 1,
	}, {
		Duration = duration or 0.6,
		EasingStyle = Enum.EasingStyle.Quad,
	})
	Animation.Play(tween, function()
		ripple:Destroy()
	end)
end

return Animation
