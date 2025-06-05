local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- === GUI ===
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "AllInOneGUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 420) -- увеличил высоту, чтобы вместить полёт и ноуклип
frame.Position = UDim2.new(0.5, -150, 0.5, -210)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -30, 0, 30)
title.Position = UDim2.new(0, 5, 0, 5)
title.Text = "🔥 Мульти-меню"
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 22
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Left

local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0, 25, 0, 25)
close.Position = UDim2.new(1, -30, 0, 5)
close.Text = "✕"
close.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
close.TextColor3 = Color3.new(1,1,1)
close.Font = Enum.Font.SourceSansBold
close.TextSize = 20

local collapse = Instance.new("TextButton", frame)
collapse.Size = UDim2.new(0, 25, 0, 25)
collapse.Position = UDim2.new(1, -60, 0, 5)
collapse.Text = "🗕"
collapse.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
collapse.TextColor3 = Color3.new(1,1,1)
collapse.Font = Enum.Font.SourceSansBold
collapse.TextSize = 18

local isCollapsed = false
local fullSize = frame.Size

collapse.MouseButton1Click:Connect(function()
	isCollapsed = not isCollapsed
	if isCollapsed then
		frame.Size = UDim2.new(fullSize.X.Scale, fullSize.X.Offset, 0, 40)
		for _, child in pairs(frame:GetChildren()) do
			if child ~= title and child ~= close and child ~= collapse then
				child.Visible = false
			end
		end
		collapse.Text = "🗖"
	else
		frame.Size = fullSize
		for _, child in pairs(frame:GetChildren()) do
			child.Visible = true
		end
		collapse.Text = "🗕"
	end
end)

close.MouseButton1Click:Connect(function()
	gui:Destroy()
	if flying then
		stopFly()
	end
	if noclipRunning then
		stopNoclip()
	end
end)

-- === Кнопки и логика ===
local y = 40
local function makeButton(text)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(1, -20, 0, 30)
	btn.Position = UDim2.new(0, 10, 0, y)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 16
	btn.Text = text
	y += 40
	return btn
end

local speedBtn = makeButton("⚡ Включить бег")
local jumpBtn = makeButton("🟢 Включить прыжок")
local flyBtn = makeButton("🛫 Включить полёт")
local noclipBtn = makeButton("Noclip: ВЫКЛ") -- кнопка для ноуклипа

-- === Слайдеры скорости ===
local sliderFrame = Instance.new("Frame", frame)
sliderFrame.Size = UDim2.new(1, -20, 0, 40)
sliderFrame.Position = UDim2.new(0, 10, 0, y)
sliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
y += 50

local sliderBar = Instance.new("Frame", sliderFrame)
sliderBar.Size = UDim2.new(1, -20, 0, 6)
sliderBar.Position = UDim2.new(0, 10, 0.5, -3)
sliderBar.BackgroundColor3 = Color3.fromRGB(100, 100, 100)

local slider = Instance.new("Frame", sliderBar)
slider.Size = UDim2.new(0, 10, 0, 16)
slider.Position = UDim2.new(0, 0, -0.5, 0)
slider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

