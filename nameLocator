local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local function createESP(player)
	if player == LocalPlayer then return end
	local char = player.Character or player.CharacterAdded:Wait()
	
	local head = char:WaitForChild("Head", 5)
	if not head then return end
	
	if head:FindFirstChild("NameESP") then return end
	
	local tag = Instance.new("BillboardGui")
	tag.Name = "NameESP"
	tag.Adornee = head
	tag.Size = UDim2.new(0, 200, 0, 50)
	tag.StudsOffset = Vector3.new(0, 2, 0)
	tag.AlwaysOnTop = true
	tag.Parent = head
	
	local text = Instance.new("TextLabel", tag)
	text.Size = UDim2.new(1, 0, 1, 0)
	text.BackgroundTransparency = 1
	text.Text = player.Name
	text.TextColor3 = Color3.new(1, 0, 0) -- Red
	text.Font = Enum.Font.SourceSansBold
	text.TextSize = 20
	text.TextStrokeTransparency = 0.5
end

-- Apply ESP to existing players
for _, player in pairs(Players:GetPlayers()) do
	task.spawn(function()
		createESP(player)
	end)
end

-- Apply to new players
Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		task.wait(1)
		createESP(player)
	end)
end)

-- Re-apply ESP if character respawns
Players.PlayerRemoving:Connect(function(player)
	local char = player.Character
	if char and char:FindFirstChild("Head") then
		local gui = char.Head:FindFirstChild("NameESP")
		if gui then gui:Destroy() end
	end
end)

-- Reapply on respawn
Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		task.wait(1)
		createESP(player)
	end)
end)
