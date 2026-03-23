--[[
    ========================================================================
    PROJECT: NAMMON SPY V10.8 (ANTI-VOID & FULL MAMMOTH)
    DEVELOPER: AI BROTHER FOR NAMMON (น้ำมนต์)
    VERSION: 10.8 (THE LONGEST & MOST STABLE)
    ========================================================================
    DESCRIPTION:
    สคริปต์นี้ถูกเขียนขึ้นเพื่อน้ำมนต์โดยเฉพาะ เน้นความยาวและอ่านง่าย (Full Block)
    - ระบบกันตกทะลุแมพ (Anti-Void TP)
    - ระบบลอยตัวตกช้า (Slow Fall Glide)
    - ระบบกันดาเมจตกจากที่สูง (No Fall Damage Bypass)
    - ระบบมองทะลุออร่าเรืองแสงรอบตัว (Neon Highlight ESP)
    - ระบบปรับความเร็ว (WalkSpeed Adjuster + / -)
    - ระบบปรับแรงกระโดด (JumpPower Adjuster + / -)
    - ระบบปรับระยะตบ (Kill Aura Range Adjuster + / -)
    - ปุ่มเปิด-ปิด Kill Aura แยกต่างหาก
    - ลูกแก้วปกสปาย RGB (Spy Orb Sphere)
    ========================================================================
]]

-- [[ การเรียกใช้ SERVICES พื้นฐาน ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- [[ การตั้งค่าตัวแปร (CONFIGURATION) ]] --
local WalkSpeedValue = 46
local JumpPowerValue = 250
local KillAuraRange = 25
local IsKillAuraEnabled = false
local IsEspEnabled = false
local IsSlowFallEnabled = true
local AntiVoidLevel = -100 -- ระดับความลึกที่จะให้วาร์ปกลับขึ้นมา

-- [[ การเข้าถึง REMOTES ของเกม ]] --
local RemotesFolder = ReplicatedStorage:WaitForChild("Remotes")
local HitRemote = RemotesFolder:WaitForChild("Hit")
local FallDamageRemote = RemotesFolder:WaitForChild("FallDamage")

-- [[ 1. ระบบ NO FALL DAMAGE BYPASS (ระดับลึก) ]] --
-- บล็อกการส่งข้อมูลความเสียหายจากการตกไปที่เซิร์ฟเวอร์
local OldMetatableNamecall
OldMetatableNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local Method = getnamecallmethod()
    
    -- ตรวจสอบว่าเป็น Remote กันตกตึกหรือไม่
    if self == FallDamageRemote and Method == "FireServer" then
        -- ถ้าใช่ ให้หยุดการทำงานทันที (Return nil)
        return nil 
    end
    
    return OldMetatableNamecall(self, ...)
end)

-- [[ 2. ระบบ SLOW FALL & ANTI-VOID (กันร่วงช้าและกันตกแมพ) ]] --
RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local RootPart = LocalPlayer.Character.HumanoidRootPart
        local Humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        
        -- ส่วนที่ 1: ระบบร่วงช้า (Slow Fall)
        if IsSlowFallEnabled then
            if Humanoid and Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
                -- ถ้ากำลังร่วงเร็วเกินไป ให้เบรกความเร็วไว้ที่ -10
                if RootPart.AssemblyLinearVelocity.Y < -10 then
                    RootPart.AssemblyLinearVelocity = Vector3.new(
                        RootPart.AssemblyLinearVelocity.X, 
                        -10, 
                        RootPart.AssemblyLinearVelocity.Z
                    )
                end
            end
        end
        
        -- ส่วนที่ 2: ระบบกันตกทะลุแมพ (Anti-Void)
        if RootPart.Position.Y < AntiVoidLevel then
            -- ถ้าน้ำมนต์ร่วงลึกเกินไป ให้วาร์ปกลับขึ้นมาที่ความสูง 50 ทันที
            RootPart.CFrame = CFrame.new(RootPart.Position.X, 50, RootPart.Position.Z)
            RootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        end
    end
end)

