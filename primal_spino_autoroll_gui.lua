-- Grow a Garden | Auto Roll for Spinosaurus in Primal Egg + ESP + GUI (by ChatGPT)
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local eggName = "Primal Egg"
local targetPet = "Spinosaurus"

local running = false
local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
gui.Name = "SpinoAutoRoll"

-- GUI setup
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 160)
frame.Position = UDim2.new(0.5, -150, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
title.Text = "🎯 Auto Roll: Primal Egg"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

local statusLabel = Instance.new("TextLabel", frame)
statusLabel.Size = UDim2.new(1, -10, 0, 40)
statusLabel.Position = UDim2.new(0, 5, 0, 35)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.new(1, 1, 1)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 15
statusLabel.Text = "Ready to roll..."

local startBtn = Instance.new("TextButton", frame)
startBtn.Size = UDim2.new(0.45, 0, 0, 35)
startBtn.Position = UDim2.new(0.05, 0, 1, -40)
startBtn.Text = "▶️ Start"
startBtn.BackgroundColor3 = Color3.fromRGB(50, 130, 60)
startBtn.TextColor3 = Color3.new(1,1,1)
startBtn.Font = Enum.Font.GothamBold
startBtn.TextSize = 14

local stopBtn = Instance.new("TextButton", frame)
stopBtn.Size = UDim2.new(0.45, 0, 0, 35)
stopBtn.Position = UDim2.new(0.5, 0, 1, -40)
stopBtn.Text = "⛔ Stop"
stopBtn.BackgroundColor3 = Color3.fromRGB(160, 50, 50)
stopBtn.TextColor3 = Color3.new(1,1,1)
stopBtn.Font = Enum.Font.GothamBold
stopBtn.TextSize = 14

local function notify(text)
	statusLabel.Text = text
end

local function highlightSpino()
	for _, pet in ipairs(Workspace:GetDescendants()) do
		if pet:IsA("Model") and pet.Name == targetPet and not pet:FindFirstChild("ESP") then
			local adornee = pet:FindFirstChildWhichIsA("BasePart")
			if adornee then
				local esp = Instance.new("BillboardGui", pet)
				esp.Name = "ESP"
				esp.Adornee = adornee
				esp.Size = UDim2.new(0, 100, 0, 30)
				esp.AlwaysOnTop = true

				local label = Instance.new("TextLabel", esp)
				label.Size = UDim2.new(1, 0, 1, 0)
				label.BackgroundTransparency = 1
				label.Text = "🦖 Spinosaurus"
				label.TextColor3 = Color3.new(1, 0.4, 0.4)
				label.TextScaled = true
				label.Font = Enum.Font.GothamBold
			end
		end
	end
end

local function hasSpinoInEgg(dropTable)
	for _, pet in pairs(dropTable or {}) do
		if tostring(pet):lower():find(targetPet:lower()) then
			return true
		end
	end
	return false
end

local function findEggRemote()
	for _, v in pairs(getgc(true)) do
		if typeof(v) == "function" and getfenv(v).script then
			local constants = debug.getconstants(v)
			for _, c in pairs(constants) do
				if tostring(c):lower():find("primal") then
					local up = debug.getupvalues(v)
					for _, val in pairs(up) do
						if typeof(val) == "table" and val.Roll then
							return val
						end
					end
				end
			end
		end
	end
	return nil
end

local function startRolling()
	local eggRemoteTable = findEggRemote()
	if not eggRemoteTable then
		notify("❌ Egg roll system not found.")
		return
	end

	running = true
	while running do
		local data = eggRemoteTable.GetPossibleRewards(eggName)
		if hasSpinoInEgg(data) then
			notify("🎯 Spinosaurus is in the egg! OPEN NOW!")
			break
		else
			notify("🔁 Rolling again...")
			eggRemoteTable.Roll(eggName)
			task.wait(0.5)
		end
	end
end

startBtn.MouseButton1Click:Connect(function()
	if not running then
		startRolling()
	end
end)

stopBtn.MouseButton1Click:Connect(function()
	running = false
	notify("⛔ Stopped.")
end)

-- Optional: auto ESP every 3 sec
task.spawn(function()
	while true do
		highlightSpino()
		task.wait(3)
	end
end)
