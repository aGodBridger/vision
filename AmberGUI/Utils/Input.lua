-- AmberGUI Input Utilities
-- Handles keyboard, mouse, and keybind management

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local InputUtils = {}

-- Key code to name mapping (matching the C++ overlay)
InputUtils.KeyNames = {
	[Enum.KeyCode.Unknown] = "None",
	-- Mouse buttons are UserInputType, not KeyCode - handle separately
	[Enum.KeyCode.Cancel] = "Cancel",
	[Enum.KeyCode.Backspace] = "Backspace",
	[Enum.KeyCode.Tab] = "Tab",
	[Enum.KeyCode.Clear] = "Clear",
	[Enum.KeyCode.Return] = "Enter",
	[Enum.KeyCode.Pause] = "Pause",
	[Enum.KeyCode.CapsLock] = "Caps Lock",
	[Enum.KeyCode.Escape] = "Esc",
	[Enum.KeyCode.Space] = "Space",
	[Enum.KeyCode.PageUp] = "Page Up",
	[Enum.KeyCode.PageDown] = "Page Down",
	[Enum.KeyCode.End] = "End",
	[Enum.KeyCode.Home] = "Home",
	[Enum.KeyCode.Left] = "Left",
	[Enum.KeyCode.Up] = "Up",
	[Enum.KeyCode.Right] = "Right",
	[Enum.KeyCode.Down] = "Down",
	[Enum.KeyCode.Insert] = "Insert",
	[Enum.KeyCode.Delete] = "Delete",
	[Enum.KeyCode.Zero] = "0",
	[Enum.KeyCode.One] = "1",
	[Enum.KeyCode.Two] = "2",
	[Enum.KeyCode.Three] = "3",
	[Enum.KeyCode.Four] = "4",
	[Enum.KeyCode.Five] = "5",
	[Enum.KeyCode.Six] = "6",
	[Enum.KeyCode.Seven] = "7",
	[Enum.KeyCode.Eight] = "8",
	[Enum.KeyCode.Nine] = "9",
	[Enum.KeyCode.A] = "A",
	[Enum.KeyCode.B] = "B",
	[Enum.KeyCode.C] = "C",
	[Enum.KeyCode.D] = "D",
	[Enum.KeyCode.E] = "E",
	[Enum.KeyCode.F] = "F",
	[Enum.KeyCode.G] = "G",
	[Enum.KeyCode.H] = "H",
	[Enum.KeyCode.I] = "I",
	[Enum.KeyCode.J] = "J",
	[Enum.KeyCode.K] = "K",
	[Enum.KeyCode.L] = "L",
	[Enum.KeyCode.M] = "M",
	[Enum.KeyCode.N] = "N",
	[Enum.KeyCode.O] = "O",
	[Enum.KeyCode.P] = "P",
	[Enum.KeyCode.Q] = "Q",
	[Enum.KeyCode.R] = "R",
	[Enum.KeyCode.S] = "S",
	[Enum.KeyCode.T] = "T",
	[Enum.KeyCode.U] = "U",
	[Enum.KeyCode.V] = "V",
	[Enum.KeyCode.W] = "W",
	[Enum.KeyCode.X] = "X",
	[Enum.KeyCode.Y] = "Y",
	[Enum.KeyCode.Z] = "Z",
	[Enum.KeyCode.LeftWindows] = "LWin",
	[Enum.KeyCode.RightWindows] = "RWin",
	[Enum.KeyCode.Menu] = "Apps",
	[Enum.KeyCode.NumLock] = "Num Lock",
	[Enum.KeyCode.ScrollLock] = "Scroll Lock",
	[Enum.KeyCode.LeftShift] = "LShift",
	[Enum.KeyCode.RightShift] = "RShift",
	[Enum.KeyCode.LeftControl] = "LControl",
	[Enum.KeyCode.RightControl] = "RControl",
	[Enum.KeyCode.LeftAlt] = "LAlt",
	[Enum.KeyCode.RightAlt] = "RAlt",
	[Enum.KeyCode.F1] = "F1",
	[Enum.KeyCode.F2] = "F2",
	[Enum.KeyCode.F3] = "F3",
	[Enum.KeyCode.F4] = "F4",
	[Enum.KeyCode.F5] = "F5",
	[Enum.KeyCode.F6] = "F6",
	[Enum.KeyCode.F7] = "F7",
	[Enum.KeyCode.F8] = "F8",
	[Enum.KeyCode.F9] = "F9",
	[Enum.KeyCode.F10] = "F10",
	[Enum.KeyCode.F11] = "F11",
	[Enum.KeyCode.F12] = "F12",
	[Enum.KeyCode.F13] = "F13",
	[Enum.KeyCode.F14] = "F14",
	[Enum.KeyCode.F15] = "F15",
	[Enum.KeyCode.F16] = "F16",
	[Enum.KeyCode.F17] = "F17",
	[Enum.KeyCode.F18] = "F18",
	[Enum.KeyCode.F19] = "F19",
	[Enum.KeyCode.F20] = "F20",
	[Enum.KeyCode.F21] = "F21",
	[Enum.KeyCode.F22] = "F22",
	[Enum.KeyCode.F23] = "F23",
	[Enum.KeyCode.F24] = "F24",
	[Enum.KeyCode.KeypadZero] = "Numpad 0",
	[Enum.KeyCode.KeypadOne] = "Numpad 1",
	[Enum.KeyCode.KeypadTwo] = "Numpad 2",
	[Enum.KeyCode.KeypadThree] = "Numpad 3",
	[Enum.KeyCode.KeypadFour] = "Numpad 4",
	[Enum.KeyCode.KeypadFive] = "Numpad 5",
	[Enum.KeyCode.KeypadSix] = "Numpad 6",
	[Enum.KeyCode.KeypadSeven] = "Numpad 7",
	[Enum.KeyCode.KeypadEight] = "Numpad 8",
	[Enum.KeyCode.KeypadNine] = "Numpad 9",
	[Enum.KeyCode.KeypadMultiply] = "Multiply",
	[Enum.KeyCode.KeypadPlus] = "Add",
	[Enum.KeyCode.KeypadMinus] = "Subtract",
	[Enum.KeyCode.KeypadPeriod] = "Decimal",
	[Enum.KeyCode.KeypadDivide] = "Divide",
	
	-- Mouse buttons (UserInputType)
	[Enum.UserInputType.MouseButton1] = "Mouse 1",
	[Enum.UserInputType.MouseButton2] = "Mouse 2",
	[Enum.UserInputType.MouseButton3] = "MButton",
	[Enum.UserInputType.MouseButton4] = "X1",
	[Enum.UserInputType.MouseButton5] = "X2",
}

