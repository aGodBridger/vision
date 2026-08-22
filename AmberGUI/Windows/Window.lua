-- AmberGUI Window Module
-- Main window with tab system, matching the C++ overlay design

local Theme = require("Theme")
local TweenUtils = require("Utils.Tween")
local ColorUtils = require("Utils.Color")
local InputUtils = require("Utils.Input")
local AmberGUI = require("Core")

local Window = {}
Window.__index = Window

-- Default window configuration
Window.DefaultConfig = {
	Title = "amber.lol",
	Size = UDim2.new(0, 575, 0, 650),
	MinSize = Vector2.new(575, 650),
	Position = UDim2.new(0.5, 0, 0.5, 0),
	AnchorPoint = Vector2.new(0.5, 0.5),
	Tabs = {"Aimbot", "Silent", "Visual", "Movement", "Players", "Settings"},
	ThemeColor = Theme.GetColor("ThemeColor"),
	Draggable = true,
	Resizable = false,
	ShowCloseButton = false,
}

function Window.new(options)
	local self = setmetatable({}, Window)
	
	-- Merge config
	self.Config = {}
	for k, v in pairs(Window.DefaultConfig) do
		self.Config[k] = options and options[k] or v
	end
	
	-- State
	self.Visible = true
	self.CurrentTab = self.Config.Tabs[1]
	self.TabButtons = {}
	self.TabFrames = {}
	self.Widgets = {}
	self.Dragging = false
	self.DragStart = nil
	self.StartPos = nil
	
	-- Create GUI elements
	self:Create()
	
	-- Register window
	table.insert(AmberGUI.Windows, self)
	AmberGUI.ActiveWindow = self
	
	return self
end

