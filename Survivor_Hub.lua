--[[
    ====================================================================================================
    PROJECT: NAMMON SPY V11.8 (THE TITAN EDITION)
    DEVELOPER: AI BROTHER FOR NAMMON (น้ำมนต์)
    VERSION: 11.8 [ฉบับประกอบร่างสมบูรณ์ 360+ บรรทัด]
    ====================================================================================================
    📜 DESCRIPTION:
    สคริปต์นี้ถูกออกแบบมาเพื่อแมพซอมบี้เวฟมนุษย์โดยเฉพาะ (Ball TD)
    รวมทุกฟังก์ชัน: Full Bright, ESP ชื่อเขียว, God Shield, Kill Aura และ UI ลื่นไหล
    ====================================================================================================
]]

-- [[ 1. SERVICE INITIALIZATION - การเรียกใช้บริการจากระบบ ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- [[ 2. GLOBAL CONFIGURATION - การตั้งค่าเริ่มต้น ]] --
local WalkSpeedValue = 16    
local JumpPowerValue = 50    
local KillAuraRange = 25
local IsKillAuraEnabled = false
local IsEspEnabled = false
local IsFullBrightEnabled = false
local IsSlowFallEnabled = true
local AntiVoidLevel = -100
local RainbowColor = Color3.new(1, 1, 1)

-- [[ 3. ULTIMATE BYPASS SYSTEM - ระบบเจาะจงและดักจับข้อมูล ]] --
-- ค้นหา Remotes ที่จำเป็นต้องใช้ในแมพนี้
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local HitRemote = Remotes:WaitForChild("Hit")
local FallDamageRemote = Remotes:WaitForChild("FallDamage")

-- การใช้ Metamethod เพื่อบล็อกข้อมูลดาเมจจากการตก
local OldNamecall
OldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local Method = getnamecallmethod()
    local Args = {...}
    
    -- ถ้าเกมพยายามส่งข้อมูลว่าเราตกที่สูง ให้บล็อกทิ้ง (Return nil)
    if self == FallDamageRemote and Method == "FireServer" then
        return nil 
    end
    
    return OldNamecall(self, ...)
end)

-- [[ 4. VISION & LIGHTING SYSTEM - ระบบการมองเห็น ]] --
-- ฟังก์ชันปรับแสงสว่างแบบเรียลไทม์ (Full Bright)
RunService.RenderStepped:Connect(function()
    if IsFullBrightEnabled then
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        Lighting.Brightness = 2.5
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 100000 -- ไล่หมอกออกไปให้หมด
    else
        Lighting.GlobalShadows = true
    end
    
    -- คำนวณสีรุ้ง (Rainbow RGB) สำหรับ UI
    local Hue = tick() % 5 / 5
    RainbowColor = Color3.fromHSV(Hue, 1, 1)
end)

-- [[ 5. MOVEMENT & PROTECTION - ระบบเคลื่อนที่และป้องกันตัว ]] --
RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local Root = LocalPlayer.Character.HumanoidRootPart
        local Hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        
        -- ระบบ Slow Fall: ตรวจจับสถานะการร่วง (Freefall)
        if IsSlowFallEnabled and Hum and Hum:GetState() == Enum.HumanoidStateType.Freefall then
            if Root.AssemblyLinearVelocity.Y < -5 then
                -- ล็อกความเร็วการตกให้คงที่และปลอดภัย
                Root.AssemblyLinearVelocity = Vector3.new(
                    Root.AssemblyLinearVelocity.X, 
                    -10, 
                    Root.AssemblyLinearVelocity.Z
                )
            end
        end
        
        -- ระบบ Anti-Void: กันตกทะลุโลก
        if Root.Position.Y < AntiVoidLevel then
            Root.CFrame = CFrame.new(Root.Position.X, 50, Root.Position.Z)
            Root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        end
    end
end)

