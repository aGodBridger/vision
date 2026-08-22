-- AmberGUI Bulk Add Modal
-- Modal window for bulk adding targets

local Theme = require("Theme")
local TweenUtils = require("Utils.Tween")
local InputUtils = require("Utils.Input")

local BulkAddModal = {}
BulkAddModal.__index = BulkAddModal

function BulkAddModal.new(options)
	local self = setmetatable({}, BulkAddModal)
	
	self.Config = options or {}
	self.Visible = false
	self.Callback = self.Config.Callback
	
	self:Create()
	return self
end

function BulkAddModal:Create()
	local screenGui = AmberGUI.ScreenGui
	if not screenGui then return end
	
	self.Frame = Instance.new("Frame")
	self.Frame.Name = "BulkAddModal"
	self.Frame.Size = UDim2.new(0, 450, 0, 400)
	self.Frame.Position = UDim2.new(0.5, -225, 0.5, -200)
	self.Frame.AnchorPoint = Vector2.new(0.5, 0.5)
	self.Frame.BackgroundColor3 = Theme.GetColor("WindowBG")
	self.Frame.BorderSizePixel = 0
	self.Frame.Visible = false
	self.Frame.ZIndex = 1000
	self.Frame.Parent = screenGui
	
	-- Outer border
	local outerBorder = Instance.new("UIStroke")
	outerBorder.Color = Theme.GetColor("OverlayBorder")
	outerBorder.Thickness = 2
	outerBorder.Parent = self.Frame
	
	-- Header
	self.Header = Instance.new("Frame")
	self.Header.Name = "Header"
	self.Header.Size = UDim2.new(1, 0, 0, 35)
	self.Header.BackgroundColor3 = Theme.GetColor("Child")
	self.Header.BorderSizePixel = 0
	self.Header.Parent = self.Frame
	
	-- Header accent
	local headerAccent = Instance.new("Frame")
	headerAccent.Size = UDim2.new(1, 0, 0, 2)
	headerAccent.Position = UDim2.new(0, 0, 1, -2)
	headerAccent.BackgroundColor3 = Theme.GetColor("ThemeColor")
	headerAccent.BorderSizePixel = 0
	headerAccent.Parent = self.Header
	
	-- Header shadow
	local headerShadow = Instance.new("Frame")
	headerShadow.Size = UDim2.new(1, 0, 0, 2)
	headerShadow.Position = UDim2.new(0, 0, 1, 0)
	headerShadow.BackgroundColor3 = Theme.GetColor("ThemeColor")
	headerShadow.BackgroundTransparency = 0.8
	headerShadow.BorderSizePixel = 0
	headerShadow.Parent = self.Header
	
	-- Title
	self.TitleLabel = Instance.new("TextLabel")
	self.TitleLabel.Size = UDim2.new(1, -20, 1, 0)
	self.TitleLabel.Position = UDim2.new(0, 10, 0, 0)
	self.TitleLabel.BackgroundTransparency = 1
	self.TitleLabel.Text = "Bulk Add Targets"
	self.TitleLabel.TextColor3 = Theme.GetColor("Text")
	self.TitleLabel.TextSize = 14
	self.TitleLabel.Font = Theme.GetFont()
	self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	self.TitleLabel.TextYAlignment = Enum.TextYAlignment.Center
	self.TitleLabel.Parent = self.Header
	
	-- Drag header
	self:SetupDragging()
	
	-- Content
	self.Content = Instance.new("Frame")
	self.Content.Name = "Content"
	self.Content.Size = UDim2.new(1, -20, 1, -55)
	self.Content.Position = UDim2.new(0, 10, 0, 45)
	self.Content.BackgroundTransparency = 1
	self.Content.Parent = self.Frame
	
	-- Instruction label
	self.Instruction = Instance.new("TextLabel")
	self.Instruction.Size = UDim2.new(1, 0, 0, 20)
	self.Instruction.BackgroundTransparency = 1
	self.Instruction.Text = "Paste list of usernames or display names (one per line):"
	self.Instruction.TextColor3 = Theme.GetColor("Text")
	self.Instruction.TextSize = 13
	self.Instruction.Font = Theme.GetFont()
	self.Instruction.TextXAlignment = Enum.TextXAlignment.Left
	self.Instruction.TextYAlignment = Enum.TextYAlignment.Center
	self.Instruction.Parent = self.Content
	
	-- Text box
	self.TextBox = Instance.new("TextBox")
	self.TextBox.Name = "BulkInput"
	self.TextBox.Size = UDim2.new(1, 0, 1, -80)
	self.TextBox.Position = UDim2.new(0, 0, 0, 25)
	self.TextBox.BackgroundColor3 = Theme.GetColor("Child")
	self.TextBox.BorderSizePixel = 1
	self.TextBox.BorderColor3 = Theme.GetColor("Border")
	self.TextBox.Text = ""
	self.TextBox.PlaceholderText = "Player1\nPlayer2\nPlayer3..."
	self.TextBox.TextColor3 = Theme.GetColor("Text")
	self.TextBox.PlaceholderColor3 = Theme.GetColor("TextDisabled")
	self.TextBox.TextSize = 13
	self.TextBox.Font = Theme.GetFont()
	self.TextBox.TextXAlignment = Enum.TextXAlignment.Left
	self.TextBox.TextYAlignment = Enum.TextYAlignment.Top
	self.TextBox.ClearTextOnFocus = false
	self.TextBox.MultiLine = true
	self.TextBox.Parent = self.Content
	
	local boxCorner = Instance.new("UICorner")
	boxCorner.CornerRadius = UDim.new(0, 3)
	boxCorner.Parent = self.TextBox
	
	-- Buttons
	self.ButtonFrame = Instance.new("Frame")
	self.ButtonFrame.Size = UDim2.new(1, 0, 0, 40)
	self.ButtonFrame.Position = UDim2.new(0, 0, 1, -40)
	self.ButtonFrame.BackgroundTransparency = 1
	self.ButtonFrame.Parent = self.Content
	
	local btnLayout = Instance.new("UIListLayout")
	btnLayout.FillDirection = Enum.FillDirection.Horizontal
	btnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	btnLayout.Padding = UDim.new(0, 10)
	btnLayout.Parent = self.ButtonFrame
	
	self.AddAllBtn = Instance.new("TextButton")
	self.AddAllBtn.Size = UDim2.new(0, 120, 1, 0)
	self.AddAllBtn.BackgroundColor3 = Theme.GetColor("Button")
	self.AddAllBtn.BorderSizePixel = 1
	self.AddAllBtn.BorderColor3 = Theme.GetColor("Border")
	self.AddAllBtn.Text = "Add All"
	self.AddAllBtn.TextColor3 = Theme.GetColor("Text")
	self.AddAllBtn.TextSize = 13
	self.AddAllBtn.Font = Theme.GetFont()
	self.AddAllBtn.Parent = self.ButtonFrame
	
	self.CancelBtn = Instance.new("TextButton")
	self.CancelBtn.Size = UDim2.new(0, 120, 1, 0)
	self.CancelBtn.BackgroundColor3 = Theme.GetColor("Button")
	self.CancelBtn.BorderSizePixel = 1
	self.CancelBtn.BorderColor3 = Theme.GetColor("Border")
	self.CancelBtn.Text = "Cancel"
	self.CancelBtn.TextColor3 = Theme.GetColor("Text")
	self.CancelBtn.TextSize = 13
	self.CancelBtn.Font = Theme.GetFont()
	self.CancelBtn.Parent = self.ButtonFrame
	
	for _, btn in ipairs({self.AddAllBtn, self.CancelBtn}) do
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 4)
		corner.Parent = btn
		
		btn.MouseEnter:Connect(function()
			btn.BackgroundColor3 = Theme.GetColor("ButtonHovered")
			btn.BorderColor3 = Theme.GetColor("ThemeColor")
		end)
		
		btn.MouseLeave:Connect(function()
			btn.BackgroundColor3 = Theme.GetColor("Button")
			btn.BorderColor3 = Theme.GetColor("Border")
		end)
	end
	
	self.AddAllBtn.MouseButton1Click:Connect(function()
		self:ProcessBulkAdd()
	end)
	
	self.CancelBtn.MouseButton1Click:Connect(function()
		self:Hide()
	end)
