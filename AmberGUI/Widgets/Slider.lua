-- AmberGUI Slider Widget
-- Replicates ImGui::SliderFloat/SliderInt with manual input popup (right-click)

local Theme = require("Theme")
local TweenUtils = require("Utils.Tween")
local InputUtils = require("Utils.Input")

local Slider = {}
Slider.__index = Slider

Slider.DefaultConfig = {
	Text = "Slider",
	Min = 0,
	Max = 100,
	Default = 0,
	Format = "%.1f",
	IsInt = false,
	Callback = nil,
	Size = UDim2.new(1, 0, 0, 36),
	ShowValue = true,
	ManualInput = true, -- Right-click for manual input
}

function Slider.new(parent, options)
	local self = setmetatable({}, Slider)
	
	self.Config = {}
	for k, v in pairs(Slider.DefaultConfig) do
		self.Config[k] = options and options[k] or v
	end
	
	self.Value = self.Config.Default
	self.Dragging = false
	self.PopupOpen = false
	
	self:Create(parent)
	return self
end

function Slider:Create(parent)
	self.Frame = Instance.new("Frame")
	self.Frame.Name = "Slider"
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
	
	-- Value label
	if self.Config.ShowValue then
		self.ValueLabel = Instance.new("TextLabel")
		self.ValueLabel.Name = "ValueLabel"
		self.ValueLabel.Size = UDim2.new(0, 60, 0, 18)
		self.ValueLabel.Position = UDim2.new(1, -60, 0, 0)
		self.ValueLabel.BackgroundTransparency = 1
		self.ValueLabel.Text = self:FormatValue(self.Value)
		self.ValueLabel.TextColor3 = Theme.GetColor("TextDisabled")
		self.ValueLabel.TextSize = 13
		self.ValueLabel.Font = Theme.GetFont()
		self.ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
		self.ValueLabel.TextYAlignment = Enum.TextYAlignment.Center
		self.ValueLabel.Parent = self.Frame
	end
	
	-- Slider track
	self.Track = Instance.new("Frame")
	self.Track.Name = "Track"
	self.Track.Size = UDim2.new(1, 0, 0, 6)
	self.Track.Position = UDim2.new(0, 0, 0, 22)
	self.Track.BackgroundColor3 = Theme.GetColor("FrameBG")
	self.Track.BorderSizePixel = 0
	self.Track.Parent = self.Frame
	
	local trackCorner = Instance.new("UICorner")
	trackCorner.CornerRadius = UDim.new(0, 3)
	trackCorner.Parent = self.Track
	
	-- Slider fill
	self.Fill = Instance.new("Frame")
	self.Fill.Name = "Fill"
	self.Fill.Size = UDim2.new(self:GetRatio(), 0, 1, 0)
	self.Fill.BackgroundColor3 = Theme.GetColor("SliderGrab")
	self.Fill.BorderSizePixel = 0
	self.Fill.Parent = self.Track
	
	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(0, 3)
	fillCorner.Parent = self.Fill
	
	-- Slider knob
	self.Knob = Instance.new("Frame")
	self.Knob.Name = "Knob"
	self.Knob.Size = UDim2.new(0, 14, 0, 14)
	self.Knob.Position = UDim2.new(self:GetRatio(), -7, 0.5, -7)
	self.Knob.BackgroundColor3 = Theme.GetColor("SliderGrab")
	self.Knob.BorderSizePixel = 0
	self.Knob.ZIndex = 5
	self.Knob.Parent = self.Track
	
	local knobCorner = Instance.new("UICorner")
	knobCorner.CornerRadius = UDim.new(1, 0)
	knobCorner.Parent = self.Knob
	
	-- Knob glow
	self.KnobGlow = Instance.new("ImageLabel")
	self.KnobGlow.Name = "Glow"
	self.KnobGlow.Size = UDim2.new(0, 24, 0, 24)
	self.KnobGlow.Position = UDim2.new(0.5, -12, 0.5, -12)
	self.KnobGlow.BackgroundTransparency = 1
	self.KnobGlow.Image = "rbxassetid://5028857084" -- Soft circle
	self.KnobGlow.ImageColor3 = Theme.GetColor("SliderGrab")
	self.KnobGlow.ImageTransparency = 0.7
	self.KnobGlow.ZIndex = 4
	self.KnobGlow.Parent = self.Knob
	
	-- Input events
	self.Track.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			self.Dragging = true
			self:UpdateFromMouse(input.Position.X)
		elseif input.UserInputType == Enum.UserInputType.MouseButton2 and self.Config.ManualInput then
			self:OpenManualInput()
		end
	end)
	
	self.Knob.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			self.Dragging = true
		elseif input.UserInputType == Enum.UserInputType.MouseButton2 and self.Config.ManualInput then
			self:OpenManualInput()
		end
	end)
	
	local UserInputService = game:GetService("UserInputService")
	UserInputService.InputChanged:Connect(function(input)
		if self.Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			self:UpdateFromMouse(input.Position.X)
		end
	end)
	
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			self.Dragging = false
		end
	end)
	
	-- Hover effects
	self.Track.MouseEnter:Connect(function()
		if not self.Dragging then
			TweenUtils.Tween(self.Knob, {Size = UDim2.new(0, 16, 0, 16)}, 0.1)
			TweenUtils.Tween(self.KnobGlow, {ImageTransparency = 0.5}, 0.1)
		end
	end)
	
	self.Track.MouseLeave:Connect(function()
		if not self.Dragging then
			TweenUtils.Tween(self.Knob, {Size = UDim2.new(0, 14, 0, 14)}, 0.1)
			TweenUtils.Tween(self.KnobGlow, {ImageTransparency = 0.7}, 0.1)
		end
	end)
	
	-- Initial value
	self:SetValue(self.Config.Default)
