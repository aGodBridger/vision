-- AmberGUI Aimbot Tab
-- Replicates the Aimbot tab from the C++ overlay

local Theme = require("Theme")
local Child = require("Widgets.Child")
local Checkbox = require("Widgets.Checkbox")
local Slider = require("Widgets.Slider")
local Combo = require("Widgets.Combo")
local ColorPicker = require("Widgets.ColorPicker")
local Hotkey = require("Widgets.Hotkey")
local Separator = require("Widgets.Separator")
local InputUtils = require("Utils.Input")

local AimbotTab = {}

function AimbotTab.Create(window, globals)
	-- Left column: Aimbot
	local aimbotChild = window:CreateChild("Aimbot", {
		Title = "Aimbot",
		Size = UDim2.new(0.5, -4, 1, 0),
		ShowTitle = true,
	})
	aimbotChild.Frame.LayoutOrder = 1
	
	-- Master toggle
	local aimbotEnabled = aimbotChild:AddCheckbox("Aim", globals.combat.aimbot, function(v)
		globals.combat.aimbot = v
	end)
	
	-- Hotkey next to checkbox
	local aimbotHotkey = aimbotChild:AddHotkey("", globals.combat.aimbotkeybind, function(key, type)
		globals.combat.aimbotkeybind = {key = key, type = type}
	end)
	aimbotHotkey.Frame.Position = UDim2.new(1, -85, 0, 0)
	aimbotHotkey.Frame.Size = UDim2.new(0, 80, 0, 24)
	
	aimbotChild:AddCheckbox("Sticky Aim", globals.combat.stickyaim, function(v)
		globals.combat.stickyaim = v
	end)
	
	aimbotChild:AddCheckbox("Closest Part", globals.combat.aimbot_closest_part, function(v)
		globals.combat.aimbot_closest_part = v
	end)
	
	aimbotChild:AddLabel("Type")
	aimbotChild:AddCombo("", {"Camera", "Mouse"}, globals.combat.aimbottype + 1, function(i)
		globals.combat.aimbottype = i - 1
	end)
	
	aimbotChild:AddSeparator()
	aimbotChild:AddLabel("Aim Part")
	-- Multi-select combo for aim parts
	local aimPartCombo = aimbotChild:AddCombo("", globals.combat.hit_parts, 1, function(i) end)
	-- Note: The C++ uses a multi-select combo, would need custom implementation
	
	aimbotChild:AddLabel("Air Part")
	local airPartCombo = aimbotChild:AddCombo("", globals.combat.hit_parts, 1, function(i) end)
	
	-- Right column: FOV
	local fovChild = window:CreateChild("Aimbot", {
		Title = "FOV",
		Size = UDim2.new(0.5, -4, 0.5, 0),
		ShowTitle = true,
	})
	fovChild.Frame.LayoutOrder = 2
	fovChild.Frame.Position = UDim2.new(0.5, 4, 0, 0)
	
	fovChild:AddCheckbox("Use FOV", globals.combat.usefov, function(v)
		globals.combat.usefov = v
	end)
	
	local fovColorPicker = fovChild:AddColorPicker("", globals.combat.fovcolor, function(c, a)
		globals.combat.fovcolor = c
	end)
	fovColorPicker.Frame.Position = UDim2.new(1, -35, 0, 0)
	fovColorPicker.Frame.Size = UDim2.new(0, 32, 0, 18)
	
	fovChild:AddCheckbox("Fill FOV", globals.combat.fovfill, function(v)
		globals.combat.fovfill = v
	end)
	
	local fovFillColorPicker = fovChild:AddColorPicker("", globals.combat.fovfillcolor, function(c, a)
		globals.combat.fovfillcolor = c
	end)
	fovFillColorPicker.Frame.Position = UDim2.new(1, -35, 0, 0)
	fovFillColorPicker.Frame.Size = UDim2.new(0, 32, 0, 18)
	
	fovChild:AddCheckbox("Spin FOV", globals.combat.spin_fov_aimbot, function(v)
		globals.combat.spin_fov_aimbot = v
	end)
	
	fovChild:AddSlider("FOV Radius", 1, 300, globals.combat.fovsize, function(v)
		globals.combat.fovsize = v
	end, "%.0f")
	
	fovChild:AddSlider("FOV Transparency", 0, 5, globals.combat.fovtransparency, function(v)
		globals.combat.fovtransparency = v
	end, "%.1f")
	
	fovChild:AddSlider("Fill Transparency", 0, 3, globals.combat.fovfilltransparency, function(v)
		globals.combat.fovfilltransparency = v
	end, "%.1f")
	
	fovChild:AddSlider("Spin Speed", 0, 3, globals.combat.spin_fov_aimbot_speed, function(v)
		globals.combat.spin_fov_aimbot_speed = v
	end, "%.1f")
	
	fovChild:AddLabel("Shape")
	fovChild:AddCombo("", {"Circle", "Square", "Triangle", "Pentagon", "Hexagon", "Octagon"}, globals.combat.fovshape + 1, function(i)
		globals.combat.fovshape = i - 1
	end)
	
	-- Controls column
	local controlsChild = window:CreateChild("Aimbot", {
		Title = "Controls",
		Size = UDim2.new(0.5, -4, 0.5, 0),
		ShowTitle = true,
	})
	controlsChild.Frame.LayoutOrder = 3
	controlsChild.Frame.Position = UDim2.new(0.5, 4, 0.5, 0)
	
	controlsChild:AddCheckbox("Smoothness", globals.combat.smoothing, function(v)
		globals.combat.smoothing = v
	end)
	
	controlsChild:AddSlider("Smoothness X", 1, 100, globals.combat.smoothingx, function(v)
		globals.combat.smoothingx = v
	end, "%.0f")
	
	controlsChild:AddSlider("Smoothness Y", 1, 100, globals.combat.smoothingy, function(v)
		globals.combat.smoothingy = v
	end, "%.0f")
	
	controlsChild:AddCheckbox("Predictions", globals.combat.predictions, function(v)
		globals.combat.predictions = v
	end)
	
	controlsChild:AddSlider("Prediction X", 1, 30, globals.combat.predictionsx, function(v)
		globals.combat.predictionsx = v
	end, "%.0f")
	
	controlsChild:AddSlider("Prediction Y", 1, 30, globals.combat.predictionsy, function(v)
		globals.combat.predictionsy = v
	end, "%.0f")
	
	controlsChild:AddLabel("Smoothing Style")
	controlsChild:AddCombo("", globals.combat.smoothing_styles, globals.combat.smoothing_style + 1, function(i)
		globals.combat.smoothing_style = i - 1
	end)
	
	-- Checks
	controlsChild:AddSeparator()
	controlsChild:AddCheckbox("Team Check", globals.combat.teamcheck, function(v)
		globals.combat.teamcheck = v
	end)
	
	controlsChild:AddCheckbox("Knocked Check", globals.combat.knockcheck, function(v)
		globals.combat.knockcheck = v
	end)
	
	controlsChild:AddCheckbox("Wallcheck", globals.combat.wallcheck, function(v)
		globals.combat.wallcheck = v
	end)
	
	controlsChild:AddCheckbox("Distance Check", globals.combat.rangecheck, function(v)
		globals.combat.rangecheck = v
	end)
	
	local distanceSlider = controlsChild:AddSlider("Distance", 10, 5000, globals.combat.aim_distance, function(v)
		globals.combat.aim_distance = v
	end, "%.0f")
	distanceSlider.Frame.Visible = globals.combat.rangecheck
	
	-- Triggerbot
	controlsChild:AddSeparator()
	controlsChild:AddCheckbox("Trigger Bot", globals.combat.triggerbot, function(v)
		globals.combat.triggerbot = v
	end)
	
	local triggerHotkey = controlsChild:AddHotkey("", globals.combat.triggerbotkeybind, function(key, type)
		globals.combat.triggerbotkeybind = {key = key, type = type}
	end)
	triggerHotkey.Frame.Position = UDim2.new(1, -85, 0, 0)
	triggerHotkey.Frame.Size = UDim2.new(0, 80, 0, 24)
	
	local triggerDelay = controlsChild:AddSlider("Delay (ms)", 0, 1000, globals.combat.triggerbot_delay, function(v)
		globals.combat.triggerbot_delay = v
	end, "%.0f")
	triggerDelay.Frame.Visible = globals.combat.triggerbot
	
	controlsChild:AddLabel("Triggerbot Checks")
	-- Would need multi-select combo for: Spray, Knife, Wallet, Food
	
	return {
		aimbotChild = aimbotChild,
		fovChild = fovChild,
		controlsChild = controlsChild,
	}
end

return AimbotTab