function Window:Create()
	local screenGui = AmberGUI.ScreenGui
	
	-- Main frame
	self.Frame = Instance.new("Frame")
	self.Frame.Name = "MainWindow"
	self.Frame.Size = self.Config.Size
	self.Frame.Position = self.Config.Position
	self.Frame.AnchorPoint = self.Config.AnchorPoint
	self.Frame.BackgroundColor3 = Theme.GetColor("WindowBG")
	self.Frame.BorderSizePixel = 0
	self.Frame.ClipsDescendants = true
	self.Frame.ZIndex = 100
	self.Frame.Parent = screenGui
	
	-- Outer border (2px)
	self.OuterBorder = Instance.new("UIStroke")
	self.OuterBorder.Color = Theme.GetColor("OverlayBorder")
	self.OuterBorder.Thickness = 2
	self.OuterBorder.Transparency = 0
	self.OuterBorder.Parent = self.Frame
	
	-- Inner border (1px)
	self.InnerBorder = Instance.new("Frame")
	self.InnerBorder.Name = "InnerBorder"
	self.InnerBorder.Size = UDim2.new(1, -4, 1, -4)
	self.InnerBorder.Position = UDim2.new(0, 2, 0, 2)
	self.InnerBorder.BackgroundTransparency = 1
	self.InnerBorder.BorderSizePixel = 1
	self.InnerBorder.BorderColor3 = Theme.GetColor("Border")
	self.InnerBorder.ZIndex = 101
	self.InnerBorder.Parent = self.Frame
	
	-- Header gradient background
	self.HeaderBg = Instance.new("Frame")
	self.HeaderBg.Name = "HeaderBg"
	self.HeaderBg.Size = UDim2.new(1, 0, 0, 30)
	self.HeaderBg.Position = UDim2.new(0, 0, 0, 0)
	self.HeaderBg.BackgroundColor3 = Theme.GetColor("WindowBG")
	self.HeaderBg.BorderSizePixel = 0
	self.HeaderBg.ZIndex = 102
	self.HeaderBg.Parent = self.Frame
	
	-- Header gradient (darker top)
	self.HeaderGradient = Instance.new("UIGradient")
	self.HeaderGradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, ColorUtils.Darken(Theme.GetColor("WindowBG"), 0.04)),
		ColorSequenceKeypoint.new(1, Theme.GetColor("WindowBG"))
	}
	self.HeaderGradient.Rotation = 90
	self.HeaderGradient.Parent = self.HeaderBg
	
	-- Header accent line
	self.HeaderAccent = Instance.new("Frame")
	self.HeaderAccent.Name = "HeaderAccent"
	self.HeaderAccent.Size = UDim2.new(1, 0, 0, 2)
	self.HeaderAccent.Position = UDim2.new(0, 0, 0, 30)
	self.HeaderAccent.BackgroundColor3 = Theme.GetColor("ThemeColor")
	self.HeaderAccent.BorderSizePixel = 0
	self.HeaderAccent.ZIndex = 103
	self.HeaderAccent.Parent = self.Frame
	
	-- Title text
	self.TitleLabel = Instance.new("TextLabel")
	self.TitleLabel.Name = "Title"
	self.TitleLabel.Size = UDim2.new(1, -20, 1, 0)
	self.TitleLabel.Position = UDim2.new(0, 10, 0, 0)
	self.TitleLabel.BackgroundTransparency = 1
	self.TitleLabel.Text = self.Config.Title
	self.TitleLabel.TextColor3 = Theme.GetColor("ThemeColor")
	self.TitleLabel.TextSize = 14
	self.TitleLabel.Font = Theme.GetFont()
	self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	self.TitleLabel.TextYAlignment = Enum.TextYAlignment.Center
	self.TitleLabel.ZIndex = 104
	self.TitleLabel.Parent = self.HeaderBg
	
	-- Date/Time label (clickable for timezone)
	self.DateLabel = Instance.new("TextLabel")
	self.DateLabel.Name = "DateTime"
	self.DateLabel.Size = UDim2.new(0, 200, 1, 0)
	self.DateLabel.Position = UDim2.new(1, -210, 0, 0)
	self.DateLabel.BackgroundTransparency = 1
	self.DateLabel.TextColor3 = Theme.GetColor("Text")
	self.DateLabel.TextSize = 13
	self.DateLabel.Font = Theme.GetFont()
	self.DateLabel.TextXAlignment = Enum.TextXAlignment.Right
	self.DateLabel.TextYAlignment = Enum.TextYAlignment.Center
	self.DateLabel.ZIndex = 104
	self.DateLabel.Parent = self.HeaderBg
	
	-- Tab bar container
	self.TabBar = Instance.new("Frame")
	self.TabBar.Name = "TabBar"
	self.TabBar.Size = UDim2.new(1, 0, 0, 21)
	self.TabBar.Position = UDim2.new(0, 0, 0, 32)
	self.TabBar.BackgroundColor3 = Theme.GetColor("WindowBG")
	self.TabBar.BorderSizePixel = 0
	self.TabBar.ZIndex = 105
	self.TabBar.Parent = self.Frame
	
	self.TabBarLayout = Instance.new("UIListLayout")
	self.TabBarLayout.FillDirection = Enum.FillDirection.Horizontal
	self.TabBarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	self.TabBarLayout.VerticalAlignment = Enum.VerticalAlignment.Top
	self.TabBarLayout.Padding = UDim.new(0, 0)
	self.TabBarLayout.Parent = self.TabBar
	
	-- Tab underline (accent line)
	self.TabUnderline = Instance.new("Frame")
	self.TabUnderline.Name = "TabUnderline"
	self.TabUnderline.Size = UDim2.new(0, 0, 0, 1.5)
	self.TabUnderline.BackgroundColor3 = Theme.GetColor("Border")
	self.TabUnderline.BorderSizePixel = 0
	self.TabUnderline.ZIndex = 106
	self.TabUnderline.Parent = self.TabBar
	
	-- Content area
	self.ContentArea = Instance.new("Frame")
	self.ContentArea.Name = "ContentArea"
	self.ContentArea.Size = UDim2.new(1, 0, 1, -53)
	self.ContentArea.Position = UDim2.new(0, 0, 0, 53)
	self.ContentArea.BackgroundTransparency = 1
	self.ContentArea.ZIndex = 110
	self.ContentArea.Parent = self.Frame
	
	-- Create tabs
	for i, tabName in ipairs(self.Config.Tabs) do
		self:CreateTab(tabName, i)
	end
	
	-- Select first tab
	self:SelectTab(self.Config.Tabs[1])
	
	-- Setup dragging
	if self.Config.Draggable then
		self:SetupDragging()
	end
	
	-- Setup date/time update
	task.spawn(function()
		while self.Frame and self.Frame.Parent do
			self:UpdateDateTime()
			task.wait(1)
		end
	end)