end

function Slider:GetRatio()
	return (self.Value - self.Config.Min) / (self.Config.Max - self.Config.Min)
end

function Slider:FormatValue(val)
	if self.Config.IsInt then
		return string.format("%.0f", val)
	end
	return string.format(self.Config.Format, val)
end

function Slider:UpdateFromMouse(mouseX)
	local trackPos = self.Track.AbsolutePosition.X
	local trackSize = self.Track.AbsoluteSize.X
	local relativeX = math.clamp(mouseX - trackPos, 0, trackSize)
	local ratio = relativeX / trackSize
	
	local newValue = self.Config.Min + ratio * (self.Config.Max - self.Config.Min)
	
	if self.Config.IsInt then
		newValue = math.floor(newValue + 0.5)
	end
	
	self:SetValue(newValue)
end

function Slider:SetValue(value)
	value = math.clamp(value, self.Config.Min, self.Config.Max)
	if self.Config.IsInt then
		value = math.floor(value + 0.5)
	end
	
	self.Value = value
	self:UpdateVisuals()
	
	if self.Config.Callback then
		self.Config.Callback(value)
	end
end

function Slider:GetValue()
	return self.Value
end

function Slider:UpdateVisuals()
	local ratio = self:GetRatio()
	
	self.Fill.Size = UDim2.new(ratio, 0, 1, 0)
	self.Knob.Position = UDim2.new(ratio, -7, 0.5, -7)
	
	if self.ValueLabel then
		self.ValueLabel.Text = self:FormatValue(self.Value)
	end
end

