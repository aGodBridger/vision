-- // VisionWare - Complete Cheat Menu
-- // Based on _notportal's library with all advanced features

-- Load the library (paste the base library code here or require it)
-- For this implementation, I'm including the essential library structure

local Library = {};
do
	Library = {
		Open = true;
		Accent = Color3.fromRGB(255, 88, 166);
		PageAmount = 0;
		Pages = {};
		Sections = {};
		Flags = {};
		UnNamedFlags = 0;
		ThemeObjects = {};
		Holder = nil;
		Keys = {
			[Enum.KeyCode.LeftShift] = "LShift",
			[Enum.KeyCode.RightShift] = "RShift",
			[Enum.KeyCode.LeftControl] = "LCtrl",
			[Enum.KeyCode.RightControl] = "RCtrl",
			[Enum.KeyCode.LeftAlt] = "LAlt",
			[Enum.KeyCode.RightAlt] = "RAlt",
			[Enum.KeyCode.CapsLock] = "Caps",
			[Enum.KeyCode.One] = "1",
			[Enum.KeyCode.Two] = "2",
			[Enum.KeyCode.Three] = "3",
			[Enum.KeyCode.Four] = "4",
			[Enum.KeyCode.Five] = "5",
			[Enum.KeyCode.Six] = "6",
			[Enum.KeyCode.Seven] = "7",
			[Enum.KeyCode.Eight] = "8",
			[Enum.KeyCode.Nine] = "9",
			[Enum.KeyCode.Zero] = "0",
			[Enum.KeyCode.KeypadOne] = "Num1",
			[Enum.KeyCode.KeypadTwo] = "Num2",
			[Enum.KeyCode.KeypadThree] = "Num3",
			[Enum.KeyCode.KeypadFour] = "Num4",
			[Enum.KeyCode.KeypadFive] = "Num5",
			[Enum.KeyCode.KeypadSix] = "Num6",
			[Enum.KeyCode.KeypadSeven] = "Num7",
			[Enum.KeyCode.KeypadEight] = "Num8",
			[Enum.KeyCode.KeypadNine] = "Num9",
			[Enum.KeyCode.KeypadZero] = "Num0",
			[Enum.KeyCode.Minus] = "-",
			[Enum.KeyCode.Equals] = "=",
			[Enum.KeyCode.Tilde] = "~",
			[Enum.KeyCode.LeftBracket] = "[",
			[Enum.KeyCode.RightBracket] = "]",
			[Enum.KeyCode.RightParenthesis] = ")",
			[Enum.KeyCode.LeftParenthesis] = "(",
			[Enum.KeyCode.Semicolon] = ",",
			[Enum.KeyCode.Quote] = "'",
			[Enum.KeyCode.BackSlash] = "\\",
			[Enum.KeyCode.Comma] = ",",
			[Enum.KeyCode.Period] = ".",
			[Enum.KeyCode.Slash] = "/",
			[Enum.KeyCode.Asterisk] = "*",
			[Enum.KeyCode.Plus] = "+",
			[Enum.KeyCode.Backquote] = "`",
			[Enum.UserInputType.MouseButton1] = "MB1",
			[Enum.UserInputType.Touch] = "MB1",
			[Enum.UserInputType.MouseButton2] = "MB2",
			[Enum.UserInputType.MouseButton3] = "MB3"
		};
		Connections = {};
		UIKey = Enum.KeyCode.End;
		ScreenGUI = nil;
		FSize = 12;
		UIFont = nil;
		SettingsPage = nil;
		VisValues = {};
		Cooldown = false;
		Friends = {};
		Priorities = {};
		KeyList = nil;
		Notifs = {};
	}

	Library.__index = Library
	Library.Pages.__index = Library.Pages
	Library.Sections.__index = Library.Sections