end

function Window:CreateTab(name, index)
	-- Tab button
	local button = Instance.new("TextButton")
	button.Name = "Tab_" .. name
	button.Size = UDim2.new(0, 0, 1, 0)
	button.AutomaticSize = Enum.AutomaticSize.X
	button.BackgroundTransparency = 1
	button.Text = name
	button.TextColor3 = Color3.new(0.47, 0.47, 0.47) -- inactive gray
	button.TextSize = 13
	button.Font = Theme.GetFont()
	button.TextXAlignment = Enum.TextXAlignment.Center
	button.TextYAlignment = Enum.TextYAlignment.Center
	button.ZIndex = 106
	button.Parent = self.TabBar
	
	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, 16)
	padding.PaddingRight = UDim.new(0, 16)
	padding.Parent = button
	
	-- Tab content frame
	local content = Instance.new("ScrollingFrame")
	content.Name = "Tab_" .. name
	content.Size = UDim2.new(1, 0, 1, 0)
	content.BackgroundTransparency = 1
	content.BorderSizePixel = 0
	content.ScrollBarThickness = 0
	content.CanvasSize = UDim2.new(0, 0, 0, 0)
	content.AutomaticCanvasSize = Enum.AutomaticSize.Y
	content.Visible = false
	content.ZIndex = 111
	content.Parent = self.ContentArea
	
	local contentLayout = Instance.new("UIListLayout")
	contentLayout.Padding = UDim.new(0, 8)
	contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	contentLayout.Parent = content
	
	local contentPadding = Instance.new("UIPadding")
	contentPadding.PaddingTop = UDim.new(0, 8)
	contentPadding.PaddingLeft = UDim.new(0, 8)
	contentPadding.PaddingRight = UDim.new(0, 8)
	contentPadding.PaddingBottom = UDim.new(0, 8)
	contentPadding.Parent = content
	
	-- Button events
	button.MouseButton1Click:Connect(function()
		self:SelectTab(name)
	end)
	
	button.MouseEnter:Connect(function()
		if self.CurrentTab ~= name then
			TweenUtils.TweenTextColor(button, Color3.new(0.7, 0.7, 0.7), 0.15)
		end
	end)
	
	button.MouseLeave:Connect(function()
		if self.CurrentTab ~= name then
			TweenUtils.TweenTextColor(button, Color3.new(0.47, 0.47, 0.47), 0.15)
		end
	end)
	
	self.TabButtons[name] = button
	self.TabFrames[name] = content
end

