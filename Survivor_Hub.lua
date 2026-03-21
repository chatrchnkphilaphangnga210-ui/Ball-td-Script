-- [[ 🕵️ ZOMBIE VS HUMAN - SUPREME EDITION ]]
-- [[ BY NAMMON & GEMINI AI ]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer
local Lighting = game:GetService("Lighting")

-- [ ⚙️ CONFIG & LANG DATA ]
_G.Nammon_Configs = {
    Speed = 16, Jump = 50, Invis = false,
    NoBlast = false, NoRunner = false, NoCannon = false, FastAnim = false,
    DelOrb = false, XrayLevel = 0, BrightLevel = 0,
    Language = "TH" -- "TH" หรือ "EN"
}

local LangData = {
    TH = {
        Tabs = {"ตัวเรา", "ผู้รอดชีวิต", "ซอมบี้", "มองทะลุ", "การตั้งค่า"},
        Invis = "ล่องหน (ไร้ชื่อ)",
        Orbs = "ดูดลูกแก้ว",
        Blast = "กันระเบิด",
        Attack = "ตีแสง",
        LangBtn = "เปลี่ยนเป็นภาษาอังกฤษ",
        Xray = "เอกซเรย์",
        Bright = "เพิ่มแสง"
    },
    EN = {
        Tabs = {"Player", "Survivor", "Zombie", "Visual", "Settings"},
        Invis = "Invis (No Name)",
        Orbs = "Auto Collect Orbs",
        Blast = "Anti-Explosion",
        Attack = "Fast Attack",
        LangBtn = "Switch to Thai",
        Xray = "X-Ray Mode",
        Bright = "Brightness"
    }
}

-- [ 🌈 RGB ENGINE ]
local function MakeRGB(obj)
    spawn(function()
        while task.wait() do
            local hue = tick() % 5 / 5
            local color = Color3.fromHSV(hue, 1, 1)
            if obj:IsA("UIStroke") then obj.Color = color
            elseif obj:IsA("TextLabel") or obj:IsA("TextButton") then obj.TextColor3 = color end
        end
    end)
end

-- [ 🖥️ UI CONSTRUCTION ]
local Gui = Instance.new("ScreenGui", LP.PlayerGui)
Gui.Name = "NammonSpy_ZvsH_Final"

-- 🔮 1. ลูกแก้วเปิด/ปิด (Toggle Ball)
local ToggleBall = Instance.new("ImageButton", Gui)
ToggleBall.Size = UDim2.new(0, 50, 0, 50)
ToggleBall.Position = UDim2.new(0, 15, 0, 80)
ToggleBall.BackgroundColor3 = Color3.new(0,0,0)
ToggleBall.Image = "rbxassetid://6031094678" 
Instance.new("UICorner", ToggleBall).CornerRadius = UDim.new(1, 0)
local BallStroke = Instance.new("UIStroke", ToggleBall)
BallStroke.Thickness = 3
MakeRGB(BallStroke)

-- 🖼️ 2. Main Frame
local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 560, 0, 380)
Main.Position = UDim2.new(0.5, -280, 0.5, -190)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Main.Visible = true
Instance.new("UICorner", Main)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Thickness = 3
MakeRGB(MainStroke)

ToggleBall.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- [ 🏷️ HEADER SECTION ]
local MainTitle = Instance.new("TextLabel", Main)
MainTitle.Size = UDim2.new(1, 0, 0, 40)
MainTitle.Position = UDim2.new(0, 0, 0, 10)
MainTitle.Text = "ZOMBIE VS HUMAN"
MainTitle.Font = "GothamBold"
MainTitle.TextSize = 26
MainTitle.BackgroundTransparency = 1
MakeRGB(MainTitle)

local SubTitle = Instance.new("TextLabel", Main)
SubTitle.Size = UDim2.new(1, 0, 0, 20)
SubTitle.Position = UDim2.new(0, 0, 0, 45)
SubTitle.Text = "Z vs H by Nammon & Gemini"
SubTitle.Font = "Gotham"
SubTitle.TextSize = 14
SubTitle.TextColor3 = Color3.new(0.8, 0.8, 0.8)
SubTitle.BackgroundTransparency = 1

-- [ 📂 SIDEBAR & TABS ]
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 170, 1, -90)
Sidebar.Position = UDim2.new(0, 10, 0, 80)
Sidebar.BackgroundTransparency = 1
Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 8)

local PageContainer = Instance.new("Frame", Main)
PageContainer.Size = UDim2.new(1, -200, 1, -90)
PageContainer.Position = UDim2.new(0, 190, 0, 80)
PageContainer.BackgroundTransparency = 1

local Tabs, TabBtns = {}, {}
local function CreatePage(name)
    local f = Instance.new("ScrollingFrame", PageContainer)
    f.Size = UDim2.new(1, 0, 1, 0)
    f.BackgroundTransparency = 1; f.Visible = false
    f.CanvasSize = UDim2.new(0, 0, 2, 0)
    Instance.new("UIListLayout", f).Padding = UDim.new(0, 10)
    Tabs[name] = f
    return f
end

local P1, P2, P3, P4, P5 = CreatePage("T1"), CreatePage("T2"), CreatePage("T3"), CreatePage("T4"), CreatePage("T5")

local function UpdateLanguage()
    local D = LangData[_G.Nammon_Configs.Language]
    for i, btn in pairs(TabBtns) do btn.Text = D.Tabs[i] end
    -- อัปเดตชื่อปุ่มฟังก์ชันในนี้เพิ่มเติมได้ครับ
end

local function ShowTab(idx)
    local i = 1
    for _, v in pairs(Tabs) do v.Visible = (i == idx) i = i + 1 end
end

local function AddTabButton(idx)
    local b = Instance.new("TextButton", Sidebar)
    b.Size = UDim2.new(1, 0, 0, 52)
    b.Font = "GothamBold"; b.TextSize = 20
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    b.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() ShowTab(idx) end)
    table.insert(TabBtns, b)
end

for i=1, 5 do AddTabButton(i) end
UpdateLanguage()
ShowTab(1)

-- [ 🚀 การตั้งค่า: ปุ่มสลับภาษา ]
local LangBtn = Instance.new("TextButton", P5)
LangBtn.Size = UDim2.new(0.95, 0, 0, 60)
LangBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
LangBtn.Font = "GothamBold"; LangBtn.TextSize = 18; LangBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", LangBtn)
MakeRGB(Instance.new("UIStroke", LangBtn))

LangBtn.MouseButton1Click:Connect(function()
    _G.Nammon_Configs.Language = (_G.Nammon_Configs.Language == "TH") and "EN" or "TH"
    LangBtn.Text = LangData[_G.Nammon_Configs.Language].LangBtn
    UpdateLanguage()
end)
LangBtn.Text = LangData[_G.Nammon_Configs.Language].LangBtn

print("🕵️ ZOMBIE VS HUMAN V1.0 - MULTI-LANG READY!")
