local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local tweenService = game:GetService("TweenService")
local userInputService = game:GetService("UserInputService")

-- Переменные состояния
local espEnabled = false
local espObjects = {} -- Сюда будем сохранять созданные BillboardGui
local menuVisible = true
local enemiesFolder = workspace:WaitForChild("Enemies")

-- Ждем загрузки персонажа
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Создаем основной GUI
local gui = Instance.new("ScreenGui")
gui.Name = "ESPMenu"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- ========== МЕНЮ ==========
-- Основной фрейм меню
local menuFrame = Instance.new("Frame")
menuFrame.Name = "MainMenu"
menuFrame.Size = UDim2.new(0, 300, 0, 200)
menuFrame.Position = UDim2.new(0.5, -150, 0.5, -100) -- По центру экрана
menuFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
menuFrame.Parent = gui
menuFrame.Active = true
menuFrame.Draggable = false -- Будем делать перетаскивание вручную

-- A. Градиент
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 60)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(60, 40, 80)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 40, 100))
})
gradient.Parent = menuFrame

-- B. Закругленные углы
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = menuFrame

-- Верхняя полоса для перетаскивания
local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 30)
topBar.Position = UDim2.new(0, 0, 0, 0)
topBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
topBar.BackgroundTransparency = 0.5
topBar.Parent = menuFrame

local topBarCorner = Instance.new("UICorner")
topBarCorner.CornerRadius = UDim.new(0, 12)
topBarCorner.Parent = topBar

-- Заголовок
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "ESP Controls"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = topBar

-- Кнопка закрытия (X)
local closeButton = Instance.new("ImageButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 20, 0, 20)
closeButton.Position = UDim2.new(1, -25, 0, 5)
closeButton.BackgroundTransparency = 1
closeButton.Image = "rbxassetid://3926305904" -- Иконка X
closeButton.ImageColor3 = Color3.fromRGB(255, 100, 100)
closeButton.Parent = topBar

-- Кнопка ESP
local espButton = Instance.new("TextButton")
espButton.Name = "ESPButton"
espButton.Size = UDim2.new(0.8, 0, 0, 40)
espButton.Position = UDim2.new(0.1, 0, 0.3, 0)
espButton.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
espButton.Text = "Включить ESP"
espButton.TextColor3 = Color3.fromRGB(255, 255, 255)
espButton.Font = Enum.Font.Gotham
espButton.TextSize = 16
espButton.Parent = menuFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = espButton

local buttonGradient = Instance.new("UIGradient")
buttonGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 70, 90)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 70))
})
buttonGradient.Parent = espButton

