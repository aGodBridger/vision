-- AmberGUI Demo Script
-- Place this in StarterPlayerScripts or a LocalScript to test the GUI

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Load the library (adjust path as needed)
local AmberGUI = require(ReplicatedStorage:WaitForChild("AmberGUI"))

-- Initialize
local Amber = AmberGUI.Init()

-- Optional: Add some mock players for testing
task.wait(1)
Amber.Globals.misc.mock_players = {
	{name = "Player1", displayname = "PlayerOne", health = 100, maxhealth = 100, team = "Neutral"},
	{name = "Player2", displayname = "PlayerTwo", health = 50, maxhealth = 100, team = "Enemy"},
	{name = "Player3", displayname = "PlayerThree", health = 100, maxhealth = 100, team = "Friendly"},
	{name = "LocalPlayer", displayname = "You", health = 100, maxhealth = 100, team = "Client"},
}

-- Refresh player list
if Amber.Tabs.Players and Amber.Tabs.Players.RefreshPlayerList then
	Amber.Tabs.Players:RefreshPlayerList()
end

-- Example: Toggle menu with a different key
-- AmberGUI.MenuKeybind = AmberGUI.InputUtils.Keybind.new(Enum.KeyCode.RightShift, AmberGUI.InputUtils.KeybindType.TOGGLE)

-- Example: Programmatically change theme
task.wait(3)
Amber.Theme.SetColor("ThemeColor", 0, 1, 0.5, 1) -- Change to teal
Amber.Theme.SetColor("WindowBG", 0.05, 0.05, 0.1, 1) -- Darker background

-- Update all windows
for _, window in ipairs(AmberGUI.Windows) do
	if window.UpdateTheme then
		window:UpdateTheme()
	end
end

-- Example: Add notification
AmberGUI.Notify("Theme changed!", 3, Amber.Theme.GetColor("ThemeColor"))

-- Example: Access globals
print("Aimbot enabled:", Amber.Globals.combat.aimbot)
print("Current theme color:", Amber.Theme.GetColor("ThemeColor"))

-- Cleanup on script removal (optional)
game:GetService("Players").LocalPlayer.CharacterRemoving:Connect(function()
	Amber.Destroy()
end)

print("AmberGUI Demo loaded! Press INSERT to open menu.")