-- AmberGUI Child Panel Widget
-- Replicates ImGui::BeginChild with border, background, and title bar

local Theme = require("Theme")
local TweenUtils = require("Utils.Tween")
local ColorUtils = require("Utils.Color")

local Child = {}
Child.__index = Child

Child.DefaultConfig = {
	Title = "",
	Size = UDim2.new(1, 0, 1, 0),
	BackgroundColor3 = nil, -- Uses theme Child color
	BorderColor3 = nil,     -- Uses theme Border color
	AccentColor = nil,      -- Uses theme ThemeColor
	ShowTitle = true,
	TitleHeight = 20,
	Rounded = false,
	AutoHeight = false,
}

function Child.new(parent, options)
	local self = setmetatable({}, Child)
	
	self.Config = {}
	for k, v in pairs(Child.DefaultConfig) do
		self.Config[k] = options and options[k] or v
	end
	
	self.Widgets = {}
	self.LayoutOrder = 0
	
	self:Create(parent)
	return self
end

function Child:Create(parent)
	-- Main frame
	self.Frame = Instance.new("Frame")
	self.Frame.Name = "Child_" .. self.Config.Title
	self.Frame.Size = self.Config.Size
	self.Frame.BackgroundColor3 = self.Config.BackgroundColor3 or Theme.GetColor("Child")
	self.Frame.BorderSizePixel = 0
	self.Frame.ClipsDescendants = true
	self.Frame.Parent = parent
	
	if self.Config.Rounded then
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 4)
		corner.Parent = self.Frame
	end
	
	-- Border stroke
	self.Border = Instance.new("UIStroke")
	self.Border.Color = self.Config.BorderColor3 or Theme.GetColor("Border")
	self.Border.Thickness = 1
	self.Border.Parent = self.Frame
	
	-- Title bar
	if self.Config.ShowTitle and self.Config.Title ~= "" then
		self.TitleBar = Instance.new("Frame")
		self.TitleBar.Name = "TitleBar"
		self.TitleBar.Size = UDim2.new(1, 0, 0, self.Config.TitleHeight)
		self.TitleBar.BackgroundColor3 = self.Config.BackgroundColor3 or Theme.GetColor("Child")
		self.TitleBar.BorderSizePixel = 0
		self.TitleBar.Parent = self.Frame
		
		-- Title accent line (top)
		self.TitleAccent = Instance.new("Frame")
		self.TitleAccent.Name = "TitleAccent"
		self.TitleAccent.Size = UDim2.new(1, 0, 0, 2)
		self.TitleAccent.BackgroundColor3 = self.Config.AccentColor or Theme.GetColor("ThemeColor")
		self.TitleAccent.BorderSizePixel = 0
		self.TitleAccent.Parent = self.TitleBar
		
		-- Title shadow
		self.TitleShadow = Instance.new("Frame")
		self.TitleShadow.Name = "TitleShadow"
		self.TitleShadow.Size = UDim2.new(1, 0, 0, 2)
		self.TitleShadow.Position = UDim2.new(0, 0, 0, 2)
		self.TitleShadow.BackgroundColor3 = self.Config.AccentColor or Theme.GetColor("ThemeColor")
		self.TitleShadow.BackgroundTransparency = 0.8
		self.TitleShadow.BorderSizePixel = 0
		self.TitleShadow.Parent = self.TitleBar
		
		-- Title text
		self.TitleLabel = Instance.new("TextLabel")
		self.TitleLabel.Name = "Title"
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
		
		-- Content area (below title)
		self.Content = Instance.new("ScrollingFrame")
		self.Content.Name = "Content"
		self.Content.Size = UDim2.new(1, 0, 1, -self.Config.TitleHeight)
		self.Content.Position = UDim2.new(0, 0, 0, self.Config.TitleHeight)
		self.Content.BackgroundTransparency = 1
		self.Content.BorderSizePixel = 0
		self.Content.ScrollBarThickness = 0
		self.Content.CanvasSize = UDim2.new(0, 0, 0, 0)
		self.Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
		self.Content.Parent = self.Frame
	else
		-- Content area (full size)
		self.Content = Instance.new("ScrollingFrame")
		self.Content.Name = "Content"
		self.Content.Size = UDim2.new(1, 0, 1, 0)
		self.Content.BackgroundTransparency = 1
		self.Content.BorderSizePixel = 0
		self.Content.ScrollBarThickness = 0
		self.Content.CanvasSize = UDim2.new(0, 0, 0, 0)
		self.Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
		self.Content.Parent = self.Frame
	end
	
	-- Content layout
	self.ContentLayout = Instance.new("UIListLayout")
	self.ContentLayout.Padding = UDim.new(0, 6)
	self.ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	self.ContentLayout.Parent = self.Content
	
	self.ContentPadding = Instance.new("UIPadding")
	self.ContentPadding.PaddingTop = UDim.new(0, 6)
	self.ContentPadding.PaddingLeft = UDim.new(0, 8)
	self.ContentPadding.PaddingRight = UDim.new(0, 8)
	self.ContentPadding.PaddingBottom = UDim.new(0, 6)
	self.ContentPadding.Parent = self.Content
	
	-- Auto-size handling
	if self.Config.AutoHeight then
		self.ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			self.Frame.Size = UDim2.new(
				self.Config.Size.X.Scale, self.Config.Size.X.Offset,
				0, self.ContentLayout.AbsoluteContentSize.Y + 
					(self.Config.ShowTitle and self.Config.TitleHeight or 0) + 12
			)
		end)
	end
