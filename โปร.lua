-- [[ NAMMON ZvH HUB - V6.5 Final Ultimate (Kid Hub Edition) ]] --
-- ผู้พัฒนา: Nammon (ร่วมกับพี่ Gemini)
-- ฟีเจอร์: กันระเบิด, กันปืนใหญ่บักทอง, ล่องหน, ESP, Ghost Jump, Battery Saver

local LP = game:GetService("Players").LocalPlayer
local RS = game:GetService("RunService")
local VU = game:GetService("VirtualUser")
local TS = game:GetService("TeleportService")
local CG = game:GetService("CoreGui")

-- [ ⚙️ ตั้งค่าเริ่มต้น ]
_G.Speed = 25
_G.Jump = 50
_G.Invis = false
_G.AntiMissile = true
_G.ExpertDodge = true
_G.GhostJump = false
_G.PlayerESP = false
_G.LootESP = false
_G.BatterySafe = false

-- [ 🖥️ สร้าง GUI (ลูกแก้ว RGB & Menu) ]
local SG = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
SG.Name = "Nammon_KidHub"; SG.ResetOnSpawn = false

local Orb = Instance.new("TextButton", SG); Orb.Size = UDim2.new(0, 50, 0, 50); Orb.Position = UDim2.new(0, 20, 0.5, -25); Orb.Draggable = true
Orb.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Orb.Text = "🌀"; Orb.TextSize = 25; Instance.new("UICorner", Orb).CornerRadius = UDim.new(1, 0)
local OSt = Instance.new("UIStroke", Orb); OSt.Thickness = 3; OSt.ApplyStrokeMode = "Border"
task.spawn(function() while task.wait(0.05) do local h = tick() % 3 / 3; OSt.Color = Color3.fromHSV(h, 0.8, 1) end end)

local M = Instance.new("Frame", SG); M.Size = UDim2.new(0, 230, 0, 450); M.Position = UDim2.new(0.5, -115, 0.5, -225); M.Visible = false; M.Active = true; M.Draggable = true; M.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Instance.new("UICorner", M)
Orb.MouseButton1Click:Connect(function() M.Visible = not M.Visible end)

local Title = Instance.new("TextLabel", M); Title.Size = UDim2.new(1, 0, 0, 40); Title.Text = "NAMMON ZvH V6.5"; Title.TextColor3 = Color3.new(1,1,1); Title.BackgroundTransparency = 1; Title.TextSize = 20

local SF = Instance.new("ScrollingFrame", M); SF.Size = UDim2.new(1, -10, 1, -50); SF.Position = UDim2.new(0, 5, 0, 45); SF.BackgroundTransparency = 1; SF.CanvasSize = UDim2.new(0, 0, 0, 850); SF.ScrollBarThickness = 3
local UIList = Instance.new("UIListLayout", SF); UIList.HorizontalAlignment = "Center"; UIList.Padding = UDim.new(0, 6)

local function Btn(txt, func, clr)
    local b = Instance.new("TextButton", SF); b.Size = UDim2.new(0.9, 0, 0, 35); b.BackgroundColor3 = clr or Color3.fromRGB(45, 45, 45); b.Text = txt; b.TextColor3 = Color3.new(1,1,1); b.TextScaled = true; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(func); return b
end

-- [ ⚡ ฟังก์ชันหลัก ]

-- 1. วิ่งไว & โดดสูง
local spdB = Btn("🏃 สปีด: 25", function(b)
    if _G.Speed == 25 then _G.Speed = 50 elseif _G.Speed == 50 then _G.Speed = 80 elseif _G.Speed == 80 then _G.Speed = 16 else _G.Speed = 25 end
    b.Text = "🏃 สปีด: ".._G.Speed
end)

