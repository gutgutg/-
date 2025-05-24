local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "SpeedBypassGUI"

local button = Instance.new("TextButton", gui)
button.Size = UDim2.new(0, 200, 0, 40)
button.Position = UDim2.new(0, 20, 0, 100)
button.Text = "⚡ Включить быстрый бег"
button.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
button.TextColor3 = Color3.new(1, 1, 1)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 20

local jumpBtn = Instance.new("TextButton", gui)
jumpBtn.Size = UDim2.new(0, 200, 0, 40)
jumpBtn.Position = UDim2.new(0, 20, 0, 150)
jumpBtn.Text = "🟢 Включить бесконечный прыжок"
jumpBtn.BackgroundColor3 = Color3.fromRGB(60, 180, 90)
jumpBtn.TextColor3 = Color3.new(1, 1, 1)
jumpBtn.Font = Enum.Font.SourceSansBold
jumpBtn.TextSize = 20

local closeBtn = Instance.new("TextButton", gui)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(0, 230, 0, 100)
closeBtn.Text = "❌"
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 20

local sliderFrame = Instance.new("Frame", gui)
sliderFrame.Size = UDim2.new(0, 200, 0, 50)
sliderFrame.Position = UDim2.new(0, 20, 0, 200)
sliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
sliderFrame.BorderSizePixel = 0

local sliderBar = Instance.new("Frame", sliderFrame)
sliderBar.Size = UDim2.new(1, -20, 0, 8)
sliderBar.Position = UDim2.new(0, 10, 0.5, -4)
sliderBar.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
sliderBar.BorderSizePixel = 0

local slider = Instance.new("Frame", sliderBar)
slider.Size = UDim2.new(0, 10, 0, 20)
slider.Position = UDim2.new(0, 0, -0.5, 0)
slider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
slider.BorderSizePixel = 0

local speedLabel = Instance.new("TextLabel", sliderFrame)
speedLabel.Size = UDim2.new(1, 0, 0, 20)
speedLabel.Position = UDim2.new(0, 0, 1, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Скорость: 2.5"
speedLabel.TextColor3 = Color3.new(1, 1, 1)
speedLabel.Font = Enum.Font.SourceSansBold
speedLabel.TextSize = 18

local speedEnabled = false
local jumpEnabled = false
local minSpeed = 1
local maxSpeed = 30
local speed = 2.5

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

UIS.JumpRequest:Connect(function()
	if jumpEnabled and lp.Character and lp.Character:FindFirstChildOfClass("Humanoid") then
		lp.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

button.MouseButton1Click:Connect(function()
	speedEnabled = not speedEnabled
	button.Text = speedEnabled and "⛔ Выключить быстрый бег" or "⚡ Включить быстрый бег"
end)

jumpBtn.MouseButton1Click:Connect(function()
	jumpEnabled = not jumpEnabled
	jumpBtn.Text = jumpEnabled and "⛔ Выключить бесконечный прыжок" or "🟢 Включить бесконечный прыжок"
end)

closeBtn.MouseButton1Click:Connect(function()
	gui:Destroy()
	speedEnabled = false
	jumpEnabled = false
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
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- Папка для ESP в PlayerGui
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "PlayerESP"
ESPFolder.Parent = player:WaitForChild("PlayerGui")

local espPlayers = {}
local espEnabled = false -- по умолчанию ESP выключен

-- Функция создания ESP
local function createESPForCharacter(char)
    if not char then return end
    if espPlayers[char] then return end

    local highlight = Instance.new("Highlight")
    highlight.Adornee = char
    highlight.FillColor = Color3.fromRGB(0, 255, 0)
    highlight.OutlineColor = Color3.fromRGB(0, 200, 0)
    highlight.Parent = ESPFolder

    local head = char:FindFirstChild("Head")
    local billboard
    if head then
        billboard = Instance.new("BillboardGui")
        billboard.Adornee = head
        billboard.Size = UDim2.new(0, 100, 0, 40)
        billboard.StudsOffset = Vector3.new(0, 2, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = ESPFolder

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

-- Удаление ESP для персонажа
local function removeESPForCharacter(char)
    if espPlayers[char] then
        if espPlayers[char].Highlight then
            espPlayers[char].Highlight:Destroy()
        end
        if espPlayers[char].Billboard then
            espPlayers[char].Billboard:Destroy()
        end
        espPlayers[char] = nil
    end
end

-- Включение ESP для всех игроков (кроме себя)
local function enableESP()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            createESPForCharacter(plr.Character)
        end
    end
end

-- Выключение ESP для всех
local function disableESP()
    for char, _ in pairs(espPlayers) do
        removeESPForCharacter(char)
    end
end

-- Создаем GUI с кнопкой вкл/выкл ESP
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ESPToggleGui"
screenGui.Parent = player:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 120, 0, 40)
button.Position = UDim2.new(0, 10, 0, 10)
button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
button.TextColor3 = Color3.fromRGB(0, 255, 0)
button.Font = Enum.Font.SourceSansBold
button.TextScaled = true
button.Text = "ESP ВЫКЛ"
button.Parent = screenGui

button.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    if espEnabled then
        enableESP()
        button.Text = "ESP ВКЛ"
        button.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        disableESP()
        button.Text = "ESP ВЫКЛ"
        button.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

-- Подключаем события игроков для динамического обновления ESP
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        if espEnabled and plr ~= player then
            createESPForCharacter(char)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(plr)
    if plr.Character then
        removeESPForCharacter(plr.Character)
    end
end)

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterRemoving:Connect(function(char)
        removeESPForCharacter(char)
    end)
end)

RunService.Heartbeat:Connect(function()
    for char, _ in pairs(espPlayers) do
        if not char or not char.Parent then
            removeESPForCharacter(char)
        end
    end
end)
