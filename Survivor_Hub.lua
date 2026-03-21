-- [[ 🕵️ ZOMBIE VS HUMAN - NAMMON SPY [RESTORED] ]]
-- [[ FIX: SPEED, JUMP, BRIGHT, ESP HIGHLIGHT ]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer
local Lighting = game:GetService("Lighting")

-- [ ⚙️ CONFIG ]
_G.Nammon_Configs = {
    Speed_Act = false, Speed_Val = 50,
    Jump_Act = false, Jump_Val = 100,
    Invis = false, FullBright = false,
    EspH = false, EspZ = false, EspBlock = false,
    InstantBoom = false, AntiStop = false
}

-- [ 🔮 UI CORE & DRAGGABLE ]
local Gui = Instance.new("ScreenGui", LP.PlayerGui)
Gui.Name = "NammonSpy_Restored"; Gui.ResetOnSpawn = false

local ToggleBall = Instance.new("ImageButton", Gui)
ToggleBall.Size = UDim2.new(0, 60, 0, 60); ToggleBall.Position = UDim2.new(0, 20, 0, 150)
ToggleBall.BackgroundColor3 = Color3.new(0,0,0); ToggleBall.Image = "rbxassetid://6031094678" -- รูป ✓
Instance.new("UICorner", ToggleBall).CornerRadius = UDim.new(1, 0)
local BStroke = Instance.new("UIStroke", ToggleBall); BStroke.Thickness = 3

-- ระบบลากลูกแก้ว
local dragging, dragStart, startPos
ToggleBall.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = ToggleBall.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        ToggleBall.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
ToggleBall.InputEnded:Connect(function() dragging = false end)

local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 560, 0, 400); Main.Position = UDim2.new(0.5, -280, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20); Instance.new("UICorner", Main)
local MStroke = Instance.new("UIStroke", Main); MStroke.Thickness = 3
ToggleBall.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- [ 📂 SIDEBAR (เลื่อนได้) ]
local SideScroll = Instance.new("ScrollingFrame", Main)
SideScroll.Size = UDim2.new(0, 175, 1, -110); SideScroll.Position = UDim2.new(0, 15, 0, 90)
SideScroll.BackgroundTransparency = 1; SideScroll.ScrollBarThickness = 2; SideScroll.CanvasSize = UDim2.new(0, 0, 1.5, 0)
Instance.new("UIListLayout", SideScroll).Padding = UDim.new(0, 8)

local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -215, 1, -110); Container.Position = UDim2.new(0, 200, 0, 90); Container.BackgroundTransparency = 1

local Pages = {}
local function CreatePage(id)
    local f = Instance.new("ScrollingFrame", Container)
    f.Size = UDim2.new(1, 0, 1, 0); f.BackgroundTransparency = 1; f.Visible = false
    f.CanvasSize = UDim2.new(0, 0, 2, 0); Instance.new("UIListLayout", f).Padding = UDim.new(0, 10)
    Pages[tostring(id)] = f; return f
end

local P1 = CreatePage(1); local P3 = CreatePage(3); local P4 = CreatePage(4)

local function AddTab(txt, id)
    local b = Instance.new("TextButton", SideScroll); b.Size = UDim2.new(0.95, 0, 0, 50)
    b.Text = txt; b.Font = "GothamBold"; b.TextSize = 18; b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = Color3.fromRGB(30,30,35); Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() for i, p in pairs(Pages) do p.Visible = (i == tostring(id)) end end)
end

AddTab("ตัวเรา", 1); AddTab("ระเบิดสั่งตาย", 3); AddTab("มองทะลุ", 4)

-- [ 🚀 FUNCTION BUILDER ]
local function NewToggle(txt, key, parent)
    local b = Instance.new("TextButton", parent); b.Size = UDim2.new(0.95, 0, 0, 50)
    b.Text = txt..": OFF"; b.Font = "GothamBold"; b.TextSize = 16; b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = Color3.fromRGB(45, 45, 50); Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        _G.Nammon_Configs[key] = not _G.Nammon_Configs[key]
        b.Text = txt..": "..(_G.Nammon_Configs[key] and "ON" or "OFF")
        b.BackgroundColor3 = _G.Nammon_Configs[key] and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(45, 45, 50)
    end)
end

-- [ 🛠️ ใส่ปุ่มที่น้ำมนต์สั่ง ]
NewToggle("เปิดใช้งาน Speed", "Speed_Act", P1)
NewToggle("เปิดใช้งาน Jump", "Jump_Act", P1)
NewToggle("ล่องหน (ไร้ชื่อ)", "Invis", P1)

NewToggle("กดระเบิดทันที", "InstantBoom", P3)
NewToggle("ล็อคสถานะระเบิด", "AntiStop", P3)

NewToggle("เอกซเรย์คน (เขียว)", "EspH", P4)
NewToggle("เอกซเรย์ซอมบี้ (แดง)", "EspZ", P4)
NewToggle("เพิ่มแสงสว่าง (Bright)", "FullBright", P4)
NewToggle("มองทะลุไม้", "EspBlock", P4)

-- [ ⚡ LOGIC SYSTEM ]
RunService.Stepped:Connect(function()
    if _G.Nammon_Configs.Speed_Act then LP.Character.Humanoid.WalkSpeed = _G.Nammon_Configs.Speed_Val end
    if _G.Nammon_Configs.Jump_Act then LP.Character.Humanoid.JumpPower = _G.Nammon_Configs.Jump_Val end
    if _G.Nammon_Configs.FullBright then Lighting.Brightness = 3; Lighting.ClockTime = 12 end
end)

task.spawn(function()
    while task.wait(0.5) do
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local h = p.Character:FindFirstChild("NammonESP") or Instance.new("Highlight", p.Character)
                h.Name = "NammonESP"
                local isZom = p.Character:FindFirstChild("ZombieTag") or p.Name:lower():find("zombie")
                h.Enabled = isZom and _G.Nammon_Configs.EspZ or _G.Nammon_Configs.EspH
                h.FillColor = isZom and Color3.new(1,0,0) or Color3.new(0,1,0)
                h.OutlineColor = Color3.new(1,1,1)
            end
        end
    end
end)

-- RGB Loop
task.spawn(function()
    while task.wait() do
        local c = Color3.fromHSV(tick()%4/4, 1, 1)
        BStroke.Color = c; MStroke.Color = c
    end
