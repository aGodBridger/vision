-- AmberGUI ColorPicker Widget
-- Replicates ImGui::ColorEdit4 with HSV picker, alpha bar, and input fields

local Theme = require("Theme")
local TweenUtils = require("Utils.Tween")
local ColorUtils = require("Utils.Color")
local InputUtils = require("Utils.Input")

local ColorPicker = {}
ColorPicker.__index = ColorPicker

ColorPicker.DefaultConfig = {
	Text = "Color",
	Default = Color3.new(1, 1, 1),
	DefaultAlpha = 1,
	Callback = nil,
	ShowAlpha = true,
	ShowInputs = true,
	Size = UDim2.new(1, 0, 0, 24),
	PickerSize = UDim2.new(0, 200, 0, 200),
}

function ColorPicker.new(parent, options)
	local self = setmetatable({}, ColorPicker)
	
	self.Config = {}
	for k, v in pairs(ColorPicker.DefaultConfig) do
		self.Config[k] = options and options[k] or v
	end
	
	self.Color = self.Config.Default
	self.Alpha = self.Config.DefaultAlpha
	self.PickerOpen = false
	
	self:Create(parent)
	return self
end

function ColorPicker:Create(parent)
	self.Frame = Instance.new("Frame")
	self.Frame.Name = "ColorPicker"
	self.Frame.Size = self.Config.Size
	self.Frame.BackgroundTransparency = 1
	self.Frame.Parent = parent
	
	-- Label
	self.Label = Instance.new("TextLabel")
	self.Label.Name = "Label"
	self.Label.Size = UDim2.new(1, -40, 1, 0)
	self.Label.BackgroundTransparency = 1
	self.Label.Text = self.Config.Text
	self.Label.TextColor3 = Theme.GetColor("Text")
	self.Label.TextSize = 13
	self.Label.Font = Theme.GetFont()
	self.Label.TextXAlignment = Enum.TextXAlignment.Left
	self.Label.TextYAlignment = Enum.TextYAlignment.Center
	self.Label.Parent = self.Frame
	
	-- Color preview button
	self.Preview = Instance.new("TextButton")
	self.Preview.Name = "Preview"
	self.Preview.Size = UDim2.new(0, 32, 0, 18)
	self.Preview.Position = UDim2.new(1, -32, 0.5, -9)
	self.Preview.BackgroundColor3 = self.Color
	self.Preview.BorderSizePixel = 1
	self.Preview.BorderColor3 = Theme.GetColor("Border")
	self.Preview.Text = ""
	self.Preview.AutoButtonColor = false
	self.Preview.Parent = self.Frame
	
	local previewCorner = Instance.new("UICorner")
	previewCorner.CornerRadius = UDim.new(0, 3)
	previewCorner.Parent = self.Preview
	
	-- Alpha checkerboard pattern
	self.AlphaPattern = Instance.new("ImageLabel")
	self.AlphaPattern.Size = UDim2.new(1, 0, 1, 0)
	self.AlphaPattern.BackgroundTransparency = 1
	self.AlphaPattern.Image = "rbxassetid://4155801252" -- Checkerboard
	self.AlphaPattern.ImageTransparency = 1 - self.Alpha
	self.AlphaPattern.ScaleType = Enum.ScaleType.Tile
	self.AlphaPattern.TileSize = UDim2.new(0, 8, 0, 8)
	self.AlphaPattern.Parent = self.Preview
	
	self.Preview.MouseButton1Click:Connect(function()
		self:TogglePicker()
	end)
	
	self.Preview.MouseEnter:Connect(function()
		TweenUtils.Tween(self.Preview, {BorderColor3 = Theme.GetColor("ThemeColor")}, 0.1)
	end)
	
	self.Preview.MouseLeave:Connect(function()
		TweenUtils.Tween(self.Preview, {BorderColor3 = Theme.GetColor("Border")}, 0.1)
	end)
end

function ColorPicker:TogglePicker()
	if self.PickerOpen then
		self:ClosePicker()
	else
		self:OpenPicker()
	end
end

