-- AmberGUI Label Widget

local Theme = require("Theme")
local TweenUtils = require("Utils.Tween")

local Label = {}
Label.__index = Label

Label.DefaultConfig = {
	Text = "Label",
	TextColor3 = nil,
	TextSize = 13,
	Font = nil,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextYAlignment = Enum.TextYAlignment.Center,
	Size = UDim2.new(1, 0, 0, 20),
}

function Label.new(parent, options)
	local self = setmetatable({}, Label)
	
	self.Config = {}
	for k, v in pairs(Label.DefaultConfig) do
		self.Config[k] = options and options[k] or v
	end
	
	self:Create(parent)
	return self
end

function Label:Create(parent)
	self.Frame = Instance.new("TextLabel")
	self.Frame.Name = "Label"
	self.Frame.Size = self.Config.Size
	self.Frame.BackgroundTransparency = 1
	self.Frame.Text = self.Config.Text
	self.Frame.TextColor3 = self.Config.TextColor3 or Theme.GetColor("Text")
	self.Frame.TextSize = self.Config.TextSize
	self.Frame.Font = self.Config.Font or Theme.GetFont()
	self.Frame.TextXAlignment = self.Config.TextXAlignment
	self.Frame.TextYAlignment = self.Config.TextYAlignment
	self.Frame.Parent = parent
end

function Label:SetText(text)
	self.Config.Text = text
	self.Frame.Text = text
end

function Label:SetColor(color)
	self.Frame.TextColor3 = color
end

function Label:UpdateTheme()
	self.Frame.TextColor3 = self.Config.TextColor3 or Theme.GetColor("Text")
	self.Frame.Font = self.Config.Font or Theme.GetFont()
end

function Label:Destroy()
	self.Frame:Destroy()
end

return Label