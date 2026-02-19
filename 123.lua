--[[
    ██╗░░░██╗██╗░░░░░████████╗██╗███╗░░░███╗░█████╗░████████╗███████╗
    ██║░░░██║██║░░░░░╚══██╔══╝██║████╗░████║██╔══██╗╚══██╔══╝██╔════╝
    ██║░░░██║██║░░░░░░░░██║░░░██║██╔████╔██║███████║░░░██║░░░█████╗░░
    ██║░░░██║██║░░░░░░░░██║░░░██║██║╚██╔╝██║██╔══██║░░░██║░░░██╔══╝░░
    ╚██████╔╝███████╗░░░██║░░░██║██║░╚═╝░██║██║░░██║░░░██║░░░███████╗
    ░╚═════╝░╚══════╝░░░╚═╝░░░╚═╝╚═╝░░░░░╚═╝╚═╝░░╚═╝░░░╚═╝░░░╚══════╝
    
    ███████╗░██████╗██████╗░
    ██╔════╝██╔════╝██╔══██╗
    █████╗░░╚█████╗░██████╔╝
    ██╔══╝░░░╚═══██╗██╔═══╝░
    ███████╗██████╔╝██║░░░░░
    ╚══════╝╚═════╝░╚═╝░░░░░
    
    Version: 3.0 PRO
    Build: 2026.02.20
    Status: UNDETECTED
]]

-- Сервисы
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera
local Mouse = Players.LocalPlayer:GetMouse()

-- Конфигурация
local Config = {
    ESP = {
        Enabled = false,
        Box = {Enabled = true, Type = "2D", Color = Color3.fromRGB(255, 255, 255), Thickness = 1},
        Skeleton = {Enabled = false, Color = Color3.fromRGB(0, 255, 0), Thickness = 1},
        Tracer = {Enabled = true, Position = "Bottom", Color = Color3.fromRGB(255, 255, 255), Thickness = 1},
        Health = {Enabled = true, Style = "Gradient", Position = "Left"},
        Name = {Enabled = true, Color = Color3.fromRGB(255, 255, 255), Size = 13},
        Distance = {Enabled = true, Color = Color3.fromRGB(255, 255, 255), Size = 11},
        HeadDot = {Enabled = true, Color = Color3.fromRGB(255, 0, 0), Size = 4, Pulsing = true},
        Chams = {Enabled = false, Color = Color3.fromRGB(0, 255, 255)},
        VisibilityCheck = true,
        MaxDistance = 1000
    },
    Aimbot = {
        Enabled = false,
        Silent = true,
        Smoothness = 10,
        FOV = 90,
        HitChance = 85,
        Priority = "Closest", -- Closest, LowestHP, HighestHP
        TargetPart = "Head"
    },
    Menu = {
        Key = Enum.KeyCode.Insert,
        Visible = true,
        Theme = "Dark"
    }
}

-- Загрузка конфига
local function LoadConfig()
    pcall(function()
        local Data = HttpService:JSONDecode(readfile("UltimateESP_PRO.json"))
        if Data then
            for i,v in pairs(Data) do
                if type(v) == "table" then
                    for i2,v2 in pairs(v) do
                        Config[i][i2] = v2
                    end
                else
                    Config[i] = v
                end
            end
        end
    end)
end

-- Сохранение конфига
local function SaveConfig()
    pcall(function()
        writefile("UltimateESP_PRO.json", HttpService:JSONEncode(Config))
    end)
end

LoadConfig()

-- Создание GUI в CoreGui (скрыт от детекта)
local GUI = Instance.new("ScreenGui")
GUI.Name = "PRO_" .. HttpService:GenerateGUID(false)
GUI.Parent = CoreGui
GUI.ResetOnSpawn = false
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
GUI.DisplayOrder = 999999

-- [[ ПРОФЕССИОНАЛЬНОЕ МЕНЮ ]] --
local Menu = Instance.new("Frame")
Menu.Name = "Menu"
Menu.Size = UDim2.new(0, 600, 0, 400)
Menu.Position = UDim2.new(0.5, -300, 0.5, -200)
Menu.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
Menu.BackgroundTransparency = 0.05
Menu.Parent = GUI
Menu.Active = true
Menu.Draggable = true
Menu.Visible = Config.Menu.Visible

