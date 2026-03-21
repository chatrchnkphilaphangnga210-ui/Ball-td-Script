-- [[ 🕵️ PROJECT: NAMMON SPY - DEFINITIVE EDITION ]]
-- [[ CONCEPT: UI V1.0 + POWER V7.5 ]]
-- [[ AUTHOR: NAMMON & GEMINI ]]

-- [ 1. SERVICES & CORE ]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [ 2. SETTINGS: ระบบตั้งค่าแบบ Real-time ]
_G.Nammon_Configs = {
    Speed = 46,
    Jump = 250,
    P_ESP = false,
    M_ESP = false,
    DelShells = false,
    AntiKB = false,
    GhostJump = false,
    Invis = false,
    AntiAFK = true
}

-- [ 3. FUNCTIONS: ระบบเบื้องหลัง ]
-- ระบบตาทิพย์ (ESP)
local function CreateESP(Part, Tag, Color)
    if not Part or Part:FindFirstChild("ESP_"..Tag) then return end
    local Box = Instance.new("BoxHandleAdornment", Part)
    Box.Name = "ESP_"..Tag
    Box.Size = Part.Size + Vector3.new(0.1, 0.1, 0.1)
    Box.AlwaysOnTop, Box.ZIndex, Box.Adornee = true, 10, Part
    Box.Color3, Box.Transparency = Color, 0.5
end

-- [ 4. UI CONSTRUCTION: กู้คืนความเท่ V1.0 ]
local Gui = Instance.new("ScreenGui", LP.PlayerGui)
Gui.Name = "NammonSpy_Master"

local Main = Instance.new("Frame", Gui)
Main.Size, Main.Position = UDim2.new(0, 500, 0, 320), UDim2.new(0.5, -250, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Main.Active, Main.Draggable = true, true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(255, 85, 0) -- ขอบส้ม Signature

-- [ SIDEBAR (ฝั่งซ้าย) ]
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size, Sidebar.Position = UDim2.new(0, 140, 1, -20), UDim2.new(0, 10, 0, 10)
Sidebar.BackgroundTransparency = 1
local S_Layout = Instance.new("UIListLayout", Sidebar)
S_Layout.Padding = UDim.new(0, 5)

-- [ CONTENT (ฝั่งขวา) ]
local Content = Instance.new("ScrollingFrame", Main)
Content.Size, Content.Position = UDim2.new(1, -170, 1, -20), UDim2.new(0, 160, 0, 10)
Content.BackgroundTransparency, Content.CanvasSize = 1, UDim2.new(0, 0, 2, 0)
Content.ScrollBarThickness = 2
Instance.new("UIListLayout", Content).Padding = UDim.new(0, 8)

-- [ 🏗️ UI BUILDER: ฟังก์ชันสร้างส่วนประกอบ ]
local function NewTab(name, icon)
    local b = Instance.new("TextButton", Sidebar)
    b.Size, b.BackgroundColor3 = UDim2.new(1, 0, 0, 45), Color3.fromRGB(40, 40, 45)
    b.Text, b.TextColor3, b.Font = icon.." "..name, Color3.new(1, 1, 1), "GothamBold"
    Instance.new("UICorner", b)
end

local function NewToggle(txt, icon, key)
    local b = Instance.new("TextButton", Content)
    b.Size, b.BackgroundColor3 = UDim2.new(0.95, 0, 0, 45), Color3.fromRGB(45, 45, 55)
    b.Text, b.TextColor3, b.Font = icon.." "..txt..": OFF", Color3.new(1, 1, 1), "GothamBold"
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        _G.Nammon_Configs[key] = not _G.Nammon_Configs[key]
        b.Text = icon.." "..txt..": "..(_G.Nammon_Configs[key] and "ON" or "OFF")
        b.BackgroundColor3 = _G.Nammon_Configs[key] and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(45, 45, 55)
    end)
end

