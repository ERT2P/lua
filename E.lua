-- [[ ERT-- [[ Blox Fruits Auto Soru & Skill Combo - Ultra Modern UI Version ]] -- ]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local EffectFolder = ReplicatedStorage:FindFirstChild("Effect")
local Bindable = EffectFolder and EffectFolder:FindFirstChild("Bindable")
local Soru = EffectFolder and EffectFolder:FindFirstChild("Container") and EffectFolder.Container:FindFirstChild("Shared") and EffectFolder.Container.Shared:FindFirstChild("Soru")

local SkillsList = {"Z", "X", "C"}
local CurrentSkillIndex = 1
local SelectedSkill = Enum.KeyCode[SkillsList[CurrentSkillIndex]]
local SkillEnabled = true
local isExecuting = false

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltraSoruGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 230, 0, 190)
MainFrame.Position = UDim2.new(0.5, -115, 0.4, -95)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderColor3 = Color3.fromRGB(60, 60, 80)
MainFrame.BorderSizePixel = 1
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0, 12)
UICornerMain.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 34)
Title.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
Title.BorderSizePixel = 0
Title.Text = "⚡ [ ERT // (L) HIDE ] ⚡"
Title.TextColor3 = Color3.fromRGB(255, 204, 0)
Title.TextSize = 11
Title.Font = Enum.Font.Code
Title.Parent = MainFrame

local UICornerTitle = Instance.new("UICorner")
UICornerTitle.CornerRadius = UDim.new(0, 12)
UICornerTitle.Parent = Title

local SwitchBtn = Instance.new("TextButton")
SwitchBtn.Size = UDim2.new(1, -24, 0, 36)
SwitchBtn.Position = UDim2.new(0, 12, 0, 46)
SwitchBtn.BackgroundColor3 = Color3.fromRGB(0, 168, 84)
SwitchBtn.BorderSizePixel = 0
SwitchBtn.Text = "AUTO SKILL: [ON] (P)"
SwitchBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SwitchBtn.TextSize = 12
SwitchBtn.Font = Enum.Font.Code
SwitchBtn.Parent = MainFrame

local UICornerBtn = Instance.new("UICorner")
UICornerBtn.CornerRadius = UDim.new(0, 8)
UICornerBtn.Parent = SwitchBtn

local function updateSwitchButton()
    if SkillEnabled then
        SwitchBtn.Text = "AUTO SKILL: [ON] (P)"
        SwitchBtn.BackgroundColor3 = Color3.fromRGB(0, 168, 84)
    else
        SwitchBtn.Text = "AUTO SKILL: [OFF] (P)"
        SwitchBtn.BackgroundColor3 = Color3.fromRGB(180, 45, 45)
    end
end

SwitchBtn.MouseButton1Click:Connect(function()
    SkillEnabled = not SkillEnabled
    updateSwitchButton()
end)

local Label = Instance.new("TextLabel")
Label.Size = UDim2.new(1, 0, 0, 20)
Label.Position = UDim2.new(0, 0, 0, 88)
Label.BackgroundTransparency = 1
Label.Text = "ERT - ACTIVE SKILL:"
Label.TextColor3 = Color3.fromRGB(140, 140, 165)
Label.TextSize = 10
Label.Font = Enum.Font.Code
Label.Parent = MainFrame

local ButtonsContainer = Instance.new("Frame")
ButtonsContainer.Size = UDim2.new(0, 180, 0, 36)
ButtonsContainer.Position = UDim2.new(0.5, -90, 0, 110)
ButtonsContainer.BackgroundTransparency = 1
ButtonsContainer.Parent = MainFrame

local UIGridLayout = Instance.new("UIGridLayout")
UIGridLayout.CellSize = UDim2.new(0, 52, 0, 34)
UIGridLayout.CellPadding = UDim2.new(0, 12, 0, 0)
UIGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIGridLayout.Parent = ButtonsContainer

local skillButtons = {}

local SkillNotifyLabel = Instance.new("TextLabel")
SkillNotifyLabel.Size = UDim2.new(0, 54, 0, 28)
SkillNotifyLabel.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
SkillNotifyLabel.BorderColor3 = Color3.fromRGB(80, 80, 110)
SkillNotifyLabel.BorderSizePixel = 1
SkillNotifyLabel.TextColor3 = Color3.fromRGB(0, 255, 170)
SkillNotifyLabel.TextSize = 13
SkillNotifyLabel.Font = Enum.Font.Code
SkillNotifyLabel.Visible = false
SkillNotifyLabel.Parent = ScreenGui

