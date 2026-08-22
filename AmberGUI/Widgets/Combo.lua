-- AmberGUI Combo/Dropdown Widget
-- Replicates ImGui::Combo with searchable dropdown

local Theme = require("Theme")
local TweenUtils = require("Utils.Tween")
local InputUtils = require("Utils.Input")

local Combo = {}
Combo.__index = Combo

Combo.DefaultConfig = {
	Text = "Combo",
	Items = {"Option 1", "Option 2", "Option 3"},
	Default = 1,
	Callback = nil,
	Size = UDim2.new(1, 0, 0, 36),
	MaxVisibleItems = 8,
	Searchable = false,
	MultiSelect = false,
}

function Combo.new(parent, options)
	local self = setmetatable({}, Combo)
	
	self.Config = {}
	for k, v in pairs(Combo.DefaultConfig) do
		self.Config[k] = options and options[k] or v
	end
	
	self.SelectedIndex = self.Config.Default
	self.SelectedItems = {}
	if self.Config.MultiSelect then
		self.SelectedItems[self.Config.Default] = true
	else
		self.SelectedItems[self.Config.Default] = true
	end
	
	self.DropdownOpen = false
	
	self:Create(parent)
	return self
end

function Combo:Create(parent)
	self.Frame = Instance.new("Frame")
	self.Frame.Name = "Combo"
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
	
	-- Dropdown button
	self.Button = Instance.new("TextButton")
	self.Button.Name = "Button"
	self.Button.Size = UDim2.new(1, 0, 0, 24)
	self.Button.Position = UDim2.new(0, 0, 0, 20)
	self.Button.BackgroundColor3 = Theme.GetColor("FrameBG")
	self.Button.BorderSizePixel = 1
	self.Button.BorderColor3 = Theme.GetColor("Border")
	self.Button.Text = ""
	self.Button.AutoButtonColor = false
	self.Button.Parent = self.Frame
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 3)
	corner.Parent = self.Button
	
	-- Selected text
	self.SelectedText = Instance.new("TextLabel")
	self.SelectedText.Name = "SelectedText"
	self.SelectedText.Size = UDim2.new(1, -36, 1, 0)
	self.SelectedText.Position = UDim2.new(0, 8, 0, 0)
	self.SelectedText.BackgroundTransparency = 1
	self.SelectedText.Text = self:GetDisplayText()
	self.SelectedText.TextColor3 = Theme.GetColor("Text")
	self.SelectedText.TextSize = 13
	self.SelectedText.Font = Theme.GetFont()
	self.SelectedText.TextXAlignment = Enum.TextXAlignment.Left
	self.SelectedText.TextYAlignment = Enum.TextYAlignment.Center
	self.SelectedText.TextTruncate = Enum.TextTruncateAtEnd
	self.SelectedText.Parent = self.Button
	
	-- Arrow icon
	self.Arrow = Instance.new("ImageLabel")
	self.Arrow.Name = "Arrow"
	self.Arrow.Size = UDim2.new(0, 16, 0, 16)
	self.Arrow.Position = UDim2.new(1, -20, 0.5, -8)
	self.Arrow.BackgroundTransparency = 1
	self.Arrow.Image = "rbxassetid://3926307971" -- Dropdown arrow
	self.Arrow.ImageColor3 = Theme.GetColor("TextDisabled")
	self.Arrow.Rotation = 0
	self.Arrow.Parent = self.Button
	
	-- Click events
	self.Button.MouseButton1Click:Connect(function()
		self:ToggleDropdown()
	end)
	
	self.Button.MouseEnter:Connect(function()
		TweenUtils.Tween(self.Button, {BorderColor3 = Theme.GetColor("ThemeColor")}, 0.1)
	end)
	
	self.Button.MouseLeave:Connect(function()
		TweenUtils.Tween(self.Button, {BorderColor3 = Theme.GetColor("Border")}, 0.1)
	end)
end

