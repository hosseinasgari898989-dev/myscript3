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
-- 🇮🇷 بخش ۵: چسبیدن به پشت و جلو (نسخه اصلاح‌شده)
-- ================================================
-- ⚠️ توجه: توابع startAttach و stopAttach اینجا تعریف شدن
-- تا قبل از استفاده وجود داشته باشند!

local function startAttach()
    if attachConnection then attachConnection:Disconnect() end
    attachConnection = RunService.Heartbeat:Connect(function()
        if not selectedPlayer or not selectedPlayer.Character then return end
        local char = player.Character if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local targetRoot = selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not root or not targetRoot then return end
        local dist = isBackAttach and backDistance or frontDistance
        local dir = isBackAttach and -1 or 1
        root.CFrame = CFrame.new(targetRoot.Position + targetRoot.CFrame.LookVector * dir * dist)
    end)
end

local function stopAttach()
    if attachConnection then attachConnection:Disconnect(); attachConnection = nil end
end

createToggle(scrollFrame, "🎯 چسبیدن به پشت (Back)",
    function() return isBackAttach end,
    function(state)
        if state and not selectedPlayer then
            print("⚠️ اول از لیست بازیکن انتخاب کن!")
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
            print("⚠️ اول از لیست بازیکن انتخاب کن!")
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

print("✅ بخش ۵: چسبیدن به پشت و جلو (اصلاح‌شده) اضافه شدند!")
-- 🇮🇷 بخش ۶: Invisible (غیب شدن) و Order (چرخش)
-- ================================================
createToggle(scrollFrame, "👻 Invisible (غیب شدن)",
    function() return isInvisible end,
    function(state)
        isInvisible = state
        local char = player.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = state and 1 or 0
                end
            end
        end
    end
)

createToggle(scrollFrame, "🔄 Order (چرخش دور بازیکن)",
    function() return isOrder end,
    function(state)
        if state and not selectedPlayer then
            print("⚠️ اول از لیست بازیکن انتخاب کن!")
            return
        end
        isOrder = state
        if state then startOrder() else stopOrder() end
    end
)

createSlider(scrollFrame, "📏 فاصله چرخش", 1, 50,
    function() return orderDistance end,
    function(val) orderDistance = val end
)

print("✅ بخش ۶: Invisible و Order اضافه شدند!")

-- ================================================
-- 🇮🇷 بخش ۷: Kill Farm (کشتن خودکار)
-- ================================================
createToggle(scrollFrame, "⚔️ Kill Farm (کشتن خودکار)",
    function() return isKillFarm end,
    function(state)
        if state and not selectedPlayer then
            print("⚠️ اول از لیست بازیکن انتخاب کن!")
            return
        end
        isKillFarm = state
        if state then startKillFarm() else stopKillFarm() end
    end
)

print("✅ بخش ۷: Kill Farm اضافه شد!")

-- ================================================
-- 🇮🇷 بخش ۸: Fly (پرواز) و Noclip (عبور از دیوار)
-- ================================================
createToggle(scrollFrame, "✈️ Fly (پرواز)",
    function() return isFly end,
    function(state)
        isFly = state
        if state then startFly() else stopFly() end
    end
)

createToggle(scrollFrame, "🌀 Noclip (عبور از دیوار)",
    function() return isNoclip end,
    function(state)
        isNoclip = state
        if state then startNoclip() else stopNoclip() end
    end
)

print("✅ بخش ۸: Fly و Noclip اضافه شدند!")

-- ================================================
-- 🇮🇷 بخش ۹: WalkSpeed (سرعت) و JumpPower (پرش)
-- ================================================
createSlider(scrollFrame, "🏃 WalkSpeed (سرعت راه)", 0, 250,
    function() return walkSpeedValue end,
    function(val)
        walkSpeedValue = val
        local char = player.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then hum.WalkSpeed = val end
        end
    end
)

createSlider(scrollFrame, "🦘 JumpPower (قدرت پرش)", 0, 200,
    function() return jumpPowerValue end,
    function(val)
        jumpPowerValue = val
        local char = player.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then hum.JumpPower = val end
        end
    end
)

print("✅ بخش ۹: WalkSpeed و JumpPower اضافه شدند!")

-- ================================================
-- 🇮🇷 بخش ۱۰: Fling (پرتاب) و WalkFling
-- ================================================
createToggle(scrollFrame, "💥 Fling (پرتاب به بالا)",
    function() return isFling end,
    function(state)
        isFling = state
        if state then startFling() else stopFling() end
    end
)

createToggle(scrollFrame, "🌀 WalkFling (پرتاب با راه رفتن)",
    function() return isWalkFling end,
    function(state)
        isWalkFling = state
        if state then startWalkFling() else stopWalkFling() end
    end
)

print("✅ بخش ۱۰: Fling و WalkFling اضافه شدند!")

-- ================================================
-- 🇮🇷 بخش ۱۵: ایدی سازنده (کم‌رنگ)
-- ================================================
local creditFrame = Instance.new("Frame")
creditFrame.Size = UDim2.new(0.92, 0, 0, 30)
creditFrame.BackgroundTransparency = 1
creditFrame.BorderSizePixel = 0
creditFrame.Parent = scrollFrame

local creditLabel = Instance.new("TextLabel")
creditLabel.Size = UDim2.new(1, 0, 1, 0)
creditLabel.BackgroundTransparency = 1
creditLabel.Text = "@fromiran_love"
creditLabel.TextColor3 = Color3.fromRGB(150, 150, 180)
creditLabel.TextSize = 14
creditLabel.Font = Enum.Font.GothamMedium
creditLabel.TextTransparency = 0.3  -- کم‌رنگ
creditLabel.TextScaled = false
creditLabel.Parent = creditFrame

print("✅ بخش ۱۵: ایدی سازنده اضافه شد!")

-- ================================================
-- ================================================
-- 🇮🇷 بخش ۱۱: دکمه کوچک‌سازی در گوشه (نسخه اصلاح‌شده برای گوشی)
-- ================================================
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

-- مدیریت کوچک‌سازی (با کلیک و لمس)
minimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    mainFrame.Visible = not isMinimized
    minimizedButton.Visible = isMinimized
end)