function Window:SelectTab(name)
	if not self.TabFrames[name] then return end
	
	-- Update buttons
	for tabName, button in pairs(self.TabButtons) do
		if tabName == name then
			button.TextColor3 = Theme.GetColor("ThemeColor")
			button.TextTransparency = 0
		else
			button.TextColor3 = Color3.new(0.47, 0.47, 0.47)
			button.TextTransparency = 0
		end
	end
	
	-- Update content visibility
	for tabName, frame in pairs(self.TabFrames) do
		frame.Visible = (tabName == name)
	end
	
	-- Animate underline
	local activeButton = self.TabButtons[name]
	if activeButton then
		local targetPos = activeButton.AbsolutePosition.X - self.TabBar.AbsolutePosition.X
		local targetSize = activeButton.AbsoluteSize.X
		
		TweenUtils.Tween(self.TabUnderline, {
			Position = UDim2.new(0, targetPos, 1, -2),
			Size = UDim2.new(0, targetSize, 0, 1.5)
		}, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	end
	
	self.CurrentTab = name
end

function Window:UpdateDateTime()
	if not self.DateLabel or not self.DateLabel.Parent then return end
	
	local now = os.date("*t")
	local months = {"jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec"}
	local month = months[now.month] or "jan"
	local ampm = now.hour >= 12 and "pm" or "am"
	local hour12 = now.hour % 12
	if hour12 == 0 then hour12 = 12 end
	
	self.DateLabel.Text = string.format("%s. %02d. %d | %02d:%02d %s", month, now.day, now.year, hour12, now.min, ampm)
end

function Window:SetupDragging()
	local header = self.HeaderBg
	
	header.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			self.Dragging = true
			self.DragStart = input.Position
			self.StartPos = self.Frame.Position
		end
	end)
	
	header.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement and self.Dragging then
			local delta = input.Position - self.DragStart
			self.Frame.Position = UDim2.new(
				self.StartPos.X.Scale, self.StartPos.X.Offset + delta.X,
				self.StartPos.Y.Scale, self.StartPos.Y.Offset + delta.Y
			)
		end
	end)
	
	header.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			self.Dragging = false
		end
	end)
	
	-- Also allow dragging from tab bar
	self.TabBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			self.Dragging = true
			self.DragStart = input.Position
			self.StartPos = self.Frame.Position
		end
	end)
	
	self.TabBar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement and self.Dragging then
			local delta = input.Position - self.DragStart
			self.Frame.Position = UDim2.new(
				self.StartPos.X.Scale, self.StartPos.X.Offset + delta.X,
				self.StartPos.Y.Scale, self.StartPos.Y.Offset + delta.Y
			)
		end
	end)
	
	self.TabBar.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			self.Dragging = false
		end
	end)
end

-- Add a widget to a tab
function Window:AddWidget(tabName, widget)
	if not self.TabFrames[tabName] then return end
	widget.Parent = self.TabFrames[tabName]
	table.insert(self.Widgets, widget)
	return widget
end

-- Create a child panel (like ImGui BeginChild)
function Window:CreateChild(tabName, options)
	local Child = require("Widgets.Child")
	return Child.new(self.TabFrames[tabName], options)
end

-- Show/hide window
function Window:SetVisible(visible)
	self.Visible = visible
	self.Frame.Visible = visible
end

function Window:Toggle()
	self:SetVisible(not self.Visible)
end

-- Update theme colors
function Window:UpdateTheme()
	self.Frame.BackgroundColor3 = Theme.GetColor("WindowBG")
	self.OuterBorder.Color = Theme.GetColor("OverlayBorder")
	self.InnerBorder.BorderColor3 = Theme.GetColor("Border")
	self.HeaderBg.BackgroundColor3 = Theme.GetColor("WindowBG")
	self.HeaderGradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, ColorUtils.Darken(Theme.GetColor("WindowBG"), 0.04)),
		ColorSequenceKeypoint.new(1, Theme.GetColor("WindowBG"))
	}
	self.HeaderAccent.BackgroundColor3 = Theme.GetColor("ThemeColor")
	self.TitleLabel.TextColor3 = Theme.GetColor("ThemeColor")
	self.DateLabel.TextColor3 = Theme.GetColor("Text")
	self.TabBar.BackgroundColor3 = Theme.GetColor("WindowBG")
	self.TabUnderline.BackgroundColor3 = Theme.GetColor("Border")
	
	for name, button in pairs(self.TabButtons) do
		if name == self.CurrentTab then
			button.TextColor3 = Theme.GetColor("ThemeColor")
		else
			button.TextColor3 = Color3.new(0.47, 0.47, 0.47)
		end
		button.Font = Theme.GetFont()
	end
	
	self.TitleLabel.Font = Theme.GetFont()
	self.DateLabel.Font = Theme.GetFont()
end

function Window:Destroy()
	for i, w in ipairs(AmberGUI.Windows) do
		if w == self then
			table.remove(AmberGUI.Windows, i)
			break
		end
	end
	if AmberGUI.ActiveWindow == self then
		AmberGUI.ActiveWindow = AmberGUI.Windows[1] or nil
	end
	self.Frame:Destroy()
end

return Window