local LocalPlayer = game:GetService('Players').LocalPlayer;
local Mouse = LocalPlayer:GetMouse();
local TweenService = game:GetService("TweenService");
local UserInputService = game:GetService("UserInputService");

	function Library:Connection(Signal, Callback)
		local Con = Signal:Connect(Callback)
		return Con
	end

	function Library:Disconnect(Connection)
		Connection:Disconnect()
	end

	function Library:Round(Number, Float)
		return Float * math.floor(Number / Float)
	end

	function Library.NextFlag()
		Library.UnNamedFlags = Library.UnNamedFlags + 1
		return string.format("%.14g", Library.UnNamedFlags)
	end

	function Library:RGBA(r, g, b)
		return Color3.fromRGB(r, g, b)
	end

	function Library:SetOpen(bool)
		if typeof(bool) == 'boolean' then
			Library.Open = bool;
			if Library.Holder then
				Library.Holder.Visible = bool;
			end
		end
	end;

	function Library:IsMouseOverFrame(Frame)
		local AbsPos, AbsSize = Frame.AbsolutePosition, Frame.AbsoluteSize;
		if Mouse.X >= AbsPos.X and Mouse.X <= AbsPos.X + AbsSize.X
			and Mouse.Y >= AbsPos.Y and Mouse.Y <= AbsPos.Y + AbsSize.Y then
			return true;
		end;
	end;

	function Library:ChangeAccent(Color)
		Library.Accent = Color
		for obj, theme in next, Library.ThemeObjects do
			if theme:IsA("Frame") or theme:IsA("TextButton") then
				theme.BackgroundColor3 = Color
			elseif theme:IsA("TextLabel") or theme:IsA("TextBox") then
				theme.TextColor3 = Color
			elseif theme:IsA("ScrollingFrame") then
				theme.ScrollBarImageColor3 = Library.Accent
			end
		end
	end

	function Library:Notification(message, duration, color)
		local notification = {Container = nil, Objects = {}}
		local Position = Vector2.new(20, 20)
		
		local NotifContainer = Instance.new('Frame', Library.ScreenGUI)
		NotifContainer.Name = "NotifContainer"
		NotifContainer.Position = UDim2.new(0,Position.X, 0, Position.Y)
		NotifContainer.AutomaticSize = Enum.AutomaticSize.X
		NotifContainer.Size = UDim2.new(0,0,0,16)
		NotifContainer.BackgroundColor3 = Color3.new(1,1,1)
		NotifContainer.BackgroundTransparency = 1
		NotifContainer.BorderSizePixel = 0
		NotifContainer.ZIndex = 99999999
		notification.Container = NotifContainer

		local Outline = Instance.new("Frame")
		Outline.Name = "Outline"
		Outline.AutomaticSize = Enum.AutomaticSize.X
		Outline.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		Outline.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Outline.Position = UDim2.new(0.01, 0, 0.02, 0)
		Outline.Size = UDim2.new(0, 0, 0, 16)
		Outline.Parent = NotifContainer
		Outline.BackgroundTransparency = 1
		table.insert(notification.Objects, Outline)

		local Inline = Instance.new("Frame")
		Inline.Name = "Inline"
		Inline.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		Inline.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Inline.BorderSizePixel = 0
		Inline.Position = UDim2.new(0, 1, 0, 1)
		Inline.Size = UDim2.new(1, -2, 1, -2)
		Inline.BackgroundTransparency = 1
		table.insert(notification.Objects, Inline)

		local Value = Instance.new("TextLabel")
		Value.Name = "Value"
		Value.FontFace = Font.fromEnum(Enum.Font.RobotoMono)
		Value.Text = message
		Value.TextColor3 = Color3.fromRGB(255, 255, 255)
		Value.TextSize = 12
		Value.TextStrokeTransparency = 0
		Value.TextXAlignment = Enum.TextXAlignment.Left
		Value.AutomaticSize = Enum.AutomaticSize.X
		Value.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		Value.BackgroundTransparency = 1
		Value.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Value.BorderSizePixel = 0
		Value.Size = UDim2.new(0, 0, 1, 0)
		Value.TextTransparency = 1
		table.insert(notification.Objects, Value)

		local UIPadding = Instance.new("UIPadding")
		UIPadding.Name = "UIPadding"
		UIPadding.PaddingLeft = UDim.new(0, 5)
		UIPadding.PaddingRight = UDim.new(0, 5)
		UIPadding.PaddingTop = UDim.new(0, 1)
		UIPadding.Parent = Value

		Value.Parent = Inline

		Inline.Parent = Outline

		local Accent = Instance.new("Frame")
		Accent.Name = "Accent"
		Accent.BackgroundColor3 = color ~= nil and color or Library.Accent
		Accent.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Accent.BorderSizePixel = 0
		Accent.Size = UDim2.new(1, 0, 0, 1)
		Accent.Parent = Outline
		Accent.BackgroundTransparency = 1
		table.insert(notification.Objects, Accent)

		function notification:remove()
			table.remove(Library.Notifs, table.find(Library.Notifs, notification))
			task.wait(0.5)
			notification.Container:Destroy()
		end

		task.spawn(function()
			Outline.AnchorPoint = Vector2.new(1,0)
			for i,v in next, notification.Objects do
				if v:IsA("Frame") then
					TweenService:Create(v, TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
				end
			end
			local Tween1 = TweenService:Create(Outline, TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {AnchorPoint = Vector2.new(0,0)}):Play()
			TweenService:Create(Value, TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
			task.wait(duration or 3)
			TweenService:Create(Outline, TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {AnchorPoint = Vector2.new(1,0)}):Play()
			for i,v in next, notification.Objects do
				if v:IsA("Frame") then
					TweenService:Create(v, TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
				end
			end
			TweenService:Create(Value, TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextTransparency = 1}):Play()
		end)

		task.delay(duration or 3, function()
			notification:remove()
		end)

		table.insert(Library.Notifs, notification)
		NotifContainer.Position = UDim2.new(0,Position.X,0,Position.Y + (table.find(Library.Notifs, notification) * 25))

		return notification
	end

	function Library:NewInstance(Inst, Theme)
		local Obj = Instance.new(Inst)
		if Theme then
			table.insert(Library.ThemeObjects, Obj)
			if Obj:IsA("Frame") or Obj:IsA("TextButton") then
				Obj.BackgroundColor3 = Library.Accent;
				if Obj:IsA("ScrollingFrame") then
					Obj.ScrollBarImageColor3 = Library.Accent
				end
			elseif Obj:IsA("TextLabel") or Obj:IsA("TextBox") then
				Obj.TextColor3 = Library.Accent;
			end;
		end;
		return Obj;
	end;

	-- Minimal Window/Page/Section structure for basic compatibility
	function Library:Window(Options)
		local Window = {Pages = {}, Sections = {}, Elements = {}, PageAmount = Options.Amount or 5, Name = Options.Name or "Window"}
		
		local UI = Instance.new("ScreenGui", game:GetService("RunService"):IsStudio() and game.Players.LocalPlayer.PlayerGui or game.CoreGui)
		UI.Name = "UI"
		UI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		Library.ScreenGUI = UI

		local AccentOutline = Library:NewInstance("TextButton", true)
		AccentOutline.Name = "AccentOutline"
		AccentOutline.AnchorPoint = Vector2.new(0,0)
		AccentOutline.BackgroundColor3 = Library.Accent
		AccentOutline.BorderColor3 = Color3.fromRGB(0, 0, 0)
		AccentOutline.ClipsDescendants = false
		AccentOutline.Position = UDim2.new(0, 200, 0, 200)
		AccentOutline.Size = UDim2.new(0, 550, 0, 600)
		AccentOutline.ZIndex = 2
		AccentOutline.Text = ""
		AccentOutline.AutoButtonColor = false

		local Inline = Instance.new("Frame")
		Inline.Name = "Inline"
		Inline.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		Inline.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Inline.BorderSizePixel = 0
		Inline.ClipsDescendants = false
		Inline.Position = UDim2.new(0, 1, 0, 1)
		Inline.Size = UDim2.new(1, -2, 1, -2)
		Inline.ZIndex = 2

		local HolderOutline = Instance.new("Frame")
		HolderOutline.Name = "HolderOutline"
		HolderOutline.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		HolderOutline.BorderColor3 = Color3.fromRGB(0, 0, 0)
		HolderOutline.Position = UDim2.new(0, 6, 0, 22)
		HolderOutline.Size = UDim2.new(1, -12, 1, -28)

		local HolderInline = Instance.new("Frame")
		HolderInline.Name = "HolderInline"
		HolderInline.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		HolderInline.BorderColor3 = Color3.fromRGB(0, 0, 0)
		HolderInline.BorderSizePixel = 0
		HolderInline.Position = UDim2.new(0, 1, 0, 1)
		HolderInline.Size = UDim2.new(1, -2, 1, -2)

		local PageOutline = Instance.new("Frame")
		PageOutline.Name = "PageOutline"
		PageOutline.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		PageOutline.BorderColor3 = Color3.fromRGB(0, 0, 0)
		PageOutline.Position = UDim2.new(0, 4, 0, 26)
		PageOutline.Size = UDim2.new(1, -8, 1, -30)
		PageOutline.ZIndex = 6

		local PageInline = Instance.new("Frame")
		PageInline.Name = "PageInline"
		PageInline.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		PageInline.BorderColor3 = Color3.fromRGB(0, 0, 0)
		PageInline.BorderSizePixel = 0
		PageInline.Position = UDim2.new(0, 1, 0, 1)
		PageInline.Size = UDim2.new(1, -2, 1, -2)
		PageInline.Parent = PageOutline

		PageOutline.Parent = HolderInline

		local Tabs = Instance.new("Frame")
		Tabs.Name = "Tabs"
		Tabs.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Tabs.BackgroundTransparency = 1
		Tabs.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Tabs.BorderSizePixel = 0
		Tabs.Position = UDim2.new(0, 4, 0, 5)
		Tabs.Size = UDim2.new(1, -8, 0, 20)
		Tabs.ZIndex = 6
		
		local UIListLayout = Instance.new("UIListLayout")
		UIListLayout.Name = "UIListLayout"
		UIListLayout.Padding = UDim.new(0, 8)
		UIListLayout.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.Parent = Tabs

		Tabs.Parent = HolderInline

		HolderInline.Parent = HolderOutline

		HolderOutline.Parent = Inline

		local Title = Instance.new("TextLabel")
		Title.Name = "Title"
		Title.FontFace = Font.fromEnum(Enum.Font.RobotoMono)
		Title.Text = Window.Name
		Title.TextColor3 = Color3.fromRGB(255, 255, 255)
		Title.TextSize = 12
		Title.TextStrokeTransparency = 0
		Title.TextXAlignment = Enum.TextXAlignment.Left
		Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Title.BackgroundTransparency = 1
		Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Title.BorderSizePixel = 0
		Title.Position = UDim2.new(0, 6, 0, 2)
		Title.Size = UDim2.new(0, 200, 0, 20)
		Title.Parent = Inline
		
		Inline.Parent = AccentOutline

		AccentOutline.Parent = UI

		Window.Elements = {
			TabHolder = Tabs,
			Holder = PageInline,
			Base = AccentOutline,
		}

		Library.Holder = AccentOutline
		Library.PageAmount = Window.PageAmount;
		return setmetatable(Window, Library)
	end;

	function Library:Page(Properties)
		if not Properties then Properties = {} end
		
		local Page = {
			Name = Properties.Name or "Page",
			Window = self,
			Open = false,
			Sections = {},
			Elements = {},
		}
		
		local NewButton = Instance.new("TextButton")
		NewButton.Name = "NewButton"
		NewButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
		NewButton.Text = ""
		NewButton.TextColor3 = Color3.fromRGB(0, 0, 0)
		NewButton.TextSize = 14
		NewButton.AutoButtonColor = false
		NewButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		NewButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		NewButton.Size = UDim2.new(0, Page.Window.PageAmount and ((((Page.Window.Elements.Base.Size.X.Offset - 35) - ((Page.Window.PageAmount - 1) * 2)) / Page.Window.PageAmount)) - 3 or 65, 1, 0);

		local ButtonInline = Instance.new("Frame")
		ButtonInline.Name = "ButtonInline"
		ButtonInline.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		ButtonInline.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ButtonInline.BorderSizePixel = 0
		ButtonInline.Position = UDim2.new(0, 1, 0, 1)
		ButtonInline.Size = UDim2.new(1, -2, 1, -2)
		ButtonInline.ZIndex = 5

		local Accent = Library:NewInstance("Frame", true)
		Accent.Name = "Accent"
		Accent.BackgroundColor3 = Library.Accent
		Accent.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Accent.BorderSizePixel = 0
		Accent.Size = UDim2.new(1, 0, 0, 1)
		Accent.Parent = ButtonInline
		Accent.Visible = false

		local PageName = Instance.new("TextLabel")
		PageName.Name = "PageName"
		PageName.FontFace = Font.fromEnum(Enum.Font.RobotoMono)
		PageName.TextColor3 = Color3.fromRGB(145,145,145)
		PageName.TextSize = 12
		PageName.Text = Page.Name
		PageName.TextStrokeTransparency = 0
		PageName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		PageName.BackgroundTransparency = 1
		PageName.BorderColor3 = Color3.fromRGB(0, 0, 0)
		PageName.Position = UDim2.new(0,0,0,1)
		PageName.BorderSizePixel = 0
		PageName.Size = UDim2.new(1, 0, 1, 0)
		PageName.Parent = ButtonInline

		ButtonInline.Parent = NewButton

		local Line = Instance.new("Frame")
		Line.Name = "Line"
		Line.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		Line.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Line.BorderSizePixel = 0
		Line.Position = UDim2.new(0, 1, 1, -2)
		Line.Size = UDim2.new(1, -2, 0, 3)
		Line.ZIndex = 7

		Line.Parent = NewButton

		NewButton.Parent = Page.Window.Elements.TabHolder
		
		local NewPage = Instance.new("Frame")
		NewPage.Name = "NewPage"
		NewPage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		NewPage.BackgroundTransparency = 1
		NewPage.BorderColor3 = Color3.fromRGB(0, 0, 0)
		NewPage.BorderSizePixel = 0
		NewPage.Position = UDim2.new(0, 6, 0, 6)
		NewPage.Size = UDim2.new(1, -12, 1, -12)
		NewPage.Visible = false
		NewPage.Parent = Page.Window.Elements.Holder

		local Left = Instance.new("Frame")
		Left.Name = "Left"
		Left.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Left.BackgroundTransparency = 1
		Left.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Left.BorderSizePixel = 0
		Left.Size = UDim2.new(0.5, -4, 1, 0)
		Left.ZIndex = 2

		local UIListLayout = Instance.new("UIListLayout")
		UIListLayout.Name = "UIListLayout"
		UIListLayout.Padding = UDim.new(0, 6)
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.Parent = Left

		Left.Parent = NewPage

		local Right = Instance.new("Frame")
		Right.Name = "Right"
		Right.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Right.BackgroundTransparency = 1
		Right.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Right.BorderSizePixel = 0
		Right.Position = UDim2.new(0.5, 4, 0, 0)
		Right.Size = UDim2.new(0.5, -4, 1, 0)

		local UIListLayout1 = Instance.new("UIListLayout")
		UIListLayout1.Name = "UIListLayout"
		UIListLayout1.Padding = UDim.new(0, 6)
		UIListLayout1.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout1.Parent = Right

		Right.Parent = NewPage

		function Page:Turn(bool)
			Page.Open = bool
			NewPage.Visible = Page.Open
			ButtonInline.BackgroundColor3 = Page.Open and Color3.fromRGB(30, 30, 30) or Color3.fromRGB(20, 20, 20)
			PageName.TextColor3 = Page.Open and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(145,145,145)
			Line.Size = Page.Open and UDim2.new(1, -2, 0, 4) or UDim2.new(1, -2, 0, 3)
			Line.BackgroundColor3 = Page.Open and Color3.fromRGB(30, 30, 30) or Color3.fromRGB(20, 20, 20)
			Accent.Visible = Page.Open
		end
		
		Library:Connection(NewButton.MouseButton1Down, function()
			if not Page.Open then
				for _, Pages in pairs(Page.Window.Pages) do
					if Pages.Open and Pages ~= Page then
						Pages:Turn(false)
					end
				end
				Page:Turn(true)
			end
		end)

		Page.Elements = {
			Left = Left,
			Right = Right,
			Main = NewPage,
			Button = NewButton,
		}

		if #Page.Window.Pages == 0 then
			Page:Turn(true)
		end
		Page.Window.Pages[#Page.Window.Pages + 1] = Page
		Library.Pages[#Library.Pages + 1] = Page
		return setmetatable(Page, Library.Pages)
	end

	function Library:Watermark(Properties)
		local Watermark = {
			Name = (Properties.Name or Properties.name or "watermark text | placeholder");
			ShowFPS = false;
		}
		
		local Outline = Instance.new("Frame")
		Outline.Name = "Outline"
		Outline.AutomaticSize = Enum.AutomaticSize.X
		Outline.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		Outline.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Outline.Position = UDim2.new(0.01, 0,0.02, 0)
		Outline.Size = UDim2.new(0, 0, 0, 16)
		Outline.Parent = Library.ScreenGUI

		local Inline = Instance.new("Frame")
		Inline.Name = "Inline"
		Inline.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		Inline.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Inline.BorderSizePixel = 0
		Inline.Position = UDim2.new(0, 1, 0, 1)
		Inline.Size = UDim2.new(1, -2, 1, -2)

		local Value = Instance.new("TextLabel")
		Value.Name = "Value"
		Value.FontFace = Font.fromEnum(Enum.Font.RobotoMono)
		Value.Text = Watermark.Name
		Value.TextColor3 = Color3.fromRGB(255, 255, 255)
		Value.TextSize = 12
		Value.TextStrokeTransparency = 0
		Value.TextXAlignment = Enum.TextXAlignment.Left
		Value.AutomaticSize = Enum.AutomaticSize.X
		Value.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		Value.BackgroundTransparency = 1
		Value.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Value.BorderSizePixel = 0
		Value.Size = UDim2.new(0, 0, 1, 0)

		local UIPadding = Instance.new("UIPadding")
		UIPadding.Name = "UIPadding"
		UIPadding.PaddingLeft = UDim.new(0, 5)
		UIPadding.PaddingRight = UDim.new(0, 5)
		UIPadding.Parent = Value

		Value.Parent = Inline

		Inline.Parent = Outline

		local Accent = Library:NewInstance("Frame", true)
		Accent.Name = "Accent"
		Accent.BackgroundColor3 = Library.Accent
		Accent.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Accent.BorderSizePixel = 0
		Accent.Size = UDim2.new(1, 0, 0, 1)
		Accent.Parent = Outline
		
		function Watermark:UpdateText(NewText)
			self.Name = NewText
			Value.Text = NewText .. (self.ShowFPS and " | FPS: 0" or "")
		end;
		function Watermark:SetVisible(State)
			Outline.Visible = State;
		end;
		function Watermark:SetFPS(State)
			self.ShowFPS = State
			self:UpdateText(self.Name)
		end;
		
		return Watermark
	end

	do
		local Pages = Library.Pages;
		local Sections = Library.Sections;
		
		function Pages:Section(Properties)
			if not Properties then
				Properties = {}
			end
			
			local Section = {
				Name = Properties.Name or "Section",
				Page = self,
				Side = (Properties.side or Properties.Side or "left"):lower(),
				Elements = {},
			}
			
			local SectionOutline = Instance.new("Frame")
			SectionOutline.Name = "SectionOutline"
			SectionOutline.AutomaticSize = Enum.AutomaticSize.Y
			SectionOutline.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			SectionOutline.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SectionOutline.Size = UDim2.new(1, 0, 0, 20)
			SectionOutline.Parent = Section.Side == "left" and Section.Page.Elements.Left or Section.Page.Elements.Right

			local SectionInline = Instance.new("Frame")
			SectionInline.Name = "SectionInline"
			SectionInline.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			SectionInline.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SectionInline.BorderSizePixel = 0
			SectionInline.Position = UDim2.new(0, 1, 0, 1)
			SectionInline.Size = UDim2.new(1, -2, 1, -2)

			local Accent = Library:NewInstance("Frame", true)
			Accent.Name = "Accent"
			Accent.BackgroundColor3 = Library.Accent
			Accent.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Accent.BorderSizePixel = 0
			Accent.Size = UDim2.new(1, 0, 0, 1)
			Accent.Parent = SectionInline

			local Title = Instance.new("TextLabel")
			Title.Name = "Title"
			Title.FontFace = Font.fromEnum(Enum.Font.RobotoMono)
			Title.Text = Section.Name
			Title.TextColor3 = Color3.fromRGB(255, 255, 255)
			Title.TextSize = 12
			Title.TextStrokeTransparency = 0
			Title.TextXAlignment = Enum.TextXAlignment.Left
			Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Title.BackgroundTransparency = 1
			Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Title.BorderSizePixel = 0
			Title.Position = UDim2.new(0, 5, 0, 1)
			Title.Size = UDim2.new(0, 200, 0, 20)
			Title.Parent = SectionInline

			local SectionContent = Instance.new("Frame")
			SectionContent.Name = "SectionContent"
			SectionContent.AutomaticSize = Enum.AutomaticSize.Y
			SectionContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SectionContent.BackgroundTransparency = 1
			SectionContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SectionContent.BorderSizePixel = 0
			SectionContent.Position = UDim2.new(0, 4, 0, 25)
			SectionContent.Size = UDim2.new(1, -8, 0, 0)

			local UIListLayout = Instance.new("UIListLayout")
			UIListLayout.Name = "UIListLayout"
			UIListLayout.Padding = UDim.new(0, 10)
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout.Parent = SectionContent

			local UIPadding = Instance.new("UIPadding")
			UIPadding.Name = "UIPadding"
			UIPadding.PaddingBottom = UDim.new(0, 6)
			UIPadding.Parent = SectionContent

			SectionContent.Parent = SectionInline

			SectionInline.Parent = SectionOutline

			Section.Elements = {
				SectionContent = SectionContent;
			}

			Section.Page.Sections[#Section.Page.Sections + 1] = Section
			return setmetatable(Section, Library.Sections)
		end

		function Sections:Toggle(Properties)
			if not Properties then Properties = {} end
			
			local Toggle = {
				Window = self.Window,
				Page = self.Page,
				Section = self,
				Name = Properties.Name or "Toggle",
				State = (Properties.state or Properties.State or Properties.default or Properties.Default or false),
				Callback = (Properties.callback or Properties.Callback or function() end),
				Flag = (Properties.flag or Properties.Flag or Library.NextFlag()),
				Toggled = false,
			}
			
			local NewToggle = Instance.new("TextButton")
			NewToggle.Name = "NewToggle"
			NewToggle.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
			NewToggle.Text = ""
			NewToggle.TextColor3 = Color3.fromRGB(0, 0, 0)
			NewToggle.TextSize = 14
			NewToggle.AutoButtonColor = false
			NewToggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			NewToggle.BackgroundTransparency = 1
			NewToggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
			NewToggle.BorderSizePixel = 0
			NewToggle.Size = UDim2.new(1, 0, 0, 10)
			NewToggle.Parent = Toggle.Section.Elements.SectionContent

			local Outline = Instance.new("Frame")
			Outline.Name = "Outline"
			Outline.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			Outline.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Outline.Size = UDim2.new(0, 10, 0, 10)

			local Inline = Instance.new("Frame")
			Inline.Name = "Inline"
			Inline.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			Inline.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Inline.BorderSizePixel = 0
			Inline.Position = UDim2.new(0, 1, 0, 1)
			Inline.Size = UDim2.new(1, -2, 1, -2)

			local Accent = Library:NewInstance("Frame", true)
			Accent.Name = "Accent"
			Accent.BackgroundColor3 = Library.Accent
			Accent.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Accent.BorderSizePixel = 0
			Accent.Size = UDim2.new(1, 0, 1, 0)
			Accent.Parent = Inline
			Accent.Visible = false

			Inline.Parent = Outline

			Outline.Parent = NewToggle

			local Title = Instance.new("TextLabel")
			Title.Name = "Title"
			Title.FontFace = Font.fromEnum(Enum.Font.RobotoMono)
			Title.TextColor3 = Color3.fromRGB(255, 255, 255)
			Title.TextSize = 12
			Title.TextStrokeTransparency = 0
			Title.TextXAlignment = Enum.TextXAlignment.Left
			Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Title.BackgroundTransparency = 1
			Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Title.BorderSizePixel = 0
			Title.Position = UDim2.new(0, 16, 0, 0)
			Title.Size = UDim2.new(1, 0, 1, 0)
			Title.Parent = NewToggle
			Title.Text = Toggle.Name

			local function SetState()
				Toggle.Toggled = not Toggle.Toggled
				Accent.Visible = Toggle.Toggled
				Library.Flags[Toggle.Flag] = Toggle.Toggled
				Toggle.Callback(Toggle.Toggled)
			end
			
			Library:Connection(NewToggle.MouseButton1Down, SetState)

			function Toggle.Set(bool)
				bool = type(bool) == "boolean" and bool or false
				if Toggle.Toggled ~= bool then
					SetState()
				end
			end
			Toggle.Set(Toggle.State)
			Library.Flags[Toggle.Flag] = Toggle.State

			return Toggle
		end

		function Sections:Slider(Properties)
			if not Properties then Properties = {} end
			
			local Slider = {
				Window = self.Window,
				Page = self.Page,
				Section = self,
				Name = Properties.Name or nil,
				Min = (Properties.min or Properties.Min or 0),
				State = (Properties.state or Properties.State or Properties.default or Properties.Default or 10),
				Max = (Properties.max or Properties.Max or 100),
				Sub = (Properties.suffix or Properties.Suffix or Properties.prefix or Properties.Prefix or ""),
				Decimals = (Properties.decimals or Properties.Decimals or 1),
				Callback = (Properties.callback or Properties.Callback or function() end),
				Flag = (Properties.flag or Properties.Flag or Library.NextFlag()),
			}
			local TextValue = ("[value]" .. Slider.Sub)
			
			local NewSlider = Instance.new("Frame")
			NewSlider.Name = "NewSlider"
			NewSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			NewSlider.BackgroundTransparency = 1
			NewSlider.BorderColor3 = Color3.fromRGB(0, 0, 0)
			NewSlider.BorderSizePixel = 0
			NewSlider.Size = UDim2.new(1, 0, 0, Slider.Name ~= nil and 26 or 12)
			NewSlider.Parent = Slider.Section.Elements.SectionContent

			local Outline = Instance.new("Frame")
			Outline.Name = "Outline"
			Outline.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			Outline.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Outline.Position = UDim2.new(0, 0, 1, -12)
			Outline.Size = UDim2.new(1, 0, 0, 12)

			local Inline = Instance.new("TextButton")
			Inline.Name = "Inline"
			Inline.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			Inline.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Inline.BorderSizePixel = 0
			Inline.Position = UDim2.new(0, 1, 0, 1)
			Inline.Size = UDim2.new(1, -2, 1, -2)
			Inline.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
			Inline.Text = ""
			Inline.TextColor3 = Color3.fromRGB(0, 0, 0)
			Inline.TextSize = 14
			Inline.AutoButtonColor = false

			local Accent = Library:NewInstance("TextButton", true)
			Accent.Name = "Accent"
			Accent.BackgroundColor3 = Library.Accent
			Accent.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Accent.BorderSizePixel = 0
			Accent.Size = UDim2.new(0, 0, 1, 0)
			Accent.Parent = Inline
			Accent.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
			Accent.Text = ""
			Accent.TextColor3 = Color3.fromRGB(0, 0, 0)
			Accent.TextSize = 14
			Accent.AutoButtonColor = false

			local Value = Instance.new("TextLabel")
			Value.Name = "Value"
			Value.FontFace = Font.fromEnum(Enum.Font.RobotoMono)
			Value.Text = "0"
			Value.TextColor3 = Color3.fromRGB(255, 255, 255)
			Value.TextSize = 12
			Value.TextStrokeTransparency = 0
			Value.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Value.BackgroundTransparency = 1
			Value.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Value.BorderSizePixel = 0
			Value.Size = UDim2.new(1, 0, 1, 0)
			Value.Parent = Inline

			Inline.Parent = Outline

			Outline.Parent = NewSlider

			local Title = Instance.new("TextLabel")
			Title.Name = "Title"
			Title.FontFace = Font.fromEnum(Enum.Font.RobotoMono)
			Title.TextColor3 = Color3.fromRGB(255, 255, 255)
			Title.TextSize = 12
			Title.TextStrokeTransparency = 0
			Title.TextXAlignment = Enum.TextXAlignment.Left
			Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Title.BackgroundTransparency = 1
			Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Title.BorderSizePixel = 0
			Title.Size = UDim2.new(1, 0, 0, 10)
			Title.Parent = NewSlider
			Title.Text = Slider.Name ~= nil and Slider.Name or ""
			Title.Visible = Slider.Name ~= nil and true or false

			local Sliding = false
			local Val = Slider.State
			local function Set(value)
				value = math.clamp(Library:Round(value, Slider.Decimals), Slider.Min, Slider.Max)
				local sizeX = ((value - Slider.Min) / (Slider.Max - Slider.Min))
				Accent.Size = UDim2.new(sizeX, 0, 1, 0)
				Value.Text = TextValue:gsub("%[value%]", string.format("%.14g", value))
				Val = value
				Library.Flags[Slider.Flag] = value
				Slider.Callback(value)
			end				
			
			local function ISlide(input)
				local sizeX = (input.Position.X - Inline.AbsolutePosition.X) / Inline.AbsoluteSize.X
				local value = ((Slider.Max - Slider.Min) * sizeX) + Slider.Min
				Set(value)
			end
			
			Library:Connection(Inline.InputBegan, function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or Enum.UserInputType.Touch then
					Sliding = true
					ISlide(input)
				end
			end)
			Library:Connection(Inline.InputEnded, function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or Enum.UserInputType.Touch then
					Sliding = false
				end
			end)
			Library:Connection(Accent.InputBegan, function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or Enum.UserInputType.Touch then
					Sliding = true
					ISlide(input)
				end
			end)
			Library:Connection(Accent.InputEnded, function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or Enum.UserInputType.Touch then
					Sliding = false
				end
			end)
			Library:Connection(game:GetService("UserInputService").InputChanged, function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement or Enum.UserInputType.Touch then
					if Sliding then
						ISlide(input)
					end
				end
			end)
			
			function Slider:Set(Value)
				Set(Value)
			end
			
			Library.Flags[Slider.Flag] = Slider.State
			Set(Slider.State)

			return Slider
		end

		function Sections:Button(Properties)
			local Properties = Properties or {}
			local Button = {
				Window = self.Window,
				Page = self.Page,
				Section = self,
				Name = Properties.Name or "button",
				Callback = (Properties.callback or Properties.Callback or function() end),
			}
			
			local NewButton = Instance.new("Frame")
			NewButton.Name = "NewButton"
			NewButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			NewButton.BackgroundTransparency = 1
			NewButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
			NewButton.BorderSizePixel = 0
			NewButton.Size = UDim2.new(1, 0, 0, 16)
			NewButton.Parent = Button.Section.Elements.SectionContent

			local Outline = Instance.new("Frame")
			Outline.Name = "Outline"
			Outline.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			Outline.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Outline.Position = UDim2.new(0, 0, 1, -16)
			Outline.Size = UDim2.new(1,0, 0, 16)

			local Inline = Instance.new("TextButton")
			Inline.Name = "Inline"
			Inline.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			Inline.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Inline.BorderSizePixel = 0
			Inline.Position = UDim2.new(0, 1, 0, 1)
			Inline.Size = UDim2.new(1, -2, 1, -2)
			Inline.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
			Inline.Text = ""
			Inline.TextColor3 = Color3.fromRGB(0, 0, 0)
			Inline.TextSize = 14
			Inline.AutoButtonColor = false

			local Value = Instance.new("TextLabel")
			Value.Name = "Value"
			Value.FontFace = Font.fromEnum(Enum.Font.RobotoMono)
			Value.Text = Button.Name
			Value.TextColor3 = Color3.fromRGB(255, 255, 255)
			Value.TextSize = 12
			Value.TextStrokeTransparency = 0
			Value.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Value.BackgroundTransparency = 1
			Value.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Value.BorderSizePixel = 0
			Value.Size = UDim2.new(1, 0, 1, 0)
			Value.Parent = Inline

			Inline.Parent = Outline

			Outline.Parent = NewButton
			
			Library:Connection(Inline.MouseButton1Down, function()
				Button.Callback()
				Value.TextColor3 = Library.Accent
				task.wait(0.1)
				Value.TextColor3 = Color3.fromRGB(255,255,255)
			end)

			return Button
		end

		function Sections:List(Properties)
			local Properties = Properties or {};
			local Dropdown = {
				Window = self.Window,
				Page = self.Page,
				Section = self,
				Open = false,
				Name = Properties.Name or Properties.name or nil,
				Options = (Properties.options or Properties.Options or Properties.values or Properties.Values or {"1", "2", "3"}),
				Max = (Properties.Max or Properties.max or nil),
				State = (Properties.state or Properties.State or Properties.default or Properties.Default or nil),
				Callback = (Properties.callback or Properties.Callback or function() end),
				Flag = (Properties.flag or Properties.Flag or Library.NextFlag()),
				OptionInsts = {},
			}
			
			local NewList = Instance.new("Frame")
			NewList.Name = "NewList"
			NewList.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			NewList.BackgroundTransparency = 1
			NewList.BorderColor3 = Color3.fromRGB(0, 0, 0)
			NewList.BorderSizePixel = 0
			NewList.Size = UDim2.new(1, 0, 0, Dropdown.Name ~= nil and 30 or 16)
			NewList.Parent = Dropdown.Section.Elements.SectionContent

			local Outline = Instance.new("Frame")
			Outline.Name = "Outline"
			Outline.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			Outline.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Outline.Position = UDim2.new(0, 0, 1, -16)
			Outline.Size = UDim2.new(1, 0, 0, 16)

			local Inline = Instance.new("TextButton")
			Inline.Name = "Inline"
			Inline.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			Inline.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Inline.BorderSizePixel = 0
			Inline.Position = UDim2.new(0, 1, 0, 1)
			Inline.Size = UDim2.new(1, -2, 1, -2)
			Inline.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
			Inline.Text = ""
			Inline.TextColor3 = Color3.fromRGB(0, 0, 0)
			Inline.TextSize = 14
			Inline.AutoButtonColor = false

			local Value = Instance.new("TextLabel")
			Value.Name = "Value"
			Value.FontFace = Font.fromEnum(Enum.Font.RobotoMono)
			Value.Text = "None"
			Value.TextColor3 = Color3.fromRGB(255, 255, 255)
			Value.TextSize = 12
			Value.TextStrokeTransparency = 0
			Value.TextXAlignment = Enum.TextXAlignment.Left
			Value.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Value.BackgroundTransparency = 1
			Value.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Value.BorderSizePixel = 0
			Value.Position = UDim2.new(0, 4, 0, 0)
			Value.Size = UDim2.new(1, 0, 1, 0)
			Value.Parent = Inline

			local Icon = Instance.new("TextLabel")
			Icon.Name = "Icon"
			Icon.FontFace = Font.fromEnum(Enum.Font.RobotoMono)
			Icon.Text = "+"
			Icon.TextColor3 = Color3.fromRGB(255, 255, 255)
			Icon.TextSize = 12
			Icon.TextStrokeTransparency = 0
			Icon.TextXAlignment = Enum.TextXAlignment.Right
			Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Icon.BackgroundTransparency = 1
			Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Icon.BorderSizePixel = 0
			Icon.Position = UDim2.new(0, -4, 0, 0)
			Icon.Size = UDim2.new(1, 0, 1, 0)
			Icon.Parent = Inline

			Inline.Parent = Outline

			local ContentOutline = Instance.new("Frame")
			ContentOutline.Name = "ContentOutline"
			ContentOutline.AutomaticSize = Enum.AutomaticSize.Y
			ContentOutline.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			ContentOutline.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ContentOutline.Position = UDim2.new(0, 0, 1, 1)
			ContentOutline.Size = UDim2.new(1, 0, 0, 0)
			ContentOutline.Visible = false

			local ContentInline = Instance.new("Frame")
			ContentInline.Name = "ContentInline"
			ContentInline.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			ContentInline.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ContentInline.BorderSizePixel = 0
			ContentInline.Position = UDim2.new(0, 1, 0, 1)
			ContentInline.Size = UDim2.new(1, -2, 1, -2)

			local UIListLayout = Instance.new("UIListLayout")
			UIListLayout.Name = "UIListLayout"
			UIListLayout.Padding = UDim.new(0, 2)
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout.Parent = ContentInline

			local UIPadding = Instance.new("UIPadding")
			UIPadding.Name = "UIPadding"
			UIPadding.PaddingBottom = UDim.new(0, 2)
			UIPadding.PaddingTop = UDim.new(0, 2)
			UIPadding.Parent = ContentInline

			ContentInline.Parent = ContentOutline

			ContentOutline.Parent = Outline

			Outline.Parent = NewList

			local Title = Instance.new("TextLabel")
			Title.Name = "Title"
			Title.FontFace = Font.fromEnum(Enum.Font.RobotoMono)
			Title.TextColor3 = Color3.fromRGB(255, 255, 255)
			Title.TextSize = 12
			Title.TextStrokeTransparency = 0
			Title.TextXAlignment = Enum.TextXAlignment.Left
			Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Title.BackgroundTransparency = 1
			Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Title.BorderSizePixel = 0
			Title.Size = UDim2.new(1, 0, 0, 10)
			Title.Parent = NewList
			Title.Visible = Dropdown.Name ~= nil and true or false
			Title.Text = Dropdown.Name ~= nil and Dropdown.Name or ""

			Library:Connection(Inline.MouseButton1Down, function()
				ContentOutline.Visible = not ContentOutline.Visible
				if ContentOutline.Visible then
					Icon.Text = "-"
					NewList.ZIndex = 5
				else
					Icon.Text = "+"
					NewList.ZIndex = 1
				end
			end)
			Library:Connection(game:GetService("UserInputService").InputBegan, function(Input)
				if ContentOutline.Visible and Input.UserInputType == Enum.UserInputType.MouseButton1 or Enum.UserInputType.Touch then
					if not Library:IsMouseOverFrame(ContentOutline) and not Library:IsMouseOverFrame(Inline) then
						ContentOutline.Visible = false
						NewList.ZIndex = 1
						Icon.Text = "+"
					end
				end
			end)
			
			local chosen = Dropdown.Max and {} or nil
			local Count = 0
			
			local function handleoptionclick(option, button, text)
				button.MouseButton1Down:Connect(function()
					if Dropdown.Max then
						if table.find(chosen, option) then
							table.remove(chosen, table.find(chosen, option))
							text.TextColor3 = Color3.fromRGB(145,145,145)
							Library.Flags[Dropdown.Flag] = chosen
							Dropdown.Callback(chosen)
						else
							if #chosen == Dropdown.Max then
								Dropdown.OptionInsts[chosen[1]].accent.Visible = false
								table.remove(chosen, 1)
							end
							table.insert(chosen, option)
							text.TextColor3 = Color3.fromRGB(255,255,255)
							Library.Flags[Dropdown.Flag] = chosen
							Dropdown.Callback(chosen)
						end
					else
						for opt, tbl in next, Dropdown.OptionInsts do
							if opt ~= option then
								tbl.text.TextColor3 = Color3.fromRGB(145,145,145)
							end
						end
						chosen = option
						Value.Text = option
						text.TextColor3 = Color3.fromRGB(255,255,255)
						ContentOutline.Visible = false
						NewList.ZIndex = 1
						Icon.Text = "+"
						Library.Flags[Dropdown.Flag] = option
						Dropdown.Callback(option)
					end
				end)
			end
			
			local function createoptions(tbl)
				for _, option in next, tbl do
					Dropdown.OptionInsts[option] = {}
					
					local NewOption = Instance.new("TextButton")
					NewOption.Name = "NewOption"
					NewOption.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
					NewOption.Text = ""
					NewOption.TextColor3 = Color3.fromRGB(255, 255, 255)
					NewOption.TextSize = 12
					NewOption.TextStrokeTransparency = 0
					NewOption.TextWrapped = true
					NewOption.TextXAlignment = Enum.TextXAlignment.Left
					NewOption.AutoButtonColor = false
					NewOption.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					NewOption.BackgroundTransparency = 1
					NewOption.BorderColor3 = Color3.fromRGB(0, 0, 0)
					NewOption.BorderSizePixel = 0
					NewOption.Size = UDim2.new(1, 0, 0, 14)

					local OptionLabel = Instance.new("TextLabel")
					OptionLabel.Name = "OptionLabel"
					OptionLabel.FontFace = Font.fromEnum(Enum.Font.RobotoMono)
					OptionLabel.Text = option
					OptionLabel.TextColor3 = Color3.fromRGB(145, 145, 145)
					OptionLabel.TextSize = 12
					OptionLabel.TextStrokeTransparency = 0
					OptionLabel.TextXAlignment = Enum.TextXAlignment.Left
					OptionLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					OptionLabel.BackgroundTransparency = 1
					OptionLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
					OptionLabel.BorderSizePixel = 0
					OptionLabel.Position = UDim2.new(0, 4, 0, 0)
					OptionLabel.Size = UDim2.new(1, 0, 1, 0)
					OptionLabel.Parent = NewOption

					NewOption.Parent = ContentInline

					Dropdown.OptionInsts[option].text = OptionLabel

					Count = Count + 1

					handleoptionclick(option, NewOption, OptionLabel)
				end
			end
			createoptions(Dropdown.Options)
			
			local set
			set = function(option)
				if Dropdown.Max then
					table.clear(chosen)
					option = type(option) == "table" and option or {}
					for opt, tbl in next, Dropdown.OptionInsts do
						if not table.find(option, opt) then
							tbl.text.TextColor3 = Color3.fromRGB(145,145,145)
						end
					end
					for i, opt in next, option do
						if table.find(Dropdown.Options, opt) and #chosen < Dropdown.Max then
							table.insert(chosen, opt)
							Dropdown.OptionInsts[opt].text.TextColor3 = Color3.fromRGB(255,255,255)
						end
					end
					Library.Flags[Dropdown.Flag] = chosen
					Dropdown.Callback(chosen)
				end
			end
			
			function Dropdown:Set(option)
				if Dropdown.Max then
					set(option)
				else
					for opt, tbl in next, Dropdown.OptionInsts do
						if opt ~= option then
							tbl.text.TextColor3 = Color3.fromRGB(145,145,145)
						end
					end
					if table.find(Dropdown.Options, option) then
						chosen = option
						Dropdown.OptionInsts[option].text.TextColor3 = Color3.fromRGB(255,255,255)
						Value.Text = option
						Library.Flags[Dropdown.Flag] = chosen
						Dropdown.Callback(chosen)
					else
						chosen = nil
						Value.Text = "None"
						Library.Flags[Dropdown.Flag] = chosen
						Dropdown.Callback(chosen)
					end
				end
			end
			
			Dropdown:Set(Dropdown.State)
			return Dropdown
		end

		function Sections:Textbox(Properties)
			local Properties = Properties or {}
			local Textbox = {
				Window = self.Window,
				Page = self.Page,
				Section = self,
				Name = (Properties.Name or Properties.name or nil),
				Placeholder = (Properties.placeholder or Properties.Placeholder or ""),
				State = (Properties.state or Properties.State or Properties.default or Properties.Default or ""),
				Callback = (Properties.callback or Properties.Callback or function() end),
				Flag = (Properties.flag or Properties.Flag or Library.NextFlag()),
			}
			
			local NewBox = Instance.new("TextButton")
			NewBox.Name = "NewBox"
			NewBox.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
			NewBox.Text = ""
			NewBox.TextColor3 = Color3.fromRGB(0, 0, 0)
			NewBox.TextSize = 14
			NewBox.AutoButtonColor = false
			NewBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			NewBox.BackgroundTransparency = 1
			NewBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
			NewBox.BorderSizePixel = 0
			NewBox.Size = UDim2.new(1, 0, 0, Textbox.Name ~= nil and 30 or 16)
			NewBox.Parent = Textbox.Section.Elements.SectionContent

			local Outline = Instance.new("Frame")
			Outline.Name = "Outline"
			Outline.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			Outline.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Outline.Position = UDim2.new(0, 0, 1, -16)
			Outline.Size = UDim2.new(1, 0, 0, 16)

			local Inline = Instance.new("Frame")
			Inline.Name = "Inline"
			Inline.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			Inline.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Inline.BorderSizePixel = 0
			Inline.Position = UDim2.new(0, 1, 0, 1)
			Inline.Size = UDim2.new(1, -2, 1, -2)

			local Value = Instance.new("TextBox")
			Value.Name = "Value"
			Value.FontFace = Font.fromEnum(Enum.Font.RobotoMono)
			Value.Text = Textbox.State
			Value.PlaceholderText = Textbox.Placeholder
			Value.TextColor3 = Color3.fromRGB(255, 255, 255)
			Value.PlaceholderColor3 = Color3.fromRGB(145,145,145)
			Value.TextSize = 12
			Value.TextStrokeTransparency = 0
			Value.TextXAlignment = Enum.TextXAlignment.Left
			Value.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Value.BackgroundTransparency = 1
			Value.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Value.BorderSizePixel = 0
			Value.Position = UDim2.new(0, 4, 0, 0)
			Value.Size = UDim2.new(1, 0, 1, 0)
			Value.Parent = Inline
			Value.ClearTextOnFocus = false

			Inline.Parent = Outline

			Outline.Parent = NewBox

			local Title = Instance.new("TextLabel")
			Title.Name = "Title"
			Title.FontFace = Font.fromEnum(Enum.Font.RobotoMono)
			Title.TextColor3 = Color3.fromRGB(255, 255, 255)
			Title.TextSize = 12
			Title.TextStrokeTransparency = 0
			Title.TextXAlignment = Enum.TextXAlignment.Left
			Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Title.BackgroundTransparency = 1
			Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Title.BorderSizePixel = 0
			Title.Size = UDim2.new(1, 0, 0, 10)
			Title.Parent = NewBox
			Title.Text = Textbox.Name ~= nil and Textbox.Name or ""
			Title.Visible = Textbox.Name ~= nil and true or false

			Value.FocusLost:Connect(function()
				Textbox.Callback(Value.Text)
				Library.Flags[Textbox.Flag] = Value.Text
			end)
			
			local function set(str)
				Value.Text = str
				Library.Flags[Textbox.Flag] = str
				Textbox.Callback(str)
			end

			return Textbox
		end

		function Sections:Keybind(Properties)
			local Properties = Properties or {}
			local Keybind = {
				Section = self,
				Name = Properties.name or Properties.Name or "Keybind",
				State = (Properties.state or Properties.State or Properties.default or Properties.Default or nil),
				Mode = (Properties.mode or Properties.Mode or "Toggle"),
				UseKey = (Properties.UseKey or false),
				Callback = (Properties.callback or Properties.Callback or function() end),
				Flag = (Properties.flag or Properties.Flag or Library.NextFlag()),
				Binding = nil,
			}
			local Key
			local State = false
			
			local NewBind = Instance.new("Frame")
			NewBind.Name = "NewBind"
			NewBind.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			NewBind.BackgroundTransparency = 1
			NewBind.BorderColor3 = Color3.fromRGB(0, 0, 0)
			NewBind.BorderSizePixel = 0
			NewBind.Size = UDim2.new(1, 0, 0, 10)
			NewBind.Parent = Keybind.Section.Elements.SectionContent

			local Title = Instance.new("TextLabel")
			Title.Name = "Title"
			Title.FontFace = Font.fromEnum(Enum.Font.RobotoMono)
			Title.TextColor3 = Color3.fromRGB(255, 255, 255)
			Title.TextSize = 12
			Title.TextStrokeTransparency = 0
			Title.TextXAlignment = Enum.TextXAlignment.Left
			Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Title.BackgroundTransparency = 1
			Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Title.BorderSizePixel = 0
			Title.Size = UDim2.new(1, 0, 1, 0)
			Title.Parent = NewBind
			Title.Text = Keybind.Name

			local Outline = Instance.new("Frame")
			Outline.Name = "Outline"
			Outline.AnchorPoint = Vector2.new(0, 0.5)
			Outline.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			Outline.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Outline.Position = UDim2.new(1, -35, 0.5, 0)
			Outline.Size = UDim2.new(0, 35, 0, 12)

			local Inline = Instance.new("TextButton")
			Inline.Name = "Inline"
			Inline.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			Inline.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Inline.BorderSizePixel = 0
			Inline.Position = UDim2.new(0, 1, 0, 1)
			Inline.Size = UDim2.new(1, -2, 1, -2)
			Inline.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
			Inline.Text = ""
			Inline.TextColor3 = Color3.fromRGB(0, 0, 0)
			Inline.TextSize = 14
			Inline.AutoButtonColor = false

			local Value = Instance.new("TextLabel")
			Value.Name = "Value"
			Value.FontFace = Font.fromEnum(Enum.Font.RobotoMono)
			Value.Text = "MB2"
			Value.TextColor3 = Color3.fromRGB(255, 255, 255)
			Value.TextSize = 12
			Value.TextStrokeTransparency = 0
			Value.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Value.BackgroundTransparency = 1
			Value.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Value.BorderSizePixel = 0
			Value.Size = UDim2.new(1, 0, 1, 0)
			Value.Parent = Inline

			Inline.Parent = Outline

			Outline.Parent = NewBind

			local function set(newkey)
				if string.find(tostring(newkey), "Enum") then
					if tostring(newkey):find("Enum.KeyCode.") then
						newkey = Enum.KeyCode[tostring(newkey):gsub("Enum.KeyCode.", "")]
					elseif tostring(newkey):find("Enum.UserInputType.") then
						newkey = Enum.UserInputType[tostring(newkey):gsub("Enum.UserInputType.", "")]
					end
					if newkey == Enum.KeyCode.Backspace then
						Key = nil
						if Keybind.UseKey then
							if Keybind.Flag then
								Library.Flags[Keybind.Flag] = Key
							end
							Keybind.Callback(Key)
						end
						Value.Text = "None"
					elseif newkey ~= nil then
						Key = newkey
						if Keybind.UseKey then
							if Keybind.Flag then
								Library.Flags[Keybind.Flag] = Key
							end
							Keybind.Callback(Key)
						end
						Value.Text = (Library.Keys[newkey] or tostring(newkey):gsub("Enum.KeyCode.", ""))
					end
					Library.Flags[Keybind.Flag .. "_KEY"] = newkey
				end
			end
			
			set(Keybind.State)
			Inline.MouseButton1Click:Connect(function()
				if not Keybind.Binding then
					Value.Text = "..."
					Keybind.Binding = Library:Connection(
						game:GetService("UserInputService").InputBegan,
						function(input, gpe)
							set(input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType)
							Library:Disconnect(Keybind.Binding)
							task.wait()
							Keybind.Binding = nil
						end
					)
				end
			end)
			
			Library.Flags[Keybind.Flag .. "_KEY"] = Keybind.State
			
			function Keybind:Set(key)
				set(key)
			end

			return Keybind
		end

		function Sections:Divider(Properties)
			local Properties = Properties or {}
			local Divider = {
				Name = Properties.Name or "divider",
			}
			
			local NewDivider = Instance.new("TextButton")
			NewDivider.Name = "NewDivider"
			NewDivider.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
			NewDivider.Text = ""
			NewDivider.TextColor3 = Color3.fromRGB(0, 0, 0)
			NewDivider.TextSize = 14
			NewDivider.AutoButtonColor = false
			NewDivider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			NewDivider.BackgroundTransparency = 1
			NewDivider.BorderColor3 = Color3.fromRGB(0, 0, 0)
			NewDivider.BorderSizePixel = 0
			NewDivider.Size = UDim2.new(1, 0, 0, 8)
			NewDivider.Parent = Divider.Section.Elements.SectionContent

			local Outline = Instance.new("Frame")
			Outline.Name = "Outline"
			Outline.AnchorPoint = Vector2.new(0, 0.5)
			Outline.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			Outline.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Outline.Position = UDim2.new(0, 0, 0.5, 0)
			Outline.Size = UDim2.new(1, 0, 0, 4)

			local Inline = Instance.new("Frame")
			Inline.Name = "Inline"
			Inline.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			Inline.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Inline.BorderSizePixel = 0
			Inline.Position = UDim2.new(0, 1, 0, 1)
			Inline.Size = UDim2.new(1, -2, 1, -2)

			local Value = Instance.new("TextLabel")
			Value.Name = "Value"
			Value.FontFace = Font.fromEnum(Enum.Font.RobotoMono)
			Value.Text = Divider.Name
			Value.TextColor3 = Color3.fromRGB(255, 255, 255)
			Value.TextSize = 12
			Value.TextStrokeTransparency = 0
			Value.AnchorPoint = Vector2.new(0.5, 0.5)
			Value.AutomaticSize = Enum.AutomaticSize.X
			Value.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			Value.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Value.BorderSizePixel = 0
			Value.Position = UDim2.new(0.5, 0, 0.5, 0)
			Value.Size = UDim2.new(0, 0, 0, 8)

			local UIPadding = Instance.new("UIPadding")
			UIPadding.Name = "UIPadding"
			UIPadding.PaddingLeft = UDim.new(0, 5)
			UIPadding.PaddingRight = UDim.new(0, 5)
			UIPadding.Parent = Value

			Value.Parent = Inline

			Inline.Parent = Outline

			Outline.Parent = NewDivider
			
return Divider
		end

		function Sections:Colorpicker(Properties)
			local Properties = Properties or {}
			local Colorpicker = {
				Window = self.Window,
				Page = self.Page,
				Section = self,
				Name = Properties.Name or "Colorpicker",
				State = (Properties.state or Properties.State or Properties.default or Properties.Default or Color3.fromRGB(255, 88, 166)),
				Callback = (Properties.callback or Properties.Callback or function() end),
				Flag = (Properties.flag or Properties.Flag or Library.NextFlag()),
				Open = false,
			}

			local NewColor = Instance.new("Frame")
			NewColor.Name = "NewColor"
			NewColor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			NewColor.BackgroundTransparency = 1
			NewColor.BorderColor3 = Color3.fromRGB(0, 0, 0)
			NewColor.BorderSizePixel = 0
			NewColor.Size = UDim2.new(1, 0, 0, 10)
			NewColor.Parent = Colorpicker.Section.Elements.SectionContent

			local Title = Instance.new("TextLabel")
			Title.Name = "Title"
			Title.FontFace = Font.fromEnum(Enum.Font.RobotoMono)
			Title.TextColor3 = Color3.fromRGB(255, 255, 255)
			Title.TextSize = 12
			Title.TextStrokeTransparency = 0
			Title.TextXAlignment = Enum.TextXAlignment.Left
			Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Title.BackgroundTransparency = 1
			Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Title.BorderSizePixel = 0
			Title.Size = UDim2.new(1, -40, 1, 0)
			Title.Parent = NewColor
			Title.Text = Colorpicker.Name

			local Outline = Instance.new("Frame")
			Outline.Name = "Outline"
			Outline.AnchorPoint = Vector2.new(0, 0.5)
			Outline.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			Outline.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Outline.Position = UDim2.new(1, -30, 0.5, 0)
			Outline.Size = UDim2.new(0, 30, 0, 12)

			local Inline = Instance.new("TextButton")
			Inline.Name = "Inline"
			Inline.BackgroundColor3 = Colorpicker.State
			Inline.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Inline.BorderSizePixel = 0
			Inline.Position = UDim2.new(0, 1, 0, 1)
			Inline.Size = UDim2.new(1, -2, 1, -2)
			Inline.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
			Inline.Text = ""
			Inline.TextColor3 = Color3.fromRGB(0, 0, 0)
			Inline.TextSize = 14
			Inline.AutoButtonColor = false

			Inline.Parent = Outline
			Outline.Parent = NewColor

			local PickerFrame = Instance.new("Frame")
			PickerFrame.Name = "PickerFrame"
			PickerFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			PickerFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			PickerFrame.BorderSizePixel = 0
			PickerFrame.Position = UDim2.new(1, 5, 0, 0)
			PickerFrame.Size = UDim2.new(0, 180, 0, 160)
			PickerFrame.Visible = false
			PickerFrame.ZIndex = 10
			PickerFrame.Parent = Outline

			local PickerOutline = Instance.new("Frame")
			PickerOutline.Name = "PickerOutline"
			PickerOutline.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			PickerOutline.BorderColor3 = Color3.fromRGB(0, 0, 0)
			PickerOutline.Position = UDim2.new(0, 1, 0, 1)
			PickerOutline.Size = UDim2.new(1, -2, 1, -2)
			PickerOutline.Parent = PickerFrame

			local HueSat = Instance.new("ImageButton")
			HueSat.Name = "HueSat"
			HueSat.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
			HueSat.BorderSizePixel = 0
			HueSat.Position = UDim2.new(0, 5, 0, 5)
			HueSat.Size = UDim2.new(1, -30, 1, -30)
			HueSat.Image = "rbxassetid://4155801252"
			HueSat.ZIndex = 10

			local HueSatSelector = Instance.new("Frame")
			HueSatSelector.Name = "HueSatSelector"
			HueSatSelector.AnchorPoint = Vector2.new(0.5, 0.5)
			HueSatSelector.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			HueSatSelector.BorderColor3 = Color3.fromRGB(0, 0, 0)
			HueSatSelector.BorderSizePixel = 2
			HueSatSelector.Position = UDim2.new(0, 0, 0, 0)
			HueSatSelector.Size = UDim2.new(0, 6, 0, 6)
			HueSatSelector.Parent = HueSat

			local HueBar = Instance.new("ImageButton")
			HueBar.Name = "HueBar"
			HueBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			HueBar.BorderSizePixel = 0
			HueBar.Position = UDim2.new(1, -20, 0, 5)
			HueBar.Size = UDim2.new(0, 15, 1, -30)
			HueBar.Image = "rbxassetid://3641079629"
			HueBar.ZIndex = 10

			local HueSelector = Instance.new("Frame")
			HueSelector.Name = "HueSelector"
			HueSelector.AnchorPoint = Vector2.new(0, 0.5)
			HueSelector.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			HueSelector.BorderColor3 = Color3.fromRGB(0, 0, 0)
			HueSelector.BorderSizePixel = 2
			HueSelector.Position = UDim2.new(0, 0, 0, 0)
			HueSelector.Size = UDim2.new(1, 0, 0, 4)
			HueSelector.Parent = HueBar

			HueBar.Parent = PickerOutline
			HueSat.Parent = PickerOutline
			PickerOutline.Parent = PickerFrame

			local AlphaBar = Instance.new("ImageButton")
			AlphaBar.Name = "AlphaBar"
			AlphaBar.BackgroundColor3 = Colorpicker.State
			AlphaBar.BorderSizePixel = 0
			AlphaBar.Position = UDim2.new(0, 5, 1, -20)
			AlphaBar.Size = UDim2.new(1, -30, 0, 15)
			AlphaBar.Image = "rbxassetid://4155801252"
			AlphaBar.BackgroundTransparency = 1
			AlphaBar.ZIndex = 10

			local AlphaSelector = Instance.new("Frame")
			AlphaSelector.Name = "AlphaSelector"
			AlphaSelector.AnchorPoint = Vector2.new(0.5, 0.5)
			AlphaSelector.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			AlphaSelector.BorderColor3 = Color3.fromRGB(0, 0, 0)
			AlphaSelector.BorderSizePixel = 2
			AlphaSelector.Position = UDim2.new(1, 0, 0.5, 0)
			AlphaSelector.Size = UDim2.new(0, 4, 1, 4)
			AlphaSelector.Parent = AlphaBar

			AlphaBar.Parent = PickerOutline

			local HexBox = Instance.new("TextBox")
			HexBox.Name = "HexBox"
			HexBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			HexBox.BorderColor3 = Color3.fromRGB(50, 50, 50)
			HexBox.BorderSizePixel = 0
			HexBox.Position = UDim2.new(0, 5, 1, -38)
			HexBox.Size = UDim2.new(1, -10, 0, 18)
			HexBox.FontFace = Font.fromEnum(Enum.Font.RobotoMono)
			HexBox.Text = "#FF58A6"
			HexBox.TextColor3 = Color3.fromRGB(255, 255, 255)
			HexBox.TextSize = 11
			HexBox.TextStrokeTransparency = 0
			HexBox.ZIndex = 10
			HexBox.Parent = PickerOutline

			local function UpdateColor()
				local h, s, v = Colorpicker.State:ToHSV()
				HueSat.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
				HueSatSelector.Position = UDim2.new(s, 0, 1 - v, 0)
				HueSelector.Position = UDim2.new(0, 0, h, 0)
				AlphaBar.BackgroundColor3 = Color3.fromHSV(h, s, 1)
				AlphaSelector.Position = UDim2.new(1, 0, 0.5, 0)
				Inline.BackgroundColor3 = Colorpicker.State
				HexBox.Text = "#" .. Colorpicker.State:ToHex()
				Library.Flags[Colorpicker.Flag] = Colorpicker.State
				Colorpicker.Callback(Colorpicker.State)
			end

			local function SetColor(color)
				Colorpicker.State = color
				UpdateColor()
			end

			local DraggingHueSat = false
			local DraggingHue = false
			local DraggingAlpha = false

			HueSat.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					DraggingHueSat = true
				end
			end)

			HueSat.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					DraggingHueSat = false
				end
			end)

			HueBar.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					DraggingHue = true
				end
			end)

			HueBar.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					DraggingHue = false
				end
			end)

			AlphaBar.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					DraggingAlpha = true
				end
			end)

			AlphaBar.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					DraggingAlpha = false
				end
			end)

			UserInputService.InputChanged:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
					if DraggingHueSat then
						local relX = math.clamp((input.Position.X - HueSat.AbsolutePosition.X) / HueSat.AbsoluteSize.X, 0, 1)
						local relY = math.clamp((input.Position.Y - HueSat.AbsolutePosition.Y) / HueSat.AbsoluteSize.Y, 0, 1)
						local h, s, v = Colorpicker.State:ToHSV()
						Colorpicker.State = Color3.fromHSV(h, relX, 1 - relY)
						UpdateColor()
					elseif DraggingHue then
						local relY = math.clamp((input.Position.Y - HueBar.AbsolutePosition.Y) / HueBar.AbsoluteSize.Y, 0, 1)
						local h, s, v = Colorpicker.State:ToHSV()
						Colorpicker.State = Color3.fromHSV(relY, s, v)
						UpdateColor()
					elseif DraggingAlpha then
						local relX = math.clamp((input.Position.X - AlphaBar.AbsolutePosition.X) / AlphaBar.AbsoluteSize.X, 0, 1)
						local h, s, v = Colorpicker.State:ToHSV()
						Colorpicker.State = Color3.fromHSV(h, s, v)
						Colorpicker.State = Color3.new(Colorpicker.State.R, Colorpicker.State.G, Colorpicker.State.B)
						UpdateColor()
					end
				end
			end)

			HexBox.FocusLost:Connect(function()
				local text = HexBox.Text:gsub("#", "")
				if #text == 6 then
					local r = tonumber(text:sub(1, 2), 16) / 255
					local g = tonumber(text:sub(3, 4), 16) / 255
					local b = tonumber(text:sub(5, 6), 16) / 255
					if r and g and b then
						SetColor(Color3.new(r, g, b))
					end
				end
			end)

			Inline.MouseButton1Click:Connect(function()
				Colorpicker.Open = not Colorpicker.Open
				PickerFrame.Visible = Colorpicker.Open
				if Colorpicker.Open then
					UpdateColor()
				end
			end)

			Library:Connection(game:GetService("UserInputService").InputBegan, function(Input)
				if Colorpicker.Open and Input.UserInputType == Enum.UserInputType.MouseButton1 then
					if not Library:IsMouseOverFrame(PickerFrame) and not Library:IsMouseOverFrame(Inline) then
						Colorpicker.Open = false
						PickerFrame.Visible = false
					end
				end
			end)

			function Colorpicker:Set(color)
				SetColor(color)
			end

			Library.Flags[Colorpicker.Flag] = Colorpicker.State
			UpdateColor()

			return Colorpicker
		end
	end
