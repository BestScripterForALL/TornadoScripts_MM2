local Players = game:GetService("Players")
local plr     = Players.LocalPlayer
local UIS     = game:GetService("UserInputService")
local VIM     = game:GetService("VirtualInputManager")

-------------------------------------------------
-- GUI
-------------------------------------------------
local gui = Instance.new("ScreenGui", plr:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false

local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.fromOffset(60,60)
openBtn.Position = UDim2.new(1,-70,0.5,-30)
openBtn.Text = "T"
openBtn.Font = Enum.Font.GothamBold
openBtn.TextScaled = true
openBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
openBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1,0)

-------------------------------------------------
-- Drag logic
-------------------------------------------------
local dragging, dragInput, dragStart, startPos
openBtn.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging, dragStart, startPos = true, i.Position, openBtn.Position
		i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then dragging = false end end)
	end
end)
openBtn.InputChanged:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseMovement then dragInput = i end
end)
UIS.InputChanged:Connect(function(i)
	if i == dragInput and dragging then
		local d = i.Position - dragStart
		openBtn.Position = UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
	end
end)

-------------------------------------------------
-- Menu
-------------------------------------------------
local menu = Instance.new("Frame", gui)
menu.Size = UDim2.fromOffset(450,300)
menu.Position = UDim2.new(0.5,-225,0.5,-150)
menu.BackgroundColor3 = Color3.fromRGB(25,25,25)
menu.Visible = false
Instance.new("UICorner", menu).CornerRadius = UDim.new(0,10)

local title = Instance.new("TextLabel", menu)
title.Size  = UDim2.new(1,0,0,40)
title.Text  = "Tornado Scripts"
title.Font  = Enum.Font.GothamBold
title.TextScaled = true
title.BackgroundColor3 = Color3.fromRGB(35,35,35)
title.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", title).CornerRadius = UDim.new(0,8)

local tabs = Instance.new("Frame", menu)
tabs.Size = UDim2.new(0,130,1,-40)
tabs.Position = UDim2.new(0,0,0,40)
tabs.BackgroundColor3 = Color3.fromRGB(45,45,45)

local btnInfo = Instance.new("TextButton", tabs)
btnInfo.Size = UDim2.new(1,0,0,40)
btnInfo.Text = "Info"
btnInfo.Font = Enum.Font.GothamBold
btnInfo.TextScaled = true
btnInfo.BackgroundColor3 = Color3.fromRGB(65,65,65)
btnInfo.TextColor3 = Color3.new(1,1,1)

local btnMain = Instance.new("TextButton", tabs)
btnMain.Size = UDim2.new(1,0,0,40)
btnMain.Position = UDim2.new(0,0,0,45)
btnMain.Text = "Main"
btnMain.Font = Enum.Font.GothamBold
btnMain.TextScaled = true
btnMain.BackgroundColor3 = Color3.fromRGB(65,65,65)
btnMain.TextColor3 = Color3.new(1,1,1)

local pages = Instance.new("Frame", menu)
pages.Size = UDim2.new(1,-130,1,-40)
pages.Position = UDim2.new(0,130,0,40)
pages.BackgroundTransparency = 1

-------------------------------------------------
-- Info page
-------------------------------------------------
local pageInfo = Instance.new("Frame", pages)
pageInfo.Size = UDim2.new(1,0,1,0)

local infoLabel = Instance.new("TextLabel", pageInfo)
infoLabel.Size = UDim2.new(1,-20,0,200)
infoLabel.Position = UDim2.new(0,10,0,10)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "Создатель: BestScripterForALL\nИгрок: "..plr.Name
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextScaled = true
infoLabel.TextColor3 = Color3.new(1,1,1)
infoLabel.TextWrapped = true

-------------------------------------------------
-- Main page & buttons
-------------------------------------------------
local pageMain = Instance.new("Frame", pages)
pageMain.Size = UDim2.new(1,0,1,0)
pageMain.Visible = false
pageMain.BackgroundTransparency = 1

local function mkBtn(text,y)
	local b = Instance.new("TextButton", pageMain)
	b.Size = UDim2.new(0,150,0,50)
	b.Position = UDim2.new(0,20,0,y)
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextScaled = true
	b.BackgroundColor3 = Color3.fromRGB(100,30,30)
	b.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
	return b
end

local autoBtn   = mkBtn("AutoFarm [OFF]",20)
local espBtn    = mkBtn("ESP [OFF]",90)
local kAuraBtn  = mkBtn("KillAura [OFF]",160)

openBtn.MouseButton1Click:Connect(function() menu.Visible = not menu.Visible end)
btnInfo.MouseButton1Click:Connect(function() pageInfo.Visible,pageMain.Visible=true,false end)
btnMain.MouseButton1Click:Connect(function() pageInfo.Visible,pageMain.Visible=false,true end)

