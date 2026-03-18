-- [[ Ball TD GUI by น้ำมนต์ ]] --

-- 1. สร้างหน้าจอหลัก (ScreenGui)
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TitleLabel = Instance.new("TextLabel")
local MacroButton = Instance.new("TextButton")
local StatusLabel = Instance.new("TextLabel")
local UICorner_Frame = Instance.new("UICorner")
local UICorner_Button = Instance.new("UICorner")

-- ตั้งค่าหน้าจอหลัก (ให้มันลอยอยู่บนหน้าจอ)
ScreenGui.Name = "NammonGui"
ScreenGui.Parent = game.CoreGui or game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- 2. สร้างกรอบหลัก (Main Frame)
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- สีเทาเข้ม
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -75) -- ตรงกลางจอ
MainFrame.Size = UDim2.new(0, 200, 0, 150) -- ขนาดกว้าง 200 สูง 150
MainFrame.Active = true
MainFrame.Draggable = true -- ทำให้ลากหน้าจอไปมาได้

UICorner_Frame.CornerRadius = UDim.new(0, 10) -- ทำมุมโค้ง
UICorner_Frame.Parent = MainFrame

-- 3. สร้างหัวข้อ (Title)
TitleLabel.Name = "TitleLabel"
TitleLabel.Parent = MainFrame
TitleLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.BackgroundTransparency = 1 -- พื้นหลังใส
TitleLabel.Size = UDim2.new(1, 0, 0, 30)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Text = "Ball TD Hack v1.0"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- สีขาว
TitleLabel.TextSize = 18

-- 4. สร้างสถานะ (Status)
StatusLabel.Name = "StatusLabel"
StatusLabel.Parent = MainFrame
StatusLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 0, 0, 35)
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Font = Enum.Font.SourceSans
StatusLabel.Text = "สถานะ: ปิดอยู่"
StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0) -- สีแดง
StatusLabel.TextSize = 14

-- 5. สร้างปุ่มเปิด-ปิด Macro (Button)
MacroButton.Name = "MacroButton"
MacroButton.Parent = MainFrame
MacroButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- สีเทา
MacroButton.Position = UDim2.new(0.1, 0, 0.5, 0)
MacroButton.Size = UDim2.new(0.8, 0, 0.4, 0)
MacroButton.Font = Enum.Font.SourceSansBold
MacroButton.Text = "เริ่ม Macro"
MacroButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MacroButton.TextSize = 20

UICorner_Button.CornerRadius = UDim.new(0, 8)
UICorner_Button.Parent = MacroButton

-- [[ ระบบการทำงาน (Logic) ]] --

local macro_running = false -- ตัวแปรเช็คสถานะ

-- ฟังก์ชันเมื่อกดปุ่ม
MacroButton.MouseButton1Click:Connect(function()
    macro_running = not macro_running -- สลับสถานะ (เปิด<->ปิด)
    
    if macro_running then
        MacroButton.Text = "หยุด Macro"
        MacroButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0) -- สีเขียว
        StatusLabel.Text = "สถานะ: เปิดใช้งาน"
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0) -- สีเขียว
        print("เริ่มระบบ Macro ของน้ำมนต์แล้ว!")
        
        -- ใส่โค้ด Macro (จดจำ Pattern) ที่นี่
        -- เช่น:
        -- task.spawn(function()
        --     while macro_running do
        --         -- ใส่คำสั่งวางบอลตรงนี้
        --         print("กำลังรัน Pattern การวาง...")
        --         task.wait(5)
        --     end
        -- end)
        
    else
        MacroButton.Text = "เริ่ม Macro"
        MacroButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- สีเทา
        StatusLabel.Text = "สถานะ: ปิดอยู่"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0) -- สีแดง
        print("หยุดระบบ Macro แล้ว!")
    end
end)

print("โหลด UI เรียบร้อยแล้วครับน้ำมนต์!")
