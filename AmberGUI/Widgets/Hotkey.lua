-- AmberGUI Hotkey Widget
-- Replicates the C++ Hotkey binder with Hold/Toggle/Always modes

local Theme = require("Theme")
local TweenUtils = require("Utils.Tween")
local InputUtils = require("Utils.Input")

local Hotkey = {}
Hotkey.__index = Hotkey

Hotkey.DefaultConfig = {
	Text = "Hotkey",
	Default = Enum.KeyCode.Unknown,
	DefaultType = InputUtils.KeybindType.HOLD,
	Callback = nil,
	Size = UDim2.new(1, 0, 0, 36),
	ShowTypeSelector = true,
}

function Hotkey.new(parent, options)
	local self = setmetatable({}, Hotkey)
	
	self.Config = {}
	for k, v in pairs(Hotkey.DefaultConfig) do
		self.Config[k] = options and options[k] or v
	end
	
	self.Keybind = InputUtils.Keybind.new(self.Config.Default, self.Config.DefaultType)
	self.Listening = false
	self.TypeMenuOpen = false
	
	self:Create(parent)
	return self
end

function Hotkey:Create(parent)
	self.Frame = Instance.new("Frame")
	self.Frame.Name = "Hotkey"
	self.Frame.Size = self.Config.Size
	self.Frame.BackgroundTransparency = 1
	self.Frame.Parent = parent
	
	-- Label
	self.Label = Instance.new("TextLabel")
	self.Label.Name = "Label"
	self.Label.Size = UDim2.new(1, -60, 0, 18)
	self.Label.BackgroundTransparency = 1
	self.Label.Text = self.Config.Text
	self.Label.TextColor3 = Theme.GetColor("Text")
	self.Label.TextSize = 13
	self.Label.Font = Theme.GetFont()
	self.Label.TextXAlignment = Enum.TextXAlignment.Left
	self.Label.TextYAlignment = Enum.TextYAlignment.Center
	self.Label.Parent = self.Frame
	
	-- Keybind button
	self.Button = Instance.new("TextButton")
	self.Button.Name = "Button"
	self.Button.Size = UDim2.new(0, 80, 0, 24)
	self.Button.Position = UDim2.new(1, -80, 0, 20)
	self.Button.BackgroundColor3 = Theme.GetColor("FrameBG")
	self.Button.BorderSizePixel = 1
	self.Button.BorderColor3 = Theme.GetColor("Border")
	self.Button.Text = self.Keybind:GetName()
	self.Button.TextColor3 = Theme.GetColor("Text")
	self.Button.TextSize = 12
	self.Button.Font = Theme.GetFont()
	self.Button.AutoButtonColor = false
	self.Button.Parent = self.Frame
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 3)
	corner.Parent = self.Button
	
	-- Type indicator
	if self.Config.ShowTypeSelector then
		self.TypeLabel = Instance.new("TextLabel")
		self.TypeLabel.Name = "TypeLabel"
		self.TypeLabel.Size = UDim2.new(0, 40, 0, 14)
		self.TypeLabel.Position = UDim2.new(1, -125, 0, 25)
		self.TypeLabel.BackgroundTransparency = 1
		self.TypeLabel.Text = "[" .. self.Keybind.type .. "]"
		self.TypeLabel.TextColor3 = Theme.GetColor("TextDisabled")
		self.TypeLabel.TextSize = 10
		self.TypeLabel.Font = Theme.GetFont()
		self.TypeLabel.TextXAlignment = Enum.TextXAlignment.Right
		self.TypeLabel.Parent = self.Frame
		
		-- Type click to cycle
		local typeClick = Instance.new("TextButton")
		typeClick.Name = "TypeClick"
		typeClick.Size = UDim2.new(0, 40, 0, 18)
		typeClick.Position = UDim2.new(1, -125, 0, 24)
		typeClick.BackgroundTransparency = 1
		typeClick.Text = ""
		typeClick.Parent = self.Frame
		
		typeClick.MouseButton1Click:Connect(function()
			self:CycleType()
		end)
	end
	
	-- Button events
	self.Button.MouseButton1Click:Connect(function()
		self:StartListening()
	end)
	
	self.Button.MouseEnter:Connect(function()
		if not self.Listening then
			TweenUtils.Tween(self.Button, {BorderColor3 = Theme.GetColor("ThemeColor")}, 0.1)
		end
	end)
	
	self.Button.MouseLeave:Connect(function()
		if not self.Listening then
			TweenUtils.Tween(self.Button, {BorderColor3 = Theme.GetColor("Border")}, 0.1)
		end
	end)
	
	-- Right-click for type menu
	self.Button.MouseButton2Click:Connect(function()
		if self.Config.ShowTypeSelector then
			self:OpenTypeMenu()
		end
	end)
