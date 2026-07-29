--!strict
-- AtomicUI Utility Functions

local Utility = {}

function Utility.DeepCopy(t: table): table
	local copy = {}
	for k, v in next, t do
		if type(v) == "table" then
			copy[k] = Utility.DeepCopy(v)
		else
			copy[k] = v
		end
	end
	return copy
end

function Utility.TableFreeze(t: table): table
	for k, v in next, t do
		if type(v) == "table" then
			Utility.TableFreeze(v)
		end
	end
	return table.freeze(t)
end

function Utility.WrapText(text: string, maxWidth: number, font: Font, baseSize: number): { string }
	local lines = {}
	local currentLine = ""
	for word in text:gmatch("%S+") do
		local testLine = #currentLine > 0 and currentLine .. " " .. word or word
		local bounds = font:GetBounds(testLine, baseSize)
		if bounds.X <= maxWidth then
			currentLine = testLine
		else
			if #currentLine > 0 then
				table.insert(lines, currentLine)
			end
			currentLine = word
		end
	end
	if #currentLine > 0 then
		table.insert(lines, currentLine)
	end
	return lines
end

function Utility.Clamp(value: number, min: number, max: number): number
	return math.max(min, math.min(max, value))
end

function Utility.Lerp(a: number, b: number, t: number): number
	return a + (b - a) * t
end

function Utility.HexToColor3(hex: string): Color3
	hex = hex:gsub("#", "")
	local r = tonumber(hex:sub(1, 2), 16) or 0
	local g = tonumber(hex:sub(3, 4), 16) or 0
	local b = tonumber(hex:sub(5, 6), 16) or 0
	return Color3.fromRGB(r, g, b)
end

function Utility.Color3ToHex(color: Color3): string
	local r = math.floor(color.R * 255)
	local g = math.floor(color.G * 255)
	local b = math.floor(color.B * 255)
	return string.format("#%02X%02X%02X", r, g, b)
end

function Utility.IsMobile(): boolean
	return game:GetService("UserInputService").TouchEnabled
end

function Utility.GetScreenSize(): Vector2
	return game:GetService("Camera").ViewportSize
end

return Utility