-- [[ 6. ESP SCANNER SYSTEM - ระบบสแกนหาซอมบี้ชื่อเขียว ]] --
local function ApplyHighlight(TargetPlayer)
    local function CreateHighlight(Character)
        -- รอให้ตัวละครโหลดเสร็จสักครู่เพื่อกันสคริปต์หลุด
        task.wait(0.7)
        if Character:FindFirstChild("NammonHighlight") then 
            Character.NammonHighlight:Destroy() 
        end
        
        local Highlight = Instance.new("Highlight", Character)
        Highlight.Name = "NammonHighlight"
        Highlight.FillTransparency = 0.5
        Highlight.OutlineTransparency = 0
        
        RunService.RenderStepped:Connect(function()
            if not Character or not Character:Parent() or not IsEspEnabled then 
                Highlight.Enabled = false 
                return 
            end
            Highlight.Enabled = true
            
            local IsZombie = false
            -- ตรวจสอบจากชื่อสีเขียวตามที่น้ำมนต์บอก (Green Name = Zombie)
            local Head = Character:FindFirstChild("Head")
            if Head then
                for _, v in pairs(Head:GetDescendants()) do
                    if v:IsA("TextLabel") then
                        -- ตรวจจับค่าสีเขียว (G) ที่สูงกว่าสีแดง (R) และน้ำเงิน (B)
                        if v.TextColor3.G > 0.8 and v.TextColor3.R < 0.3 and v.TextColor3.B < 0.3 then
                            IsZombie = true
                            break
                        end
                    end
                end
            end
            
            -- การแสดงผลสีออร่า
            if IsZombie then
                Highlight.OutlineColor = Color3.fromRGB(255, 0, 0) -- ซอมบี้ = แดง
                Highlight.FillColor = Color3.fromRGB(255, 0, 0)
            else
                Highlight.OutlineColor = Color3.fromRGB(0, 255, 0) -- คนปกติ = เขียว
                Highlight.FillColor = Color3.fromRGB(0, 255, 0)
            end
        end)
    end
    
    TargetPlayer.CharacterAdded:Connect(CreateHighlight)
    if TargetPlayer.Character then CreateHighlight(TargetPlayer.Character) end
end

-- รันระบบ ESP สำหรับผู้เล่นทุกคนในเซิร์ฟเวอร์
for _, p in pairs(Players:GetPlayers()) do 
    if p ~= LocalPlayer then ApplyHighlight(p) end 
end
Players.PlayerAdded:Connect(ApplyHighlight)

-- [[ 7. COMBAT SYSTEM - ระบบการต่อสู้ (Kill Aura 360) ]] --
task.spawn(function()
    while true do
        task.wait(0.1)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            local Hum = LocalPlayer.Character.Humanoid
            
            -- ปรับค่าความเร็วและแรงกระโดดตามน้ำมนต์สั่ง
            Hum.WalkSpeed = WalkSpeedValue
            Hum.JumpPower = JumpPowerValue
            Hum.UseJumpPower = true
            
            -- ระบบตบอัตโนมัติ (ตรวจสอบว่าถืออาวุธอยู่หรือไม่)
            if IsKillAuraEnabled and LocalPlayer.Character:FindFirstChildOfClass("Tool") then
                for _, Target in pairs(workspace:GetChildren()) do
                    if Target:FindFirstChild("Humanoid") and Target ~= LocalPlayer.Character and Target.Humanoid.Health > 0 then
                        local T_Root = Target:FindFirstChild("HumanoidRootPart")
                        local P_Root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        
                        if T_Root and P_Root then
                            local Distance = (P_Root.Position - T_Root.Position).Magnitude
                            if Distance <= KillAuraRange then
                                -- ส่งสัญญาณการโจมตีไปยังเซิร์ฟเวอร์
                                HitRemote:FireServer(Target.Humanoid)
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- [[ 8. USER INTERFACE (UI) - ระบบหน้าต่างเมนู SPY ]] --
local ScreenGui = Instance.new("ScreenGui", (gethui and gethui()) or game:GetService("CoreGui"))
ScreenGui.Name = "NammonSpyGUI"
ScreenGui.ResetOnSpawn = false

-- ปุ่มลูกแก้วเปิด/ปิด (The Orb)
local Orb = Instance.new("ImageButton", ScreenGui)
Orb.Name = "SpyOrb"
Orb.Size = UDim2.new(0, 70, 0, 70)
Orb.Position = UDim2.new(0, 30, 0.5, -35)
Orb.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Orb.Image = "rbxassetid://10827222859" -- ไอคอน Spy
local OrbCorner = Instance.new("UICorner", Orb)
OrbCorner.CornerRadius = UDim.new(1, 0)
local OrbStroke = Instance.new("UIStroke", Orb)
OrbStroke.Thickness = 4
OrbStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- หน้าต่างเมนูหลัก (Main Frame)
local Main = Instance.new("Frame", ScreenGui)
Main.Name = "MainFrame"
Main.Size = UDim2.new(0, 380, 0, 520)
Main.Position = UDim2.new(0.5, -190, 0.5, -260)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Main.Visible = false
local MainCorner = Instance.new("UICorner", Main)
MainCorner.CornerRadius = UDim.new(0, 20)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Thickness = 5

-- แถบเลื่อนฟังก์ชัน (Scrolling Content)
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -30, 1, -60)
Scroll.Position = UDim2.new(0, 15, 0, 30)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 5
Scroll.CanvasSize = UDim2.new(0, 0, 6, 0)
local UIList = Instance.new("UIListLayout", Scroll)
UIList.Padding = UDim.new(0, 20)
UIList.HorizontalAlignment = "Center"