-- [[ 3. ระบบ NEON HIGHLIGHT ESP (ออร่าเรืองแสงรอบอวตาร) ]] --
local function ApplyHighlight(TargetPlayer)
    local function CreateHighlight(Character)
        -- รอตัวละครโหลด
        task.wait(0.6)
        
        -- ล้างค่าเก่า
        if Character:FindFirstChild("NammonHighlight") then
            Character.NammonHighlight:Destroy()
        end
        
        -- สร้างออร่าเรืองแสงรอบตัว (Highlight)
        local Highlight = Instance.new("Highlight")
        Highlight.Name = "NammonHighlight"
        Highlight.Parent = Character
        Highlight.Adornee = Character
        Highlight.FillTransparency = 0.5
        Highlight.OutlineTransparency = 0
        Highlight.OutlineColor = Color3.fromRGB(0, 255, 0)
        
        -- อัปเดตสถานะสีตามประเภทตัวละคร
        RunService.RenderStepped:Connect(function()
            if not Character or not Character:Parent() or not IsEspEnabled then
                Highlight.Enabled = false
                return
            end
            
            Highlight.Enabled = true
            local IsZombie = false
            
            -- สแกนหาโมเดลซอมบี้
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
            
            -- ปรับสี (แดง = ซอมบี้, เขียว = คน)
            if IsZombie then
                Highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
                Highlight.FillColor = Color3.fromRGB(255, 0, 0)
            else
                Highlight.OutlineColor = Color3.fromRGB(0, 255, 0)
                Highlight.FillColor = Color3.fromRGB(0, 255, 0)
            end
        end)
    end
    
    TargetPlayer.CharacterAdded:Connect(CreateHighlight)
    if TargetPlayer.Character then
        CreateHighlight(TargetPlayer.Character)
    end
end

-- สแกนผู้เล่นทุกคนในเซิร์ฟเวอร์
for _, OtherPlayer in pairs(Players:GetPlayers()) do
    if OtherPlayer ~= LocalPlayer then
        ApplyHighlight(OtherPlayer)
    end
end
Players.PlayerAdded:Connect(ApplyHighlight)

-- [[ 4. MAIN LOOP SYSTEM (SPEED, JUMP & KILL AURA) ]] --
task.spawn(function()
    while true do
        task.wait(0.1)
        
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            -- อัปเดตสเตตัสพื้นฐาน
            local Hum = LocalPlayer.Character.Humanoid
            Hum.WalkSpeed = WalkSpeedValue
            Hum.JumpPower = JumpPowerValue
            Hum.UseJumpPower = true
            
            -- ระบบตบอัตโนมัติ (Kill Aura)
            if IsKillAuraEnabled then
                local Tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if Tool then
                    for _, Target in pairs(workspace:GetChildren()) do
                        if Target:FindFirstChild("Humanoid") and Target ~= LocalPlayer.Character then
                            local T_Root = Target:FindFirstChild("HumanoidRootPart")
                            local P_Root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                            
                            if T_Root and P_Root then
                                local Distance = (P_Root.Position - T_Root.Position).Magnitude
                                if Distance <= KillAuraRange and Target.Humanoid.Health > 0 then
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

-- [[ 5. ระบบโครงสร้าง UI (RGB & SPY ICON) ]] --
local ScreenGui = Instance.new("ScreenGui", (gethui and gethui()) or CoreGui)
ScreenGui.Name = "NAMMON_SPY_V10_8"
ScreenGui.ResetOnSpawn = false

-- สร้างลูกแก้วสายลับ (Spy Orb)
local Orb = Instance.new("ImageButton", ScreenGui)
Orb.Name = "SpyOrb"
Orb.Size = UDim2.new(0, 65, 0, 65)
Orb.Position = UDim2.new(0, 20, 0.5, 0)
Orb.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Orb.Image = "rbxassetid://10827222859"
local OrbCorner = Instance.new("UICorner", Orb)
OrbCorner.CornerRadius = UDim.new(1, 0)
local OrbStroke = Instance.new("UIStroke", Orb)
OrbStroke.Thickness = 3

-- สร้างหน้าต่างเมนูหลัก
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 380, 0, 450)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Visible = false
local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 15)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Thickness = 4

