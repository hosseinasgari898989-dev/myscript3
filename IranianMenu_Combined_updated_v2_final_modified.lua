-- ================================================
-- 🇮🇷 بخش ۱: متغیرها و ساخت منو
-- ================================================
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ================================================
-- متغیرهای وضعیت
-- ================================================
local selectedPlayer = nil
local isBackAttach = false
local isFrontAttach = false
local isInvisible = false
local isOrder = false
local isKillFarm = false
local isFly = false
local isNoclip = false
local isFling = false
local isWalkFling = false

local backDistance = 5
local frontDistance = 5
local orderDistance = 10
local walkSpeedValue = 16
local jumpPowerValue = 50

local attachConnection = nil
local orderConnection = nil
local killFarmConnection = nil
local flyConnection = nil
local noclipConnection = nil
local flingConnection = nil

local isMinimized = false

print("✅ بخش ۱: متغیرها تعریف شدند!")

-- ================================================
-- ================================================
-- 🇮🇷 بخش ۲: ساخت صفحه اصلی و نوار عنوان (اندازه مناسب گوشی)
-- ================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "IranianMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 480)  -- کوچک‌تر برای گوشی
mainFrame.Position = UDim2.new(0.5, -160, 0.3, 0)  -- پایین‌تر از بالا
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 17, 25)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 1
mainFrame.BorderColor3 = Color3.fromRGB(0, 150, 255)
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 16)
mainCorner.Parent = mainFrame

-- نوار عنوان
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(25, 30, 45)
titleBar.BorderSizePixel = 0
titleBar.Active = true
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 16)
titleCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0.6, 0, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🇮🇷 منوی ایرانی"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 17
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- دکمه کوچک‌سازی
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 32, 0, 32)
minimizeBtn.Position = UDim2.new(1, -70, 0, 4)
minimizeBtn.BackgroundTransparency = 1
minimizeBtn.Text = "➖"
minimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
minimizeBtn.TextSize = 16
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.Parent = titleBar

-- دکمه بستن
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 32, 0, 32)
closeBtn.Position = UDim2.new(1, -36, 0, 4)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
closeBtn.TextSize = 16
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = titleBar

print("✅ بخش ۲: صفحه اصلی ساخته شد!")

-- ================================================
-- 🇮🇷 بخش ۳: اسکرول فریم و توابع کمکی (با فضای کافی برای اسکرول)
-- ================================================
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -10, 1, -50)
scrollFrame.Position = UDim2.new(0, 5, 0, 45)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 1800)  -- فضای کافی برای همه گزینه‌ها
scrollFrame.ScrollBarThickness = 4
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)
scrollFrame.Parent = mainFrame

local scrollLayout = Instance.new("UIListLayout")
scrollLayout.Padding = UDim.new(0, 6)
scrollLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
scrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
scrollLayout.Parent = scrollFrame

-- ===== تابع ساخت دکمه ON/OFF =====
local function createToggle(parent, text, getState, setState)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.92, 0, 0, 38)
    frame.BackgroundColor3 = Color3.fromRGB(22, 25, 40)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    frame.Parent = parent

    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 8)
    frameCorner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.55, 0, 1, 0)
    label.Position = UDim2.new(0.05, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 230)
    label.TextSize = 13
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.3, 0, 0.7, 0)
    btn.Position = UDim2.new(0.65, 0, 0.15, 0)
    btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    btn.BorderSizePixel = 0
    btn.Text = "خاموش"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.Parent = frame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        local newState = not getState()
        setState(newState)
        if newState then
            btn.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
            btn.Text = "روشن"
        else
            btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            btn.Text = "خاموش"
        end
    end)
    return frame
end

-- ===== تابع ساخت اسلایدر عددی =====
local function createSlider(parent, text, minVal, maxVal, getVal, setVal)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.92, 0, 0, 42)
    frame.BackgroundColor3 = Color3.fromRGB(22, 25, 40)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    frame.Parent = parent

    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 8)
    frameCorner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 0.4, 0)
    label.Position = UDim2.new(0.05, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 230)
    label.TextSize = 12
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.2, 0, 0.4, 0)
    valueLabel.Position = UDim2.new(0.75, 0, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(getVal())
    valueLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    valueLabel.TextSize = 13
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = frame

    local slider = Instance.new("TextBox")
    slider.Size = UDim2.new(0.5, 0, 0.3, 0)
    slider.Position = UDim2.new(0.25, 0, 0.5, 0)
    slider.BackgroundColor3 = Color3.fromRGB(12, 15, 28)
    slider.BorderSizePixel = 0
    slider.Text = tostring(getVal())
    slider.TextColor3 = Color3.fromRGB(255, 255, 255)
    slider.TextSize = 13
    slider.Font = Enum.Font.GothamMedium
    slider.TextXAlignment = Enum.TextXAlignment.Center
    slider.Parent = frame

    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 6)
    sliderCorner.Parent = slider

    slider.FocusLost:Connect(function(enter)
        if enter then
            local val = tonumber(slider.Text)
            if val and val >= minVal and val <= maxVal then
                setVal(val)
                valueLabel.Text = tostring(val)
                slider.Text = tostring(val)
            else
                slider.Text = tostring(getVal())
            end
        end
    end)
    return frame
