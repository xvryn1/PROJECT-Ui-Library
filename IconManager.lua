--!strict
-- AtomicUI Icon Manager

local IconManager = {}
IconManager.__index = IconManager

type IconData = {
	Image: string,
	Size: number?,
	Color: Color3?,
}

local ICONS = {
	Close = "rbxassetid://12345678",
	Minimize = "rbxassetid://12345679",
	Maximize = "rbxassetid://12345680",
	Search = "rbxassetid://12345681",
	Settings = "rbxassetid://12345682",
	Home = "rbxassetid://12345683",
	User = "rbxassetid://12345684",
	Lock = "rbxassetid://12345685",
	Unlock = "rbxassetid://12345686",
	Check = "rbxassetid://12345687",
	X = "rbxassetid://12345688",
	Plus = "rbxassetid://12345689",
	Minus = "rbxassetid://12345690",
	ArrowLeft = "rbxassetid://12345691",
	ArrowRight = "rbxassetid://12345692",
	ArrowUp = "rbxassetid://12345693",
	ArrowDown = "rbxassetid://12345694",
	Info = "rbxassetid://12345695",
	Warning = "rbxassetid://12345696",
	Error = "rbxassetid://12345697",
	Success = "rbxassetid://12345698",
}

function IconManager.GetIcon(name: string): string?
	return ICONS[name]
end

function IconManager.CreateIcon(iconName: string, parent: GuiObject, size: number?): ImageLabel
	local image = Instance.new("ImageLabel")
	image.Name = "Icon_" .. iconName
	image.Image = ICONS[iconName] or "rbxassetid://0"
	image.Size = UDim2.fromOffset(size or 20, size or 20)
	image.BackgroundTransparency = 1
	image.Parent = parent
	return image
end

return IconManager