function ColorPicker:OpenPicker()
	local screenGui = self.Frame:FindFirstAncestorOfClass("ScreenGui")
	if not screenGui then return end
	
	local previewPos = self.Preview.AbsolutePosition
	
	self.PickerFrame = Instance.new("Frame")
	self.PickerFrame.Name = "ColorPickerPopup"
	self.PickerFrame.Size = self.Config.PickerSize + UDim2.new(0, 0, 0, self.Config.ShowAlpha and 30 or 0)
	self.PickerFrame.Position = UDim2.new(0, previewPos.X - self.Config.PickerSize.X.Offset, 0, previewPos.Y + 25)
	self.PickerFrame.BackgroundColor3 = Theme.GetColor("PopupBG")
	self.PickerFrame.BorderSizePixel = 1
	self.PickerFrame.BorderColor3 = Theme.GetColor("Border")
	self.PickerFrame.ZIndex = 1000
	self.PickerFrame.Parent = screenGui
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 4)
	corner.Parent = self.PickerFrame
	
	local stroke = Instance.new("UIStroke")
	stroke.Color = Theme.GetColor("ThemeColor")
	stroke.Thickness = 1
	stroke.Parent = self.PickerFrame
	
	-- HSV Picker
	self:CreateHSVPicker()
	
	-- Alpha bar
	if self.Config.ShowAlpha then
		self:CreateAlphaBar()
	end
	
	-- Input fields
	if self.Config.ShowInputs then
		self:CreateInputFields()
	end
	
	-- Close on click outside
	self.CloseConnection = game:GetService("UserInputService").InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			local mousePos = InputUtils.GetMousePosition()
			local framePos = self.PickerFrame.AbsolutePosition
			local frameSize = self.PickerFrame.AbsoluteSize
			if mousePos.X < framePos.X or mousePos.X > framePos.X + frameSize.X or
			   mousePos.Y < framePos.Y or mousePos.Y > framePos.Y + frameSize.Y then
				if mousePos.X < self.Preview.AbsolutePosition.X or mousePos.X > self.Preview.AbsolutePosition.X + self.Preview.AbsoluteSize.X or
				   mousePos.Y < self.Preview.AbsolutePosition.Y or mousePos.Y > self.Preview.AbsolutePosition.Y + self.Preview.AbsoluteSize.Y then
					self:ClosePicker()
				end
			end
		end
	end)
	
	self.PickerOpen = true
end

