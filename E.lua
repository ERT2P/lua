--[[
    ERT2P
    =====
]]

getgenv().ERT2P = getgenv().ERT2P or {}
if getgenv().ERT2P.Loaded then
    warn("[ERT2P] Already loaded. Restart Roblox to reload.")
    return
end
getgenv().ERT2P.Loaded = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local Settings = {
    Speed      = 100,
    JumpPower  = 100,
    Slide      = false,
    SlideSpeed = 150,
    HideKey    = Enum.KeyCode.K,
}

local function getChar()   return LocalPlayer.Character end

local function getHRP()
    local c = getChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function getHumanoid()
    local c = getChar()
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function applyStats()
    local hum = getHumanoid()
    if not hum then return end
    hum.WalkSpeed = Settings.Speed
    hum.JumpPower = Settings.JumpPower
end

-- ================= GUI (BLUE THEME) =================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ERT2PGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local GUI_W = 280
local GUI_H = 350

local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(GUI_W, GUI_H)
Main.Position = UDim2.fromOffset(15, 150)
Main.BackgroundColor3 = Color3.fromRGB(15, 25, 45) -- لون خلفية أزرق غامق
Main.BorderSizePixel = 2
Main.BorderColor3 = Color3.fromRGB(50, 130, 255) -- إطار أزرق فاتح
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 32)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 60, 120) -- شريط العنوان أزرق مميز
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "ERT2P"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.Parent = TitleBar

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.fromOffset(32, 32)
MinimizeBtn.Position = UDim2.new(1, -32, 0, 0)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(30, 80, 160)
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextScaled = true
MinimizeBtn.Parent = TitleBar

local function MakeSquareToggle(x, y, label)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromOffset(40, 40)
    btn.Position = UDim2.fromOffset(x, y)
    btn.BackgroundColor3 = Color3.fromRGB(25, 50, 90)
    btn.BorderSizePixel = 2
    btn.BorderColor3 = Color3.fromRGB(80, 160, 255)
    btn.Text = ""
    btn.Parent = Main

    local inner = Instance.new("Frame")
    inner.Size = UDim2.fromOffset(24, 24)
    inner.Position = UDim2.new(0.5, -12, 0.5, -12)
    inner.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
    inner.BackgroundTransparency = 1
    inner.BorderSizePixel = 2
    inner.BorderColor3 = Color3.fromRGB(80, 160, 255)
    inner.Parent = btn

    local lab = Instance.new("TextLabel")
    lab.Size = UDim2.fromOffset(200, 40)
    lab.Position = UDim2.fromOffset(x + 48, y)
    lab.BackgroundTransparency = 1
    lab.Text = label .. " : OFF"
    lab.TextXAlignment = Enum.TextXAlignment.Left
    lab.TextColor3 = Color3.fromRGB(200, 225, 255)
    lab.Font = Enum.Font.GothamBold
    lab.TextScaled = true
    lab.Parent = Main

    return btn, inner, lab
end

local function SetSquare(inner, on)
    inner.BackgroundTransparency = on and 0 or 1
end

local function MakeLabel(x, y, text)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.fromOffset(60, 40)
    l.Position = UDim2.fromOffset(x, y)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.TextColor3 = Color3.fromRGB(150, 200, 255)
    l.Font = Enum.Font.GothamBold
    l.TextScaled = true
    l.Parent = Main
    return l
end

local function MakeMinus(x, y)
    local b = Instance.new("TextButton")
    b.Size = UDim2.fromOffset(40, 40)
    b.Position = UDim2.fromOffset(x, y)
    b.BackgroundColor3 = Color3.fromRGB(30, 60, 90)
    b.BorderSizePixel = 2
    b.BorderColor3 = Color3.fromRGB(80, 160, 255)
    b.Text = "-"
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.GothamBold
    b.TextScaled = true
    b.Parent = Main
    return b
end

local function MakePlus(x, y)
    local b = Instance.new("TextButton")
    b.Size = UDim2.fromOffset(40, 40)
    b.Position = UDim2.fromOffset(x, y)
    b.BackgroundColor3 = Color3.fromRGB(20, 90, 60)
    b.BorderSizePixel = 2
    b.BorderColor3 = Color3.fromRGB(80, 255, 160)
    b.Text = "+"
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.GothamBold
    b.TextScaled = true
    b.Parent = Main
    return b
end

local function MakeValue(x, y, text, w)
    local v = Instance.new("TextLabel")
    v.Size = UDim2.fromOffset(w or 50, 40)
    v.Position = UDim2.fromOffset(x, y)
    v.BackgroundTransparency = 1
    v.Text = text
    v.TextColor3 = Color3.fromRGB(100, 220, 255)
    v.Font = Enum.Font.GothamBold
    v.TextScaled = true
    v.Parent = Main
    return v
end

-- ============ ROWS ============
MakeLabel(10, 38, "SPEED")
local SpeedMinus = MakeMinus(75, 38)
local SpeedVal   = MakeValue(120, 38, tostring(Settings.Speed))
local SpeedPlus  = MakePlus(185, 38)

MakeLabel(10, 84, "JUMP")
local JumpMinus = MakeMinus(75, 84)
local JumpVal   = MakeValue(120, 84, tostring(Settings.JumpPower))
local JumpPlus  = MakePlus(185, 84)

local SlideBtn, SlideInner, SlideLabel = MakeSquareToggle(10, 130, "SLIDE")

-- ============ CODES ============
local defaultCodes = {
    "SUBSCRIBED", "ENZOS", "TYPHOON", "KITT", "DRAGONABUSE",
    "ADMIN", "3BVISITS", "UPD24", "STRAWMEN", "fudd10_v2"
}