end

print("✅ بخش ۳: توابع کمکی ساخته شدند!")

-- 🇮🇷 بخش ۴: لیست بازیکنان (قابل کلیک)
-- ================================================
local playerListFrame = Instance.new("Frame")
playerListFrame.Size = UDim2.new(0.92, 0, 0, 110)
playerListFrame.BackgroundColor3 = Color3.fromRGB(22, 25, 40)
playerListFrame.BackgroundTransparency = 0.3
playerListFrame.BorderSizePixel = 0
playerListFrame.Parent = scrollFrame

local listCorner = Instance.new("UICorner")
listCorner.CornerRadius = UDim.new(0, 8)
listCorner.Parent = playerListFrame

local listLabel = Instance.new("TextLabel")
listLabel.Size = UDim2.new(1, 0, 0, 25)
listLabel.BackgroundTransparency = 1
listLabel.Text = "👥 لیست بازیکنان (برای انتخاب کلیک کن)"
listLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
listLabel.TextSize = 13
listLabel.Font = Enum.Font.GothamBold
listLabel.Parent = playerListFrame

local playerList = Instance.new("ScrollingFrame")
playerList.Size = UDim2.new(1, -10, 1, -35)
playerList.Position = UDim2.new(0, 5, 0, 30)
playerList.BackgroundTransparency = 1
playerList.BorderSizePixel = 0
playerList.CanvasSize = UDim2.new(0, 0, 0, 0)
playerList.ScrollBarThickness = 3
playerList.Parent = playerListFrame

local playerListLayout = Instance.new("UIListLayout")
playerListLayout.Padding = UDim.new(0, 2)
playerListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
playerListLayout.Parent = playerList

local playerButtons = {}

local function updatePlayerList()
    for _, btn in ipairs(playerButtons) do
        btn:Destroy()
    end
    playerButtons = {}
    playerList.CanvasSize = UDim2.new(0, 0, 0, 0)

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0.9, 0, 0, 24)
            btn.BackgroundColor3 = Color3.fromRGB(38, 42, 55)
            btn.BorderSizePixel = 0
            btn.Text = plr.Name
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.TextSize = 12
            btn.Font = Enum.Font.GothamMedium
            btn.Parent = playerList

            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 4)
            btnCorner.Parent = btn

            btn.MouseButton1Click:Connect(function()
                selectedPlayer = plr
                for _, b in ipairs(playerButtons) do
                    b.BackgroundColor3 = Color3.fromRGB(38, 42, 55)
                end
                btn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
                print("🎯 بازیکن انتخاب شد:", plr.Name)
            end)
            table.insert(playerButtons, btn)
        end
    end
    playerList.CanvasSize = UDim2.new(0, 0, 0, #playerButtons * 26 + 5)
end

updatePlayerList()
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)

print("✅ بخش ۴: لیست بازیکنان بارگذاری شد!")

-- ================================================
-- ================================================
-- ================================================
-- 🇮🇷 بخش ۵: چسبیدن به پشت/جلو + Kill Farm (نسخه نهایی)
-- ================================================

-- 1️⃣ چسبیدن به پشت/جلو
local function startAttach()
    if attachConnection then
        attachConnection:Disconnect()
    end
    attachConnection = RunService.Heartbeat:Connect(function()
        if not selectedPlayer or not selectedPlayer.Character then
            return
        end
        local char = player.Character
        if not char then
            return
        end
        local root = char:FindFirstChild("HumanoidRootPart")
        local targetRoot = selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not root or not targetRoot then
            return
        end
        local dist = isBackAttach and backDistance or frontDistance
        local dir = isBackAttach and -1 or 1
        root.CFrame = CFrame.new(targetRoot.Position + targetRoot.CFrame.LookVector * dir * dist)
    end)
end

local function stopAttach()
    if attachConnection then
        attachConnection:Disconnect()
        attachConnection = nil
    end
end

createToggle(scrollFrame, "🎯 چسبیدن به پشت (Back)",
    function() return isBackAttach end,
    function(state)
        if state and not selectedPlayer then
            print("⚠️ لطفاً ابتدا یک بازیکن انتخاب کن!")
            return
        end
        if state then
            isFrontAttach = false
            isBackAttach = true
            startAttach()
        else
            isBackAttach = false
            stopAttach()
        end
    end
)

createSlider(scrollFrame, "📏 فاصله پشت", 1, 100,
    function() return backDistance end,
    function(val) backDistance = val end
)

createToggle(scrollFrame, "🎯 چسبیدن به جلو (Front)",
    function() return isFrontAttach end,
    function(state)
        if state and not selectedPlayer then
            print("⚠️ لطفاً ابتدا یک بازیکن انتخاب کن!")
            return
        end
        if state then
            isBackAttach = false
            isFrontAttach = true
            startAttach()
        else
            isFrontAttach = false
            stopAttach()
        end
    end
)

createSlider(scrollFrame, "📏 فاصله جلو", 1, 100,
    function() return frontDistance end,
    function(val) frontDistance = val end
)