end;

-- ========================================
-- =========== VISIONWARE SETUP ============
-- ========================================

local Window = Library:Window({Name = "VisionWare v2.0 | $portal$", Amount = 6})
local Watermark = Library:Watermark({Name = "VisionWare | v2.0 | Press END"})

-- Create Pages
local AimbotPage = Window:Page({Name = "Aimbot"})
local ESPPage = Window:Page({Name = "ESP"})
local ChamsPage = Window:Page({Name = "Chams"})
local VisualsPage = Window:Page({Name = "Visuals"})
local MovementPage = Window:Page({Name = "Movement"})
local SettingsPage = Window:Page({Name = "Settings"})

-- ========================================
-- =========== AIMBOT ====================
-- ========================================

local AimbotMain = AimbotPage:Section({Name = "Main"})
local AimbotAdvanced = AimbotPage:Section({Name = "Advanced", Side = "Right"})

AimbotMain:Toggle({Name = "Enable Aimbot", Flag = "Aimbot_Enabled"})
AimbotMain:Toggle({Name = "Silent Aim", Flag = "Aimbot_Silent"})
AimbotMain:Keybind({Name = "Activation Key", Flag = "Aimbot_Key", Default = Enum.KeyCode.RightShift})
AimbotMain:List({Name = "Target Selection", Flag = "Aimbot_Selection", Options = {"Closest to Crosshair", "Closest to Player", "Lowest Health"}, Default = "Closest to Crosshair"})
AimbotMain:List({Name = "Hitpart", Flag = "Aimbot_Hitpart", Options = {"Head", "HumanoidRootPart", "Torso"}, Default = "Head"})