function ColorPicker:CreateHSVPicker()
	local picker = Instance.new("Frame")
	picker.Name = "HSVPicker"
	picker.Size = UDim2.new(1, -16, 1, self.Config.ShowAlpha and -50 or -16)
	picker.Position = UDim2.new(0, 8, 0, 8)
	picker.BackgroundColor3 = Color3.new(1, 0, 0) -- Will be overridden by gradient
	picker.BorderSizePixel = 0
	picker.Parent = self.PickerFrame
	
	-- Saturation/Value gradient (white to black vertical, transparent to color horizontal)
	local svGradient = Instance.new("UIGradient")
	svGradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
		ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1))
	}
	svGradient.Transparency = NumberSequence.new{
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(1, 1)
	}
	svGradient.Rotation = -90
	svGradient.Parent = picker
	
	-- Hue overlay
	local hueOverlay = Instance.new("Frame")
	hueOverlay.Size = UDim2.new(1, 0, 1, 0)
	hueOverlay.BackgroundColor3 = Color3.new(1, 1, 1)
	hueOverlay.BackgroundTransparency = 0
	hueOverlay.BorderSizePixel = 0
	hueOverlay.Parent = picker
	
	local hueGradient = Instance.new("UIGradient")
	hueGradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.new(1, 0, 0)),
		ColorSequenceKeypoint.new(1/6, Color3.new(1, 1, 0)),
		ColorSequenceKeypoint.new(2/6, Color3.new(0, 1, 0)),
		ColorSequenceKeypoint.new(3/6, Color3.new(0, 1, 1)),
		ColorSequenceKeypoint.new(4/6, Color3.new(0, 0, 1)),
		ColorSequenceKeypoint.new(5/6, Color3.new(1, 0, 1)),
		ColorSequenceKeypoint.new(1, Color3.new(1, 0, 0))
	}
	hueGradient.Rotation = 0
	hueGradient.Parent = hueOverlay
	
	-- Saturation/Value picker cursor
	self.SVCursor = Instance.new("Frame")
	self.SVCursor.Name = "SVCursor"
	self.SVCursor.Size = UDim2.new(0, 12, 0, 12)
	self.SVCursor.BackgroundColor3 = Color3.new(1, 1, 1)
	self.SVCursor.BackgroundTransparency = 0
	self.SVCursor.BorderSizePixel = 2
	self.SVCursor.BorderColor3 = Color3.new(0, 0, 0)
	self.SVCursor.AnchorPoint = Vector2.new(0.5, 0.5)
	self.SVCursor.ZIndex = 5
	self.SVCursor.Parent = picker
	
	local svCursorCorner = Instance.new("UICorner")
	svCursorCorner.CornerRadius = UDim.new(1, 0)
	svCursorCorner.Parent = self.SVCursor
	
	-- Hue bar
	self.HueBar = Instance.new("Frame")
	self.HueBar.Name = "HueBar"
	self.HueBar.Size = UDim2.new(1, -16, 0, 12)
	self.HueBar.Position = UDim2.new(0, 8, 1, self.Config.ShowAlpha and -48 or -24)
	self.HueBar.BackgroundColor3 = Color3.new(1, 1, 1)
	self.HueBar.BorderSizePixel = 0
	self.HueBar.Parent = self.PickerFrame
	
	local hueBarGradient = Instance.new("UIGradient")
	hueBarGradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.new(1, 0, 0)),
		ColorSequenceKeypoint.new(1/6, Color3.new(1, 1, 0)),
		ColorSequenceKeypoint.new(2/6, Color3.new(0, 1, 0)),
		ColorSequenceKeypoint.new(3/6, Color3.new(0, 1, 1)),
		ColorSequenceKeypoint.new(4/6, Color3.new(0, 0, 1)),
		ColorSequenceKeypoint.new(5/6, Color3.new(1, 0, 1)),
		ColorSequenceKeypoint.new(1, Color3.new(1, 0, 0))
	}
	hueBarGradient.Rotation = 0
	hueBarGradient.Parent = self.HueBar
	
	local hueBarCorner = Instance.new("UICorner")
	hueBarCorner.CornerRadius = UDim.new(0, 3)
	hueBarCorner.Parent = self.HueBar
	
	-- Hue cursor
	self.HueCursor = Instance.new("Frame")
	self.HueCursor.Name = "HueCursor"
	self.HueCursor.Size = UDim2.new(0, 4, 1, 8)
	self.HueCursor.BackgroundColor3 = Color3.new(1, 1, 1)
	self.HueCursor.BorderSizePixel = 1
	self.HueCursor.BorderColor3 = Color3.new(0, 0, 0)
	self.HueCursor.AnchorPoint = Vector2.new(0.5, 0.5)
	self.HueCursor.ZIndex = 5
	self.HueCursor.Parent = self.HueBar
	
	-- Drag handlers
	self.HueDragging = false
	self.SVDragging = false
	
	picker.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			self.SVDragging = true
			self:UpdateSVFromMouse(input.Position)
		end
	end)
	
	self.HueBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			self.HueDragging = true
			self:UpdateHueFromMouse(input.Position)
		end
	end)
	
	game:GetService("UserInputService").InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			if self.SVDragging then
				self:UpdateSVFromMouse(input.Position)
			elseif self.HueDragging then
				self:UpdateHueFromMouse(input.Position)
			end
		end
	end)
	
	game:GetService("UserInputService").InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			self.SVDragging = false
			self.HueDragging = false
		end
	end)
	
	-- Initialize cursor positions from current color
	self:UpdateCursorsFromColor()
end

