--[[ 🥚 Grow a Garden - Zen Egg AutoRoll Predictor with ESP & GUI 🎯
     ✔️ Predicts pet before opening
     ✔️ Repeats roll until target pet is found
     ✔️ Shows ESP above real egg in PlayerGui
     ✔️ Stops on correct prediction
     ✔️ Clean, elegant GUI
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- GUI Setup
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "ZenEggAutoRollGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 280, 0, 160)
frame.Position = UDim2.new(0, 20, 0, 150)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "🎯 Zen Egg AutoRoll"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.new(1,1,1)

local eggBox = Instance.new("TextBox", frame)
eggBox.PlaceholderText = "Egg name (e.g. Zen Egg)"
eggBox.Position = UDim2.new(0, 10, 0, 40)
eggBox.Size = UDim2.new(1, -20, 0, 30)
eggBox.Font = Enum.Font.Gotham
eggBox.TextSize = 16
eggBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
eggBox.TextColor3 = Color3.new(1,1,1)
eggBox.Text = ""
Instance.new("UICorner", eggBox).CornerRadius = UDim.new(0, 5)

local petBox = Instance.new("TextBox", frame)
petBox.PlaceholderText = "Target Pet (e.g. Kitsune)"
petBox.Position = UDim2.new(0, 10, 0, 80)
petBox.Size = UDim2.new(1, -20, 0, 30)
petBox.Font = Enum.Font.Gotham
petBox.TextSize = 16
petBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
petBox.TextColor3 = Color3.new(1,1,1)
petBox.Text = ""
Instance.new("UICorner", petBox).CornerRadius = UDim.new(0, 5)

local toggle = Instance.new("TextButton", frame)
toggle.Position = UDim2.new(0, 10, 0, 120)
toggle.Size = UDim2.new(1, -20, 0, 30)
toggle.Text = "▶️ Start AutoRoll"
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 16
toggle.TextColor3 = Color3.new(1,1,1)
toggle.BackgroundColor3 = Color3.fromRGB(60, 120, 60)
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 5)

-- ESP Handler (above real Zen Egg in PlayerGui)
local function updateEggESP(petName)
    local eggFrame = LocalPlayer:FindFirstChild("PlayerGui")
        and LocalPlayer.PlayerGui:FindFirstChild("EventShop_UI")
        and LocalPlayer.PlayerGui.EventShop_UI:FindFirstChild("Frame")
        and LocalPlayer.PlayerGui.EventShop_UI.Frame:FindFirstChild("ScrollingFrame")
        and LocalPlayer.PlayerGui.EventShop_UI.Frame.ScrollingFrame:FindFirstChild("zen")
        and LocalPlayer.PlayerGui.EventShop_UI.Frame.ScrollingFrame.zen:FindFirstChild("Egg_Padding")

    if eggFrame and eggFrame:IsA("Frame") then
        if not eggFrame:FindFirstChild("PredictionESP") then
            local esp = Instance.new("BillboardGui", eggFrame)
            esp.Name = "PredictionESP"
            esp.Size = UDim2.new(0, 200, 0, 50)
            esp.StudsOffset = Vector3.new(0, 2, 0)
            esp.AlwaysOnTop = true

            local label = Instance.new("TextLabel", esp)
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.TextColor3 = Color3.fromRGB(255, 255, 0)
            label.Font = Enum.Font.GothamBold
            label.TextScaled = true
            label.Text = "🔮 " .. petName
        else
            local gui = eggFrame:FindFirstChild("PredictionESP")
            if gui and gui:IsA("BillboardGui") then
                local label = gui:FindFirstChildOfClass("TextLabel")
                if label then
                    label.Text = "🔮 " .. petName
                end
            end
        end
    end
end

-- Main loop logic
local rolling = false

local function startRolling(eggName, targetPet)
    local petFolder = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("ReplicatedAssest"):WaitForChild("PetAssest")

    while rolling do
        local found = false
        local connection

        connection = petFolder.ChildAdded:Connect(function(pet)
            if not rolling then return end
            local predicted = pet.Name
            updateEggESP(predicted)

            if predicted == targetPet then
                toggle.Text = "✅ Found: " .. targetPet
                rolling = false
                connection:Disconnect()
            end
        end)

        local success, err = pcall(function()
            ReplicatedStorage:WaitForChild("Events"):WaitForChild("HatchEgg"):FireServer(eggName)
        end)

        if not success then
            warn("⚠️ Hatch error:", err)
        end

        task.wait(2.5)
        if connection and connection.Connected then connection:Disconnect() end
        if not rolling then break end
    end
end

-- Button
toggle.MouseButton1Click:Connect(function()
    if rolling then
        rolling = false
        toggle.Text = "▶️ Start AutoRoll"
        return
    end

    local egg = eggBox.Text
    local pet = petBox.Text

    if egg == "" or pet == "" then
        toggle.Text = "❌ Fill both fields"
        task.wait(1.5)
        toggle.Text = "▶️ Start AutoRoll"
        return
    end

    rolling = true
    toggle.Text = "⏳ Rolling..."
    startRolling(egg, pet)
end)