local function NewAdjuster(txt, key)
    local f = Instance.new("Frame", Content)
    f.Size, f.BackgroundColor3 = UDim2.new(0.95, 0, 0, 55), Color3.fromRGB(35, 35, 40)
    Instance.new("UICorner", f)
    local l = Instance.new("TextLabel", f)
    l.Size, l.Text = UDim2.new(1, 0, 1, 0), txt..": [".._G.Nammon_Configs[key].."]"
    l.TextColor3, l.BackgroundTransparency, l.Font = Color3.new(1, 1, 1), 1, "GothamBold"
    
    local p = Instance.new("TextButton", f)
    p.Size, p.Position, p.Text = UDim2.new(0, 40, 0, 40), UDim2.new(1, -45, 0.5, -20), "+"
    p.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    p.MouseButton1Click:Connect(function() 
        _G.Nammon_Configs[key] = _G.Nammon_Configs[key] + 5 
        l.Text = txt..": [".._G.Nammon_Configs[key].."]" 
    end)
    
    local m = Instance.new("TextButton", f)
    m.Size, m.Position, m.Text = UDim2.new(0, 40, 0, 40), UDim2.new(0, 5, 0.5, -20), "-"
    m.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    m.MouseButton1Click:Connect(function() 
        _G.Nammon_Configs[key] = _G.Nammon_Configs[key] - 5 
        l.Text = txt..": [".._G.Nammon_Configs[key].."]" 
    end)
    Instance.new("UICorner", p) Instance.new("UICorner", m)
end

-- [ 🚀 DEPLOYING: เริ่มติดตั้งฟังก์ชัน ]
NewTab("Player", "👤")
NewTab("Zombie", "🧟")
NewTab("Visual", "👁️")

NewAdjuster("Speed", "Speed")
NewAdjuster("Jump", "Jump")
NewToggle("Player ESP", "👁️", "P_ESP")
NewToggle("Zombie ESP", "👁️", "M_ESP")
NewToggle("Delete Shells", "🛡️", "DelShells")
NewToggle("Anti-Knockback", "🛡️", "AntiKB")
NewToggle("Ghost Jump", "🧗", "GhostJump")
NewToggle("Invisibility", "👻", "Invis")

-- ปุ่ม Reset Character
local Reset = Instance.new("TextButton", Content)
Reset.Size, Reset.BackgroundColor3 = UDim2.new(0.95, 0, 0, 50), Color3.fromRGB(180, 0, 0)
Reset.Text, Reset.TextColor3, Reset.Font = "💣 Reset Character", Color3.new(1, 1, 1), "GothamBold"
Instance.new("UICorner", Reset)
Reset.MouseButton1Click:Connect(function() LP.Character:BreakJoints() end)

-- [ ⚡ RUNTIME CORE: ระบบควบคุมการทำงาน ]
RunService.Stepped:Connect(function()
    pcall(function()
        local char = LP.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = _G.Nammon_Configs.Speed
            char.Humanoid.JumpPower = _G.Nammon_Configs.Jump
            if _G.Nammon_Configs.GhostJump then char.Humanoid:ChangeState(11) end
            if _G.Nammon_Configs.Invis then
                for _, v in pairs(char:GetChildren()) do if v:IsA("BasePart") then v.Transparency = 0.5 end end
            end
            if _G.Nammon_Configs.AntiKB and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.Velocity = Vector3.new(0, char.HumanoidRootPart.Velocity.Y, 0)
            end
        end
    end)
end)

-- ระบบลบกระสุน/ปืนใหญ่
workspace.DescendantAdded:Connect(function(obj)
    if _G.Nammon_Configs.DelShells and (obj.Name == "Bullet" or obj.Name == "Shell") then
        task.wait()
        obj:Destroy()
    end
end)

-- ระบบตาทิพย์
RunService.Heartbeat:Connect(function()
    if _G.Nammon_Configs.P_ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then CreateESP(p.Character:FindFirstChild("HumanoidRootPart"), "P", Color3.new(0, 1, 0)) end
        end
    end
end)

print("🕵️ [NAMMON SPY] Definitive Edition: THE MASTERPIECE LOADED!")
