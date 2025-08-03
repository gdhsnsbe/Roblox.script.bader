--[[ 📜 Grow a Garden | Zen Egg Auto-Roll with GUI ESP Prediction ]]
-- يتنبأ بالحيوان بدون فتح Zen Egg، يعرض الاسم داخل PlayerGui فوق البيضة (Egg_Padding)، ويتوقف عند Spinosaurus

local TARGET_PET = "Spinosaurus"
local EGG_NAME = "Zen Egg"
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- GUI عنصر ESP
local function createOrUpdateESP(text)
    local guiPath = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("EventShop_UI")
        :WaitForChild("Frame"):WaitForChild("ScrollingFrame"):WaitForChild("zen")
        :WaitForChild("Egg_Padding")

    if guiPath:FindFirstChild("PetPredictionESP") then
        guiPath:FindFirstChild("PetPredictionESP"):Destroy()
    end

    local label = Instance.new("TextLabel", guiPath)
    label.Name = "PetPredictionESP"
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 0, 0, -22)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 0)
    label.TextStrokeTransparency = 0.5
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 16
    label.Text = "🔮 " .. text
end

-- الواجهة
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "ZenAutoRollUI"
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 100)
frame.Position = UDim2.new(0, 20, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0

local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(1, 0, 0.4, 0)
toggle.Text = "▶️ Start Zen Roll"
toggle.TextColor3 = Color3.new(1,1,1)
toggle.BackgroundColor3 = Color3.fromRGB(50,50,50)
toggle.Font = Enum.Font.SourceSansBold
toggle.TextSize = 18

local label = Instance.new("TextLabel", frame)
label.Size = UDim2.new(1, 0, 0.6, 0)
label.Position = UDim2.new(0, 0, 0.4, 0)
label.BackgroundTransparency = 1
label.TextColor3 = Color3.new(1,1,1)
label.Font = Enum.Font.SourceSansBold
label.TextSize = 18
label.Text = "🐣 Waiting..."

-- الوظيفة الأساسية
local rolling = false
local function startRolling()
    local path = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("ReplicatedAssest"):WaitForChild("PetAssest")

    while rolling do
        local predictedPet = nil
        local connection
        connection = path.ChildAdded:Connect(function(child)
            if not rolling then return end
            predictedPet = child.Name
            label.Text = "🔮 Predicted: " .. predictedPet
            createOrUpdateESP(predictedPet)

            if predictedPet == TARGET_PET then
                rolling = false
                toggle.Text = "✅ Found: " .. TARGET_PET
                connection:Disconnect()
            end
        end)

        local success, err = pcall(function()
            ReplicatedStorage:WaitForChild("Events"):WaitForChild("HatchEgg"):FireServer(EGG_NAME)
        end)
        if not success then
            warn("❌ فشل في إرسال HatchEgg:", err)
        end

        task.wait(2.5)
        if connection and connection.Connected then connection:Disconnect() end
    end
end

toggle.MouseButton1Click:Connect(function()
    rolling = not rolling
    toggle.Text = rolling and "⏹️ Stop Rolling" or "▶️ Start Zen Roll"
    if rolling then
        startRolling()
    end
end)