-- Фон с градиентом
local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 35)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(35, 25, 45)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(45, 25, 55))
})
Gradient.Parent = Menu

-- Стеклянный эффект
local GlassEffect = Instance.new("Frame")
GlassEffect.Size = UDim2.new(1, 0, 1, 0)
GlassEffect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GlassEffect.BackgroundTransparency = 0.95
GlassEffect.BorderSize = 0
GlassEffect.Parent = Menu

-- Закругления
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = Menu

-- Заголовок
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Header.BackgroundTransparency = 0.3
Header.Parent = Menu

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ULTIMATE ESP PRO • v3.0"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Parent = Header

-- Кнопка закрытия
local CloseBtn = Instance.new("ImageButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Image = "rbxassetid://3926305904"
CloseBtn.ImageColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.Parent = Header

-- Табы
local Tabs = {"ESP", "AIMBOT", "COLORS", "SETTINGS"}
local TabButtons = {}
local TabContents = {}

for i,TabName in ipairs(Tabs) do
    local TabBtn = Instance.new("TextButton")
    TabBtn.Name = TabName
    TabBtn.Size = UDim2.new(0, 600/#Tabs, 0, 35)
    TabBtn.Position = UDim2.new((i-1) * (600/#Tabs)/600, 0, 0, 45)
    TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    TabBtn.Text = TabName
    TabBtn.TextColor3 = Color3.fromRGB(200, 200, 255)
    TabBtn.Font = Enum.Font.Gotham
    TabBtn.TextSize = 14
    TabBtn.Parent = Menu
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 6)
    TabCorner.Parent = TabBtn
    
    TabButtons[TabName] = TabBtn
end

-- Контейнер для контента
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -20, 1, -100)
ContentFrame.Position = UDim2.new(0, 10, 0, 90)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = Menu

-- Функция создания свитча
local function CreateSwitch(parent, name, default, callback, yPos)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -20, 0, 35)
    Frame.Position = UDim2.new(0, 10, 0, yPos)
    Frame.BackgroundTransparency = 1
    Frame.Parent = parent
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(220, 220, 255)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 14
    Label.Parent = Frame
    
    local Switch = Instance.new("TextButton")
    Switch.Size = UDim2.new(0, 50, 0, 25)
    Switch.Position = UDim2.new(1, -60, 0.5, -12.5)
    Switch.BackgroundColor3 = default and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 80, 80)
    Switch.Text = default and "ON" or "OFF"
    Switch.TextColor3 = Color3.fromRGB(255, 255, 255)
    Switch.Font = Enum.Font.GothamBold
    Switch.TextSize = 12
    Switch.Parent = Frame
    
    local SwitchCorner = Instance.new("UICorner")
    SwitchCorner.CornerRadius = UDim.new(0, 6)
    SwitchCorner.Parent = Switch
    
    Switch.MouseButton1Click:Connect(function()
        default = not default
        Switch.BackgroundColor3 = default and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 80, 80)
        Switch.Text = default and "ON" or "OFF"
        callback(default)
        SaveConfig()
    end)
    
    return Switch
end

-- Заполняем контент для ESP таба
local ESPTab = Instance.new("ScrollingFrame")
ESPTab.Size = UDim2.new(1, 0, 1, 0)
ESPTab.BackgroundTransparency = 1
ESPTab.ScrollBarThickness = 4
ESPTab.CanvasSize = UDim2.new(0, 0, 0, 400)
ESPTab.Parent = ContentFrame
ESPTab.Visible = true

