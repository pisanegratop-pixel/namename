--[[
██████╗ ███████╗██████╗ ██╗   ██╗ ██████╗ 
██╔══██╗██╔════╝██╔══██╗██║   ██║██╔════╝ 
██████╔╝█████╗  ██████╔╝██║   ██║██║  ███╗
██╔══██╗██╔══╝  ██╔══██╗██║   ██║██║   ██║
██████╔╝███████╗██║  ██║╚██████╔╝╚██████╔╝
╚═════╝ ╚══════╝╚═╝  ╚═╝ ╚═════╝  ╚═════╝ 
                                          
███████╗███████╗██████╗                     
██╔════╝██╔════╝██╔══██╗                    
███████╗█████╗  ██████╔╝                    
╚════██║██╔══╝  ██╔═══╝                     
███████║███████╗██║                         
╚══════╝╚══════╝╚═╝                         
--]]

print("🚀 Запуск ESP меню...")

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local tweenService = game:GetService("TweenService")
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")

-- Переменные состояния
local espEnabled = false
local espObjects = {}
local menuVisible = true
local enemiesFolder = nil

-- Ждем загрузки игрока
repeat task.wait() until player and player.Character
print("✅ Игрок загружен:", player.Name)

-- Функция безопасного получения персонажа
local function getCharacter()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        return player.Character, player.Character.HumanoidRootPart
    else
        local char = player.CharacterAdded:Wait(5)
        if char then
            local root = char:WaitForChild("HumanoidRootPart", 5)
            return char, root
        end
    end
    return nil, nil
end

local character, rootPart = getCharacter()
if not character or not rootPart then
    warn("❌ Не удалось загрузить персонажа!")
    character = player.Character or workspace:FindFirstChildWhichIsA("Model")
    rootPart = character and character:FindFirstChild("HumanoidRootPart")
end

print("✅ Персонаж загружен:", character and character.Name)

-- Ищем или создаем папку с врагами
enemiesFolder = workspace:FindFirstChild("Enemies")
if not enemiesFolder then
    print("📁 Папка Enemies не найдена, создаем...")
    enemiesFolder = Instance.new("Folder")
    enemiesFolder.Name = "Enemies"
    enemiesFolder.Parent = workspace
    
    -- Для теста создадим несколько врагов если их нет
    task.wait(1)
    if #enemiesFolder:GetChildren() == 0 then
        print("👾 Создаю тестовых врагов для проверки...")
        local dummy = Instance.new("Model")
        dummy.Name = "TestEnemy"
        local part = Instance.new("Part")
        part.Name = "HumanoidRootPart"
        part.Size = Vector3.new(2, 2, 1)
        part.Position = Vector3.new(10, 5, 10)
        part.Anchored = true
        part.Parent = dummy
        local hum = Instance.new("Humanoid")
        hum.Parent = dummy
        dummy.Parent = enemiesFolder
        
        local dummy2 = dummy:Clone()
        dummy2.Name = "TestEnemy2"
        dummy2.Parent = enemiesFolder
        dummy2.HumanoidRootPart.Position = Vector3.new(-10, 5, 15)
    end
end
print("✅ Папка врагов готова, найдено объектов:", #enemiesFolder:GetChildren())

-- Удаляем старый GUI если есть
local oldGui = player.PlayerGui:FindFirstChild("ESPMenu")
if oldGui then
    oldGui:Destroy()
    task.wait(0.1)
end

-- Создаем основной GUI
local gui = Instance.new("ScreenGui")
gui.Name = "ESPMenu"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")
gui.DisplayOrder = 999 -- Поверх всего
print("✅ GUI создан")

-- ========== МЕНЮ ==========
local menuFrame = Instance.new("Frame")
menuFrame.Name = "MainMenu"
menuFrame.Size = UDim2.new(0, 300, 0, 220)
menuFrame.Position = UDim2.new(0.5, -150, 0.5, -110)
menuFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
menuFrame.BackgroundTransparency = 0
menuFrame.Parent = gui
menuFrame.Active = true
menuFrame.Visible = true

-- Градиент
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 60)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(60, 40, 80)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 40, 100))
})
gradient.Parent = menuFrame

-- Закругленные углы
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = menuFrame

-- Верхняя полоса
local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 30)
topBar.Position = UDim2.new(0, 0, 0, 0)
topBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
topBar.BackgroundTransparency = 0.3
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

