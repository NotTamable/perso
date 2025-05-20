local p=game:GetService("Players").LocalPlayer
local c=p.Character or p.CharacterAdded:Wait()
local r=c:WaitForChild("HumanoidRootPart")
local uis=game:GetService("UserInputService")
local g=Instance.new("ScreenGui",p:WaitForChild("PlayerGui"))
g.Name="TPUI"
local f=Instance.new("Frame",g)f.Size=UDim2.new(0,260,0,400)f.Position=UDim2.new(1,-270,0.5,-200)f.BackgroundColor3=Color3.fromRGB(30,30,30)f.BorderSizePixel=0
local btn=function(t,y)
local b=Instance.new("TextButton")b.Size=UDim2.new(1,0,0,30)b.Position=UDim2.new(0,0,0,y)b.Text=t
b.BackgroundColor3=Color3.fromRGB(45,45,45)b.TextColor3=Color3.new(1,1,1)b.Font=Enum.Font.SourceSansBold
b.TextSize=14 return b
end
local toggle,tpList={},{}
local tpMode,looping=false,false
local function refresh()
	for _,v in pairs(f:GetChildren())do if v.Name=="tpbtn"then v:Destroy()end end
	for i,t in ipairs(tpList)do
		local b=btn(t.name,60+i*32)b.Name="tpbtn"b.Parent=f
		b.MouseButton1Click:Connect(function()r.CFrame=CFrame.new(t.pos)end)
		local up=Instance.new("TextButton",b)up.Size=UDim2.new(0,20,1,0)up.Position=UDim2.new(1,-60,0,0)up.Text="↑"up.TextSize=12
		local dn=Instance.new("TextButton",b)dn.Size=UDim2.new(0,20,1,0)dn.Position=UDim2.new(1,-40,0,0)dn.Text="↓"dn.TextSize=12
		local rn=Instance.new("TextButton",b)rn.Size=UDim2.new(0,20,1,0)rn.Position=UDim2.new(1,-20,0,0)rn.Text="✎"rn.TextSize=12
		up.MouseButton1Click:Connect(function()if i>1 then tpList[i],tpList[i-1]=tpList[i-1],tpList[i]refresh()end end)
		dn.MouseButton1Click:Connect(function()if i<#tpList then tpList[i],tpList[i+1]=tpList[i+1],tpList[i]refresh()end end)
		rn.MouseButton1Click:Connect(function()
			local new=Instance.new("TextBox",b)new.Size=UDim2.new(1,0,1,0)new.Text=t.name
			new.FocusLost:Connect(function()t.name=new.Text new:Destroy()refresh()end)
		end)
	end
end
local b1=btn("🧭 Toggle Teleport Click",0)b1.Parent=f
b1.MouseButton1Click:Connect(function()tpMode=not tpMode b1.Text=tpMode and "✅ Click To Teleport" or "🧭 Toggle Teleport Click"end)
uis.InputBegan:Connect(function(i,gp)
	if not gp and tpMode and i.UserInputType==Enum.UserInputType.MouseButton1 then
		local m=uis:GetMouseLocation()
		local v=workspace.CurrentCamera:ScreenPointToRay(m.X,m.Y)
		local ray=Ray.new(v.Origin,v.Direction*500)
		local p,_,_ = workspace:FindPartOnRay(ray,p.Character)
		if p then r.CFrame=CFrame.new(p.Position+Vector3.new(0,3,0))end
	end
end)
local b2=btn("➕ Save Position",30)b2.Parent=f
b2.MouseButton1Click:Connect(function()
	table.insert(tpList,{name="TP "..#tpList+1,pos=r.Position})refresh()
end)
local b3=btn("▶ Run All",30+32)b3.Parent=f
b3.MouseButton1Click:Connect(function()
	task.spawn(function()
		repeat for _,t in ipairs(tpList)do r.CFrame=CFrame.new(t.pos)task.wait(0.5)end until not looping
	end)
end)
local b4=btn("🔁 Loop: OFF",30+64)b4.Parent=f
b4.MouseButton1Click:Connect(function()
	looping=not looping b4.Text=looping and "🔁 Loop: ON" or "🔁 Loop: OFF"
end)
