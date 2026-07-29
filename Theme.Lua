--!strict
-- AtomicUI Theme Manager

local Theme = {}
Theme.__index = Theme

type ThemeColors = {
	Background: Color3,
	Surface: Color3,
	Surface2: Color3,
	Surface3: Color3,
	Primary: Color3,
	PrimaryDark: Color3,
	PrimaryLight: Color3,
	Accent: Color3,
	Text: Color3,
	TextSecondary: Color3,
	TextMuted: Color3,
	Border: Color3,
	Shadow: Color3,
	Success: Color3,
	Warning: Color3,
	Danger: Color3,
	Info: Color3,
}

local DarkTheme: ThemeColors = {
	Background = Color3.fromHex("111111"),
	Surface = Color3.fromHex("1A1A1A"),
	Surface2 = Color3.fromHex("242424"),
	Surface3 = Color3.fromHex("2D2D2D"),
	Primary = Color3.fromHex("7C3AED"),
	PrimaryDark = Color3.fromHex("5B21B6"),
	PrimaryLight = Color3.fromHex("A78BFA"),
	Accent = Color3.fromHex("06B6D4"),
	Text = Color3.fromHex("FFFFFF"),
	TextSecondary = Color3.fromHex("9CA3AF"),
	TextMuted = Color3.fromHex("6B7280"),
	Border = Color3.fromHex("374151"),
	Shadow = Color3.fromHex("000000"),
	Success = Color3.fromHex("10B981"),
	Warning = Color3.fromHex("F59E0B"),
	Danger = Color3.fromHex("EF4444"),
	Info = Color3.fromHex("3B82F6"),
}

local LightTheme: ThemeColors = {
	Background = Color3.fromHex("F9FAFB"),
	Surface = Color3.fromHex("FFFFFF"),
	Surface2 = Color3.fromHex("F3F4F6"),
	Surface3 = Color3.fromHex("E5E7EB"),
	Primary = Color3.fromHex("7C3AED"),
	PrimaryDark = Color3.fromHex("5B21B6"),
	PrimaryLight = Color3.fromHex("A78BFA"),
	Accent = Color3.fromHex("06B6D4"),
	Text = Color3.fromHex("111827"),
	TextSecondary = Color3.fromHex("6B7280"),
	TextMuted = Color3.fromHex("9CA3AF"),
	Border = Color3.fromHex("D1D5DB"),
	Shadow = Color3.fromHex("000000"),
	Success = Color3.fromHex("10B981"),
	Warning = Color3.fromHex("F59E0B"),
	Danger = Color3.fromHex("EF4444"),
	Info = Color3.fromHex("3B82F6"),
}

local currentTheme: ThemeColors = DarkTheme
local themeListeners: { (ThemeColors) -> () } = {}

function Theme.GetCurrent(): ThemeColors
	return currentTheme
end

function Theme.SetTheme(themeName: string)
	if themeName == "light" then
		currentTheme = LightTheme
	else
		currentTheme = DarkTheme
	end
	for _, listener in themeListeners do
		task.spawn(listener, currentTheme)
	end
end

function Theme.Connect(listener: (ThemeColors) -> ()): () -> ()
	table.insert(themeListeners, listener)
	return function()
		for i, existing in themeListeners do
			if existing == listener then
				table.remove(themeListeners, i)
				break
			end
		end
	end
end

function Theme.GetColor(key: string): Color3
	return currentTheme[key] or Color3.new(1, 0, 0)
end

return Theme
