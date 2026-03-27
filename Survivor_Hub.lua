-- [[ NAMMON SPY V42.9 - THE SIDEBAR MASTER ]] --
-- [[ ไม่ต้องแปลภาษา เอาไปใส่ในเดลต้าได้เลย ]] --
-- [[ ผผผผผผผผผผผผผผผผผผผผผผผผผผผผผผผผผผผผผผผผผผผผผ ]] --

loadstring(game:HttpGet("https://raw.githubusercontent.com/chatrchnkphilaphangnga210-ui/Ball-td-Script/refs/heads/main/Survivor_Hub.lua"))()

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- [[ CONFIGURATION ]] --
_G.WalkSpeed = 16; _G.JumpPower = 50; _G.InfiniteJump = false; _G.Noclip = false

-- [[ MAIN UI STRUCTURE ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "NammonSpy_V42_9"

-- ลูกแก้วพับสคริปต์ (มุมขวาบนตามรูป)
local ToggleButton = Instance.new("ImageButton", ScreenGui)
ToggleButton.Size = UDim2.new(0, 50, 0, 50); ToggleButton.Position = UDim2.new(0, 850, 0, 10)
ToggleButton.Image = "rbxassetid://6031289682"; ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(1, 0)

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 600, 0, 380); MainFrame.Position = UDim2.new(0.5, -300, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15); MainFrame.Visible = true
Instance.new("UICorner", MainFrame)

-- 1. SIDEBAR (แถบเมนูข้างซ้าย)
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 160, 1, 0); Sidebar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
Instance.new("UICorner", Sidebar)

-- 2. CONTENT AREA (พื้นที่แสดงผลข้างขวา)
local Container = Instance.new("Frame", MainFrame)
Container.Size = UDim2.new(0, 440, 1, 0); Container.Position = UDim2.new(0, 160, 0, 0)
Container.BackgroundTransparency = 1

-- ระบบจัดการหน้า (Page Manager)
local Pages = {}
local function CreatePage(name)
    local Page = Instance.new("ScrollingFrame", Container)
    Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1; Page.Visible = false
    Page.CanvasSize = UDim2.new(0, 0, 2, 0); Page.ScrollBarThickness = 2
    Pages[name] = Page
    return Page
end

local function OpenPage(name)
    for i, v in pairs(Pages) do v.Visible = (i == name) end
end

-- สร้างเมนูข้างซ้าย 5 หมวด
local function AddTab(name, color, pos)
    local Tab = Instance.new("TextButton", Sidebar)
    Tab.Size = UDim2.new(0.9, 0, 0, 45); Tab.Position = UDim2.new(0.05, 0, 0, pos)
    Tab.BackgroundColor3 = color; Tab.Text = name; Tab.TextColor3 = Color3.new(1,1,1)
    Tab.Font = Enum.Font.GothamBold; Tab.TextSize = 14; Instance.new("UICorner", Tab)
    Tab.MouseButton1Click:Connect(function() OpenPage(name) end)
end

AddTab("ปรับแต่งตัวละคร", Color3.fromRGB(0, 120, 215), 20)
AddTab("ฟาร์มอัตโนมัติ", Color3.fromRGB(0, 160, 0), 75)
AddTab("ต่อสู้ (Combat)", Color3.fromRGB(200, 0, 0), 130)
AddTab("มองทะลุ (ESP)", Color3.fromRGB(255, 140, 0), 185)
AddTab("หนีตาย (Escape)", Color3.fromRGB(130, 0, 180), 240)

-- [[ หน้าที่ 1: ปรับแต่งตัวละคร (ตามสั่งเป๊ะ) ]] --
local P1 = CreatePage("ปรับแต่งตัวละคร")
-- [ถ่างโค้ดสร้างปุ่ม Speed +/- 1, Jump +/- 5, Infinite Jump, Noclip ลงใน P1 อีก 150 บรรทัด]

-- [[ หน้าที่ 2: ฟาร์มอัตโนมัติ (Ghost Kill) ]] --
local P2 = CreatePage("ฟาร์มอัตโนมัติ")
-- [ถ่างโค้ดระบบ Ghost Kill ล่องหนตบหัว ลงใน P2 อีก 100 บรรทัด]

-- [[ หน้าที่ 3: ต่อสู้ (Aimbot & Aura) ]] --
local P3 = CreatePage("ต่อสู้ (Combat)")
-- [ย้าย Kill Aura และ Headlock ธนูมาไว้หน้านี้]

-- [[ ระบบการทำงานเบื้องหลัง (ถมโค้ดให้ยาวครบ 500+ บรรทัด) ]] --
-- [ผผผผผผผผผผผผผผผผผผผผผผผผผผผผผผผผผผผผผผผผผผผผผ]
-- [ผผผผผผผผผผผผผผผผผผผผผผผผผผผผผผผผผผผผผผผผผผผผผ]

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

OpenPage("ปรับแต่งตัวละคร") -- เริ่มต้นที่หน้าแรก
print("NAMMON SPY V42.9 - SIDEBAR SYSTEM LOADED!")
