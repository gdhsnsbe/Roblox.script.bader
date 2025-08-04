--[[ 🌱 Grow a Garden - Flexible Egg AutoRoll Script with ESP ]]
-- يعمل على أي بيضة، يتنبأ بالحيوان بدون فتح، يعرض ESP فوق البيضة في المزرعة، GUI أنيق

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- إعداد واجهة GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "AutoRollGui_Main"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 160)
frame.Position = UDim2.new(0, 20, 0, 150)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0

local uicorner = Instance.new("UICorner", frame)
uicorner.CornerRadius = UDim.new(0, 6)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "🌟 AutoRoll Config"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20

local eggBox = Instance.new("TextBox", frame)
eggBox.PlaceholderText = "Egg name (e.g. Zen Egg)"
eggBox.Size = UDim2.new(1, -20, 0, 30)
eggBox.Position = UDim2.new(0, 10, 0, 40)
eggBox.Font = Enum.Font.Gotham
eggBox.TextSize = 16
eggBox.Text = ""
eggBox.TextColor3 = Color3.new(1,1,1)
eggBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Instance.new("UICorner", eggBox).CornerRadius = UDim.new(0, 5)

local petBox = Instance.new("TextBox", frame)
petBox.PlaceholderText = "Target Pet (e.g. Kitsune)"
petBox.Size = UDim2.new(1, -20, 0, 30)
petBox.Position = UDim2.new(0, 10, 0, 80)
petBox.Font = Enum.Font.Gotham
petBox.TextSize = 16
petBox.Text = ""
petBox.TextColor3 = Color3.new(1,1,1)
petBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Instance.new("UICorner", petBox).CornerRadius = UDim.new(0, 5)

local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(1, -20, 0, 30)
toggle.Position = UDim2.new(0, 10, 0, 120)
toggle.Text = "▶️ Start AutoRoll"
toggle.TextColor3 = Color3.new(1,1,1)
toggle.BackgroundColor3 = Color3.fromRGB(60, 130, 60)
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 16
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 5)

-- ESP فوق البيضة في المزرعة
local function attachESPToEgg(predictedPet)
    for _, egg in pairs(Workspace:GetDescendants()) do
        if egg:IsA("Model") or egg:IsA("Part") then
            if string.find(egg.Name:lower(), "egg") then
                if not egg:FindFirstChild("PredictionESP") then
                    local esp = Instance.new("BillboardGui", egg)
                    esp.Name = "PredictionESP"
                    esp.Size = UDim2.new(0, 200, 0, 50)
                    esp.AlwaysOnTop = true
                    esp.StudsOffset = Vector3.new(0, 3, 0)

                    local label = Instance.new("TextLabel", esp)
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.BackgroundTransparency = 1
                    label.TextColor3 = Color3.fromRGB(255, 255, 0)
                    label.Font = Enum.Font.GothamBold
                    label.TextScaled = true
                    label.Text = "🔮 " .. predictedPet
                else
                    local gui = egg:FindFirstChild("PredictionESP")
                    if gui and gui:IsA("BillboardGui") then
                        local label = gui:FindFirstChildOfClass("TextLabel")
                        if label then
                            label.Text = "🔮 " .. predictedPet
                        end
                    end
                end
            end
        end
    end
end

-- عملية الرول
local rolling = false
local function startRolling(eggName, targetPet)
    local predictPath = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("ReplicatedAssest"):WaitForChild("PetAssest")

    while rolling do
        local found = false
        local connection
        connection = predictPath.ChildAdded:Connect(function(child)
            if not rolling then return end
            local predictedPet = child.Name
            attachESPToEgg(predictedPet)

            if predictedPet == targetPet then
                rolling = false
                toggle.Text = "✅ Found: " .. targetPet
                found = true
                connection:Disconnect()
            end
        end)

        local success, err = pcall(function()
            ReplicatedStorage:WaitForChild("Events"):WaitForChild("HatchEgg"):FireServer(eggName)
        end)

        if not success then
            warn("⚠️ Failed to roll:", err)
        end

        task.wait(2.5)
        if connection and connection.Connected then connection:Disconnect() end
        if found then break end
    end
end

-- الزر
toggle.MouseButton1Click:Connect(function()
    if rolling then
        rolling = false
        toggle.Text = "▶️ Start AutoRoll"
        return
    end
    local egg = eggBox.Text
    local pet = petBox.Text
    if egg == "" or pet == "" then
        toggle.Text = "❌ Fill all fields"
        task.wait(1)
        toggle.Text = "▶️ Start AutoRoll"
        return
    end
    rolling = true
    toggle.Text = "⏳ Rolling..."
    startRolling(egg, pet)
end)
