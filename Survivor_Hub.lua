-- [[ 🕵️ SURVIVOR HUB V1.0 - OFFICIAL RELEASE ]] --
-- [[ DEVELOPER: NAMMON SPY (THE FIRST IN THE WORLD) ]] --
-- [[ GAME: ZOMBIE VS HUMAN | FRAME: 500x300 ]] --

local LP = game:GetService("Players").LocalPlayer
local RS = game:GetService("RunService")
local VU = game:GetService("VirtualUser")

-- [ ⚙️ CONFIGURATION SETTINGS ]
_G.Speed = 16
_G.Jump = 50
_G.Invis = false
_G.GhostJump = false
_G.AntiCannon = true
_G.AntiRunner = false
_G.AntiBomb = false
_G.PlayerESP = false
_G.ZombieESP = false
_G.XrayMode = false
_G.BatterySafe = false

-- [ 🌈 RAINBOW RGB BORDER SYSTEM ]
local function MakeRGB(uiPart)
    spawn(function()
        while wait() do
            for i = 0, 1, 0.01 do
                if uiPart then 
                    uiPart.Color = Color3.fromHSV(i, 1, 1)
                    wait(0.01) 
                else 
                    break 
                end
            end
        end
    end)
end

-- [ 🖥️ MAIN UI CONSTRUCTION ]
local SG = LP.PlayerGui:FindFirstChild("Nammon_Pro_Hub") or Instance.new("ScreenGui", LP.PlayerGui)
SG.Name = "Nammon_Pro_Hub"
SG.ResetOnSpawn = false

local Main = Instance.new("Frame", SG)
Main.Name = "MainFrame"
Main.Size = UDim2.new(0, 500, 0, 300)
Main.Position = UDim2.new(0.5, -250, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

-- [ ✨ RGB STROKE ]
local RGB_Border = Instance.new("UIStroke", Main)
RGB_Border.Thickness = 2
RGB_Border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MakeRGB(RGB_Border)

-- [ 🏷️ HEADER SECTION ]
local Title = Instance.new("TextLabel", Main)
Title.Name = "GameTitle"
Title.Size = UDim2.new(0, 200, 0, 20)
Title.Position = UDim2.new(0, 15, 0, 8)
Title.Text = "Z vs H"
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundTransparency = 1
Title.TextXAlignment = "Left"
Title.TextSize = 18
Title.Font = Enum.Font.SourceSansBold

local Credit = Instance.new("TextLabel", Main)
Credit.Name = "DevCredit"
Credit.Size = UDim2.new(0, 200, 0, 15)
Credit.Position = UDim2.new(0, 15, 0, 28)
Credit.Text = "🕵️ NAMMON SPY V1.0"
Credit.TextColor3 = Color3.fromRGB(200, 200, 200)
Credit.BackgroundTransparency = 1
Credit.TextXAlignment = "Left"
Credit.TextSize = 13

-- [ 🔵 MINIMIZE BUTTON ]
local MinBtn = Instance.new("TextButton", Main)
MinBtn.Size = UDim2.new(0, 25, 0, 25)
MinBtn.Position = UDim2.new(1, -35, 0, 10)
MinBtn.Text = "[-]"
MinBtn.TextColor3 = Color3.new(1,1,1)
MinBtn.BackgroundColor3 = Color3.fromRGB(40,40,45)
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(1, 0)

-- [ 📂 SIDEBAR NAVIGATION ]
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 130, 1, -70)
Sidebar.Position = UDim2.new(0, 5, 0, 60)
Sidebar.BackgroundTransparency = 1
local SidebarList = Instance.new("UIListLayout", Sidebar)
SidebarList.Padding = UDim.new(0, 8)

-- [ 📦 CONTAINER SYSTEM ]
local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -145, 1, -70)
Container.Position = UDim2.new(0, 140, 0, 60)
Container.BackgroundTransparency = 1

local Pages = {}
local function CreatePage(name, icon)
    local p = Instance.new("ScrollingFrame", Container)
    p.Size = UDim2.new(1, 0, 1, 0)
    p.Visible = false
    p.BackgroundTransparency = 1
    p.CanvasSize = UDim2.new(0, 0, 0, 500)
    p.ScrollBarThickness = 2
    local l = Instance.new("UIListLayout", p)
    l.Padding = UDim.new(0, 7)
    l.HorizontalAlignment = "Center"
    Pages[name] = p
    
    local b = Instance.new("TextButton", Sidebar)
    b.Size = UDim2.new(1, 0, 0, 38)
    b.Text = icon.." "..name
    b.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    b.TextColor3 = Color3.new(1,1,1)
    b.TextSize = 14
    Instance.new("UICorner", b)
    
    b.MouseButton1Click:Connect(function()
        for _, pg in pairs(Pages) do pg.Visible = false end
        p.Visible = true
    end)
    return p