function Slider:OpenManualInput()
	-- Create popup for manual input
	local screenGui = self.Frame:FindFirstAncestorOfClass("ScreenGui")
	if not screenGui then return end
	
	self.Popup = Instance.new("Frame")
	self.Popup.Name = "SliderPopup"
	self.Popup.Size = UDim2.new(0, 180, 0, 90)
	self.Popup.Position = UDim2.new(0, InputUtils.GetMousePosition().X, 0, InputUtils.GetMousePosition().Y)
	self.Popup.BackgroundColor3 = Theme.GetColor("PopupBG")
	self.Popup.BorderSizePixel = 1
	self.Popup.BorderColor3 = Theme.GetColor("Border")
	self.Popup.ZIndex = 1000
	self.Popup.Parent = screenGui
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 4)
	corner.Parent = self.Popup
	
	local stroke = Instance.new("UIStroke")
	stroke.Color = Theme.GetColor("ThemeColor")
	stroke.Thickness = 1
	stroke.Parent = self.Popup
	
	-- Title
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -16, 0, 20)
	title.Position = UDim2.new(0, 8, 0, 4)
	title.BackgroundTransparency = 1
	title.Text = "Enter value for " .. self.Config.Text
	title.TextColor3 = Theme.GetColor("Text")
	title.TextSize = 12
	title.Font = Theme.GetFont()
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = self.Popup
	
	-- Input box
	local textBox = Instance.new("TextBox")
	textBox.Size = UDim2.new(1, -16, 0, 28)
	textBox.Position = UDim2.new(0, 8, 0, 28)
	textBox.BackgroundColor3 = Theme.GetColor("FrameBG")
	textBox.BorderSizePixel = 1
	textBox.BorderColor3 = Theme.GetColor("Border")
	textBox.Text = self:FormatValue(self.Value)
	textBox.TextColor3 = Theme.GetColor("Text")
	textBox.TextSize = 13
	textBox.Font = Theme.GetFont()
	textBox.ClearTextOnFocus = false
	textBox.Parent = self.Popup
	
	local boxCorner = Instance.new("UICorner")
	boxCorner.CornerRadius = UDim.new(0, 3)
	boxCorner.Parent = textBox
	
	-- Buttons
	local buttonFrame = Instance.new("Frame")
	buttonFrame.Size = UDim2.new(1, -16, 0, 28)
	buttonFrame.Position = UDim2.new(0, 8, 0, 60)
	buttonFrame.BackgroundTransparency = 1
	buttonFrame.Parent = self.Popup
	
	local buttonLayout = Instance.new("UIListLayout")
	buttonLayout.FillDirection = Enum.FillDirection.Horizontal
	buttonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	buttonLayout.Padding = UDim.new(0, 8)
	buttonLayout.Parent = buttonFrame
	
	local okButton = Instance.new("TextButton")
	okButton.Size = UDim2.new(0, 60, 1, 0)
	okButton.BackgroundColor3 = Theme.GetColor("Button")
	okButton.Text = "OK"
	okButton.TextColor3 = Theme.GetColor("Text")
	okButton.TextSize = 12
	okButton.Font = Theme.GetFont()
	okButton.Parent = buttonFrame
	
	local okCorner = Instance.new("UICorner")
	okCorner.CornerRadius = UDim.new(0, 3)
	okCorner.Parent = okButton
	
	local cancelButton = Instance.new("TextButton")
	cancelButton.Size = UDim2.new(0, 60, 1, 0)
	cancelButton.BackgroundColor3 = Theme.GetColor("Button")
	cancelButton.Text = "Cancel"
	cancelButton.TextColor3 = Theme.GetColor("Text")
	cancelButton.TextSize = 12
	cancelButton.Font = Theme.GetFont()
	cancelButton.Parent = buttonFrame
	
	local cancelCorner = Instance.new("UICorner")
	cancelCorner.CornerRadius = UDim.new(0, 3)
	cancelCorner.Parent = cancelButton
	
	textBox:CaptureFocus()
	
	local function close()
		if self.Popup then
			self.Popup:Destroy()
			self.Popup = nil
			self.PopupOpen = false
		end
	end
	
	okButton.MouseButton1Click:Connect(function()
		local num = tonumber(textBox.Text)
		if num then
			self:SetValue(num)
		end
		close()
	end)
	
	cancelButton.MouseButton1Click:Connect(close)
	
	textBox.FocusLost:Connect(function(enterPressed)
		if enterPressed then
			local num = tonumber(textBox.Text)
			if num then
				self:SetValue(num)
			end
			close()
		end
	end)
	
	-- Close on click outside
	local clickConn
	clickConn = screenGui:GetPropertyChangedSignal("Enabled"):Connect(function() end) -- placeholder
	local inputConn
	inputConn = game:GetService("UserInputService").InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			local mousePos = InputUtils.GetMousePosition()
			local popupPos = self.Popup.AbsolutePosition
			local popupSize = self.Popup.AbsoluteSize
			if mousePos.X < popupPos.X or mousePos.X > popupPos.X + popupSize.X or
			   mousePos.Y < popupPos.Y or mousePos.Y > popupPos.Y + popupSize.Y then
				close()
				if inputConn then inputConn:Disconnect() end
			end
		end
	end)
	
	self.PopupOpen = true
end

function Slider:UpdateTheme()
	self.Label.TextColor3 = Theme.GetColor("Text")
	self.Label.Font = Theme.GetFont()
	
	if self.ValueLabel then
		self.ValueLabel.TextColor3 = Theme.GetColor("TextDisabled")
		self.ValueLabel.Font = Theme.GetFont()
	end
	
	self.Track.BackgroundColor3 = Theme.GetColor("FrameBG")
	self.Fill.BackgroundColor3 = Theme.GetColor("SliderGrab")
	self.Knob.BackgroundColor3 = Theme.GetColor("SliderGrab")
	self.KnobGlow.ImageColor3 = Theme.GetColor("SliderGrab")
end

function Slider:Destroy()
	if self.Popup then self.Popup:Destroy() end
	self.Frame:Destroy()
end

return Slider