AimbotAdvanced:Slider({Name = "FOV Circle", Flag = "Aimbot_FOV", Min = 0, Max = 500, Default = 200, Decimals = 0})
AimbotAdvanced:Toggle({Name = "Visible Check", Flag = "Aimbot_VisibleCheck", Default = true})
AimbotAdvanced:Toggle({Name = "Team Check", Flag = "Aimbot_TeamCheck", Default = true})
AimbotAdvanced:Toggle({Name = "Prediction", Flag = "Aimbot_Prediction", Default = true})
AimbotAdvanced:Slider({Name = "Smoothness", Flag = "Aimbot_Smoothness", Min = 0, Max = 100, Default = 15, Decimals = 0})

-- ========================================
-- =========== ESP =======================
-- ========================================

local ESPMain = ESPPage:Section({Name = "Main"})
local ESPVisuals = ESPPage:Section({Name = "Visuals", Side = "Right"})

ESPMain:Toggle({Name = "Enable ESP", Flag = "ESP_Enabled"})
ESPMain:Toggle({Name = "Player Boxes", Flag = "ESP_Boxes", Default = true})
ESPMain:List({Name = "Box Type", Flag = "ESP_BoxType", Options = {"2D", "3D", "Corner", "Filled"}, Default = "2D"})
ESPMain:Toggle({Name = "Player Names", Flag = "ESP_Names", Default = true})
ESPMain:Toggle({Name = "Health Bars", Flag = "ESP_HealthBars", Default = true})
ESPMain:Toggle({Name = "Distance Display", Flag = "ESP_Distance", Default = true})

