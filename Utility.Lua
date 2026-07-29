--!strict
-- AtomicUI Utility Functions

local TextService = game:GetService("TextService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local Utility = {}
Utility.__index = Utility

function Utility.DeepCopy<T>(t: T): T
	if type(t) ~= "table" then
		return t
	end
	local copy = {}
	for k, v in pairs(t) do
		if type(v) == "table" then
			copy[k] = Utility.DeepCopy(v)
		else
			copy[k] = v
		end
	end
	return (copy :: any) :: T
end

function Utility.TableFreeze<T>(t: T): T
	if type(t) ~= "table" then
		return t
	end
	for _, v in pairs(t) do
		if type(v) == "table" then
			Utility.TableFreeze(v)
		end
	end
	if table.freeze then
		pcall(table.freeze, t)
	end
	return t
end

function Utility.WrapText(text: string, maxWidth: number, font: Enum.Font, baseSize: number): { string }
	assert(type(text) == "string", "WrapText: text must be string")
	assert(type(maxWidth) == "number", "WrapText: maxWidth must be number")
	assert(typeof(font) == "EnumItem", "WrapText: font must be Enum.Font")
	assert(type(baseSize) == "number", "WrapText: baseSize must be number")

	local lines: { string } = {}
	local currentLine = ""
	for word in string.gmatch(text, "%S+") do
		local testLine = #currentLine > 0 and (currentLine .. " " .. word) or word
		local size = TextService:GetTextSize(testLine, baseSize, font, Vector2.new(maxWidth, math.huge))
		if size.X <= maxWidth then
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
	assert(type(value) == "number" and type(min) == "number" and type(max) == "number", "Clamp expects numbers")
	return math.max(min, math.min(max, value))
end

function Utility.Lerp(a: number, b: number, t: number): number
	assert(type(a) == "number" and type(b) == "number" and type(t) == "number", "Lerp expects numbers")
	return a + (b - a) * t
end

function Utility.HexToColor3(hex: string): Color3
	assert(type(hex) == "string", "HexToColor3 expects string")
	hex = hex:gsub("#", "")
	if #hex == 3 then
		hex = string.format("%s%s%s%s%s%s", hex:sub(1,1), hex:sub(1,1), hex:sub(2,2), hex:sub(2,2), hex:sub(3,3), hex:sub(3,3))
	end
	if #hex ~= 6 then
		return Color3.fromRGB(255, 0, 0)
	end
	local r = tonumber(hex:sub(1, 2), 16) or 0
	local g = tonumber(hex:sub(3, 4), 16) or 0
	local b = tonumber(hex:sub(5, 6), 16) or 0
	return Color3.fromRGB(r, g, b)
end

function Utility.Color3ToHex(color: Color3): string
	assert(typeof(color) == "Color3", "Color3ToHex expects Color3")
	local r = math.floor(color.R * 255 + 0.5)
	local g = math.floor(color.G * 255 + 0.5)
	local b = math.floor(color.B * 255 + 0.5)
	return string.format("#%02X%02X%02X", r, g, b)
end

function Utility.IsMobile(): boolean
	return UserInputService.TouchEnabled
end

function Utility.GetScreenSize(): Vector2
	local camera = Workspace.CurrentCamera
	if camera then
		return camera.ViewportSize
	end
	return Vector2.new(0, 0)
end

function Utility.ToUDim2Size(size: any, fallback: Vector2): UDim2
	if typeof(size) == "Vector2" then
		return UDim2.fromOffset(size.X, size.Y)
	elseif typeof(size) == "UDim2" then
		return size
	else
		return UDim2.fromOffset(fallback.X, fallback.Y)
	end
end

return Utility
