-- Grow a Garden: Auto Roll + ESP + GUI (by ChatGPT)
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

local running = false
local foundSpino = false

-- واجهة المستخدم
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "GrowGardenAutoRoll"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 180)
frame.Position = UDim2.new(0.5, -150, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "🌱 Grow a Garden: Auto Roll"
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18

local resultLabel = Instance.new("TextLabel", frame)
resultLabel.Size = UDim2.new(1, 0, 0, 40)
resultLabel.Position = UDim2.new(0, 0, 0, 45)
resultLabel.BackgroundTransparency = 1
resultLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
resultLabel.Font = Enum.Font.Gotham
resultLabel.TextSize = 18
resultLabel.Text = "Click Start to begin..."

local startBtn = Instance.new("TextButton", frame)
startBtn.Size = UDim2.new(0.45, 0, 0, 40)
startBtn.Position = UDim2.new(0.05, 0, 1, -45)
startBtn.Text = "▶️ Start Auto Roll"
startBtn.BackgroundColor3 = Color3.fromRGB(60, 130, 60)
startBtn.TextColor3 = Color3.new(1, 1, 1)
startBtn.Font = Enum.Font.GothamBold
startBtn.TextSize = 16

local stopBtn = Instance.new("TextButton", frame)
stopBtn.Size = UDim2.new(0.45, 0, 0, 40)
stopBtn.Position = UDim2.new(0.5, 0, 1, -45)
stopBtn.Text = "⛔ Stop"
stopBtn.BackgroundColor3 = Color3.fromRGB(150, 60, 60)
stopBtn.TextColor3 = Color3.new(1, 1, 1)
stopBtn.Font = Enum.Font.GothamBold
stopBtn.TextSize = 16

local espBtn = Instance.new("TextButton", frame)
espBtn.Size = UDim2.new(0.9, 0, 0, 30)
espBtn.Position = UDim2.new(0.05, 0, 1, -85)
espBtn.Text = "👁️ Enable Spinosaurus ESP"
espBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 150)
espBtn.TextColor3 = Color3.new(1, 1, 1)
espBtn.Font = Enum.Font.GothamBold
espBtn.TextSize = 15

-- ESP
function enableESP()
    for _, pet in pairs(Workspace:GetDescendants()) do
        if pet:IsA("Model") and pet.Name == "Spinosaurus" and not pet:FindFirstChild("SpinoESP") then
            local billboard = Instance.new("BillboardGui", pet)
            billboard.Name = "SpinoESP"
            billboard.Size = UDim2.new(0, 100, 0, 30)
            billboard.AlwaysOnTop = true
            billboard.Adornee = pet:FindFirstChildWhichIsA("Part")

            local label = Instance.new("TextLabel", billboard)
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.TextColor3 = Color3.new(1, 0.3, 0.3)
            label.Text = "🦖 Spinosaurus"
            label.TextScaled = true
        end
    end
end

-- تحقق من Spinosaurus
function checkForSpino()
    for _,v in pairs(getgc(true)) do
        if typeof(v) == "function" and getfenv(v).script then
            local dump = debug.getupvalues(v)
            for _,val in pairs(dump) do
                if typeof(val) == "table" then
                    for k, pet in pairs(val) do
                        if tostring(k):lower():find("spino") or tostring(pet):lower():find("spino") then
                            return true
                        end
                    end
                end
            end
        end
    end
    return false
end

-- Auto Roll
function startAutoRoll()
    running = true
    resultLabel.Text = "🔄 Searching for Spinosaurus..."
    while running do
        if checkForSpino() then
            foundSpino = true
            resultLabel.Text = "🎯 Spinosaurus ready! Open the egg!"
            break
        end
        task.wait(0.5)
    end
end

startBtn.MouseButton1Click:Connect(function()
    if not running then
        startAutoRoll()
    end
end)

stopBtn.MouseButton1Click:Connect(function()
    running = false
    resultLabel.Text = "⛔ Stopped."
end)

espBtn.MouseButton1Click:Connect(function()
    enableESP()
end)
