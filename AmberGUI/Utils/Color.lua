-- AmberGUI Color Utilities

local ColorUtils = {}

-- HSV to RGB conversion
function ColorUtils.HSVtoRGB(h, s, v)
	local r, g, b
	
	local i = math.floor(h * 6)
	local f = h * 6 - i
	local p = v * (1 - s)
	local q = v * (1 - f * s)
	local t = v * (1 - (1 - f) * s)
	
	i = i % 6
	
	if i == 0 then r, g, b = v, t, p
	elseif i == 1 then r, g, b = q, v, p
	elseif i == 2 then r, g, b = p, v, t
	elseif i == 3 then r, g, b = p, q, v
	elseif i == 4 then r, g, b = t, p, v
	elseif i == 5 then r, g, b = v, p, q
	end
	
	return Color3.new(r, g, b)
end

-- RGB to HSV conversion
function ColorUtils.RGBtoHSV(r, g, b)
	local max = math.max(r, g, b)
	local min = math.min(r, g, b)
	local delta = max - min
	
	local h, s, v = 0, 0, max
	
	if max > 0 then
		s = delta / max
	end
	
	if delta > 0 then
		if max == r then
			h = (g - b) / delta
		elseif max == g then
			h = 2 + (b - r) / delta
		else
			h = 4 + (r - g) / delta
		end
		h = h / 6
		if h < 0 then h = h + 1 end
	end
	
	return h, s, v
end

-- Color3 to HSV
function ColorUtils.Color3ToHSV(color)
	return ColorUtils.RGBtoHSV(color.R, color.G, color.B)
end

-- HSV to Color3
function ColorUtils.HSVToColor3(h, s, v)
	return ColorUtils.HSVtoRGB(h, s, v)
end

-- Lerp between two colors
function ColorUtils.Lerp(a, b, t)
	return Color3.new(
		a.R + (b.R - a.R) * t,
		a.G + (b.G - a.G) * t,
		a.B + (b.B - a.B) * t
	)
end

-- Darken a color
function ColorUtils.Darken(color, amount)
	amount = amount or 0.1
	return Color3.new(
		math.max(0, color.R - amount),
		math.max(0, color.G - amount),
		math.max(0, color.B - amount)
	)
end

-- Lighten a color
function ColorUtils.Lighten(color, amount)
	amount = amount or 0.1
	return Color3.new(
		math.min(1, color.R + amount),
		math.min(1, color.G + amount),
		math.min(1, color.B + amount)
	)
end

-- Multiply color by scalar
function ColorUtils.Multiply(color, scalar)
	return Color3.new(color.R * scalar, color.G * scalar, color.B * scalar)
end

-- Add two colors
function ColorUtils.Add(a, b)
	return Color3.new(
		math.min(1, a.R + b.R),
		math.min(1, a.G + b.G),
		math.min(1, a.B + b.B)
	)
end

-- Convert Color3 to hex string
function ColorUtils.ToHex(color)
	return string.format("#%02X%02X%02X", 
		math.floor(color.R * 255 + 0.5),
		math.floor(color.G * 255 + 0.5),
		math.floor(color.B * 255 + 0.5)
	)
end

-- Convert hex string to Color3
function ColorUtils.FromHex(hex)
	hex = hex:gsub("#", "")
	local r = tonumber(hex:sub(1, 2), 16) / 255
	local g = tonumber(hex:sub(3, 4), 16) / 255
	local b = tonumber(hex:sub(5, 6), 16) / 255
	return Color3.new(r, g, b)
end

-- Get contrast color (black or white) for text on background
function ColorUtils.GetContrastColor(bgColor)
	local luminance = 0.299 * bgColor.R + 0.587 * bgColor.G + 0.114 * bgColor.B
	return luminance > 0.5 and Color3.new(0, 0, 0) or Color3.new(1, 1, 1)
end

-- Rainbow color based on time
function ColorUtils.Rainbow(speed, offset)
	speed = speed or 1
	offset = offset or 0
	local h = (tick() * speed + offset) % 1
	return ColorUtils.HSVtoRGB(h, 1, 1)
end

-- Gradient between multiple colors
function ColorUtils.Gradient(colors, t)
	if #colors == 0 then return Color3.new(1, 1, 1) end
	if #colors == 1 then return colors[1] end
	if t <= 0 then return colors[1] end
	if t >= 1 then return colors[#colors] end
	
	local segment = 1 / (#colors - 1)
	local index = math.floor(t / segment)
	local localT = (t - index * segment) / segment
	
	index = math.clamp(index + 1, 1, #colors - 1)
	return ColorUtils.Lerp(colors[index], colors[index + 1], localT)
end

return ColorUtils