-- 2️⃣ Kill Farm (چسبیدن به پلیر با سرعت بالا - از همه جهت)
local function startKillFarm()
    if killFarmConnection then
        killFarmConnection:Disconnect()
    end
    local angle = 0
    killFarmConnection = RunService.Heartbeat:Connect(function()
        if not isKillFarm then
            return
        end
        if not selectedPlayer or not selectedPlayer.Character then
            return
        end
        local char = player.Character
        if not char then
            return
        end
        local root = char:FindFirstChild("HumanoidRootPart")
        local targetRoot = selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not root or not targetRoot then
            return
        end
        
        -- حرکت دورانی سریع دور پلیر (جلو/عقب/بالا/پایین)
        angle = angle + 0.3
        local radius = 2
        local heightOffset = math.sin(angle) * 2
        local x = math.cos(angle) * radius
        local z = math.sin(angle) * radius
        local targetPos = targetRoot.Position + Vector3.new(x, heightOffset, z)
        root.CFrame = CFrame.new(targetPos)
    end)
end

local function stopKillFarm()
    if killFarmConnection then
        killFarmConnection:Disconnect()
        killFarmConnection = nil
    end
end

createToggle(scrollFrame, "⚔️ Kill Farm (چسبیدن سریع)",
    function() return isKillFarm end,
    function(state)
        if state and not selectedPlayer then
            print("⚠️ لطفاً ابتدا یک بازیکن انتخاب کن!")
            return
        end
        isKillFarm = state
        if state then
            isBackAttach = false
            isFrontAttach = false
            stopAttach()
            startKillFarm()
        else
            stopKillFarm()
        end
    end
)

print("✅ بخش ۵: چسبیدن و Kill Farm (نسخه نهایی) اضافه شدند!")
-- ================================================
-- 🇮🇷 بخش ۶: Invisible (بدون باگ)
-- ================================================

-- Invisible (با حذف بلاک‌ها)
local invisibleParts = {}

createToggle(scrollFrame, "👻 Invisible (غیب شدن)",
    function() return isInvisible end,
    function(state)
        isInvisible = state
        local char = player.Character
        if not char then
            return
        end
        
        if state then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 1
                end
            end
        else
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 0
                end
            end
            for _, p in ipairs(invisibleParts) do
                p:Destroy()
            end
            invisibleParts = {}
        end
    end
)

print("✅ بخش ۶: Invisible (بی‌باگ) اضافه شد!")
-- ================================================
-- 🇮🇷 بخش ۷: رفتن پیش پلیر (Teleport)
-- ================================================
local function teleportToPlayer()
    if not selectedPlayer then
        print("⚠️ لطفاً ابتدا یک بازیکن انتخاب کن!")
        return
    end
    local char = player.Character
    if not char then
        return
    end
    local root = char:FindFirstChild("HumanoidRootPart")
    local targetRoot = selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root or not targetRoot then
        return
    end
    root.CFrame = CFrame.new(targetRoot.Position + Vector3.new(0, 2, 0))
    print("✅ به " .. selectedPlayer.Name .. " تله‌پورت شدی!")
end

local teleportFrame = Instance.new("Frame")
teleportFrame.Size = UDim2.new(0.92, 0, 0, 38)
teleportFrame.BackgroundColor3 = Color3.fromRGB(22, 25, 40)
teleportFrame.BackgroundTransparency = 0.3
teleportFrame.BorderSizePixel = 0
teleportFrame.Parent = scrollFrame

local teleportCorner = Instance.new("UICorner")
teleportCorner.CornerRadius = UDim.new(0, 8)
teleportCorner.Parent = teleportFrame

local teleportLabel = Instance.new("TextLabel")
teleportLabel.Size = UDim2.new(0.55, 0, 1, 0)
teleportLabel.Position = UDim2.new(0.05, 0, 0, 0)
teleportLabel.BackgroundTransparency = 1
teleportLabel.Text = "🚀 رفتن پیش پلیر"
teleportLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
teleportLabel.TextSize = 13
teleportLabel.Font = Enum.Font.GothamMedium
teleportLabel.TextXAlignment = Enum.TextXAlignment.Left
teleportLabel.Parent = teleportFrame

local teleportBtn = Instance.new("TextButton")
teleportBtn.Size = UDim2.new(0.3, 0, 0.7, 0)
teleportBtn.Position = UDim2.new(0.65, 0, 0.15, 0)
teleportBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
teleportBtn.BorderSizePixel = 0
teleportBtn.Text = "برو"
teleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportBtn.TextSize = 13
teleportBtn.Font = Enum.Font.GothamBold
teleportBtn.Parent = teleportFrame

local teleportBtnCorner = Instance.new("UICorner")
teleportBtnCorner.CornerRadius = UDim.new(0, 6)
teleportBtnCorner.Parent = teleportBtn

teleportBtn.MouseButton1Click:Connect(teleportToPlayer)
teleportBtn.TouchTap:Connect(teleportToPlayer)

