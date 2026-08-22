-- AmberGUI Theme System
-- Replicates the ImGui theme from the C++ overlay with 20+ color properties

local Theme = {}
Theme.__index = Theme

-- Default theme matching the C++ overlay (pink accent #DA477A)
Theme.Default = {
	-- Core accent colors
	ThemeColor = {218/255, 71/255, 122/255, 1},        -- #DA477A - Main accent
	AccentActive = {180/255, 50/255, 100/255, 1},       -- Darker accent for active
	OverlayBorder = {218/255, 71/255, 122/255, 1},      -- Window border
	
	-- Background colors
	WindowBG = {0.08, 0.08, 0.08, 1},       -- Main window background (~#141414)
	Child = {0.12, 0.12, 0.12, 1},          -- Child/panel background
	PopupBG = {0.15, 0.15, 0.15, 0.95},     -- Popup background
	
	-- Text colors
	Text = {1, 1, 1, 1},                    -- Primary text
	TextDisabled = {0.5, 0.5, 0.5, 1},      -- Disabled text
	
	-- Border
	Border = {0.2, 0.2, 0.2, 1},            -- General borders
	
	-- Button states
	Button = {0.15, 0.15, 0.15, 1},
	ButtonHovered = {0.2, 0.2, 0.2, 1},
	ButtonActive = {0.25, 0.25, 0.25, 1},
	
	-- Frame/Input backgrounds
	FrameBG = {0.1, 0.1, 0.1, 1},
	FrameBGHovered = {0.15, 0.15, 0.15, 1},
	FrameBGActive = {0.2, 0.2, 0.2, 1},
	
	-- Header (tab selected, tree nodes)
	Header = {0.2, 0.2, 0.2, 1},
	
	-- Scrollbar
	ScrollbarBG = {0.05, 0.05, 0.05, 1},
	ScrollbarGrab = {0.3, 0.3, 0.3, 1},
	ScrollbarGrabHovered = {0.4, 0.4, 0.4, 1},
	ScrollbarGrabActive = {0.5, 0.5, 0.5, 1},
	
	-- Slider
	SliderGrab = {218/255, 71/255, 122/255, 1},
	SliderGrabActive = {255/255, 100/255, 150/255, 1},
	
	-- CheckMark (checkbox check, radio dot)
	CheckMark = {218/255, 71/255, 122/255, 1},
	
	-- Separator
	Separator = {0.2, 0.2, 0.2, 1},
}

-- Current active theme (starts as default)
Theme.Current = {}

-- Font options
Theme.Fonts = {
	{Name = "GothamBold", Enum = Enum.Font.GothamBold},
	{Name = "Gotham", Enum = Enum.Font.Gotham},
	{Name = "RobotoMono", Enum = Enum.Font.RobotoMono},
	{Name = "Code", Enum = Enum.Font.Code},
	{Name = "Arial", Enum = Enum.Font.Arial},
	{Name = "SourceSansBold", Enum = Enum.Font.SourceSansBold},
	{Name = "SourceSans", Enum = Enum.Font.SourceSans},
}

Theme.CurrentFontIndex = 1

-- Initialize current theme with defaults
for k, v in pairs(Theme.Default) do
	Theme.Current[k] = {table.unpack(v)}
end

-- Get current theme color as Color3
function Theme.GetColor(name)
	local c = Theme.Current[name]
	if c then
		return Color3.new(c[1], c[2], c[3])
	end
	return Color3.new(1, 1, 1)
end

-- Get current theme color as Color3 with alpha
function Theme.GetColorAlpha(name)
	local c = Theme.Current[name]
	if c then
		return Color3.new(c[1], c[2], c[3]), c[4] or 1
	end
	return Color3.new(1, 1, 1), 1
end

-- Set theme color
function Theme.SetColor(name, r, g, b, a)
	if Theme.Current[name] then
		Theme.Current[name] = {r, g, b, a or 1}
	else
		Theme.Current[name] = {r, g, b, a or 1}
	end
end

-- Set theme color from Color3
function Theme.SetColor3(name, color, alpha)
	Theme.SetColor(name, color.R, color.G, color.B, alpha or 1)
end

-- Reset to defaults
function Theme.Reset()
	for k, v in pairs(Theme.Default) do
		Theme.Current[k] = {table.unpack(v)}
	end
end

-- Export theme to JSON string
function Theme.Export()
	local HttpService = game:GetService("HttpService")
	local export = {theme = {}}
	for k, v in pairs(Theme.Current) do
		export.theme[k] = v
	end
	export.fontIndex = Theme.CurrentFontIndex
	return HttpService:JSONEncode(export)
end

-- Import theme from JSON string
function Theme.Import(jsonString)
	local HttpService = game:GetService("HttpService")
	local success, data = pcall(function()
		return HttpService:JSONDecode(jsonString)
	end)
	
	if success and data and data.theme then
		for k, v in pairs(data.theme) do
			if Theme.Current[k] and type(v) == "table" and #v >= 3 then
				Theme.Current[k] = {v[1], v[2], v[3], v[4] or 1}
			end
		end
		if data.fontIndex and Theme.Fonts[data.fontIndex] then
			Theme.CurrentFontIndex = data.fontIndex
		end
		return true
	end
	return false
end

-- Get current font enum
function Theme.GetFont()
	return Theme.Fonts[Theme.CurrentFontIndex].Enum
end

-- Get font name
function Theme.GetFontName()
	return Theme.Fonts[Theme.CurrentFontIndex].Name
end

-- Set font index
function Theme.SetFontIndex(index)
	if Theme.Fonts[index] then
		Theme.CurrentFontIndex = index
	end
end

-- Lerp helper for color animation
function Theme.LerpColor(a, b, t)
	return Color3.new(
		a.R + (b.R - a.R) * t,
		a.G + (b.G - a.G) * t,
		a.B + (b.B - a.B) * t
	)
end

-- Convert to ImGui-style Vec4 (for compatibility)
function Theme.ToVec4(name)
	local c = Theme.Current[name]
	if c then
		return {c[1], c[2], c[3], c[4] or 1}
	end
	return {1, 1, 1, 1}
end

return Theme