local Window = {}
local AimRadius = 15
local MenuWidth = 300
local MenuHeight = 400
local ESPEnabled = false
local TeamCheckEnabled = true
local ValidKey = "Jwd3awK"
local KeyVerified = false
function Window.CreateButton(parent, text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 30)
    button.Position = UDim2.new(0, 0, 0.1, (table.getn(parent:GetChildren()) * 35) + 5)
    button.Text = text
    button.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.SourceSans
    button.TextScaled = true
    button.Parent = parent
    button.MouseButton1Click:Connect(callback)
    return button
end
function Window.CreateToggle(parent, text, initialValue, callback)
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(1, 0, 0, 30)
    toggle.Position = UDim2.new(0, 0, 0.1, (table.getn(parent:GetChildren()) * 35) + 5)
    toggle.Text = text .. ": " .. (initialValue and "ON" or "OFF")
    toggle.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    toggle.TextColor3 = Color3.new(1, 1, 1)
    toggle.Font = Enum.Font.SourceSans
    toggle.TextScaled = true
    local isOn = initialValue
    toggle.Parent = parent
    toggle.MouseButton1Click:Connect(function()
        isOn = not isOn
        toggle.Text = text .. ": " .. (isOn and "ON" or "OFF")
        callback(isOn)
    end)
    return toggle
end
local GuiService = game:GetService("GuiService")
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TitleLabel = Instance.new("TextLabel")
local KeyInputFrame = Instance.new("Frame")
local KeyTextBox = Instance.new("TextBox")
local VerifyButton = Instance.new("TextButton")
local MenuContent = Instance.new("Frame")
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
MainFrame.Size = UDim2.new(0, MenuWidth, 0, MenuHeight)
MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.1, 0)
UICorner.Parent = MainFrame
TitleLabel.Size = UDim2.new(1, 0, 0, 30)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.Text = "Codded t.me/deleteless"
TitleLabel.TextColor3 = Color3.new(1, 1, 1)
TitleLabel.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
TitleLabel.TextScaled = true
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Center
TitleLabel.Parent = MainFrame
KeyInputFrame.Size = UDim2.new(1, -20, 0, 60)
KeyInputFrame.Position = UDim2.new(0, 10, 0.1, 35)
KeyInputFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
KeyInputFrame.BorderSizePixel = 0
KeyInputFrame.Parent = MainFrame
KeyTextBox.Size = UDim2.new(1, -10, 0, 30)
KeyTextBox.Position = UDim2.new(0, 5, 0, 5)
KeyTextBox.PlaceholderText = "Get key t.me/durovmay"
KeyTextBox.TextColor3 = Color3.new(1, 1, 1)
KeyTextBox.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
KeyTextBox.Font = Enum.Font.SourceSans
KeyTextBox.TextScaled = true
KeyTextBox.Parent = KeyInputFrame
VerifyButton.Size = UDim2.new(0.5, -10, 0, 30)
VerifyButton.Position = UDim2.new(0.5, 5, 0, 40)
VerifyButton.AnchorPoint = Vector2.new(0.5, 0)
VerifyButton.Text = "Check key🔑"
VerifyButton.TextColor3 = Color3.new(1, 1, 1)
VerifyButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
VerifyButton.Font = Enum.Font.SourceSansBold
VerifyButton.TextScaled = true
VerifyButton.Parent = KeyInputFrame
MenuContent.Size = UDim2.new(1, 0, 0, MenuHeight - 30)
MenuContent.Position = UDim2.new(0, 0, 0, 30)
MenuContent.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
MenuContent.BorderSizePixel = 0
MenuContent.Visible = false
MenuContent.Parent = MainFrame
local Aiming = false
local Target = nil
local function FindNearestTarget()
    local Players = game.Players:GetPlayers()
    local ClosestPlayer = nil
    local ClosestDistance = math.huge
    local LocalPlayer = game.Players.LocalPlayer
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local Head = Character:FindFirstChild("Head")
	local LocalTeam = LocalPlayer.Team
    if not Head then return nil end
    for _, Player in pairs(Players) do
        if Player ~= LocalPlayer and Player.Character then
			local EnemyTeam = Player.Team
			if TeamCheckEnabled and LocalTeam == EnemyTeam then
				continue
			end
            local EnemyHead = Player.Character:FindFirstChild("Head")
            if EnemyHead then
                local Distance = (Head.Position - EnemyHead.Position).Magnitude
                if Distance < ClosestDistance then
                    ClosestDistance = Distance
                    ClosestPlayer = Player
                end
            end
        end
    end
    if ClosestDistance <= AimRadius then
        return ClosestPlayer
    end
    return nil
end
local function AimBot()
    local LocalPlayer = game.Players.LocalPlayer
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local Humanoid = Character:FindFirstChild("Humanoid")
    local Head = Character:FindFirstChild("Head")
    if not Humanoid or not Head then return end
    Target = FindNearestTarget()
    if Target then
        local EnemyHead = Target.Character:FindFirstChild("Head")
        if EnemyHead then
            local Camera = workspace.CurrentCamera
            local ViewportSize = Camera.ViewportSize
            local TargetPosition = Camera:WorldToViewportPoint(EnemyHead.Position)
            local MousePosition = Vector2.new(ViewportSize.X / 2, ViewportSize.Y / 2)
            local Difference = MousePosition - Vector2.new(TargetPosition.X, TargetPosition.Y)
            local NewCFrame = CFrame.lookAt(Head.Position, EnemyHead.Position)
            Camera.CFrame = NewCFrame
        end
    end
