--[[ 🥚 Grow a Garden – All Eggs AutoRoll Predictor with ESP ]]
-- يدعم أي نوع بيضة، يرصد الاسم المتوقع، يعرض ESP فوق البيضة كل 3 ثواني

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local function findAnyEggFrame()
    for _, child in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
        if child:IsA("Frame") and child.Name:lower():find("egg") then
            return child
        end
    end
end

local function createOrUpdateESP(targetFrame, petName)
    if not targetFrame then return end
    local existing = targetFrame:FindFirstChild("PredictionESP")
    if not existing then
        local esp = Instance.new("BillboardGui", targetFrame)
        esp.Name = "PredictionESP"
        esp.Size = UDim2.new(0, 200, 0, 40)
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
        local label = existing:FindFirstChildOfClass("TextLabel")
        if label then label.Text = "🔮 " .. petName end
    end
end

local rolling = true

task.spawn(function()
    while rolling do
        local petFolder = LocalPlayer.PlayerGui:FindFirstChild("ReplicatedAssest") and
                          LocalPlayer.PlayerGui.ReplicatedAssest:FindFirstChild("PetAssest")
        if petFolder then
            local connection
            connection = petFolder.ChildAdded:Connect(function(child)
                createOrUpdateESP(findAnyEggFrame(), child.Name)
            end)
        end

        local eggFrame = findAnyEggFrame()
        local eggName = eggFrame and eggFrame.Name or "Zen Egg"
        pcall(function()
            ReplicatedStorage.Events.HatchEgg:FireServer(eggName)
        end)

        task.wait(3)
        if connection then connection:Disconnect() end
    end
end)