print("✅ بخش ۷: رفتن پیش پلیر اضافه شد!")
-- ================================================
-- ================================================
-- 🇮🇷 بخش ۸: Fly (پرواز با سرعت ثابت)
-- ================================================
local flyEnabled = false
local flySpeed = 50
local flyConnection = nil
local flyVelocity = nil
local flyGyro = nil

local function getRoot()
    local char = player.Character
    if char then
        return char:FindFirstChild("HumanoidRootPart")
    end
    return nil
end

local function startFly()
    local root = getRoot()
    if not root then
        return
    end
    
    stopFly()
    
    flyEnabled = true
    flyVelocity = Instance.new("BodyVelocity")
    flyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
    flyVelocity.Velocity = Vector3.zero
    flyVelocity.Parent = root
    
    flyGyro = Instance.new("BodyGyro")
    flyGyro.MaxTorque = Vector3.new(100000, 100000, 100000)
    flyGyro.P = 10000
    flyGyro.Parent = root
    
    flyConnection = RunService.RenderStepped:Connect(function()
        if not flyEnabled then
            return
        end
        local character = player.Character
        local currentRoot = character and character:FindFirstChild("HumanoidRootPart")
        local camera = workspace.CurrentCamera
        if not currentRoot or not camera then
            return
        end
        local forward = camera.CFrame.LookVector
        local right = camera.CFrame.RightVector
        local movement = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            movement += forward
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            movement -= forward
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            movement += right
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            movement -= right
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            movement += Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            movement -= Vector3.new(0, 1, 0)
        end
        if movement.Magnitude > 0 then
            movement = movement.Unit * flySpeed
        end
        flyVelocity.Velocity = movement
        flyGyro.CFrame = camera.CFrame
    end)
end

local function stopFly()
    flyEnabled = false
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    if flyVelocity then
        flyVelocity:Destroy()
        flyVelocity = nil
    end
    if flyGyro then
        flyGyro:Destroy()
        flyGyro = nil
    end
end

createToggle(scrollFrame, "✈️ Fly (پرواز)",
    function() return flyEnabled end,
    function(state)
        if state then
            startFly()
        else
            stopFly()
        end
    end
)

print("✅ بخش ۸: Fly (با سرعت ثابت) اضافه شد!")
-- ================================================
-- 🇮🇷 بخش ۹: WalkSpeed, JumpPower, Infinite Jump (از Utility Box)
-- ================================================

-- WalkSpeed
local function applyWalkSpeed()
    local char = player.Character
    if char then
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            hum.WalkSpeed = walkSpeedValue
        end
    end
end

createSlider(scrollFrame, "🏃 WalkSpeed (سرعت راه)", 0, 250,
    function() return walkSpeedValue end,
    function(val)
        walkSpeedValue = val
        applyWalkSpeed()
    end
)

-- JumpPower
local function applyJumpPower()
    local char = player.Character
    if char then
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            hum.JumpPower = jumpPowerValue
        end
    end
end

createSlider(scrollFrame, "🦘 JumpPower (قدرت پرش)", 0, 200,
    function() return jumpPowerValue end,
    function(val)
        jumpPowerValue = val
        applyJumpPower()
    end
)

-- Infinite Jump (از Utility Box)
local infiniteJumpEnabled = false

local function toggleInfiniteJump(state)
    infiniteJumpEnabled = state
end