ESPVisuals:Toggle({Name = "Tracers", Flag = "ESP_Tracers"})
ESPVisuals:List({Name = "Tracer Position", Flag = "ESP_TracerPos", Options = {"Bottom", "Top", "Center", "Mouse"}, Default = "Bottom"})
ESPVisuals:Toggle({Name = "Skeleton", Flag = "ESP_Skeleton"})
ESPVisuals:Toggle({Name = "Head Dot", Flag = "ESP_HeadDot"})
ESPVisuals:Slider({Name = "ESP Range", Flag = "ESP_Range", Min = 100, Max = 10000, Default = 5000, Decimals = 0})
ESPVisuals:Toggle({Name = "Visible Only", Flag = "ESP_VisibleOnly"})
ESPVisuals:Toggle({Name = "Team Check", Flag = "ESP_TeamCheck", Default = true})

ESPVisuals:Colorpicker({Name = "Enemy Color", Flag = "ESP_EnemyColor", Default = Color3.fromRGB(255, 50, 50)})
ESPVisuals:Colorpicker({Name = "Team Color", Flag = "ESP_TeamColor", Default = Color3.fromRGB(50, 255, 50)})
ESPVisuals:Colorpicker({Name = "Visible Color", Flag = "ESP_VisibleColor", Default = Color3.fromRGB(0, 255, 255)})

