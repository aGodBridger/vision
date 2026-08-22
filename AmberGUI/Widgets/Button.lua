-- AmberGUI Button Widget
-- Supports colored buttons with gradient, matching the C++ ColoredButtonV1

local Theme = require("Theme")
local TweenUtils = require("Utils.Tween")
local ColorUtils = require("Utils.Color")

local Button = {}
Button.__index = Button

Button.DefaultConfig = {
	Text = "Button",
	Size = UDim2.new(1, 0, 0, 28),
	TextColor3 = Color3.new(1, 1, 1),
	BackgroundColor3 = nil,        -- Uses theme Button color
	BackgroundColorHovered = nil,  -- Uses theme ButtonHovered
	BackgroundColorActive = nil,   -- Uses theme ButtonActive
	GradientColor = nil,           -- Optional second color for gradient
	TextSize = 13,
	Font = nil,
	Callback = nil,
	Rounded = false,
	CornerRadius = 4,
}

function Button.new(parent, options)
	local self = setmetatable({}, Button)
	
	self.Config = {}
	for k, v in pairs(Button.DefaultConfig) do
		self.Config[k] = options and options[k] or v
	end
	
	self.Hovered = false
	self.Pressed = false
	
	self:Create(parent)
	return self
end

function Button:Create(parent)
	self.Frame = Instance.new("TextButton")
	self.Frame.Name = "Button"
	self.Frame.Size = self.Config.Size
	self.Frame.BackgroundColor3 = self.Config.BackgroundColor3 or Theme.GetColor("Button")
	self.Frame.BorderSizePixel = 0
	self.Frame.Text = self.Config.Text
	self.Frame.TextColor3 = self.Config.TextColor3
	self.Frame.TextSize = self.Config.TextSize
	self.Frame.Font = self.Config.Font or Theme.GetFont()
	self.Frame.AutoButtonColor = false
	self.Frame.Parent = parent
	
	if self.Config.Rounded then
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, self.Config.CornerRadius)
		corner.Parent = self.Frame
	end
	
	-- Gradient support
	if self.Config.GradientColor then
		self.Gradient = Instance.new("UIGradient")
		self.Gradient.Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0, self.Frame.BackgroundColor3),
			ColorSequenceKeypoint.new(1, self.Config.GradientColor)
		}
		self.Gradient.Rotation = 90
		self.Gradient.Parent = self.Frame
	end
	
	-- Border
	self.Border = Instance.new("UIStroke")
	self.Border.Color = Theme.GetColor("Border")
	self.Border.Thickness = 1
	self.Border.Transparency = 0.5
	self.Border.Parent = self.Frame
	
	-- Events
	self.Frame.MouseEnter:Connect(function()
		self.Hovered = true
		self:UpdateVisuals()
	end)
	
	self.Frame.MouseLeave:Connect(function()
		self.Hovered = false
		self.Pressed = false
		self:UpdateVisuals()
	end)
	
	self.Frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			self.Pressed = true
			self:UpdateVisuals()
		end
	end)
	
	self.Frame.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			self.Pressed = false
			self:UpdateVisuals()
		end
	end)
	
	self.Frame.MouseButton1Click:Connect(function()
		if self.Config.Callback then
			self.Config.Callback()
		end
	end)
end

function Button:UpdateVisuals()
	local targetColor
	
	if self.Pressed then
		targetColor = self.Config.BackgroundColorActive or Theme.GetColor("ButtonActive")
	elseif self.Hovered then
		targetColor = self.Config.BackgroundColorHovered or Theme.GetColor("ButtonHovered")
	else
		targetColor = self.Config.BackgroundColor3 or Theme.GetColor("Button")
	end
	
	TweenUtils.Tween(self.Frame, {BackgroundColor3 = targetColor}, 0.1)
	
	if self.Gradient and self.Config.GradientColor then
		local endColor = self.Config.GradientColor
		if self.Pressed then
			endColor = ColorUtils.Darken(endColor, 0.1)
		elseif self.Hovered then
			endColor = ColorUtils.Lighten(endColor, 0.05)
		end
		TweenUtils.Tween(self.Gradient, {
			Color = ColorSequence.new{
				ColorSequenceKeypoint.new(0, targetColor),
				ColorSequenceKeypoint.new(1, endColor)
			}
		}, 0.1)
	end
end

function Button:SetText(text)
	self.Config.Text = text
	self.Frame.Text = text
end

function Button:SetCallback(callback)
	self.Config.Callback = callback
end

function Button:UpdateTheme()
	self.Frame.BackgroundColor3 = self.Config.BackgroundColor3 or Theme.GetColor("Button")
	self.Frame.TextColor3 = self.Config.TextColor3
	self.Frame.Font = self.Config.Font or Theme.GetFont()
	self.Border.Color = Theme.GetColor("Border")
	
	if self.Gradient and self.Config.GradientColor then
		self.Gradient.Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0, self.Frame.BackgroundColor3),
			ColorSequenceKeypoint.new(1, self.Config.GradientColor)
		}
	end
end

function Button:Destroy()
	self.Frame:Destroy()
end

return Button