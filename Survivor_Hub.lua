-- [[ NAMMON SPY V1.4 - Official Multi-Tab Hub ]] --
-- ผู้พัฒนา: Nammon (ร่วมกับพี่ Gemini)
-- เกม: Zombie vs Human & Ball TD

local LP = game:GetService("Players").LocalPlayer
local RS = game:GetService("RunService")
local VU = game:GetService("VirtualUser")

-- [ ⚙️ Global Settings ]
_G.Speed = 16
_G.Jump = 50
_G.Invis = false
_G.AntiCannon = true
_G.PlayerESP = false
_G.ZombieESP = false
_G.XrayMode = false
_G.BatterySafe = false

-- [ 🖥️ UI Design - กว้าง 500 / สูง 300 ]
local SG = LP.PlayerGui:FindFirstChild("Nammon_Pro_Hub") or Instance.new("ScreenGui", LP.PlayerGui)
SG.Name = "Nammon_Pro_Hub"; SG.ResetOnSpawn = false

local Main = Instance.new("Frame", SG); Main.Size = UDim2.new(0, 500, 0, 300); Main.Position = UDim2.new(0.5, -250, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 25); Main.Active = true; Main.Draggable = true; Instance.new("UICorner", Main)

-- Sidebar (แถบเมนูด้านซ้าย)
local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0, 130, 1, -10); Sidebar.Position = UDim2.new(0, 5, 0, 5); Sidebar.BackgroundTransparency = 1
local SidebarList = Instance.new("UIListLayout", Sidebar); SidebarList.Padding = UDim.new(0, 5)

-- Container (พื้นที่แสดงเนื้อหาด้านขวา)
local Container = Instance.new("Frame", Main); Container.Size = UDim2.new(1, -145, 1, -45); Container.Position = UDim2.new(0, 140, 0, 40); Container.BackgroundTransparency = 1
local Title = Instance.new("TextLabel", Main); Title.Size = UDim2.new(0, 300, 0, 30); Title.Position = UDim2.new(0, 140, 0, 5); Title.Text = "🕵️ NAMMON SPY V1.4 - Zombie vs Human"; Title.TextColor3 = Color3.new(1,1,1); Title.BackgroundTransparency = 1; Title.TextXAlignment = "Left"; Title.TextSize = 16

-- ฟังก์ชันสลับหน้า (Tabs)
local Pages = {}
local function CreatePage(name)
    local p = Instance.new("ScrollingFrame", Container); p.Size = UDim2.new(1, 0, 1, 0); p.Visible = false; p.BackgroundTransparency = 1; p.CanvasSize = UDim2.new(0, 0, 0, 500); p.ScrollBarThickness = 2
    local l = Instance.new("UIListLayout", p); l.Padding = UDim.new(0, 6); l.HorizontalAlignment = "Center"
    Pages[name] = p
    
    local b = Instance.new("TextButton", Sidebar); b.Size = UDim2.new(1, 0, 0, 35); b.Text = name; b.BackgroundColor3 = Color3.fromRGB(45, 45, 50); b.TextColor3 = Color3.new(1,1,1); b.TextSize = 14; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        for _, pg in pairs(Pages) do pg.Visible = false end
        p.Visible = true
    end)
    return p
end

local function Btn(p, txt, func, clr)
    local b = Instance.new("TextButton", p); b.Size = UDim2.new(0.95, 0, 0, 35); b.Text = txt; b.BackgroundColor3 = clr or Color3.fromRGB(55, 55, 60); b.TextColor3 = Color3.new(1,1,1); b.TextScaled = true; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(func); return b
end

-- --- [ หมวดที่ 1: 👤 Player ] ---
local p1 = CreatePage("👤 Player")
Btn(p1, "🏃 วิ่งเร็ว (Speed: 50)", function(b) _G.Speed = (_G.Speed == 16 and 50 or 16); b.Text = (_G.Speed == 50 and "🏃 วิ่งเร็ว: [เปิด]" or "🏃 วิ่งเร็ว: [ปกติ]") end)
Btn(p1, "🚀 กระโดดสูง (Jump: 120)", function(b) _G.Jump = (_G.Jump == 50 and 120 or 50); b.Text = (_G.Jump == 120 and "🚀 กระโดดสูง: [เปิด]" or "🚀 กระโดดสูง: [ปกติ]") end)
Btn(p1, "👻 ล่องหน (Invisible)", function()
    _G.Invis = not _G.Invis
    for _, v in pairs(LP.Character:GetDescendants()) do
        if v:IsA("BasePart") or v:IsA("Decal") then v.Transparency = _G.Invis and 1 or 0
        elseif v:IsA("Accessory") then v.Handle.Transparency = _G.Invis and 1 or 0 end
    end
end)
Btn(p1, "♻️ รีเซ็ตตัวละคร (Reset)", function() LP.Character.Humanoid.Health = 0 end, Color3.fromRGB(120, 0, 0))

-- --- [ หมวดที่ 2: 🧟 Zombie ] ---
local p2 = CreatePage("🧟 Zombie")
Btn(p2, "🛡️ หลบปืนใหญ่บักทอง (Auto Dodge)", function(b) _G.AntiCannon = not _G.AntiCannon; b.BackgroundColor3 = _G.AntiCannon and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(55, 55, 60) end)
Btn(p2, "🧗 กระโดดทะลุ (Ghost Jump)", function() _G.GhostJump = not _G.GhostJump end)

-- --- [ หมวดที่ 3: 👁️ Visual ] ---
local p3 = CreatePage("👁️ Visual")
Btn(p3, "🧊 X-Ray (มองฉากจางๆ)", function() 
    _G.XrayMode = not _G.XrayMode
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and not v:IsDescendantOf(LP.Character) then v.LocalTransparencyModifier = _G.XrayMode and 0.5 or 0 end
    end
end)
Btn(p3, "👤 มองเห็นคน (Player ESP)", function() _G.PlayerESP = not _G.PlayerESP end)
Btn(p3, "🧟 มองซอมบี้ (Zombie ESP)", function() _G.ZombieESP = not _G.ZombieESP end)

-- --- [ หมวดที่ 4: ⚙️ ระบบหลังบ้าน ] ---
local p4 = CreatePage("⚙️ หลังบ้าน")
Btn(p4, "🔋 ประหยัดแบต (Battery Safe)", function() 
    _G.BatterySafe = not _G.BatterySafe; RS:Set3dRenderingEnabled(not _G.BatterySafe); setfpscap(_G.BatterySafe and 10 or 60)
end)
Btn(p4, "🚀 วาร์ปไปแอบ (รักษาของ)", function() 
    LP.Character.HumanoidRootPart.CFrame = LP.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5000, 0)
    local p = Instance.new("Part", workspace); p.Size = Vector3.new(20,1,20); p.Anchored = true; p.CFrame = LP.Character.HumanoidRootPart.CFrame * CFrame.new(0,-3.5,0)
end)

-- [ 🔄 Loop ระบบทำงาน ]
RS.Stepped:Connect(function()
    pcall(function()
        local char = LP.Character; local hum = char.Humanoid
        hum.WalkSpeed = _G.Speed; hum.JumpPower = _G.Jump
        -- ระบบกันปืนใหญ่
        if _G.AntiCannon then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and v.Name:lower():find("cannon") then
                    if (char.PrimaryPart.Position - v.Position).Magnitude < 25 then char.PrimaryPart.CFrame = char.PrimaryPart.CFrame * CFrame.new(0, 0, 50) end
                end
            end
        end
    end)
end)

Pages["👤 Player"].Visible = true
print("NAMMON SPY V1.4 LOADED!")
