-- AmberGUI Players Tab
-- Replicates the Players tab with player list, search, filters, and actions

local Theme = require("Theme")
local Child = require("Widgets.Child")
local Checkbox = require("Widgets.Checkbox")
local Slider = require("Widgets.Slider")
local Combo = require("Widgets.Combo")
local ColorPicker = require("Widgets.ColorPicker")
local Input = require("Widgets.Input")
local Button = require("Widgets.Button")
local Separator = require("Widgets.Separator")
local InputUtils = require("Utils.Input")

local PlayersTab = {}

function PlayersTab.Create(window, globals)
	-- Main holder child (full width)
	local playersChild = window:CreateChild("Players", {
		Title = "",
		Size = UDim2.new(1, 0, 1, 0),
		ShowTitle = false,
	})
	playersChild.Frame.LayoutOrder = 1
	
	-- Search bar
	local searchInput = playersChild:AddInput("Search", "", function(text)
		globals.misc.player_search = text
	end, "Search...")
	searchInput.Frame.Size = UDim2.new(1, 0, 0, 28)
	searchInput.Label.Visible = false
	searchInput.TextBox.Size = UDim2.new(1, 0, 0, 24)
	
	-- Filter dropdown
	local filterCombo = playersChild:AddCombo("Filter", {"All", "Neutral", "Friendly", "Enemy", "Target"}, 1, function(i)
		globals.misc.player_filter = i - 1
	end)
	filterCombo.Frame.Size = UDim2.new(1, 0, 0, 28)
	filterCombo.Label.Visible = false
	filterCombo.Button.Size = UDim2.new(1, 0, 0, 24)
	filterCombo.Button.Position = UDim2.new(0, 0, 0, 4)
	
	-- Player list container (scrolling frame)
	local listContainer = Instance.new("Frame")
	listContainer.Name = "PlayerListContainer"
	listContainer.Size = UDim2.new(1, 0, 1, -120)
	listContainer.BackgroundTransparency = 1
	listContainer.Parent = playersChild.Content
	
	local listScroll = Instance.new("ScrollingFrame")
	listScroll.Name = "PlayerList"
	listScroll.Size = UDim2.new(1, 0, 1, 0)
	listScroll.BackgroundColor3 = Theme.GetColor("Child")
	listScroll.BorderSizePixel = 1
	listScroll.BorderColor3 = Theme.GetColor("Border")
	listScroll.ScrollBarThickness = 4
	listScroll.ScrollBarImageColor3 = Theme.GetColor("ScrollbarGrab")
	listScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	listScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	listScroll.Parent = listContainer
	
	local listCorner = Instance.new("UICorner")
	listCorner.CornerRadius = UDim.new(0, 4)
	listCorner.Parent = listScroll
	
	local listStroke = Instance.new("UIStroke")
	listStroke.Color = Theme.GetColor("ThemeColor")
	listStroke.Thickness = 1
	listStroke.Parent = listScroll
	
	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 2)
	listLayout.Parent = listScroll
	
	local listPadding = Instance.new("UIPadding")
	listPadding.PaddingTop = UDim.new(0, 4)
	listPadding.PaddingLeft = UDim.new(0, 4)
	listPadding.PaddingRight = UDim.new(0, 4)
	listPadding.PaddingBottom = UDim.new(0, 4)
	listPadding.Parent = listScroll
	
	-- Bottom panels: Actions & Custom
	local bottomFrame = Instance.new("Frame")
	bottomFrame.Name = "BottomPanels"
	bottomFrame.Size = UDim2.new(1, 0, 0, 100)
	bottomFrame.BackgroundTransparency = 1
	bottomFrame.Parent = playersChild.Content
	
	local bottomLayout = Instance.new("UIListLayout")
	bottomLayout.FillDirection = Enum.FillDirection.Horizontal
	bottomLayout.Padding = UDim.new(0, 8)
	bottomLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	bottomLayout.Parent = bottomFrame
	
	-- Actions panel
	local actionsChild = playersChild:AddChild({
		Title = "Actions",
		Size = UDim2.new(0.5, -4, 0, 100),
		ShowTitle = true,
		AutoHeight = false,
	})
	actionsChild.Frame.Parent = bottomFrame
	actionsChild.Frame.LayoutOrder = 1
	
	actionsChild:AddLabel("No player selected")
	
	-- Custom/Filters panel
	local customChild = playersChild:AddChild({
		Title = "Filters",
		Size = UDim2.new(0.5, -4, 0, 100),
		ShowTitle = true,
		AutoHeight = false,
	})
	customChild.Frame.Parent = bottomFrame
	customChild.Frame.LayoutOrder = 2
	
	customChild:AddCombo("Filter", {"All", "Neutral", "Friendly", "Enemy", "Target"}, 1, function(i)
		globals.misc.player_filter = i - 1
	end)
	
	customChild:AddSeparator()
	customChild:AddLabel("Auto Friend Groups")
	
	local groupInput = customChild:AddInput("Group ID", globals.misc.autofriend_group_id or "", function(text)
		globals.misc.autofriend_group_id = text
	end, "Group ID")
	groupInput.Label.Visible = false
	groupInput.TextBox.Size = UDim2.new(1, 0, 0, 24)
	
	local autoAddBtn = customChild:AddButton("Auto Add Friend", function()
		-- Trigger autofriend
		globals.misc.trigger_autofriend = true
	end)
	
	local bulkAddBtn = customChild:AddButton("Bulk Add Targets", function()
		globals.misc.show_bulk_add = true
	end)
	
	-- Store references for updating
	playersChild.ListScroll = listScroll
	playersChild.ActionsChild = actionsChild
	playersChild.SelectedPlayer = nil
	
	-- Function to refresh player list
	function playersChild:RefreshPlayerList()
		-- Clear existing
		for _, child in ipairs(listScroll:GetChildren()) do
			if child:IsA("TextButton") or child:IsA("Frame") then
				child:Destroy()
			end
		end
		
		-- Mock player data (in real use, this would come from globals.instances.cachedplayers)
		local players = globals.misc.mock_players or {
			{name = "Player1", displayname = "PlayerOne", health = 100, maxhealth = 100, team = "Neutral"},
			{name = "Player2", displayname = "PlayerTwo", health = 50, maxhealth = 100, team = "Enemy"},
			{name = "Player3", displayname = "PlayerThree", health = 100, maxhealth = 100, team = "Friendly"},
			{name = "LocalPlayer", displayname = "You", health = 100, maxhealth = 100, team = "Client"},
		}
		
		local searchText = (globals.misc.player_search or ""):lower()
		local filter = globals.misc.player_filter or 0
		
		for _, player in ipairs(players) do
			-- Search filter
			local shouldContinue = false
			if searchText ~= "" then
				local nameMatch = player.name:lower():find(searchText, 1, true)
				local displayMatch = player.displayname:lower():find(searchText, 1, true)
				if not nameMatch and not displayMatch then shouldContinue = true end
			end
			
			if not shouldContinue then
				-- Team filter
				local isClient = player.team == "Client"
				local isFriendly = player.team == "Friendly"
				local isEnemy = player.team == "Enemy"
				local isTarget = globals.visuals.target_only_list and table.find(globals.visuals.target_only_list, player.name)
				
				local passFilter = false
				if filter == 0 then passFilter = true -- All
				elseif filter == 1 then passFilter = not isFriendly and not isEnemy and not isTarget -- Neutral
				elseif filter == 2 then passFilter = isFriendly -- Friendly
				elseif filter == 3 then passFilter = isEnemy or isTarget -- Enemy
				elseif filter == 4 then passFilter = isTarget -- Target Only
				end
				
				if passFilter then
					-- Create player card
					local card = Instance.new("TextButton")
			card.Name = "PlayerCard_" .. player.name
			card.Size = UDim2.new(1, 0, 0, 30)
			card.BackgroundTransparency = 1
			card.Text = ""
			card.AutoButtonColor = false
			card.Parent = listScroll
			
			local highlight = Instance.new("Frame")
			highlight.Name = "Highlight"
			highlight.Size = UDim2.new(1, 0, 1, 0)
			highlight.BackgroundTransparency = 1
			highlight.BorderSizePixel = 0
			highlight.Parent = card
			
			local cardCorner = Instance.new("UICorner")
			cardCorner.CornerRadius = UDim.new(0, 3)
			cardCorner.Parent = highlight
			
			-- Name text
			local nameLabel = Instance.new("TextLabel")
			nameLabel.Size = UDim2.new(1, -80, 1, 0)
			nameLabel.Position = UDim2.new(0, 10, 0, 0)
			nameLabel.BackgroundTransparency = 1
			nameLabel.Text = player.displayname .. " @" .. player.name
			nameLabel.TextColor3 = Theme.GetColor("Text")
			nameLabel.TextSize = 13
			nameLabel.Font = Theme.GetFont()
			nameLabel.TextXAlignment = Enum.TextXAlignment.Left
			nameLabel.TextYAlignment = Enum.TextYAlignment.Center
			nameLabel.TextTruncate = Enum.TextTruncateAtEnd
			nameLabel.Parent = card
			
			-- Status badge
			local statusText = "Neutral"
			local statusColor = Color3.new(0.6, 0.6, 0.6)
			if isClient then
				statusText = "Client"
				statusColor = Theme.GetColor("ThemeColor")
			elseif isTarget then
				statusText = "Target"
				statusColor = Color3.new(0, 0, 0)
			elseif isFriendly then
				statusText = "Friendly"
				statusColor = Color3.new(0, 1, 0)
			elseif isEnemy then
				statusText = "Enemy"
				statusColor = Color3.new(1, 0, 0)
			end
			
			local statusLabel = Instance.new("TextLabel")
			statusLabel.Size = UDim2.new(0, 70, 1, 0)
			statusLabel.Position = UDim2.new(1, -70, 0, 0)
			statusLabel.BackgroundTransparency = 1
			statusLabel.Text = statusText
			statusLabel.TextColor3 = statusColor
			statusLabel.TextSize = 12
			statusLabel.Font = Theme.GetFont()
			statusLabel.TextXAlignment = Enum.TextXAlignment.Right
			statusLabel.TextYAlignment = Enum.TextYAlignment.Center
			statusLabel.Parent = card
			
			-- Hover/selection effects
			card.MouseEnter:Connect(function()
				if playersChild.SelectedPlayer ~= player.name then
					highlight.BackgroundTransparency = 0.95
					highlight.BackgroundColor3 = Color3.new(1, 1, 1)
				end
			end)
			
			card.MouseLeave:Connect(function()
				if playersChild.SelectedPlayer ~= player.name then
					highlight.BackgroundTransparency = 1
				end
			end)
			
			card.MouseButton1Click:Connect(function()
				playersChild:SelectPlayer(player)
			end)
		end
	end
	end
