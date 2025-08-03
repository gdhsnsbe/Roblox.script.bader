--[[ 📜 Grow a Garden | Passive ESP + Logger (No Auto Hatch) ]]
-- يراقب البيض المفتوح ويعرض اسم الحيوان. يتوقف تلقائيًا عند Spinosaurus.

local TARGET_PET = "Spinosaurus"
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- واجهة المستخدم
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "SpinoWatcherUI"
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 250, 0, 120)
Frame.Position = UDim2.new(0, 20, 0, 100)
Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Frame.BorderSizePixel = 0

local Toggle = Instance.new("TextButton", Frame)
Toggle.Size = UDim2.new(1, 0, 0.4, 0)
Toggle.Position = UDim2.new(0, 0, 0, 0)
Toggle.Text = "▶️ Start Watching"
Toggle.TextColor3 = Color3.new(1, 1, 1)
Toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Toggle.Font = Enum.Font.SourceSansBold
Toggle.TextSize = 18

local Label = Instance.new("TextLabel", Frame)
Label.Size = UDim2.new(1, 0, 0.6, 0)
Label.Position = UDim2.new(0, 0, 0.4, 0)
Label.Text = "🐣 Last Hatched: ..."
Label.TextColor3 = Color3.new(1, 1, 1)
Label.BackgroundTransparency = 1
Label.Font = Enum.Font.SourceSansBold
Label.TextSize = 18

-- وظيفة ESP
local function highlight(model)
    if model:FindFirstChild("ESPBox") then return end
    local box = Instance.new("BoxHandleAdornment", model)
    box.Name = "ESPBox"
    box.Size = model:GetExtentsSize()
    box.Adornee = model
    box.AlwaysOnTop = true
    box.ZIndex = 5
    box.Transparency = 0.4
    box.Color3 = Color3.fromRGB(0, 255, 0)
end

-- المراقبة
local watching = false
local conn = nil

local function startWatching()
    local petsFolder = LocalPlayer:WaitForChild("Pets", 10)
    if not petsFolder then return warn("❌ Pets folder not found") end

    conn = petsFolder.ChildAdded:Connect(function(pet)
        if not watching then return end
        if pet:IsA("Folder") then
            task.wait(0.5)
            local petName = pet.Name
            Label.Text = "🐣 Last Hatched: " .. petName
            local worldPet = workspace:FindFirstChild(petName)
            if worldPet then highlight(worldPet) end
            if petName == TARGET_PET then
                watching = false
                Toggle.Text = "✅ Found: " .. TARGET_PET
                conn:Disconnect()
            end
        end
    end)
end

Toggle.MouseButton1Click:Connect(function()
    watching = not watching
    Toggle.Text = watching and "⏹️ Stop Watching" or "▶️ Start Watching"
    if watching and not conn then
        startWatching()
    elseif not watching and conn then
        conn:Disconnect()
        conn = nil
    end
end)
