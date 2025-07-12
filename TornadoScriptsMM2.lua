local Players = game:GetService("Players")
local UIS     = game:GetService("UserInputService")
local VIM     = game:GetService("VirtualInputManager")
local plr     = Players.LocalPlayer

-- GUI ----------------------------------------------------------
local gui = Instance.new("ScreenGui", plr:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false

local open = Instance.new("TextButton", gui)
open.Size = UDim2.fromOffset(60,60)
open.Position = UDim2.new(1,-70,0.5,-30)
open.Text = "T"
open.Font = Enum.Font.GothamBold
open.TextScaled = true
open.BackgroundColor3 = Color3.fromRGB(20,20,20)
open.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", open).CornerRadius = UDim.new(1,0)

local drag,di,ds,sp
open.InputBegan:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
		drag,ds,sp=true,i.Position,open.Position
		i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then drag=false end end)
	end
end)
open.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then di=i end end)
UIS.InputChanged:Connect(function(i)
	if i==di and drag then
		open.Position=UDim2.new(sp.X.Scale,sp.X.Offset+i.Position.X-ds.X,sp.Y.Scale,sp.Y.Offset+i.Position.Y-ds.Y)
	end
end)

local menu = Instance.new("Frame", gui)
menu.Size = UDim2.fromOffset(450,300)
menu.Position = UDim2.new(0.5,-225,0.5,-150)
menu.BackgroundColor3 = Color3.fromRGB(25,25,25)
menu.Visible = false
Instance.new("UICorner", menu).CornerRadius = UDim.new(0,10)

local title = Instance.new("TextLabel", menu)
title.Size = UDim2.new(1,0,0,40)
title.Text = "Tornado Scripts"
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.BackgroundColor3 = Color3.fromRGB(35,35,35)
title.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", title).CornerRadius = UDim.new(0,8)

local tabs = Instance.new("Frame", menu)
tabs.Size = UDim2.new(0,130,1,-40)
tabs.Position = UDim2.new(0,0,0,40)
tabs.BackgroundColor3 = Color3.fromRGB(45,45,45)

local function tab(name, y)
	local b = Instance.new("TextButton", tabs)
	b.Size = UDim2.new(1,0,0,40)
	b.Position = UDim2.new(0,0,0,y)
	b.Text = name
	b.Font = Enum.Font.GothamBold
	b.TextScaled = true
	b.BackgroundColor3 = Color3.fromRGB(65,65,65)
	b.TextColor3 = Color3.new(1,1,1)
	return b
end
local bInfo = tab("Info",0)
local bMain = tab("Main",45)
local bFun  = tab("Fun" ,90)

local pages = Instance.new("Frame", menu)
pages.Size = UDim2.new(1,-130,1,-40)
pages.Position = UDim2.new(0,130,0,40)
pages.BackgroundTransparency = 1

local pInfo = Instance.new("Frame", pages)
pInfo.Size = UDim2.new(1,0,1,0)

local pMain = Instance.new("Frame", pages)
pMain.Size = UDim2.new(1,0,1,0)
pMain.Visible = false
pMain.BackgroundTransparency = 1

local pFun = Instance.new("Frame", pages)
pFun.Size = UDim2.new(1,0,1,0)
pFun.Visible = false
pFun.BackgroundTransparency = 1

local info = Instance.new("TextLabel", pInfo)
info.Size = UDim2.new(1,-20,0,200)
info.Position = UDim2.new(0,10,0,10)
info.BackgroundTransparency = 1
info.Text = "Создатель: BestScripterForALL\nИгрок: "..plr.Name
info.Font = Enum.Font.Gotham
info.TextScaled = true
info.TextColor3 = Color3.new(1,1,1)
info.TextWrapped = true

local function mk(parent,text,y)
	local b = Instance.new("TextButton", parent)
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

