-- [[ Ball TD GUI v2.0 Lesson 1: Structural Setup by น้ำมนต์ ]] --

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local SideBar = Instance.new("Frame")
local TitleLabel = Instance.new("TextLabel")
local ContentFrame = Instance.new("Frame")
local UICorner_Frame = Instance.new("UICorner")
local UICorner_SideBar = Instance.new("UICorner")

-- 1. Setup ScreenGui (ตัวคุมหน้าจอ)
ScreenGui.Name = "NammonGuiv2"
ScreenGui.Parent = game.CoreGui or game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- 2. Setup MainFrame (หน้าต่างหลัก - สีม่วงเข้ม)
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 30, 60) -- สีม่วงเข้มเท่ๆ
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150) -- จัดให้กลางจอ
MainFrame.Size = UDim2.new(0, 400, 0, 300) -- ขนาดหน้าต่าง
MainFrame.Active = true
MainFrame.Draggable = true -- ทำให้ลากไปมาได้

UICorner_Frame.CornerRadius = UDim2.new(0, 10) -- ขอบมนนิดๆ
UICorner_Frame.Parent = MainFrame

-- 3. Setup SideBar (แถบเมนูข้าง - สีม่วงอ่อน)
SideBar.Name = "SideBar"
SideBar.Parent = MainFrame
SideBar.BackgroundColor3 = Color3.fromRGB(60, 50, 80) -- สีม่วงอ่อนกว่า
SideBar.Size = UDim2.new(0, 100, 1, 0) -- ขนาดความกว้าง 100

UICorner_SideBar.CornerRadius = UDim2.new(0, 10) -- ขอบมน
UICorner_SideBar.Parent = SideBar

-- 4. Setup TitleLabel (ชื่อสคริปต์ใน SideBar)
TitleLabel.Name = "TitleLabel"
TitleLabel.Parent = SideBar
TitleLabel.BackgroundTransparency = 1
TitleLabel.Size = UDim2.new(1, 0, 0, 50) -- ความสูง 50
TitleLabel.Font = Enum.Font.SourceSansBold -- ฟอนต์หนา
TitleLabel.Text = "BALL TD" -- ชื่อเกม
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- สีขาว
TitleLabel.TextSize = 22 -- ขนาดตัวอักษร

-- 5. Setup ContentFrame (พื้นที่แสดงผลด้านขวา - สีดำ)
ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- สีดำ
ContentFrame.Position = UDim2.new(0, 110, 0, 10) -- ขยับจาก SideBar นิดนึง
ContentFrame.Size = UDim2.new(1, -120, 1, -20) -- ขนาดที่เหลือทั้งหมด

print("บทเรียนที่ 1: โครงสร้าง UI สำเร็จแล้ว!")