function ColorPicker:CreateAlphaBar()
	local alphaBar = Instance.new("Frame")
	alphaBar.Name = "AlphaBar"
	alphaBar.Size = UDim2.new(1, -16, 0, 12)
	alphaBar.Position = UDim2.new(0, 8, 1, -30)
	alphaBar.BackgroundColor3 = self.Color
	alphaBar.BorderSizePixel = 0
	alphaBar.Parent = self.PickerFrame
	
	-- Checkerboard background
	local checker = Instance.new("ImageLabel")
	checker.Size = UDim2.new(1, 0, 1, 0)
	checker.BackgroundTransparency = 1
	checker.Image = "rbxassetid://4155801252"
	checker.ScaleType = Enum.ScaleType.Tile
	checker.TileSize = UDim2.new(0, 8, 0, 8)
	checker.Parent = alphaBar
	
	-- Alpha gradient (transparent to opaque)
	local alphaGradient = Instance.new("UIGradient")
	alphaGradient.Transparency = NumberSequence.new{
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(1, 0)
	}
	alphaGradient.Rotation = 0
	alphaGradient.Parent = alphaBar
	
	local alphaCorner = Instance.new("UICorner")
	alphaCorner.CornerRadius = UDim.new(0, 3)
	alphaCorner.Parent = alphaBar
	
	-- Alpha cursor
	self.AlphaCursor = Instance.new("Frame")
	self.AlphaCursor.Name = "AlphaCursor"
	self.AlphaCursor.Size = UDim2.new(0, 4, 1, 8)
	self.AlphaCursor.BackgroundColor3 = Color3.new(1, 1, 1)
	self.AlphaCursor.BorderSizePixel = 1
	self.AlphaCursor.BorderColor3 = Color3.new(0, 0, 0)
	self.AlphaCursor.AnchorPoint = Vector2.new(0.5, 0.5)
	self.AlphaCursor.ZIndex = 5
	self.AlphaCursor.Parent = alphaBar
	
	self.AlphaDragging = false
	
	alphaBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			self.AlphaDragging = true
			self:UpdateAlphaFromMouse(input.Position)
		end
	end)
	
	game:GetService("UserInputService").InputChanged:Connect(function(input)
		if self.AlphaDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			self:UpdateAlphaFromMouse(input.Position)
		end
	end)
	
	game:GetService("UserInputService").InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			self.AlphaDragging = false
		end
	end)
end

function ColorPicker:CreateInputFields()
	local inputFrame = Instance.new("Frame")
	inputFrame.Name = "InputFields"
	inputFrame.Size = UDim2.new(1, -16, 0, 24)
	inputFrame.Position = UDim2.new(0, 8, 1, self.Config.ShowAlpha and -80 or -50)
	inputFrame.BackgroundTransparency = 1
	inputFrame.Parent = self.PickerFrame
	
	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Horizontal
	layout.Padding = UDim.new(0, 4)
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout.Parent = inputFrame
	
	-- R, G, B, A inputs
	self.InputBoxes = {}
	local channels = self.Config.ShowAlpha and {"R", "G", "B", "A"} or {"R", "G", "B"}
	
	for _, channel in ipairs(channels) do
		local box = Instance.new("TextBox")
		box.Name = channel .. "Input"
		box.Size = UDim2.new(0, 40, 1, 0)
		box.BackgroundColor3 = Theme.GetColor("FrameBG")
		box.BorderSizePixel = 1
		box.BorderColor3 = Theme.GetColor("Border")
		box.TextColor3 = Theme.GetColor("Text")
		box.TextSize = 11
		box.Font = Theme.GetFont()
		box.ClearTextOnFocus = false
		box.Parent = inputFrame
		
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 3)
		corner.Parent = box
		
		box.FocusLost:Connect(function()
			self:UpdateFromInputs()
		end)
		
		self.InputBoxes[channel] = box
	end
	
	self:UpdateInputsFromColor()
end

function ColorPicker:UpdateSVFromMouse(mousePos)
	local picker = self.PickerFrame:FindFirstChild("HSVPicker")
	if not picker then return end
	
	local relX = math.clamp(mousePos.X - picker.AbsolutePosition.X, 0, picker.AbsoluteSize.X)
	local relY = math.clamp(mousePos.Y - picker.AbsolutePosition.Y, 0, picker.AbsoluteSize.Y)
	
	local s = relX / picker.AbsoluteSize.X
	local v = 1 - (relY / picker.AbsoluteSize.Y)
	
	local h, _, _ = ColorUtils.Color3ToHSV(self.Color)
	self.Color = ColorUtils.HSVToColor3(h, s, v)
	
	self:UpdateVisuals()
end

function ColorPicker:UpdateHueFromMouse(mousePos)
	local relX = math.clamp(mousePos.X - self.HueBar.AbsolutePosition.X, 0, self.HueBar.AbsoluteSize.X)
	local h = relX / self.HueBar.AbsoluteSize.X
	
	local _, s, v = ColorUtils.Color3ToHSV(self.Color)
	self.Color = ColorUtils.HSVToColor3(h, s, v)
	
	self:UpdateVisuals()
end