-- Reverse mapping
InputUtils.NameToKeyCode = {}
for k, v in pairs(InputUtils.KeyNames) do
	InputUtils.NameToKeyCode[v] = k
end

-- Keybind types (matching C++)
InputUtils.KeybindType = {
	HOLD = "Hold",
	TOGGLE = "Toggle",
	ALWAYS = "Always",
}

-- Keybind object
InputUtils.Keybind = {}
InputUtils.Keybind.__index = InputUtils.Keybind

function InputUtils.Keybind.new(key, type)
	local self = setmetatable({}, InputUtils.Keybind)
	self.key = key or Enum.KeyCode.Unknown
	self.type = type or InputUtils.KeybindType.HOLD
	self.enabled = false
	return self
end

function InputUtils.Keybind:GetName()
	return InputUtils.KeyNames[self.key] or "Unknown"
end

function InputUtils.Keybind:IsDown()
	if self.key == Enum.KeyCode.Unknown then return false end
	
	-- Handle both KeyCode and UserInputType
	if typeof(self.key) == "EnumItem" then
		if self.key.EnumType == Enum.KeyCode then
			return UserInputService:IsKeyDown(self.key)
		elseif self.key.EnumType == Enum.UserInputType then
			return UserInputService:IsMouseButtonPressed(self.key)
		end
	end
	return false
end

function InputUtils.Keybind:SetKey(key)
	self.key = key
end

function InputUtils.Keybind:SetType(type)
	self.type = type
end

-- Input state tracking
InputUtils.KeyStates = {}
InputUtils.MouseStates = {}

-- Update function to call every frame
function InputUtils.Update()
	for keyCode, _ in pairs(InputUtils.KeyStates) do
		InputUtils.KeyStates[keyCode] = UserInputService:IsKeyDown(keyCode)
	end
	
	for button, _ in pairs(InputUtils.MouseStates) do
		InputUtils.MouseStates[button] = UserInputService:IsMouseButtonPressed(button)
	end
end

-- Check if key was just pressed
function InputUtils.WasKeyPressed(keyCode)
	local wasDown = InputUtils.KeyStates[keyCode] == false
	local isDown = UserInputService:IsKeyDown(keyCode)
	InputUtils.KeyStates[keyCode] = isDown
	return wasDown and isDown