minimizeBtn.TouchTap:Connect(function()
    isMinimized = not isMinimized
    mainFrame.Visible = not isMinimized
    minimizedButton.Visible = isMinimized
end)

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

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    print("🇮🇷 منوی ایرانی بسته شد!")
end)

closeBtn.TouchTap:Connect(function()
    screenGui:Destroy()
    print("🇮🇷 منوی ایرانی بسته شد!")
end)

print("✅ بخش ۱۱: مدیریت کوچک‌سازی و بستن (اصلاح‌شده برای گوشی) اضافه شد!")

-- 🇮🇷 بخش ۱۲: درگ کردن منو (نسخه اصلاح‌شده)
-- ================================================
local dragging = false
local dragStart, startPos

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
       input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        print("🖱️ درگ شروع شد!") -- برای دیباگ
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
        print("🖱️ درگ تمام شد!") -- برای دیباگ
    end
end)

print("✅ بخش ۱۲: درگ کردن منو (اصلاح‌شده) اضافه شد!")
-- 🇮🇷 بخش ۱۳: توابع اصلی (Order، KillFarm، Fly، Noclip، Fling، WalkFling)
-- ================================================

-- ⚠️ توابع startAttach و stopAttach در بخش ۵ تعریف شدن.
-- اینجا فقط توابع دیگه رو تعریف می‌کنیم.

-- 2️⃣ Order (چرخش دور بازیکن)
local function startOrder()
    if orderConnection then orderConnection:Disconnect() end
    local angle = 0
    orderConnection = RunService.Heartbeat:Connect(function()
        if not isOrder then return end
        if not selectedPlayer or not selectedPlayer.Character then return end
        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local targetRoot = selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not root or not targetRoot then return end
        angle = angle + 0.05
        local radius = orderDistance
        root.CFrame = CFrame.new(targetRoot.Position + Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius))
    end)
end

local function stopOrder()
    if orderConnection then
        orderConnection:Disconnect()
        orderConnection = nil
    end
end