local skillNotifyTween = nil

local function showSkillNotificationAtMouse(skillName)
    local mousePos = UserInputService:GetMouseLocation()
    SkillNotifyLabel.Position = UDim2.new(0, mousePos.X + 15, 0, mousePos.Y - 10)
    SkillNotifyLabel.Text = "ERT: [" .. skillName .. "]"
    
    if skillNotifyTween then
        skillNotifyTween:Cancel()
    end

    SkillNotifyLabel.Visible = true
    SkillNotifyLabel.TextTransparency = 0
    SkillNotifyLabel.BackgroundTransparency = 0.2

    skillNotifyTween = TweenService:Create(SkillNotifyLabel, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 1,
        BackgroundTransparency = 1
    })
    
    task.delay(0.9, function()
        if SkillNotifyLabel.TextTransparency == 0 then
            skillNotifyTween:Play()
            skillNotifyTween.Completed:Connect(function()
                if SkillNotifyLabel.TextTransparency >= 1 then
                    SkillNotifyLabel.Visible = false
                end
            end)
        end
    end)
end

local function updateSkillButtons(showPopup)
    local selectedName = SkillsList[CurrentSkillIndex]
    SelectedSkill = Enum.KeyCode[selectedName]
    
    for name, button in pairs(skillButtons) do
        if name == selectedName then
            button.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        else
            button.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
        end
    end

    if showPopup then
        showSkillNotificationAtMouse(selectedName)
    end
end

for index, skillName in ipairs(SkillsList) do
    local btn = Instance.new("TextButton")
    btn.Text = skillName
    btn.TextSize = 13
    btn.Font = Enum.Font.Code
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BorderSizePixel = 0
    btn.BackgroundColor3 = (skillName == "Z") and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(30, 30, 42)
    btn.Parent = ButtonsContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        CurrentSkillIndex = index
        updateSkillButtons(true)
    end)
    
    skillButtons[skillName] = btn
end

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Position = UDim2.new(0, 0, 1, -22)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "ERT: READY"
StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 120)
StatusLabel.TextSize = 11
StatusLabel.Font = Enum.Font.Code
StatusLabel.Parent = MainFrame

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if UserInputService:GetFocusedTextBox() then return end

    if input.KeyCode == Enum.KeyCode.P then
        SkillEnabled = not SkillEnabled
        updateSwitchButton()
    end

    if input.KeyCode == Enum.KeyCode.L then
        MainFrame.Visible = not MainFrame.Visible
    end

    if input.KeyCode == Enum.KeyCode.LeftAlt or input.KeyCode == Enum.KeyCode.RightAlt then
        CurrentSkillIndex = CurrentSkillIndex + 1
        if CurrentSkillIndex > #SkillsList then
            CurrentSkillIndex = 1
        end
        updateSkillButtons(true)
    end
end)

local function isMyCharacter(obj)
    local char = LocalPlayer.Character
    if not char then return false end
    
    if typeof(obj) == "Instance" then
        return obj == char or obj:IsDescendantOf(char)
    elseif type(obj) == "table" then
        for _, v in pairs(obj) do
            if isMyCharacter(v) then return true end
        end
    end
    return false
end

if Bindable then
    Bindable.Event:Connect(function(action, module, data, info)
        if not SkillEnabled or isExecuting then return end

        if action == "spawn" and (module == Soru or tostring(module) == "Soru") then
            if isMyCharacter(data) or isMyCharacter(info) then
                isExecuting = true
                
                StatusLabel.Text = "ERT: EXECUTING [" .. SkillsList[CurrentSkillIndex] .. "]"
                StatusLabel.TextColor3 = Color3.fromRGB(255, 170, 0)

                VirtualInputManager:SendKeyEvent(true, SelectedSkill, false, nil)
                VirtualInputManager:SendKeyEvent(false, SelectedSkill, false, nil)

                task.wait(0.04)
                StatusLabel.Text = "ERT: READY"
                StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 120)
                isExecuting = false
            end
        end
    end)
end
