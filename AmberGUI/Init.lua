-- AmberGUI Main Entry Point
-- Initializes the library and creates the main menu

local AmberGUI = require("Core")
local Theme = require("Theme")
local Window = require("Windows/Window")
local KeybindsWindow = require("Windows/KeybindsWindow")
local BulkAddModal = require("Windows/BulkAddModal")
local AimbotTab = require("Tabs/AimbotTab")
local SilentTab = require("Tabs/SilentTab")
local VisualTab = require("Tabs/VisualTab")
local MovementTab = require("Tabs/MovementTab")
local PlayersTab = require("Tabs/PlayersTab")
local SettingsTab = require("Tabs/SettingsTab")
local Globals = require("Globals")
local InputUtils = require("Utils/Input")

-- Apply globals to theme
for k, v in pairs(Globals.misc) do
	if Theme.Current[k] and type(v) == "table" and #v >= 3 then
		Theme.Current[k] = {v[1], v[2], v[3], v[4] or 1}
	end
end

Theme.CurrentFontIndex = Globals.misc.font_index or 1

-- Main module
local Amber = {}
Amber.__index = Amber

Amber.Version = "1.0.0"
Amber.Globals = Globals
Amber.Theme = Theme
Amber.AmberGUI = AmberGUI

function Amber.Init(parent)
	-- Initialize core
	AmberGUI.Init(parent)
	
	-- Create main window
	Amber.MainWindow = Window.new({
		Title = "amber.lol",
		Size = UDim2.new(0, 575, 0, 650),
		Tabs = {"Aimbot", "Silent", "Visual", "Movement", "Players", "Settings"},
	})
	
	-- Create tabs
	Amber.Tabs = {}
	Amber.Tabs.Aimbot = AimbotTab.Create(Amber.MainWindow, Globals)
	Amber.Tabs.Silent = SilentTab.Create(Amber.MainWindow, Globals)
	Amber.Tabs.Visual = VisualTab.Create(Amber.MainWindow, Globals)
	Amber.Tabs.Movement = MovementTab.Create(Amber.MainWindow, Globals)
	Amber.Tabs.Players = PlayersTab.Create(Amber.MainWindow, Globals)
	Amber.Tabs.Settings = SettingsTab.Create(Amber.MainWindow, Globals)
	
	-- Create keybinds window
	Amber.KeybindsWindow = KeybindsWindow.new()
	
	-- Add keybinds to keybinds window
	local function addKeybind(name, keybindTable)
		local kb = InputUtils.Keybind.new(keybindTable.key, keybindTable.type)
		Amber.KeybindsWindow:AddKeybind(name, kb)
		return kb
	end
	
	Amber.KeybindsList = {
		Aimbot = addKeybind("Aimbot", Globals.combat.aimbotkeybind),
		SilentAim = addKeybind("Silent Aim", Globals.combat.silentaimkeybind),
		Speed = addKeybind("Speed", Globals.misc.speedkeybind),
		Fly = addKeybind("Fly", Globals.misc.flightkeybind),
		JumpPower = addKeybind("Jump Power", Globals.misc.jumppowerkeybind),
		Orbit = addKeybind("Orbit", Globals.combat.orbitkeybind),
		Rotate360 = addKeybind("360 Camera", Globals.misc.rotate360keybind),
		Triggerbot = addKeybind("Triggerbot", Globals.combat.triggerbotkeybind),
		Macro = addKeybind("Macro", Globals.misc.macro_keybind),
	}
	
	-- Create bulk add modal
	Amber.BulkAddModal = BulkAddModal.new({
		Callback = function(names)
			for _, name in ipairs(names) do
				if not table.find(Globals.visuals.target_only_list, name) then
					table.insert(Globals.visuals.target_only_list, name)
				end
				Globals.bools.player_status[name] = false
			end
			Globals.visuals.target_only_esp = true
			
			-- Refresh players tab
			if Amber.Tabs.Players and Amber.Tabs.Players.RefreshPlayerList then
				Amber.Tabs.Players:RefreshPlayerList()
			end
		end
	})
	
	-- Handle bulk add trigger
	task.spawn(function()
		while true do
			if Globals.misc.show_bulk_add then
				Globals.misc.show_bulk_add = false
				Amber.BulkAddModal:Show()
			end
			task.wait(0.1)
		end
	end)
	
	-- Handle auto friend trigger
	task.spawn(function()
		while true do
			if Globals.misc.trigger_autofriend then
				Globals.misc.trigger_autofriend = false
				print("[AmberGUI] Auto friend triggered for group:", Globals.misc.autofriend_group_id)
			end
			task.wait(0.1)
		end
	end)
	
	-- Handle teleport
	task.spawn(function()
		while true do
			if Globals.misc.teleport_to then
				local targetName = Globals.misc.teleport_to
				Globals.misc.teleport_to = nil
				print("[AmberGUI] Teleport to:", targetName)
				-- In real implementation: find player and teleport
			end
			task.wait(0.1)
		end
	end)
	
	-- Show welcome notification
	task.wait(0.5)
	AmberGUI.Notify("amber.lol initialized", 3, Theme.GetColor("ThemeColor"))
	AmberGUI.Notify("Press INSERT to toggle menu", 5, Theme.GetColor("TextDisabled"))
	
	return Amber
end

function Amber.SetVisible(visible)
	AmberGUI.SetVisible(visible)
end

function Amber.Toggle()
	AmberGUI.Toggle()
end

function Amber.Notify(text, duration, color)
	AmberGUI.Notify(text, duration, color)
end

function Amber.GetTheme()
	return Theme
end

function Amber.Destroy()
	AmberGUI.Destroy()
	if Amber.KeybindsWindow then
		Amber.KeybindsWindow:Destroy()
	end
	if Amber.BulkAddModal then
		Amber.BulkAddModal:Destroy()
	end
end

-- Export everything
Amber.Window = Window
Amber.KeybindsWindow = KeybindsWindow
Amber.BulkAddModal = BulkAddModal

return Amber