end

function Hotkey:StartListening()
	if self.Listening then return end
	
	self.Listening = true
	self.Button.Text = "..."
	self.Button.TextColor3 = Theme.GetColor("ThemeColor")
	TweenUtils.Tween(self.Button, {BorderColor3 = Theme.GetColor("ThemeColor")}, 0.1)
	
	-- Create listener
	self.Listener = InputUtils.HotkeyListener.new(function(keyCode)
		self:StopListening(keyCode)
	end)
	self.Listener:Start()
end

function Hotkey:StopListening(keyCode)
	if self.Listener then
		self.Listener:Stop()
		self.Listener = nil
	end
	
	self.Listening = false
	
	if keyCode then
		self.Keybind:SetKey(keyCode)
		self.Button.Text = self.Keybind:GetName()
		self.Button.TextColor3 = Theme.GetColor("Text")
	else
		self.Button.Text = self.Keybind:GetName()
		self.Button.TextColor3 = Theme.GetColor("Text")
	end
	
	TweenUtils.Tween(self.Button, {BorderColor3 = Theme.GetColor("Border")}, 0.1)
	
	if self.Config.Callback then
		self.Config.Callback(self.Keybind.key, self.Keybind.type)
	end
end

function Hotkey:CycleType()
	local types = {InputUtils.KeybindType.HOLD, InputUtils.KeybindType.TOGGLE, InputUtils.KeybindType.ALWAYS}
	local currentIndex = 1
	for i, t in ipairs(types) do
		if t == self.Keybind.type then
			currentIndex = i
			break
		end
	end
	
	local nextIndex = currentIndex + 1
	if nextIndex > #types then nextIndex = 1 end
	
	self.Keybind:SetType(types[nextIndex])
	
	if self.TypeLabel then
		self.TypeLabel.Text = "[" .. self.Keybind.type .. "]"
	end
	
	if self.Config.Callback then
		self.Config.Callback(self.Keybind.key, self.Keybind.type)
	end
end