function Combo:GetDisplayText()
	if self.Config.MultiSelect then
		local selected = {}
		for i, _ in pairs(self.SelectedItems) do
			if self.Config.Items[i] then
				table.insert(selected, self.Config.Items[i])
			end
		end
		if #selected == 0 then return "None" end
		if #selected > 3 then return #selected .. " selected" end
		return table.concat(selected, ", ")
	else
		return self.Config.Items[self.SelectedIndex] or "None"
	end
end

function Combo:ToggleDropdown()
	if self.DropdownOpen then
		self:CloseDropdown()
	else
		self:OpenDropdown()
	end
end

function Combo:OpenDropdown()
	local screenGui = self.Frame:FindFirstAncestorOfClass("ScreenGui")
	if not screenGui then return end
	
	local buttonPos = self.Button.AbsolutePosition
	local buttonSize = self.Button.AbsoluteSize
	
	self.DropdownFrame = Instance.new("Frame")
	self.DropdownFrame.Name = "ComboDropdown"
	self.DropdownFrame.Size = UDim2.new(0, buttonSize.X, 0, math.min(#self.Config.Items, self.Config.MaxVisibleItems) * 24 + 8)
	self.DropdownFrame.Position = UDim2.new(0, buttonPos.X, 0, buttonPos.Y + buttonSize.Y + 2)
	self.DropdownFrame.BackgroundColor3 = Theme.GetColor("PopupBG")
	self.DropdownFrame.BorderSizePixel = 1
	self.DropdownFrame.BorderColor3 = Theme.GetColor("Border")
	self.DropdownFrame.ZIndex = 1000
	self.DropdownFrame.ClipsDescendants = true
	self.DropdownFrame.Parent = screenGui
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 4)
	corner.Parent = self.DropdownFrame
	
	local stroke = Instance.new("UIStroke")
	stroke.Color = Theme.GetColor("ThemeColor")
	stroke.Thickness = 1
	stroke.Parent = self.DropdownFrame
	
	-- Search box (if searchable)
	local itemStartY = 4
	if self.Config.Searchable then
		local searchBox = Instance.new("TextBox")
		searchBox.Name = "SearchBox"
		searchBox.Size = UDim2.new(1, -8, 0, 24)
		searchBox.Position = UDim2.new(0, 4, 0, 4)
		searchBox.BackgroundColor3 = Theme.GetColor("FrameBG")
		searchBox.BorderSizePixel = 1
		searchBox.BorderColor3 = Theme.GetColor("Border")
		searchBox.PlaceholderText = "Search..."
		searchBox.Text = ""
		searchBox.TextColor3 = Theme.GetColor("Text")
		searchBox.PlaceholderColor3 = Theme.GetColor("TextDisabled")
		searchBox.TextSize = 12
		searchBox.Font = Theme.GetFont()
		searchBox.ClearTextOnFocus = false
		searchBox.Parent = self.DropdownFrame
		
		local searchCorner = Instance.new("UICorner")
		searchCorner.CornerRadius = UDim.new(0, 3)
		searchCorner.Parent = searchBox
		
		itemStartY = 32
		self.DropdownFrame.Size = UDim2.new(0, buttonSize.X, 0, math.min(#self.Config.Items, self.Config.MaxVisibleItems) * 24 + 36)
		
		searchBox:GetPropertyChangedSignal("Text"):Connect(function()
			self:FilterItems(searchBox.Text)
		end)
		
		searchBox:CaptureFocus()
	end
	
	-- Items container
	self.ItemsContainer = Instance.new("ScrollingFrame")
	self.ItemsContainer.Name = "ItemsContainer"
	self.ItemsContainer.Size = UDim2.new(1, -8, 1, -itemStartY - 4)
	self.ItemsContainer.Position = UDim2.new(0, 4, 0, itemStartY)
	self.ItemsContainer.BackgroundTransparency = 1
	self.ItemsContainer.BorderSizePixel = 0
	self.ItemsContainer.ScrollBarThickness = 4
	self.ItemsContainer.ScrollBarImageColor3 = Theme.GetColor("ScrollbarGrab")
	self.ItemsContainer.CanvasSize = UDim2.new(0, 0, 0, #self.Config.Items * 24)
	self.ItemsContainer.Parent = self.DropdownFrame
	
	local itemsLayout = Instance.new("UIListLayout")
	itemsLayout.Padding = UDim.new(0, 2)
	itemsLayout.Parent = self.ItemsContainer
	
	-- Create items
	self.ItemButtons = {}
	for i, itemText in ipairs(self.Config.Items) do
		self:CreateItemButton(itemText, i)
	end
	
	-- Rotate arrow
	TweenUtils.Tween(self.Arrow, {Rotation = 180}, 0.15)
	
	-- Close on click outside
	self.CloseConnection = game:GetService("UserInputService").InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			local mousePos = InputUtils.GetMousePosition()
			local framePos = self.DropdownFrame.AbsolutePosition
			local frameSize = self.DropdownFrame.AbsoluteSize
			local buttonPos2 = self.Button.AbsolutePosition
			local buttonSize2 = self.Button.AbsoluteSize
			
			local inDropdown = mousePos.X >= framePos.X and mousePos.X <= framePos.X + frameSize.X and
							  mousePos.Y >= framePos.Y and mousePos.Y <= framePos.Y + frameSize.Y
			local inButton = mousePos.X >= buttonPos2.X and mousePos.X <= buttonPos2.X + buttonSize2.X and
							mousePos.Y >= buttonPos2.Y and mousePos.Y <= buttonPos2.Y + buttonSize2.Y
			
			if not inDropdown and not inButton then
				self:CloseDropdown()
			end
		end
	end)
	
	self.DropdownOpen = true
end

function Combo:CreateItemButton(text, index)
	local button = Instance.new("TextButton")
	button.Name = "Item_" .. index
	button.Size = UDim2.new(1, 0, 0, 24)
	button.BackgroundTransparency = 1
	button.Text = ""
	button.AutoButtonColor = false
	button.Parent = self.ItemsContainer
	
	local selected = self.SelectedItems[index]
	
	-- Highlight
	local highlight = Instance.new("Frame")
	highlight.Name = "Highlight"
	highlight.Size = UDim2.new(1, 0, 1, 0)
	highlight.BackgroundColor3 = selected and Theme.GetColor("ThemeColor") or Color3.new(1, 1, 1)
	highlight.BackgroundTransparency = selected and 0.8 or 1
	highlight.BorderSizePixel = 0
	highlight.Parent = button
	
	-- Checkmark for multi-select
	if self.Config.MultiSelect then
		local check = Instance.new("ImageLabel")
		check.Name = "Check"
		check.Size = UDim2.new(0, 14, 0, 14)
		check.Position = UDim2.new(0, 4, 0.5, -7)
		check.BackgroundTransparency = 1
		check.Image = "rbxassetid://3926305904"
		check.ImageColor3 = Theme.GetColor("CheckMark")
		check.ImageTransparency = selected and 0 or 1
		check.ScaleType = Enum.ScaleType.Fit
		check.Parent = button
	end
	
	-- Text
	local label = Instance.new("TextLabel")
	label.Name = "Label"
	label.Size = UDim2.new(1, self.Config.MultiSelect and -24 or -12, 1, 0)
	label.Position = UDim2.new(0, self.Config.MultiSelect and 22 or 8, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Theme.GetColor("Text")
	label.TextSize = 12
	label.Font = Theme.GetFont()
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextYAlignment = Enum.TextYAlignment.Center
	label.TextTruncate = Enum.TextTruncateAtEnd
	label.Parent = button
	
	button.MouseEnter:Connect(function()
		if not selected then
			TweenUtils.Tween(highlight, {BackgroundTransparency = 0.9}, 0.1)
		end
	end)
	
	button.MouseLeave:Connect(function()
		if not selected then
			TweenUtils.Tween(highlight, {BackgroundTransparency = 1}, 0.1)
		end
	end)
	
	button.MouseButton1Click:Connect(function()
		if self.Config.MultiSelect then
			self.SelectedItems[index] = not self.SelectedItems[index]
			highlight.BackgroundTransparency = self.SelectedItems[index] and 0.8 or 1
			highlight.BackgroundColor3 = self.SelectedItems[index] and Theme.GetColor("ThemeColor") or Color3.new(1, 1, 1)
			button.Check.ImageTransparency = self.SelectedItems[index] and 0 or 1
		else
			self.SelectedIndex = index
			for _, btn in pairs(self.ItemButtons) do
				btn.Highlight.BackgroundTransparency = 1
			end
			highlight.BackgroundTransparency = 0.8
			highlight.BackgroundColor3 = Theme.GetColor("ThemeColor")
			self.SelectedText.Text = self:GetDisplayText()
			self:CloseDropdown()
		end
		
		if self.Config.Callback then
			if self.Config.MultiSelect then
				self.Config.Callback(self:GetSelectedIndices())
			else
				self.Config.Callback(index, text)
			end
		end
	end)
	
	self.ItemButtons[index] = button
end

function Combo:FilterItems(searchText)
	searchText = searchText:lower()
	
	for i, button in pairs(self.ItemButtons) do
		local itemText = self.Config.Items[i]:lower()
		local visible = searchText == "" or itemText:find(searchText, 1, true)
		button.Visible = visible
	end
	
	self.ItemsContainer.CanvasSize = UDim2.new(0, 0, 0, #self.Config.Items * 26)
end

function Combo:CloseDropdown()
	if self.DropdownFrame then
		self.DropdownFrame:Destroy()
		self.DropdownFrame = nil
	end
	if self.CloseConnection then
		self.CloseConnection:Disconnect()
		self.CloseConnection = nil
	end
	
	TweenUtils.Tween(self.Arrow, {Rotation = 0}, 0.15)
	self.DropdownOpen = false
end

function Combo:GetSelectedIndices()
	local indices = {}
	for i, _ in pairs(self.SelectedItems) do
		table.insert(indices, i)
	end
	table.sort(indices)
	return indices
end

function Combo:SetValue(index)
	if self.Config.MultiSelect then return end
	
	self.SelectedIndex = math.clamp(index, 1, #self.Config.Items)
	self.SelectedItems = {}
	self.SelectedItems[self.SelectedIndex] = true
	self.SelectedText.Text = self:GetDisplayText()
	
	if self.DropdownOpen then
		for i, button in pairs(self.ItemButtons) do
			button.Highlight.BackgroundTransparency = (i == self.SelectedIndex) and 0.8 or 1
			button.Highlight.BackgroundColor3 = Theme.GetColor("ThemeColor")
		end
	end
	
	if self.Config.Callback then
		self.Config.Callback(self.SelectedIndex, self.Config.Items[self.SelectedIndex])
	end
end

function Combo:SetValues(items)
	self.Config.Items = items
	self.SelectedIndex = 1
	self.SelectedItems = {[1] = true}
	self.SelectedText.Text = self:GetDisplayText()
end

function Combo:UpdateTheme()
	self.Label.TextColor3 = Theme.GetColor("Text")
	self.Label.Font = Theme.GetFont()
	self.Button.BackgroundColor3 = Theme.GetColor("FrameBG")
	self.Button.BorderColor3 = Theme.GetColor("Border")
	self.SelectedText.TextColor3 = Theme.GetColor("Text")
	self.SelectedText.Font = Theme.GetFont()
	self.Arrow.ImageColor3 = Theme.GetColor("TextDisabled")
	
	if self.DropdownOpen and self.DropdownFrame then
		self.DropdownFrame.BackgroundColor3 = Theme.GetColor("PopupBG")
		self.DropdownFrame.BorderColor3 = Theme.GetColor("Border")
		
		for _, button in pairs(self.ItemButtons) do
			if button:FindFirstChild("Label") then
				button.Label.TextColor3 = Theme.GetColor("Text")
				button.Label.Font = Theme.GetFont()
			end
			if button:FindFirstChild("Check") then
				button.Check.ImageColor3 = Theme.GetColor("CheckMark")
			end
		end
	end
end

function Combo:Destroy()
	self:CloseDropdown()
	self.Frame:Destroy()
end

return Combo