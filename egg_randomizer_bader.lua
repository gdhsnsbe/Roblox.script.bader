-- Egg Randomizer GUI Script (Fixed Version)
local pets = {"Duke", "Pumpkin Panda", "Phantom Cat", "Golden Dog", "Leaf Bunny", "Fire Wolf", "Dark Reaper"}

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "EggRandomizer"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 120)
frame.Position = UDim2.new(0.5, -125, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "🎲 Egg Randomizer"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
title.BorderSizePixel = 0
title.Font = Enum.Font.GothamBold
title.TextSize = 18

local result = Instance.new("TextLabel", frame)
result.Size = UDim2.new(1, 0, 0, 40)
result.Position = UDim2.new(0, 0, 0, 30)
result.Text = "Click Roll to Start!"
result.TextColor3 = Color3.fromRGB(255, 255, 255)
result.BackgroundTransparency = 1
result.Font = Enum.Font.Gotham
result.TextSize = 20

local roll = Instance.new("TextButton", frame)
roll.Size = UDim2.new(1, 0, 0, 40)
roll.Position = UDim2.new(0, 0, 1, -40)
roll.Text = "🎰 Roll"
roll.TextColor3 = Color3.fromRGB(255, 255, 255)
roll.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
roll.BorderSizePixel = 0
roll.Font = Enum.Font.GothamBold
roll.TextSize = 20

roll.MouseButton1Click:Connect(function()
	local chosen = pets[math.random(1, #pets)]
	result.Text = "🐾 You got: " .. chosen .. "!"
end)
add egg randomizer. 
