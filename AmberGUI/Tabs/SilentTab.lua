-- AmberGUI Silent Aim Tab

local Theme = require("Theme")
local Child = require("Widgets.Child")
local Checkbox = require("Widgets.Checkbox")
local Slider = require("Widgets.Slider")
local Combo = require("Widgets.Combo")
local ColorPicker = require("Widgets.ColorPicker")
local Hotkey = require("Widgets.Hotkey")
local Separator = require("Widgets.Separator")

local SilentTab = {}

function SilentTab.Create(window, globals)
	-- Left column: Silent Aim
	local silentChild = window:CreateChild("Silent", {
		Title = "Silent Aim",
		Size = UDim2.new(0.5, -4, 1, 0),
		ShowTitle = true,
	})
	silentChild.Frame.LayoutOrder = 1
	
	local silentEnabled = silentChild:AddCheckbox("Silent", globals.combat.silentaim, function(v)
		globals.combat.silentaim = v
	end)
	
	local silentHotkey = silentChild:AddHotkey("", globals.combat.silentaimkeybind, function(key, type)
		globals.combat.silentaimkeybind = {key = key, type = type}
	end)
	silentHotkey.Frame.Position = UDim2.new(1, -85, 0, 0)
	silentHotkey.Frame.Size = UDim2.new(0, 80, 0, 24)
	
	silentChild:AddCheckbox("Sticky Aim", globals.combat.stickyaimsilent, function(v)
		globals.combat.stickyaimsilent = v
	end)
	
	silentChild:AddCheckbox("Closest Part", globals.combat.silent_closest_part, function(v)
		globals.combat.silent_closest_part = v
	end)
	
	silentChild:AddLabel("Type")
	silentChild:AddCombo("", {"Freeaim", "Mouse"}, globals.combat.silentaimtype + 1, function(i)
		globals.combat.silentaimtype = i - 1
	end)
	
	silentChild:AddLabel("Aim Part")
	silentChild:AddCombo("", globals.combat.hit_parts, 1, function(i) end)
	
	silentChild:AddLabel("Air Part")
	silentChild:AddCombo("", globals.combat.hit_parts, 1, function(i) end)
	
	-- Right column: FOV
	local fovChild = window:CreateChild("Silent", {
		Title = "FOV",
		Size = UDim2.new(0.5, -4, 0.5, 0),
		ShowTitle = true,
	})
	fovChild.Frame.LayoutOrder = 2
	fovChild.Frame.Position = UDim2.new(0.5, 4, 0, 0)
	
	fovChild:AddCheckbox("Use FOV", globals.combat.silentaimfov, function(v)
		globals.combat.silentaimfov = v
	end)
	
	local silentFovColor = fovChild:AddColorPicker("", globals.combat.silentaimfovcolor, function(c, a)
		globals.combat.silentaimfovcolor = c
	end)
	silentFovColor.Frame.Position = UDim2.new(1, -35, 0, 0)
	silentFovColor.Frame.Size = UDim2.new(0, 32, 0, 18)
	
	fovChild:AddCheckbox("Fill FOV", globals.combat.silentaimfovfill, function(v)
		globals.combat.silentaimfovfill = v
	end)
	
	local silentFovFillColor = fovChild:AddColorPicker("", globals.combat.silentaimfovfillcolor, function(c, a)
		globals.combat.silentaimfovfillcolor = c
	end)
	silentFovFillColor.Frame.Position = UDim2.new(1, -35, 0, 0)
	silentFovFillColor.Frame.Size = UDim2.new(0, 32, 0, 18)
	
	fovChild:AddCheckbox("Spin FOV", globals.combat.spin_fov_silentaim, function(v)
		globals.combat.spin_fov_silentaim = v
	end)
	
	fovChild:AddSlider("FOV Radius", 1, 300, globals.combat.silentaimfovsize, function(v)
		globals.combat.silentaimfovsize = v
	end, "%.0f")
	
	fovChild:AddSlider("FOV Transparency", 0, 5, globals.combat.silentaimfovtransparency, function(v)
		globals.combat.silentaimfovtransparency = v
	end, "%.1f")
	
	fovChild:AddSlider("Fill Transparency", 0, 3, globals.combat.silentaimfovfilltransparency, function(v)
		globals.combat.silentaimfovfilltransparency = v
	end, "%.1f")
	
	fovChild:AddSlider("Spin Speed", 0, 3, globals.combat.spin_fov_silentaim_speed, function(v)
		globals.combat.spin_fov_silentaim_speed = v
	end, "%.1f")
	
	fovChild:AddLabel("Shape")
	fovChild:AddCombo("", {"Circle", "Square", "Triangle", "Pentagon", "Hexagon", "Octagon"}, globals.combat.silentaimfovshape + 1, function(i)
		globals.combat.silentaimfovshape = i - 1
	end)
	
	-- Controls
	local controlsChild = window:CreateChild("Silent", {
		Title = "Controls",
		Size = UDim2.new(0.5, -4, 0.5, 0),
		ShowTitle = true,
	})
	controlsChild.Frame.LayoutOrder = 3
	controlsChild.Frame.Position = UDim2.new(0.5, 4, 0.5, 0)
	
	controlsChild:AddCheckbox("Predictions", globals.combat.silentpredictions, function(v)
		globals.combat.silentpredictions = v
	end)
	
	controlsChild:AddSlider("Prediction X", 1, 30, globals.combat.silentpredictionsx, function(v)
		globals.combat.silentpredictionsx = v
	end, "%.0f")
	
	controlsChild:AddSlider("Prediction Y", 1, 30, globals.combat.silentpredictionsy, function(v)
		globals.combat.silentpredictionsy = v
	end, "%.0f")
	
	controlsChild:AddSeparator()
	controlsChild:AddCheckbox("Team Check", globals.combat.teamcheck, function(v)
		globals.combat.teamcheck = v
	end)
	
	controlsChild:AddCheckbox("Knocked Check", globals.combat.knockcheck, function(v)
		globals.combat.knockcheck = v
	end)
	
	controlsChild:AddCheckbox("Distance Check", globals.combat.rangecheck, function(v)
		globals.combat.rangecheck = v
	end)
	
	local distSlider = controlsChild:AddSlider("Distance", 10, 5000, globals.combat.aim_distance, function(v)
		globals.combat.aim_distance = v
	end, "%.0f")
	distSlider.Frame.Visible = globals.combat.rangecheck
	
	controlsChild:AddCheckbox("Wallcheck", globals.combat.wallcheck, function(v)
		globals.combat.wallcheck = v
	end)
	
	return {silentChild, fovChild, controlsChild}
end

return SilentTab