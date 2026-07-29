--!strict
-- AtomicUI Config System

local Config = {}
Config.__index = Config

local storage = game:GetService("DataStoreService"):GetDataStore("AtomicUI_Config")
local localData = {}

function Config.Load(name: string): table?
	local success, data = pcall(function()
		return storage:GetAsync(name)
	end)
	
	if success and data then
		localData[name] = data
		return data
	end
	
	return nil
end

function Config.Save(name: string, data: table)
	localData[name] = data
	local success, err = pcall(function()
		return storage:SetAsync(name, data)
	end)
	
	if not success then
		warn("Failed to save config:", err)
	end
end

function Config.Get(name: string, key: string): any?
	local data = localData[name]
	if data then
		return data[key]
	end
	return nil
end

function Config.Set(name: string, key: string, value: any)
	if not localData[name] then
		localData[name] = {}
	end
	localData[name][key] = value
	Config.Save(name, localData[name])
end

function Config.Delete(name: string)
	localData[name] = nil
	local success, err = pcall(function()
		return storage:RemoveAsync(name)
	end)
	
	if not success then
		warn("Failed to delete config:", err)
	end
end

function Config.Exists(name: string): boolean
	return localData[name] ~= nil
end

return Config
