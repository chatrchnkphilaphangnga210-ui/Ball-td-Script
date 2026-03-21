-- [[ Nammon ZvH V2.6 - Full Function & Orb ]] --
local LP = game:GetService("Players").LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local SG = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
SG.Name = "Nammon_V2_6"; SG.ResetOnSpawn = false

_G.S, _G.J, _G.E, _G.X, _G.NC = 16, 50, false, false, false

-- [ 🔵 ลูกแก้วเปิด/ปิด (Orb) ]
local Orb = Instance.new("TextButton", SG)
Orb.Size = UDim2.new(0, 45, 0, 45); Orb.Position = UDim2.new(0, 10, 0.5, 0)
Orb.BackgroundColor3 = Color3.fromRGB(30, 30, 30); Orb.Text = "🕵️"; Orb.TextSize = 25
Orb.Draggable = true; Instance.new("UICorner", Orb).CornerRadius = UDim.new(1, 0)
local OSt = Instance.new("UIStroke", Orb); OSt.Thickness = 2; task.spawn(function() while task.wait(0.1) do OSt.Color = Color3.fromHSV(tick() % 5 / 5, 0.8, 1) end end)

-- [ 🖥️ Main UI ]
local M = Instance.new("Frame", SG)
M.Size = UDim2.new(0, 220, 0, 320); M.Position = UDim2.new(0.5, -110, 0.5, -160)
M.BackgroundColor3 = Color3.fromRGB(15, 15, 15); M.Visible = false; M.Active = true; M.Draggable = true
Instance.new("UICorner", M)
Orb.MouseButton1Click:Connect(function() M.Visible = not M.Visible end)

-- [ 📜 Scrolling Frame ]
local SF = Instance.new("ScrollingFrame", M)
SF.Size = UDim2.new(1, -10, 1, -10); SF.Position = UDim2.new(0, 5, 0, 5)
SF.BackgroundTransparency = 1; SF.CanvasSize = UDim2.new(0, 0, 0, 450); SF.ScrollBarThickness = 2
local LL = Instance.new("UIListLayout", SF); LL.HorizontalAlignment = "Center"; LL.Padding = UDim.new(0, 8)

local function Btn(txt, func, clr)
    local b = Instance.new("TextButton", SF)
    b.Size = UDim2.new(0.95, 0, 0, 38); b.BackgroundColor3 = clr or Color3.fromRGB(40, 40, 40)
    b.Text = txt; b.TextColor3 = Color3.new(1,1,1); b.TextScaled = true; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(func); return b
end

-- [ 🛠️ Buttons ]
local sL = Btn("Speed: 16", function() end)
task.spawn(function()
    local function Hold(b, v) local h = false; b.MouseButton1Down:Connect(function() h = true; while h do _G.S = math.clamp(_G.S + v, 0, 200); sL.Text = "Speed: ".._G.S; task.wait(0.3) end end); b.MouseButton1Up:Connect(function() h = false end) end
    local f = Instance.new("Frame", SF); f.Size = UDim2.new(0.95, 0, 0, 35); f.BackgroundTransparency = 1
    local m = Btn("-", function() end, Color3.fromRGB(150, 50, 50)); m.Parent = f; m.Size = UDim2.new(0.45, 0, 1, 0); Hold(m, -1)
    local p = Btn("+", function() end, Color3.fromRGB(50, 150, 50)); p.Parent = f; p.Position = UDim2.new(0.55, 0, 0, 0); p.Size = UDim2.new(0.45, 0, 1, 0); Hold(p, 1)
end)

local jL = Btn("Jump: 50", function() end)
Btn("ปรับ Jump +10", function() _G.J = (_G.J >= 500 and 50 or _G.J + 10); jL.Text = "Jump: ".._G.J end)

local eB = Btn("ESP: ปิด", function() _G.E = not _G.E end, Color3.fromRGB(0, 100, 0))
local xB = Btn("X-Ray: ปิด", function() _G.X = not _G.X end, Color3.fromRGB(60, 60, 60))
local nB = Btn("กระโดดทะลุ: ปิด", function() _G.NC = not _G.NC end, Color3.fromRGB(150, 100, 0))

-- [ ⚙️ Systems ]
RS.RenderStepped:Connect(function()
    pcall(function()
        local h = LP.Character:FindFirstChildOfClass("Humanoid")
        if h then 
            h.WalkSpeed = _G.S; h.JumpPower = _G.J; h.UseJumpPower = true 
            if _G.NC and h.FloorMaterial == Enum.Material.Air then
                for _, p in pairs(LP.Character:GetChildren()) do if p:IsA("BasePart") then p.CanCollide = false end end
            end
        end
        eB.Text = "ESP: "..(_G.E and "เปิด" or "ปิด")
        xB.Text = "X-Ray: "..(_G.X and "เปิด" or "ปิด")
        nB.Text = "กระโดดทะลุ: "..(_G.NC and "เปิด" or "ปิด")
        
        -- Anti Fall Damage (เบรกความเร็วตกพื้น)
        if LP.Character.PrimaryPart.Velocity.Y < -60 then
            LP.Character.PrimaryPart.Velocity = Vector3.new(LP.Character.PrimaryPart.Velocity.X, -5, LP.Character.PrimaryPart.Velocity.Z)
        end
    end)
end)

task.spawn(function()
    while task.wait(1.5) do
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Humanoid") and v.Parent and v.Parent ~= LP.Character then
                local h = v.Parent:FindFirstChild("NammonESP") or Instance.new("Highlight", v.Parent)
                h.Name = "NammonESP"; h.Enabled = _G.E
                h.FillColor = (v.Parent:FindFirstChild("Zombie") or v.Parent.Name:lower():find("zombie")) and Color3.new(1,0,0) or Color3.new(0,1,0)
            end
            if _G.X and v:IsA("BasePart") and not v:IsDescendantOf(LP.Character) and v.Name ~= "Baseplate" then
                v.LocalTransparencyModifier = 0.7
            elseif not _G.X and v:IsA("BasePart") then
                v.LocalTransparencyModifier = 0
            end
        end
    end
end)