local btnAF = mk(pMain,"AutoFarm [OFF]",20)
local btnESP= mk(pMain,"ESP [OFF]"     ,90)
local btnKA = mk(pMain,"KillAura [OFF]",160)
local btnSJ = mk(pFun ,"Spam Jump [OFF]",20)

open.MouseButton1Click:Connect(function() menu.Visible = not menu.Visible end)
bInfo.MouseButton1Click:Connect(function() pInfo.Visible=true  pMain.Visible=false pFun.Visible=false end)
bMain.MouseButton1Click:Connect(function() pInfo.Visible=false pMain.Visible=true  pFun.Visible=false end)
bFun.MouseButton1Click:Connect(function()  pInfo.Visible=false pMain.Visible=false pFun.Visible=true  end)

----------------------------------------------------------------
-- AutoFarm (телепорт к ближайшей монете)
----------------------------------------------------------------
local afOn=false
btnAF.MouseButton1Click:Connect(function()
	afOn=not afOn
	btnAF.Text = afOn and "AutoFarm [ON]" or "AutoFarm [OFF]"
	btnAF.BackgroundColor3 = afOn and Color3.fromRGB(30,130,30) or Color3.fromRGB(100,30,30)
end)

local function nearestCoin()
	local char=plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
	if not char then return nil end
	local best,dist=nil,9e9
	for _,m in ipairs(workspace:GetChildren()) do
		local cc=m:FindFirstChild("CoinContainer")
		if cc then
			for _,c in ipairs(cc:GetChildren()) do
				if c:IsA("BasePart") then
					local d=(c.Position-char.Position).Magnitude
					if d<dist then dist,best=d,c end
				end
			end
		end
	end
	return best
end

task.spawn(function()
	while true do
		task.wait(0.25)
		if afOn then
			local coin=nearestCoin()
			if coin and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
				plr.Character.HumanoidRootPart.CFrame=coin.CFrame+Vector3.new(0,3,0)
			end
		end
	end
end)

----------------------------------------------------------------
-- ESP
----------------------------------------------------------------
local espOn=false
local espF=Instance.new("Folder",game.CoreGui) espF.Name="ESPTornado"
local owners={Gun=nil,Knife=nil} local col={}
local function clr() for _,v in ipairs(espF:GetChildren()) do v:Destroy() end col={} end
local function has(p,it) local b=p:FindFirstChild("Backpack") if not b then return false end for _,o in ipairs(b:GetChildren()) do if o.Name:lower()==it then return true end end return false end
local function upd()
	local k,g=nil,nil
	for _,p in ipairs(Players:GetPlayers()) do
		if not k and has(p,"knife") then k=p end
		if not g and (has(p,"gun") or has(p,"revolver")) then g=p end
	end
	if k and k~=owners.Knife then if owners.Knife then col[owners.Knife]=Color3.fromRGB(0,255,0) end owners.Knife=k col[k]=Color3.fromRGB(255,0,0) end
	if g and g~=owners.Gun   then if owners.Gun   then col[owners.Gun]  =Color3.fromRGB(0,255,0) end owners.Gun  =g col[g]=Color3.fromRGB(0,100,255) end
	for _,p in ipairs(Players:GetPlayers()) do if p~=plr and not col[p] then col[p]=Color3.fromRGB(0,255,0) end end
end
local function draw()
	for _,p in ipairs(Players:GetPlayers()) do
		if p~=plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			local b=espF:FindFirstChild(p.Name)
			if not b then b=Instance.new("BoxHandleAdornment",espF) b.Name=p.Name b.Adornee=p.Character.HumanoidRootPart b.Size=Vector3.new(4,6,2) b.Transparency=0.4 b.AlwaysOnTop=true b.ZIndex=5 end
			b.Color3=col[p]
		end
	end
end
btnESP.MouseButton1Click:Connect(function()
	espOn=not espOn
	btnESP.Text=espOn and "ESP [ON]" or "ESP [OFF]"
	btnESP.BackgroundColor3=espOn and Color3.fromRGB(30,130,30) or Color3.fromRGB(100,30,30)
	if not espOn then clr() end
end)
task.spawn(function()
	while true do task.wait(1) if espOn then upd() draw() end end
end)

