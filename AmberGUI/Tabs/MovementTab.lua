-- AmberGUI Movement Tab

local Theme = require("Theme")
local Child = require("Widgets.Child")
local Checkbox = require("Widgets.Checkbox")
local Slider = require("Widgets.Slider")
local Combo = require("Widgets.Combo")
local ColorPicker = require("Widgets.ColorPicker")
local Hotkey = require("Widgets.Hotkey")
local Separator = require("Widgets.Separator")

local MovementTab = {}

function MovementTab.Create(window, globals)
	-- Left column: Movement
	local moveChild = window:CreateChild("Movement", {
		Title = "Movement",
		Size = UDim2.new(0.5, -4, 1, 0),
		ShowTitle = true,
	})
	moveChild.Frame.LayoutOrder = 1
	
	-- Speed Hack
	local speedCheckbox = moveChild:AddCheckbox("Speed Hack", globals.misc.speed, function(v)
		globals.misc.speed = v
	end)
	
	local speedHotkey = moveChild:AddHotkey("", globals.misc.speedkeybind, function(key, type)
		globals.misc.speedkeybind = {key = key, type = type}
	end)
	speedHotkey.Frame.Position = UDim2.new(1, -85, 0, 0)
	speedHotkey.Frame.Size = UDim2.new(0, 80, 0, 24)
	
	local speedMode = moveChild:AddCombo("", {"Walk Speed", "Velocity"}, globals.misc.speedtype + 1, function(i)
		globals.misc.speedtype = i - 1
	end)
	speedMode.Frame.Visible = globals.misc.speed
	
	local speedValue = moveChild:AddSlider("Speed Value", 1, 500, globals.misc.speedvalue, function(v)
		globals.misc.speedvalue = v
	end, "Speed: %.0f")
	speedValue.Frame.Visible = globals.misc.speed
	
	-- Fly
	local flyCheckbox = moveChild:AddCheckbox("Fly", globals.misc.flight, function(v)
		globals.misc.flight = v
	end)
	
	local flyHotkey = moveChild:AddHotkey("", globals.misc.flightkeybind, function(key, type)
		globals.misc.flightkeybind = {key = key, type = type}
	end)
	flyHotkey.Frame.Position = UDim2.new(1, -85, 0, 0)
	flyHotkey.Frame.Size = UDim2.new(0, 80, 0, 24)
	
	local flyMode = moveChild:AddCombo("", {"Position", "Velocity"}, globals.misc.flighttype + 1, function(i)
		globals.misc.flighttype = i - 1
	end)
	flyMode.Frame.Visible = globals.misc.flight
	
	local flySpeed = moveChild:AddSlider("Fly Speed", 1, 100, globals.misc.flightvalue, function(v)
		globals.misc.flightvalue = v
	end, "Fly Speed: %.0f")
	flySpeed.Frame.Visible = globals.misc.flight
	
	-- Jump Power
	local jumpCheckbox = moveChild:AddCheckbox("Jump Power", globals.misc.jumppower, function(v)
		globals.misc.jumppower = v
	end)
	
	local jumpHotkey = moveChild:AddHotkey("", globals.misc.jumppowerkeybind, function(key, type)
		globals.misc.jumppowerkeybind = {key = key, type = type}
	end)
	jumpHotkey.Frame.Position = UDim2.new(1, -85, 0, 0)
	jumpHotkey.Frame.Size = UDim2.new(0, 80, 0, 24)
	
	local jumpValue = moveChild:AddSlider("Jump Power", 0, 500, globals.misc.jumppowervalue, function(v)
		globals.misc.jumppowervalue = v
	end, "Jump Power: %.0f")
	jumpValue.Frame.Visible = globals.misc.jumppower
	
	-- No Jump Cooldown
	moveChild:AddCheckbox("No Jump Cooldown", globals.misc.nojumpcooldown, function(v)
		globals.misc.nojumpcooldown = v
	end)
	
	-- Right column: Extra
	local extraChild = window:CreateChild("Movement", {
		Title = "Extra",
		Size = UDim2.new(0.5, -4, 1, 0),
		ShowTitle = true,
	})
	extraChild.Frame.LayoutOrder = 2
	extraChild.Frame.Position = UDim2.new(0.5, 4, 0, 0)
	
	-- Orbit
	local orbitCheckbox = extraChild:AddCheckbox("Orbit", globals.combat.orbit, function(v)
		globals.combat.orbit = v
	end)
	
	local orbitHotkey = extraChild:AddHotkey("", globals.combat.orbitkeybind, function(key, type)
		globals.combat.orbitkeybind = {key = key, type = type}
	end)
	orbitHotkey.Frame.Position = UDim2.new(1, -85, 0, 0)
	orbitHotkey.Frame.Size = UDim2.new(0, 80, 0, 24)
	
	local orbitMode = extraChild:AddCombo("", {"Random", "X Axis", "Y Axis"}, globals.combat.orbittype + 1, function(i)
		globals.combat.orbittype = i - 1
	end)
	orbitMode.Frame.Visible = globals.combat.orbit
	
	local orbitSpeed = extraChild:AddSlider("Orbit Speed", 1, 50, globals.combat.orbitspeed, function(v)
		globals.combat.orbitspeed = v
	end, "Speed: %.0f")
	orbitSpeed.Frame.Visible = globals.combat.orbit
	
	local orbitHeight = extraChild:AddSlider("Orbit Height", 0, 20, globals.combat.orbitheight, function(v)
		globals.combat.orbitheight = v
	end, "Height: %.0f")
	orbitHeight.Frame.Visible = globals.combat.orbit
	
	local orbitRange = extraChild:AddSlider("Orbit Range", 1, 50, globals.combat.orbitrange, function(v)
		globals.combat.orbitrange = v
	end, "Range: %.0f")
	orbitRange.Frame.Visible = globals.combat.orbit
	
	-- 360 Camera
	local rotateCheckbox = extraChild:AddCheckbox("360 Camera", globals.misc.rotate360, function(v)
		globals.misc.rotate360 = v
	end)
	
	local rotateHotkey = extraChild:AddHotkey("", globals.misc.rotate360keybind, function(key, type)
		globals.misc.rotate360keybind = {key = key, type = type}
	end)
	rotateHotkey.Frame.Position = UDim2.new(1, -85, 0, 0)
	rotateHotkey.Frame.Size = UDim2.new(0, 80, 0, 24)
	
	local rotateSpeed = extraChild:AddSlider("360 Speed", 1, 30, globals.misc.rotate360_speed, function(v)
		globals.misc.rotate360_speed = v
	end, "360 Speed: %.0f")
	rotateSpeed.Frame.Visible = globals.misc.rotate360
	
	local rotateVSpeed = extraChild:AddSlider("Vertical Speed", 0, 30, globals.misc.rotate360_vspeed, function(v)
		globals.misc.rotate360_vspeed = v
	end, "Vertical Speed: %.0f")
	rotateVSpeed.Frame.Visible = globals.misc.rotate360
	
	-- Macro
	local macroCheckbox = extraChild:AddCheckbox("Macro", globals.misc.macro_enabled, function(v)
		globals.misc.macro_enabled = v
	end)
	
	local macroHotkey = extraChild:AddHotkey("", globals.misc.macro_keybind, function(key, type)
		globals.misc.macro_keybind = {key = key, type = type}
	end)
	macroHotkey.Frame.Position = UDim2.new(1, -85, 0, 0)
	macroHotkey.Frame.Size = UDim2.new(0, 80, 0, 24)
	
	local macroDelay = extraChild:AddSlider("Delay", 1, 100, globals.misc.macro_delay, function(v)
		globals.misc.macro_delay = v
	end, "Delay: %.0f ms")
	macroDelay.Frame.Visible = globals.misc.macro_enabled
	
	return {moveChild, extraChild}
end

return MovementTab