local CodeBox = Instance.new("TextBox")
CodeBox.Size = UDim2.fromOffset(140, 30)
CodeBox.Position = UDim2.fromOffset(10, 184)
CodeBox.BackgroundColor3 = Color3.fromRGB(20, 35, 60)
CodeBox.BorderSizePixel = 2
CodeBox.BorderColor3 = Color3.fromRGB(80, 160, 255)
CodeBox.Text = table.concat(defaultCodes, ", ")
CodeBox.TextColor3 = Color3.fromRGB(255, 255, 255)
CodeBox.Font = Enum.Font.Code
CodeBox.TextSize = 12
CodeBox.Parent = Main

local RedeemBtn = Instance.new("TextButton")
RedeemBtn.Size = UDim2.fromOffset(110, 30)
RedeemBtn.Position = UDim2.fromOffset(158, 184)
RedeemBtn.BackgroundColor3 = Color3.fromRGB(30, 100, 200)
RedeemBtn.BorderSizePixel = 2
RedeemBtn.BorderColor3 = Color3.fromRGB(255, 255, 255)
RedeemBtn.Text = "REDEEM"
RedeemBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RedeemBtn.Font = Enum.Font.GothamBold
RedeemBtn.TextScaled = true
RedeemBtn.Parent = Main

local CodeStatus = Instance.new("TextLabel")
CodeStatus.Size = UDim2.new(1, -20, 0, 18)
CodeStatus.Position = UDim2.fromOffset(10, 220)
CodeStatus.BackgroundTransparency = 1
CodeStatus.Text = "Paste codes then REDEEM."
CodeStatus.TextColor3 = Color3.fromRGB(150, 210, 255)
CodeStatus.Font = Enum.Font.Gotham
CodeStatus.TextScaled = true
CodeStatus.Parent = Main

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(1, -20, 0, 30)
CloseBtn.Position = UDim2.fromOffset(10, 246)
CloseBtn.BackgroundColor3 = Color3.fromRGB(120, 40, 40)
CloseBtn.BorderSizePixel = 2
CloseBtn.BorderColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Text = "HIDE GUI  [K]"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextScaled = true
CloseBtn.Parent = Main

-- ============ TOGGLES ============
local SlideVel = nil

local function ToggleSlide()
    Settings.Slide = not Settings.Slide
    SetSquare(SlideInner, Settings.Slide)
    SlideLabel.Text = "SLIDE : " .. (Settings.Slide and "ON" or "OFF")
    if not Settings.Slide and SlideVel then
        SlideVel:Destroy()
        SlideVel = nil
    end
end

SlideBtn.MouseButton1Click:Connect(ToggleSlide)

local function BindValueRow(minusBtn, plusBtn, valueLabel, varName, step, minV, maxV)
    minusBtn.MouseButton1Click:Connect(function()
        Settings[varName] = math.max(minV, Settings[varName] - step)
        valueLabel.Text = tostring(Settings[varName])
        applyStats()
    end)
    plusBtn.MouseButton1Click:Connect(function()
        Settings[varName] = math.min(maxV, Settings[varName] + step)
        valueLabel.Text = tostring(Settings[varName])
        applyStats()
    end)
end

BindValueRow(SpeedMinus, SpeedPlus, SpeedVal, "Speed", 10, 0, 500)
BindValueRow(JumpMinus, JumpPlus, JumpVal, "JumpPower", 10, 0, 500)

local Minimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    Minimized = not Minimized
    local h = Minimized and 32 or GUI_H
    Main.Size = UDim2.fromOffset(GUI_W, h)
    for _, child in ipairs(Main:GetChildren()) do
        if child ~= TitleBar then
            child.Visible = not Minimized
        end
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
end)

RedeemBtn.MouseButton1Click:Connect(function()
    local list = {}
    for code in CodeBox.Text:gmatch("[^,%s]+") do
        table.insert(list, code)
    end
    if #list == 0 then
        for _, c in ipairs(defaultCodes) do table.insert(list, c) end
    end
    CodeStatus.Text = "[+] Redeeming " .. #list .. " codes..."
    task.spawn(function()
        for _, code in ipairs(list) do
            pcall(function()
                local Remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
                if Remotes then
                    local submit = Remotes:FindFirstChild("CodeSubmit") or Remotes:FindFirstChild("Code")
                    if submit then submit:FireServer(code) end
                end
            end)
            task.wait(0.4)
        end
        CodeStatus.Text = "[OK] Finished."
    end)
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Settings.HideKey then
        Main.Visible = not Main.Visible
    end
end)

RunService.RenderStepped:Connect(function()
    applyStats()
    local hrp = getHRP()

    if Settings.Slide and hrp then
        if not SlideVel or not SlideVel.Parent then
            SlideVel = Instance.new("BodyVelocity")
            SlideVel.MaxForce = Vector3.new(1e5, 0, 1e5)
            SlideVel.Parent = hrp
        end
        local hum = getHumanoid()
        local md = hum and hum.MoveDirection or Vector3.new()
        if md.Magnitude > 0.1 then
            SlideVel.Velocity = md * Settings.SlideSpeed
        else
            SlideVel.Velocity = Vector3.new(SlideVel.Velocity.X * 0.92, 0, SlideVel.Velocity.Z * 0.92)
        end
    elseif SlideVel then
        SlideVel:Destroy()
        SlideVel = nil
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    applyStats()
end)

print("[ERT2P] Loaded successfully with Blue Theme.")
