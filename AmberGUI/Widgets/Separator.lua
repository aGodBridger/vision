-- AmberGUI Separator Widget

local Theme = require("Theme")

local Separator = {}
Separator.__index = Separator

Separator.DefaultConfig = {
	Text = "",
	Size = UDim2.new(1, 0, 0, 16),
	ShowText = false,
}

function Separator.new(parent, options)
	local self = setmetatable({}, Separator)
	
	self.Config = {}
	for k, v in pairs(Separator.DefaultConfig) do
		self.Config[k] = options and options[k] or v
	end
	
	self:Create(parent)
	return self
end

function Separator:Create(parent)
	self.Frame = Instance.new("Frame")
	self.Frame.Name = "Separator"
	self.Frame.Size = self.Config.Size
	self.Frame.BackgroundTransparency = 1
	self.Frame.Parent = parent
	
	if self.Config.ShowText and self.Config.Text ~= "" then
		-- Left line
		self.LeftLine = Instance.new("Frame")
		self.LeftLine.Name = "LeftLine"
		self.LeftLine.Size = UDim2.new(0.5, -40, 0, 1)
		self.LeftLine.Position = UDim2.new(0, 0, 0.5, 0)
		self.LeftLine.AnchorPoint = Vector2.new(0, 0.5)
		self.LeftLine.BackgroundColor3 = Theme.GetColor("Border")
		self.LeftLine.BorderSizePixel = 0
		self.LeftLine.Parent = self.Frame
		
		-- Text
		self.TextLabel = Instance.new("TextLabel")
		self.TextLabel.Name = "Text"
		self.TextLabel.Size = UDim2.new(0, 80, 1, 0)
		self.TextLabel.Position = UDim2.new(0.5, -40, 0, 0)
		self.TextLabel.BackgroundTransparency = 1
		self.TextLabel.Text = self.Config.Text
		self.TextLabel.TextColor3 = Theme.GetColor("TextDisabled")
		self.TextLabel.TextSize = 11
		self.TextLabel.Font = Theme.GetFont()
		self.TextLabel.TextXAlignment = Enum.TextXAlignment.Center
		self.TextLabel.TextYAlignment = Enum.TextYAlignment.Center
		self.TextLabel.Parent = self.Frame
		
		-- Right line
		self.RightLine = Instance.new("Frame")
		self.RightLine.Name = "RightLine"
		self.RightLine.Size = UDim2.new(0.5, -40, 0, 1)
		self.RightLine.Position = UDim2.new(1, 0, 0.5, 0)
		self.RightLine.AnchorPoint = Vector2.new(1, 0.5)
		self.RightLine.BackgroundColor3 = Theme.GetColor("Border")
		self.RightLine.BorderSizePixel = 0
		self.RightLine.Parent = self.Frame
	else
		-- Simple line
		self.Line = Instance.new("Frame")
		self.Line.Name = "Line"
		self.Line.Size = UDim2.new(1, 0, 0, 1)
		self.Line.Position = UDim2.new(0, 0, 0.5, 0)
		self.Line.AnchorPoint = Vector2.new(0, 0.5)
		self.Line.BackgroundColor3 = Theme.GetColor("Border")
		self.Line.BorderSizePixel = 0
		self.Line.Parent = self.Frame
	end
end

function Separator:UpdateTheme()
	if self.LeftLine then
		self.LeftLine.BackgroundColor3 = Theme.GetColor("Border")
		self.RightLine.BackgroundColor3 = Theme.GetColor("Border")
		self.TextLabel.TextColor3 = Theme.GetColor("TextDisabled")
		self.TextLabel.Font = Theme.GetFont()
	else
		self.Line.BackgroundColor3 = Theme.GetColor("Border")
	end
end

function Separator:Destroy()
	self.Frame:Destroy()
end

return Separator