UserInputService.JumpRequest:Connect(function()
    if not infiniteJumpEnabled then
        return
    end
    local char = player.Character
    if char then
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

createToggle(scrollFrame, "⬆️ Infinite Jump (پرش بی‌نهایت)",
    function() return infiniteJumpEnabled end,
    function(state)
        infiniteJumpEnabled = state
    end
)

print("✅ بخش ۹: WalkSpeed, JumpPower, Infinite Jump (از Utility Box) اضافه شدند!")
-- ================================================
-- 🇮🇷 بخش ۱۰: Noclip + WallWalk (با Raycast)
-- ================================================

-- Noclip
local function startNoclip()
    if noclipConnection then
        noclipConnection:Disconnect()
    end
    noclipEnabled = true
    noclipConnection = RunService.Stepped:Connect(function()
        if not noclipEnabled then
            return
        end
        local character = player.Character
        if not character then
            return
        end
        for _, object in ipairs(character:GetDescendants()) do
            if object:IsA("BasePart") then
                object.CanCollide = false
            end
        end
    end)
end

local function stopNoclip()
    noclipEnabled = false
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    local character = player.Character
    if character then
        for _, object in ipairs(character:GetDescendants()) do
            if object:IsA("BasePart") then
                object.CanCollide = true
            end
        end
    end
end

createToggle(scrollFrame, "🌀 Noclip (عبور از دیوار)",
    function() return noclipEnabled end,
    function(state)
        if state then
            startNoclip()
        else
            stopNoclip()
        end
    end
)

-- WallWalk (با Raycast)
local wallWalkEnabled = false
local wallWalkConnection = nil

local function startWallWalk()
    if wallWalkConnection then
        wallWalkConnection:Disconnect()
    end
    wallWalkConnection = RunService.Heartbeat:Connect(function()
        if not wallWalkEnabled then
            return
        end
        local char = player.Character
        if not char then
            return
        end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then
            return
        end
        local hum = char:FindFirstChild("Humanoid")
        if not hum then
            return
        end
        
        -- Raycast به سمت جلو و پایین
        local rayDirection = root.CFrame.LookVector * 3 + Vector3.new(0, -1, 0)
        local rayParams = RaycastParams.new()
        rayParams.FilterType = Enum.RaycastFilterType.Blacklist
        rayParams.FilterDescendantsInstances = {char}
        local result = workspace:Raycast(root.Position, rayDirection, rayParams)
        
        if result and result.Instance and result.Instance:IsA("BasePart") then
            local normal = result.Normal
            local hitPos = result.Position
            root.CFrame = CFrame.new(hitPos + normal * 2)
            hum.WalkSpeed = 25
        else
            hum.WalkSpeed = walkSpeedValue
        end
    end)
end

local function stopWallWalk()
    if wallWalkConnection then
        wallWalkConnection:Disconnect()
        wallWalkConnection = nil
    end
    applyWalkSpeed()
end

createToggle(scrollFrame, "🧱 WallWalk (راه رفتن روی دیوار)",
    function() return wallWalkEnabled end,
    function(state)
        wallWalkEnabled = state
        if state then
            startWallWalk()
        else
            stopWallWalk()
        end
    end
)

print("✅ بخش ۱۰: Noclip و WallWalk (با Raycast) اضافه شدند!")
-- ================================================
-- 🇮🇷 بخش ۱۱: Fling + WalkFling (از Fling Box)
-- ================================================
local flingEnabled = false
local walkFlingEnabled = false
local flingConnection = nil
local walkFlingConnection = nil
local flingVelocity = nil
local walkFlingVelocity = nil

-- Fling - با انتخاب بازیکن از لیست
local function startFling()
    if not selectedPlayer or not selectedPlayer.Character then
        print("⚠️ لطفاً ابتدا یک بازیکن انتخاب کن!")
        return
    end
    
    local char = player.Character
    if not char then
        return
    end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then
        return
    end
    
    stopFling()
    
    flingEnabled = true
    flingVelocity = Instance.new("BodyVelocity")
    flingVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
    flingVelocity.Velocity = Vector3.new(0, 80, 0)
    flingVelocity.Parent = root
    
    flingConnection = RunService.Heartbeat:Connect(function()
        if not flingEnabled then
            return
        end
        if not selectedPlayer or not selectedPlayer.Character then
            return
        end
        local currentRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        local targetRoot = selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not currentRoot or not targetRoot then
            return
        end
        
        currentRoot.CFrame = CFrame.new(targetRoot.Position + Vector3.new(0, 2, 0))
        
        if flingVelocity and flingVelocity.Parent == currentRoot then
            flingVelocity.Velocity = currentRoot.CFrame.LookVector * 100 + Vector3.new(0, 80, 0)
        end
    end)
    
    print("💥 Fling روی " .. selectedPlayer.Name .. " فعال شد!")
end

local function stopFling()
    flingEnabled = false
    if flingConnection then
        flingConnection:Disconnect()
        flingConnection = nil
    end
    if flingVelocity then
        flingVelocity:Destroy()
        flingVelocity = nil
    end
end

createToggle(scrollFrame, "💥 Fling (پرتاب بازیکن)",
    function() return flingEnabled end,
    function(state)
        if state then
            startFling()
        else
            stopFling()
        end
    end
)

-- WalkFling
local function startWalkFling()
    local char = player.Character
    if not char then
        return
    end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not root or not hum then
        return
    end
    
    stopWalkFling()
    
    walkFlingEnabled = true
    hum.AutoRotate = false
    
    walkFlingVelocity = Instance.new("BodyAngularVelocity")
    walkFlingVelocity.MaxTorque = Vector3.new(100000, 100000, 100000)
    walkFlingVelocity.AngularVelocity = Vector3.new(0, 100, 0)
    walkFlingVelocity.Parent = root
    
    walkFlingConnection = RunService.Heartbeat:Connect(function()
        if not walkFlingEnabled then
            return
        end
        local currentRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not currentRoot then
            return
        end
        if walkFlingVelocity and walkFlingVelocity.Parent == currentRoot then
            walkFlingVelocity.AngularVelocity = Vector3.new(0, 100, 0)
        end
    end)
    
    print("🌀 WalkFling فعال شد!")
end

local function stopWalkFling()
    walkFlingEnabled = false
    if walkFlingConnection then
        walkFlingConnection:Disconnect()
        walkFlingConnection = nil
    end
    if walkFlingVelocity then
        walkFlingVelocity:Destroy()
        walkFlingVelocity = nil
    end
    local char = player.Character
    if char then
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            hum.AutoRotate = true
        end
    end
end

createToggle(scrollFrame, "🌀 WalkFling (پرتاب با راه رفتن)",
    function() return walkFlingEnabled end,
    function(state)
        if state then
            startWalkFling()
        else
            stopWalkFling()
        end
    end
)

print("✅ بخش ۱۱: Fling و WalkFling (از Fling Box) اضافه شدند!")
-- ================================================
-- 🇮🇷 بخش ۱۲: درگ کردن منو + دکمه‌های بستن و کوچک‌سازی
-- ================================================

-- ===== درگ کردن منو =====
local dragging = false
local dragStart, startPos

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
       input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or
                     input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
       input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- ===== دکمه کوچک‌سازی در گوشه =====
local minimizedButton = Instance.new("TextButton")
minimizedButton.Size = UDim2.new(0, 55, 0, 55)
minimizedButton.Position = UDim2.new(1, -70, 0, 10)
minimizedButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
minimizedButton.BackgroundTransparency = 0.2
minimizedButton.BorderSizePixel = 0
minimizedButton.Text = "🇮🇷"
minimizedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizedButton.TextSize = 28
minimizedButton.Font = Enum.Font.GothamBold
minimizedButton.Visible = false
minimizedButton.Parent = screenGui

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(1, 0)
minCorner.Parent = minimizedButton

-- ===== مدیریت کوچک‌سازی =====
local isMinimized = false

local function toggleMinimize()
    isMinimized = not isMinimized
    mainFrame.Visible = not isMinimized
    minimizedButton.Visible = isMinimized
end

minimizeBtn.MouseButton1Click:Connect(toggleMinimize)
minimizeBtn.TouchTap:Connect(toggleMinimize)

minimizedButton.MouseButton1Click:Connect(function()
    isMinimized = false
    mainFrame.Visible = true
    minimizedButton.Visible = false
end)

minimizedButton.TouchTap:Connect(function()
    isMinimized = false
    mainFrame.Visible = true
    minimizedButton.Visible = false
end)

-- ===== دکمه بستن =====
local function closeMenu()
    screenGui:Destroy()
    print("🇮🇷 منوی ایرانی بسته شد!")
end

closeBtn.MouseButton1Click:Connect(closeMenu)
closeBtn.TouchTap:Connect(closeMenu)

print("✅ بخش ۱۲: درگ کردن منو و دکمه‌های بستن/کوچک‌سازی (اصلاح‌شده) اضافه شد!")
-- ================================================
-- 🇮🇷 بخش ۱۳: توابع اصلی (فقط KillFarm - بدون Order)
-- ================================================

-- ⚠️ توابع startAttach و stopAttach در بخش ۵ تعریف شدن.

-- Kill Farm
local function startKillFarm()
    if killFarmConnection then
        killFarmConnection:Disconnect()
    end
    local angle = 0
    killFarmConnection = RunService.Heartbeat:Connect(function()
        if not isKillFarm then
            return
        end
        if not selectedPlayer or not selectedPlayer.Character then
            return
        end
        local char = player.Character
        if not char then
            return
        end
        local root = char:FindFirstChild("HumanoidRootPart")
        local targetRoot = selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not root or not targetRoot then
            return
        end
        angle = angle + 0.2
        root.CFrame = CFrame.new(targetRoot.Position + Vector3.new(math.cos(angle) * 3, 1, math.sin(angle) * 3))
    end)
end

local function stopKillFarm()
    if killFarmConnection then
        killFarmConnection:Disconnect()
        killFarmConnection = nil
    end
end

print("✅ بخش ۱۳: توابع اصلی (فقط KillFarm) بارگذاری شدند!")
-- ================================================
-- 🇮🇷 بخش ۱۶: Camlock Tool (قفل دوربین روی بازیکن)
-- ================================================
local isCamlock = false
local camTarget = nil

local function startCamlock()
    if not selectedPlayer then
        print("⚠️ لطفاً ابتدا یک بازیکن انتخاب کن!")
        return
    end
    isCamlock = true
    camTarget = selectedPlayer
    print("🔒 Camlock روی " .. selectedPlayer.Name .. " فعال شد!")
end

local function stopCamlock()
    isCamlock = false
    camTarget = nil
    print("🔓 Camlock غیرفعال شد!")
end

RunService.Heartbeat:Connect(function()
    if isCamlock and camTarget and camTarget.Character then
        local cam = workspace.CurrentCamera
        if cam then
            local targetRoot = camTarget.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                cam.CFrame = CFrame.lookAt(cam.CFrame.Position, targetRoot.Position)
            end
        end
    end
end)

createToggle(scrollFrame, "🔒 Camlock (قفل دوربین روی بازیکن)",
    function() return isCamlock end,
    function(state)
        if state then
            startCamlock()
        else
            stopCamlock()
        end
    end
)

print("✅ بخش ۱۶: Camlock Tool اضافه شد!")

-- ================================================
-- 🇮🇷 بخش ۱۷: Float (سطح نامرئی زیر پا) - اصلاح‌شده
-- ================================================
local floatEnabled = false
local floatConnection = nil
local floatVelocity = nil

local function startFloat()
    local char = player.Character
    if not char then
        return
    end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then
        return
    end
    
    stopFloat()
    
    floatEnabled = true
    floatVelocity = Instance.new("BodyVelocity")
    floatVelocity.MaxForce = Vector3.new(0, 100000, 0)
    floatVelocity.Velocity = Vector3.new(0, 0, 0)
    floatVelocity.Parent = root
    
    floatConnection = RunService.Heartbeat:Connect(function()
        if not floatEnabled then
            return
        end
        local currentRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not currentRoot then
            return
        end
        if floatVelocity and floatVelocity.Parent == currentRoot then
            floatVelocity.Velocity = Vector3.new(0, 0, 0)
        end
    end)
end

local function stopFloat()
    floatEnabled = false
    if floatConnection then
        floatConnection:Disconnect()
        floatConnection = nil
    end
    if floatVelocity then
        floatVelocity:Destroy()
        floatVelocity = nil
    end
end

createToggle(scrollFrame, "🪶 Float (شناور)",
    function() return floatEnabled end,
    function(state)
        if state then
            startFloat()
        else
            stopFloat()
        end
    end
)

print("✅ بخش ۱۷: Float (اصلاح‌شده) اضافه شد!")
-- ================================================
-- 🇮🇷 بخش ۱۸: ESP (خط کشیدن دور بازیکنان)
-- ================================================
local espEnabled = false
local espHighlights = {}
local espTargetPlayer = nil

local function createESP(target)
    if not target or not target.Character then
        return
    end
    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineTransparency = 0
    highlight.Parent = target.Character
    table.insert(espHighlights, highlight)
end

local function clearESP()
    for _, h in ipairs(espHighlights) do
        h:Destroy()
    end
    espHighlights = {}
end

local function updateESP()
    clearESP()
    if not espEnabled then
        return
    end
    
    if espTargetPlayer then
        -- ESP فقط روی یک بازیکن خاص
        createESP(espTargetPlayer)
    else
        -- ESP روی همه بازیکنان
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player then
                createESP(plr)
            end
        end
    end
end

-- دکمه ESP همگانی
createToggle(scrollFrame, "🎯 ESP (همه بازیکنان)",
    function() return espEnabled and espTargetPlayer == nil end,
    function(state)
        espEnabled = state
        espTargetPlayer = nil
        if state then
            updateESP()
        else
            clearESP()
        end
    end
)

-- دکمه ESP روی بازیکن انتخاب‌شده (توی لیست)
createToggle(scrollFrame, "🎯 ESP روی بازیکن انتخاب‌شده",
    function() return espEnabled and espTargetPlayer ~= nil end,
    function(state)
        if state and not selectedPlayer then
            print("⚠️ لطفاً ابتدا یک بازیکن انتخاب کن!")
            return
        end
        espEnabled = state
        espTargetPlayer = state and selectedPlayer or nil
        if state then
            updateESP()
        else
            clearESP()
        end
    end
)

Players.PlayerAdded:Connect(updateESP)
Players.PlayerRemoving:Connect(updateESP)

print("✅ بخش ۱۸: ESP اضافه شد!")

-- ================================================
-- 🇮🇷 بخش ۱۹: دکمه Camlock جداگانه روی صفحه (با درگ)
-- ================================================
local camlockButton = nil
local camlockActive = false
local isDraggingCamlock = false
local dragStartCamlock, startPosCamlock

local function createCamlockButton()
    if camlockButton then
        camlockButton:Destroy()
        camlockButton = nil
    end
    
    camlockButton = Instance.new("TextButton")
    camlockButton.Size = UDim2.new(0, 100, 0, 50)
    camlockButton.Position = UDim2.new(0.5, -50, 0.8, 0)
    camlockButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    camlockButton.BorderSizePixel = 0
    camlockButton.Text = "🔒 Camlock"
    camlockButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    camlockButton.TextSize = 16
    camlockButton.Font = Enum.Font.GothamBold
    camlockButton.Parent = screenGui
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = camlockButton
    
    -- ===== درگ کردن دکمه Camlock =====
    camlockButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            isDraggingCamlock = true
            dragStartCamlock = input.Position
            startPosCamlock = camlockButton.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if isDraggingCamlock and (input.UserInputType == Enum.UserInputType.MouseMovement or
                                   input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStartCamlock
            camlockButton.Position = UDim2.new(
                startPosCamlock.X.Scale,
                startPosCamlock.X.Offset + delta.X,
                startPosCamlock.Y.Scale,
                startPosCamlock.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            isDraggingCamlock = false
        end
    end)
    
    -- ===== کلیک روی دکمه Camlock =====
    camlockButton.MouseButton1Click:Connect(function()
        camlockActive = not camlockActive
        if camlockActive then
            camlockButton.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
            camlockButton.Text = "🔓 Camlock"
            -- پیدا کردن نزدیک‌ترین بازیکن
            local closest = nil
            local minDist = math.huge
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= player then
                    local targetRoot = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                    if targetRoot then
                        local dist = (targetRoot.Position - player.Character.HumanoidRootPart.Position).Magnitude
                        if dist < minDist then
                            minDist = dist
                            closest = plr
                        end
                    end
                end
            end
            if closest then
                selectedPlayer = closest
                startCamlock()
                print("🔒 Camlock روی نزدیک‌ترین پلیر: " .. closest.Name)
            else
                camlockActive = false
                camlockButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
                camlockButton.Text = "🔒 Camlock"
                print("⚠️ هیچ پلیری نزدیک نیست!")
            end
        else
            camlockButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
            camlockButton.Text = "🔒 Camlock"
            stopCamlock()
            print("🔓 Camlock غیرفعال شد!")
        end
    end)
end

-- دکمه ایجاد/حذف Camlock در منو
createToggle(scrollFrame, "🔄 ایجاد دکمه Camlock روی صفحه",
    function() return camlockButton ~= nil end,
    function(state)
        if state then
            createCamlockButton()
        else
            if camlockButton then
                camlockButton:Destroy()
                camlockButton = nil
                stopCamlock()
                camlockActive = false
            end
        end
    end
)

print("✅ بخش ۱۹: دکمه Camlock جداگانه (با درگ) اضافه شد!")
-- ================================================
-- 🇮🇷 بخش ۲۰: آیدی سازنده (همیشه آخر)
-- ================================================
local creditFrame = Instance.new("Frame")
creditFrame.Size = UDim2.new(0.92, 0, 0, 50)
creditFrame.BackgroundTransparency = 1
creditFrame.BorderSizePixel = 0
creditFrame.Parent = scrollFrame

local creditLabel1 = Instance.new("TextLabel")
creditLabel1.Size = UDim2.new(1, 0, 0.5, 0)
creditLabel1.Position = UDim2.new(0, 0, 0, 0)
creditLabel1.BackgroundTransparency = 1
creditLabel1.Text = "آیدی سازنده اسکریپت در تلگرام : @fromiran_love"
creditLabel1.TextColor3 = Color3.fromRGB(150, 150, 180)
creditLabel1.TextSize = 12
creditLabel1.Font = Enum.Font.GothamMedium
creditLabel1.TextTransparency = 0.3
creditLabel1.TextScaled = true
creditLabel1.Parent = creditFrame

local creditLabel2 = Instance.new("TextLabel")
creditLabel2.Size = UDim2.new(1, 0, 0.5, 0)
creditLabel2.Position = UDim2.new(0, 0, 0.5, 0)
creditLabel2.BackgroundTransparency = 1
creditLabel2.Text = "آیدی سازنده اسکریپت در روبیکا : @H033_EIN_0"
creditLabel2.TextColor3 = Color3.fromRGB(150, 150, 180)
creditLabel2.TextSize = 12
creditLabel2.Font = Enum.Font.GothamMedium
creditLabel2.TextTransparency = 0.3
creditLabel2.TextScaled = true
creditLabel2.Parent = creditFrame

print("✅ بخش ۲۰: آیدی سازنده (همیشه آخر) اضافه شد!")

-- ================================================
-- 🇮🇷 بخش ۲۱: Lag (لگ فیک)
-- ================================================
local lagEnabled = false
local lagConnection = nil

local function startLag()
    if lagConnection then
        lagConnection:Disconnect()
    end
    lagConnection = RunService.Heartbeat:Connect(function()
        if not lagEnabled then
            return
        end
        local char = player.Character
        if not char then
            return
        end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then
            return
        end
        -- ایجاد لگ فیک با جابجایی ناگهانی
        if math.random(1, 100) < 5 then
            local offset = Vector3.new(
                math.random(-3, 3),
                math.random(-2, 2),
                math.random(-3, 3)
            )
            root.CFrame = root.CFrame + offset
        end
    end)
end

local function stopLag()
    if lagConnection then
        lagConnection:Disconnect()
        lagConnection = nil
    end
end

createToggle(scrollFrame, "📶 Lag (لگ فیک)",
    function() return lagEnabled end,
    function(state)
        lagEnabled = state
        if state then
            startLag()
        else
            stopLag()
        end
    end
)

print("✅ بخش ۲۱: Lag اضافه شد!")

-- ================================================
-- 🇮🇷 بخش ۲۲: Hitbox (نمایش هیت‌باکس بازیکنان)
-- ================================================
local hitboxEnabled = false
local hitboxParts = {}

local function createHitbox(plr)
    if not plr or not plr.Character then
        return
    end
    local root = plr.Character:FindFirstChild("HumanoidRootPart")
    if not root then
        return
    end
    
    local box = Instance.new("BoxHandleAdornment")
    box.Size = Vector3.new(4, 6, 4)
    box.Adornee = root
    box.Color3 = Color3.fromRGB(255, 0, 0)
    box.Transparency = 0.5
    box.ZIndex = 0
    box.Parent = root
    table.insert(hitboxParts, box)
end

local function clearHitbox()
    for _, h in ipairs(hitboxParts) do
        h:Destroy()
    end
    hitboxParts = {}
end

local function updateHitbox()
    clearHitbox()
    if not hitboxEnabled then
        return
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            createHitbox(plr)
        end
    end
end

createToggle(scrollFrame, "📦 Hitbox (نمایش هیت‌باکس)",
    function() return hitboxEnabled end,
    function(state)
        hitboxEnabled = state
        if state then
            updateHitbox()
        else
            clearHitbox()
        end
    end
)

Players.PlayerAdded:Connect(updateHitbox)
Players.PlayerRemoving:Connect(updateHitbox)

print("✅ بخش ۲۲: Hitbox اضافه شد!")
