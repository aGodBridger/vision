-- AmberGUI Tween Utilities
-- Wrapper around Roblox TweenService with helper functions

local TweenService = game:GetService("TweenService")

local TweenUtils = {}

-- Easing styles mapping
TweenUtils.EasingStyles = {
	Linear = Enum.EasingStyle.Linear,
	Sine = Enum.EasingStyle.Sine,
	Back = Enum.EasingStyle.Back,
	Quad = Enum.EasingStyle.Quad,
	Quart = Enum.EasingStyle.Quart,
	Quint = Enum.EasingStyle.Quint,
	Bounce = Enum.EasingStyle.Bounce,
	Elastic = Enum.EasingStyle.Elastic,
	Exponential = Enum.EasingStyle.Exponential,
	Circular = Enum.EasingStyle.Circular,
	Cubic = Enum.EasingStyle.Cubic,
}

TweenUtils.EasingDirections = {
	In = Enum.EasingDirection.In,
	Out = Enum.EasingDirection.Out,
	InOut = Enum.EasingDirection.InOut,
}

-- Create a tween
function TweenUtils.Create(instance, properties, duration, easingStyle, easingDirection, repeatCount, reverses, delayTime)
	local tweenInfo = TweenInfo.new(
		duration or 0.3,
		easingStyle or Enum.EasingStyle.Quad,
		easingDirection or Enum.EasingDirection.Out,
		repeatCount or 0,
		reverses or false,
		delayTime or 0
	)
	return TweenService:Create(instance, tweenInfo, properties)
end

-- Quick tween with promise-like completion
function TweenUtils.Tween(instance, properties, duration, easingStyle, easingDirection)
	local tween = TweenUtils.Create(instance, properties, duration, easingStyle, easingDirection)
	tween:Play()
	return tween
end

-- Tween position
function TweenUtils.TweenPosition(instance, position, duration, easingStyle, easingDirection)
	return TweenUtils.Tween(instance, {Position = position}, duration, easingStyle, easingDirection)
end

-- Tween size
function TweenUtils.TweenSize(instance, size, duration, easingStyle, easingDirection)
	return TweenUtils.Tween(instance, {Size = size}, duration, easingStyle, easingDirection)
end

-- Tween transparency
function TweenUtils.TweenTransparency(instance, transparency, duration, easingStyle, easingDirection)
	return TweenUtils.Tween(instance, {BackgroundTransparency = transparency}, duration, easingStyle, easingDirection)
end

-- Tween color
function TweenUtils.TweenColor(instance, color, duration, easingStyle, easingDirection)
	return TweenUtils.Tween(instance, {BackgroundColor3 = color}, duration, easingStyle, easingDirection)
end

-- Tween text color
function TweenUtils.TweenTextColor(instance, color, duration, easingStyle, easingDirection)
	return TweenUtils.Tween(instance, {TextColor3 = color}, duration, easingStyle, easingDirection)
end

-- Tween rotation
function TweenUtils.TweenRotation(instance, rotation, duration, easingStyle, easingDirection)
	return TweenUtils.Tween(instance, {Rotation = rotation}, duration, easingStyle, easingDirection)
end

-- Fade in
function TweenUtils.FadeIn(instance, duration, easingStyle, easingDirection)
	instance.Visible = true
	return TweenUtils.TweenTransparency(instance, 0, duration, easingStyle, easingDirection)
end

-- Fade out
function TweenUtils.FadeOut(instance, duration, easingStyle, easingDirection)
	local tween = TweenUtils.TweenTransparency(instance, 1, duration, easingStyle, easingDirection)
	tween.Completed:Connect(function()
		instance.Visible = false
	end)
	return tween
end

-- Slide in from direction
function TweenUtils.SlideIn(instance, direction, distance, duration, easingStyle, easingDirection)
	distance = distance or 20
	duration = duration or 0.3
	
	local originalPos = instance.Position
	local startPos
	
	if direction == "Left" then
		startPos = originalPos - UDim2.new(0, distance, 0, 0)
	elseif direction == "Right" then
		startPos = originalPos + UDim2.new(0, distance, 0, 0)
	elseif direction == "Up" then
		startPos = originalPos - UDim2.new(0, 0, 0, distance)
	elseif direction == "Down" then
		startPos = originalPos + UDim2.new(0, 0, 0, distance)
	else
		startPos = originalPos
	end
	
	instance.Position = startPos
	instance.Visible = true
	return TweenUtils.TweenPosition(instance, originalPos, duration, easingStyle, easingDirection)
end

-- Pulse animation
function TweenUtils.Pulse(instance, scale, duration, easingStyle, easingDirection)
	scale = scale or 1.05
	duration = duration or 0.15
	
	local originalSize = instance.Size
	local targetSize = UDim2.new(
		originalSize.X.Scale * scale, originalSize.X.Offset * scale,
		originalSize.Y.Scale * scale, originalSize.Y.Offset * scale
	)
	
	local grow = TweenUtils.TweenSize(instance, targetSize, duration, easingStyle, easingDirection)
	grow.Completed:Connect(function()
		TweenUtils.TweenSize(instance, originalSize, duration, easingStyle, easingDirection)
	end)
	return grow
end

-- Shake animation
function TweenUtils.Shake(instance, intensity, duration, easingStyle, easingDirection)
	intensity = intensity or 5
	duration = duration or 0.05
	
	local originalPos = instance.Position
	local shakes = 6
	local shakeDuration = duration / shakes
	
	local function doShake(i)
		if i >= shakes then
			instance.Position = originalPos
			return
		end
		
		local offsetX = math.random(-intensity, intensity)
		local offsetY = math.random(-intensity, intensity)
		local targetPos = originalPos + UDim2.new(0, offsetX, 0, offsetY)
		
		local tween = TweenUtils.TweenPosition(instance, targetPos, shakeDuration, easingStyle, easingDirection)
		tween.Completed:Connect(function()
			doShake(i + 1)
		end)
	end
	
	doShake(0)
end

-- Spring-like animation using RunService
function TweenUtils.Spring(instance, property, targetValue, stiffness, damping, mass)
	local RunService = game:GetService("RunService")
	
	stiffness = stiffness or 170
	damping = damping or 26
	mass = mass or 1
	
	local velocity = 0
	local currentValue = instance[property]
	
	local connection
	connection = RunService.Heartbeat:Connect(function(dt)
		local displacement = currentValue - targetValue
		local springForce = -stiffness * displacement
		local dampingForce = -damping * velocity
		local acceleration = (springForce + dampingForce) / mass
		
		velocity = velocity + acceleration * dt
		currentValue = currentValue + velocity * dt
		
		instance[property] = currentValue
		
		if math.abs(velocity) < 0.01 and math.abs(displacement) < 0.01 then
			instance[property] = targetValue
			connection:Disconnect()
		end
	end)
	
	return connection
end

-- Cancel all tweens on an instance
function TweenUtils.Cancel(instance)
	for _, tween in pairs(TweenService:GetPlayingTweens()) do
		if tween.Instance == instance then
			tween:Cancel()
		end
	end
end

-- Wait for tween completion (yields)
function TweenUtils.Wait(tween)
	local done = false
	tween.Completed:Connect(function()
		done = true
	end)
	while not done do
		task.wait()
	end
end

return TweenUtils