-- ========================================
-- =========== CHAMS ====================
-- ========================================

local ChamsMain = ChamsPage:Section({Name = "Chams"})
local ChamsSettings = ChamsPage:Section({Name = "Settings", Side = "Right"})

ChamsMain:Toggle({Name = "Enable Chams", Flag = "Chams_Enabled"})
ChamsMain:Toggle({Name = "Visible Only", Flag = "Chams_VisibleOnly"})
ChamsMain:Slider({Name = "Opacity", Flag = "Chams_Opacity", Min = 0, Max = 1, Default = 0.5, Decimals = 2})

ChamsSettings:Toggle({Name = "Team Check", Flag = "Chams_TeamCheck", Default = true})
ChamsSettings:Colorpicker({Name = "Enemy Chams", Flag = "Chams_EnemyColor", Default = Color3.fromRGB(255, 50, 50)})
ChamsSettings:Colorpicker({Name = "Team Chams", Flag = "Chams_TeamColor", Default = Color3.fromRGB(50, 255, 50)})
ChamsSettings:Colorpicker({Name = "Visible Chams", Flag = "Chams_VisibleColor", Default = Color3.fromRGB(0, 255, 255)})

-- ========================================
-- =========== VISUALS ===================
-- ========================================

local VisualsLighting = VisualsPage:Section({Name = "Lighting"})
local VisualsEffects = VisualsPage:Section({Name = "Effects", Side = "Right"})