-- พื้นที่ Scrolling สำหรับใส่ฟังก์ชันเยอะๆ
local ScrollFrame = Instance.new("ScrollingFrame", MainFrame)
ScrollFrame.Size = UDim2.new(1, -20, 1, -40)
ScrollFrame.Position = UDim2.new(0, 10, 0, 20)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.CanvasSize = UDim2.new(0, 0, 4.5, 0) -- ขยายให้ยาวทะลุใจ
ScrollFrame.ScrollBarThickness = 5
local UIList = Instance.new("UIListLayout", ScrollFrame)
UIList.Padding = UDim.new(0, 15)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- [[ ฟังก์ชันสร้างตัวปรับค่าแบบแยกบรรทัด (ADJUSTERS) ]] --
local function CreateAdjuster(Title, StartVal, Step, Callback)
    local Frame = Instance.new("Frame", ScrollFrame)
    Frame.Size = UDim2.new(0, 330, 0, 70)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Instance.new("UICorner", Frame)
    
    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Color3.new(1, 1, 1)
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 16
    Label.Text = Title .. ": [" .. StartVal .. "]"
    
    local Minus = Instance.new("TextButton", Frame)
    Minus.Size = UDim2.new(0, 55, 0, 45)
    Minus.Position = UDim2.new(0, 10, 0.5, -22.5)
    Minus.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    Minus.Text = "-"
    Minus.TextColor3 = Color3.new(1, 1, 1)
    Minus.Font = Enum.Font.GothamBold
    Instance.new("UICorner", Minus)
    
    local Plus = Instance.new("TextButton", Frame)
    Plus.Size = UDim2.new(0, 55, 0, 45)
    Plus.Position = UDim2.new(1, -65, 0.5, -22.5)
    Plus.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    Plus.Text = "+"
    Plus.TextColor3 = Color3.new(1, 1, 1)
    Plus.Font = Enum.Font.GothamBold
    Instance.new("UICorner", Plus)
    
    Minus.MouseButton1Click:Connect(function() Callback(-Step) end)
    Plus.MouseButton1Click:Connect(function() Callback(Step) end)
    
    return Label
end

-- สร้างปุ่มปรับแต่ง 3 อย่างหลัก
local WS_Display = CreateAdjuster("WalkSpeed (ความเร็ว)", WalkSpeedValue, 2, function(D)
    WalkSpeedValue = math.max(0, WalkSpeedValue + D)
end)

local JP_Display = CreateAdjuster("JumpPower (แรงกระโดด)", JumpPowerValue, 10, function(D)
    JumpPowerValue = math.max(0, JumpPowerValue + D)
end)

local KA_Display = CreateAdjuster("Kill Aura Range (ระยะตบ)", KillAuraRange, 5, function(D)
    KillAuraRange = math.max(0, KillAuraRange + D)
end)

-- [[ ฟังก์ชันสร้างปุ่มเปิด-ปิด (TOGGLES) ]] --
local function CreateToggle(LabelText, Action)
    local Button = Instance.new("TextButton", ScrollFrame)
    Button.Size = UDim2.new(0, 330, 0, 55)
    Button.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
    Button.Text = LabelText
    Button.TextColor3 = Color3.new(1, 1, 1)
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 16
    Instance.new("UICorner", Button)
    
    local Active = false
    -- ตั้งค่าเริ่มต้นสำหรับ Slow Fall
    if LabelText:find("Slow Fall") then 
        Active = true 
        Button.BackgroundColor3 = Color3.fromRGB(255, 100, 0) 
    end
    
    Button.MouseButton1Click:Connect(function()
        Active = not Active
        Button.BackgroundColor3 = Active and Color3.fromRGB(255, 100, 0) or Color3.fromRGB(0, 120, 200)
        Action(Active)
    end)
end

-- เพิ่มปุ่มฟังก์ชันต่างๆ
CreateToggle("👁️ Neon Highlight ESP", function(S) IsEspEnabled = S end)
CreateToggle("🪂 Slow Fall (Glide Mode)", function(S) IsSlowFallEnabled = S end)
CreateToggle("⚔️ Enable Kill Aura (Auto Slap)", function(S) IsKillAuraEnabled = S end)

-- [[ 6. ระบบ RGB & DRAGGABLE LOGIC ]] --
RunService.RenderStepped:Connect(function()
    -- อัปเดตตัวเลขใน UI ตลอดเวลา
    WS_Display.Text = "WalkSpeed: [" .. WalkSpeedValue .. "]"
    JP_Display.Text = "JumpPower: [" .. JumpPowerValue .. "]"
    KA_Display.Text = "Kill Aura Range: [" .. KillAuraRange .. "]"
    
    -- อะนิเมชั่นไฟ RGB วิ่งวน
    local Hue = tick() % 5 / 5
    local RGB = Color3.fromHSV(Hue, 1, 1)
    OrbStroke.Color = RGB
    MainStroke.Color = RGB
end)

-- ระบบลากลูกแก้วย้ายตำแหน่ง
local IsDragging, DragStartPos, StartFramePos
Orb.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
        IsDragging = true
        DragStartPos = Input.Position
        StartFramePos = Orb.Position
    end
end)

UserInputService.InputChanged:Connect(function(Input)
    if IsDragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
        local Delta = Input.Position - DragStartPos
        Orb.Position = UDim2.new(
            StartFramePos.X.Scale, 
            StartFramePos.X.Offset + Delta.X, 
            StartFramePos.Y.Scale, 
            StartFramePos.Y.Offset + Delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
        IsDragging = false
    end
end)

-- เปิด-ปิดเมนู
Orb.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)
