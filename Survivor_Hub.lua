--[[
    ============================================================
    PROJECT: NAMMON SPY V10.5 (MAMMOTH EDITION)
    DEVELOPER: AI BROTHER FOR NAMMON (น้ำมนต์)
    VERSION: 10.5 (STABLE & LONG VERSION)
    ============================================================
    DESCRIPTION:
    สคริปต์นี้ถูกเขียนแบบ Full Block เพื่อให้อ่านง่ายและเสถียรที่สุด
    โดยรวมทุกฟังก์ชันที่น้ำมนต์ต้องการไว้ในที่เดียว
    - ระบบไฟ RGB วิ่งรอบ UI และลูกแก้ว
    - รูปปกสปายในลูกแก้ว (Spy Icon)
    - ระบบลอยตัวตกช้า (Slow Fall / Glide)
    - ระบบกันดาเมจตกจากที่สูง (No Fall Damage)
    - ระบบมองทะลุแยกประเภทซอมบี้/คน (Selective ESP)
    - ระบบปรับความเร็วและแรงกระโดด (Movement)
    - ระบบตบอัตโนมัติ (Kill Aura)
    ============================================================
]]

-- [ การประกาศตัวแปรเบื้องต้น ] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- [ การตั้งค่าเริ่มต้น (Configuration) ] --
local WalkSpeedValue = 46
local JumpPowerValue = 250
local KillAuraRange = 25
local IsNoclipEnabled = false
local IsEspEnabled = false
local IsSlowFallEnabled = true -- เปิดโหมดตกช้าไว้เป็นพื้นฐาน

-- [ การเชื่อมต่อ Remotes ของเกม ] --
local RemotesFolder = ReplicatedStorage:WaitForChild("Remotes")
local HitRemote = RemotesFolder:WaitForChild("Hit")
local FallDamageRemote = RemotesFolder:WaitForChild("FallDamage")

-- [[ 1. ระบบ NO FALL DAMAGE BYPASS ]] --
-- ดักฟัง Namecall เพื่อบล็อกการส่งดาเมจตกจากที่สูงไปหาเซิร์ฟเวอร์
local OldMetatableNamecall
OldMetatableNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local MethodName = getnamecallmethod()
    
    -- ถ้าเกมพยายามจะส่งข้อมูลดาเมจตกจากที่สูงมาที่นี่ เราจะหยุดมันทันที
    if self == FallDamageRemote and MethodName == "FireServer" then
        return nil 
    end
    
    return OldMetatableNamecall(self, ...)
end)

-- [[ 2. ระบบ SLOW FALL (ลอยตัวตกช้าๆ เหมือนกางร่ม) ]] --
-- ระบบนี้จะทำงานตลอดเวลาเมื่อเราอยู่กลางอากาศ
RunService.Heartbeat:Connect(function()
    if IsSlowFallEnabled then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local RootPart = LocalPlayer.Character.HumanoidRootPart
            local Humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            
            -- ตรวจสอบว่าตัวละครกำลังร่วง (Freefall) หรือไม่
            if Humanoid and Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
                -- ถ้าความเร็วการร่วง (Y Velocity) เกินกว่าที่กำหนด (ตกเร็วเกินไป)
                if RootPart.AssemblyLinearVelocity.Y < -10 then
                    -- บังคับให้ความเร็วคงที่ที่ -10 เพื่อให้ตัวละครค่อยๆ ลอยลงมา
                    RootPart.AssemblyLinearVelocity = Vector3.new(
                        RootPart.AssemblyLinearVelocity.X, 
                        -10, 
                        RootPart.AssemblyLinearVelocity.Z
                    )
                end
            end
        end
    end
end)