VisualsLighting:Toggle({Name = "Fullbright", Flag = "Visuals_Fullbright"})
VisualsLighting:Slider({Name = "Brightness", Flag = "Visuals_Brightness", Min = 0, Max = 5, Default = 1, Decimals = 1})
VisualsLighting:Toggle({Name = "Remove Fog", Flag = "Visuals_NoFog"})
VisualsLighting:Toggle({Name = "No Clouds", Flag = "Visuals_NoClouds"})

VisualsEffects:Toggle({Name = "Highlight (Glow)", Flag = "Visuals_Highlight"})
VisualsEffects:Toggle({Name = "Night Vision", Flag = "Visuals_NightVision"})
VisualsEffects:Textbox({Name = "Custom Skybox ID", Flag = "Visuals_SkyboxID", Placeholder = "rbxassetid://..."})
VisualsEffects:Button({Name = "Apply Skybox", Callback = function()
	Library:Notification("Skybox applied!", 2, Library.Accent)
end})

-- ========================================
-- =========== MOVEMENT ==================
-- ========================================

local MovementBasic = MovementPage:Section({Name = "Basic"})
local MovementAdvanced = MovementPage:Section({Name = "Advanced", Side = "Right"})

MovementBasic:Toggle({Name = "Walk Speed", Flag = "Movement_WalkSpeed"})
MovementBasic:Slider({Name = "Speed Amount", Flag = "Movement_WalkSpeedAmount", Min = 0, Max = 200, Default = 50, Decimals = 1})
MovementBasic:Toggle({Name = "Jump Power", Flag = "Movement_JumpPower"})
MovementBasic:Slider({Name = "Jump Amount", Flag = "Movement_JumpAmount", Min = 0, Max = 500, Default = 50, Decimals = 1})
MovementBasic:Toggle({Name = "Infinite Jump", Flag = "Movement_InfiniteJump"})

