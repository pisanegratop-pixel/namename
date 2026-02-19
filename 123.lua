--[[
    ULTIMATE ESP MENU v2.0
    Полностью переработанная версия
]]

-- Сервисы
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local Camera = workspace.CurrentCamera

-- Переменные
local LocalPlayer = Players.LocalPlayer
local ESPEnabled = false
local ESPObjects = {}
local MenuVisible = true
local Settings = {
    Box = true,
    Tracer = true,
    Name = true,
    Distance = true,
    Health = true,
    HeadDot = true,
    BoxColor = Color3.fromRGB(255, 255, 255),
    TracerColor = Color3.fromRGB(255, 255, 255),
    NameColor = Color3.fromRGB(255, 255, 255),
    DistanceColor = Color3.fromRGB(255, 255, 255),
    HealthColor = Color3.fromRGB(0, 255, 0),
    DotColor = Color3.fromRGB(255, 0, 0)
}

-- Загрузка настроек
local function LoadSettings()
    pcall(function()
        local Data = HttpService:JSONDecode(readfile("ESPSettings.json"))
        if Data then
            for i,v in pairs(Data) do
                Settings[i] = v
            end
        end
    end)
end

-- Сохранение настроек
local function SaveSettings()
    pcall(function()
        writefile("ESPSettings.json", HttpService:JSONEncode(Settings))
    end)
end

LoadSettings()

-- Создание GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltimateESP"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = (CoreGui or Players.LocalPlayer:WaitForChild("PlayerGui"))

-- Главное меню
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 350, 0, 450)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BackgroundTransparency = 0.1
MainFrame.Parent = ScreenGui
MainFrame.Active = true
MainFrame.Draggable = true

-- Градиент
local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 45)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(45, 35, 60)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 40, 75))
})
Gradient.Parent = MainFrame

-- Закругление
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Верхняя панель
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
TopBar.BackgroundTransparency = 0.3
TopBar.Parent = MainFrame

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 12)
TopBarCorner.Parent = TopBar

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ULTIMATE ESP v2.0"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = TopBar

-- Кнопка закрытия
local CloseButton = Instance.new("ImageButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Position = UDim2.new(1, -30, 0, 5)
CloseButton.BackgroundTransparency = 1
CloseButton.Image = "rbxassetid://3926305904"
CloseButton.ImageColor3 = Color3.fromRGB(255, 100, 100)
CloseButton.Parent = TopBar

-- Создание свитчей
local function CreateSwitch(Name, Default, PositionY, Callback)
    local SwitchFrame = Instance.new("Frame")
    SwitchFrame.Size = UDim2.new(0.9, 0, 0, 40)
    SwitchFrame.Position = UDim2.new(0.05, 0, 0, PositionY)
    SwitchFrame.BackgroundTransparency = 1
    SwitchFrame.Parent = MainFrame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = Name
    Label.TextColor3 = Color3.fromRGB(220, 220, 255)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 16
    Label.Parent = SwitchFrame
    
    local Switch = Instance.new("TextButton")
    Switch.Size = UDim2.new(0, 50, 0, 25)
    Switch.Position = UDim2.new(1, -60, 0.5, -12.5)
    Switch.BackgroundColor3 = Default and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 100, 100)
    Switch.Text = Default and "ON" or "OFF"
    Switch.TextColor3 = Color3.fromRGB(255, 255, 255)
    Switch.Font = Enum.Font.GothamBold
    Switch.TextSize = 14
    Switch.Parent = SwitchFrame
    
    local SwitchCorner = Instance.new("UICorner")
    SwitchCorner.CornerRadius = UDim.new(0, 6)
    SwitchCorner.Parent = Switch
    
    Switch.MouseButton1Click:Connect(function()
        Default = not Default
        Switch.BackgroundColor3 = Default and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 100, 100)
        Switch.Text = Default and "ON" or "OFF"
        Callback(Default)
    end)
    
    return Switch
end

-- Создание меню
local Y = 45
CreateSwitch("Box ESP", Settings.Box, Y, function(v) Settings.Box = v SaveSettings() end)
Y = Y + 45
CreateSwitch("Tracers", Settings.Tracer, Y, function(v) Settings.Tracer = v SaveSettings() end)
Y = Y + 45
CreateSwitch("Show Names", Settings.Name, Y, function(v) Settings.Name = v SaveSettings() end)
Y = Y + 45
CreateSwitch("Show Distance", Settings.Distance, Y, function(v) Settings.Distance = v SaveSettings() end)
Y = Y + 45
CreateSwitch("Health Bar", Settings.Health, Y, function(v) Settings.Health = v SaveSettings() end)
Y = Y + 45
CreateSwitch("Head Dot", Settings.HeadDot, Y, function(v) Settings.HeadDot = v SaveSettings() end)