end
	
	function playersChild:SelectPlayer(player)
		self.SelectedPlayer = player.name
		
		-- Update visual selection
		for _, child in ipairs(listScroll:GetChildren()) do
			local highlight = child:FindFirstChild("Highlight")
			if highlight then
				if child.Name == "PlayerCard_" .. player.name then
					highlight.BackgroundTransparency = 0.8
					highlight.BackgroundColor3 = Color3.new(0.2, 0.2, 0.25)
				else
					highlight.BackgroundTransparency = 1
				end
			end
		end
		
		-- Update actions panel
		self:UpdateActionsPanel(player)
	end
	
	function playersChild:UpdateActionsPanel(player)
		-- Clear actions
		for _, child in ipairs(self.ActionsChild.Content:GetChildren()) do
			if child:IsA("TextButton") or child:IsA("TextLabel") then
				child:Destroy()
			end
		end
		
		local isMe = player.team == "Client"
		
		if isMe then
			local label = Instance.new("TextLabel")
			label.Size = UDim2.new(1, 0, 0, 24)
			label.BackgroundTransparency = 1
			label.Text = "Cannot perform actions on self"
			label.TextColor3 = Theme.GetColor("TextDisabled")
			label.TextSize = 13
			label.Font = Theme.GetFont()
			label.TextXAlignment = Enum.TextXAlignment.Center
			label.Parent = self.ActionsChild.Content
			return
		end
		
		local function createActionBtn(text, callback)
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1, -16, 0, 22)
			btn.BackgroundColor3 = Theme.GetColor("Button")
			btn.BorderSizePixel = 1
			btn.BorderColor3 = Theme.GetColor("Border")
			btn.Text = text
			btn.TextColor3 = Theme.GetColor("Text")
			btn.TextSize = 12
			btn.Font = Theme.GetFont()
			btn.Parent = self.ActionsChild.Content
			
			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(0, 4)
			corner.Parent = btn
			
			btn.MouseButton1Click:Connect(callback)
			
			btn.MouseEnter:Connect(function()
				btn.BackgroundColor3 = Theme.GetColor("ButtonHovered")
				btn.BorderColor3 = Theme.GetColor("ThemeColor")
			end)
			
			btn.MouseLeave:Connect(function()
				btn.BackgroundColor3 = Theme.GetColor("Button")
				btn.BorderColor3 = Theme.GetColor("Border")
			end)
			
			return btn
		end
		
		local isInTargetList = globals.visuals.target_only_list and table.find(globals.visuals.target_only_list, player.name)
		local isSpectating = globals.misc.spectate_target_name == player.name
		local isFriendly = globals.bools.player_status and globals.bools.player_status[player.name] == true
		local isEnemy = globals.bools.player_status and globals.bools.player_status[player.name] == false
		
		-- Teleport
		createActionBtn("Teleport To", function()
			globals.misc.teleport_to = player.name
		end)
		
		-- Spectate
		createActionBtn(isSpectating and "Unspectate" or "Spectate", function()
			if isSpectating then
				globals.misc.spectate_target_name = ""
			else
				globals.misc.spectate_target_name = player.name
			end
			self:UpdateActionsPanel(player)
		end)
		
		-- Target Only
		createActionBtn(isInTargetList and "Remove Target Only" or "Set Target Only", function()
			if isInTargetList then
				for i, name in ipairs(globals.visuals.target_only_list) do
					if name == player.name then
						table.remove(globals.visuals.target_only_list, i)
						break
					end
				end
				if globals.bools.player_status then
					globals.bools.player_status[player.name] = nil
				end
			else
				table.insert(globals.visuals.target_only_list, player.name)
				if globals.bools.player_status then
					globals.bools.player_status[player.name] = false
				end
				globals.visuals.target_only_esp = true
			end
			self:UpdateActionsPanel(player)
			self:RefreshPlayerList()
		end)
		
		-- Status cycle (Neutral -> Friendly -> Enemy -> Neutral)
		if not isInTargetList then
			local statusText
			if isFriendly then statusText = "Set as Enemy"
			elseif isEnemy then statusText = "Set as Neutral"
			else statusText = "Set as Friendly" end
			
			createActionBtn(statusText, function()
				if isFriendly then
					globals.bools.player_status[player.name] = false
				elseif isEnemy then
					globals.bools.player_status[player.name] = nil
				else
					globals.bools.player_status[player.name] = true
				end
				self:UpdateActionsPanel(player)
				self:RefreshPlayerList()
			end)
		end
		
		-- Copy Username
		createActionBtn("Copy Username", function()
			globals.misc.copied_username = player.name
		end)
		
		-- Copy ID
		createActionBtn("Copy ID", function()
			globals.misc.copied_userid = player.name
		end)
	end
	
	-- Initial refresh
	task.spawn(function()
		task.wait(0.1)
		playersChild:RefreshPlayerList()
	end)
	
	return playersChild
end

return PlayersTab