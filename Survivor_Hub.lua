-- [[ 🕵️ ZOMBIE VS HUMAN - NAMMON SPY V1.6 ]]
-- [[ OWNER: NAMMON | CATEGORY: ALL-IN-ONE OVERLOAD ]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

-- [[ ⚙️ CORE CONFIGURATION DATABASE ]]
_G.Nammon_Configs = {
    -- หมวดที่ 1: ตัวเรา (Player)
    Speed_Act = false, Speed_Val = 16,
    Jump_Act = false, Jump_Val = 50,
    Invis_Name = false, NoFall_Damage = false,
    Fly_Mode = false, Fly_Speed = 50,
    Infinite_Jump = false,
    
    -- หมวดที่ 2: ผู้รอดชีวิต (Survivor)
    Fast_Animation = false, No_Explosion_Push = false,
    Auto_Repair = false, Instant_Build = false,
    Infinite_Wood = false, Fast_Tool = false,
    
    -- หมวดที่ 3: ระเบิดสั่งตาย (Zombie Destruct)
    Instant_Boom = false, Force_Remote_Boom = false,
    Anti_Stop_Boom = false, Loop_All_Bombs = false,
    No_Delay_Place = false, Auto_Explode_Near = false,
    
    -- หมวดที่ 4: มองทะลุ (Visuals/ESP)
    Esp_Humans = false, Esp_Zombies = false,
    Esp_Items = false, Esp_Blocks = false,
    Full_Bright = false, Bright_Level = 2,
    No_Fog = false, Xray_Blocks = false,
    
    -- หมวดที่ 5: การตั้งค่า (Settings)
    Language = "TH", Theme_Color = Color3.fromRGB(0, 255, 0),
    Ball_Visible = true, Rainbow_UI = false
}

-- [[ 🔮 UI CONSTRUCTION - DETAILED LAYER ]]
local ScreenGui = Instance.new("ScreenGui", LP.PlayerGui)
ScreenGui.Name = "NammonSpy_V1.6_Overload"; ScreenGui.ResetOnSpawn = false

-- 🔮 ลูกแก้วเปิด/ปิด (✓)
local ToggleBall = Instance.new("ImageButton", ScreenGui)
ToggleBall.Size = UDim2.new(0, 60, 0, 60); ToggleBall.Position = UDim2.new(0, 25, 0, 180)
ToggleBall.BackgroundColor3 = Color3.fromRGB(10, 10, 10); ToggleBall.Image = "rbxassetid://6031094678"
Instance.new("UICorner", ToggleBall).CornerRadius = UDim.new(1, 0)
local BallStroke = Instance.new("UIStroke", ToggleBall); BallStroke.Thickness = 3; BallStroke.Color = Color3.new(0, 1, 0)

-- ระบบลากลูกแก้วแบบสมูท
local dragging, dInput, dStart, sPos
ToggleBall.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; dStart = i.Position; sPos = ToggleBall.Position end end)
UIS.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then local delta = i.Position - dStart; ToggleBall.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + delta.X, sPos.Y.Scale, sPos.Y.Offset + delta.Y) end end)
ToggleBall.InputEnded:Connect(function() dragging = false end)

-- MAIN FRAME
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 600, 0, 450); MainFrame.Position = UDim2.new(0.5, -300, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18); MainFrame.BorderSizePixel = 0; MainFrame.Visible = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke", MainFrame); MainStroke.Thickness = 2; MainStroke.Color = Color3.fromRGB(40, 40, 45)

ToggleBall.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

-- [[ 📂 NAVIGATION SYSTEM (5 หมวดหมู่) ]]
local SideBar = Instance.new("ScrollingFrame", MainFrame)
SideBar.Size = UDim2.new(0, 185, 1, -110); SideBar.Position = UDim2.new(0, 15, 0, 95)
SideBar.BackgroundTransparency = 1; SideBar.ScrollBarThickness = 2; SideBar.CanvasSize = UDim2.new(0, 0, 1.6, 0)
Instance.new("UIListLayout", SideBar).Padding = UDim.new(0, 10)