end
local function ToggleAimBot(enabled)
    Aiming = enabled
    if Aiming then
        print("AimBot включен!")
        game:GetService("RunService").RenderStepped:Connect(AimBot)
    else
        print("AimBot выключен!")
        for i, connection in pairs(game:GetService("RunService"):GetConnections("RenderStepped")) do
            if connection.Function == AimBot then
                connection:Disconnect()
            end
        end
    end
end
local function ToggleESP(enabled)
    ESPEnabled = enabled
	print("ESP включен: " .. tostring(enabled))
end
local function ToggleTeamCheck(enabled)
    TeamCheckEnabled = enabled
	print("Team Check включен: " .. tostring(enabled))
end
local function ChangeAimRadius(amount)
    AimRadius = AimRadius + amount
	if AimRadius < 0 then
		AimRadius = 0
	end
	RadiusLabel.Text = "Радиус аимбота: " .. AimRadius
end
Window.CreateToggle(MenuContent, "Аимбот", false, ToggleAimBot)
Window.CreateToggle(MenuContent, "ESP", false, ToggleESP)
Window.CreateToggle(MenuContent, "Team Check", true, ToggleTeamCheck)
Window.CreateButton(MenuContent, "+ Радиус", function() ChangeAimRadius(5) end)
Window.CreateButton(MenuContent, "- Радиус", function() ChangeAimRadius(-5) end)
local RadiusLabel = Instance.new("TextLabel")
RadiusLabel.Size = UDim2.new(1, 0, 0, 20)
RadiusLabel.Position = UDim2.new(0, 0, 0.9, 0)
RadiusLabel.Text = "Радиус аимбота: " .. AimRadius
RadiusLabel.TextColor3 = Color3.new(1, 1, 1)
RadiusLabel.BackgroundColor3 = Color3.new(0, 0, 0)
RadiusLabel.TextScaled = true
RadiusLabel.Font = Enum.Font.SourceSans
RadiusLabel.TextXAlignment = Enum.TextXAlignment.Center
RadiusLabel.Parent = MenuContent
local dragging = false
local dragInput = nil
local dragStart = nil
local UserInputService = game:GetService("UserInputService")
MainFrame.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragInput = input
		dragStart = input.Position
	end
end)
MainFrame.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            MainFrame.Position.X.Scale,
            MainFrame.Position.X.Offset + delta.X,
            MainFrame.Position.Y.Scale,
            MainFrame.Position.Y.Offset + delta.Y
        )
        dragStart = input.Position
    end
end)
MainFrame.InputEnded:Connect(function(input)
    if input == dragInput then
        dragging = false
        dragInput = nil
    end
end)
local hue = 0
game:GetService("RunService").RenderStepped:Connect(function()
	hue = hue + 0.01
	if hue > 1 then
		hue = 0
	end
	local color = Color3.fromHSV(hue, 1, 1)
	MainFrame.BackgroundColor3 = color:Lerp(Color3.new(0, 0, 0), 0.7)
end)
game:GetService("RunService").RenderStepped:Connect(function()
	if ESPEnabled and KeyVerified then
		for i, v in pairs(game.Players:GetPlayers()) do
			if v.Name ~= game.Players.LocalPlayer.Name and v.Character and v.Character:FindFirstChild("Head") then
				local Head = v.Character:FindFirstChild("Head")
				local Humanoid = v.Character:FindFirstChild("Humanoid")
				if Head and Humanoid and Humanoid.Health > 0 then
					local BillboardGui = Head:FindFirstChild("BillboardGui")
					if not BillboardGui then
						BillboardGui = Instance.new("BillboardGui")
						BillboardGui.Size = UDim2.new(0, 50, 0, 20)
						BillboardGui.AlwaysOnTop = true
						BillboardGui.Parent = Head
						local TextLabel = Instance.new("TextLabel")
						TextLabel.Size = UDim2.new(1, 0, 1, 0)
						TextLabel.BackgroundTransparency = 1
						TextLabel.TextColor3 = Color3.new(1, 1, 1)
						TextLabel.TextScaled = true
						TextLabel.Font = Enum.Font.SourceSansBold
						TextLabel.Text = v.Name
						TextLabel.Parent = BillboardGui
					end
				end
			end
		end
	else
		for i, v in pairs(game.Players:GetPlayers()) do
			if v.Character and v.Character:FindFirstChild("Head") then
				local Head = v.Character:FindFirstChild("Head")
				local BillboardGui = Head:FindFirstChild("BillboardGui")
				if BillboardGui then
					BillboardGui:Destroy()
				end
			end
		end
	end
end)
VerifyButton.MouseButton1Click:Connect(function()
    if KeyTextBox.Text == ValidKey then
        KeyVerified = true
        KeyInputFrame:Destroy()
        MenuContent.Visible = true
        print("Key Verifed")
    else
        warn("Wrong Key!")
    end
end)
print("Exploit Loaded...")