local speedLabel = Instance.new("TextLabel", sliderFrame)
speedLabel.Size = UDim2.new(1, 0, 0, 20)
speedLabel.Position = UDim2.new(0, 0, 1, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.new(1,1,1)
speedLabel.Text = "Скорость: 2.5"
speedLabel.Font = Enum.Font.SourceSans
speedLabel.TextSize = 16

local flySliderFrame = Instance.new("Frame", frame)
flySliderFrame.Size = UDim2.new(1, -20, 0, 40)
flySliderFrame.Position = UDim2.new(0, 10, 0.02, y)
flySliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
y += 50

local flySliderBar = Instance.new("Frame", flySliderFrame)
flySliderBar.Size = UDim2.new(1, -20, 0, 6)
flySliderBar.Position = UDim2.new(0, 10, 0.5, -3)
flySliderBar.BackgroundColor3 = Color3.fromRGB(100, 100, 100)

local flySlider = Instance.new("Frame", flySliderBar)
flySlider.Size = UDim2.new(0, 10, 0, 16)
flySlider.Position = UDim2.new(0, 0, -0.5, 0)
flySlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

local flySpeedLabel = Instance.new("TextLabel", flySliderFrame)
flySpeedLabel.Size = UDim2.new(1, 0, 0, 20)
flySpeedLabel.Position = UDim2.new(0, 0, 1, 0)
flySpeedLabel.BackgroundTransparency = 1
flySpeedLabel.TextColor3 = Color3.new(1,1,1)
flySpeedLabel.Text = "Скорость полёта: 40"
flySpeedLabel.Font = Enum.Font.SourceSans
flySpeedLabel.TextSize = 16

-- === Логика функций ===
local speed = 2.5
local minSpeed = 1
local maxSpeed = 30
local speedEnabled = false
local jumpEnabled = false

local flying = false
local flySpeed = 40
local flyMinSpeed = 10
local flyMaxSpeed = 250
local bv, bg
local moveVector = Vector3.zero
local keysPressed = {}
local HRP = nil

local directions = {
	[Enum.KeyCode.W] = Vector3.new(0, 0, -1),
	[Enum.KeyCode.S] = Vector3.new(0, 0, 1),
	[Enum.KeyCode.A] = Vector3.new(-1, 0, 0),
	[Enum.KeyCode.D] = Vector3.new(1, 0, 0),
	[Enum.KeyCode.Space] = Vector3.new(0, 1, 0),
	[Enum.KeyCode.LeftShift] = Vector3.new(0, -1, 0),
}

local function updateMoveVector()
	moveVector = Vector3.zero
	for key, dir in pairs(directions) do
		if keysPressed[key] then
			moveVector += dir
		end
	end
end

local function startFly()
	if flying then return end
	if not HRP then return end
	flying = true
	bv = Instance.new("BodyVelocity")
	bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
	bv.Velocity = Vector3.zero
	bv.P = 1000
	bv.Parent = HRP
	bg = Instance.new("BodyGyro")
	bg.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
	bg.P = 3000
	bg.CFrame = HRP.CFrame
	bg.Parent = HRP
	RunService:BindToRenderStep("FlyControl", Enum.RenderPriority.Character.Value + 1, function()
		local camCF = workspace.CurrentCamera.CFrame
		local dir = camCF:VectorToWorldSpace(moveVector)
		bv.Velocity = dir.Magnitude > 0 and dir.Unit * flySpeed or Vector3.zero
		bg.CFrame = camCF
		local rootCF = HRP.CFrame
		local lookDir = Vector3.new(camCF.LookVector.X, 0, camCF.LookVector.Z)
		if lookDir.Magnitude > 0.1 then
			HRP.CFrame = CFrame.new(rootCF.Position, rootCF.Position + lookDir)
		end
	end)
end

local function stopFly()
	if not flying then return end
	flying = false
	if bv then bv:Destroy() end
	if bg then bg:Destroy() end
	RunService:UnbindFromRenderStep("FlyControl")
end

-- Noclip логика
local noclipRunning = false

local function setCanCollide(value)
	local char = LocalPlayer.Character
	if not char then return end
	for _, part in pairs(char:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = value
		end
	end
end

local function startNoclip()
	noclipRunning = true
	noclipBtn.Text = "Noclip: ВКЛ"
	noclipBtn.BackgroundColor3 = Color3.fromRGB(30, 150, 30)
end

local function stopNoclip()
	noclipRunning = false
	noclipBtn.Text = "Noclip: ВЫКЛ"
	noclipBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	setCanCollide(true)
end

local function toggleNoclip()
	if noclipRunning then
		stopNoclip()
	else
		startNoclip()
	end
end

noclipBtn.MouseButton1Click:Connect(toggleNoclip)

RunService.Stepped:Connect(function()
	if noclipRunning then
		setCanCollide(false)
	end
end)

-- Обновление HRP при спавне персонажа
LocalPlayer.CharacterAdded:Connect(function(char)
	HRP = char:WaitForChild("HumanoidRootPart")
	if flying then
		startFly()
	end
	if noclipRunning then
		setCanCollide(false)
	end
end)
if LocalPlayer.Character then
	HRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end

-- Обработка бег и прыжок
speedBtn.MouseButton1Click:Connect(function()
	speedEnabled = not speedEnabled
	if speedEnabled then
		speedBtn.Text = "⚡ Выключить бег"
		LocalPlayer.Character.Humanoid.WalkSpeed = speed
	else
		speedBtn.Text = "⚡ Включить бег"
		LocalPlayer.Character.Humanoid.WalkSpeed = 16
	end
end)

jumpBtn.MouseButton1Click:Connect(function()
	jumpEnabled = not jumpEnabled
	if jumpEnabled then
		jumpBtn.Text = "🔴 Выключить прыжок"
		LocalPlayer.Character.Humanoid.JumpPower = 100
	else
		jumpBtn.Text = "🟢 Включить прыжок"
		LocalPlayer.Character.Humanoid.JumpPower = 50
	end
end)

flyBtn.MouseButton1Click:Connect(function()
	if flying then
		flyBtn.Text = "🛫 Включить полёт"
		stopFly()
	else
		if HRP then
			flyBtn.Text = "🛬 Выключить полёт"
			startFly()
		end
	end
end)

-- Слайдер управления скоростью бега
local draggingSpeed = false
sliderBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingSpeed = true
	end
end)
sliderBar.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingSpeed = false
	end
end)
sliderBar.InputChanged:Connect(function(input)
	if draggingSpeed and input.UserInputType == Enum.UserInputType.MouseMovement then
		local relativeX = math.clamp(input.Position.X - sliderBar.AbsolutePosition.X, 0, sliderBar.AbsoluteSize.X)
		local percent = relativeX / sliderBar.AbsoluteSize.X
		speed = minSpeed + (maxSpeed - minSpeed) * percent
		speedLabel.Text = ("Скорость: %.1f"):format(speed)
		if speedEnabled then
			LocalPlayer.Character.Humanoid.WalkSpeed = speed
		end
		slider.Position = UDim2.new(percent, 0, -0.5, 0)
	end
end)

-- Слайдер управления скоростью полёта
local draggingFlySpeed = false
flySliderBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingFlySpeed = true
	end
end)
flySliderBar.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingFlySpeed = false
	end
end)
flySliderBar.InputChanged:Connect(function(input)
	if draggingFlySpeed and input.UserInputType == Enum.UserInputType.MouseMovement then
		local relativeX = math.clamp(input.Position.X - flySliderBar.AbsolutePosition.X, 0, flySliderBar.AbsoluteSize.X)
		local percent = relativeX / flySliderBar.AbsoluteSize.X
		flySpeed = flyMinSpeed + (flyMaxSpeed - flyMinSpeed) * percent
		flySpeedLabel.Text = ("Скорость полёта: %.0f"):format(flySpeed)
		flySlider.Position = UDim2.new(percent, 0, -0.5, 0)
	end
end)

-- Обработка нажатий для полёта
UIS.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if directions[input.KeyCode] then
		keysPressed[input.KeyCode] = true
		updateMoveVector()
	end
end)
UIS.InputEnded:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if directions[input.KeyCode] then
		keysPressed[input.KeyCode] = false
		updateMoveVector()
	end
end)
