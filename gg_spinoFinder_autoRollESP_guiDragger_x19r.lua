-- Auto Roll for Spinosaurus + Multi-Pet ESP + Draggable GUI | By ChatGPT
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

local eggName = "Primal Egg"
local targetPet = "Spinosaurus"

local running = false

-- GUI
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "SpinoESP_GUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 310, 0, 180)
frame.Position = UDim2.new(0.5, -155, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "🌱 Grow a Garden - Auto Roll & ESP"
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(1, -10, 0, 40)
status.Position = UDim2.new(0, 5, 0, 35)
status.BackgroundTransparency = 1
status.TextColor3 = Color3.new(1, 1, 1)
status.Font = Enum.Font.Gotham
status.TextSize = 15
status.Text = "Ready to begin..."

local startBtn = Instance.new("TextButton", frame)
startBtn.Size = UDim2.new(0.45, 0, 0, 35)
startBtn.Position = UDim2.new(0.05, 0, 1, -45)
startBtn.Text = "▶️ Start"
startBtn.BackgroundColor3 = Color3.fromRGB(60, 130, 60)
startBtn.TextColor3 = Color3.new(1, 1, 1)
startBtn.Font = Enum.Font.GothamBold
startBtn.TextSize = 14

local stopBtn = Instance.new("TextButton", frame)
stopBtn.Size = UDim2.new(0.45, 0, 0, 35)
stopBtn.Position = UDim2.new(0.5, 0, 1, -45)
stopBtn.Text = "⛔ Stop"
stopBtn.BackgroundColor3 = Color3.fromRGB(160, 60, 60)
stopBtn.TextColor3 = Color3.new(1, 1, 1)
stopBtn.Font = Enum.Font.GothamBold
stopBtn.TextSize = 14

-- Notify
local function updateStatus(msg)
	status.Text = msg
end

-- ESP for any pet model in world
local function tagPetESP(pet)
	if pet:IsA("Model") and pet:FindFirstChildWhichIsA("BasePart") and not pet:FindFirstChild("ESP") then
		local esp = Instance.new("BillboardGui", pet)
		esp.Name = "ESP"
		esp.Adornee = pet:FindFirstChildWhichIsA("BasePart")
		esp.Size = UDim2.new(0, 100, 0, 30)
		esp.AlwaysOnTop = true

		local label = Instance.new("TextLabel", esp)
		label.Size = UDim2.new(1, 0, 1, 0)
		label.BackgroundTransparency = 1
		label.Text = "🐾 " .. pet.Name
		label.TextColor3 = Color3.fromRGB(255, 150, 150)
		label.TextScaled = true
	end
end

-- Loop over world pets and apply ESP
local function scanWorldPets()
	for _, pet in pairs(Workspace:GetDescendants()) do
		if pet:IsA("Model") and pet:FindFirstChildWhichIsA("BasePart") then
			tagPetESP(pet)
		end
	end
end

-- Check egg contents for Spino
local function hasTargetPet(dropTable)
	for _, pet in pairs(dropTable or {}) do
		if tostring(pet):lower():find(targetPet:lower()) then
			return true
		end
	end
	return false
end

-- Show ESP of all possible pets in this egg roll
local function showPossibleESP(dropTable)
	for _, pet in pairs(dropTable or {}) do
		warn("👁️ Possible: ", pet)
	end
end

-- Locate roll function in memory
local function findEggSystem()
	for _, fn in pairs(getgc(true)) do
		if typeof(fn) == "function" and getfenv(fn).script then
			local consts = debug.getconstants(fn)
			for _, c in pairs(consts) do
				if tostring(c):lower():find("primal") then
					local ups = debug.getupvalues(fn)
					for _, u in pairs(ups) do
						if typeof(u) == "table" and u.Roll and u.GetPossibleRewards then
							return u
						end
					end
				end
			end
		end
	end
end

-- Start Auto Roll
local function startRolling()
	local eggRemote = findEggSystem()
	if not eggRemote then
		updateStatus("❌ Egg system not found.")
		return
	end

	running = true
	while running do
		local drops = eggRemote.GetPossibleRewards(eggName)
		showPossibleESP(drops)

		if hasTargetPet(drops) then
			updateStatus("🎯 Spinosaurus found! Open it now.")
			break
		else
			updateStatus("🔁 Rolling...")
			eggRemote.Roll(eggName)
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
	updateStatus("⛔ Stopped.")
end)

-- Auto scan for world ESP every few seconds
task.spawn(function()
	while true do
		scanWorldPets()
		task.wait(4)
	end
end)
