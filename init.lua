--!strict
-- AtomicUI v1.0.0
-- Lightweight entry module for the AtomicUI library

local AtomicUI = {}
AtomicUI.Version = "1.0.0"

-- Lazy loader helpers. In Roblox, when this module is placed in a folder
-- alongside the other modules, these require calls will work. We use pcall
-- to avoid runtime errors in unexpected environments (studio test harnesses, etc.).
local function tryRequire(childName: string)
	local ok, result = pcall(function()
		local child = script:FindFirstChild(childName)
		if child then
			return require(child)
		end
		-- If the module is not a direct child (packaging differences), attempt require by name
		local ok2, r2 = pcall(function() return require(script) end)
		if ok2 then
			return r2
		end
		error("Module not found: " .. childName)
	end)
	if ok then
		return result
	end
	return nil
end

-- Expose a simple lazy index so consumers can do:
-- local UI = require(path.to.AtomicUI)
-- local Window = UI.Core.Window
setmetatable(AtomicUI, {
	__index = function(t, k)
		if k == "Theme" then
			return tryRequire("Theme.Lua") or tryRequire("Theme")
		elseif k == "Utility" then
			return tryRequire("Utility.Lua") or tryRequire("Utility")
		elseif k == "Animation" then
			return tryRequire("Animation.lua") or tryRequire("Animation")
		elseif k == "IconManager" then
			return tryRequire("IconManager.lua") or tryRequire("IconManager")
		elseif k == "Core" then
			local core = {}
			core.Window = tryRequire("Core") and tryRequire("Core").Window or nil
			return core
		elseif k == "Components" then
			local components = {}
			-- components are available by requiring the Components folder or individual modules
			return components
		end
		return rawget(t, k)
	end,
})

return AtomicUI
