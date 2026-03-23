--[[
    PROJECT: NAMMON SPY V8.1 (OFFICIAL GITHUB VERSION)
    OWNER: NAMMON (น้ำมนต์)
    FEATURES: 
        - Professional UI (Red/Green Buttons)
        - Safe Ghost Jump (Only Player Blocks)
        - Kill Aura (Slider 1-500, Active with Tool)
        - Anti-Fall Damage (Bypass)
        - RGB Orb Toggle (Draggable)
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- [ Configuration ]
local ws_value = 46
local jp_value = 250
local ka_on = true -- เปิด Standby ไว้เสมอ
local ka_range = 25
local noclip_on = false
local hitRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Hit")
local fallRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("FallDamage")

-- [ 1. Anti-Fall Damage ]
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    if self == fallRemote and getnamecallmethod() == "FireServer" then return nil end
    return oldNamecall(self, ...)
end)

-- [ 2. Smart Ghost Jump (Player Blocks Only) ]
RunService.Stepped:Connect(function()
    if noclip_on and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                -- เช็คว่าใกล้ๆ มีบล็อกที่คนสร้างไหม (ชื่อโฟลเดอร์ส่วนใหญ่คือ Buildings หรือ Builds)
                local isBlock = false
                local builds = workspace:FindFirstChild("Buildings") or workspace:FindFirstChild("Builds")
                
                -- ตรวจสอบวัตถุรอบตัวในระยะใกล้
                for _, obj in pairs(workspace:GetPartBoundsInRadius(part.Position, 1)) do
                    if builds and obj:IsDescendantOf(builds) then
                        isBlock = true
                        break
                    elseif obj.Name == "Part" and obj.Parent:IsA("Model") and obj ~= part then
                        isBlock = true
                        break
                    end
                end
                
                if isBlock then
                    part.CanCollide = false -- ทะลุได้ถ้าเป็นบล็อกคนวาง
                else
                    -- ถ้าเป็นพื้นแมพหรือวัตถุเดิม ให้ชนปกติเพื่อไม่ให้ร่วง
                    if part.Name == "HumanoidRootPart" then 
                        part.CanCollide = true 
                    end
                end
            end
        end
    end
end)

-- [ 3. UI Implementation ]
local ScreenGui = Instance.new("ScreenGui", (gethui and gethui()) or game:GetService("CoreGui"))
ScreenGui.Name = "NAMMON_SPY_V8_1"

-- Orb Toggle
local Orb = Instance.new("ImageButton", ScreenGui)
Orb.Size = UDim2.new(0, 50, 0, 50)
Orb.Position = UDim2.new(0, 10, 0.5, 0)
Orb.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Orb.Image = "rbxassetid://6031068433"
Instance.new("UICorner", Orb).CornerRadius = UDim.new(1, 0)
local OrbStroke = Instance.new("UIStroke", Orb)
OrbStroke.Thickness = 2

-- Main Frame
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 340, 0, 260)
Main.Position = UDim2.new(0.5, -170, 0.5, -130)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.Visible = false
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Thickness = 2; MainStroke.Color = Color3.fromRGB(255, 100, 0) -- ขอบส้ม

-- Adjuster Function (Red/Green)
local function createAdjuster(title, startVal, increment, pos, parent, callback)
    local F = Instance.new("Frame", parent)
    F.Size = UDim2.new(0, 300, 0, 45); F.Position = pos; F.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Instance.new("UICorner", F)

    local L = Instance.new("TextLabel", F)
    L.Size = UDim2.new(1, 0, 1, 0); L.BackgroundTransparency = 1; L.TextColor3 = Color3.new(1, 1, 1)
    L.Font = Enum.Font.GothamBold; L.Text = title .. ": [" .. startVal .. "]"

    local M = Instance.new("TextButton", F)
    M.Size = UDim2.new(0, 45, 1, 0); M.BackgroundColor3 = Color3.fromRGB(180, 0, 0); M.Text = "-"; M.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", M)

    local P = Instance.new("TextButton", F)
    P.Size = UDim2.new(0, 45, 1, 0); P.Position = UDim2.new(1, -45, 0, 0); P.BackgroundColor3 = Color3.fromRGB(0, 150, 0); P.Text = "+"; P.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", P)

    M.MouseButton1Click:Connect(function() callback(-increment) end)
    P.MouseButton1Click:Connect(function() callback(increment) end)
    return L
