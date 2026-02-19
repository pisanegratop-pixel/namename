-- Сервисы
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Ждем загрузки игрока
repeat wait() until LocalPlayer and LocalPlayer.Character

-- Настройки
local Settings = {
    ESP = {
        Enabled = false,
        Box = true,
        Tracer = true,
        Name = true,
        Distance = true,
        Health = true,
        HeadDot = true
    }
}

-- Создаем GUI в PlayerGui (точно работает)
local GUI = Instance.new("ScreenGui")
GUI.Name = "SimpleESP"
GUI.Parent = LocalPlayer:WaitForChild("PlayerGui")
GUI.ResetOnSpawn = false

-- Простое меню
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.BackgroundTransparency = 0.1
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = GUI
MainFrame.Visible = true

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Title.Text = "SIMPLE ESP"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Parent = MainFrame

-- Кнопка закрытия
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.Parent = Title

-- Кнопка включения ESP
local ESPBtn = Instance.new("TextButton")
ESPBtn.Size = UDim2.new(0.8, 0, 0, 40)
ESPBtn.Position = UDim2.new(0.1, 0, 0.3, 0)
ESPBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
ESPBtn.Text = "Включить ESP"
ESPBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPBtn.Font = Enum.Font.Gotham
ESPBtn.TextSize = 16
ESPBtn.Parent = MainFrame

-- Статус
local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(0.8, 0, 0, 30)
Status.Position = UDim2.new(0.1, 0, 0.6, 0)
Status.BackgroundTransparency = 1
Status.Text = "ESP: Выключен"
Status.TextColor3 = Color3.fromRGB(200, 200, 200)
Status.Font = Enum.Font.Gotham
Status.TextSize = 14
Status.Parent = MainFrame

-- Кнопка открытия (появляется когда меню закрыто)
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 20, 0.9, -70)
OpenBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
OpenBtn.Text = "ESP"
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 12
OpenBtn.Parent = GUI
OpenBtn.Visible = false

-- Функция открытия/закрытия
local function ToggleMenu()
    MainFrame.Visible = not MainFrame.Visible
    OpenBtn.Visible = not MainFrame.Visible
end

CloseBtn.MouseButton1Click:Connect(ToggleMenu)
OpenBtn.MouseButton1Click:Connect(ToggleMenu)

-- Горячая клавиша Insert
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Insert then
        ToggleMenu()
    end
end)

-- ESP переменные
local ESPEnabled = false
local ESPObjects = {}

-- Функция очистки ESP
local function ClearESP()
    for _, obj in ipairs(ESPObjects) do
        pcall(function() obj:Remove() end)
    end
    ESPObjects = {}
end

-- Функция включения ESP
ESPBtn.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    if ESPEnabled then
        ESPBtn.Text = "Выключить ESP"
        ESPBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        Status.Text = "ESP: Включен"
        Status.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        ESPBtn.Text = "Включить ESP"
        ESPBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        Status.Text = "ESP: Выключен"
        Status.TextColor3 = Color3.fromRGB(200, 200, 200)
        ClearESP()
    end
end)

