-- AmberGUI Globals
-- Centralized state management matching the C++ globals structure

local Globals = {}

-- Combat settings
Globals.combat = {
	-- Aimbot
	aimbot = false,
	aimbotkeybind = {key = Enum.KeyCode.Unknown, type = "Hold"},
	stickyaim = false,
	aimbot_closest_part = false,
	aimbottype = 0, -- 0 = Camera, 1 = Mouse
	aimpart = {},
	airaimpart = {},
	hit_parts = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "LeftArm", "RightArm", "LeftLeg", "RightLeg"},
	
	-- FOV
	usefov = false,
	fovcolor = {1, 1, 1, 1},
	fovfill = false,
	fovfillcolor = {1, 1, 1, 0.5},
	spin_fov_aimbot = false,
	fovsize = 100,
	fovtransparency = 1,
	fovfilltransparency = 1,
	spin_fov_aimbot_speed = 1,
	fovshape = 0, -- 0=Circle, 1=Square, etc.
	
	-- Smoothing
	smoothing = false,
	smoothingx = 10,
	smoothingy = 10,
	smoothing_style = 0,
	smoothing_styles = {"Linear", "Quadratic", "Cubic"},
	
	-- Predictions
	predictions = false,
	predictionsx = 10,
	predictionsy = 10,
	
	-- Checks
	teamcheck = false,
	knockcheck = false,
	wallcheck = false,
	rangecheck = false,
	aim_distance = 1000,
	
	-- Triggerbot
	triggerbot = false,
	triggerbotkeybind = {key = Enum.KeyCode.Unknown, type = "Hold"},
	triggerbot_delay = 0,
	triggerbot_item_checks = {false, false, false, false}, -- spray, knife, wallet, food
	
	-- Silent Aim
	silentaim = false,
	silentaimkeybind = {key = Enum.KeyCode.Unknown, type = "Hold"},
	stickyaimsilent = false,
	silent_closest_part = false,
	silentaimtype = 0, -- 0 = Freeaim, 1 = Mouse
	silentaimpart = {},
	airsilentaimpart = {},
	silentaimfov = false,
	silentaimfovcolor = {1, 1, 1, 1},
	silentaimfovfill = false,
	silentaimfovfillcolor = {1, 1, 1, 0.5},
	spin_fov_silentaim = false,
	silentaimfovsize = 100,
	silentaimfovtransparency = 1,
	silentaimfovfilltransparency = 1,
	spin_fov_silentaim_speed = 1,
	silentaimfovshape = 0,
	silentpredictions = false,
	silentpredictionsx = 10,
	silentpredictionsy = 10,
	
	-- Orbit
	orbit = false,
	orbitkeybind = {key = Enum.KeyCode.Unknown, type = "Hold"},
	orbittype = 0,
	orbitspeed = 10,
	orbitheight = 5,
	orbitrange = 10,
}

-- Visual settings
Globals.visuals = {
	visuals = false,
	
	-- Box
	boxes = false,
	boxtype = 0,
	boxcolors = {1, 1, 1, 1},
	box_overlay_flags = {false, false, false}, -- outline, glow, fill
	boxfillcolor = {1, 1, 1, 0.5},
	glowcolor = {1, 1, 1, 1},
	glow_size = 10,
	glow_opacity = 0.5,
	
	-- Health
	health = false,
	health_bar_outline = false,
	health_bar_gradient = false,
	enable_health_glow = false,
	healthglowcolor = {1, 1, 1, 1},
	healthbarcolor1 = {0, 1, 0, 1},
	healthbarcolor = {1, 0, 0, 1},
	health_glow_size = 10,
	health_glow_opacity = 0.5,
	health_bar_position = 0,
	
	-- Name
	name = false,
	namecolor = {1, 1, 1, 1},
	nametype = 0,
	
	-- Tool
	toolesp = false,
	toolespcolor = {1, 1, 1, 1},
	
	-- Skeleton
	skeletons = false,
	skeletonscolor = {1, 1, 1, 1},
	
	-- Chams
	chams = false,
	chamstype = 0,
	chamscolor = {1, 1, 1, 1},
	chamscolor1 = {1, 1, 1, 1},
	
	-- Snaplines
	snapline = false,
	snaplinecolor = {1, 1, 1, 1},
	snaplinetype = 0,
	snaplineoverlaytype = 0,
	
	-- Distance
	distance = false,
	distancecolor = {1, 1, 1, 1},
	visual_range = 1000,
	
	-- Fog
	fog_enabled = false,
	fog_color = {0.5, 0.5, 0.5, 1},
	fog_start = 0,
	fog_end = 1000,
	
	-- Sonar
	sonar = false,
	sonar_detect_players = false,
	sonar_detect_color_in = {0, 1, 0, 1},
	sonar_detect_color_out = {1, 0, 0, 1},
	sonar_range = 50,
	sonar_speed = 1,
	sonar_thickness = 1,
	
	-- Target/Locked
	target_only_esp = false,
	target_only_list = {},
	lockedesp = false,
	lockedespcolor = {1, 0, 1, 1},
}

