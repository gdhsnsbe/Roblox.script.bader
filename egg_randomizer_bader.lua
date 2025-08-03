-- Egg Randomizer GUI Script (Client-side Fun)
local pets = {"Duke", "Pumpkin Panda", "Phantom Cat", "Golden Dog", "Leaf Bunny", "Fire Wolf", "Dark Reaper"}

-- GUI setup
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "EggRandomizer"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 250, 0, 120)
Frame.Position = UDim2.new(0.5, -125, 0.4, 0)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "🎲 Egg Randomizer"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.BorderSizePixel = 0
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18

local Result = Instance.new("TextLabel", Frame)
Result.Size = UDim2.new(1, 0, 0, 40)
Result.Position = UDim2.new(0, 0, 0, 30)
Result.Text = "Click Roll to Start!"
Result.TextColor3 = Color3.fromRGB(255, 255, 255)
Result.BackgroundTransparency = 1
Result.Font = Enum.Font.Gotham
Result.TextSize = 20

local Roll = Instance.new("TextButton", Frame)
Roll.Size = UDim2.new(1, 0, 0, 40)
Roll.Position = UDim2.new(0, 0, 1, -40)
Roll.Text = "🎰 Roll"
Roll.TextColor3 = Color3.fromRGB(255, 255, 255)
Roll.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Roll.BorderSizePixel = 0
Roll.Font = Enum.Font.GothamBold
Roll.TextSize = 20

Roll.MouseButton1Click:Connect(function()
	local chosen = pets[math.random(1, #pets)]
	Result.Text = "🐾 You got: " .. chosen .. "!"
end).   
Add randomizer script. 
