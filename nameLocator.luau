local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local espEnabled = true
local espTags = {}

-- Create toggle button
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "ESP_ToggleUI"
gui.ResetOnSpawn = false

local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 100, 0, 30)
toggleBtn.Position = UDim2.new(0, 10, 0, 100)
toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Text = "ESP: ON"
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 14
toggleBtn.Draggable = true
toggleBtn.Active = true

-- Toggle function
toggleBtn.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	toggleBtn.Text = espEnabled and "ESP: ON" or "ESP: OFF"
	for _, tag in pairs(espTags) do
		if tag and tag:IsA("BillboardGui") then
			tag.Enabled = espEnabled
		end
	end
end)

-- Function to create ESP tag
local function createESP(player)
	if player == LocalPlayer then return end
	local function onCharacterAdded(char)
		local head = char:WaitForChild("Head", 5)
		if not head then return end

		-- Remove old if exists
		local existing = head:FindFirstChild("NameESP")
		if existing then existing:Destroy() end

		local tag = Instance.new("BillboardGui")
		tag.Name = "NameESP"
		tag.Adornee = head
		tag.Size = UDim2.new(0, 200, 0, 50)
		tag.StudsOffset = Vector3.new(0, 2, 0)
		tag.AlwaysOnTop = true
		tag.Enabled = espEnabled
		tag.Parent = head
		espTags[player] = tag

		local nameLabel = Instance.new("TextLabel", tag)
		nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
		nameLabel.Position = UDim2.new(0, 0, 0, 0)
		nameLabel.BackgroundTransparency = 1
		nameLabel.Text = player.Name
		nameLabel.TextColor3 = Color3.new(1, 0, 0)
		nameLabel.Font = Enum.Font.SourceSansBold
		nameLabel.TextSize = 16
		nameLabel.TextStrokeTransparency = 0.5

		local distLabel = Instance.new("TextLabel", tag)
		distLabel.Size = UDim2.new(1, 0, 0.5, 0)
		distLabel.Position = UDim2.new(0, 0, 0.5, 0)
		distLabel.BackgroundTransparency = 1
		distLabel.Text = "Distance: 0"
		distLabel.TextColor3 = Color3.new(1, 1, 1)
		distLabel.Font = Enum.Font.SourceSans
		distLabel.TextSize = 14
		distLabel.Name = "DistanceLabel"

		-- Update distance
		RunService.RenderStepped:Connect(function()
			if not tag or not tag.Parent or not distLabel or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
			local hrp = player.Character.HumanoidRootPart
			local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			if myHRP then
				local dist = (myHRP.Position - hrp.Position).Magnitude
				distLabel.Text = string.format("Distance: %.1f", dist)
			end
		end)
	end

	if player.Character then
		onCharacterAdded(player.Character)
	end
	player.CharacterAdded:Connect(onCharacterAdded)
end

-- Add ESP for all players
for _, p in ipairs(Players:GetPlayers()) do
	createESP(p)
end

-- New players
Players.PlayerAdded:Connect(function(player)
	createESP(player)
end)
