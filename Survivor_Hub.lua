-- [[ 🕵️ ZOMBIE VS HUMAN - NAMMON SPY V1.0 ]]
-- [[ BY NAMMON & GEMINI AI | FOCUS: STABILITY ]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer
local Lighting = game:GetService("Lighting")

-- [ ⚙️ CONFIG ]
_G.Nammon_Configs = {
    Invis = false, DelOrb = false, FastAnim = false, 
    NoBlast = false, EspH = false, EspZ = false, FullBright = false
}

-- [ 🌈 RGB MASTER: ขอบ และ ชื่อหลัก ]
local function ApplyRGB(obj)
    task.spawn(function()
        while task.wait() do
            local hue = tick() % 4 / 4
            local color = Color3.fromHSV(hue, 1, 1)
            if obj:IsA("UIStroke") then obj.Color = color
            elseif obj:IsA("TextLabel") and obj.Name == "MainTitle" then obj.TextColor3 = color end
        end
    end)
end

-- [ 🖥️ UI CORE CONSTRUCTION ]
local Gui = Instance.new("ScreenGui", LP.PlayerGui)
Gui.Name = "NammonSpy_Final"; Gui.ResetOnSpawn = false

-- 🔮 ลูกแก้วเปิด/ปิด: รูปสไปร์ ✓ สีชมพู (ขอบ RGB)
local ToggleBall = Instance.new("ImageButton", Gui)
ToggleBall.Size = UDim2.new(0, 55, 0, 55); ToggleBall.Position = UDim2.new(0, 20, 0, 100)
ToggleBall.BackgroundColor3 = Color3.new(0,0,0); ToggleBall.Image = "rbxassetid://6031094678" -- รูป ✓
Instance.new("UICorner", ToggleBall).CornerRadius = UDim.new(1, 0)
local BallStroke = Instance.new("UIStroke", ToggleBall); BallStroke.Thickness = 3
ApplyRGB(BallStroke)

local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 560, 0, 400); Main.Position = UDim2.new(0.5, -280, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20); Instance.new("UICorner", Main)
local MainStroke = Instance.new("UIStroke", Main); MainStroke.Thickness = 3
ApplyRGB(MainStroke)

ToggleBall.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- [ 🏷️ HEADER: ZOMBIE VS HUMAN ]
local MainTitle = Instance.new("TextLabel", Main)
MainTitle.Name = "MainTitle"; MainTitle.Size = UDim2.new(1, 0, 0, 45)
MainTitle.Position = UDim2.new(0, 0, 0, 10); MainTitle.Text = "ZOMBIE VS HUMAN"
MainTitle.Font = "GothamBold"; MainTitle.TextSize = 28; MainTitle.BackgroundTransparency = 1
ApplyRGB(MainTitle)

local SubTitle = Instance.new("TextLabel", Main)
SubTitle.Size = UDim2.new(1, 0, 0, 20); SubTitle.Position = UDim2.new(0, 0, 0, 50)
SubTitle.Text = "Z vs H by Nammon & Gemini"; SubTitle.Font = "Gotham"; SubTitle.TextSize = 14
SubTitle.TextColor3 = Color3.new(0.8, 0.8, 0.8); SubTitle.BackgroundTransparency = 1

-- [ 📂 STABLE NAVIGATION ]
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 175, 1, -120); Sidebar.Position = UDim2.new(0, 10, 0, 100); Sidebar.BackgroundTransparency = 1
Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 8)

local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -210, 1, -120); Container.Position = UDim2.new(0, 200, 0, 100); Container.BackgroundTransparency = 1

local Pages = {}
local function CreatePage(name)
    local f = Instance.new("ScrollingFrame", Container)
    f.Size = UDim2.new(1, 0, 1, 0); f.BackgroundTransparency = 1; f.Visible = false
    f.CanvasSize = UDim2.new(0, 0, 2, 0); f.ScrollBarThickness = 2
    Instance.new("UIListLayout", f).Padding = UDim.new(0, 10)
    Pages[name] = f; return f
end

local P1 = CreatePage("Player"); local P2 = CreatePage("Surv"); local P3 = CreatePage("Zom"); local P4 = CreatePage("Vis"); local P5 = CreatePage("Set")

local function OpenTab(id)
    P1.Visible = (id == 1); P2.Visible = (id == 2); P3.Visible = (id == 3); P4.Visible = (id == 4); P5.Visible = (id == 5)
end

local function AddTab(txt, id)
    local b = Instance.new("TextButton", Sidebar)
    b.Size = UDim2.new(1, 0, 0, 52); b.Text = txt; b.Font = "GothamBold"; b.TextSize = 19
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 35); b.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", b); b.MouseButton1Click:Connect(function() OpenTab(id) end)
end

AddTab("ตัวเรา", 1); AddTab("ผู้รอดชีวิต", 2); AddTab("ซอมบี้", 3); AddTab("มองทะลุ", 4); AddTab("การตั้งค่า", 5)

-- [ 🚀 COMPONENT: ปุ่มสีขาวนิ่งๆ ]
local function NewToggle(txt, key, parent)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0.95, 0, 0, 50); b.Text = txt..": OFF"; b.Font = "GothamBold"; b.TextSize = 17
    b.TextColor3 = Color3.new(1, 1, 1); b.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        _G.Nammon_Configs[key] = not _G.Nammon_Configs[key]
        b.Text = txt..": "..(_G.Nammon_Configs[key] and "ON" or "OFF")
        b.BackgroundColor3 = _G.Nammon_Configs[key] and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(45, 45, 50)
    end)
end

-- [ 🛠️ จัดหมวดหมู่ปุ่ม (FIXED!) ]
NewToggle("ล่องหน (ไร้ชื่อ)", "Invis", P1) -- หน้า 1

NewToggle("ดูดลูกแก้ว", "DelOrb", P2) -- หน้า 2
NewToggle("ตีความเร็วแสง", "FastAnim", P2)
NewToggle("กันแรงระเบิด", "NoBlast", P2)

local Soon = Instance.new("TextLabel", P3) -- หน้า 3
Soon.Size = UDim2.new(1,0,0,50); Soon.Text = "COMING SOON..."; Soon.TextColor3 = Color3.new(0.5,0.5,0.5); Soon.BackgroundTransparency = 1

NewToggle("มองทะลุมนุษย์", "EspH", P4) -- หน้า 4
NewToggle("มองทะลุซอมบี้", "EspZ", P4)
NewToggle("เปิดไฟสว่าง", "FullBright", P4)

local LangBtn = Instance.new("TextButton", P5) -- หน้า 5 (การตั้งค่า)
LangBtn.Size = UDim2.new(0.95, 0, 0, 55); LangBtn.Text = "เปลี่ยนเป็นภาษาอังกฤษ"
LangBtn.Font = "GothamBold"; LangBtn.TextSize = 17; LangBtn.TextColor3 = Color3.new(1, 1, 1)
LangBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35); Instance.new("UICorner", LangBtn)

-- [ ⚡ LOGIC ]
RunService.RenderStepped:Connect(function()
    if _G.Nammon_Configs.FullBright then Lighting.Brightness = 3; Lighting.ClockTime = 12 end
end)

OpenTab(1) -- Start
print("🕵️ NAMMON SPY V1.0 - STABLE VERSION READY!")
