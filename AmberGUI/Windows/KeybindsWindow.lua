-- AmberGUI Keybinds Window
-- Floating keybinds list overlay

local Theme = require("Theme")
local TweenUtils = require("Utils.Tween")
local InputUtils = require("Utils.Input")

local KeybindsWindow = {}
KeybindsWindow.__index = KeybindsWindow

KeybindsWindow.DefaultConfig = {
	Title = "Keybinds",
	Size = UDim2.new(0, 180, 0, 0),
	Position = UDim2.new(0, 20, 0, 100),
	AutoSize = true,
}

function KeybindsWindow.new(options)
	local self = setmetatable({}, KeybindsWindow)
	
	self.Config = {}
	for k, v in pairs(KeybindsWindow.DefaultConfig) do
		self.Config[k] = options and options[k] or v
	end
	
	self.Visible = true
	self.Keybinds = {}
	
	self:Create()
	return self
end

function KeybindsWindow:Create()
	local screenGui = AmberGUI.ScreenGui
	if not screenGui then return end
	
	self.Frame = Instance.new("Frame")
	self.Frame.Name = "KeybindsWindow"
	self.Frame.Size = self.Config.Size
	self.Frame.Position = self.Config.Position
	self.Frame.BackgroundColor3 = Theme.GetColor("WindowBG")
	self.Frame.BorderSizePixel = 0
	self.Frame.ClipsDescendants = true
	self.Frame.Visible = false
	self.Frame.ZIndex = 200
	self.Frame.Parent = screenGui
	
	-- Outer border
	local stroke = Instance.new("UIStroke")
	stroke.Color = Theme.GetColor("OverlayBorder")
	stroke.Thickness = 2
	stroke.Parent = self.Frame
	
	-- Title bar
	self.TitleBar = Instance.new("Frame")
	self.TitleBar.Name = "TitleBar"
	self.TitleBar.Size = UDim2.new(1, 0, 0, 20)
	self.TitleBar.BackgroundColor3 = Theme.GetColor("Child")
	self.TitleBar.BorderSizePixel = 0
	self.TitleBar.Parent = self.Frame
	
	-- Accent line
	self.AccentLine = Instance.new("Frame")
	self.AccentLine.Size = UDim2.new(0, 2, 1, 0)
	self.AccentLine.BackgroundColor3 = Theme.GetColor("ThemeColor")
	self.AccentLine.BorderSizePixel = 0
	self.AccentLine.Parent = self.TitleBar
	
	-- Title text
	self.TitleLabel = Instance.new("TextLabel")
	self.TitleLabel.Size = UDim2.new(1, -16, 1, 0)
	self.TitleLabel.Position = UDim2.new(0, 8, 0, 0)
	self.TitleLabel.BackgroundTransparency = 1
	self.TitleLabel.Text = self.Config.Title
	self.TitleLabel.TextColor3 = Theme.GetColor("Text")
	self.TitleLabel.TextSize = 13
	self.TitleLabel.Font = Theme.GetFont()
	self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	self.TitleLabel.TextYAlignment = Enum.TextYAlignment.Center
	self.TitleLabel.Parent = self.TitleBar
	
	-- Separator
	local separator = Instance.new("Frame")
	separator.Size = UDim2.new(1, 0, 0, 1)
	separator.Position = UDim2.new(0, 0, 0, 20)
	separator.BackgroundColor3 = Theme.GetColor("Border")
	separator.BorderSizePixel = 0
	separator.Parent = self.Frame
	
	-- Content area
	self.Content = Instance.new("Frame")
	self.Content.Name = "Content"
	self.Content.Size = UDim2.new(1, 0, 1, -22)
	self.Content.Position = UDim2.new(0, 0, 0, 22)
	self.Content.BackgroundTransparency = 1
	self.Content.Parent = self.Frame
	
	self.ContentLayout = Instance.new("UIListLayout")
	self.ContentLayout.Padding = UDim.new(0, 2)
	self.ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	self.ContentLayout.Parent = self.Content
	
	self.ContentPadding = Instance.new("UIPadding")
	self.ContentPadding.PaddingTop = UDim.new(0, 4)
	self.ContentPadding.PaddingLeft = UDim.new(0, 8)
	self.ContentPadding.PaddingRight = UDim.new(0, 8)
	self.ContentPadding.PaddingBottom = UDim.new(0, 4)
	self.ContentPadding.Parent = self.Content
	
	-- Dragging
	self:SetupDragging()