-- [[ 3. ระบบ MOVEMENT & KILL AURA LOOP ]] --
-- ใช้ Task Spawn เพื่อแยกการทำงานออกมาไม่ให้ไปรบกวนส่วนอื่น
task.spawn(function()
    while true do
        task.wait(0.1)
        
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            -- อัปเดตความเร็วการวิ่ง
            LocalPlayer.Character.Humanoid.WalkSpeed = WalkSpeedValue
            
            -- อัปเดตแรงกระโดด
            LocalPlayer.Character.Humanoid.JumpPower = JumpPowerValue
            LocalPlayer.Character.Humanoid.UseJumpPower = true
            
            -- ระบบ Kill Aura (ตบอัตโนมัติรอบตัว)
            local CurrentTool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if CurrentTool then
                for _, Target in pairs(workspace:GetChildren()) do
                    if Target:FindFirstChild("Humanoid") and Target ~= LocalPlayer.Character then
                        if Target.Humanoid.Health > 0 then
                            local TargetRoot = Target:FindFirstChild("HumanoidRootPart")
                            local PlayerRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                            
                            if TargetRoot and PlayerRoot then
                                local Distance = (PlayerRoot.Position - TargetRoot.Position).Magnitude
                                if Distance <= KillAuraRange then
                                    -- ส่งคำสั่งตบไปที่เซิร์ฟเวอร์
                                    HitRemote:FireServer(Target.Humanoid)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- [[ 4. ระบบ SELECTIVE ESP (มองทะลุแยกประเภท) ]] --
local function ApplyESP(TargetPlayer)
    local function CreateESP(Character)
        -- รอให้ตัวละครโหลดเสร็จสักครู่
        task.wait(0.5)
        
        -- ถ้ามี ESP เก่าอยู่ให้ลบทิ้งก่อน
        if Character:FindFirstChild("NammonESP") then
            Character.NammonESP:Destroy()
        end
        
        -- สร้าง BillboardGui เพื่อโชว์บนหัว
        local Billboard = Instance.new("BillboardGui", Character)
        Billboard.Name = "NammonESP"
        Billboard.Size = UDim2.new(4, 0, 5, 0)
        Billboard.AlwaysOnTop = true
        Billboard.Adornee = Character:FindFirstChild("HumanoidRootPart")
        
        -- สร้างกรอบ ESP
        local Frame = Instance.new("Frame", Billboard)
        Frame.Size = UDim2.new(1, 0, 1, 0)
        Frame.BackgroundTransparency = 1
        
        -- เส้นขอบ ESP
        local Stroke = Instance.new("UIStroke", Frame)
        Stroke.Thickness = 2
        Stroke.Color = Color3.fromRGB(0, 255, 0)
        
        -- ชื่อและสถานะเลือด
        local Label = Instance.new("TextLabel", Frame)
        Label.Size = UDim2.new(1, 0, 0, 20)
        Label.Position = UDim2.new(0, 0, 1, 5)
        Label.BackgroundTransparency = 1
        Label.Font = Enum.Font.GothamBold
        Label.TextSize = 14
        Label.TextColor3 = Color3.new(1, 1, 1)
        
        -- ลูปตรวจสอบสถานะซอมบี้/คน ตลอดเวลา
        RunService.RenderStepped:Connect(function()
            if not Character or not Character:Parent() or not IsEspEnabled then
                Frame.Visible = false
                return
            end
            
            Frame.Visible = true
            local IsZombie = false
            
            -- ตรวจสอบจากการสแกนโมเดล (Zombie Identification)
            for _, Object in pairs(Character:GetChildren()) do
                if Object:IsA("CharacterMesh") then
                    if Object.MeshId == 271114115 or Object.MeshId == 271118539 then
                        IsZombie = true
                        break
                    end
                end
                if Object.Name:lower():find("zombie") then
                    IsZombie = true
                    break
                end
            end
            
            -- ปรับสีตามประเภท
            if IsZombie then
                Stroke.Color = Color3.fromRGB(255, 0, 0)
                Label.TextColor3 = Color3.fromRGB(255, 0, 0)
                Label.Text = "🧟 " .. TargetPlayer.Name .. " [" .. math.floor(Character.Humanoid.Health) .. "]"
            else
                Stroke.Color = Color3.fromRGB(0, 255, 0)
                Label.TextColor3 = Color3.fromRGB(0, 255, 0)
                Label.Text = "👤 " .. TargetPlayer.Name .. " [" .. math.floor(Character.Humanoid.Health) .. "]"
            end
        end)
    end
    
    TargetPlayer.CharacterAdded:Connect(CreateESP)
    if TargetPlayer.Character then
        CreateESP(TargetPlayer.Character)
    end
end

-- รัน ESP สำหรับทุกคนในห้อง
for _, OtherPlayer in pairs(Players:GetPlayers()) do
    if OtherPlayer ~= LocalPlayer then
        ApplyESP(OtherPlayer)
    end
end
Players.PlayerAdded:Connect(ApplyESP)

-- [[ 5. ระบบ UI CONSTRUCTION (RGB & SPY ICON) ]] --
local ScreenGui = Instance.new("ScreenGui", (gethui and gethui()) or game:GetService("CoreGui"))
ScreenGui.Name = "NAMMON_SPY_V10_5"
ScreenGui.ResetOnSpawn = false

-- สร้างลูกแก้ว (Orb) พร้อมรูปสปาย
local Orb = Instance.new("ImageButton", ScreenGui)
Orb.Name = "SpyOrb"
Orb.Size = UDim2.new(0, 65, 0, 65)
Orb.Position = UDim2.new(0, 20, 0.5, 0)
Orb.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Orb.Image = "rbxassetid://10827222859" -- ไอคอนสปายสุดเท่
local OrbCorner = Instance.new("UICorner", Orb)
OrbCorner.CornerRadius = UDim.new(1, 0)
local OrbStroke = Instance.new("UIStroke", Orb)
OrbStroke.Thickness = 3

-- สร้างหน้าต่างเมนูหลัก
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 360, 0, 350)
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Visible = false
local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 15)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Thickness = 4

