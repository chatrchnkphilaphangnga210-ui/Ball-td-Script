-- [[ 🕵️ NAMMON SPY V1.0 - SUPREME EDITION ]]
-- [[ CREDITS: BY NAMMON & GEMINI AI ]]
-- [[ STATUS: OFFICIAL RELEASE ]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer
local Lighting = game:GetService("Lighting")

-- [ ⚙️ CONFIG & SAVES ]
_G.Nammon_Configs = {
    Speed = 16, Jump = 50, Invis = false,
    NoBlast = false, NoRunner = false, NoCannon = false, FastAnim = false,
    DelOrb = true, XrayLevel = 0, BrightLevel = 0,
    AFK = false
}

-- [ 🛠️ CORE FUNCTIONS ]

-- 1. ระบบดูดลูกแก้ว (Magnet)
game:GetService("Workspace").DescendantAdded:Connect(function(obj)
    if _G.Nammon_Configs.DelOrb and (obj.Name:find("Orb") or obj.Name:find("Loot")) then
        task.wait(0.1)
        pcall(function()
            local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if hrp then 
                if obj:IsA("BasePart") then obj.CFrame = hrp.CFrame 
                elseif obj:IsA("Model") then obj:MoveTo(hrp.Position) end
            end
        end)
    end
end)

-- 2. ระบบล่องหนไร้ชื่อ (Ghost Mode)
local function ToggleGhost(state)
    local char = LP.Character
    if not char or not char:FindFirstChild("Humanoid") then return end
    char.Humanoid.DisplayDistanceType = state and Enum.HumanoidDisplayDistanceType.None or Enum.HumanoidDisplayDistanceType.Viewer
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") or v:IsA("Decal") then
            if state then
                if not v:FindFirstChild("OldT") then Instance.new("NumberValue", v).Name = "OldT" v:FindFirstChild("OldT").Value = v.Transparency end
                v.Transparency = 1 v.CanTouch = false
            else
                if v:FindFirstChild("OldT") then v.Transparency = v:FindFirstChild("OldT").Value v.CanTouch = true v:FindFirstChild("OldT"):Destroy() end
            end
        end
    end
end

-- 3. ระบบกันระเบิด Triple Dodge
game:GetService("Workspace").DescendantAdded:Connect(function(obj)
    if (_G.Nammon_Configs.NoBlast and obj.Name == "Explosion") or 
       (_G.Nammon_Configs.NoRunner and obj.Name == "RunnerExplosion") or
       (_G.Nammon_Configs.NoCannon and (obj.Name == "CannonBall" or obj.Name == "Shell")) then
        task.wait() obj:Destroy()
    end
end)

-- [ 🖥️ UI CONSTRUCTION ]
local Gui = Instance.new("ScreenGui", LP.PlayerGui)
local Main = Instance.new("Frame", Gui); Main.Size, Main.Position = UDim2.new(0, 520, 0, 340), UDim2.new(0.5, -260, 0.5, -170)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 25); Main.Active, Main.Draggable = true, true
Instance.new("UICorner", Main); Instance.new("UIStroke", Main).Color = Color3.fromRGB(255, 80, 0)

-- Header (ชื่อมหาเทพ)
local Title = Instance.new("TextLabel", Main)
Title.Size, Title.Position = UDim2.new(1, -20, 0, 40), UDim2.new(0, 20, 0, 5)
Title.Text = "🕵️ NAMMON SPY V1.0 [OFFICIAL] - BY NAMMON"
Title.TextColor3, Title.Font, Title.TextSize = Color3.new(1,1,1), "GothamBold", 18
Title.BackgroundTransparency, Title.TextXAlignment = 1, "Left"

-- [ 📂 SIDEBAR & CONTENT ]
local Sidebar = Instance.new("Frame", Main); Sidebar.Size, Sidebar.Position = UDim2.new(0, 140, 1, -70), UDim2.new(0, 10, 0, 55)
Sidebar.BackgroundTransparency = 1; Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 5)

local Content = Instance.new("ScrollingFrame", Main); Content.Size, Content.Position = UDim2.new(1, -170, 1, -70), UDim2.new(0, 160, 0, 55)
Content.BackgroundTransparency, Content.CanvasSize = 1, UDim2.new(0, 0, 3, 0)
Instance.new("UIListLayout", Content).Padding = UDim.new(0, 8)