----------------------------------------------------------------
-- KillAura
----------------------------------------------------------------
local kaOn=false
btnKA.MouseButton1Click:Connect(function()
	kaOn=not kaOn
	btnKA.Text=kaOn and "KillAura [ON]" or "KillAura [OFF]"
	btnKA.BackgroundColor3=kaOn and Color3.fromRGB(30,130,30) or Color3.fromRGB(100,30,30)
end)
local function tgt()
	local hrp=plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") if not hrp then return nil end
	local best,d=nil,100
	for _,p in ipairs(Players:GetPlayers()) do
		if p~=plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			local dist=(p.Character.HumanoidRootPart.Position-hrp.Position).Magnitude
			if dist<d then d,best=dist,p end
		end
	end
	return best
end
task.spawn(function()
	while true do task.wait(0.5)
		if kaOn then
			local tar=tgt()
			if tar and tar.Character and plr.Character then
				local thrp=tar.Character.HumanoidRootPart
				local phrp=plr.Character.HumanoidRootPart
				phrp.CFrame=thrp.CFrame*CFrame.new(0,2,2)
				VIM:SendMouseButtonEvent(0,0,0,true,game,0)
				VIM:SendMouseButtonEvent(0,0,0,false,game,0)
			end
		end
	end
end)

----------------------------------------------------------------
-- Spam Jump
----------------------------------------------------------------
local sj=false
btnSJ.MouseButton1Click:Connect(function()
	sj=not sj
	btnSJ.Text=sj and "Spam Jump [ON]" or "Spam Jump [OFF]"
	btnSJ.BackgroundColor3=sj and Color3.fromRGB(30,130,30) or Color3.fromRGB(100,30,30)
end)
task.spawn(function()
	while true do task.wait(0.3)
		if sj and plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") then
			plr.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end
end)
local btnTPM = mk(pFun, "TP to Murderer [OFF]", 90)
local tpmOn = false

btnTPM.MouseButton1Click:Connect(function()
	tpmOn = not tpmOn
	btnTPM.Text = tpmOn and "TP to Murderer [ON]" or "TP to Murderer [OFF]"
	btnTPM.BackgroundColor3 = tpmOn and Color3.fromRGB(30,130,30) or Color3.fromRGB(100,30,30)
end)

task.spawn(function()
	while true do
		task.wait(1)
		if tpmOn and owners.Knife and owners.Knife.Character and plr.Character then
			local murderer = owners.Knife
			local tHRP = murderer.Character:FindFirstChild("HumanoidRootPart")
			local pHRP = plr.Character:FindFirstChild("HumanoidRootPart")
			if tHRP and pHRP then
				pHRP.CFrame = tHRP.CFrame * CFrame.new(0, 2, 2)
			end
		end
	end
end)
local btnTPS = mk(pFun, "TP to Sheriff [OFF]", 160)
local tpsOn = false

btnTPS.MouseButton1Click:Connect(function()
	tpsOn = not tpsOn
	btnTPS.Text = tpsOn and "TP to Sheriff [ON]" or "TP to Sheriff [OFF]"
	btnTPS.BackgroundColor3 = tpsOn and Color3.fromRGB(30,130,30) or Color3.fromRGB(100,30,30)
end)

task.spawn(function()
	while true do
		task.wait(1)
		if tpsOn and owners.Gun and owners.Gun.Character and plr.Character then
			local sheriff = owners.Gun
			local sheriffHRP = sheriff.Character:FindFirstChild("HumanoidRootPart")
			local myHRP = plr.Character:FindFirstChild("HumanoidRootPart")
			if sheriffHRP and myHRP then
				myHRP.CFrame = sheriffHRP.CFrame * CFrame.new(0, 2, 2)
			end
		end
	end
end)