-- พื้นที่สำหรับเลื่อน (Scrolling Frame)
local Scroll = Instance.new("ScrollingFrame", MainFrame)
Scroll.Size = UDim2.new(1, -20, 1, -40)
Scroll.Position = UDim2.new(0, 10, 0, 20)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 3, 0)
Scroll.ScrollBarThickness = 4
local UIList = Instance.new("UIListLayout", Scroll)
UIList.Padding = UDim.new(0, 15)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- ฟังก์ชันสร้างปุ่มปรับค่าแบบอลังการ
local function CreateAdjuster(Title, StartValue, Increment, Callback)
    local Container = Instance.new("Frame", Scroll)
    Container.Size = UDim2.new(0, 320, 0, 65)
    Container.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Instance.new("UICorner", Container)
    
    local Label = Instance.new("TextLabel", Container)
    Label.Size = UDim2.new(1, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Color3.new(1, 1, 1)
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 16
    Label.Text = Title .. ": [" .. StartValue .. "]"
    
    local MinusBtn = Instance.new("TextButton", Container)
    MinusBtn.Size = UDim2.new(0, 50, 0, 40)
    MinusBtn.Position = UDim2.new(0, 10, 0.5, -20)
    MinusBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    MinusBtn.Text = "-"
    MinusBtn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", MinusBtn)
    
    local PlusBtn = Instance.new("TextButton", Container)
    PlusBtn.Size = UDim2.new(0, 50, 0, 40)
    PlusBtn.Position = UDim2.new(1, -60, 0.5, -20)
    PlusBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    PlusBtn.Text = "+"
    PlusBtn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", PlusBtn)
    
    MinusBtn.MouseButton1Click:Connect(function() Callback(-Increment) end)
    PlusBtn.MouseButton1Click:Connect(function() Callback(Increment) end)
    return Label
end

-- สร้างปุ่มปรับแต่งต่างๆ
local WalkSpeedLabel = CreateAdjuster("WalkSpeed", WalkSpeedValue, 2, function(Delta)
    WalkSpeedValue = math.max(0, WalkSpeedValue + Delta)
end)

local JumpPowerLabel = CreateAdjuster("JumpPower", JumpPowerValue, 10, function(Delta)
    JumpPowerValue = math.max(0, JumpPowerValue + Delta)
end)

-- ฟังก์ชันสร้างปุ่มเปิด-ปิด (Toggle)
local function CreateToggle(Text, Callback)
    local ToggleBtn = Instance.new("TextButton", Scroll)
    ToggleBtn.Size = UDim2.new(0, 320, 0, 55)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
    ToggleBtn.Text = Text
    ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.TextSize = 16
    Instance.new("UICorner", ToggleBtn)
    
    local IsActive = false
    if Text:find("Slow Fall") then IsActive = true ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 0) end
    
    ToggleBtn.MouseButton1Click:Connect(function()
        IsActive = not IsActive
        ToggleBtn.BackgroundColor3 = IsActive and Color3.fromRGB(255, 100, 0) or Color3.fromRGB(0, 120, 200)
        Callback(IsActive)
    end)
end

CreateToggle("👁️ Selective ESP (Spy Eye)", function(State) IsEspEnabled = State end)
CreateToggle("🪂 Slow Fall (Gliding Mode)", function(State) IsSlowFallEnabled = State end)
CreateToggle("👻 Ghost Jump (No Walls)", function(State) IsNoclipEnabled = State end)

-- [[ 6. ระบบ RGB ANIMATION & DRAGGABLE ]] --
-- ลูปสำหรับไฟ RGB แบบสมูท
RunService.RenderStepped:Connect(function()
    WalkSpeedLabel.Text = "WalkSpeed: [" .. WalkSpeedValue .. "]"
    JumpPowerLabel.Text = "JumpPower: [" .. JumpPowerValue .. "]"
    
    local HueValue = tick() % 5 / 5
    local RGBColor = Color3.fromHSV(HueValue, 1, 1)
    
    OrbStroke.Color = RGBColor
    MainStroke.Color = RGBColor
end)

-- ระบบลากลูกแก้วไปมาบนหน้าจอ
local Dragging, DragInput, DragStart, StartPos
Orb.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = Input.Position
        StartPos = Orb.Position
        
        Input.Changed:Connect(function()
            if Input.UserInputState == Enum.UserInputState.End then
                Dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(Input)
    if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
        local Delta = Input.Position - DragStart
        Orb.Position = UDim2.new(
            StartPos.X.Scale, 
            StartPos.X.Offset + Delta.X, 
            StartPos.Y.Scale, 
            StartPos.Y.Offset + Delta.Y
        )
    end
end)

-- เปิด-ปิดหน้าต่างหลัก
Orb.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)
