-- [[ Ball TD GUI v1.2 by น้ำมนต์ ]] --

-- 1. สร้างหน้าจอหลัก
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TitleLabel = Instance.new("TextLabel")
local MacroButton = Instance.new("TextButton")
local AFKButton = Instance.new("TextButton") -- ปุ่ม Anti-AFK
local UICorner_Frame = Instance.new("UICorner")
local UICorner_B1 = Instance.new("UICorner")
local UICorner_B2 = Instance.new("UICorner")

ScreenGui.Name = "NammonGui"
ScreenGui.Parent = game.CoreGui or game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- 2. ปรับขนาดกรอบ (เพิ่มความสูงเป็น 180 เพื่อให้มีที่วาง 2 ปุ่ม)
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -90)
MainFrame.Size = UDim2.new(0, 200, 0, 180) 
MainFrame.Active = true
MainFrame.Draggable = true

UICorner_Frame.CornerRadius = UDim2.new(0, 12)
UICorner_Frame.Parent = MainFrame

-- 3. หัวข้อ
TitleLabel.Name = "TitleLabel"
TitleLabel.Parent = MainFrame
TitleLabel.BackgroundTransparency = 1
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Text = "Ball TD Hack v1.2"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 20

-- 4. ปุ่มที่ 1: เริ่ม Macro
MacroButton.Name = "MacroButton"
MacroButton.Parent = MainFrame
MacroButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MacroButton.Position = UDim2.new(0.1, 0, 0.25, 0)
MacroButton.Size = UDim2.new(0.8, 0, 0.3, 0)
MacroButton.Font = Enum.Font.SourceSansBold
MacroButton.Text = "เริ่ม Macro"
MacroButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MacroButton.TextSize = 18

UICorner_B1.CornerRadius = UDim2.new(0, 8)
UICorner_B1.Parent = MacroButton

-- 5. ปุ่มที่ 2: ปุ่ม Anti-AFK (แบบกดเปิด/ปิดเอง)
AFKButton.Name = "AFKButton"
AFKButton.Parent = MainFrame
AFKButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
AFKButton.Position = UDim2.new(0.1, 0, 0.6, 0)
AFKButton.Size = UDim2.new(0.8, 0, 0.3, 0)
AFKButton.Font = Enum.Font.SourceSansBold
AFKButton.Text = "เปิด Anti-AFK"
AFKButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AFKButton.TextSize = 18

UICorner_B2.CornerRadius = UDim2.new(0, 8)
UICorner_B2.Parent = AFKButton

-- [[ ระบบการทำงาน ]] --
local macro_running = false
local afk_running = false

-- สั่งงานปุ่ม Macro
MacroButton.MouseButton1Click:Connect(function()
    macro_running = not macro_running
    if macro_running then
        MacroButton.Text = "หยุด Macro"
        MacroButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0) -- สีเขียว
    else
        MacroButton.Text = "เริ่ม Macro"
        MacroButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end
end)

-- สั่งงานปุ่ม Anti-AFK
AFKButton.MouseButton1Click:Connect(function()
    afk_running = not afk_running
    if afk_running then
        AFKButton.Text = "ปิด Anti-AFK"
        AFKButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255) -- สีฟ้าเวลาเปิด
        print("เปิดระบบกันหลุดแล้วนะน้ำมนต์!")
    else
        AFKButton.Text = "เปิด Anti-AFK"
        AFKButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        print("ปิดระบบกันหลุดแล้ว!")
    end
end)

-- ตัวเช็คกันหลุด (ทำงานเฉพาะตอน afk_running เป็น true)
local VirtualUser = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    if afk_running then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

print("สคริปต์ v1.2 อัปเดตเสร็จแล้วครับ!")