-------------------------------------------------
-- AutoFarm
-------------------------------------------------
local running=false
autoBtn.MouseButton1Click:Connect(function()
	running=not running
	autoBtn.Text = running and "AutoFarm [ON]" or "AutoFarm [OFF]"
	autoBtn.BackgroundColor3 = running and Color3.fromRGB(30,130,30) or Color3.fromRGB(100,30,30)
	task.spawn(function()
		while running do
			local target
			for _,map in ipairs(workspace:GetChildren()) do
				if map:IsA("Model") and map:FindFirstChild("CoinContainer") then
					for _,c in ipairs(map.CoinContainer:GetChildren()) do
						if c:IsA("BasePart") then target=c break end
					end
				end
				if target then break end
			end
			if target and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
				plr.Character.HumanoidRootPart.CFrame = target.CFrame + Vector3.new(0,3,0)
			end
			task.wait(0.5)
		end
	end)
end)

-------------------------------------------------
-- НОВЫЙ ESP
-------------------------------------------------
local espOn = false
local espFolder = Instance.new("Folder", game.CoreGui)
espFolder.Name = "ESPFolder_Tornado"

local itemOwners = { Gun = nil, Knife = nil }
local playerColors = {}

local function clearESP()
	for _, v in ipairs(espFolder:GetChildren()) do v:Destroy() end
	playerColors = {}
end

local function hasItem(player, itemName)
	local bp = player:FindFirstChild("Backpack")
	if bp then
		for _, it in ipairs(bp:GetChildren()) do
			if it.Name:lower() == itemName:lower() then return true end
		end
	end
	return false
end

local function updateItemOwners()
	local newKnife, newGun
	for _, p in ipairs(Players:GetPlayers()) do
		if not newKnife and hasItem(p,"Knife") then newKnife=p end
		if not newGun and (hasItem(p,"Gun") or hasItem(p,"Revolver")) then newGun=p end
	end
	if newKnife and newKnife ~= itemOwners.Knife then
		if itemOwners.Knife then playerColors[itemOwners.Knife]=Color3.fromRGB(0,255,0) end
		itemOwners.Knife = newKnife
		playerColors[newKnife] = Color3.fromRGB(255,0,0)
	end
	if newGun and newGun ~= itemOwners.Gun then
		if itemOwners.Gun then playerColors[itemOwners.Gun]=Color3.fromRGB(0,255,0) end
		itemOwners.Gun = newGun
		playerColors[newGun] = Color3.fromRGB(0,100,255)
	end
end

local function assignColorsIfMissing()
	for _, p in ipairs(Players:GetPlayers()) do
		if p~=plr and not playerColors[p] then playerColors[p]=Color3.fromRGB(0,255,0) end
	end
end

local function updateESP()
	for _, p in ipairs(Players:GetPlayers()) do
		if p~=plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			local box = espFolder:FindFirstChild(p.Name)
			if not box then
				box = Instance.new("BoxHandleAdornment")
				box.Name = p.Name
				box.Adornee = p.Character.HumanoidRootPart
				box.Size = Vector3.new(4,6,2)
				box.Transparency = 0.4
				box.AlwaysOnTop = true
				box.ZIndex = 5
				box.Parent = espFolder
			end
			box.Color3 = playerColors[p] or Color3.fromRGB(0,255,0)
		end
	end
end

espBtn.MouseButton1Click:Connect(function()
	espOn = not espOn
	espBtn.Text = espOn and "ESP [ON]" or "ESP [OFF]"
	espBtn.BackgroundColor3 = espOn and Color3.fromRGB(30,130,30) or Color3.fromRGB(100,30,30)
	if not espOn then clearESP() end
end)

task.spawn(function()
	while true do
		task.wait(1)
		if espOn then
			updateItemOwners()
			assignColorsIfMissing()
			updateESP()
		end
	end
end)

-------------------------------------------------
-- KillAura (0.5 s, тп строго за спину)
-------------------------------------------------
local auraOn = false
local KA_DELAY = 0.5       -- задержка между проверками

kAuraBtn.MouseButton1Click:Connect(function()
    auraOn = not auraOn
    kAuraBtn.Text = auraOn and "KillAura [ON]" or "KillAura [OFF]"
    kAuraBtn.BackgroundColor3 = auraOn and Color3.fromRGB(30,130,30)
                                        or Color3.fromRGB(100,30,30)
end)

local function getNearest()
    local me = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    if not me then return nil end
    local best, dist = nil, 100
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local d = (p.Character.HumanoidRootPart.Position - me.Position).Magnitude
            if d < 100 and d < dist then best, dist = p, d end
        end
    end
    return best
end

task.spawn(function()
    while true do
        task.wait(KA_DELAY)
        if auraOn then
            local target = getNearest()
            if target and target.Character and plr.Character
                and plr.Character:FindFirstChild("HumanoidRootPart") then

                -- CFrame за спину цели (+2 stud вверх)
                local tHRP = target.Character.HumanoidRootPart
                local behind = tHRP.CFrame * CFrame.new(0, 2, 2)
                plr.Character.HumanoidRootPart.CFrame = behind

                -- имитация клика ЛКМ
                VIM:SendMouseButtonEvent(0,0,0,true, game, 0)
                VIM:SendMouseButtonEvent(0,0,0,false,game, 0)
            end
        end
    end
end)