-- Статус ESP
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(0.8, 0, 0, 30)
statusLabel.Position = UDim2.new(0.1, 0, 0.6, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "ESP: Выключен"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 14
statusLabel.Parent = menuFrame

-- ========== КНОПКА ОТКРЫТИЯ (маленькая иконка) ==========
local openButton = Instance.new("ImageButton")
openButton.Name = "OpenButton"
openButton.Size = UDim2.new(0, 50, 0, 50)
openButton.Position = UDim2.new(0, 20, 0.9, -70) -- В левом нижнем углу
openButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
openButton.BackgroundTransparency = 0.3
openButton.Image = "rbxassetid://3926307979" -- Иконка меню
openButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
openButton.Parent = gui
openButton.Visible = false -- Скрыта, потому что меню открыто

local openButtonCorner = Instance.new("UICorner")
openButtonCorner.CornerRadius = UDim.new(1, 0) -- Круглая
openButtonCorner.Parent = openButton

-- ========== ФУНКЦИИ ESP ==========
-- Функция создания ESP для одного врага
local function createESP(enemy)
	if not espEnabled then return end
	
	local enemyRoot = enemy:FindFirstChild("HumanoidRootPart")
	if not enemyRoot then return end
	if enemy:FindFirstChild("ESP_Gui") then return end

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "ESP_Gui"
	billboard.Adornee = enemyRoot
	billboard.Size = UDim2.new(0, 200, 0, 50)
	billboard.StudsOffset = Vector3.new(0, 3, 0)
	billboard.AlwaysOnTop = true

	local label = Instance.new("TextLabel")
	label.Name = "ESP_Label"
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.new(1, 0, 0)
	label.TextStrokeTransparency = 0.3
	label.Font = Enum.Font.SourceSansBold
	label.TextSize = 18
	label.Text = enemy.Name .. "\n0m"

	label.Parent = billboard
	billboard.Parent = enemy
	
	-- Сохраняем в таблицу для последующего удаления
	table.insert(espObjects, billboard)
end

-- Функция очистки ESP
local function clearESP()
	for _, obj in ipairs(espObjects) do
		if obj and obj.Parent then
			obj:Destroy()
		end
	end
	espObjects = {}
end

-- Функция включения/выключения ESP
local function toggleESP()
	espEnabled = not espEnabled
	
	if espEnabled then
		espButton.Text = "Выключить ESP"
		statusLabel.Text = "ESP: Включен"
		statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
		
		-- Создаем ESP для всех существующих врагов
		for _, enemy in ipairs(enemiesFolder:GetChildren()) do
			task.wait(0.05) -- Небольшая задержка, чтобы не нагружать
			createESP(enemy)
		end
		
		-- Запускаем цикл обновления дистанции
		coroutine.wrap(function()
			while espEnabled do
				task.wait(0.1)
				
				-- Проверяем персонажа
				if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
					character = player.CharacterAdded:Wait()
					rootPart = character:WaitForChild("HumanoidRootPart")
				end
				
				-- Обновляем дистанцию для всех ESP объектов
				for _, enemy in ipairs(enemiesFolder:GetChildren()) do
					local enemyRoot = enemy:FindFirstChild("HumanoidRootPart")
					local billboard = enemy:FindFirstChild("ESP_Gui")
					
					if enemyRoot and billboard then
						local label = billboard:FindFirstChild("ESP_Label")
						if label then
							local dist = (enemyRoot.Position - rootPart.Position).Magnitude
							dist = math.floor(dist)
							label.Text = enemy.Name .. "\n" .. tostring(dist) .. "m"
						end
					end
				end
			end
		end)()
		
	else
		espButton.Text = "Включить ESP"
		statusLabel.Text = "ESP: Выключен"
		statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
		clearESP()
	end
end

-- Функция перетаскивания меню
do
	local dragging = false
	local dragStart = nil
	local startPos = nil
	
	topBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = menuFrame.Position
		end
	end)
	
	userInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			menuFrame.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)
	
	userInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
end

-- Функция открытия/закрытия меню с анимацией
local function toggleMenu()
	menuVisible = not menuVisible
	
	local targetTransparency = menuVisible and 0 or 1
	local targetVisible = not menuVisible
	
	local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	
	if menuVisible then
		-- Показываем меню
		menuFrame.Visible = true
		openButton.Visible = false
		tweenService:Create(menuFrame, tweenInfo, {BackgroundTransparency = 0}):Play()
		tweenService:Create(topBar, tweenInfo, {BackgroundTransparency = 0.5}):Play()
	else
		-- Скрываем меню
		tweenService:Create(menuFrame, tweenInfo, {BackgroundTransparency = 1}):Play()
		tweenService:Create(topBar, tweenInfo, {BackgroundTransparency = 1}):Play()
		task.wait(0.2)
		menuFrame.Visible = false
		openButton.Visible = true
	end
end

-- ========== НАСТРОЙКА СОБЫТИЙ ==========
-- Кнопка закрытия
closeButton.MouseButton1Click:Connect(function()
	toggleMenu()
end)

-- Кнопка открытия
openButton.MouseButton1Click:Connect(function()
	toggleMenu()
end)

-- Кнопка ESP
espButton.MouseButton1Click:Connect(function()
	toggleESP()
end)

-- Следим за новыми врагами
enemiesFolder.ChildAdded:Connect(function(enemy)
	task.wait(0.1)
	createESP(enemy)
end)

-- Анимации кнопок
espButton.MouseEnter:Connect(function()
	tweenService:Create(espButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(70, 70, 100)}):Play()
end)

espButton.MouseLeave:Connect(function()
	tweenService:Create(espButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(50, 50, 70)}):Play()
end)

closeButton.MouseEnter:Connect(function()
	tweenService:Create(closeButton, TweenInfo.new(0.1), {ImageColor3 = Color3.fromRGB(255, 50, 50)}):Play()
end)

closeButton.MouseLeave:Connect(function()
	tweenService:Create(closeButton, TweenInfo.new(0.1), {ImageColor3 = Color3.fromRGB(255, 100, 100)}):Play()
end)

openButton.MouseEnter:Connect(function()
	tweenService:Create(openButton, TweenInfo.new(0.1), {BackgroundTransparency = 0.5}):Play()
end)

openButton.MouseLeave:Connect(function()
	tweenService:Create(openButton, TweenInfo.new(0.1), {BackgroundTransparency = 0.3}):Play()
end)

print("ESP Menu загружен! Нажми на кнопку X чтобы закрыть меню.")