-- ฟังก์ชันสร้างปุ่มปรับค่า (Speed/Jump/Range)
local function CreateAdjuster(Title, Step, Callback)
    local Frame = Instance.new("Frame", Scroll)
    Frame.Size = UDim2.new(0, 330, 0, 75)
    Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Instance.new("UICorner", Frame)
    
    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Color3.new(1, 1, 1)
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 18
    
    local Minus = Instance.new("TextButton", Frame)
    Minus.Size = UDim2.new(0, 60, 0, 50)
    Minus.Position = UDim2.new(0, 10, 0.5, -25)
    Minus.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    Minus.Text = "-"
    Minus.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", Minus)
    
    local Plus = Instance.new("TextButton", Frame)
    Plus.Size = UDim2.new(0, 60, 0, 50)
    Plus.Position = UDim2.new(1, -70, 0.5, -25)
    Plus.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    Plus.Text = "+"
    Plus.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", Plus)
    
    Minus.MouseButton1Click:Connect(function() Callback(-Step) end)
    Plus.MouseButton1Click:Connect(function() Callback(Step) end)
    return Label
end

-- สร้างปุ่มตามสั่งน้ำมนต์ (Speed +1 / Jump +5)
local SpeedLabel = CreateAdjuster("Speed", 1, function(v) WalkSpeedValue = math.max(0, WalkSpeedValue + v) end)
local JumpLabel = CreateAdjuster("Jump", 5, function(v) JumpPowerValue = math.max(0, JumpPowerValue + v) end)
local RangeLabel = CreateAdjuster("Aura Range", 5, function(v) KillAuraRange = math.max(0, KillAuraRange + v) end)

-- ฟังก์ชันสร้างปุ่มเปิด/ปิด (Toggle)
local function CreateToggle(Title, InitState, Callback)
    local Button = Instance.new("TextButton", Scroll)
    Button.Size = UDim2.new(0, 330, 0, 60)
    Button.BackgroundColor3 = InitState and Color3.fromRGB(255, 120, 0) or Color3.fromRGB(0, 130, 220)
    Button.Text = Title
    Button.TextColor3 = Color3.new(1, 1, 1)
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 18
    Instance.new("UICorner", Button)
    
    local State = InitState
    Button.MouseButton1Click:Connect(function()
        State = not State
        Button.BackgroundColor3 = State and Color3.fromRGB(255, 120, 0) or Color3.fromRGB(0, 130, 220)
        Callback(State)
    end)
end

-- สร้าง Toggles ต่างๆ
CreateToggle("👁️ ESP (Zombie Name Color Fix)", false, function(s) IsEspEnabled = s end)
CreateToggle("🛡️ God Shield (Anti-Fall Mode)", true, function(s) IsSlowFallEnabled = s end)
CreateToggle("⚔️ Enable Kill Aura 360", false, function(s) IsKillAuraEnabled = s end)
CreateToggle("☀️ Full Bright (Day Mode)", false, function(s) IsFullBrightEnabled = s end)

-- [[ 9. UI UPDATE & DRAG LOGIC - ระบบอัปเดตและลากเมนู ]] --
RunService.RenderStepped:Connect(function()
    SpeedLabel.Text = "WalkSpeed: [" .. WalkSpeedValue .. "]"
    JumpLabel.Text = "JumpPower: [" .. JumpPowerValue .. "]"
    RangeLabel.Text = "Aura Range: [" .. KillAuraRange .. "]"
    
    -- อัปเดตสี RGB
    OrbStroke.Color = RainbowColor
    MainStroke.Color = RainbowColor
end)

-- ระบบลากลูกแก้ว (Draggable Logic)
local Dragging, DragInput, DragStart, StartPos
Orb.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true; DragStart = input.Position; StartPos = Orb.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local Delta = input.Position - DragStart
        Orb.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = false
    end
end)

-- ปุ่มเปิด/ปิดเมนู
Orb.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- แจ้งเตือนเมื่อโหลดเสร็จ
print("========================================")
print("NAMMON SPY V11.8 LOADED SUCCESSFULLY!")
print("========================================")
