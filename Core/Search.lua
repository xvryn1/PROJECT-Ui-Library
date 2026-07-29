--!strict
-- AtomicUI Search System

local Search = {}
Search.__index = Search

function Search.Filter(items: { any }, query: string, keyField: string): { any }
	query = query:lower()
	local results = {}
	
	for _, item in items do
		local searchText = keyField and item[keyField] or tostring(item)
		if searchText:lower():find(query, nil, true) then
			table.insert(results, item)
		end
	end
	
	return results
end

function Search.FuzzyFilter(items: { any }, query: string, keyField: string): { any }
	query = query:lower()
	local results = {}
	
	for _, item in items do
		local searchText = keyField and item[keyField] or tostring(item)
		searchText = searchText:lower()
		
		local match = true
		local queryPos = 1
		for i = 1, #searchText do
			if searchText:sub(i, i) == query:sub(queryPos, queryPos) then
				queryPos = queryPos + 1
				if queryPos > #query then
					break
				end
			end
		end
		
		if queryPos > #query then
			table.insert(results, item)
		end
	end
	
	return results
end

function Search.CreateSearchBar(parent: GuiObject, onSearch: (string) -> ())
	local searchBar = Instance.new("TextBox")
	searchBar.Name = "SearchBar"
	searchBar.Size = UDim2.new(1, -32, 0, 36)
	searchBar.Position = UDim2.fromOffset(16, 0)
	searchBar.BackgroundColor3 = require(script.Parent.Theme).GetCurrent().Surface2
	searchBar.BorderSizePixel = 0
	searchBar.Text = ""
	searchBar.TextColor3 = require(script.Parent.Theme).GetCurrent().Text
	searchBar.TextSize = 14
	searchBar.Font = Enum.Font.Gotham
	searchBar.PlaceholderText = "Search..."
	searchBar.PlaceholderColor3 = require(script.Parent.Theme).GetCurrent().TextMuted
	searchBar.Parent = parent
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = searchBar
	
	local icon = Instance.new("ImageLabel")
	icon.Size = UDim2.fromOffset(20, 20)
	icon.Position = UDim2.fromOffset(12, 8)
	icon.BackgroundTransparency = 1
	icon.Image = "rbxassetid://12345681" -- search icon
	icon.ImageColor3 = require(script.Parent.Theme).GetCurrent().TextMuted
	icon.Parent = searchBar
	
	local debounce = nil
	searchBar:GetPropertyChangedSignal("Text"):Connect(function()
		if debounce then
			debounce:Disconnect()
		end
		debounce = task.delay(0.3, function()
			onSearch(searchBar.Text)
		end)
	end)
	
	return searchBar
end

return Search
