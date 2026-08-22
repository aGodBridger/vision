-- AmberGUI Core Module
-- Main entry point, manages GUI lifecycle, state, and rendering

local Theme = require("Theme")
local TweenUtils = require("Utils.Tween")
local ColorUtils = require("Utils.Color")
local InputUtils = require("Utils.Input")

local AmberGUI = {}
AmberGUI.__index = AmberGUI

-- Library version
AmberGUI.Version = "1.0.0"

-- Global state
AmberGUI.Windows = {}
AmberGUI.ActiveWindow = nil
AmberGUI.ScreenGui = nil
AmberGUI.Initialized = false
AmberGUI.Visible = true
AmberGUI.MenuKeybind = InputUtils.Keybind.new(Enum.KeyCode.Insert, InputUtils.KeybindType.TOGGLE)

-- Notifications
AmberGUI.Notifications = {}
AmberGUI.NotificationQueue = {}

-- Tooltip
AmberGUI.Tooltip = nil
AmberGUI.TooltipText = ""

-- Focus management
AmberGUI.FocusedWindow = nil
AmberGUI.FocusedWidget = nil

-- Initialize the library
function AmberGUI.Init(parent)
	if AmberGUI.Initialized then return AmberGUI end
	
	-- Create ScreenGui
	AmberGUI.ScreenGui = Instance.new("ScreenGui")
	AmberGUI.ScreenGui.Name = "AmberGUI"
	AmberGUI.ScreenGui.ResetOnSpawn = false
	AmberGUI.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	AmberGUI.ScreenGui.DisplayOrder = 1000
	AmberGUI.ScreenGui.IgnoreGuiInset = true
	
	if parent then
		AmberGUI.ScreenGui.Parent = parent
	else
		AmberGUI.ScreenGui.Parent = game:GetService("CoreGui") or game.Players.LocalPlayer:WaitForChild("PlayerGui")
	end
	
	-- Initialize input system
	InputUtils.Init()
	
	-- Register menu toggle keybind
	InputUtils.RegisterKeybind("MenuToggle", AmberGUI.MenuKeybind, function(enabled)
		AmberGUI.SetVisible(enabled)
	end)
	
	-- Create notification container
	AmberGUI.NotificationContainer = Instance.new("Frame")
	AmberGUI.NotificationContainer.Name = "NotificationContainer"
	AmberGUI.NotificationContainer.Size = UDim2.new(1, 0, 1, 0)
	AmberGUI.NotificationContainer.BackgroundTransparency = 1
	AmberGUI.NotificationContainer.ZIndex = 10000
	AmberGUI.NotificationContainer.Parent = AmberGUI.ScreenGui
	
	-- Create tooltip
	AmberGUI.Tooltip = Instance.new("TextLabel")
	AmberGUI.Tooltip.Name = "Tooltip"
	AmberGUI.Tooltip.BackgroundColor3 = Theme.GetColor("PopupBG")
	AmberGUI.Tooltip.BackgroundTransparency = 0.1
	AmberGUI.Tooltip.BorderSizePixel = 1
	AmberGUI.Tooltip.BorderColor3 = Theme.GetColor("Border")
	AmberGUI.Tooltip.TextColor3 = Theme.GetColor("Text")
	AmberGUI.Tooltip.TextSize = 13
	AmberGUI.Tooltip.Font = Theme.GetFont()
	AmberGUI.Tooltip.TextXAlignment = Enum.TextXAlignment.Left
	AmberGUI.Tooltip.TextYAlignment = Enum.TextYAlignment.Center
	AmberGUI.Tooltip.Visible = false
	AmberGUI.Tooltip.ZIndex = 10001
	AmberGUI.Tooltip.Parent = AmberGUI.ScreenGui
	
	local tooltipCorner = Instance.new("UICorner")
	tooltipCorner.CornerRadius = UDim.new(0, 4)
	tooltipCorner.Parent = AmberGUI.Tooltip
	
	local tooltipPadding = Instance.new("UIPadding")
	tooltipPadding.PaddingLeft = UDim.new(0, 8)
	tooltipPadding.PaddingRight = UDim.new(0, 8)
	tooltipPadding.PaddingTop = UDim.new(0, 4)
	tooltipPadding.PaddingBottom = UDim.new(0, 4)
	tooltipPadding.Parent = AmberGUI.Tooltip
	
	AmberGUI.Initialized = true
	
	-- Start render loop
	task.spawn(AmberGUI.RenderLoop)
	
	return AmberGUI
end

-- Main render loop
function AmberGUI.RenderLoop()
	local RunService = game:GetService("RunService")
	
	RunService.Heartbeat:Connect(function(deltaTime)
		if not AmberGUI.Visible then return end
		
		-- Update notifications
		AmberGUI.UpdateNotifications(deltaTime)
		
		-- Update tooltip position
		AmberGUI.UpdateTooltip()
		
		-- Update all windows
		for _, window in pairs(AmberGUI.Windows) do
			if window.Update then
				window:Update(deltaTime)
			end
		end
	end)