end

-- Check if key was just released
function InputUtils.WasKeyReleased(keyCode)
	local wasDown = InputUtils.KeyStates[keyCode] == true
	local isDown = UserInputService:IsKeyDown(keyCode)
	InputUtils.KeyStates[keyCode] = isDown
	return wasDown and not isDown
end

-- Check if mouse button was just pressed
function InputUtils.WasMouseButtonPressed(button)
	local wasDown = InputUtils.MouseStates[button] == false
	local isDown = UserInputService:IsMouseButtonPressed(button)
	InputUtils.MouseStates[button] = isDown
	return wasDown and isDown
end

-- Get mouse position
function InputUtils.GetMousePosition()
	return UserInputService:GetMouseLocation()
end

-- Check if mouse is over a GuiObject
function InputUtils.IsMouseOver(guiObject)
	local mousePos = InputUtils.GetMousePosition()
	local absPos = guiObject.AbsolutePosition
	local absSize = guiObject.AbsoluteSize
	
	return mousePos.X >= absPos.X 
		and mousePos.X <= absPos.X + absSize.X
		and mousePos.Y >= absPos.Y
		and mousePos.Y <= absPos.Y + absSize.Y
end

-- Keybind listener for hotkey binding UI
InputUtils.HotkeyListener = {}
InputUtils.HotkeyListener.__index = InputUtils.HotkeyListener

function InputUtils.HotkeyListener.new(callback)
	local self = setmetatable({}, InputUtils.HotkeyListener)
	self.callback = callback
	self.listening = false
	self.connection = nil
	return self
end

function InputUtils.HotkeyListener:Start()
	if self.listening then return end
	self.listening = true
	
	self.connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		
		local keyCode = input.KeyCode
		local userInputType = input.UserInputType
		
		-- Handle mouse buttons
		if keyCode == Enum.KeyCode.Unknown and userInputType.Name:find("MouseButton") then
			-- Allow Escape to cancel
			if userInputType == Enum.UserInputType.MouseButton1 then return end -- Don't bind left click
			
			self:Stop()
			if self.callback then self.callback(userInputType) end
			return
		end
		
		if keyCode == Enum.KeyCode.Unknown then return end
		
		-- Allow Escape to cancel
		if keyCode == Enum.KeyCode.Escape then
			self:Stop()
			if self.callback then self.callback(nil) end
			return
		end
		
		self:Stop()
		if self.callback then self.callback(keyCode) end
	end)
end

function InputUtils.HotkeyListener:Stop()
	if self.connection then
		self.connection:Disconnect()
		self.connection = nil
	end
	self.listening = false
end

-- Global keybind registry
InputUtils.RegisteredKeybinds = {}

function InputUtils.RegisterKeybind(name, keybind, callback)
	InputUtils.RegisteredKeybinds[name] = {keybind = keybind, callback = callback}
end

function InputUtils.UnregisterKeybind(name)
	InputUtils.RegisteredKeybinds[name] = nil
end

function InputUtils.ProcessKeybinds()
	for name, data in pairs(InputUtils.RegisteredKeybinds) do
		local keybind = data.keybind
		local callback = data.callback
		
		if keybind.type == InputUtils.KeybindType.HOLD then
			if keybind:IsDown() and not keybind.enabled then
				keybind.enabled = true
				if callback then callback(true) end
			elseif not keybind:IsDown() and keybind.enabled then
				keybind.enabled = false
				if callback then callback(false) end
			end
		elseif keybind.type == InputUtils.KeybindType.TOGGLE then
			if InputUtils.WasKeyPressed(keybind.key) then
				keybind.enabled = not keybind.enabled
				if callback then callback(keybind.enabled) end
			end
		elseif keybind.type == InputUtils.KeybindType.ALWAYS then
			keybind.enabled = true
		end
	end
end

-- Initialize input tracking
function InputUtils.Init()
	-- Initialize key states
	for keyCode, _ in pairs(InputUtils.KeyNames) do
		InputUtils.KeyStates[keyCode] = false
	end
	
	for _, button in pairs(Enum.UserInputType:GetEnumItems()) do
		if button.Name:find("MouseButton") then
			InputUtils.MouseStates[button] = false
		end
	end
	
	-- Connect update loop
	RunService.Heartbeat:Connect(function()
		InputUtils.Update()
		InputUtils.ProcessKeybinds()
	end)
end

return InputUtils