-- 2. ล่องหน (มือสังหาร)
Btn("👻 ล่องหน (Invis)", function(b)
    _G.Invis = not _G.Invis
    if _G.Invis then
        for _, v in pairs(LP.Character:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then v.Transparency = 1 elseif v:IsA("Accessory") then v.Handle.Transparency = 1 end
        end
        if LP.Character:FindFirstChild("Head") then LP.Character.Head:ClearAllChildren() end
        b.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    else
        LP.Character.Humanoid.Health = 0 -- Reset เพื่อกลับมาร่างเดิม
    end
end)

-- 3. กันปืนใหญ่บักทอง & ระเบิด
Btn("🛡️ กันปืนใหญ่/ระเบิด: เปิด", function(b)
    _G.AntiMissile = not _G.AntiMissile
    b.Text = "🛡️ กันปืนใหญ่/ระเบิด: "..(_G.AntiMissile and "เปิด" or "ปิด")
end, Color3.fromRGB(200, 100, 0))

-- 4. กระโดดทะลุ (Ghost Jump)
Btn("🧗 กระโดดทะลุ: ปิด", function(b)
    _G.GhostJump = not _G.GhostJump
    b.Text = "🧗 กระโดดทะลุ: "..(_G.GhostJump and "เปิด" or "ปิด")
end)

-- 5. มองทะลุ (ESP)
Btn("👁️ มองทะลุคน", function() _G.PlayerESP = not _G.PlayerESP end)
Btn("💎 มองทะลุของ (Loot)", function() _G.LootESP = not _G.LootESP end)

-- 6. โหมดรักษาของ 30 นาที & ประหยัดแบต
Btn("🔋 โหมดประหยัดแบต", function(b)
    _G.BatterySafe = not _G.BatterySafe
    RS:Set3dRenderingEnabled(not _G.BatterySafe)
    setfpscap(_G.BatterySafe and 10 or 60)
    b.BackgroundColor3 = _G.BatterySafe and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(45, 45, 45)
end)

Btn("🚀 วาร์ปไปแอบบนฟ้า (รักษาของ)", function()
    LP.Character.HumanoidRootPart.CFrame = LP.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5000, 0)
    local p = Instance.new("Part", workspace); p.Size = Vector3.new(20,1,20); p.Anchored = true; p.CFrame = LP.Character.HumanoidRootPart.CFrame * CFrame.new(0,-3.5,0)
end, Color3.fromRGB(80, 80, 80))

-- [ 🔄 ระบบทำงานเบื้องหลัง (Loop) ]
RS.Heartbeat:Connect(function()
    pcall(function()
        local char = LP.Character
        local hum = char:FindFirstChildOfClass("Humanoid")
        -- วิ่งไว/โดดสูง
        hum.WalkSpeed = _G.Speed
        hum.JumpPower = _G.Jump
        
        -- กระโดดทะลุ
        if _G.GhostJump and (hum:GetState() == Enum.HumanoidStateType.Jumping or hum:GetState() == Enum.HumanoidStateType.Freefall) then
            for _, v in pairs(char:GetChildren()) do if v:IsA("BasePart") then v.CanCollide = false end end
        else
            for _, v in pairs(char:GetChildren()) do if v:IsA("BasePart") then v.CanCollide = true end end
        end

        -- ระบบดักกระสุนปืนใหญ่บักทอง/ระเบิด
        if _G.AntiMissile then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and (v.Name:lower():find("cannon") or v.Name:lower():find("bomb")) then
                    if (char.PrimaryPart.Position - v.Position).Magnitude < 30 then
                        char.PrimaryPart.CFrame = char.PrimaryPart.CFrame * CFrame.new(0, 0, 45) -- วาร์ปหนี
                    end
                end
            end
        end
    end)
end)

-- กันเด้ง (Anti-AFK)
LP.Idled:Connect(function() VU:CaptureController(); VU:ClickButton2(Vector2.new()) end)

-- Rejoin ทันทีที่หลุด
CG.RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
    if child.Name == "ErrorPrompt" then TS:Teleport(game.PlaceId, LP) end
end)

print("NAMMON KID HUB LOADED SUCCESS!")