-- Основной цикл ESP
RunService.RenderStepped:Connect(function()
    if not ESPEnabled then return end
    
    ClearESP()
    
    -- Проверяем персонажа игрока
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    
    -- Рисуем ESP для всех игроков
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            if char then
                local root = char:FindFirstChild("HumanoidRootPart")
                local humanoid = char:FindFirstChildWhichIsA("Humanoid")
                
                if root and humanoid and humanoid.Health > 0 then
                    -- Получаем позицию на экране
                    local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
                    
                    if onScreen then
                        -- Расстояние
                        local dist = (root.Position - myRoot.Position).Magnitude
                        
                        -- Размер бокса
                        local size = math.clamp(1000 / dist, 30, 100)
                        
                        -- Рисуем бокс (4 линии)
                        if Settings.ESP.Box then
                            -- Верхняя линия
                            local line1 = Drawing.new("Line")
                            line1.From = Vector2.new(pos.X - size, pos.Y - size)
                            line1.To = Vector2.new(pos.X + size, pos.Y - size)
                            line1.Color = Color3.fromRGB(255, 255, 255)
                            line1.Thickness = 1
                            line1.Visible = true
                            table.insert(ESPObjects, line1)
                            
                            -- Правая линия
                            local line2 = Drawing.new("Line")
                            line2.From = Vector2.new(pos.X + size, pos.Y - size)
                            line2.To = Vector2.new(pos.X + size, pos.Y + size)
                            line2.Color = Color3.fromRGB(255, 255, 255)
                            line2.Thickness = 1
                            line2.Visible = true
                            table.insert(ESPObjects, line2)
                            
                            -- Нижняя линия
                            local line3 = Drawing.new("Line")
                            line3.From = Vector2.new(pos.X + size, pos.Y + size)
                            line3.To = Vector2.new(pos.X - size, pos.Y + size)
                            line3.Color = Color3.fromRGB(255, 255, 255)
                            line3.Thickness = 1
                            line3.Visible = true
                            table.insert(ESPObjects, line3)
                            
                            -- Левая линия
                            local line4 = Drawing.new("Line")
                            line4.From = Vector2.new(pos.X - size, pos.Y + size)
                            line4.To = Vector2.new(pos.X - size, pos.Y - size)
                            line4.Color = Color3.fromRGB(255, 255, 255)
                            line4.Thickness = 1
                            line4.Visible = true
                            table.insert(ESPObjects, line4)
                        end
                        
                        -- Имя
                        if Settings.ESP.Name then
                            local nameText = Drawing.new("Text")
                            nameText.Text = player.Name
                            nameText.Position = Vector2.new(pos.X, pos.Y - size - 15)
                            nameText.Color = Color3.fromRGB(255, 255, 255)
                            nameText.Size = 13
                            nameText.Center = true
                            nameText.Outline = true
                            nameText.Visible = true
                            table.insert(ESPObjects, nameText)
                        end
                        
                        -- Дистанция
                        if Settings.ESP.Distance then
                            local distText = Drawing.new("Text")
                            distText.Text = math.floor(dist) .. "m"
                            distText.Position = Vector2.new(pos.X, pos.Y + size + 5)
                            distText.Color = Color3.fromRGB(255, 255, 255)
                            distText.Size = 11
                            distText.Center = true
                            distText.Outline = true
                            distText.Visible = true
                            table.insert(ESPObjects, distText)
                        end
                        
                        -- Tracer
                        if Settings.ESP.Tracer then
                            local tracer = Drawing.new("Line")
                            tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                            tracer.To = Vector2.new(pos.X, pos.Y)
                            tracer.Color = Color3.fromRGB(255, 255, 255)
                            tracer.Thickness = 1
                            tracer.Visible = true
                            table.insert(ESPObjects, tracer)
                        end
                        
                        -- Health Bar
                        if Settings.ESP.Health then
                            local healthPercent = humanoid.Health / humanoid.MaxHealth
                            
                            local bgBar = Drawing.new("Square")
                            bgBar.Size = Vector2.new(4, size * 2)
                            bgBar.Position = Vector2.new(pos.X - size - 8, pos.Y - size)
                            bgBar.Color = Color3.fromRGB(50, 50, 50)
                            bgBar.Filled = true
                            bgBar.Visible = true
                            table.insert(ESPObjects, bgBar)
                            
                            local healthBar = Drawing.new("Square")
                            healthBar.Size = Vector2.new(4, size * 2 * healthPercent)
                            healthBar.Position = Vector2.new(pos.X - size - 8, pos.Y + size - (size * 2 * healthPercent))
                            healthBar.Color = Color3.fromRGB(0, 255, 0)
                            healthBar.Filled = true
                            healthBar.Visible = true
                            table.insert(ESPObjects, healthBar)
                        end
                        
                        -- Head Dot
                        if Settings.ESP.HeadDot then
                            local head = char:FindFirstChild("Head")
                            if head then
                                local headPos, _ = Camera:WorldToViewportPoint(head.Position)
                                local dot = Drawing.new("Circle")
                                dot.Position = Vector2.new(headPos.X, headPos.Y)
                                dot.Radius = 4
                                dot.Color = Color3.fromRGB(255, 0, 0)
                                dot.Filled = true
                                dot.NumSides = 16
                                dot.Visible = true
                                table.insert(ESPObjects, dot)
                            end
                        end
                    end
                end
            end
        end
    end
end)

print("Simple ESP загружен! Нажми INSERT чтобы открыть меню")
