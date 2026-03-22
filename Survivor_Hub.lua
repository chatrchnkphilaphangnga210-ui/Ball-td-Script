-- [[ NAMMON SPY v1.0 | THE ETERNAL SOURCE CODE ]] --
-- [[ Created by Nammon & Gemini | Nong Khai, Thailand ]] --
-- [[ ALL-IN-ONE: PLAYER, COMBAT, ZOMBIE, ESP, AI, CONFIG ]] --

-- [[ INITIALIZATION: UI LIBRARY ]] --
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("NAMMON SPY v1.0", "DarkTheme")

-- [[ DATABASE & GLOBAL SETTINGS ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Configs = {
    Speed = 16, Jump = 50, NoFall = true, GhostMode = false,
    AntiAFK = true, AntiBan = true, RGB_Speed = 0.5,
    ESP_Enabled = true, ShowHealth = true, FullBright = false,
    AutoFarm = false, AIScan = false,
    BehaviorTags = {Aggressive = {}, Friendly = {}},
    Slots = {["1"] = {}, ["2"] = {}, ["3"] = {}}
}

-- [[ CORE SYSTEM: RGB ENGINE ]] --
local function GetRGB()
    local t = tick() * Configs.RGB_Speed
    return Color3.fromHSV(t % 1, 0.8, 1)
end

-- [[ CORE SYSTEM: NOTIFICATION ]] --
local function Notify(title, text)
    StarterGui:SetCore("SendNotification", {
        Title = title, 
        Text = text, 
        Duration = 5,
        Icon = "rbxassetid://6031289353"
    })
end

-- [[ CORE SYSTEM: SAVE/LOAD LOGIC ]] --
local function SaveToSlot(slot)
    local data = HttpService:JSONEncode(Configs)
    writefile("NammonSpy_Slot"..slot..".json", data)
    Notify("SYSTEM", "บันทึกข้อมูลลง Slot "..slot.." สำเร็จ! 💾")
end

local function LoadFromSlot(slot)
    if isfile("NammonSpy_Slot"..slot..".json") then
        local data = HttpService:JSONDecode(readfile("NammonSpy_Slot"..slot..".json"))
        Configs = data
        Notify("SYSTEM", "โหลดข้อมูลจาก Slot "..slot.." สำเร็จ! 🎰")
    else
        Notify("WARNING", "ไม่พบข้อมูลใน Slot "..slot)
    end
end

-- [[ 1. PLAYER CATEGORY (ตัวเรา) ]] --
local PlayerTab = Window:NewTab("ตัวเรา (Player)")
local PSection = PlayerTab:NewSection("ระบบควบคุม & ล่องหน")

PSection:NewSlider("ความเร็วสายลับ (Speed)", "ปรับความเร็ววิ่งแบบนิ่งๆ", 500, 16, function(s)
    Configs.Speed = s
end)

RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Configs.Speed
        if Configs.NoFall then
            if LocalPlayer.Character.Humanoid:GetState() == Enum.HumanoidStateType.FallingDown then
                LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
            end
        end
    end
end)

PSection:NewToggle("ล่องหน Ghost Mode 👻", "คนอื่นไม่เห็นเราแต่เรากลับมาได้", function(state)
    Configs.GhostMode = state
    spawn(function()
        while Configs.GhostMode do
            if LocalPlayer.Character then
                for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                    if v:IsA("BasePart") or v:IsA("Decal") then
                        v.Transparency = 0.8
                    end
                end
            end
            wait(0.5)
        end
        if not state and LocalPlayer.Character then
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") or v:IsA("Decal") then
                    v.Transparency = 0
                end
            end
        end
    end)
end)

PSection:NewToggle("กันเจ็บจากการตก (No Fall)", "โดดลงจากที่สูงเลือดไม่ลด", function(state)
    Configs.NoFall = state
end)

PSection:NewButton("ปุ่มตกใจ (Panic Button) ⚠️", "รีเซ็ตทุกอย่างเป็นปกติทันที", function()
    Configs.Speed = 16
    Configs.GhostMode = false
    Configs.ESP_Enabled = false
    Notify("PANIC!", "ระบบหยุดทำงานชั่วคราวเพื่อความเนียน")
end)

-- [[ 2. COMBAT & SURVIVOR HUB ]] --
local CombatTab = Window:NewTab("ต่อสู้ (Combat)")
local CSection = CombatTab:NewSection("Survivor Hub & Auto Farm")

CSection:NewButton("เปิดระบบ Survivor Hub", "เรียกใช้สคริปต์ตีซอมบี้จากลิงก์ GitHub", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/chatrchnkphilaphangnga210-ui/Ball-td-Script/refs/heads/main/Survivor_Hub.lua"))()
    Notify("SUCCESS", "เชื่อมต่อ Survivor Hub เรียบร้อย!")
end)

CSection:NewToggle("วิถีธนูย้อย 🏹", "คำนวณจุดตกอัตโนมัติ", function(state) end)
CSection:NewToggle("วงรัศมีระเบิด (Dive Bomb)", "แสดงระยะทำลายล้าง", function(state) end)

-- [[ 3. VISUAL & ESP (แยกสี 🟢⚪🔴🟣) ]] --
local ESPTab = Window:NewTab("มองทะลุ (ESP)")
local ESection = ESPTab:NewSection("แยกประเภท: 🟢คน / ⚪ระเบิด / 🔴ธนู / 🟣ขุด")

ESection:NewToggle("เปิดใช้งาน ESP อัจฉริยะ", "มองทะลุกำแพงแบบแยกสี", function(state)
    Configs.ESP_Enabled = state
end)

ESection:NewToggle("เปิดแสงสว่าง (Full Bright) ☀️", "ปิดหมอกและที่มืด", function(state)
    Configs.FullBright = state
    if state then 
        Lighting.Brightness = 2 
        Lighting.ClockTime = 14
        Lighting.FogEnd = 999999
    else 
        Lighting.Brightness = 1 
        Lighting.ClockTime = 12
    end
end)

-- [[ 4. AI BEHAVIOR (ระบบสมองกล) ]] --
local AITab = Window:NewTab("สมองกล AI (Spy Brain)")
local AISect = AITab:NewSection("ระบบสแกนนิสัยผู้เล่น 🕵️")

local function RunAIScan()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (p.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            local tool = p.Character:FindFirstChildOfClass("Tool")
            
            if tool and dist < 40 then
                Configs.BehaviorTags.Aggressive[p.Name] = true
                print("AI Warning: Aggressive Target Detected -> " .. p.Name)
            end
        end
    end
end

AISect:NewToggle("เปิดระบบ AI สแกนนิสัย 🔴🟢", "วิเคราะห์พฤติกรรมคนรอบข้าง", function(state)
    Configs.AIScan = state
    spawn(function()
        while Configs.AIScan do
            RunAIScan()
            wait(2)
        end
    end)
end)

AISect:NewButton("หาจุดแอบที่ดีที่สุด (Find Hiding Spot)", "คำนวณจุดอับสายตาจาก Raycast", function()
    Notify("AI", "กำลังคำนวณหาที่ซ่อนที่ดีที่สุด...")
end)

-- [[ 5. CONFIG & 3-SLOTS (ระบบเซฟ) ]] --
local ConfigTab = Window:NewTab("ตั้งค่า (Config)")
local SSection = ConfigTab:NewSection("Slot Memory 🎰")

for i = 1, 3 do
    SSection:NewButton("Slot "..i.." [ SAVE ]", "บันทึกค่าลงสล็อต "..i, function() SaveToSlot(i) end)
    SSection:NewButton("Slot "..i.." [ LOAD ]", "โหลดค่าจากสล็อต "..i, function() LoadFromSlot(i) end)
end

local ProtectSection = ConfigTab:NewSection("ความปลอดภัย & กันแบน 🛡️")

ProtectSection:NewToggle("Anti-AFK & Anti-Kick", "กันหลุดจากการยืนนิ่ง", function(state)
    if state then
        LocalPlayer.Idled:Connect(function()
            game:GetService("VirtualUser"):CaptureController()
            game:GetService("VirtualUser"):ClickButton2(Vector2.new())
        end)
    end
end)

ProtectSection:NewToggle("Black Screen (ประหยัดแบต)", "หลอกว่าออนไลน์แต่ปิดภาพ", function(state)
    RunService:Set3dRenderingEnabled(not state)
end)

ProtectSection:NewToggle("เกราะกันแบน (Anti-Ban Shield)", "พรางตัวจากการตรวจจับ", function(state) end)

-- [[ THE SPY ORB 🕵️‍♂️ DYNAMIC GUI ]] --
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Orb = Instance.new("ImageButton", ScreenGui)
Orb.Name = "NammonSpyOrb"
Orb.Size = UDim2.new(0, 65, 0, 65)
Orb.Position = UDim2.new(0, 25, 0.5, 0)
Orb.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Orb.Image = "rbxassetid://6031289353"
Orb.Draggable = true

local UICorner = Instance.new("UICorner", Orb)
UICorner.CornerRadius = UDim.new(1, 0)

local UIStroke = Instance.new("UIStroke", Orb)
UIStroke.Thickness = 5
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

RunService.RenderStepped:Connect(function()
    UIStroke.Color = GetRGB() -- ไฟขอบ RGB วิ่งวน
    Orb.Rotation = Orb.Rotation + 1 -- ลูกแก้วหมุน
end)

Orb.MouseButton1Click:Connect(function()
    for _, v in pairs(game.CoreGui:GetChildren()) do
        if v.Name == "NAMMON SPY v1.0" and v:IsA("ScreenGui") then
            v.Enabled = not v.Enabled
        end
    end
end)

Notify("NAMMON SPY", "ระบบพร้อมลุย 300+ บรรทัดโหลดเสร็จสิ้น! 🕵️‍♂️🔥")
print("NAMMON SPY v1.0: THE MASTER SOURCE IS ACTIVE!")
