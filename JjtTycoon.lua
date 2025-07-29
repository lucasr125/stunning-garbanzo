local localPlayer = game.Players.LocalPlayer
local playerHRP = localPlayer.Character.HumanoidRootPart
local playerTycoon = nil
local playerCash = localPlayer:FindFirstChild("leaderstats").Money
local gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name

local autoClickOnMineActive = false
local autoClickOnMineCooldown = 0.1
local autoCollectCashActive = false
local autoCollectCashCooldown = 0.1
local autoBuyTycoonButtonsActive = false
local autoBuyTycoonButtonsCooldown = 0.1

local function getPlayerTycoon()
if workspace["Pandoo Tycoon Kit"].Tycoons.Tycoon.Owner.Value == localPlayer.UserId then
playerTycoon = workspace["Pandoo Tycoon Kit"].Tycoons.Tycoon
end
end

local function clickOnMine()
if playerTycoon and fireclickdetector then
fireclickdetector(playerTycoon.Purchases.Mine.Click.ClickDetector)
end
end

local function collectCash()
if playerTycoon and firetouchinterest then
firetouchinterest(playerHRP, playerTycoon.Essentials.Collect, 0)
firetouchinterest(playerHRP, playerTycoon.Essentials.Collect, 1)
end
end

local function buyTycoonButtons()
if playerTycoon and firetouchinterest then
for i, v in pairs(playerTycoon.Buttons:GetChildren()) do
if v:FindFirstChild("Button") then
firetouchinterest(playerHRP, v.Button, 0)
firetouchinterest(playerHRP, v.Button, 1)
end
end
end
end

local function autoBuyLoop()
while autoBuyTycoonButtonsActive do
buyTycoonButtons()
task.wait(autoBuyTycoonButtonsCooldown)
end
end

local function autoCollectLoop()
while autoCollectCashActive do
collectCash()
task.wait(autoCollectCashCooldown)
end
end

local function autoClickLoop()
while autoClickOnMineActive do
clickOnMine()
task.wait(autoClickOnMineCooldown)
end
end


local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = gameName.." Window",
    Icon = 0,
    LoadingTitle = "Rayfield Interface Suite",
    LoadingSubtitle = "by Sirius",
    ShowText = gameName,
    Theme = "Default",

    ToggleUIKeybind = "K",

    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false
})

repeat task.wait(1) getPlayerTycoon() until playerTycoon ~= nil
task.wait(2)

local TycoonTab = Window:CreateTab("Tycoon Tab", 4483362458)

local AutoBuyToggle = TycoonTab:CreateToggle({
    Name = "Auto Buy Tycoon Buttons",
    CurrentValue = false,
    Flag = "AutoBuyTycoonToggle",
    Callback = function(Value)
    autoBuyTycoonButtonsActive = Value
    if Value then task.spawn(autoBuyLoop) end
    end,
})

local AutoCollectToggle = TycoonTab:CreateToggle({
    Name = "Auto Collect Cash",
    CurrentValue = false,
    Flag = "AutoCollectCashToggle",
    Callback = function(Value)
    autoCollectCashActive = Value
    if Value then task.spawn(autoCollectLoop) end
    end,
})

local AutoClickToggle = TycoonTab:CreateToggle({
    Name = "Auto Click Mine",
    CurrentValue = false,
    Flag = "AutoClickMineToggle",
    Callback = function(Value)
    autoClickOnMineActive = Value
    if Value then task.spawn(autoClickLoop) end
    end,
})


local ClickerCooldownSlider = TycoonTab:CreateSlider({
    Name = "Clicker Cooldown",
    Range = {
        0.01, 1
    },
    Increment = 0.01,
    Suffix = "s",
    CurrentValue = autoClickOnMineCooldown,
    Flag = "ClickerCooldown",
    Callback = function(Value)
    autoClickOnMineCooldown = Value
    end,
})

local BuyCooldownSlider = TycoonTab:CreateSlider({
    Name = "Buy Buttons Cooldown",
    Range = {
        0.01, 1
    },
    Increment = 0.01,
    Suffix = "s",
    CurrentValue = autoBuyTycoonButtonsCooldown,
    Flag = "BuyCooldown",
    Callback = function(Value)
    autoBuyTycoonButtonsCooldown = Value
    end,
})

local CollectCooldownSlider = TycoonTab:CreateSlider({
    Name = "Collect Cash Cooldown",
    Range = {
        0.01, 1
    },
    Increment = 0.01,
    Suffix = "s",
    CurrentValue = autoCollectCashCooldown,
    Flag = "CollectCooldown",
    Callback = function(Value)
    autoCollectCashCooldown = Value
    end,
})

local function updateHRP()
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
playerHRP = character:WaitForChild("HumanoidRootPart")
end

localPlayer.CharacterAdded:Connect(function()
    updateHRP()
end)

updateHRP()

Rayfield:Notify({
   Title = "Warning",
   Content = "If you die unexpectedly, you'll need to re-enable all functions manually.",
   Duration = 6.5,
   Image = "rewind",
})