-- [[ Nammon ZvH V3.5 - Vengeance Edition ]] --
local LP = game:GetService("Players").LocalPlayer
local RS = game:GetService("RunService")
local SG = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
SG.Name = "Nammon_V3_5"; SG.ResetOnSpawn = false

_G.S, _G.J, _G.E, _G.X, _G.NC = 16, 50, false, false, false

-- [ 🔵 ลูกแก้วนีออน RGB ]
local Orb = Instance.new("TextButton", SG); Orb.Size = UDim2.new(0, 50, 0, 50); Orb.Position = UDim2.new(0, 20, 0.5, -25); Orb.Draggable = true
Orb.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Orb.Text = "🕵️"; Orb.TextSize = 28; Instance.new("UICorner", Orb).CornerRadius = UDim.new(1, 0)
local OSt = Instance.new("UIStroke", Orb); OSt.Thickness = 3; OSt.ApplyStrokeMode = "Border"
task.spawn(function() while task.wait(0.05) do local h = tick() % 3 / 3; OSt.Color = Color3.fromHSV(h, 0.8, 1); Orb.TextStrokeColor3 = OSt.Color; Orb.TextStrokeTransparency = 0.5 end end)

-- [ 🖥️ Main UI ]
local M = Instance.new("Frame", SG); M.Size = UDim2.new(0, 220, 0, 320); M.Position = UDim2.new(0.5, -110, 0.5, -160); M.Visible = false; M.Active = true; M.Draggable = true; Instance.new("UICorner", M); M.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Orb.MouseButton1Click:Connect(function() M.Visible = not M.Visible end)
local SF = Instance.new("ScrollingFrame", M); SF.Size = UDim2.new(1, -10, 1, -10); SF.Position = UDim2.new(0, 5, 0, 5); SF.BackgroundTransparency = 1; SF.CanvasSize = UDim2.new(0, 0, 0, 500); SF.ScrollBarThickness = 3
local LL = Instance.new("UIListLayout", SF); LL.HorizontalAlignment = "Center"; LL.Padding = UDim.new(0, 8)
local function Btn(txt, func, clr) local b = Instance.new("TextButton", SF); b.Size = UDim2.new(0.95, 0, 0, 38); b.BackgroundColor3 = clr or Color3.fromRGB(40, 40, 40); b.Text = txt; b.TextColor3 = Color3.new(1,1,1); b.TextScaled = true; Instance.new("UICorner", b); b.MouseButton1Click:Connect(func) return b end

-- [ ⚙️ ระบบควบคุม ]
local function CreateCounter(prefix, var, step) local label = Btn(prefix..": ".._G[var], function() end); local frame = Instance.new("Frame", SF); frame.Size = UDim2.new(0.95, 0, 0, 35); frame.BackgroundTransparency = 1; local function SetupBtn(t,v,c,p) local b = Instance.new("TextButton", frame); b.Size = UDim2.new(0.45, 0, 1, 0); b.Position = p; b.BackgroundColor3 = c; b.Text = t; b.TextColor3 = Color3.new(1,1,1); b.TextScaled = true; Instance.new("UICorner", b); local h = false; b.MouseButton1Down:Connect(function() h = true; while h do _G[var] = math.clamp(_G[var] + v, 0, 500); label.Text = prefix..": ".._G[var]; task.wait(0.15) end end); b.MouseButton1Up:Connect(function() h = false end); b.MouseLeave:Connect(function() h = false end) end; SetupBtn("-",-step,Color3.fromRGB(150,50,50),UDim2.new(0,0,0,0)); SetupBtn("+",step,Color3.fromRGB(50,150,50),UDim2.new(0.55,0,0,0)) end
CreateCounter("Speed", "S", 5); CreateCounter("Jump", "J", 5)
local eB = Btn("ESP: ปิด", function() _G.E = not _G.E end, Color3.fromRGB(0, 100, 0))
local xB = Btn("X-Ray: ปิด", function() _G.X = not _G.X end, Color3.fromRGB(60, 60, 60))
local nB = Btn("กระโดดทะลุ: ปิด", function() _G.NC = not _G.NC end, Color3.fromRGB(150, 100, 0))

-- [ ⚙️ ระบบตัวละคร ]
RS.RenderStepped:Connect(function() pcall(function() 
    local char = LP.Character; if not char then return end
    local h = char:FindFirstChildOfClass("Humanoid")
    if h then h.WalkSpeed = _G.S; h.JumpPower = _G.J; h.UseJumpPower = true end
    eB.Text = "ESP: "..(_G.E and "เปิด" or "ปิด"); xB.Text = "X-Ray: "..(_G.X and "เปิด" or "ปิด"); nB.Text = "กระโดดทะลุ: "..(_G.NC and "เปิด" or "ปิด")
    if char.PrimaryPart.Velocity.Y < -65 then char.PrimaryPart.Velocity = Vector3.new(char.PrimaryPart.Velocity.X, -5, char.PrimaryPart.Velocity.Z) end
end) end)

-- [ ⚙️ Ultimate Vengeance ESP ]
task.spawn(function()
    while task.wait(0.5) do -- สแกนไวขึ้นเพื่อความสะใจ
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Humanoid") and v.Parent and v.Parent ~= LP.Character then
                local char = v.Parent
                local isPlayer = game.Players:GetPlayerFromCharacter(char)
                local h = char:FindFirstChild("NammonESP") or Instance.new("Highlight", char)
                h.Name = "NammonESP"; h.Enabled = _G.E; h.Adornee = char
                
                if isPlayer then
                    h.FillColor = Color3.new(0, 1, 0); h.FillTransparency = 0.6; h.OutlineTransparency = 0.5
                else
                    local enemyType = "normal"
                    for _, item in pairs(char:GetDescendants()) do
                        local n = item.Name:lower()
                        if n:find("pick") or n:find("mine") or n:find("missile") or n:find("launcher") or n:find("gold") then
                            enemyType = "target" break -- เป้าหมายหลัก!
                        elseif n:find("sword") or n:find("bow") or n:find("arrow") or n:find("blade") then
                            enemyType = "danger"
                        end
                    end
                    
                    if enemyType == "target" then
                        -- # สีทองเรืองแสง (เป้าหมายล้างแค้น)
                        h.FillColor = Color3.fromRGB(255, 215, 0)
                        h.FillTransparency = 0 -- ทึบแสง มองเห็นชัดสุดๆ
                        h.OutlineColor = Color3.fromRGB(255, 255, 255) -- ขอบขาวนีออน
                        h.OutlineTransparency = 0
                    elseif enemyType == "danger" then
                        h.FillColor = Color3.fromRGB(160, 32, 240); h.FillTransparency = 0.4; h.OutlineTransparency = 0.2
                    else
                        h.FillColor = Color3.new(1, 0, 0); h.FillTransparency = 0.5; h.OutlineTransparency = 0.3
                    end
                end
            end
            if _G.X and v:IsA("BasePart") and not v:IsDescendantOf(LP.Character) and v.Name ~= "Baseplate" then
                v.LocalTransparencyModifier = 0.7
            elseif not _G.X and v:IsA("BasePart") then
                v.LocalTransparencyModifier = 0
            end
        end
    end
end)