end

function KeybindsWindow:SetupDragging()
	self.Dragging = false
	self.DragStart = nil
	self.StartPos = nil
	
	self.TitleBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			self.Dragging = true
			self.DragStart = input.Position
			self.StartPos = self.Frame.Position
		end
	end)
	
	self.TitleBar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement and self.Dragging then
			local delta = input.Position - self.DragStart
			self.Frame.Position = UDim2.new(
				self.StartPos.X.Scale, self.StartPos.X.Offset + delta.X,
				self.StartPos.Y.Scale, self.StartPos.Y.Offset + delta.Y
			)
		end
	end)
	
	self.TitleBar.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			self.Dragging = false
		end
	end)
end

function KeybindsWindow:AddKeybind(name, keybind)
	local entry = Instance.new("Frame")
	entry.Name = "Keybind_" .. name
	entry.Size = UDim2.new(1, 0, 0, 18)
	entry.BackgroundTransparency = 1
	entry.Parent = self.Content
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -60, 1, 0)
	label.Position = UDim2.new(0, 0, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = name
	label.TextColor3 = keybind.enabled and Theme.GetColor("ThemeColor") or Color3.new(0.6, 0.6, 0.6)
	label.TextSize = 12
	label.Font = Theme.GetFont()
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextYAlignment = Enum.TextYAlignment.Center
	label.Parent = entry
	
	local keyText = Instance.new("TextLabel")
	keyText.Name = "KeyText"
	keyText.Size = UDim2.new(0, 50, 1, 0)
	keyText.Position = UDim2.new(1, -50, 0, 0)
	keyText.BackgroundTransparency = 1
	keyText.Text = keybind:GetName()
	keyText.TextColor3 = keybind.enabled and Theme.GetColor("ThemeColor") or Color3.new(0.6, 0.6, 0.6)
	keyText.TextSize = 12
	keyText.Font = Theme.GetFont()
	keyText.TextXAlignment = Enum.TextXAlignment.Right
	keyText.TextYAlignment = Enum.TextYAlignment.Center
	keyText.Parent = entry
	
	self.Keybinds[name] = {frame = entry, label = label, keyText = keyText, keybind = keybind}
	
	self:UpdateSize()
	return entry
end

function KeybindsWindow:UpdateKeybind(name, keybind)
	local data = self.Keybinds[name]
	if data then
		data.keybind = keybind
		data.label.TextColor3 = keybind.enabled and Theme.GetColor("ThemeColor") or Color3.new(0.6, 0.6, 0.6)
		data.keyText.Text = keybind:GetName()
		data.keyText.TextColor3 = keybind.enabled and Theme.GetColor("ThemeColor") or Color3.new(0.6, 0.6, 0.6)
	end
end

function KeybindsWindow:RemoveKeybind(name)
	local data = self.Keybinds[name]
	if data then
		data.frame:Destroy()
		self.Keybinds[name] = nil
		self:UpdateSize()
	end
end

function KeybindsWindow:UpdateSize()
	local contentHeight = self.ContentLayout.AbsoluteContentSize.Y + 10
	self.Frame.Size = UDim2.new(0, 180, 0, contentHeight + 22)
end

function KeybindsWindow:SetVisible(visible)
	self.Visible = visible
	self.Frame.Visible = visible
end

function KeybindsWindow:Toggle()
	self:SetVisible(not self.Visible)
end

function KeybindsWindow:UpdateTheme()
	self.Frame.BackgroundColor3 = Theme.GetColor("WindowBG")
	self.TitleBar.BackgroundColor3 = Theme.GetColor("Child")
	self.AccentLine.BackgroundColor3 = Theme.GetColor("ThemeColor")
	self.TitleLabel.TextColor3 = Theme.GetColor("Text")
	self.TitleLabel.Font = Theme.GetFont()
	
	for _, data in pairs(self.Keybinds) do
		data.label.TextColor3 = data.keybind.enabled and Theme.GetColor("ThemeColor") or Color3.new(0.6, 0.6, 0.6)
		data.label.Font = Theme.GetFont()
		data.keyText.TextColor3 = data.keybind.enabled and Theme.GetColor("ThemeColor") or Color3.new(0.6, 0.6, 0.6)
		data.keyText.Font = Theme.GetFont()
	end
end

function KeybindsWindow:Destroy()
	self.Frame:Destroy()
end

return KeybindsWindow