end

-- [ 🟢🔴 CLASSIC ADJUSTER COMPONENT ]
local function CreateClassicAdjuster(p, title, setting, step, delay, min, max)
    local f = Instance.new("Frame", p)
    f.Size = UDim2.new(0.95, 0, 0, 45)
    f.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Instance.new("UICorner", f)
    
    local t = Instance.new("TextLabel", f)
    t.Size = UDim2.new(0.4, 0, 1, 0)
    t.Position = UDim2.new(0.3, 0, 0, 0)
    t.Text = title..": [".._G[setting].."]"
    t.TextColor3 = Color3.new(1,1,1)
    t.BackgroundTransparency = 1
    t.TextSize = 14
    
    local m = Instance.new("TextButton", f)
    m.Size = UDim2.new(0, 35, 0, 35)
    m.Position = UDim2.new(0, 5, 0, 5)
    m.Text = "-"
    m.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    m.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", m)
    
    local a = Instance.new("TextButton", f)
    a.Size = UDim2.new(0, 35, 0, 35)
    a.Position = UDim2.new(1, -40, 0, 5)
    a.Text = "+"
    a.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    a.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", a)
    
    -- Click Logic with Long Press
    m.MouseButton1Down:Connect(function()
        spawn(function()
            while wait(delay) and m.Parent do
                _G[setting] = math.max(min, _G[setting] - step)
                t.Text = title..": [".._G[setting].."]"
            end
        end)
    end)
    
    a.MouseButton1Down:Connect(function()
        spawn(function()
            while wait(delay) and a.Parent do
                _G[setting] = math.min(max, _G[setting] + step)
                t.Text = title..": [".._G[setting].."]"
            end
        end)
    end)
end

-- [ 🔘 BUTTON COMPONENT ]
local function Btn(p, txt, func, clr)
    local b = Instance.new("TextButton", p)
    b.Size = UDim2.new(0.95, 0, 0, 38)
    b.Text = txt
    b.BackgroundColor3 = clr or Color3.fromRGB(45, 45, 50)
    b.TextColor3 = Color3.new(1,1,1)
    b.TextSize = 14
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(func)
    return b
end

-- --- [[ TABS CONFIGURATION ]] ---
local p1 = CreatePage("Player", "👤")
CreateClassicAdjuster(p1, "Speed", "Speed", 1, 0.5, 1, 200)
CreateClassicAdjuster(p1, "Jump", "Jump", 5, 0.5, 1, 250)
Btn(p1, "👻 Invisible Mode", function() end)
Btn(p1, "🧗 Ghost Jump (Pass Wall)", function() _G.GhostJump = not _G.GhostJump end)
Btn(p1, "♻️ Reset Character", function() LP.Character.Humanoid.Health = 0 end, Color3.fromRGB(120, 0, 0))

local p2 = CreatePage("Zombie", "🧟")
Btn(p2, "🛡️ Cannon Dodge (Official)", function() end)
Btn(p2, "🏃 Runner Dodge (Auto)", function() end)
Btn(p2, "🧨 Bomb Dodge (Safe)", function() end)

local p3 = CreatePage("Visual", "👁️")
Btn(p3, "🧊 X-Ray Vision", function() end)
Btn(p3, "👤 Player ESP", function() end)
Btn(p3, "🧟 Zombie ESP", function() end)

local p4 = CreatePage("AFK", "💤")
Btn(p4, "🔋 Battery Saver", function() end)
Btn(p4, "🚀 Anti-AFK Kick", function() end)

-- [ 🔄 MINIMIZE LOGIC ]
local IsMin = false
MinBtn.MouseButton1Click:Connect(function()
    IsMin = not IsMin
    Main:TweenSize(IsMin and UDim2.new(0, 500, 0, 45) or UDim2.new(0, 500, 0, 300), "Out", "Quad", 0.3)
    MinBtn.Text = IsMin and "[+]" or "[-]"
end)

-- [ 🏁 FINAL EXECUTION ]
Pages["Player"].Visible = true
RS.Stepped:Connect(function()
    pcall(function()
        LP.Character.Humanoid.WalkSpeed = _G.Speed
        LP.Character.Humanoid.JumpPower = _G.Jump
    end)
end)

print("SURVIVOR HUB V1.0 LOADED SUCCESSFULLY!")
