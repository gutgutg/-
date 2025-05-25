local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local lp = Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()

-- === GUI ===
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "AllInOneGUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 300)
frame.Position = UDim2.new(0.5, -150, 0.5, -150)
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
end)

-- === Кнопки ===
local speedBtn = Instance.new("TextButton", frame)
speedBtn.Size = UDim2.new(1, -20, 0, 40)
speedBtn.Position = UDim2.new(0, 10, 0, 50)
speedBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
speedBtn.TextColor3 = Color3.new(1, 1, 1)
speedBtn.Font = Enum.Font.SourceSansBold
speedBtn.TextSize = 18
speedBtn.Text = "⚡ Включить быстрый бег"

local jumpBtn = Instance.new("TextButton", frame)
jumpBtn.Size = UDim2.new(1, -20, 0, 40)
jumpBtn.Position = UDim2.new(0, 10, 0, 100)
jumpBtn.BackgroundColor3 = Color3.fromRGB(60, 180, 90)
jumpBtn.TextColor3 = Color3.new(1, 1, 1)
jumpBtn.Font = Enum.Font.SourceSansBold
jumpBtn.TextSize = 18
jumpBtn.Text = "🟢 Включить бесконечный прыжок"

local espBtn = Instance.new("TextButton", frame)
espBtn.Size = UDim2.new(1, -20, 0, 40)
espBtn.Position = UDim2.new(0, 10, 0, 150)
espBtn.BackgroundColor3 = Color3.fromRGB(150, 90, 255)
espBtn.TextColor3 = Color3.new(1, 1, 1)
espBtn.Font = Enum.Font.SourceSansBold
espBtn.TextSize = 18
espBtn.Text = "🔍 Включить ESP"

-- === Слайдер скорости ===
local sliderFrame = Instance.new("Frame", frame)
sliderFrame.Size = UDim2.new(1, -20, 0, 40)
sliderFrame.Position = UDim2.new(0, 10, 0, 200)
sliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
sliderFrame.Active = true -- важное изменение
sliderFrame.Draggable = false

local sliderBar = Instance.new("Frame", sliderFrame)
sliderBar.Size = UDim2.new(1, -20, 0, 6)
sliderBar.Position = UDim2.new(0, 10, 0.5, -3)
sliderBar.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
sliderBar.BorderSizePixel = 0

local slider = Instance.new("Frame", sliderBar)
slider.Size = UDim2.new(0, 10, 0, 16)
slider.Position = UDim2.new(0, 0, -0.5, 0)
slider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
slider.BorderSizePixel = 0

local speedLabel = Instance.new("TextLabel", sliderFrame)
speedLabel.Size = UDim2.new(1, 0, 0, 20)
speedLabel.Position = UDim2.new(0, 0, 1, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.new(1,1,1)
speedLabel.Text = "Скорость: 2.5"
speedLabel.Font = Enum.Font.SourceSans
speedLabel.TextSize = 16

sliderBar.Parent = sliderFrame
slider.Parent = sliderBar
speedLabel.Parent = sliderFrame

-- === Логика ===
local speed = 2.5
local minSpeed = 1
local maxSpeed = 30
local speedEnabled = false
local jumpEnabled = false
local espEnabled = false
local espPlayers = {}

local function updateSlider(inputX)
	local relativeX = math.clamp((inputX - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
	slider.Position = UDim2.new(relativeX, -5, -0.5, 0)
	speed = minSpeed + (maxSpeed - minSpeed) * relativeX
	speedLabel.Text = "Скорость: " .. string.format("%.1f", speed)
end

sliderBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		updateSlider(input.Position.X)
		local moveConn
		moveConn = UIS.InputChanged:Connect(function(inputMove)
			if inputMove.UserInputType == Enum.UserInputType.MouseMovement then
				updateSlider(inputMove.Position.X)
			end
		end)
		UIS.InputEnded:Connect(function(endInput)
			if endInput.UserInputType == Enum.UserInputType.MouseButton1 then
				if moveConn then moveConn:Disconnect() end
			end
		end)
	end
end)

RunService.RenderStepped:Connect(function(dt)
	if speedEnabled and lp.Character and lp.Character:FindFirstChild("Humanoid") and lp.Character:FindFirstChild("HumanoidRootPart") then
		local hum = lp.Character.Humanoid
		local root = lp.Character.HumanoidRootPart
		if hum.MoveDirection.Magnitude > 0 then
			local moveVec = hum.MoveDirection.Unit * speed
			root.CFrame = root.CFrame + (moveVec * dt * 10)
		end
	end
end)

speedBtn.MouseButton1Click:Connect(function()
	speedEnabled = not speedEnabled
	speedBtn.Text = speedEnabled and "⛔ Выключить бег" or "⚡ Включить бег"
end)

UIS.JumpRequest:Connect(function()
	if jumpEnabled and lp.Character and lp.Character:FindFirstChildOfClass("Humanoid") then
		lp.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

jumpBtn.MouseButton1Click:Connect(function()
	jumpEnabled = not jumpEnabled
	jumpBtn.Text = jumpEnabled and "⛔ Выключить прыжок" or "🟢 Включить прыжок"
end)

-- === ESP с никнеймами ===
local function createESP(char)
	if not char or espPlayers[char] then return end

	local highlight = Instance.new("Highlight")
	highlight.Adornee = char
	highlight.FillColor = Color3.fromRGB(0, 255, 0)
	highlight.OutlineColor = Color3.fromRGB(0, 200, 0)
	highlight.Parent = gui

	local head = char:FindFirstChild("Head")
	local billboard
	if head then
		billboard = Instance.new("BillboardGui")
		billboard.Adornee = head
		billboard.Size = UDim2.new(0, 100, 0, 40)
		billboard.StudsOffset = Vector3.new(0, 2, 0)
		billboard.AlwaysOnTop = true
		billboard.Parent = gui

		local label = Instance.new("TextLabel", billboard)
		label.Size = UDim2.new(1, 0, 1, 0)
		label.BackgroundTransparency = 1
		label.TextColor3 = Color3.fromRGB(0, 255, 0)
		label.TextStrokeColor3 = Color3.new(0, 0, 0)
		label.TextStrokeTransparency = 0
		label.Text = char.Name
		label.Font = Enum.Font.SourceSansBold
		label.TextScaled = true
	end

	espPlayers[char] = {Highlight = highlight, Billboard = billboard}
end

local function removeESP(char)
	local esp = espPlayers[char]
	if esp then
		if esp.Highlight then esp.Highlight:Destroy() end
		if esp.Billboard then esp.Billboard:Destroy() end
		espPlayers[char] = nil
	end
end

local function toggleESP()
	espEnabled = not espEnabled
	espBtn.Text = espEnabled and "⛔ Выключить ESP" or "🔍 Включить ESP"
	if espEnabled then
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= lp and p.Character then
				createESP(p.Character)
			end
		end
	else
		for char in pairs(espPlayers) do
			removeESP(char)
		end
	end
end

espBtn.MouseButton1Click:Connect(toggleESP)

Players.PlayerAdded:Connect(function(p)
	p.CharacterAdded:Connect(function(char)
		if espEnabled then createESP(char) end
	end)
end)

Players.PlayerRemoving:Connect(function(p)
	if p.Character then removeESP(p.Character) end
end)
