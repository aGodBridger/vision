-- AmberGUI Settings Tab
-- Replicates the Settings tab with configs, main settings, and theme editor

local Theme = require("Theme")
local Child = require("Widgets.Child")
local Checkbox = require("Widgets.Checkbox")
local Slider = require("Widgets.Slider")
local Combo = require("Widgets.Combo")
local ColorPicker = require("Widgets.ColorPicker")
local Button = require("Widgets.Button")
local Input = require("Widgets.Input")
local Hotkey = require("Widgets.Hotkey")
local Separator = require("Widgets.Separator")

local SettingsTab = {}

function SettingsTab.Create(window, globals)
	-- Left column: Configs & Settings
	local leftChild = window:CreateChild("Settings", {
		Title = "",
		Size = UDim2.new(0.5, -4, 1, 0),
		ShowTitle = false,
	})
	leftChild.Frame.LayoutOrder = 1
	
	-- Configs section
	local configsChild = leftChild:AddChild({
		Title = "Configs",
		Size = UDim2.new(1, 0, 0, 200),
		ShowTitle = true,
	})
	
	-- Config list (would be populated from ConfigSystem)
	configsChild:AddLabel("Config management")
	configsChild:AddLabel("Save/Load/Delete configs")
	
	local configNameInput = configsChild:AddInput("Config Name", "", function(text)
		globals.misc.config_name = text
	end, "Config name")
	configNameInput.Label.Visible = false
	configNameInput.TextBox.Size = UDim2.new(1, 0, 0, 24)
	
	local configButtons = Instance.new("Frame")
	configButtons.Size = UDim2.new(1, 0, 0, 50)
	configButtons.BackgroundTransparency = 1
	configButtons.Parent = configsChild.Content
	
	local btnLayout = Instance.new("UIListLayout")
	btnLayout.FillDirection = Enum.FillDirection.Horizontal
	btnLayout.Padding = UDim.new(0, 4)
	btnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	btnLayout.Parent = configButtons
	
	local saveBtn = Instance.new("TextButton")
	saveBtn.Size = UDim2.new(0.3, -2, 0, 24)
	saveBtn.BackgroundColor3 = Theme.GetColor("Button")
	saveBtn.BorderSizePixel = 1
	saveBtn.BorderColor3 = Theme.GetColor("Border")
	saveBtn.Text = "Save"
	saveBtn.TextColor3 = Theme.GetColor("Text")
	saveBtn.TextSize = 12
	saveBtn.Font = Theme.GetFont()
	saveBtn.Parent = configButtons
	
	local loadBtn = Instance.new("TextButton")
	loadBtn.Size = UDim2.new(0.3, -2, 0, 24)
	loadBtn.BackgroundColor3 = Theme.GetColor("Button")
	loadBtn.BorderSizePixel = 1
	loadBtn.BorderColor3 = Theme.GetColor("Border")
	loadBtn.Text = "Load"
	loadBtn.TextColor3 = Theme.GetColor("Text")
	loadBtn.TextSize = 12
	loadBtn.Font = Theme.GetFont()
	loadBtn.Parent = configButtons
	
	local deleteBtn = Instance.new("TextButton")
	deleteBtn.Size = UDim2.new(0.3, -2, 0, 24)
	deleteBtn.BackgroundColor3 = Theme.GetColor("Button")
	deleteBtn.BorderSizePixel = 1
	deleteBtn.BorderColor3 = Theme.GetColor("Border")
	deleteBtn.Text = "Delete"
	deleteBtn.TextColor3 = Theme.GetColor("Text")
	deleteBtn.TextSize = 12
	deleteBtn.Font = Theme.GetFont()
	deleteBtn.Parent = configButtons
	
	for _, btn in ipairs({saveBtn, loadBtn, deleteBtn}) do
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 4)
		corner.Parent = btn
		
		btn.MouseEnter:Connect(function()
			btn.BackgroundColor3 = Theme.GetColor("ButtonHovered")
			btn.BorderColor3 = Theme.GetColor("ThemeColor")
		end)
		
		btn.MouseLeave:Connect(function()
			btn.BackgroundColor3 = Theme.GetColor("Button")
			btn.BorderColor3 = Theme.GetColor("Border")
		end)
	end
	
	-- Settings section
	local settingsChild = leftChild:AddChild({
		Title = "Settings",
		Size = UDim2.new(1, 0, 1, -210),
		ShowTitle = true,
	})
	
	settingsChild:AddCheckbox("Stream Proof", globals.misc.streamproof, function(v)
		globals.misc.streamproof = v
	end)
	
	settingsChild:AddCheckbox("Keybind List", globals.misc.keybinds, function(v)
		globals.misc.keybinds = v
	end)
	
	settingsChild:AddCheckbox("Unlock FPS", globals.misc.unlock_fps, function(v)
		globals.misc.unlock_fps = v
	end)
	
	local fpsSlider = settingsChild:AddSlider("Max FPS", 1, 1000, globals.misc.fps_cap, function(v)
		globals.misc.fps_cap = v
	end, "%.0f")
	fpsSlider.Frame.Visible = globals.misc.unlock_fps
	
	-- Menu keybind
	settingsChild:AddLabel("Menu Key")
	local menuHotkey = settingsChild:AddHotkey("", globals.misc.menu_hotkey, function(key, type)
		globals.misc.menu_hotkey = {key = key, type = type}
	end)
	menuHotkey.Frame.Position = UDim2.new(1, -85, 0, -2)
	menuHotkey.Frame.Size = UDim2.new(0, 80, 0, 24)
	
	-- Right column: Theme Editor
	local themeChild = window:CreateChild("Settings", {
		Title = "Theme",
		Size = UDim2.new(0.5, -4, 1, 0),
		ShowTitle = true,
	})
	themeChild.Frame.LayoutOrder = 2
	themeChild.Frame.Position = UDim2.new(0.5, 4, 0, 0)
	
	-- Theme color pickers
	local themeColors = {
		{"Accent", "ThemeColor", true},
		{"Accent Active", "AccentActive", true},
		{"Overlay Border", "OverlayBorder", true},
		{"Window Background", "WindowBG", false},
		{"Child Background", "Child", false},
		{"Header", "Header", true},
		{"Popup Background", "PopupBG", true},
		{"Text", "Text", true},
		{"Text Disabled", "TextDisabled", true},
		{"Border", "Border", false},
		{"Button", "Button", true},
		{"Button Hovered", "ButtonHovered", true},
		{"Button Active", "ButtonActive", true},
		{"Frame Background", "FrameBG", true},
		{"Frame BG Hovered", "FrameBGHovered", true},
		{"Frame BG Active", "FrameBGActive", true},
		{"Scrollbar BG", "ScrollbarBG", true},
		{"Scrollbar Grab", "ScrollbarGrab", true},
		{"Scrollbar Grab Hovered", "ScrollbarGrabHovered", true},
		{"Scrollbar Grab Active", "ScrollbarGrabActive", true},
		{"Slider Grab", "SliderGrab", true},
		{"Slider Grab Active", "SliderGrabActive", true},
	}
	
	for _, colorInfo in ipairs(themeColors) do
		local name, key, hasAlpha = colorInfo[1], colorInfo[2], colorInfo[3]
		
		local picker = themeChild:AddColorPicker(name, Theme.Current[key], function(c, a)
			Theme.SetColor(key, c.R, c.G, c.B, a)
			SettingsTab.UpdateAllWindows()
		end)
		picker.Frame.Position = UDim2.new(1, -35, 0, 0)
		picker.Frame.Size = UDim2.new(0, 32, 0, 18)
		picker.Label.Text = name
		picker.Label.Size = UDim2.new(1, -40, 0, 24)
		picker.Frame.Parent = themeChild.Content
	end
	
	-- Font selector
	themeChild:AddSeparator()
	
	local fontCombo = themeChild:AddCombo("Font", {"GothamBold", "Gotham", "RobotoMono", "Code", "Arial", "SourceSansBold", "SourceSans"}, Theme.CurrentFontIndex, function(i)
		Theme.SetFontIndex(i)
		SettingsTab.UpdateAllWindows()
	end)
	
	-- Export/Import buttons
	themeChild:AddSeparator()
	
	local exportImportFrame = Instance.new("Frame")
	exportImportFrame.Size = UDim2.new(1, 0, 0, 50)
	exportImportFrame.BackgroundTransparency = 1
	exportImportFrame.Parent = themeChild.Content
	
	local eiLayout = Instance.new("UIListLayout")
	eiLayout.FillDirection = Enum.FillDirection.Horizontal
	eiLayout.Padding = UDim.new(0, 4)
	eiLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	eiLayout.Parent = exportImportFrame
	
	local exportBtn = Instance.new("TextButton")
	exportBtn.Size = UDim2.new(0.5, -2, 0, 24)
	exportBtn.BackgroundColor3 = Theme.GetColor("Button")
	exportBtn.BorderSizePixel = 1
	exportBtn.BorderColor3 = Theme.GetColor("Border")
	exportBtn.Text = "Export Theme"
	exportBtn.TextColor3 = Theme.GetColor("Text")
	exportBtn.TextSize = 12
	exportBtn.Font = Theme.GetFont()
	exportBtn.Parent = exportImportFrame
	
	local importBtn = Instance.new("TextButton")
	importBtn.Size = UDim2.new(0.5, -2, 0, 24)
	importBtn.BackgroundColor3 = Theme.GetColor("Button")
	importBtn.BorderSizePixel = 1
	importBtn.BorderColor3 = Theme.GetColor("Border")
	importBtn.Text = "Import Theme"
	importBtn.TextColor3 = Theme.GetColor("Text")
	importBtn.TextSize = 12
	importBtn.Font = Theme.GetFont()
	importBtn.Parent = exportImportFrame
	
	for _, btn in ipairs({exportBtn, importBtn}) do
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 4)
		corner.Parent = btn
		
		btn.MouseEnter:Connect(function()
			btn.BackgroundColor3 = Theme.GetColor("ButtonHovered")
			btn.BorderColor3 = Theme.GetColor("ThemeColor")
		end)
		
		btn.MouseLeave:Connect(function()
			btn.BackgroundColor3 = Theme.GetColor("Button")
			btn.BorderColor3 = Theme.GetColor("Border")
		end)
	end
	
	exportBtn.MouseButton1Click:Connect(function()
		local json = Theme.Export()
		if setclipboard then
			setclipboard(json)
			AmberGUI.Notify("Theme exported to clipboard!", 3, Theme.GetColor("ThemeColor"))
		else
			AmberGUI.Notify("Clipboard not available", 3, Color3.new(1, 0.3, 0.3))
		end
	end)
	
	importBtn.MouseButton1Click:Connect(function()
		if getclipboard then
			local clipboard = getclipboard()
			if Theme.Import(clipboard) then
				SettingsTab.UpdateAllWindows()
				AmberGUI.Notify("Theme imported!", 3, Theme.GetColor("ThemeColor"))
			else
				AmberGUI.Notify("Invalid theme data", 3, Color3.new(1, 0.3, 0.3))
			end
		else
			AmberGUI.Notify("Clipboard not available", 3, Color3.new(1, 0.3, 0.3))
		end
	end)
	
	return {leftChild, themeChild}
end

function SettingsTab.UpdateAllWindows()
	for _, window in ipairs(AmberGUI.Windows) do
		if window.UpdateTheme then
			window:UpdateTheme()
		end
		for _, widget in ipairs(window.Widgets) do
			if widget.UpdateTheme then
				widget:UpdateTheme()
			end
		end
	end
end

return SettingsTab