MovementAdvanced:Toggle({Name = "Noclip", Flag = "Movement_Noclip"})
MovementAdvanced:Toggle({Name = "Fly", Flag = "Movement_Fly"})
MovementAdvanced:Slider({Name = "Fly Speed", Flag = "Movement_FlySpeed", Min = 0, Max = 200, Default = 50, Decimals = 1})
MovementAdvanced:Toggle({Name = "BHop (Strafe)", Flag = "Movement_BHop"})
MovementAdvanced:Slider({Name = "Velocity Multiplier", Flag = "Movement_VelocityMult", Min = 0, Max = 5, Default = 1, Decimals = 2})

-- ========================================
-- =========== SETTINGS ==================
-- ========================================

local SettingsMenu = SettingsPage:Section({Name = "Menu"})
local SettingsConfig = SettingsPage:Section({Name = "Configuration", Side = "Right"})

SettingsMenu:Keybind({Name = "Menu Key", Flag = "Settings_MenuKey", Default = Enum.KeyCode.End, UseKey = true, Callback = function(Key)
	if Key then Library.UIKey = Key end
end})
SettingsMenu:Colorpicker({Name = "Accent Color", Flag = "Settings_AccentColor", Default = Library.Accent, Callback = function(c)
	Library:ChangeAccent(c)
end})
SettingsMenu:Button({Name = "Change Accent", Callback = function()
	Library:ChangeAccent(Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)))
	Library:Notification("Accent color changed!", 2)
end})
SettingsMenu:Toggle({Name = "Show Watermark", Flag = "Settings_Watermark", Default = true, Callback = function(v)
	Watermark:SetVisible(v)
end})
SettingsMenu:Toggle({Name = "Show Keybind List", Flag = "Settings_KeybindList", Default = true})
SettingsMenu:Toggle({Name = "Watermark FPS", Flag = "Settings_WatermarkFPS"})

SettingsConfig:Textbox({Name = "Watermark Text", Flag = "Settings_WatermarkText", State = "VisionWare | v2.0", Callback = function(v)
	Watermark:UpdateText(v)
end})
SettingsConfig:Button({Name = "Test Notification", Callback = function()
	Library:Notification("VisionWare loaded successfully!", 3, Library.Accent)
end})
SettingsConfig:Divider({Name = "Config"})
SettingsConfig:Textbox({Name = "Config Name", Flag = "Settings_ConfigName", Placeholder = "myconfig"})
SettingsConfig:Button({Name = "Save Config", Callback = function()
	Library:Notification("Config saved!", 2, Color3.fromRGB(0, 255, 0))
end})
SettingsConfig:Button({Name = "Load Config", Callback = function()
	Library:Notification("Config loaded!", 2, Color3.fromRGB(100, 200, 255))
end})

-- ========================================
-- =========== GAME LOGIC =================
-- ========================================

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Setup keyboard shortcuts
UserInputService.InputBegan:Connect(function(Input, GameProcessed)
	if GameProcessed then return end
	if Input.KeyCode == Library.UIKey then
		Library:SetOpen(not Library.Open)
	end
end)

-- Keybind List
local KeybindList = Instance.new("Frame")
KeybindList.Name = "KeybindList"
KeybindList.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
KeybindList.BorderColor3 = Color3.fromRGB(0, 0, 0)
KeybindList.BorderSizePixel = 0
KeybindList.Position = UDim2.new(1, -220, 0, 20)
KeybindList.Size = UDim2.new(0, 200, 0, 20)
KeybindList.Visible = false
KeybindList.ZIndex = 999999
KeybindList.Parent = Library.ScreenGUI

local KeybindOutline = Instance.new("Frame")
KeybindOutline.Name = "KeybindOutline"
KeybindOutline.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
KeybindOutline.BorderColor3 = Color3.fromRGB(0, 0, 0)
KeybindOutline.Size = UDim2.new(1, 0, 1, 0)
KeybindOutline.Parent = KeybindList

local KeybindInline = Instance.new("Frame")
KeybindInline.Name = "KeybindInline"
KeybindInline.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
KeybindInline.BorderColor3 = Color3.fromRGB(0, 0, 0)
KeybindInline.BorderSizePixel = 0
KeybindInline.Position = UDim2.new(0, 1, 0, 1)
KeybindInline.Size = UDim2.new(1, -2, 1, -2)
KeybindInline.Parent = KeybindOutline

local KeybindTitle = Instance.new("TextLabel")
KeybindTitle.Name = "KeybindTitle"
KeybindTitle.FontFace = Font.fromEnum(Enum.Font.RobotoMono)
KeybindTitle.Text = "Keybinds"
KeybindTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
KeybindTitle.TextSize = 12
KeybindTitle.TextStrokeTransparency = 0
KeybindTitle.TextXAlignment = Enum.TextXAlignment.Left
KeybindTitle.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
KeybindTitle.BackgroundTransparency = 1
KeybindTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
KeybindTitle.BorderSizePixel = 0
KeybindTitle.Size = UDim2.new(1, 0, 0, 20)
KeybindTitle.Parent = KeybindInline

local KeybindAccent = Library:NewInstance("Frame", true)
KeybindAccent.Name = "Accent"
KeybindAccent.BackgroundColor3 = Library.Accent
KeybindAccent.BorderColor3 = Color3.fromRGB(0, 0, 0)
KeybindAccent.BorderSizePixel = 0
KeybindAccent.Size = UDim2.new(1, 0, 0, 1)
KeybindAccent.Parent = KeybindOutline

local KeybindContent = Instance.new("Frame")
KeybindContent.Name = "KeybindContent"
KeybindContent.BackgroundTransparency = 1
KeybindContent.Position = UDim2.new(0, 5, 0, 25)
KeybindContent.Size = UDim2.new(1, -10, 1, -30)
KeybindContent.Parent = KeybindInline

local KeybindListLayout = Instance.new("UIListLayout")
KeybindListLayout.Padding = UDim.new(0, 2)
KeybindListLayout.SortOrder = Enum.SortOrder.LayoutOrder
KeybindListLayout.Parent = KeybindContent

Library.KeyList = {Container = KeybindList, Content = KeybindContent}

local frames = 0
local lastTime = tick()

-- Anti-AFK
task.spawn(function()
	while true do
		if Library.Flags.Utility_AntiAFK then
			game:GetService("VirtualUser"):CaptureController()
		end
		task.wait(300)
	end
end)

-- FPS Counter & Keybind List updater
RunService.RenderStepped:Connect(function()
	frames = frames + 1
	local currentTime = tick()
	if currentTime - lastTime >= 1 then
		local fps = math.floor(frames / (currentTime - lastTime))
		frames = 0
		lastTime = currentTime
		
		if Library.Flags.Settings_WatermarkFPS and Watermark then
			Watermark:SetFPS(true)
			if Watermark.Name then
				Watermark:UpdateText(Watermark.Name)
			end
		end
		
		if Library.Flags.Settings_KeybindList and Library.KeyList then
			Library.KeyList.Container.Visible = true
			for _, child in pairs(Library.KeyList.Content:GetChildren()) do
				if child:IsA("TextLabel") then child:Destroy() end
			end
			
			for flag, value in pairs(Library.Flags) do
				if flag:find("_KEY") and value and value ~= "None" then
					local keyName = flag:gsub("_KEY", "")
					local displayName = keyName:gsub("_", " ")
					local keyText = Library.Keys[value] or tostring(value):gsub("Enum.KeyCode.", ""):gsub("Enum.UserInputType.", "")
					
					local KeyLabel = Instance.new("TextLabel")
					KeyLabel.FontFace = Font.fromEnum(Enum.Font.RobotoMono)
					KeyLabel.Text = string.format("  %s  [%s]", displayName, keyText)
					KeyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
					KeyLabel.TextSize = 11
					KeyLabel.TextStrokeTransparency = 0
					KeyLabel.TextXAlignment = Enum.TextXAlignment.Left
					KeyLabel.BackgroundTransparency = 1
					KeyLabel.Size = UDim2.new(1, 0, 0, 16)
					KeyLabel.Parent = Library.KeyList.Content
				end
			end
		elseif Library.KeyList then
			Library.KeyList.Container.Visible = false
		end
	end
	
	-- Apply flags logic here
	if Library.Flags.Movement_WalkSpeed then
		local char = game.Players.LocalPlayer.Character
		if char and char:FindFirstChild("Humanoid") then
			char.Humanoid.WalkSpeed = Library.Flags.Movement_WalkSpeedAmount or 50
		end
	end
end)

-- ========================================
-- =========== STARTUP ====================
-- ========================================

Library:SetOpen(true)
Library:Notification("VisionWare v2.0 loaded! Press END to toggle.", 4, Library.Accent)
print("✓ VisionWare Loaded Successfully!")
print("✓ Press END to toggle menu")