-- Tab Builder
local function AddTab(name)
    local b = Instance.new("TextButton", Sidebar); b.Size, b.BackgroundColor3 = UDim2.new(1, 0, 0, 42), Color3.fromRGB(40, 40, 45)
    b.Text, b.TextColor3, b.Font = name, Color3.new(1,1,1), "GothamBold"; Instance.new("UICorner", b)
end
AddTab("ผู้เล่น"); AddTab("ผู้รอดชีวิต"); AddTab("ซอมบี้ (Soon)"); AddTab("มองทะลุ"); AddTab("ตั้งค่า")

-- [ 🏗️ BUTTON BUILDER ]
local function NewToggle(txt, icon, key, callback)
    local b = Instance.new("TextButton", Content); b.Size, b.BackgroundColor3 = UDim2.new(0.95, 0, 0, 48), Color3.fromRGB(45, 45, 55)
    b.Text = icon.." "..txt..": OFF"; b.TextColor3, b.Font = Color3.new(1,1,1), "GothamBold"; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        _G.Nammon_Configs[key] = not _G.Nammon_Configs[key]
        b.Text = icon.." "..txt..": "..(_G.Nammon_Configs[key] and "ON" or "OFF")
        b.BackgroundColor3 = _G.Nammon_Configs[key] and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(45, 45, 55)
        if callback then callback(_G.Nammon_Configs[key]) end
    end)
end

-- [ 🚀 DEPLOYING FEATURES ]
NewToggle("ล่องหน (ไร้ชื่อ/กันยิง)", "👻", "Invis", ToggleGhost)
NewToggle("ดูดลูกแก้วอัตโนมัติ", "🔮", "DelOrb")
NewToggle("หลบระเบิดทั่วไป", "🧨", "NoBlast")
NewToggle("หลบระเบิดนักวิ่ง", "🏃", "NoRunner")
NewToggle("หลบปืนใหญ่", "💥", "NoCannon")
NewToggle("ตีความเร็วแสง", "⚡", "FastAnim")

-- ระบบปรับระดับ (Visual)
local function NewCycle(txt, icon, key, max, callback)
    local b = Instance.new("TextButton", Content); b.Size, b.BackgroundColor3 = UDim2.new(0.95, 0, 0, 48), Color3.fromRGB(45, 45, 55)
    b.Text = icon.." "..txt..": OFF"; b.TextColor3, b.Font = Color3.new(1,1,1), "GothamBold"; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() 
        _G.Nammon_Configs[key] = (_G.Nammon_Configs[key] >= max) and 0 or _G.Nammon_Configs[key] + 1
        local levels = {"OFF", "น้อย", "ปานกลาง", "มาก"}
        b.Text = icon.." "..txt..": "..levels[_G.Nammon_Configs[key]+1]
        if callback then callback(_G.Nammon_Configs[key]) end
    end)
end

NewCycle("เอกซเรย์ (X-Ray)", "🩻", "XrayLevel", 3, function(lv)
    local trans = {0, 0.3, 0.5, 0.8}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj:IsDescendantOf(LP.Character) then
            obj.LocalTransparencyModifier = trans[lv+1]
        end
    end
end)

NewCycle("เพิ่มแสง (Brightness)", "💡", "BrightLevel", 3, function(lv)
    local brights = {1, 3, 6, 12}
    Lighting.Brightness = brights[lv+1]
    Lighting.FogEnd = (lv > 0) and 100000 or 1000
end)

-- [ ⚡ RUNTIME ENGINE ]
RunService.Stepped:Connect(function()
    pcall(function()
        local char = LP.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = _G.Nammon_Configs.Speed
            char.Humanoid.JumpPower = _G.Nammon_Configs.Jump
            if _G.Nammon_Configs.FastAnim then for _, t in pairs(char.Humanoid:GetPlayingAnimationTracks()) do t:AdjustSpeed(100) end end
            -- ระบบหลังบ้าน: กัน Fall Damage
            if char.HumanoidRootPart.Velocity.Y < -50 then char.HumanoidRootPart.Velocity = Vector3.new(char.HumanoidRootPart.Velocity.X, 0, char.HumanoidRootPart.Velocity.Z) end
        end
    end)
end)

print("🕵️ NAMMON SPY V1.0 [OFFICIAL] - LOADED SUCCESSFULLY!")