-- Кнопка закрытия
local closeButton = Instance.new("ImageButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 20, 0, 20)
closeButton.Position = UDim2.new(1, -25, 0, 5)
closeButton.BackgroundTransparency = 1
closeButton.Image = "rbxassetid://3926305904"
closeButton.ImageColor3 = Color3.fromRGB(255, 100, 100)
closeButton.Parent = topBar

-- Кнопка ESP
local espButton = Instance.new("TextButton")
espButton.Name = "ESPButton"
espButton.Size = UDim2.new(0.8, 0, 0, 40)
espButton.Position = UDim2.new(0.1, 0, 0.25, 0)
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

-- Статус
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(0.8, 0, 0, 30)
statusLabel.Position = UDim2.new(0.1, 0, 0.55, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "ESP: Выключен"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 14
statusLabel.Parent = menuFrame

-- Инфо о врагах
local enemyCountLabel = Instance.new("TextLabel")
enemyCountLabel.Name = "EnemyCountLabel"
enemyCountLabel.Size = UDim2.new(0.8, 0, 0, 30)
enemyCountLabel.Position = UDim2.new(0.1, 0, 0.7, 0)
enemyCountLabel.BackgroundTransparency = 1
enemyCountLabel.Text = "Врагов: " .. #enemiesFolder:GetChildren()
enemyCountLabel.TextColor3 = Color3.fromRGB(150, 150, 255)
enemyCountLabel.Font = Enum.Font.Gotham
enemyCountLabel.TextSize = 14
enemyCountLabel.Parent = menuFrame

-- Кнопка открытия
local openButton = Instance.new("ImageButton")
openButton.Name = "OpenButton"
openButton.Size = UDim2.new(0, 50, 0, 50)
openButton.Position = UDim2.new(0, 20, 0.9, -70)
openButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
openButton.BackgroundTransparency = 0.3
openButton.Image = "rbxassetid://3926307979"
openButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
openButton.Parent = gui
openButton.Visible = false

local openButtonCorner = Instance.new("UICorner")
openButtonCorner.CornerRadius = UDim.new(1, 0)
openButtonCorner.Parent = openButton

print("✅ Элементы меню созданы")

-- ========== ФУНКЦИИ ESP ==========
local function createESP(enemy)
    if not espEnabled then return end
    if not enemy or not enemy.Parent then return end
    
    local enemyRoot = enemy:FindFirstChild("HumanoidRootPart")
    if not enemyRoot then return end
    if enemy:FindFirstChild("ESP_Gui") then return end
    
    pcall(function()
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
        label.Text = enemy.Name .. "\n??м"
        
        label.Parent = billboard
        billboard.Parent = enemy
        
        table.insert(espObjects, billboard)
    end)
end

local function clearESP()
    for i, obj in ipairs(espObjects) do
        pcall(function()
            if obj and obj.Parent then
                obj:Destroy()
            end
        end)
    end
    espObjects = {}
end

local function toggleESP()
    espEnabled = not espEnabled
    
    if espEnabled then
        espButton.Text = "Выключить ESP"
        statusLabel.Text = "ESP: Включен"
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        
        -- Создаем ESP для всех врагов
        for _, enemy in ipairs(enemiesFolder:GetChildren()) do
            task.wait(0.05)
            createESP(enemy)
        end
        
        -- Запускаем цикл обновления
        coroutine.wrap(function()
            while espEnabled and runService.RenderStepped do
                task.wait(0.1)
                
                -- Обновляем персонажа если умер
                if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
                    local success, newChar = pcall(function()
                        return player.CharacterAdded:Wait(2)
                    end)
                    if success and newChar then
                        character = newChar
                        rootPart = character:WaitForChild("HumanoidRootPart", 2)
                    else
                        continue
                    end
                end
                
                if not rootPart then continue end
                
                -- Обновляем дистанцию
                for _, enemy in ipairs(enemiesFolder:GetChildren()) do
                    local enemyRoot = enemy:FindFirstChild("HumanoidRootPart")
                    local billboard = enemy:FindFirstChild("ESP_Gui")
                    
                    if enemyRoot and billboard then
                        local label = billboard:FindFirstChild("ESP_Label")
                        if label then
                            local dist = (enemyRoot.Position - rootPart.Position).Magnitude
                            dist = math.floor(dist)
                            label.Text = enemy.Name .. "\n" .. tostring(dist) .. "м"
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

-- Обновление счетчика врагов
coroutine.wrap(function()
    while true do
        task.wait(1)
        if enemyCountLabel and enemyCountLabel.Parent then
            enemyCountLabel.Text = "Врагов: " .. #enemiesFolder:GetChildren()
        end
    end
end)()

-- ========== ПЕРЕТАСКИВАНИЕ ==========
local dragging = false
local dragStart = nil
local startPos = nil

topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = menuFrame.Position
    end
end)

topBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

userInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        menuFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- ========== ОТКРЫТИЕ/ЗАКРЫТИЕ ==========
local function toggleMenu()
    menuVisible = not menuVisible
    
    if menuVisible then
        menuFrame.Visible = true
        openButton.Visible = false
        tweenService:Create(menuFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
        tweenService:Create(topBar, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
    else
        tweenService:Create(menuFrame, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
        tweenService:Create(topBar, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
        task.wait(0.2)
        menuFrame.Visible = false
        openButton.Visible = true
    end
end

-- ========== СОБЫТИЯ ==========
closeButton.MouseButton1Click:Connect(toggleMenu)
openButton.MouseButton1Click:Connect(toggleMenu)
espButton.MouseButton1Click:Connect(toggleESP)

-- Следим за новыми врагами
enemiesFolder.ChildAdded:Connect(function(enemy)
    task.wait(0.2)
    createESP(enemy)
end)

-- Анимации
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

print("🎯 ESP меню готово!")
print("📊 Статистика:")
print("   - Игрок:", player.Name)
print("   - Врагов:", #enemiesFolder:GetChildren())
print("   - Меню:", menuFrame and "создано")
print("   - Кнопки:", espButton and "готовы")

-- Тестовая кнопка для проверки
local testButton = Instance.new("TextButton")
testButton.Name = "TestButton"
testButton.Size = UDim2.new(0, 100, 0, 30)
testButton.Position = UDim2.new(0, 10, 0, 10)
testButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
testButton.Text = "ТЕСТ ESP"
testButton.TextColor3 = Color3.fromRGB(255, 255, 255)
testButton.Parent = gui
testButton.Visible = false -- Скрыта, можно включить для теста

testButton.MouseButton1Click:Connect(function()
    print("🔄 Тестовое включение ESP")
    if not espEnabled then
        toggleESP()
    end
end)

print("✅ Готово! Если ESP не работает, проверь:")
print("   1. Есть ли папка 'Enemies' в Workspace")
print("   2. Есть ли у врагов HumanoidRootPart")
print("   3. Открой меню и нажми кнопку ESP")