end

function BulkAddModal:SetupDragging()
	self.Dragging = false
	self.DragStart = nil
	self.StartPos = nil
	
	self.Header.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			self.Dragging = true
			self.DragStart = input.Position
			self.StartPos = self.Frame.Position
		end
	end)
	
	self.Header.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement and self.Dragging then
			local delta = input.Position - self.DragStart
			self.Frame.Position = UDim2.new(
				self.StartPos.X.Scale, self.StartPos.X.Offset + delta.X,
				self.StartPos.Y.Scale, self.StartPos.Y.Offset + delta.Y
			)
		end
	end)
	
	self.Header.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			self.Dragging = false
		end
	end)
end

function BulkAddModal:Show()
	self.Frame.Visible = true
	self.TextBox:CaptureFocus()
	self.Visible = true
	
	-- Animation
	self.Frame.Size = UDim2.new(0, 450, 0, 0)
	TweenUtils.Tween(self.Frame, {Size = UDim2.new(0, 450, 0, 400)}, 0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end

function BulkAddModal:Hide()
	self.Visible = false
	
	local tween = TweenUtils.Tween(self.Frame, {Size = UDim2.new(0, 450, 0, 0)}, 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	tween.Completed:Connect(function()
		self.Frame.Visible = false
	end)
end

function BulkAddModal:ProcessBulkAdd()
	local text = self.TextBox.Text
	if not text or text == "" then return end
	
	local lines = {}
	for line in text:gmatch("[^\r\n]+") do
		-- Trim whitespace
		line = line:match("^%s*(.-)%s*$")
		if line ~= "" then
			table.insert(lines, line)
		end
	end
	
	if #lines == 0 then return end
	
	-- Resolve names against cached players
	local resolved = {}
	local players = globals.instances and globals.instances.cachedplayers or {}
	
	for _, line in ipairs(lines) do
		local found = false
		for _, player in ipairs(players) do
			local display = player.displayname or player.name
			if display:lower() == line:lower() or player.name:lower() == line:lower() then
				table.insert(resolved, player.name)
				found = true
				break
			end
		end
		if not found then
			-- Could not resolve, skip or add as-is
			print("[BulkAdd] Could not resolve:", line)
		end
	end
	
	-- Call callback with resolved names
	if self.Callback and #resolved > 0 then
		self.Callback(resolved)
	end
	
	AmberGUI.Notify("Added " .. #resolved .. " targets", 3, Theme.GetColor("ThemeColor"))
	
	self.TextBox.Text = ""
	self:Hide()
end

function BulkAddModal:UpdateTheme()
	self.Frame.BackgroundColor3 = Theme.GetColor("WindowBG")
	self.Header.BackgroundColor3 = Theme.GetColor("Child")
	self.TitleLabel.TextColor3 = Theme.GetColor("Text")
	self.TitleLabel.Font = Theme.GetFont()
	self.Instruction.TextColor3 = Theme.GetColor("Text")
	self.Instruction.Font = Theme.GetFont()
	self.TextBox.BackgroundColor3 = Theme.GetColor("Child")
	self.TextBox.BorderColor3 = Theme.GetColor("Border")
	self.TextBox.TextColor3 = Theme.GetColor("Text")
	self.TextBox.PlaceholderColor3 = Theme.GetColor("TextDisabled")
	self.TextBox.Font = Theme.GetFont()
	
	self.AddAllBtn.BackgroundColor3 = Theme.GetColor("Button")
	self.AddAllBtn.BorderColor3 = Theme.GetColor("Border")
	self.AddAllBtn.TextColor3 = Theme.GetColor("Text")
	self.AddAllBtn.Font = Theme.GetFont()
	
	self.CancelBtn.BackgroundColor3 = Theme.GetColor("Button")
	self.CancelBtn.BorderColor3 = Theme.GetColor("Border")
	self.CancelBtn.TextColor3 = Theme.GetColor("Text")
	self.CancelBtn.Font = Theme.GetFont()
end

return BulkAddModal