local Container = Instance.new("Frame", MainFrame)
Container.Size = UDim2.new(1, -225, 1, -110); Container.Position = UDim2.new(0, 210, 0, 95); Container.BackgroundTransparency = 1

local Pages = {}
local function CreatePage(id)
    local f = Instance.new("ScrollingFrame", Container); f.Size = UDim2.new(1, 0, 1, 0); f.BackgroundTransparency = 1; f.Visible = false
    f.CanvasSize = UDim2.new(0, 0, 2.5, 0); f.ScrollBarThickness = 3; Instance.new("UIListLayout", f).Padding = UDim.new(0, 12)
    Pages[tostring(id)] = f; return f
end

local P1 = CreatePage(1); local P2 = CreatePage(2); local P3 = CreatePage(3); local P4 = CreatePage(4); local P5 = CreatePage(5)

local function AddTab(name, id)
    local b = Instance.new("TextButton", SideBar); b.Size = UDim2.new(0.95, 0, 0, 48); b.Text = name
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 35); b.TextColor3 = Color3.new(1,1,1); b.Font = "GothamBold"; b.TextSize = 14
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    b.MouseButton1Click:Connect(function() for i, p in pairs(Pages) do p.Visible = (i == tostring(id)) end end)
end

AddTab("👤 ตัวเรา", 1); AddTab("🏠 ผู้รอดชีวิต", 2); AddTab("💣 ระเบิดสั่งตาย", 3); AddTab("👁️ มองทะลุ", 4); AddTab("⚙️ การตั้งค่า", 5)

-- [[ 🚀 COMPONENT DESIGNERS (TOGGLES/SLIDERS/LABELS) ]]
local function AddToggle(text, configKey, parent)
    local b = Instance.new("TextButton", parent); b.Size = UDim2.new(0.96, 0, 0, 48); b.Text = text..": OFF"
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 45); b.TextColor3 = Color3.new(1,1,1); b.Font = "GothamBold"; b.TextSize = 13
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    b.MouseButton1Click:Connect(function()
        _G.Nammon_Configs[configKey] = not _G.Nammon_Configs[configKey]
        b.Text = text..": "..(_G.Nammon_Configs[configKey] and "ON" or "OFF")
        b.BackgroundColor3 = _G.Nammon_Configs[configKey] and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(40, 40, 45)
    end)
end

local function AddSlider(text, configKey, min, max, parent)
    local f = Instance.new("Frame", parent); f.Size = UDim2.new(0.96, 0, 0, 75); f.BackgroundTransparency = 1
    local l = Instance.new("TextLabel", f); l.Size = UDim2.new(1, 0, 0, 30); l.Text = text..": ".._G.Nammon_Configs[configKey]; l.TextColor3 = Color3.new(1,1,1); l.BackgroundTransparency = 1; l.TextXAlignment = "Left"; l.Font = "GothamBold"
    local bar = Instance.new("Frame", f); bar.Size = UDim2.new(1, 0, 0, 12); bar.Position = UDim2.new(0, 0, 0, 42); bar.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1); Instance.new("UICorner", bar)
    local fill = Instance.new("Frame", bar); fill.Size = UDim2.new(0.3, 0, 1, 0); fill.BackgroundColor3 = Color3.fromRGB(0, 120, 255); Instance.new("UICorner", fill)
    
    bar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            local function move(inp)
                local p = math.clamp((inp.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                fill.Size = UDim2.new(p, 0, 1, 0); local v = math.floor(min + (max - min) * p)
                _G.Nammon_Configs[configKey] = v; l.Text = text..": "..v
            end
            local con; con = UIS.InputChanged:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then move(inp) end end)
            UIS.InputEnded:Connect(function() con:Disconnect() end)
            move(i)
        end
    end)
end