-- Кнопка открытия
local OpenButton = Instance.new("ImageButton")
OpenButton.Name = "OpenButton"
OpenButton.Size = UDim2.new(0, 50, 0, 50)
OpenButton.Position = UDim2.new(0, 20, 0.9, -70)
OpenButton.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
OpenButton.BackgroundTransparency = 0.2
OpenButton.Image = "rbxassetid://3926307979"
OpenButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
OpenButton.Parent = ScreenGui
OpenButton.Visible = false

local OpenButtonCorner = Instance.new("UICorner")
OpenButtonCorner.CornerRadius = UDim.new(1, 0)
OpenButtonCorner.Parent = OpenButton

-- Анимации кнопок
CloseButton.MouseEnter:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(255, 50, 50)}):Play()
end)
CloseButton.MouseLeave:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(255, 100, 100)}):Play()
end)

OpenButton.MouseEnter:Connect(function()
    TweenService:Create(OpenButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play()
end)
OpenButton.MouseLeave:Connect(function()
    TweenService:Create(OpenButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
end)

-- Функции меню
local function ToggleMenu()
    MenuVisible = not MenuVisible
    if MenuVisible then
        MainFrame.Visible = true
        OpenButton.Visible = false
        TweenService:Create(MainFrame, TweenInfo.new(0.3), {BackgroundTransparency = 0.1}):Play()
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        task.wait(0.3)
        MainFrame.Visible = false
        OpenButton.Visible = true
    end
end

CloseButton.MouseButton1Click:Connect(ToggleMenu)
OpenButton.MouseButton1Click:Connect(ToggleMenu)

-- ESP Core
local function DrawESP(Player)
    if Player == LocalPlayer then return end
    
    local function UpdateESP()
        if not ESPEnabled then return end
        
        local Character = Player.Character
        if not Character then return end
        
        local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
        local Root = Character:FindFirstChild("HumanoidRootPart")
        if not Humanoid or not Root then return end
        
        local Position, OnScreen = Camera:WorldToViewportPoint(Root.Position)
        local HeadPosition, _ = Camera:WorldToViewportPoint((Character:FindFirstChild("Head") or Root).Position)
        
        if not OnScreen then return end
        
        local BoxWidth = math.clamp(3000 / Position.Z, 2, 200)
        local BoxHeight = BoxWidth * 1.8
        local BoxY = Position.Y - BoxHeight/2
        local BoxX = Position.X - BoxWidth/2
        
        -- Box
        if Settings.Box then
            local BoxDrawing = Drawing.new("Square")
            BoxDrawing.Visible = true
            BoxDrawing.Size = Vector2.new(BoxWidth, BoxHeight)
            BoxDrawing.Position = Vector2.new(BoxX, BoxY)
            BoxDrawing.Color = Settings.BoxColor
            BoxDrawing.Thickness = 2
            BoxDrawing.Filled = false
            table.insert(ESPObjects, BoxDrawing)
        end
        
        -- Tracer
        if Settings.Tracer then
            local TracerDrawing = Drawing.new("Line")
            TracerDrawing.Visible = true
            TracerDrawing.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
            TracerDrawing.To = Vector2.new(Position.X, Position.Y)
            TracerDrawing.Color = Settings.TracerColor
            TracerDrawing.Thickness = 1
            table.insert(ESPObjects, TracerDrawing)
        end
        
        -- Name + Distance
        if Settings.Name or Settings.Distance then
            local Text = ""
            if Settings.Name then
                Text = Player.Name
            end
            if Settings.Distance then
                local Dist = math.floor((Root.Position - Camera.CFrame.Position).Magnitude)
                Text = Text .. (Settings.Name and " ["..Dist.."m]" or "["..Dist.."m]")
            end
            
            local NameDrawing = Drawing.new("Text")
            NameDrawing.Visible = true
            NameDrawing.Text = Text
            NameDrawing.Position = Vector2.new(Position.X - 50, Position.Y - BoxHeight/2 - 20)
            NameDrawing.Color = Settings.NameColor
            NameDrawing.Size = 16
            NameDrawing.Center = true
            NameDrawing.Outline = true
            table.insert(ESPObjects, NameDrawing)
        end
        
        -- Health Bar
        if Settings.Health and Humanoid.Health > 0 then
            local HealthPercent = Humanoid.Health / Humanoid.MaxHealth
            local BarWidth = BoxWidth + 4
            local BarHeight = 4
            
            -- Background
            local BGDrawing = Drawing.new("Square")
            BGDrawing.Visible = true
            BGDrawing.Size = Vector2.new(BarWidth, BarHeight)
            BGDrawing.Position = Vector2.new(BoxX - 2, BoxY - 8)
            BGDrawing.Color = Color3.fromRGB(50, 50, 50)
            BGDrawing.Filled = true
            table.insert(ESPObjects, BGDrawing)
            
            -- Health
            local HealthDrawing = Drawing.new("Square")
            HealthDrawing.Visible = true
            HealthDrawing.Size = Vector2.new(BarWidth * HealthPercent, BarHeight)
            HealthDrawing.Position = Vector2.new(BoxX - 2, BoxY - 8)
            HealthDrawing.Color = Color3.fromRGB(0, 255 * (1 - HealthPercent) + 255 * HealthPercent, 0)
            HealthDrawing.Filled = true
            table.insert(ESPObjects, HealthDrawing)
        end
        
        -- Head Dot
        if Settings.HeadDot then
            local DotDrawing = Drawing.new("Circle")
            DotDrawing.Visible = true
            DotDrawing.Position = Vector2.new(HeadPosition.X, HeadPosition.Y)
            DotDrawing.Radius = 4
            DotDrawing.Color = Settings.DotColor
            DotDrawing.Filled = true
            DotDrawing.NumSides = 16
            table.insert(ESPObjects, DotDrawing)
        end
    end
    
    local Connection
    Connection = RunService.RenderStepped:Connect(function()
        if not Player or not Player.Parent then
            Connection:Disconnect()
            return
        end
        UpdateESP()
    end)
end

-- Включение/выключение ESP
local function ToggleESP(State)
    ESPEnabled = State
    
    if ESPEnabled then
        for _, Player in ipairs(Players:GetPlayers()) do
            DrawESP(Player)
        end
        
        Players.PlayerAdded:Connect(DrawESP)
    else
        for _, DrawingObj in ipairs(ESPObjects) do
            pcall(function() DrawingObj:Remove() end)
        end
        ESPObjects = {}
    end
end

-- Создаем главный свитч
local ESPToggleFrame = Instance.new("Frame")
ESPToggleFrame.Size = UDim2.new(0.9, 0, 0, 45)
ESPToggleFrame.Position = UDim2.new(0.05, 0, 0, Y + 10)
ESPToggleFrame.BackgroundTransparency = 1
ESPToggleFrame.Parent = MainFrame

local ESPToggleLabel = Instance.new("TextLabel")
ESPToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
ESPToggleLabel.Position = UDim2.new(0, 10, 0, 0)
ESPToggleLabel.BackgroundTransparency = 1
ESPToggleLabel.Text = "ENABLE ESP"
ESPToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
ESPToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
ESPToggleLabel.Font = Enum.Font.GothamBold
ESPToggleLabel.TextSize = 18
ESPToggleLabel.Parent = ESPToggleFrame

local ESPToggleButton = Instance.new("TextButton")
ESPToggleButton.Size = UDim2.new(0, 80, 0, 30)
ESPToggleButton.Position = UDim2.new(1, -90, 0.5, -15)
ESPToggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
ESPToggleButton.Text = "OFF"
ESPToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPToggleButton.Font = Enum.Font.GothamBold
ESPToggleButton.TextSize = 16
ESPToggleButton.Parent = ESPToggleFrame

local ESPToggleCorner = Instance.new("UICorner")
ESPToggleCorner.CornerRadius = UDim.new(0, 8)
ESPToggleCorner.Parent = ESPToggleButton

-- Кнопка включения ESP
ESPToggleButton.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    ESPToggleButton.BackgroundColor3 = ESPEnabled and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(0, 200, 100)
    ESPToggleButton.Text = ESPEnabled and "ON" or "OFF"
    ToggleESP(ESPEnabled)
end)

-- FPS Counter
local FPSFrame = Instance.new("Frame")
FPSFrame.Size = UDim2.new(0.9, 0, 0, 30)
FPSFrame.Position = UDim2.new(0.05, 0, 1, -40)
FPSFrame.BackgroundTransparency = 1
FPSFrame.Parent = MainFrame

local FPSLabel = Instance.new("TextLabel")
FPSLabel.Size = UDim2.new(1, 0, 1, 0)
FPSLabel.BackgroundTransparency = 1
FPSLabel.Text = "FPS: 60"
FPSLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
FPSLabel.Font = Enum.Font.Gotham
FPSLabel.TextSize = 14
FPSLabel.Parent = FPSFrame

-- FPS Update
local LastTime = tick()
local Frames = 0

RunService.RenderStepped:Connect(function()
    Frames = Frames + 1
    local CurrentTime = tick()
    if CurrentTime - LastTime >= 1 then
        FPSLabel.Text = "FPS: " .. Frames
        Frames = 0
        LastTime = CurrentTime
    end
end)

-- Auto-update ESP when players join/leave
Players.PlayerRemoving:Connect(function()
    if ESPEnabled then
        for _, DrawingObj in ipairs(ESPObjects) do
            pcall(function() DrawingObj:Remove() end)
        end
        ESPObjects = {}
        for _, Player in ipairs(Players:GetPlayers()) do
            DrawESP(Player)
        end
    end
end)

print([[ 
    ╔══════════════════════════════════╗
    ║     ULTIMATE ESP v2.0 LOADED     ║
    ║     Press X to close/open menu   ║
    ║        Enjoy your ESP!            ║
    ╚══════════════════════════════════╝
]])

-- Hotkey for menu (X key)
UserInputService.InputBegan:Connect(function(Input, GameProcessed)
    if GameProcessed then return end
    if Input.KeyCode == Enum.KeyCode.X then
        ToggleMenu()
    end
end)
