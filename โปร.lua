-- [[ Nammon ZvH V2.4 - GitHub Version ]] --
local LP = game:GetService("Players").LocalPlayer
local SG = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
SG.Name = "Nammon_GH_V2_4"
SG.ResetOnSpawn = false

_G.S, _G.J, _G.E, _G.X = 16, 50, false, false

local M = Instance.new("Frame", SG)
M.Size = UDim2.new(0, 200, 0, 280); M.Position = UDim2.new(0.5, -100, 0.5, -140)
M.BackgroundColor3 = Color3.fromRGB(25, 25, 25); M.Active = true; M.Draggable = true
Instance.new("UICorner", M)

local function Btn(txt, pos, func, clr)
    local b = Instance.new("TextButton", M)
    b.Size = UDim2.new(0.9, 0, 0, 35); b.Position = pos
    b.BackgroundColor3 = clr or Color3.fromRGB(50, 50, 50)
    b.Text = txt; b.TextColor3 = Color3.new(1,1,1); b.TextScaled = true
    Instance.new("UICorner", b); b.MouseButton1Click:Connect(func)
    return b
end

local sT = Btn("Speed: 16", UDim2.new(0.05, 0, 0.05, 0), function() end)
Btn("-", UDim2.new(0.05, 0, 0.2, 0), function() _G.S = math.max(0, _G.S - 5); sT.Text = "Speed: ".._G.S end, Color3.fromRGB(150, 50, 50)).Size = UDim2.new(0.4, 0, 0, 30)
Btn("+", UDim2.new(0.55, 0, 0.2, 0), function() _G.S = math.min(200, _G.S + 5); sT.Text = "Speed: ".._G.S end, Color3.fromRGB(50, 150, 50)).Size = UDim2.new(0.4, 0, 0, 30)

local jT = Btn("Jump: 50", UDim2.new(0.05, 0, 0.35, 0), function() end)
Btn("-", UDim2.new(0.05, 0, 0.5, 0), function() _G.J = math.max(0, _G.J - 10); jT.Text = "Jump: ".._G.J end, Color3.fromRGB(150, 50, 50)).Size = UDim2.new(0.4, 0, 0, 30)
Btn("+", UDim2.new(0.55, 0, 0.5, 0), function() _G.J = math.min(500, _G.J + 10); jT.Text = "Jump: ".._G.J end, Color3.fromRGB(50, 150, 50)).Size = UDim2.new(0.4, 0, 0, 30)

local eB = Btn("ESP: ปิด", UDim2.new(0.05, 0, 0.65, 0), function() _G.E = not _G.E end, Color3.fromRGB(0, 100, 0))
local xB = Btn("X-Ray: ปิด", UDim2.new(0.05, 0, 0.82, 0), function() _G.X = not _G.X end, Color3.fromRGB(70, 70, 70))

game:GetService("RunService").RenderStepped:Connect(function()
    pcall(function()
        local h = LP.Character:FindFirstChild("Humanoid")
        if h then h.WalkSpeed = _G.S; h.JumpPower = _G.J end
        eB.Text = "ESP: "..(_G.E and "เปิด" or "ปิด")
        xB.Text = "X-Ray: "..(_G.X and "เปิด" or "ปิด")
    end)
end)

task.spawn(function()
    while task.wait(1) do
        for _, v in pairs(workspace:GetChildren()) do
            if v:IsA("Model") and v ~= LP.Character and v:FindFirstChild("Humanoid") then
                local hi = v:FindFirstChild("NammonESP") or Instance.new("Highlight", v)
                hi.Name = "NammonESP"; hi.Enabled = _G.E
                hi.FillColor = (v:FindFirstChild("Zombie") or v.Name:lower():find("zombie")) and Color3.new(1,0,0) or Color3.new(0,1,0)
            elseif v:IsA("BasePart") and v.Name ~= "Baseplate" then
                v.LocalTransparencyModifier = _G.X and 0.6 or 0
            end
        end
    end
end)
