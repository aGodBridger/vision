-- AmberGUI Checkbox Widget
-- Matches ImGui checkbox with custom styling

local Theme = require("Theme")
local TweenUtils = require("Utils.Tween")

local Checkbox = {}
Checkbox.__index = Checkbox

Checkbox.DefaultConfig = {
	Text = "Checkbox",
	Default = false,
	Size = UDim2.new(1, 0, 0, 24),
	BoxSize = 16,
	Callback = nil,
	TextColor3 = nil,
}

function Checkbox.new(parent, options)
	local self = setmetatable({}, Checkbox)
	
	self.Config = {}
	for k, v in pairs(Checkbox.DefaultConfig) do
		self.Config[k] = options and options[k] or v
	end
	
	self.Value = self.Config.Default
	
	self:Create(parent)
	return self
end

function Checkbox:Create(parent)
	self.Frame = Instance.new("Frame")
	self.Frame.Name = "Checkbox"
	self.Frame.Size = self.Config.Size
	self.Frame.BackgroundTransparency = 1
	self.Frame.Parent = parent
	
	-- Checkbox box
	self.Box = Instance.new("Frame")
	self.Box.Name = "Box"
	self.Box.Size = UDim2.new(0, self.Config.BoxSize, 0, self.Config.BoxSize)
	self.Box.Position = UDim2.new(0, 0, 0.5, -self.Config.BoxSize/2)
	self.Box.BackgroundColor3 = Theme.GetColor("FrameBG")
	self.Box.BorderSizePixel = 1
	self.Box.BorderColor3 = Theme.GetColor("Border")
	self.Box.Parent = self.Frame
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 3)
	corner.Parent = self.Box
	
	-- Check mark
	self.Check = Instance.new("ImageLabel")
	self.Check.Name = "Check"
	self.Check.Size = UDim2.new(0, 12, 0, 12)
	self.Check.Position = UDim2.new(0.5, -6, 0.5, -6)
	self.Check.BackgroundTransparency = 1
	self.Check.Image = "rbxassetid://3926305904" -- Checkmark icon
	self.Check.ImageColor3 = Theme.GetColor("CheckMark")
	self.Check.ImageTransparency = self.Value and 0 or 1
	self.Check.ScaleType = Enum.ScaleType.Fit
	self.Check.Parent = self.Box
	
	-- Label
	self.Label = Instance.new("TextLabel")
	self.Label.Name = "Label"
	self.Label.Size = UDim2.new(1, -self.Config.BoxSize - 8, 1, 0)
	self.Label.Position = UDim2.new(0, self.Config.BoxSize + 8, 0, 0)
	self.Label.BackgroundTransparency = 1
	self.Label.Text = self.Config.Text
	self.Label.TextColor3 = self.Config.TextColor3 or Theme.GetColor("Text")
	self.Label.TextSize = 13
	self.Label.Font = Theme.GetFont()
	self.Label.TextXAlignment = Enum.TextXAlignment.Left
	self.Label.TextYAlignment = Enum.TextYAlignment.Center
	self.Label.Parent = self.Frame
	
	-- Click detector (invisible button over entire row)
	self.ClickArea = Instance.new("TextButton")
	self.ClickArea.Name = "ClickArea"
	self.ClickArea.Size = UDim2.new(1, 0, 1, 0)
	self.ClickArea.BackgroundTransparency = 1
	self.ClickArea.Text = ""
	self.ClickArea.ZIndex = 10
	self.ClickArea.Parent = self.Frame
	
	self.ClickArea.MouseButton1Click:Connect(function()
		self:SetValue(not self.Value)
	end)
	
	-- Hover effect
	self.ClickArea.MouseEnter:Connect(function()
		TweenUtils.Tween(self.Box, {BorderColor3 = Theme.GetColor("ThemeColor")}, 0.1)
	end)
	
	self.ClickArea.MouseLeave:Connect(function()
		TweenUtils.Tween(self.Box, {BorderColor3 = Theme.GetColor("Border")}, 0.1)
	end)
	
	-- Initial state
	self:UpdateVisuals()
end

function Checkbox:SetValue(value)
	self.Value = value
	self:UpdateVisuals()
	if self.Config.Callback then
		self.Config.Callback(value)
	end
end

function Checkbox:GetValue()
	return self.Value
end

function Checkbox:UpdateVisuals()
	self.Check.ImageTransparency = self.Value and 0 or 1
	
	if self.Value then
		self.Box.BackgroundColor3 = Theme.GetColor("FrameBGActive")
		self.Box.BorderColor3 = Theme.GetColor("ThemeColor")
	else
		self.Box.BackgroundColor3 = Theme.GetColor("FrameBG")
		self.Box.BorderColor3 = Theme.GetColor("Border")
	end
end

function Checkbox:SetText(text)
	self.Config.Text = text
	self.Label.Text = text
end

function Checkbox:UpdateTheme()
	self.Box.BackgroundColor3 = self.Value and Theme.GetColor("FrameBGActive") or Theme.GetColor("FrameBG")
	self.Box.BorderColor3 = self.Value and Theme.GetColor("ThemeColor") or Theme.GetColor("Border")
	self.Check.ImageColor3 = Theme.GetColor("CheckMark")
	self.Label.TextColor3 = self.Config.TextColor3 or Theme.GetColor("Text")
	self.Label.Font = Theme.GetFont()
end

function Checkbox:Destroy()
	self.Frame:Destroy()
end

return Checkbox