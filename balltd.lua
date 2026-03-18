-- [[ Ball TD GUI v2.0 Lesson 2: Adding Buttons by น้ำมนต์ ]] --

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local SideBar = Instance.new("Frame")
local TitleLabel = Instance.new("TextLabel")
local ContentFrame = Instance.new("Frame")
local AFKButton = Instance.new("TextButton")
local UICorner_Frame = Instance.new("UICorner")
local UICorner_SideBar = Instance.new("UICorner")
local UICorner_Content = Instance.new("UICorner")
local UICorner_Button = Instance.new("UICorner")

-- 1. Setup ScreenGui
ScreenGui.Name = "NammonGuiv2"
ScreenGui.Parent = game.CoreGui or game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- 2. MainFrame (หน้าต่างสีม่วงเข้ม)
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 25, 50)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Active = true
MainFrame.Draggable = true

UICorner_Frame.CornerRadius = UDim2.new(0, 15)
UICorner_Frame.Parent = MainFrame

-- 3. SideBar (แถบเมนูสีม่วงสว่าง)
SideBar.Name = "SideBar"
SideBar.Parent = MainFrame
SideBar.BackgroundColor3 = Color3.fromRGB(55, 45, 80)
SideBar.Size = UDim2.new(0, 110, 1, 0)

UICorner_SideBar.CornerRadius = UDim2.new(0, 15)
UICorner_SideBar.Parent = SideBar

-- 4. Title (ชื่อ BALL TD)
TitleLabel.Name = "TitleLabel"
TitleLabel.Parent = SideBar
TitleLabel.BackgroundTransparency = 1
TitleLabel.Size = UDim2.new(1, 0, 0, 60)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "BALL TD"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 20

-- 5. ContentFrame (พื้นที่สีดำขวา)
ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 25)
ContentFrame.Position = UDim2.new(0, 120, 0, 15)
ContentFrame.Size = UDim2.new(1, -135, 1, -30)

UICorner_Content.CornerRadius = UDim2.new(0, 12)
UICorner_Content.Parent = ContentFrame

-- 6. AFK Button (ปุ่ม Anti-AFK อยู่ใน ContentFrame)
AFKButton.Name = "AFKButton"
AFKButton.Parent = ContentFrame
AFKButton.BackgroundColor3 = Color3.fromRGB(70, 50, 100)
AFKButton.Position = UDim2.new(0.1, 0, 0.1, 0)
AFKButton.Size = UDim2.new(0.8, 0, 0, 45)
AFKButton.Font = Enum.Font.GothamBold
AFKButton.Text = "เปิด Anti-AFK"
AFKButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AFKButton.TextSize = 16

UICorner_Button.CornerRadius = UDim2.new(0, 10)
UICorner_Button.Parent = AFKButton

-- ระบบ Anti-AFK (โค้ดเดิมที่น้ำมนต์คุ้นเคย)
local afk_running = false
AFKButton.MouseButton1Click:Connect(function()
    afk_running = not afk_running
    if afk_running then
        AFKButton.Text = "ระบบกันหลุด: เปิด"
        AFKButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        print("เปิดระบบกันหลุดแล้วนะน้ำมนต์!")
    else
        AFKButton.Text = "ระบบกันหลุด: ปิด"
        AFKButton.BackgroundColor3 = Color3.fromRGB(70, 50, 100)
        print("ปิดระบบกันหลุดแล้ว!")
    end
end)

local VirtualUser = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    if afk_running then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

print("บทเรียนที่ 2 อัปโหลดสำเร็จ! ลองรันดูนะน้ำมนต์")
