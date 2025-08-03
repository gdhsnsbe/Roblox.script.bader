-- Grow a Garden: Auto Roll Spinosaurus + Auto Open + Smart ESP + GUI | By ChatGPT
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local eggName = "Primal Egg"
local targetPet = "Spinosaurus"

local autoRolling = false
local espEnabled = false

-- GUI
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "SpinoGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 320, 0, 200)
frame.Position = UDim2.new(0.5, -160, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
title.Text = "🌿 Grow a Garden: Spino Auto Roll & ESP"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

local status = Instance.new("TextLabel", frame)
status.Position = UDim2.new(0, 10, 0, 40)
status.Size = UDim2.new(1, -20, 0, 40)
status.BackgroundTransparency = 1
status.TextColor3 = Color3.new(1, 1, 1)
status.Font = Enum.Font.Gotham
status.TextSize = 14
status.Text = "🔄 Ready..."

local startBtn = Instance.new("TextButton", frame)
startBtn.Position = UDim2.new(0.05, 0, 1, -90)
startBtn.Size = UDim2.new(0.4, 0, 0, 35)
startBtn.Text = "▶️ Start Roll"
startBtn.BackgroundColor3 = Color3.fromRGB(60, 140, 60)
startBtn.TextColor3 = Color3.new(1,1,1)
startBtn.Font = Enum.Font.GothamBold
startBtn.TextSize = 14

local stopBtn = Instance.new("TextButton", frame)
stopBtn.Position = UDim2.new(0.55, 0, 1, -90)
stopBtn.Size = UDim2.new(0.4, 0, 0, 35)
stopBtn.Text = "⛔ Stop"
stopBtn.BackgroundColor3 = Color3.fromRGB(170, 60, 60)
stopBtn.TextColor3 = Color3.new(1,1,1)
stopBtn.Font = Enum.Font.GothamBold
stopBtn.TextSize = 14

local espBtn = Instance.new("TextButton", frame)
espBtn.Position = UDim2.new(0.05, 0, 1, -45)
espBtn.Size = UDim2.new(0.9, 0, 0, 35)
espBtn.Text = "👁️ Toggle ESP (OFF)"
espBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 200)
espBtn.TextColor3 = Color3.new(1,1,1)
espBtn.Font = Enum.Font.GothamBold
espBtn.TextSize = 14

-- Update label
local function updateStatus(text)
	status.Text = text
end

-- Smart ESP only for real pets
local function isRealPet(model)
	return model:IsA("Model")
		and model:FindFirstChildWhichIsA("BasePart")
		and (model:FindFirstChild("Head") or model:FindFirstChild("HumanoidRootPart"))
		and model.Parent == Workspace
end

local function addESP(pet)
	if not pet or pet:FindFirstChild("ESP") or not isRealPet(pet) then return end
	local adornee = pet:FindFirstChildWhichIsA("BasePart")
	local esp = Instance.new("BillboardGui", pet)
	esp.Name = "ESP"
	esp.Adornee = adornee
	esp.Size = UDim2.new(0, 100, 0, 30)
	esp.AlwaysOnTop = true

	local label = Instance.new("TextLabel", esp)
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = "🐾 " .. pet.Name
	label.TextColor3 = Color3.fromRGB(255, 200, 200)
	label.TextScaled = true
end

local function scanESP()
	if not espEnabled then return end
	for _, obj in pairs(Workspace:GetDescendants()) do
		if isRealPet(obj) and not obj:FindFirstChild("ESP") then
			addESP(obj)
		end
	end
end

espBtn.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	espBtn.Text = espEnabled and "👁️ Toggle ESP (ON)" or "👁️ Toggle ESP (OFF)"
end)

-- Find Egg System
local function findEggRemote()
	for _, fn in pairs(getgc(true)) do
		if typeof(fn) == "function" and getfenv(fn).script then
			local consts = debug.getconstants(fn)
			for _, c in pairs(consts) do
				if tostring(c):lower():find("primal") then
					local ups = debug.getupvalues(fn)
					for _, u in pairs(ups) do
						if typeof(u) == "table" and u.Roll and u.GetPossibleRewards and u.Open then
							return u
						end
					end
				end
			end
		end
	end
end

local function hasSpino(dropList)
	for _, pet in pairs(dropList or {}) do
		if tostring(pet):lower():find(targetPet:lower()) then
			return true
		end
	end
	return false
end

local function startRoll()
	local system = findEggRemote()
	if not system then
		updateStatus("❌ Egg system not found.")
		return
	end

	autoRolling = true
	while autoRolling do
		local drops = system.GetPossibleRewards(eggName)
		if hasSpino(drops) then
			updateStatus("🎯 Spinosaurus found! Opening...")
			system.Open(eggName)
			break
		else
			updateStatus("🔁 Rolling...")
			system.Roll(eggName)
			task.wait(0.4)
		end
	end
end

startBtn.MouseButton1Click:Connect(function()
	if not autoRolling then
		startRoll()
	end
end)

stopBtn.MouseButton1Click:Connect(function()
	autoRolling = false
	updateStatus("⛔ Stopped.")
end)

-- Loop ESP Scan
task.spawn(function()
	while true do
		if espEnabled then scanESP() end
		task.wait(2.5)
	end
end)