end

-- Create a new window
function AmberGUI.CreateWindow(options)
	local Window = require("Windows.Window")
	return Window.new(options)
end

-- Show/hide all GUI
function AmberGUI.SetVisible(visible)
	AmberGUI.Visible = visible
	if AmberGUI.ScreenGui then
		AmberGUI.ScreenGui.Enabled = visible
	end
end

function AmberGUI.Toggle()
	AmberGUI.SetVisible(not AmberGUI.Visible)
end

-- Add notification
function AmberGUI.Notify(text, duration, color)
	duration = duration or 5
	color = color or Theme.GetColor("ThemeColor")
	
	table.insert(AmberGUI.NotificationQueue, {
		text = text,
		duration = duration,
		color = color,
		time = 0,
		yOffset = 0,
		alpha = 0,
		targetY = 0
	})
end

-- Update notifications
function AmberGUI.UpdateNotifications(deltaTime)
	local container = AmberGUI.NotificationContainer
	if not container then return end
	
	local screenSize = AmberGUI.ScreenGui.AbsoluteSize
	local baseX = screenSize.X * 0.5
	local baseY = screenSize.Y - 100
	local spacing = 28
	
	-- Calculate target positions
	local targetY = baseY
	for i = #AmberGUI.Notifications, 1, -1 do
		AmberGUI.Notifications[i].targetY = targetY
		targetY = targetY - spacing
	end
	
	-- Process queue
	for _, notif in ipairs(AmberGUI.NotificationQueue) do
		table.insert(AmberGUI.Notifications, 1, notif)
	end
	AmberGUI.NotificationQueue = {}
	
	-- Update and render
	local toRemove = {}
	for i, notif in ipairs(AmberGUI.Notifications) do
		notif.time = notif.time + deltaTime
		
		-- Fade in
		if notif.time < 0.3 then
			notif.alpha = notif.alpha + (1 - notif.alpha) * 0.2
		end
		
		-- Fade out
		if notif.time > notif.duration - 0.5 then
			notif.alpha = notif.alpha + (0 - notif.alpha) * 0.15
		end
		
		-- Smooth Y position
		notif.yOffset = notif.yOffset + (notif.targetY - notif.yOffset) * 0.15
		
		-- Remove if expired
		if notif.time > notif.duration or notif.alpha < 0.01 then
			table.insert(toRemove, i)
		else
			-- Render notification
			AmberGUI.RenderNotification(notif, baseX, notif.yOffset)
		end
	end
	
	-- Remove expired
	for i = #toRemove, 1, -1 do
		table.remove(AmberGUI.Notifications, toRemove[i])
	end
end

-- Render a single notification
function AmberGUI.RenderNotification(notif, x, y)
	local container = AmberGUI.NotificationContainer
	
	-- Create or reuse label
	local label = container:FindFirstChild("Notif_" .. notif.text)
	if not label then
		label = Instance.new("TextLabel")
		label.Name = "Notif_" .. notif.text
		label.BackgroundTransparency = 1
		label.TextColor3 = Color3.new(1, 1, 1)
		label.TextStrokeTransparency = 0
		label.TextStrokeColor3 = Color3.new(0, 0, 0)
		label.TextSize = 14
		label.Font = Theme.GetFont()
		label.TextXAlignment = Enum.TextXAlignment.Center
		label.TextYAlignment = Enum.TextYAlignment.Center
		label.Parent = container
	end
	
	label.Text = notif.text
	label.TextTransparency = 1 - notif.alpha
	label.TextStrokeTransparency = 1 - notif.alpha
	
	local textSize = game:GetService("TextService"):GetTextSize(
		notif.text, 14, Theme.GetFont(), Vector2.new(math.huge, math.huge)
	)
	
	label.Size = UDim2.new(0, textSize.X + 20, 0, textSize.Y + 8)
	label.Position = UDim2.new(0, x - label.Size.X.Offset * 0.5, 0, y)
	label.ZIndex = 10000
end

-- Update tooltip
function AmberGUI.UpdateTooltip()
	if not AmberGUI.Tooltip or not AmberGUI.TooltipText or AmberGUI.TooltipText == "" then
		if AmberGUI.Tooltip then AmberGUI.Tooltip.Visible = false end
		return
	end
	
	local mousePos = InputUtils.GetMousePosition()
	AmberGUI.Tooltip.Text = AmberGUI.TooltipText
	AmberGUI.Tooltip.Visible = true
	AmberGUI.Tooltip.Position = UDim2.new(0, mousePos.X + 16, 0, mousePos.Y + 16)
end

function AmberGUI.SetTooltip(text)
	AmberGUI.TooltipText = text or ""
end

-- Get theme
function AmberGUI.GetTheme()
	return Theme
end

-- Cleanup
function AmberGUI.Destroy()
	if AmberGUI.ScreenGui then
		AmberGUI.ScreenGui:Destroy()
	end
	AmberGUI.Windows = {}
	AmberGUI.Initialized = false
end

return AmberGUI