-- 3️⃣ Kill Farm
local function startKillFarm()
    if killFarmConnection then killFarmConnection:Disconnect() end
    local angle = 0
    killFarmConnection = RunService.Heartbeat:Connect(function()
        if not isKillFarm then return end
        if not selectedPlayer or not selectedPlayer.Character then return end
        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local targetRoot = selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not root or not targetRoot then return end
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

-- 4️⃣ Fly (پرواز)
local function startFly()
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(4000, 4000, 4000)
    bv.Parent = root

    local bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(4000, 4000, 4000)
    bg.Parent = root

    if flyConnection then flyConnection:Disconnect() end
    flyConnection = RunService.Heartbeat:Connect(function()
        if not isFly then
            stopFly()
            return
        end

        local cam = workspace.CurrentCamera
        if not cam then return end

        local f = cam.CFrame.LookVector * Vector3.new(1, 0, 1)
        if f.Magnitude > 0 then
            f = f.Unit
        end

        local r = cam.CFrame.RightVector * Vector3.new(1, 0, 1)
        if r.Magnitude > 0 then
            r = r.Unit
        end

        local m = Vector3.new(0, 0, 0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then m = m + f end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then m = m - f end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then m = m - r end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then m = m + r end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then m = m + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then m = m - Vector3.new(0, 1, 0) end
        if m.Magnitude > 0 then m = m.Unit * 50 end

        bv.Velocity = m
        bg.CFrame = cam.CFrame
    end)
end

local function stopFly()
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end

    local char = player.Character
    if char then
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            for _, c in ipairs(root:GetChildren()) do
                if c:IsA("BodyVelocity") or c:IsA("BodyGyro") then
                    c:Destroy()
                end
            end
        end
    end
end

-- 5️⃣ Noclip
local function startNoclip()
    if noclipConnection then noclipConnection:Disconnect() end
    noclipConnection = RunService.Heartbeat:Connect(function()
        if not isNoclip then
            stopNoclip()
            return
        end

        local char = player.Character
        if not char then return end

        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then
                p.CanCollide = false
            end
        end
    end)
end

local function stopNoclip()
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end

    local char = player.Character
    if char then
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then
                p.CanCollide = true
            end
        end
    end
end

-- 6️⃣ Fling
local function startFling()
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(4000, 4000, 4000)
    bv.Velocity = Vector3.new(0, 50, 0)
    bv.Parent = root

    if flingConnection then flingConnection:Disconnect() end
    flingConnection = RunService.Heartbeat:Connect(function()
        if not isFling then
            stopFling()
            return
        end

        if bv and bv.Parent then
            bv.Velocity = Vector3.new(0, 50, 0)
        end
    end)
end

local function stopFling()
    if flingConnection then
        flingConnection:Disconnect()
        flingConnection = nil
    end

    local char = player.Character
    if char then
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            for _, c in ipairs(root:GetChildren()) do
                if c:IsA("BodyVelocity") then
                    c:Destroy()
                end
            end
        end
    end
end

-- 7️⃣ WalkFling
local function startWalkFling()
    local char = player.Character
    if char then
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            hum.WalkSpeed = 200
        end
    end
end

local function stopWalkFling()
    local char = player.Character
    if char then
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            hum.WalkSpeed = walkSpeedValue
        end
    end
end

print("✅ بخش ۱۳: توابع اصلی بارگذاری شدند!")

-- ================================================
-- 🇮🇷 بخش ۱۴: مدیریت Respawn و نوتیفیکیشن
-- ================================================

-- مدیریت تولد مجدد
player.CharacterAdded:Connect(function()
    task.wait(0.5)

    if isInvisible then
        local char = player.Character
        if char then
            for _, p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.Transparency = 1
                end
            end
        end
    end

    if walkSpeedValue then
        local char = player.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                hum.WalkSpeed = walkSpeedValue
            end
        end
    end

    if jumpPowerValue then
        local char = player.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                hum.JumpPower = jumpPowerValue
            end
        end
    end
end)

-- نوتیفیکیشن خوش‌آمدگویی
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "🇮🇷 اسکریپت ایرانی",
        Text = "اسکریپت ایرانی اجرا شد 💥",
        Duration = 5,
    })
end)

print("=========================================")
print("🇮🇷 منوی ایرانی با موفقیت بارگذاری شد!")
print("💥 تمام بخش‌ها فعال و آماده استفاده")
print("=========================================")

-- ================================================
-- ⚠️ چک کردن کامل بودن اسکریپت
-- ================================================
local function checkScriptCompleteness()
    local requiredFunctions = {
        "startAttach", "stopAttach",
        "startOrder", "stopOrder",
        "startKillFarm", "stopKillFarm",
        "startFly", "stopFly",
        "startNoclip", "stopNoclip",
        "startFling", "stopFling",
        "startWalkFling", "stopWalkFling"
    }

    local missing = {}

    -- توابع بالا local هستند، بنابراین با _G یا getfenv قابل دسترسی نیستند.
    -- برای بررسی واقعی، این لیست در همین اسکریپت از طریق local references نگهداری می‌شود.
    local availableFunctions = {
        startAttach = startAttach,
        stopAttach = stopAttach,
        startOrder = startOrder,
        stopOrder = stopOrder,
        startKillFarm = startKillFarm,
        stopKillFarm = stopKillFarm,
        startFly = startFly,
        stopFly = stopFly,
        startNoclip = startNoclip,
        stopNoclip = stopNoclip,
        startFling = startFling,
        stopFling = stopFling,
        startWalkFling = startWalkFling,
        stopWalkFling = stopWalkFling,
    }

    for _, name in ipairs(requiredFunctions) do
        if not availableFunctions[name] then
            table.insert(missing, name)
        end
    end

    if #missing > 0 then
        warn("⚠️ بخش‌های زیر در اسکریپت وجود ندارند:", table.concat(missing, ", "))
        warn("❌ اسکریپت ناقص است! لطفاً همه بخش‌ها را اضافه کنید.")
    else
        print("✅ همه بخش‌ها کامل هستند!")
    end
end

checkScriptCompleteness()

print("✅ بخش ۱۴: مدیریت Respawn و نوتیفیکیشن اضافه شد!")