-- Misc settings
Globals.misc = {
	speed = false,
	speedkeybind = {key = Enum.KeyCode.Unknown, type = "Hold"},
	speedtype = 0,
	speedvalue = 50,
	
	flight = false,
	flightkeybind = {key = Enum.KeyCode.Unknown, type = "Hold"},
	flighttype = 0,
	flightvalue = 50,
	
	jumppower = false,
	jumppowerkeybind = {key = Enum.KeyCode.Unknown, type = "Hold"},
	jumppowervalue = 100,
	
	nojumpcooldown = false,
	
	rotate360 = false,
	rotate360keybind = {key = Enum.KeyCode.Unknown, type = "Hold"},
	rotate360_speed = 10,
	rotate360_vspeed = 0,
	
	macro_enabled = false,
	macro_keybind = {key = Enum.KeyCode.Unknown, type = "Hold"},
	macro_delay = 10,
	
	-- UI
	streamproof = false,
	keybinds = false,
	unlock_fps = false,
	fps_cap = 240,
	menu_hotkey = {key = Enum.KeyCode.Insert, type = "Toggle"},
	
	-- Theme
	ThemeColor = {218/255, 71/255, 122/255, 1},
	AccentActive = {180/255, 50/255, 100/255, 1},
	OverlayBorder = {218/255, 71/255, 122/255, 1},
	WindowBG = {0.08, 0.08, 0.08, 1},
	Child = {0.12, 0.12, 0.12, 1},
	Header = {0.2, 0.2, 0.2, 1},
	PopupBG = {0.15, 0.15, 0.15, 0.95},
	Text = {1, 1, 1, 1},
	TextDisabled = {0.5, 0.5, 0.5, 1},
	Border = {0.2, 0.2, 0.2, 1},
	Button = {0.15, 0.15, 0.15, 1},
	ButtonHovered = {0.2, 0.2, 0.2, 1},
	ButtonActive = {0.25, 0.25, 0.25, 1},
	FrameBG = {0.1, 0.1, 0.1, 1},
	FrameBGHovered = {0.15, 0.15, 0.15, 1},
	FrameBGActive = {0.2, 0.2, 0.2, 1},
	ScrollbarBG = {0.05, 0.05, 0.05, 1},
	ScrollbarGrab = {0.3, 0.3, 0.3, 1},
	ScrollbarGrabHovered = {0.4, 0.4, 0.4, 1},
	ScrollbarGrabActive = {0.5, 0.5, 0.5, 1},
	SliderGrab = {218/255, 71/255, 122/255, 1},
	SliderGrabActive = {1, 100/255, 150/255, 1},
	
	-- Player list
	player_search = "",
	player_filter = 0,
	mock_players = {},
	
	-- Auto friend
	autofriend_group_id = "",
	trigger_autofriend = false,
	
	-- Bulk add
	show_bulk_add = false,
	
	-- Teleport
	teleport_to = nil,
	
	-- Spectate
	spectate_target_name = "",
	
	-- Copied
	copied_username = "",
	copied_userid = "",
}

-- Bools for player status
Globals.bools = {
	player_status = {}, -- [name] = true(friendly) / false(enemy) / nil(neutral)
}

-- Instances (mock)
Globals.instances = {
	cachedplayers = {},
	lp = {name = "LocalPlayer", displayname = "You"},
	camera = {getSubject = function() return {address = 0} end},
	localplayer = {spectate = function() end, unspectate = function() end},
	bots = {},
	whitelist = {},
}

-- Font index
Globals.misc.font_index = 1

-- Timezone
Globals.timezone_index = 0

return Globals