-- Upload Instructions for AmberGUI to GitHub
-- 
-- 1. Create/navigate to repo: https://github.com/aGodBridger/vision
-- 2. Upload the AmberGUI folder contents to the repo root (or AmberGUI/ subfolder)
-- 3. The loader.lua expects files at: https://raw.githubusercontent.com/aGodBridger/vision/main/AmberGUI/
--
-- Quick upload via GitHub web:
--   - Go to https://github.com/aGodBridger/vision
--   - Click "Add file" > "Upload files"
--   - Drag the entire AmberGUI folder contents
--   - Commit
--
-- Or via Git CLI:
--   git clone https://github.com/aGodBridger/vision.git
--   cp -r AmberGUI/* vision/
--   cd vision
--   git add .
--   git commit -m "Add AmberGUI library"
--   git push
--
-- Usage in Roblox (exploit environment):
--   loadstring(game:HttpGet("https://raw.githubusercontent.com/aGodBridger/vision/main/AmberGUI/loader.lua"))()
--
-- Or if uploaded to repo root:
--   loadstring(game:HttpGet("https://raw.githubusercontent.com/aGodBridger/vision/main/loader.lua"))()

local UploadInfo = {
	repo = "aGodBridger/vision",
	branch = "main",
	folder = "AmberGUI",
	loaderUrl = "https://raw.githubusercontent.com/aGodBridger/vision/main/AmberGUI/loader.lua",
	
	files = {
		"Init.lua",
		"Core.lua", 
		"Theme.lua",
		"Globals.lua",
		"loader.lua",
		"Demo.lua",
		"README.md",
		"Utils/Color.lua",
		"Utils/Tween.lua", 
		"Utils/Input.lua",
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
		"Windows/Window.lua",
		"Windows/KeybindsWindow.lua",
		"Windows/BulkAddModal.lua",
		"Tabs/AimbotTab.lua",
		"Tabs/SilentTab.lua",
		"Tabs/VisualTab.lua",
		"Tabs/MovementTab.lua",
		"Tabs/PlayersTab.lua",
		"Tabs/SettingsTab.lua",
	}
}

return UploadInfo