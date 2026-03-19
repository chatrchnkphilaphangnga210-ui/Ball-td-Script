-- [[ Nammon's Ultimate Tab Hub ]] --
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")
local lighting = game:GetService("Lighting")
local runService = game:GetService("RunService")

local screenGui = Instance.new("ScreenGui", player.PlayerGui)
screenGui.Name = "NammonHubFinal"

-- ปุ่มเปิด/ปิด MENU
local toggleBtn = Instance.new("TextButton", screenGui)
toggleBtn.Size = UDim2.new(0, 55, 0, 55)
toggleBtn.Position = UDim2.new(0.02, 0, 0.45, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
toggleBtn.Text = "MENU"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)

-- หน้าจอหลัก
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 320, 0, 220)
mainFrame.Position = UDim2.new(0.1, 0, 0.35, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.Visible = false
Instance.new("UICorner", mainFrame)

-- Sidebar (ปุ่มเลือกหมวดหมู่)
local sidebar = Instance.new("Frame", mainFrame)
sidebar.Size = UDim2.new(0, 90, 1, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UICorner", sidebar)

-- Content Area
local content = Instance.new("Frame", mainFrame)
content.Size = UDim2.new(1, -100, 1, -10)
content.Position = UDim2.new(0, 95, 0, 5)
content.BackgroundTransparency = 1

local tabs = {}
local function createTab(name)
    local f = Instance.new("ScrollingFrame", content)
    f.Size = UDim2.new(1, 0, 1, 0)
    f.BackgroundTransparency = 1
    f.Visible = false
    f.ScrollBarThickness = 2
    Instance.new("UIListLayout", f).Padding = UDim.new(0, 5)
    tabs[name] = f
    return f
end

local pTab = createTab("Player")
local gTab = createTab("Gameplay")
local sTab = createTab("Setting")

-- ฟังก์ชันสร้างปุ่ม
local function addB(tab, txt, color, fn)
    local b = Instance.