end

function Child:AddWidget(widget)
	widget.Parent = self.Content
	self.LayoutOrder = self.LayoutOrder + 1
	if widget.Frame then
		widget.Frame.LayoutOrder = self.LayoutOrder
	end
	table.insert(self.Widgets, widget)
	return widget
end

-- Convenience methods for creating widgets
function Child:AddLabel(text)
	local Label = require("Label")
	return self:AddWidget(Label.new(self.Content, {Text = text}))
end

function Child:AddButton(text, callback)
	local Button = require("Button")
	return self:AddWidget(Button.new(self.Content, {Text = text, Callback = callback}))
end

function Child:AddCheckbox(text, default, callback)
	local Checkbox = require("Checkbox")
	return self:AddWidget(Checkbox.new(self.Content, {Text = text, Default = default, Callback = callback}))
end

function Child:AddSlider(text, min, max, default, callback, format)
	local Slider = require("Slider")
	return self:AddWidget(Slider.new(self.Content, {Text = text, Min = min, Max = max, Default = default, Callback = callback, Format = format}))
end

function Child:AddColorPicker(text, default, callback)
	local ColorPicker = require("ColorPicker")
	return self:AddWidget(ColorPicker.new(self.Content, {Text = text, Default = default, Callback = callback}))
end

function Child:AddCombo(text, items, default, callback)
	local Combo = require("Combo")
	return self:AddWidget(Combo.new(self.Content, {Text = text, Items = items, Default = default, Callback = callback}))
end

function Child:AddInput(text, default, callback, placeholder)
	local Input = require("Input")
	return self:AddWidget(Input.new(self.Content, {Text = text, Default = default, Callback = callback, Placeholder = placeholder}))
end

function Child:AddHotkey(text, default, callback)
	local Hotkey = require("Hotkey")
	return self:AddWidget(Hotkey.new(self.Content, {Text = text, Default = default, Callback = callback}))
end

function Child:AddSeparator()
	local Separator = require("Separator")
	return self:AddWidget(Separator.new(self.Content))
end

function Child:AddSpacing(amount)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 0, amount or 6)
	frame.BackgroundTransparency = 1
	frame.Parent = self.Content
	self.LayoutOrder = self.LayoutOrder + 1
	frame.LayoutOrder = self.LayoutOrder
	return frame
end

function Child:UpdateTheme()
	self.Frame.BackgroundColor3 = self.Config.BackgroundColor3 or Theme.GetColor("Child")
	self.Border.Color = self.Config.BorderColor3 or Theme.GetColor("Border")
	
	if self.TitleBar then
		self.TitleBar.BackgroundColor3 = self.Config.BackgroundColor3 or Theme.GetColor("Child")
		self.TitleAccent.BackgroundColor3 = self.Config.AccentColor or Theme.GetColor("ThemeColor")
		self.TitleShadow.BackgroundColor3 = self.Config.AccentColor or Theme.GetColor("ThemeColor")
		self.TitleLabel.TextColor3 = Theme.GetColor("Text")
		self.TitleLabel.Font = Theme.GetFont()
	end
	
	for _, widget in ipairs(self.Widgets) do
		if widget.UpdateTheme then
			widget:UpdateTheme()
		end
	end
end

function Child:SetTitle(title)
	self.Config.Title = title
	if self.TitleLabel then
		self.TitleLabel.Text = title
	end
end

function Child:SetVisible(visible)
	self.Frame.Visible = visible
end

function Child:Destroy()
	self.Frame:Destroy()
end

return Child