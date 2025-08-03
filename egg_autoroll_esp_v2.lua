local gui = game.Players.LocalPlayer:WaitForChild("PlayerGui")

print("🔎 عناصر تحتوي على 'egg' في PlayerGui:")
for _, item in pairs(gui:GetDescendants()) do
    if string.find(item.Name:lower(), "egg") then
        print("🧩", item:GetFullName(), "| نوع:", item.ClassName)
    end
end
