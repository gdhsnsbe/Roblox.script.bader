--[[ 📜 Grow a Garden Auto-Roller & ESP for Spinosaurus by ChatGPT ]]

-- SETTINGS
local TARGET_PET = "Spinosaurus"
local EGG_NAME = "Primal Egg"

-- UI Library
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 200, 0, 100)
Frame.Position = UDim2.new(0, 20, 0, 100)
Frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)

local autoRollBtn = Instance.new("TextButton", Frame)
autoRollBtn.Size = UDim2.new(1, 0, 0.5, 0)
autoRollBtn.Position = UDim2.new(0, 0, 0, 0)
autoRollBtn.Text = "🔁 Start Auto Roll"
autoRollBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

local espBtn = Instance.new("TextButton", Frame)
espBtn.Size = UDim2.new(1, 0, 0.5, 0)
espBtn.Position = UDim2.new(0, 0, 0.5, 0)
espBtn.Text = "👁️ Enable ESP"
espBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

-- Variables
local autoRolling = false
local espEnabled = false
local espConnections = {}

-- ESP Function
local function highlightSpinos()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v.Name == TARGET_PET and not v:FindFirstChild("ESPBox") then
            local b = Instance.new("BoxHandleAdornment", v)
            b.Name = "ESPBox"
            b.Size = v:GetExtentsSize()
            b.Adornee = v
            b.AlwaysOnTop = true
            b.ZIndex = 10
            b.Transparency = 0.5
            b.Color3 = Color3.fromRGB(0, 255, 0)
        end
    end
end

-- Toggle ESP
espBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espBtn.Text = espEnabled and "👁️ Disable ESP" or "👁️ Enable ESP"
    if espEnabled then
        highlightSpinos()
        table.insert(espConnections, workspace.DescendantAdded:Connect(function(obj)
            if obj:IsA("Model") and obj.Name == TARGET_PET then
                highlightSpinos()
            end
        end))
    else
        for _, v in pairs(workspace:GetDescendants()) do
            if v:FindFirstChild("ESPBox") then
                v.ESPBox:Destroy()
            end
        end
        for _, c in pairs(espConnections) do
            c:Disconnect()
        end
        espConnections = {}
    end
end)

-- Auto Roll Logic
local function openEgg()
    local args = {
        [1] = EGG_NAME
    }
    local success, err = pcall(function()
        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("HatchEgg"):FireServer(unpack(args))
    end)
    if not success then
        warn("❌ Error opening egg: ", err)
    end
end

-- Check Inventory
local function hasSpinosaurus()
    local inv = game:GetService("Players").LocalPlayer:FindFirstChild("Pets")
    if inv then
        for _, pet in pairs(inv:GetChildren()) do
            if pet.Name == TARGET_PET then
                return true
            end
        end
    end
    return false
end

-- Toggle Auto Roll
autoRollBtn.MouseButton1Click:Connect(function()
    autoRolling = not autoRolling
    autoRollBtn.Text = autoRolling and "⏹️ Stop Auto Roll" or "🔁 Start Auto Roll"

    if autoRolling then
        task.spawn(function()
            while autoRolling and not hasSpinosaurus() do
                openEgg()
                task.wait(1.5)
            end
            if hasSpinosaurus() then
                autoRollBtn.Text = "✅ Spinosaurus Found!"
                autoRolling = false
            end
        end)
    end
end)
