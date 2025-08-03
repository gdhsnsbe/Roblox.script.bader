-- كشف جميع مجسمات البيض داخل PlayerGui ووضع ESP عليها لتحديد البيضة الحقيقية

local player = game:GetService("Players").LocalPlayer
local gui = player:WaitForChild("PlayerGui")

for _, descendant in pairs(gui:GetDescendants()) do
    if descendant:IsA("Model") or descendant:IsA("Part") then
        if string.find(descendant.Name:lower(), "egg") then
            local esp = Instance.new("BillboardGui", descendant)
            esp.Name = "DebugESP"
            esp.Size = UDim2.new(0, 100, 0, 50)
            esp.StudsOffset = Vector3.new(0, 4, 0)
            esp.AlwaysOnTop = true

            local label = Instance.new("TextLabel", esp)
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = "🥚 " .. descendant.Name
            label.TextColor3 = Color3.new(1, 1, 0)
            label.Font = Enum.Font.SourceSansBold
            label.TextSize = 16
        end
    end
end
