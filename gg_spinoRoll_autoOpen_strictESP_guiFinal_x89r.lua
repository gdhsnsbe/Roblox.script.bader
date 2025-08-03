--[[ 📜 Grow a Garden | Predictive Auto-Roll with ESP (Pre-Hatch Detection) ]]
-- Watches PlayerGui.PetAssest to predict next pet before it hatches.
-- Rolls "Primal Egg" until "Spinosaurus" is predicted.
-- Displays ESP with predicted name above the egg.

local TARGET_PET = "Spinosaurus"
local EGG_NAME = "Primal Egg"
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- UI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "PredictRollUI"
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 240, 0, 120)
frame.Position = UDim2.new(0, 20, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0

local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(1, 0, 0.4, 0)
toggle.Text = "▶️ Start Predict Roll"
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

-- ESP Billboard
local function setESP(name)
    local existing = workspace:FindFirstChild("EggESP")
    if existing then existing:Destroy() end

    local egg = workspace:FindFirstChild(EGG_NAME)
    if egg then
        local esp = Instance.new("BillboardGui", egg)
        esp.Name = "EggESP"
        esp.Size = UDim2.new(0, 100, 0, 50)
        esp.StudsOffset = Vector3.new(0, 5, 0)
        esp.AlwaysOnTop = true

        local text = Instance.new("TextLabel", esp)
        text.Size = UDim2.new(1, 0, 1, 0)
        text.BackgroundTransparency = 1
        text.TextColor3 = Color3.fromRGB(0, 255, 0)
        text.Font = Enum.Font.SourceSansBold
        text.TextSize = 18
        text.Text = "🔮 " .. name
    end
end

-- Main logic
local rolling = false
local function startRolling()
    local path = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("ReplicatedAssest"):WaitForChild("PetAssest")

    while rolling do
        -- Listen for pet prediction
        local predictedPet = nil
        local connection
        connection = path.ChildAdded:Connect(function(child)
            if not rolling then return end
            predictedPet = child.Name
            label.Text = "🔮 Predicted: " .. predictedPet
            setESP(predictedPet)

            if predictedPet == TARGET_PET then
                rolling = false
                toggle.Text = "✅ Found: " .. TARGET_PET
                connection:Disconnect()
            end
        end)

        -- Fire hatch request
        local success, err = pcall(function()
            ReplicatedStorage:WaitForChild("Events"):WaitForChild("HatchEgg"):FireServer(EGG_NAME)
        end)
        if not success then
            warn("Failed to send roll:", err)
        end

        task.wait(2.5)
        if connection.Connected then connection:Disconnect() end
    end
end

-- Toggle
toggle.MouseButton1Click:Connect(function()
    rolling = not rolling
    toggle.Text = rolling and "⏹️ Stop Rolling" or "▶️ Start Predict Roll"
    if rolling then
        startRolling()
    end
end)