function ColorPicker:UpdateAlphaFromMouse(mousePos)
	local alphaBar = self.PickerFrame:FindFirstChild("AlphaBar")
	if not alphaBar then return end
	
	local relX = math.clamp(mousePos.X - alphaBar.AbsolutePosition.X, 0, alphaBar.AbsoluteSize.X)
	self.Alpha = relX / alphaBar.AbsoluteSize.X
	
	self:UpdateVisuals()
end

function ColorPicker:UpdateCursorsFromColor()
	local h, s, v = ColorUtils.Color3ToHSV(self.Color)
	
	-- SV Cursor
	local picker = self.PickerFrame:FindFirstChild("HSVPicker")
	if picker then
		self.SVCursor.Position = UDim2.new(s, 0, 1 - v, 0)
	end
	
	-- Hue Cursor
	self.HueCursor.Position = UDim2.new(h, 0, 0.5, 0)
	
	-- Alpha Cursor
	if self.AlphaCursor then
		self.AlphaCursor.Position = UDim2.new(self.Alpha, 0, 0.5, 0)
	end
	
	-- Update picker background color (hue)
	local hueOverlay = picker and picker:GetChildren()[1]
	if hueOverlay then
		hueOverlay.BackgroundColor3 = ColorUtils.HSVToColor3(h, 1, 1)
	end
end

function ColorPicker:UpdateVisuals()
	-- Update preview
	self.Preview.BackgroundColor3 = self.Color
	self.AlphaPattern.ImageTransparency = 1 - self.Alpha
	
	-- Update picker if open
	if self.PickerOpen then
		self:UpdateCursorsFromColor()
		
		-- Update alpha bar color
		local alphaBar = self.PickerFrame:FindFirstChild("AlphaBar")
		if alphaBar then
			alphaBar.BackgroundColor3 = self.Color
		end
		
		-- Update inputs
		self:UpdateInputsFromColor()
	end
	
	-- Callback
	if self.Config.Callback then
		self.Config.Callback(self.Color, self.Alpha)
	end
end

function ColorPicker:UpdateInputsFromColor()
	if not self.InputBoxes then return end
	
	self.InputBoxes.R.Text = tostring(math.floor(self.Color.R * 255 + 0.5))
	self.InputBoxes.G.Text = tostring(math.floor(self.Color.G * 255 + 0.5))
	self.InputBoxes.B.Text = tostring(math.floor(self.Color.B * 255 + 0.5))
	
	if self.InputBoxes.A then
		self.InputBoxes.A.Text = string.format("%.0f", self.Alpha * 255)
	end
end

function ColorPicker:UpdateFromInputs()
	if not self.InputBoxes then return end
	
	local r = tonumber(self.InputBoxes.R.Text) or 0
	local g = tonumber(self.InputBoxes.G.Text) or 0
	local b = tonumber(self.InputBoxes.B.Text) or 0
	
	r = math.clamp(r, 0, 255) / 255
	g = math.clamp(g, 0, 255) / 255
	b = math.clamp(b, 0, 255) / 255
	
	self.Color = Color3.new(r, g, b)
	
	if self.InputBoxes.A then
		local a = tonumber(self.InputBoxes.A.Text) or 255
		self.Alpha = math.clamp(a, 0, 255) / 255
	end
	
	self:UpdateVisuals()
end

function ColorPicker:ClosePicker()
	if self.PickerFrame then
		self.PickerFrame:Destroy()
		self.PickerFrame = nil
	end
	if self.CloseConnection then
		self.CloseConnection:Disconnect()
		self.CloseConnection = nil
	end
	self.PickerOpen = false
end

function ColorPicker:SetColor(color, alpha)
	self.Color = color
	if alpha then self.Alpha = alpha end
	self:UpdateVisuals()
end

function ColorPicker:GetColor()
	return self.Color, self.Alpha
end

function ColorPicker:UpdateTheme()
	self.Label.TextColor3 = Theme.GetColor("Text")
	self.Label.Font = Theme.GetFont()
	self.Preview.BorderColor3 = Theme.GetColor("Border")
	
	if self.PickerOpen and self.PickerFrame then
		self.PickerFrame.BackgroundColor3 = Theme.GetColor("PopupBG")
		self.PickerFrame.BorderColor3 = Theme.GetColor("Border")
	end
end

function ColorPicker:Destroy()
	self:ClosePicker()
	self.Frame:Destroy()
end

return ColorPicker