function Hotkey:OpenTypeMenu()
	if self.TypeMenuOpen then return end
	
	self.TypeMenuOpen = true
	
	local screenGui = self.Frame:FindFirstAncestorOfClass("ScreenGui")
	if not screenGui then return end
	
	local buttonPos = self.Button.AbsolutePosition
	
	self.TypeMenu = Instance.new("Frame")
	self.TypeMenu.Name = "HotkeyTypeMenu"
	self.TypeMenu.Size = UDim2.new(0, 100, 0, 90)
	self.TypeMenu.Position = UDim2.new(0, buttonPos.X - 20, 0, buttonPos.Y - 95)
	self.TypeMenu.BackgroundColor3 = Theme.GetColor("PopupBG")
	self.TypeMenu.BorderSizePixel = 1
	self.TypeMenu.BorderColor3 = Theme.GetColor("Border")
	self.TypeMenu.ZIndex = 1000
	self.TypeMenu.Parent = screenGui
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 4)
	corner.Parent = self.TypeMenu
	
	local stroke = Instance.new("UIStroke")
	stroke.Color = Theme.GetColor("ThemeColor")
	stroke.Thickness = 1
	stroke.Parent = self.TypeMenu
	
	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 2)
	layout.Parent = self.TypeMenu
	
	local types = {InputUtils.KeybindType.HOLD, InputUtils.KeybindType.TOGGLE, InputUtils.KeybindType.ALWAYS}
	
	for _, typeName in ipairs(types) do
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, -8, 0, 24)
		btn.BackgroundTransparency = 1
		btn.Text = typeName
		btn.TextColor3 = self.Keybind.type == typeName and Theme.GetColor("ThemeColor") or Theme.GetColor("Text")
		btn.TextSize = 12
		btn.Font = Theme.GetFont()
		btn.TextXAlignment = Enum.TextXAlignment.Left
		btn.Parent = self.TypeMenu
		
		local padding = Instance.new("UIPadding")
		padding.PaddingLeft = UDim.new(0, 8)
		padding.Parent = btn
		
		btn.MouseEnter:Connect(function()
			TweenUtils.Tween(btn, {BackgroundTransparency = 0.9}, 0.1)
			btn.BackgroundColor3 = Theme.GetColor("ThemeColor")
		end)
		
		btn.MouseLeave:Connect(function()
			TweenUtils.Tween(btn, {BackgroundTransparency = 1}, 0.1)
		end)
		
		btn.MouseButton1Click:Connect(function()
			self.Keybind:SetType(typeName)
			if self.TypeLabel then
				self.TypeLabel.Text = "[" .. typeName .. "]"
			end
			if self.Config.Callback then
				self.Config.Callback(self.Keybind.key, self.Keybind.type)
			end
			self:CloseTypeMenu()
		end)
	end
	
	-- Separator + Clear
	local separator = Instance.new("Frame")
	separator.Size = UDim2.new(1, 0, 0, 1)
	separator.BackgroundColor3 = Theme.GetColor("Border")
	separator.BorderSizePixel = 0
	separator.Parent = self.TypeMenu
	
	local clearBtn = Instance.new("TextButton")
	clearBtn.Size = UDim2.new(1, -8, 0, 24)
	clearBtn.BackgroundTransparency = 1
	clearBtn.Text = "Clear"
	clearBtn.TextColor3 = Color3.new(1, 0.3, 0.3)
	clearBtn.TextSize = 12
	clearBtn.Font = Theme.GetFont()
	clearBtn.TextXAlignment = Enum.TextXAlignment.Left
	clearBtn.Parent = self.TypeMenu
	
	local clearPadding = Instance.new("UIPadding")
	clearPadding.PaddingLeft = UDim.new(0, 8)
	clearPadding.Parent = clearBtn
	
	clearBtn.MouseButton1Click:Connect(function()
		self.Keybind:SetKey(Enum.KeyCode.Unknown)
		self.Button.Text = "None"
		self:CloseTypeMenu()
		if self.Config.Callback then
			self.Config.Callback(Enum.KeyCode.Unknown, self.Keybind.type)
		end
	end)
	
	-- Close on click outside
	self.TypeMenuCloseConn = game:GetService("UserInputService").InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			local mousePos = game:GetService("UserInputService"):GetMouseLocation()
			local framePos = self.TypeMenu.AbsolutePosition
			local frameSize = self.TypeMenu.AbsoluteSize
			if mousePos.X < framePos.X or mousePos.X > framePos.X + frameSize.X or
			   mousePos.Y < framePos.Y or mousePos.Y > framePos.Y + frameSize.Y then
				self:CloseTypeMenu()
			end
		end
	end)
end

function Hotkey:CloseTypeMenu()
	if self.TypeMenu then
		self.TypeMenu:Destroy()
		self.TypeMenu = nil
	end
	if self.TypeMenuCloseConn then
		self.TypeMenuCloseConn:Disconnect()
		self.TypeMenuCloseConn = nil
	end
	self.TypeMenuOpen = false
end

function Hotkey:SetKey(keyCode, keybindType)
	self.Keybind:SetKey(keyCode)
	if keybindType then
		self.Keybind:SetType(keybindType)
	end
	self.Button.Text = self.Keybind:GetName()
	
	if self.TypeLabel then
		self.TypeLabel.Text = "[" .. self.Keybind.type .. "]"
	end
end

function Hotkey:GetKey()
	return self.Keybind.key
end

function Hotkey:GetType()
	return self.Keybind.type
end

function Hotkey:IsEnabled()
	return self.Keybind.enabled
end

function Hotkey:UpdateTheme()
	self.Label.TextColor3 = Theme.GetColor("Text")
	self.Label.Font = Theme.GetFont()
	self.Button.BackgroundColor3 = Theme.GetColor("FrameBG")
	self.Button.BorderColor3 = Theme.GetColor("Border")
	self.Button.TextColor3 = Theme.GetColor("Text")
	self.Button.Font = Theme.GetFont()
	
	if self.TypeLabel then
		self.TypeLabel.TextColor3 = Theme.GetColor("TextDisabled")
		self.TypeLabel.Font = Theme.GetFont()
	end
end

function Hotkey:Destroy()
	if self.Listener then self.Listener:Stop() end
	self:CloseTypeMenu()
	self.Frame:Destroy()
end

return Hotkey