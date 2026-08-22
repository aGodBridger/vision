-- AmberGUI Loader
-- Loads the entire library from GitHub
-- Usage: loadstring(game:HttpGet("https://raw.githubusercontent.com/aGodBridger/vision/main/loader.lua"))()

local REPO_OWNER = "aGodBridger"
local REPO_NAME = "vision"
local BRANCH = "main"
local BASE_URL = "https://raw.githubusercontent.com/" .. REPO_OWNER .. "/" .. REPO_NAME .. "/" .. BRANCH .. "/AmberGUI"

-- File load order (dependencies first)
local FILES = {
	-- Utils (no deps)
	"Utils/Color.lua",
	"Utils/Tween.lua",
	"Utils/Input.lua",
	
	-- Core systems
	"Theme.lua",
	"Globals.lua",
	
	-- Widgets (depend on Theme, Utils)
	"Widgets/Label.lua",
	"Widgets/Button.lua",
	"Widgets/Checkbox.lua",
	"Widgets/Slider.lua",
	"Widgets/ColorPicker.lua",
	"Widgets/Combo.lua",
	"Widgets/Input.lua",
	"Widgets/Hotkey.lua",
	"Widgets/Separator.lua",
	"Widgets/Child.lua",
	
	-- Windows (depend on Widgets, Theme)
	"Windows/Window.lua",
	"Windows/KeybindsWindow.lua",
	"Windows/BulkAddModal.lua",
	
	-- Tabs (depend on Windows, Widgets, Globals)
	"Tabs/AimbotTab.lua",
	"Tabs/SilentTab.lua",
	"Tabs/VisualTab.lua",
	"Tabs/MovementTab.lua",
	"Tabs/PlayersTab.lua",
	"Tabs/SettingsTab.lua",
	
	-- Core & Init
	"Core.lua",
	"Init.lua",
}

-- Cache for loaded modules
local moduleCache = {}

-- Fetch file from GitHub
local function fetchFile(path)
	local url = BASE_URL .. "/" .. path
	local success, content = pcall(function()
		return game:HttpGet(url, true)
	end)
	
	if not success then
		error("Failed to fetch " .. path .. ": " .. tostring(content))
	end
	
	return content
end

-- Execute module code
local function executeModule(path, code, env)
	local chunk, err = loadstring(code, "AmberGUI/" .. path)
	if not chunk then
		error("Syntax error in " .. path .. ": " .. tostring(err))
	end
	
	-- Set up environment
	setfenv(chunk, env)
	
	local success, result = pcall(chunk)
	if not success then
		error("Runtime error in " .. path .. ": " .. tostring(result))
	end
	
	return result
end

-- Create shared environment
local sharedEnv = {
	game = game,
	workspace = workspace,
	script = script,
	-- Roblox services
	GetService = function(self, name) return game:GetService(name) end,
	-- Standard libraries
	print = print,
	warn = warn,
	error = error,
	pairs = pairs,
	ipairs = ipairs,
	next = next,
	type = type,
	tostring = tostring,
	tonumber = tonumber,
	math = math,
	string = string,
	table = table,
	os = os,
	task = task,
	coroutine = coroutine,
	Vector2 = Vector2,
	Vector3 = Vector3,
	CFrame = CFrame,
	Color3 = Color3,
	UDim2 = UDim2,
	UDim = UDim,
	Rect = Rect,
	Enum = Enum,
	Instance = Instance,
	ColorSequence = ColorSequence,
	ColorSequenceKeypoint = ColorSequenceKeypoint,
	NumberSequence = NumberSequence,
	NumberSequenceKeypoint = NumberSequenceKeypoint,
	PhysicalProperties = PhysicalProperties,
	RaycastParams = RaycastParams,
	OverlapParams = OverlapParams,
	DockWidgetPluginGuiInfo = DockWidgetPluginGuiInfo,
	Random = Random,
	DateTime = DateTime,
	TweenInfo = TweenInfo,
	PathWaypoint = PathWaypoint,
	BrickColor = BrickColor,
	CatalogSearchParams = CatalogSearchParams,
	NumberRange = NumberRange,
	Faces = Faces,
	Axes = Axes,
	Region3 = Region3,
	Region3int16 = Region3int16,
	Ray = Ray,
	FloatCurveKey = FloatCurveKey,
	SharedTable = SharedTable,
	
	-- Module system
	require = function(modulePath)
		-- Normalize path: replace dots with slashes, remove .lua if present
		local normalized = modulePath:gsub("%.", "/"):gsub("%.lua$", "")
		
		-- Check direct cache
		if moduleCache[modulePath] then return moduleCache[modulePath] end
		if moduleCache[normalized] then return moduleCache[normalized] end
		if moduleCache[normalized .. ".lua"] then return moduleCache[normalized .. ".lua"] end
		
		-- Try to find in loaded files (exact match)
		for _, filePath in ipairs(FILES) do
			local fileKey = filePath:gsub("%.lua$", "")
			if fileKey == normalized or filePath == normalized or filePath == modulePath then
				if moduleCache[filePath] then
					return moduleCache[filePath]
				end
			end
		end
		
		-- Handle bare widget names (Label, Button, etc.) -> Widgets/Label.lua
		local widgetNames = {"Label", "Button", "Checkbox", "Slider", "ColorPicker", "Combo", "Input", "Hotkey", "Separator", "Child"}
		for _, w in ipairs(widgetNames) do
			if normalized == w:lower() or normalized == w then
				local widgetPath = "Widgets/" .. w .. ".lua"
				if moduleCache[widgetPath] then
					return moduleCache[widgetPath]
				end
			end
		end
		
		-- Fallback to Roblox require
		return require(modulePath)
	end,
	
	-- Allow setting globals
	AmberGUI = {},
	Theme = {},
	Globals = {},
}

sharedEnv._G = sharedEnv
sharedEnv._ENV = sharedEnv

-- Load all files
print("[AmberGUI Loader] Starting load from " .. BASE_URL)

for _, filePath in ipairs(FILES) do
	local startTime = tick()
	print("[AmberGUI Loader] Loading " .. filePath .. "...")
	
	local code = fetchFile(filePath)
	local result = executeModule(filePath, code, sharedEnv)
	
	moduleCache[filePath] = result
	moduleCache[filePath:gsub("%.lua$", "")] = result
	
	local elapsed = (tick() - startTime) * 1000
	print("[AmberGUI Loader] Loaded " .. filePath .. " in " .. string.format("%.1f", elapsed) .. "ms")
end

print("[AmberGUI Loader] All files loaded successfully!")

-- Return the main module
return sharedEnv.AmberGUI or sharedEnv.Init or moduleCache["Init.lua"]