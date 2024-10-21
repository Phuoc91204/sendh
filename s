local SaveModule = require(game.ReplicatedStorage.Library.Client.Save)

local function formatTime(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local seconds = seconds % 60
    return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NotificationGui"
screenGui.Parent = playerGui

local backgroundFrame = Instance.new("Frame")
backgroundFrame.Size = UDim2.new(1, 0, 1.1, 0) -- Phủ 45% màn hình theo chiều dọc
backgroundFrame.BackgroundColor3 = Color3.new(0, 0, 0) -- Màu nền đen
backgroundFrame.Position = UDim2.new(0, 0, 0, -50) -- Vị trí bắt đầu từ góc trên bên trái
backgroundFrame.BorderSizePixel = 0 -- Không có viền
backgroundFrame.Parent = screenGui

local timeLabel = Instance.new("TextLabel", backgroundFrame)
timeLabel.Name = "TimeLabel"
timeLabel.Size = UDim2.new(1, 0, 1/6, 0)
timeLabel.Position = UDim2.new(0, 0, 0, 20)
timeLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Màu nền đen
timeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
timeLabel.BorderSizePixel = 0
timeLabel.TextScaled = true

local hugeLabel = Instance.new("TextLabel", backgroundFrame)
hugeLabel.Name = "HugeLabel"
hugeLabel.Text = "Éo Được Huge nào."
hugeLabel.Size = UDim2.new(1, 0, 1/6, 0)
hugeLabel.Position = UDim2.new(0, 0, 1/6, 0)
hugeLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Màu nền đen
hugeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
hugeLabel.BorderSizePixel = 0
hugeLabel.TextScaled = true

local diamondLabel = Instance.new("TextLabel", backgroundFrame)
diamondLabel.Name = "DiamondLabel"
diamondLabel.Text = "Đang cập nhật Diamonds..."
diamondLabel.Size = UDim2.new(1, 0, 1/6, 0)
diamondLabel.Position = UDim2.new(0, 0, 2/6, 0)
diamondLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Màu nền đen
diamondLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
diamondLabel.BorderSizePixel = 0
diamondLabel.TextScaled = true

local hoith95Label = Instance.new("TextLabel", backgroundFrame)
hoith95Label.Name = "PhuocBadlion"
hoith95Label.Text = "FISHING"
hoith95Label.Font = Enum.Font.GothamBold
hoith95Label.Size = UDim2.new(1, 0, 1/6, 0)
hoith95Label.Position = UDim2.new(0, 0, 5/6, 0) -- Chỉnh vị trí xuống cuối cùng trên screengui
hoith95Label.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Màu nền đen
hoith95Label.TextColor3 = Color3.fromRGB(0, 128, 0) -- Màu xanh lá cây
hoith95Label.BorderSizePixel = 0
hoith95Label.TextScaled = true

local function isFishing()
    local character = game.Players.LocalPlayer.Character
    if character then
        -- Kiểm tra xem người chơi có "Rod" và "FishingLine" trong mô hình nhân vật không
        local model = character:FindFirstChild("Model")
        if model and model:FindFirstChild("Rod") and model.Rod:FindFirstChild("FishingLine") then
            return true
        end
    end
    return false
end

local function updateFishingStatus()
    -- Kiểm tra xem người chơi có đang câu cá không
    if isFishing() then
        hoith95Label.Text = "FISHING..."
        hoith95Label.TextColor3 = Color3.fromRGB(0, 128, 0) -- Màu xanh lá cây khi đang câu
    else
        hoith95Label.Text = "NOT FISHING"
        hoith95Label.TextColor3 = Color3.fromRGB(255, 0, 0) -- Màu đỏ khi không câu
    end
end

local function updateHugeNotification(hugeCount)
    hugeLabel.Text = "HUGE: " .. hugeCount .. ""
    hugeLabel.BackgroundColor3 = hugeCount == 0 and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(0, 128, 0)
    hugeLabel.TextColor3 = hugeCount == 0 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(255, 0, 0)
    hugeLabel.Font = Enum.Font.GothamBold
end

local function updateDiamondNotification(diamondCount)
    diamondLabel.Text = "GEMS: " .. diamondCount .. ""
    diamondLabel.TextColor3 = Color3.fromRGB(0, 128, 255)
    diamondLabel.Font = Enum.Font.GothamBold
end

local lastHugeUpdateTime = 0
local lastDiamondUpdateTime = 0
local initialDiamondValue = game.Players.LocalPlayer.leaderstats["\240\159\146\142 Diamonds"].Value

local startTime = os.time()

task.spawn(function()
    while true do
        local currentTime = os.time()

        local elapsedTime = currentTime - startTime
        timeLabel.Text = "Up Time: " .. formatTime(elapsedTime)
        timeLabel.Font = Enum.Font.GothamBold

        updateFishingStatus()

        if currentTime >= lastHugeUpdateTime + 30 then
            TotalHuge = 0
            local result = SaveModule.Get()
            local pets = result.Inventory.Pet
            -- Đếm số lượng Huge pet.
            for _, pet in pairs(pets) do
                if string.match(pet.id, "Huge") then
                    TotalHuge = TotalHuge + 1
                end
            end
            updateHugeNotification(TotalHuge)
            lastHugeUpdateTime = currentTime
        end
        
        if currentTime >= lastDiamondUpdateTime + 30 then
            local currentDiamondValue = game.Players.LocalPlayer.leaderstats["\240\159\146\142 Diamonds"].Value
            updateDiamondNotification(currentDiamondValue)
            lastDiamondUpdateTime = currentTime
            
            if currentDiamondValue == initialDiamondValue and currentTime >= lastDiamondUpdateTime + 600 then
                print("Giá trị Diamonds không thay đổi trong 10 phút!")
                --loadstring(game:HttpGet("https://raw.githubusercontent.com/Hoith95/Pet-99/main/ServerHop3"))()
            end
        end
        
        task.wait(1)
    end
end)