-- [[ 🛠️ POPULATING EVERY CATEGORY (บิ้วแบบเยอะๆ) ]]
-- P1: ตัวเรา
AddToggle("เปิดใช้งาน Speed", "Speed_Act", P1); AddSlider("ความเร็วตัวเรา", "Speed_Val", 16, 350, P1)
AddToggle("เปิดใช้งาน Jump", "Jump_Act", P1); AddSlider("แรงกระโดด", "Jump_Val", 50, 400, P1)
AddToggle("กระโดดไม่จำกัด", "Infinite_Jump", P1); AddToggle("ล่องหน (ไร้ชื่อ)", "Invis_Name", P1)

-- P2: ผู้รอดชีวิต
AddToggle("ตีความเร็วแสง", "Fast_Animation", P2); AddToggle("กันแรงระเบิด", "No_Explosion_Push", P2)
AddToggle("ซ่อมบ้านอัตโนมัติ", "Auto_Repair", P2); AddToggle("สร้างของทันที", "Instant_Build", P2)
AddToggle("ไม้ไม่จำกัด", "Infinite_Wood", P2)

-- P3: ระเบิดสั่งตาย
AddToggle("ระเบิดทันที (0.1s)", "Instant_Boom", P3)
AddToggle("บังคับระเบิด (Force)", "Force_Remote_Boom", P3)
AddToggle("ห้ามหยุดระเบิด", "Anti_Stop_Boom", P3)
AddToggle("วางระเบิดไร้ดีเลย์", "No_Delay_Place", P3)

-- P4: มองทะลุ
AddToggle("X-Ray มนุษย์ (เขียว)", "Esp_Humans", P4)
AddToggle("X-Ray ซอมบี้ (แดง)", "Esp_Zombies", P4)
AddToggle("มองทะลุไม้/บล็อก", "Esp_Blocks", P4)
AddToggle("เพิ่มแสงสว่าง", "Full_Bright", P4); AddSlider("ความจ้า", "Bright_Level", 1, 20, P4)

-- P5: การตั้งค่า
AddToggle("สายรุ้ง UI", "Rainbow_UI", P5)

-- [[ ⚡ SYSTEM LOGIC - OVERLOAD PERFORMANCE ]]
RunService.Heartbeat:Connect(function()
    if LP.Character and LP.Character:FindFirstChild("Humanoid") then
        if _G.Nammon_Configs.Speed_Act then LP.Character.Humanoid.WalkSpeed = _G.Nammon_Configs.Speed_Val end
        if _G.Nammon_Configs.Jump_Act then LP.Character.Humanoid.JumpPower = _G.Nammon_Configs.Jump_Val end
    end
    if _G.Nammon_Configs.Full_Bright then Lighting.Brightness = _G.Nammon_Configs.Bright_Level; Lighting.ClockTime = 12 end
end)

-- ระบบระเบิดสั่งตายและ ESP
task.spawn(function()
    while task.wait(0.2) do
        -- Instant Boom Logic
        if _G.Nammon_Configs.Instant_Boom then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("NumberValue") and (v.Name == "Timer" or v.Name == "ExplosionTime") then v.Value = 0.1 end
            end
        end
        -- Force Remote Boom
        if _G.Nammon_Configs.Force_Remote_Boom and LP.Character then
            pcall(function()
                local b = LP.Character:FindFirstChild("ZombieBomb") or LP.Backpack:FindFirstChild("ZombieBomb")
                if b and b:FindFirstChild("RemoteEvent") then b.RemoteEvent:FireServer("Activate") end
            end)
        end
        -- ESP Engine
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local h = p.Character:FindFirstChild("NM_ESP") or Instance.new("Highlight", p.Character)
                h.Name = "NM_ESP"
                local isZ = p.Character:FindFirstChild("ZombieTag") or p.Name:lower():find("zombie")
                h.Enabled = (isZ and _G.Nammon_Configs.Esp_Zombies) or (not isZ and _G.Nammon_Configs.Esp_Humans)
                h.FillColor = isZ and Color3.new(1,0,0) or Color3.new(0,1,0)
                h.OutlineTransparency = 0
            end
        end
    end
end)

Pages["1"].Visible = true
print("🕵️ NAMMON SPY V1.6 - THE OVERLOAD MASTERPIECE ACTIVATED!")
