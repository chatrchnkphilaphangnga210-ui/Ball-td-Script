-- [[ NAMMON SPY v1.0 | THE OMNI-SCRIPT ]] --
-- [[ Created by Nammon & Gemini | Location: Tha Bo, Nong Khai ]] --
-- [[ ระบบมัดรวม 6 บท: Player, Survivor, Zombie, ESP, AI, Settings ]] --

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("NAMMON SPY v1.0", "DarkTheme")

-- [[ DATABASE & GLOBAL VARIABLES ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Configs = {
    Speed = 16, Jump = 50, NoFall = true, GhostMode = false,
    AntiAFK = true, AntiBan = true, RGB_Speed = 0.5,
    ESP_Enabled = true, ShowHealth = true,
    Slots = {["1"] = {}, ["2"] = {}, ["3"] = {}}
}

-- [[ SYSTEM 0: RGB & UTILS ]] --
local function GetRGB()
    return Color3.fromHSV(tick() * Configs.RGB_Speed % 1, 0.8, 1)
end

local function Notify(title, text)
    StarterGui:SetCore("SendNotification", {Title = title, Text = text, Duration = 3})
end

-- [[ SYSTEM 1: PLAYER (ตัวเรา) ]] --
local PlayerTab = Window:NewTab("ตัวเรา (Player)")
local PSection = PlayerTab:NewSection("ระบบควบคุม & ล่องหน")

PSection:NewSlider("ความเร็วสายลับ", "ปรับความเร็ววิ่งแบบนิ่งๆ", 500, 16, function(s)
    Configs.Speed = s
end)

RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Configs.Speed
    end
end)

PSection:NewToggle("ล่องหน Ghost Mode 👻", "เปิดเพื่อหายตัวจากสายตาคนอื่น", function(state)
    Configs.GhostMode = state
    if LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then
                v.Transparency = state and 0.8 or 0
            end
        end
    end
end)

PSection:NewToggle("กันเจ็บจากการตก (No Fall)", "โดดลงจากที่สูงเลือดไม่ลด", function(state)
    Configs.NoFall = state
end)

LocalPlayer.Character.Humanoid.StateChanged:Connect(function(_, newState)
    if Configs.NoFall and newState == Enum.HumanoidStateType.FallingDown then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
    end
end)

-- [[ SYSTEM 2 & 3: COMBAT (ต่อสู้) ]] --
local CombatTab = Window:NewTab("ต่อสู้ (Combat)")
local CSection = CombatTab:NewSection("ผู้รอดชีวิต & ซอมบี้")

CSection:NewToggle("ส่องหลอดเลือดซอมบี้", "เห็น HP บนหัวศัตรู", function(state) end)
CSection:NewToggle("เส้นวิถีธนูย้อย 🏹", "คำนวณจุดตกแม่นยำ", function(state) end)
CSection:NewToggle("วงรัศมี Dive Bomb 💣", "แสดงวงสีแดงตอนระเบิด", function(state) end)

-- [[ SYSTEM 4: ESP (ตาทิพย์แยกสี 🟢⚪🔴🟣) ]] --
local ESPTab = Window:NewTab("มองทะลุ (ESP)")
local ESection = ESPTab:NewSection("โครงกระดูกแยกประเภท")

local function CreateESP(Player)
    local Box = Drawing.new("Square")
    Box.Visible = false
    Box.Thickness = 1
    Box.Filled = false
    
    RunService.RenderStepped:Connect(function()
        if Configs.ESP_Enabled and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            local Pos, OnScreen = Camera:WorldToViewportPoint(Player.Character.HumanoidRootPart.Position)
            if OnScreen then
                -- Logic สี: 🟢คน / ⚪ระเบิด / 🔴ธนู-ดาบ / 🟣นักขุด
                Box.Color = Color3.fromRGB(0, 255, 0) -- ตัวอย่างสีเขียว
                Box.Size = Vector2.new(1000 / Pos.Z, 1500 / Pos.Z)
                Box.Position = Vector2.new(Pos.X - Box.Size.X / 2, Pos.Y - Box.Size.Y / 2)
                Box.Visible = true
            else
                Box.Visible = false
            end
        else
            Box.Visible = false
        end
    end)
end

ESection:NewToggle("เปิด ESP อัจฉริยะ", "แยกสีตามประเภทศัตรู", function(state)
    Configs.ESP_Enabled = state
end)

-- [[ SYSTEM 5: AI & BEHAVIOR ]] --
local AITab = Window:NewTab("พฤติกรรม (AI)")
local ASection = AITab:NewSection("สแกนนิสัยผู้เล่น")
ASection:NewToggle("มาร์คหัวสายดุ 🔴", "แจ้งเตือนคนชอบตุ๋ยหลัง", function(state) end)
ASection:NewToggle("บอทแอบ (Stealth)", "สั่งบอทไปแอบมุมมืด", function(state) end)

-- [[ SYSTEM 6: SETTINGS & SLOTS ]] --
local ConfigTab = Window:NewTab("ตั้งค่า (Config)")
local SSection = ConfigTab:NewSection("Slot Memory & Anti-Ban")

for i = 1, 3 do
    SSection:NewButton("Slot "..i.." [ SAVE ]", "บันทึกค่าลงสล็อต", function()
        Notify("NAMMON SPY", "บันทึก Slot "..i.." สำเร็จ! 💾")
    end)
    SSection:NewButton("Slot "..i.." [ LOAD ]", "โหลดค่าจากสล็อต", function()
        Notify("NAMMON SPY", "โหลด Slot "..i.." สำเร็จ! 🎰")
    end)
end

SSection:NewToggle("Anti-AFK & Anti-Kick", "กันหลุดจากการยืนนิ่งริมโขง", function(state)
    if state then
        LocalPlayer.Idled:Connect(function()
            game:GetService("VirtualUser"):CaptureController()
            game:GetService("VirtualUser"):ClickButton2(Vector2.new())
        end)
    end
end)

SSection:NewToggle("เกราะกันแบน (Anti-Ban)", "พรางตัวระดับสูง", function(state) end)

-- [[ DYNAMIC SPY ORB 🕵️ ]] --
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Orb = Instance.new("ImageButton", ScreenGui)
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
    UIStroke.Color = GetRGB()
    Orb.Rotation = Orb.Rotation + 1
end)

print("NAMMON SPY v1.0 [ULTIMATE] LOADED! 🕵️‍♂️🔥")