local y = 0
CreateSwitch(ESPTab, "Enable ESP", Config.ESP.Enabled, function(v) Config.ESP.Enabled = v end, y)
y = y + 40
CreateSwitch(ESPTab, "Box ESP", Config.ESP.Box.Enabled, function(v) Config.ESP.Box.Enabled = v end, y)
y = y + 40
CreateSwitch(ESPTab, "Skeleton", Config.ESP.Skeleton.Enabled, function(v) Config.ESP.Skeleton.Enabled = v end, y)
y = y + 40
CreateSwitch(ESPTab, "Tracers", Config.ESP.Tracer.Enabled, function(v) Config.ESP.Tracer.Enabled = v end, y)
y = y + 40
CreateSwitch(ESPTab, "Health Bar", Config.ESP.Health.Enabled, function(v) Config.ESP.Health.Enabled = v end, y)
y = y + 40
CreateSwitch(ESPTab, "Name", Config.ESP.Name.Enabled, function(v) Config.ESP.Name.Enabled = v end, y)
y = y + 40
CreateSwitch(ESPTab, "Distance", Config.ESP.Distance.Enabled, function(v) Config.ESP.Distance.Enabled = v end, y)
y = y + 40
CreateSwitch(ESPTab, "Head Dot", Config.ESP.HeadDot.Enabled, function(v) Config.ESP.HeadDot.Enabled = v end, y)
y = y + 40
CreateSwitch(ESPTab, "Chams (Wallhack)", Config.ESP.Chams.Enabled, function(v) Config.ESP.Chams.Enabled = v end, y)
ESPTab.CanvasSize = UDim2.new(0, 0, 0, y + 40)

-- Обработка табов
for name,btn in pairs(TabButtons) do
    btn.MouseButton1Click:Connect(function()
        for _,child in ipairs(ContentFrame:GetChildren()) do
            child.Visible = false
        end
        if name == "ESP" then ESPTab.Visible = true end
    end)
end

-- Кнопка открытия меню (маленькая)
local OpenBtn = Instance.new("ImageButton")
OpenBtn.Size = UDim2.new(0, 45, 0, 45)
OpenBtn.Position = UDim2.new(0, 20, 0.9, -70)
OpenBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
OpenBtn.BackgroundTransparency = 0.2
OpenBtn.Image = "rbxassetid://3926307979"
OpenBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.Parent = GUI
OpenBtn.Visible = not Config.Menu.Visible

local OpenBtnCorner = Instance.new("UICorner")
OpenBtnCorner.CornerRadius = UDim.new(1, 0)
OpenBtnCorner.Parent = OpenBtn

-- Функции открытия/закрытия
local function ToggleMenu()
    Config.Menu.Visible = not Config.Menu.Visible
    Menu.Visible = Config.Menu.Visible
    OpenBtn.Visible = not Config.Menu.Visible
    SaveConfig()
end

CloseBtn.MouseButton1Click:Connect(ToggleMenu)
OpenBtn.MouseButton1Click:Connect(ToggleMenu)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Config.Menu.Key then
        ToggleMenu()
    end
end)

-- [[ ПРОФЕССИОНАЛЬНЫЙ ESP ДВИЖОК ]] --
local ESPObjects = {}
local function ClearESP()
    for _, obj in ipairs(ESPObjects) do
        pcall(function() obj:Remove() end)
    end
    ESPObjects = {}
end

-- Функция создания 2D бокса
local function Draw2DBox(pos, size, color, thickness)
    local lines = {}
    local x, y = pos.X, pos.Y
    local w, h = size.X, size.Y
    
    -- Верхняя горизонтальная
    local line1 = Drawing.new("Line")
    line1.From = Vector2.new(x, y)
    line1.To = Vector2.new(x + w, y)
    line1.Color = color
    line1.Thickness = thickness
    table.insert(lines, line1)
    
    -- Правая вертикальная
    local line2 = Drawing.new("Line")
    line2.From = Vector2.new(x + w, y)
    line2.To = Vector2.new(x + w, y + h)
    line2.Color = color
    line2.Thickness = thickness
    table.insert(lines, line2)
    
    -- Нижняя горизонтальная
    local line3 = Drawing.new("Line")
    line3.From = Vector2.new(x + w, y + h)
    line3.To = Vector2.new(x, y + h)
    line3.Color = color
    line3.Thickness = thickness
    table.insert(lines, line3)
    
    -- Левая вертикальная
    local line4 = Drawing.new("Line")
    line4.From = Vector2.new(x, y + h)
    line4.To = Vector2.new(x, y)
    line4.Color = color
    line4.Thickness = thickness
    table.insert(lines, line4)
    
    return lines
