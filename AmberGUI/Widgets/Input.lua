-- AmberGUI Input Widget
-- Text input with placeholder, matching ImGui::InputText

local Theme = require("Theme")
local TweenUtils = require("Utils.Tween")

local Input = {}
Input.__index = Input

Input.DefaultConfig = {
	Text = "Input",
	Default = "",
	Placeholder = "",
	Callback = nil,
	Size = UDim2.new(1, 0, 0, 36),
	Numeric = false,
	MaxLength = 0,
}

function Input.new(parent, options)
	local self = setmetatable({}, Input)
	
	self.Config = {}
	for k, v in pairs(Input.DefaultConfig) do
		self.Config[k] = options and options[k] or v
	end
	
	self.Value = self.Config.Default
	self.Focused = false
	
	self:Create(parent)
	return self
end

function Input:Create(parent)
	self.Frame = Instance.new("Frame")
	self.Frame.Name = "Input"
	self.Frame.Size = self.Config.Size
	self.Frame.BackgroundTransparency = 1
	self.Frame.Parent = parent
	
	-- Label
	self.Label = Instance.new("TextLabel")
	self.Label.Name = "Label"
	self.Label.Size = UDim2.new(1, 0, 0, 18)
	self.Label.BackgroundTransparency = 1
	self.Label.Text = self.Config.Text
	self.Label.TextColor3 = Theme.GetColor("Text")
	self.Label.TextSize = 13
	self.Label.Font = Theme.GetFont()
	self.Label.TextXAlignment = Enum.TextXAlignment.Left
	self.Label.TextYAlignment = Enum.TextYAlignment.Center
	self.Label.Parent = self.Frame
	
	-- Text box
	self.TextBox = Instance.new("TextBox")
	self.TextBox.Name = "TextBox"
	self.TextBox.Size = UDim2.new(1, 0, 0, 24)
	self.TextBox.Position = UDim2.new(0, 0, 0, 20)
	self.TextBox.BackgroundColor3 = Theme.GetColor("FrameBG")
	self.TextBox.BorderSizePixel = 1
	self.TextBox.BorderColor3 = Theme.GetColor("Border")
	self.TextBox.Text = self.Value
	self.TextBox.PlaceholderText = self.Config.Placeholder
	self.TextBox.PlaceholderColor3 = Theme.GetColor("TextDisabled")
	self.TextBox.TextColor3 = Theme.GetColor("Text")
	self.TextBox.TextSize = 13
	self.TextBox.Font = Theme.GetFont()
	self.TextBox.TextXAlignment = Enum.TextXAlignment.Left
	self.TextBox.ClearTextOnFocus = false
	self.TextBox.Parent = self.Frame
	
	if self.Config.MaxLength > 0 then
		self.TextBox.MaxVisibleGraphemes = self.Config.MaxLength
	end
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 3)
	corner.Parent = self.TextBox
	
	-- Events
	self.TextBox.Focused:Connect(function()
		self.Focused = true
		TweenUtils.Tween(self.TextBox, {BorderColor3 = Theme.GetColor("ThemeColor")}, 0.1)
	end)
	
	self.TextBox.FocusLost:Connect(function(enterPressed)
		self.Focused = false
		TweenUtils.Tween(self.TextBox, {BorderColor3 = Theme.GetColor("Border")}, 0.1)
		
		local newValue = self.TextBox.Text
		if self.Config.Numeric then
			newValue = tonumber(newValue) or 0
			newValue = tostring(newValue)
		end
		
		if newValue ~= self.Value then
			self.Value = newValue
			self.TextBox.Text = self.Value
			if self.Config.Callback then
				self.Config.Callback(self.Value, enterPressed)
			end
		end
	end)
	
	self.TextBox:GetPropertyChangedSignal("Text"):Connect(function()
		if self.Config.Numeric then
			local text = self.TextBox.Text
			local filtered = text:gsub("[^%d%-%.]", "")
			if filtered ~= text then
				self.TextBox.Text = filtered
			end
		end
	end)
end

function Input:SetValue(value)
	self.Value = tostring(value)
	self.TextBox.Text = self.Value
end

function Input:GetValue()
	return self.Value
end

function Input:SetPlaceholder(text)
	self.Config.Placeholder = text
	self.TextBox.PlaceholderText = text
end

function Input:UpdateTheme()
	self.Label.TextColor3 = Theme.GetColor("Text")
	self.Label.Font = Theme.GetFont()
	self.TextBox.BackgroundColor3 = Theme.GetColor("FrameBG")
	self.TextBox.BorderColor3 = self.Focused and Theme.GetColor("ThemeColor") or Theme.GetColor("Border")
	self.TextBox.TextColor3 = Theme.GetColor("Text")
	self.TextBox.PlaceholderColor3 = Theme.GetColor("TextDisabled")
	self.TextBox.Font = Theme.GetFont()
end

function Input:Destroy()
	self.Frame:Destroy()
end

return Input