end

local sL = createAdjuster("Speed", ws_value, 1, UDim2.new(0.5, -150, 0, 20), Main, function(d) ws_value = math.max(0, ws_value + d) end)
local jL = createAdjuster("Jump", jp_value, 10, UDim2.new(0.5, -150, 0, 75), Main, function(d) jp_value = math.max(0, jp_value + d) end)

-- Ghost Jump Toggle
local ghostBtn = Instance.new("TextButton", Main)
ghostBtn.Size = UDim2.new(0, 300, 0, 40); ghostBtn.Position = UDim2.new(0.5, -150, 0, 130)
ghostBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45); ghostBtn.Text = "👻 Ghost Jump (Safe Pass)"; ghostBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", ghostBtn)
ghostBtn.MouseButton1Click:Connect(function()
    noclip_on = not noclip_on
    ghostBtn.BackgroundColor3 = noclip_on and Color3.fromRGB(0, 120, 200) or Color3.fromRGB(45, 45, 45)
end)

-- Kill Aura Slider
local rL = Instance.new("TextLabel", Main)
rL.Size = UDim2.new(0, 300, 0, 20); rL.Position = UDim2.new(0.5, -150, 0, 180); rL.Text = "Aura Range: "..ka_range; rL.TextColor3 = Color3.new(1, 1, 1); rL.BackgroundTransparency = 1

local SB = Instance.new("Frame", Main)
SB.Size = UDim2.new(0, 260, 0, 8); SB.Position = UDim2.new(0.5, -130, 0, 210); SB.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
local SK = Instance.new("TextButton", SB)
SK.Size = UDim2.new(0, 20, 0, 20); SK.Position = UDim2.new(0, 0, 0.5, -10); SK.Text = ""; Instance.new("UICorner", SK).CornerRadius = UDim.new(1, 0)

-- [ 4. Logic Loops ]
task.spawn(function()
    while task.wait(0.1) do
        sL.Text = "Speed: [" .. ws_value .. "]"
        jL.Text = "Jump: [" .. jp_value .. "]"
        
        if ka_on then
            local char = LocalPlayer.Character
            if char and char:FindFirstChildOfClass("Tool") then
                for _, v in pairs(workspace:GetChildren()) do
                    if v:FindFirstChild("Humanoid") and v ~= char and v.Humanoid.Health > 0 then
                        local root = v:FindFirstChild("HumanoidRootPart")
                        if root and (char.HumanoidRootPart.Position - root.Position).Magnitude <= ka_range then
                            hitRemote:FireServer(v.Humanoid)
                        end
                    end
                end
            end
        end

        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = ws_value
            LocalPlayer.Character.Humanoid.JumpPower = jp_value
        end
    end
end)

-- Slider Drag
local dragS = false
SK.MouseButton1Down:Connect(function() dragS = true end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragS = false end end)
UserInputService.InputChanged:Connect(function(i)
    if dragS and i.UserInputType == Enum.UserInputType.MouseMovement then
        local p = math.clamp((i.Position.X - SB.AbsolutePosition.X) / SB.AbsoluteSize.X, 0, 1)
        SK.Position = UDim2.new(p, -10, 0.5, -10)
        ka_range = math.floor(1 + (p * 499))
        rL.Text = "Aura Range: " .. ka_range
    end
end)

-- Orb & RGB
Orb.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
task.spawn(function() while task.wait() do OrbStroke.Color = Color3.fromHSV(tick()%5/5, 1, 1) end end)

-- Draggable
local oD, oS, oP
Orb.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then oD = true oS = i.Position oP = Orb.Position end end)
UserInputService.InputChanged:Connect(function(i) if oD and i.UserInputType == Enum.UserInputType.MouseMovement then
    local d = i.Position - oS
    Orb.Position = UDim2.new(oP.X.Scale, oP.X.Offset + d.X, oP.Y.Scale, oP.Y.Offset + d.Y)
end end)
Orb.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then oD = false end end)