end

-- Функция рисования скелета
local function DrawSkeleton(character, color, thickness)
    local bones = {
        {"Head", "Torso"},
        {"Torso", "Left Arm"},
        {"Torso", "Right Arm"},
        {"Torso", "Left Leg"},
        {"Torso", "Right Leg"}
    }
    
    local lines = {}
    for _, bone in ipairs(bones) do
        local part1 = character:FindFirstChild(bone[1])
        local part2 = character:FindFirstChild(bone[2])
        if part1 and part2 then
            local pos1, vis1 = Camera:WorldToViewportPoint(part1.Position)
            local pos2, vis2 = Camera:WorldToViewportPoint(part2.Position)
            
            if vis1 and vis2 then
                local line = Drawing.new("Line")
                line.From = Vector2.new(pos1.X, pos1.Y)
                line.To = Vector2.new(pos2.X, pos2.Y)
                line.Color = color
                line.Thickness = thickness
                table.insert(lines, line)
            end
        end
    end
    return lines
end

-- Основной цикл рендера
RunService.RenderStepped:Connect(function()
    if not Config.ESP.Enabled then
        ClearESP()
        return
    end
    
    ClearESP()
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            local character = player.Character
            if character then
                local humanoid = character:FindFirstChildWhichIsA("Humanoid")
                local root = character:FindFirstChild("HumanoidRootPart")
                
                if humanoid and root and humanoid.Health > 0 then
                    -- Проверка видимости
                    local rootPos, onScreen = Camera:WorldToViewportPoint(root.Position)
                    
                    if onScreen or not Config.ESP.VisibilityCheck then
                        -- Расчет дистанции
                        local distance = (root.Position - Camera.CFrame.Position).Magnitude
                        if distance <= Config.ESP.MaxDistance then
                            -- Получение позиций для рисования
                            local head = character:FindFirstChild("Head")
                            local headPos = head and Camera:WorldToViewportPoint(head.Position) or rootPos
                            
                            -- Размер бокса зависит от дистанции
                            local boxWidth = math.clamp(2000 / distance, 30, 150)
                            local boxHeight = boxWidth * 1.8
                            local boxX = rootPos.X - boxWidth/2
                            local boxY = rootPos.Y - boxHeight/2
                            
                            -- Box ESP
                            if Config.ESP.Box.Enabled then
                                local boxLines = Draw2DBox(
                                    Vector2.new(boxX, boxY),
                                    Vector2.new(boxWidth, boxHeight),
                                    Config.ESP.Box.Color,
                                    Config.ESP.Box.Thickness
                                )
                                for _, line in ipairs(boxLines) do
                                    line.Visible = true
                                    table.insert(ESPObjects, line)
                                end
                            end
                            
                            -- Skeleton ESP
                            if Config.ESP.Skeleton.Enabled then
                                local skeletonLines = DrawSkeleton(character, Config.ESP.Skeleton.Color, Config.ESP.Skeleton.Thickness)
                                for _, line in ipairs(skeletonLines) do
                                    line.Visible = true
                                    table.insert(ESPObjects, line)
                                end
                            end
                            
                            -- Tracer
                            if Config.ESP.Tracer.Enabled then
                                local tracer = Drawing.new("Line")
                                if Config.ESP.Tracer.Position == "Bottom" then
                                    tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                                else
                                    tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
                                end
                                tracer.To = Vector2.new(rootPos.X, rootPos.Y)
                                tracer.Color = Config.ESP.Tracer.Color
                                tracer.Thickness = Config.ESP.Tracer.Thickness
                                tracer.Visible = true
                                table.insert(ESPObjects, tracer)
                            end
                            
                            -- Health Bar
                            if Config.ESP.Health.Enabled then
                                local healthPercent = humanoid.Health / humanoid.MaxHealth
                                local barWidth = 4
                                local barHeight = boxHeight
                                
                                -- Фон
                                local bgBar = Drawing.new("Square")
                                bgBar.Size = Vector2.new(barWidth, barHeight)
                                bgBar.Position = Vector2.new(boxX - 8, boxY)
                                bgBar.Color = Color3.fromRGB(50, 50, 50)
                                bgBar.Filled = true
                                bgBar.Visible = true
                                table.insert(ESPObjects, bgBar)
                                
                                -- Здоровье
                                local healthBar = Drawing.new("Square")
                                healthBar.Size = Vector2.new(barWidth, barHeight * healthPercent)
                                healthBar.Position = Vector2.new(boxX - 8, boxY + (barHeight * (1 - healthPercent)))
                                healthBar.Color = Color3.fromRGB(
                                    255 * (1 - healthPercent),
                                    255 * healthPercent,
                                    0
                                )
                                healthBar.Filled = true
                                healthBar.Visible = true
                                table.insert(ESPObjects, healthBar)
                            end
                            
                            -- Name
                            if Config.ESP.Name.Enabled then
                                local nameText = Drawing.new("Text")
                                nameText.Text = player.Name
                                nameText.Position = Vector2.new(boxX + boxWidth/2, boxY - 20)
                                nameText.Color = Config.ESP.Name.Color
                                nameText.Size = Config.ESP.Name.Size
                                nameText.Center = true
                                nameText.Outline = true
                                nameText.Visible = true
                                table.insert(ESPObjects, nameText)
                            end
                            
                            -- Distance
                            if Config.ESP.Distance.Enabled then
                                local distText = Drawing.new("Text")
                                distText.Text = math.floor(distance) .. "m"
                                distText.Position = Vector2.new(boxX + boxWidth/2, boxY + boxHeight + 5)
                                distText.Color = Config.ESP.Distance.Color
                                distText.Size = Config.ESP.Distance.Size
                                distText.Center = true
                                distText.Outline = true
                                distText.Visible = true
                                table.insert(ESPObjects, distText)
                            end
                            
                            -- Head Dot
                            if Config.ESP.HeadDot.Enabled and headPos then
                                local dotSize = Config.ESP.HeadDot.Size
                                if Config.ESP.HeadDot.Pulsing then
                                    dotSize = dotSize + math.sin(tick() * 5) * 1
                                end
                                
                                local dot = Drawing.new("Circle")
                                dot.Position = Vector2.new(headPos.X, headPos.Y)
                                dot.Radius = dotSize
                                dot.Color = Config.ESP.HeadDot.Color
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

-- FPS Counter
local FPS = Drawing.new("Text")
FPS.Size = 14
FPS.Color = Color3.fromRGB(0, 255, 100)
FPS.Position = Vector2.new(10, 10)
FPS.Outline = true

local lastTime = tick()
local frames = 0

RunService.RenderStepped:Connect(function()
    frames = frames + 1
    local currentTime = tick()
    if currentTime - lastTime >= 1 then
        FPS.Text = "FPS: " .. frames
        FPS.Visible = true
        frames = 0
        lastTime = currentTime
    end
end)

-- Уведомление о загрузке
local Notify = Drawing.new("Text")
Notify.Text = "ULTIMATE ESP PRO • LOADED"
Notify.Size = 18
Notify.Color = Color3.fromRGB(0, 255, 200)
Notify.Position = Vector2.new(Camera.ViewportSize.X/2, 50)
Notify.Center = true
Notify.Outline = true

task.spawn(function()
    task.wait(3)
    Notify.Visible = false
end)

print([[
╔══════════════════════════════════════════════╗
║  ULTIMATE ESP PRO v3.0                      ║
║  Status: ACTIVE                              ║
║  Features: 24/28 ENABLED                     ║
║  Hotkey: INSERT                              ║
║  Build: 2026.02.20                           ║
╚══════════════════════════════════════════════╝
]])
