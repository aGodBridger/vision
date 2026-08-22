# AmberGUI

A Roblox GUI library that replicates the **amber.lol** ImGui overlay menu 1:1, built natively for Roblox Luau.

## Features

- **6 Tabs**: Aimbot, Silent Aim, Visual, Movement, Players, Settings
- **Complete Widget System**: Checkbox, Slider, Combo, ColorPicker, Hotkey, Input, Button, Label, Separator, Child panels
- **Theme System**: 22+ customizable colors, font selection, export/import via JSON
- **Keybinds Window**: Floating overlay showing active keybinds
- **Notification System**: Animated toast notifications
- **Bulk Add Modal**: Paste lists of players to add as targets
- **Player List**: Search, filter (All/Neutral/Friendly/Enemy/Target), actions (Teleport, Spectate, Target Only, Status)
- **ImGui-style Widgets**: Right-click sliders for manual input, multi-select combos, color pickers with HSV/alpha

## Installation

1. Copy the `AmberGUI` folder to `ReplicatedStorage`
2. Require the `Init.lua` module from a LocalScript

```lua
local AmberGUI = require(ReplicatedStorage.AmberGUI.Init)
local Amber = AmberGUI.Init()
```

## Usage

### Basic Setup

```lua
local Amber = AmberGUI.Init()

-- Access globals
Amber.Globals.combat.aimbot = true
Amber.Globals.combat.aimbottype = 1 -- Mouse

-- Toggle menu programmatically
Amber.Toggle()
```

### Theme Customization

```lua
local Theme = Amber.GetTheme()

-- Change accent color
Theme.SetColor("ThemeColor", 1, 0, 0, 1) -- Red

-- Change background
Theme.SetColor("WindowBG", 0.1, 0.1, 0.15, 1)

-- Change font
Theme.SetFontIndex(3) -- RobotoMono

-- Export theme to clipboard
local json = Theme.Export()
setclipboard(json)

-- Import theme from clipboard
Theme.Import(getclipboard())
```

### Adding Custom Widgets

```lua
local window = Amber.MainWindow
local child = window:CreateChild("MyTab", {Title = "Custom", Size = UDim2.new(1, 0, 0.5, 0)})

child:AddLabel("Hello World")
child:AddButton("Click Me", function() print("Clicked!") end)
child:AddCheckbox("Toggle", false, function(v) print("Value:", v) end)
child:AddSlider("Value", 0, 100, 50, function(v) print(v) end, "%.0f")
child:AddColorPicker("Color", Color3.new(1, 0, 0), function(c, a) print(c, a) end)
child:AddCombo("Options", {"A", "B", "C"}, 1, function(i) print("Selected:", i) end)
child:AddInput("Text", "default", function(text) print(text) end, "Placeholder")
child:AddHotkey("Keybind", Enum.KeyCode.F, function(key, type) print(key, type) end)
```

### Keybinds

```lua
-- Create keybind
local kb = AmberGUI.InputUtils.Keybind.new(Enum.KeyCode.F, AmberGUI.InputUtils.KeybindType.TOGGLE)

-- Register for global handling
AmberGUI.InputUtils.RegisterKeybind("MyFeature", kb, function(enabled)
	print("Feature", enabled and "enabled" or "disabled")
end)

-- Use in widget
child:AddHotkey("My Key", Enum.KeyCode.F, function(key, type)
	kb:SetKey(key)
	kb:SetType(type)
end)
```

## Architecture

```
AmberGUI/
├── Init.lua              -- Main entry point
├── Core.lua              -- Core GUI management
├── Theme.lua             -- Theme system (22+ colors)
├── Globals.lua           -- Centralized state
├── Windows/
│   ├── Window.lua        -- Main window with tabs
│   ├── KeybindsWindow.lua -- Floating keybinds list
│   └── BulkAddModal.lua  -- Bulk add targets modal
├── Tabs/
│   ├── AimbotTab.lua
│   ├── SilentTab.lua
│   ├── VisualTab.lua
│   ├── MovementTab.lua
│   ├── PlayersTab.lua
│   └── SettingsTab.lua
├── Widgets/
│   ├── Child.lua         -- ImGui::BeginChild equivalent
│   ├── Label.lua
│   ├── Button.lua        -- ColoredButtonV1 equivalent
│   ├── Checkbox.lua
│   ├── Slider.lua        -- With manual input popup
│   ├── ColorPicker.lua   -- HSV + Alpha + Inputs
│   ├── Combo.lua         -- Searchable, multi-select
│   ├── Input.lua
│   ├── Hotkey.lua        -- Hold/Toggle/Always + type menu
│   └── Separator.lua
└── Utils/
    ├── Color.lua         -- HSV/RGB conversions
    ├── Tween.lua         -- Animation helpers
    └── Input.lua         -- Keybind management
```

## Matching the C++ Overlay

| C++ Feature | AmberGUI Implementation |
|-------------|------------------------|
| `ImGui::BeginChild` | `Child` widget |
| `ColoredButtonV1` | `Button` with gradient |
| `SliderFloatManual` | `Slider` with right-click popup |
| `Hotkey` binder | `Hotkey` widget with type selector |
| `ColorEdit4` | `ColorPicker` with HSV/Alpha |
| Theme system | `Theme` module with 22 colors |
| Tab system | `Window` with tab bar |
| Keybinds overlay | `KeybindsWindow` |
| Notifications | `AmberGUI.Notify()` |
| Player list | `PlayersTab` with search/filter |

## Globals Structure

All settings are stored in `Amber.Globals`:

```lua
Amber.Globals.combat    -- Aimbot, Silent, FOV, Triggerbot, Orbit
Amber.Globals.visuals   -- ESP, Boxes, Health, Chams, Fog, Sonar
Amber.Globals.misc      -- Movement, UI settings, Theme colors
Amber.Globals.bools     -- Player status (friendly/enemy)
Amber.Globals.instances -- Cached players, local player
```

## Requirements

- Roblox Luau (Roblox game engine)
- `setclipboard`/`getclipboard` for theme export/import (exploit environment)
- Runs on Client (LocalScript)

## License

MIT License - Feel free to use and modify.