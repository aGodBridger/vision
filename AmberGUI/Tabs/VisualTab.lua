-- AmberGUI Visual Tab
-- Replicates the Visual tab from the C++ overlay with all ESP settings

local Theme = require("Theme")
local Child = require("Widgets.Child")
local Checkbox = require("Widgets.Checkbox")
local Slider = require("Widgets.Slider")
local Combo = require("Widgets.Combo")
local ColorPicker = require("Widgets.ColorPicker")
local Separator = require("Widgets.Separator")

local VisualTab = {}

function VisualTab.Create(window, globals)
	-- Left column: Player ESP
	local espChild = window:CreateChild("Visual", {
		Title = "Player ESP",
		Size = UDim2.new(0.5, -4, 1, 0),
		ShowTitle = true,
	})
	espChild.Frame.LayoutOrder = 1
	
	-- Master visuals toggle
	local visualsEnabled = espChild:AddCheckbox("Enable", globals.visuals.visuals, function(v)
		globals.visuals.visuals = v
		espChild:UpdateVisualsVisibility(v)
	end)
	
	-- Store references to widgets for enable/disable
	local espWidgets = {}
	
	local function addEspWidget(widget)
		table.insert(espWidgets, widget)
		return widget
	end
	
	local function setEspEnabled(enabled)
		for _, widget in ipairs(espWidgets) do
			widget.Frame.Visible = enabled
		end
	end
	
	espChild.UpdateVisualsVisibility = setEspEnabled
	setEspEnabled(globals.visuals.visuals)
	
	-- Boxes
	local boxesCheckbox = addEspWidget(espChild:AddCheckbox("Box", globals.visuals.boxes, function(v)
		globals.visuals.boxes = v
	end))
	
	local boxColorPicker = addEspWidget(espChild:AddColorPicker("", globals.visuals.boxcolors, function(c, a)
		globals.visuals.boxcolors = c
	end))
	boxColorPicker.Frame.Position = UDim2.new(1, -35, 0, 0)
	boxColorPicker.Frame.Size = UDim2.new(0, 32, 0, 18)
	
	local boxTypeCombo = addEspWidget(espChild:AddCombo("Box Type", {"Corners", "Bounding"}, globals.visuals.boxtype + 1, function(i)
		globals.visuals.boxtype = i - 1
	end))
	boxTypeCombo.Frame.Visible = globals.visuals.boxes
	
	-- Box Overlays (multi-select)
	local boxOverlays = addEspWidget(espChild:AddCombo("Box Overlays", {"Outline", "Glow", "Fill"}, 1, function(i) end))
	boxOverlays.Frame.Visible = globals.visuals.boxes
	
	-- Glow settings (shown when Glow selected)
	local glowSize = addEspWidget(espChild:AddSlider("Glow Size", 1, 100, globals.visuals.glow_size, function(v)
		globals.visuals.glow_size = v
	end, "%.1f"))
	glowSize.Frame.Visible = globals.visuals.boxes and globals.visuals.box_overlay_flags and globals.visuals.box_overlay_flags[2]
	
	local glowOpacity = addEspWidget(espChild:AddSlider("Glow Opacity", 0, 1, globals.visuals.glow_opacity, function(v)
		globals.visuals.glow_opacity = v
	end, "%.2f"))
	glowOpacity.Frame.Visible = globals.visuals.boxes and globals.visuals.box_overlay_flags and globals.visuals.box_overlay_flags[2]
	
	-- Fill color (shown when Fill selected)
	local boxFillColor = addEspWidget(espChild:AddColorPicker("", globals.visuals.boxfillcolor, function(c, a)
		globals.visuals.boxfillcolor = c
	end))
	boxFillColor.Frame.Position = UDim2.new(1, -35, 0, 0)
	boxFillColor.Frame.Size = UDim2.new(0, 32, 0, 18)
	boxFillColor.Frame.Visible = globals.visuals.boxes and globals.visuals.box_overlay_flags and globals.visuals.box_overlay_flags[3]
	
	-- Glow color (shown when Glow selected)
	local glowColor = addEspWidget(espChild:AddColorPicker("", globals.visuals.glowcolor, function(c, a)
		globals.visuals.glowcolor = c
	end))
	glowColor.Frame.Position = UDim2.new(1, -35, 0, 0)
	glowColor.Frame.Size = UDim2.new(0, 32, 0, 18)
	glowColor.Frame.Visible = globals.visuals.boxes and globals.visuals.box_overlay_flags and globals.visuals.box_overlay_flags[2]
	
	-- Health Bar
	local healthCheckbox = addEspWidget(espChild:AddCheckbox("Health Bar", globals.visuals.health, function(v)
		globals.visuals.health = v
	end))
	
	local healthGlowColor = addEspWidget(espChild:AddColorPicker("", globals.visuals.healthglowcolor, function(c, a)
		globals.visuals.healthglowcolor = c
	end))
	healthGlowColor.Frame.Position = UDim2.new(1, -85, 0, 0)
	healthGlowColor.Frame.Size = UDim2.new(0, 32, 0, 18)
	
	local healthColor1 = addEspWidget(espChild:AddColorPicker("", globals.visuals.healthbarcolor1, function(c, a)
		globals.visuals.healthbarcolor1 = c
	end))
	healthColor1.Frame.Position = UDim2.new(1, -55, 0, 0)
	healthColor1.Frame.Size = UDim2.new(0, 32, 0, 18)
	
	local healthColor2 = addEspWidget(espChild:AddColorPicker("", globals.visuals.healthbarcolor, function(c, a)
		globals.visuals.healthbarcolor = c
	end))
	healthColor2.Frame.Position = UDim2.new(1, -35, 0, 0)
	healthColor2.Frame.Size = UDim2.new(0, 32, 0, 18)
	
	-- Health style
	local healthStyle = addEspWidget(espChild:AddCombo("Health Style", {"Outline", "Gradient", "Glow"}, 1, function(i) end))
	healthStyle.Frame.Visible = globals.visuals.health
	
	local healthGlowSize = addEspWidget(espChild:AddSlider("Glow Size", 1, 100, globals.visuals.health_glow_size, function(v)
		globals.visuals.health_glow_size = v
	end, "%.1f"))
	healthGlowSize.Frame.Visible = false -- Only when Glow enabled
	
	local healthGlowOpacity = addEspWidget(espChild:AddSlider("Glow Opacity", 0, 1, globals.visuals.health_glow_opacity, function(v)
		globals.visuals.health_glow_opacity = v
	end, "%.2f"))
	healthGlowOpacity.Frame.Visible = false
	
	local healthPos = addEspWidget(espChild:AddCombo("Health Bar Position", {"Left", "Right"}, globals.visuals.health_bar_position + 1, function(i)
		globals.visuals.health_bar_position = i - 1
	end))
	healthPos.Frame.Visible = globals.visuals.health
	
	-- Name
	local nameCheckbox = addEspWidget(espChild:AddCheckbox("Name", globals.visuals.name, function(v)
		globals.visuals.name = v
	end))
	
	local nameColor = addEspWidget(espChild:AddColorPicker("", globals.visuals.namecolor, function(c, a)
		globals.visuals.namecolor = c
	end))
	nameColor.Frame.Position = UDim2.new(1, -35, 0, 0)
	nameColor.Frame.Size = UDim2.new(0, 32, 0, 18)
	
	local nameType = addEspWidget(espChild:AddCombo("Name Style", {"Username", "Display Name"}, globals.visuals.nametype + 1, function(i)
		globals.visuals.nametype = i - 1
	end))
	nameType.Frame.Visible = globals.visuals.name
	
	-- Tool Name
	local toolCheckbox = addEspWidget(espChild:AddCheckbox("Tool Name", globals.visuals.toolesp, function(v)
		globals.visuals.toolesp = v
	end))
	
	local toolColor = addEspWidget(espChild:AddColorPicker("", globals.visuals.toolespcolor, function(c, a)
		globals.visuals.toolespcolor = c
	end))
	toolColor.Frame.Position = UDim2.new(1, -35, 0, 0)
	toolColor.Frame.Size = UDim2.new(0, 32, 0, 18)
	
	-- Skeleton
	local skeletonCheckbox = addEspWidget(espChild:AddCheckbox("Skeleton", globals.visuals.skeletons, function(v)
		globals.visuals.skeletons = v
	end))
	
	local skeletonColor = addEspWidget(espChild:AddColorPicker("", globals.visuals.skeletonscolor, function(c, a)
		globals.visuals.skeletonscolor = c
	end))
	skeletonColor.Frame.Position = UDim2.new(1, -35, 0, 0)
	skeletonColor.Frame.Size = UDim2.new(0, 32, 0, 18)
	
	-- Chams
	local chamsCheckbox = addEspWidget(espChild:AddCheckbox("Chams", globals.visuals.chams, function(v)
		globals.visuals.chams = v
	end))
	
	local chamsColor1 = addEspWidget(espChild:AddColorPicker("", globals.visuals.chamscolor1, function(c, a)
		globals.visuals.chamscolor1 = c
	end))
	chamsColor1.Frame.Position = UDim2.new(1, -55, 0, 0)
	chamsColor1.Frame.Size = UDim2.new(0, 32, 0, 18)
	chamsColor1.Frame.Visible = globals.visuals.chams and (globals.visuals.chamstype == 1 or globals.visuals.chamstype == 2)
	
	local chamsColor2 = addEspWidget(espChild:AddColorPicker("", globals.visuals.chamscolor, function(c, a)
		globals.visuals.chamscolor = c
	end))
	chamsColor2.Frame.Position = UDim2.new(1, -35, 0, 0)
	chamsColor2.Frame.Size = UDim2.new(0, 32, 0, 18)
	
	local chamsType = addEspWidget(espChild:AddCombo("Chams Style", {"Outline", "Fill", "Highlight"}, globals.visuals.chamstype + 1, function(i)
		globals.visuals.chamstype = i - 1
		chamsColor1.Frame.Visible = globals.visuals.chams and (i - 1 == 1 or i - 1 == 2)
	end))
	chamsType.Frame.Visible = globals.visuals.chams
	
	-- Snaplines
	local snaplineCheckbox = addEspWidget(espChild:AddCheckbox("Snaplines", globals.visuals.snapline, function(v)
		globals.visuals.snapline = v
	end))
	
	local snaplineColor = addEspWidget(espChild:AddColorPicker("", globals.visuals.snaplinecolor, function(c, a)
		globals.visuals.snaplinecolor = c
	end))
	snaplineColor.Frame.Position = UDim2.new(1, -35, 0, 0)
	snaplineColor.Frame.Size = UDim2.new(0, 32, 0, 18)
	
	local snapType = addEspWidget(espChild:AddCombo("Type", {"Top", "Bottom", "Center", "Crosshair"}, globals.visuals.snaplinetype + 1, function(i)
		globals.visuals.snaplinetype = i - 1
	end))
	snapType.Frame.Visible = globals.visuals.snapline
	
	local snapOverlay = addEspWidget(espChild:AddCombo("Overlay", {"Straight", "Spiderweb"}, globals.visuals.snaplineoverlaytype + 1, function(i)
		globals.visuals.snaplineoverlaytype = i - 1
	end))
	snapOverlay.Frame.Visible = globals.visuals.snapline
	
	-- Distance
	local distanceCheckbox = addEspWidget(espChild:AddCheckbox("Distance", globals.visuals.distance, function(v)
		globals.visuals.distance = v
	end))
	
	local distanceColor = addEspWidget(espChild:AddColorPicker("", globals.visuals.distancecolor, function(c, a)
		globals.visuals.distancecolor = c
	end))
	distanceColor.Frame.Position = UDim2.new(1, -35, 0, 0)
	distanceColor.Frame.Size = UDim2.new(0, 32, 0, 18)
	
	local maxDistance = addEspWidget(espChild:AddSlider("Max Distance", 100, 5000, globals.visuals.visual_range, function(v)
		globals.visuals.visual_range = v
	end, "%.0f"))
	maxDistance.Frame.Visible = globals.visuals.distance
	
	-- Right column: Options & Theme
	local optionsChild = window:CreateChild("Visual", {
		Title = "Options",
		Size = UDim2.new(0.5, -4, 1, 0),
		ShowTitle = true,
	})
	optionsChild.Frame.LayoutOrder = 2
	optionsChild.Frame.Position = UDim2.new(0.5, 4, 0, 0)
	
	-- Fog Changer
	local fogCheckbox = optionsChild:AddCheckbox("Fog Changer", globals.visuals.fog_enabled, function(v)
		globals.visuals.fog_enabled = v
	end)
	
	local fogColor = optionsChild:AddColorPicker("", globals.visuals.fog_color, function(c, a)
		globals.visuals.fog_color = c
	end)
	fogColor.Frame.Position = UDim2.new(1, -35, 0, 0)
	fogColor.Frame.Size = UDim2.new(0, 32, 0, 18)
	
	local fogStart = optionsChild:AddSlider("Fog Start", 0, 500, globals.visuals.fog_start, function(v)
		globals.visuals.fog_start = v
	end, "%.0f")
	fogStart.Frame.Visible = globals.visuals.fog_enabled
	
	local fogEnd = optionsChild:AddSlider("Fog End", 0, 5000, globals.visuals.fog_end, function(v)
		globals.visuals.fog_end = v
	end, "%.0f")
	fogEnd.Frame.Visible = globals.visuals.fog_enabled
	
	-- Sonar
	local sonarCheckbox = optionsChild:AddCheckbox("Sonar", globals.visuals.sonar, function(v)
		globals.visuals.sonar = v
	end)
	
	local sonarDetectPlayers = optionsChild:AddCheckbox("Detect Players", globals.visuals.sonar_detect_players, function(v)
		globals.visuals.sonar_detect_players = v
	end)
	sonarDetectPlayers.Frame.Visible = globals.visuals.sonar
	
	local sonarDetectColorIn = optionsChild:AddColorPicker("", globals.visuals.sonar_detect_color_in, function(c, a)
		globals.visuals.sonar_detect_color_in = c
	end)
	sonarDetectColorIn.Frame.Position = UDim2.new(1, -55, 0, 0)
	sonarDetectColorIn.Frame.Size = UDim2.new(0, 32, 0, 18)
	sonarDetectColorIn.Frame.Visible = globals.visuals.sonar
	
	local sonarDetectColorOut = optionsChild:AddColorPicker("", globals.visuals.sonar_detect_color_out, function(c, a)
		globals.visuals.sonar_detect_color_out = c
	end)
	sonarDetectColorOut.Frame.Position = UDim2.new(1, -35, 0, 0)
	sonarDetectColorOut.Frame.Size = UDim2.new(0, 32, 0, 18)
	sonarDetectColorOut.Frame.Visible = globals.visuals.sonar
	
	local sonarRadius = optionsChild:AddSlider("Radius", 0, 100, globals.visuals.sonar_range, function(v)
		globals.visuals.sonar_range = v
	end, "%.0f")
	sonarRadius.Frame.Visible = globals.visuals.sonar
	
	local sonarSpeed = optionsChild:AddSlider("Speed", 0, 5, globals.visuals.sonar_speed, function(v)
		globals.visuals.sonar_speed = v
	end, "%.1f")
	sonarSpeed.Frame.Visible = globals.visuals.sonar
	
	local sonarThickness = optionsChild:AddSlider("Thickness", 0, 5, globals.visuals.sonar_thickness, function(v)
		globals.visuals.sonar_thickness = v
	end, "%.1f")
	sonarThickness.Frame.Visible = globals.visuals.sonar
	
	-- Target Only ESP
	optionsChild:AddCheckbox("Target Only ESP", globals.visuals.target_only_esp, function(v)
		globals.visuals.target_only_esp = v
	end)
	
	-- Locked ESP
	local lockedCheckbox = optionsChild:AddCheckbox("Locked ESP", globals.visuals.lockedesp, function(v)
		globals.visuals.lockedesp = v
	end)
	
	local lockedColor = optionsChild:AddColorPicker("", globals.visuals.lockedespcolor, function(c, a)
		globals.visuals.lockedespcolor = c
	end)
	lockedColor.Frame.Position = UDim2.new(1, -35, 0, 0)
	lockedColor.Frame.Size = UDim2.new(0, 32, 0, 18)
	
	return {espChild, optionsChild}
end

return VisualTab