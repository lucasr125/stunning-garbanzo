local localPlayer = game.Players.LocalPlayer
local playerHRP = localPlayer.Character.HumanoidRootPart
local playerTycoon = nil
local RunService = game:GetService("RunService")
local heartbeatConnection
local gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name

local settings = {
    updateValues = true,

    autoMineClicker = false,
    autoCollectCash = false,
    autoBuyTycoonButtons = false,

    mineClickerCooldown = 0.1,
    collectCashCooldown = 0.1,
    buyTycoonButtonsCooldown = 0.25,
}

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

repeat task.wait(0.25) getPlayerTycoon() until playerTycoon ~= nil

local TycoonTab = Window:CreateTab("Tycoon Tab", "banknote")
local ConfigurationTab = Window:CreateTab("Configuration Tab", "cog")

local BuyTycoonButtonsToggle = TycoonTab:CreateToggle({Name = "Auto Buy Tycoon Buttons",CurrentValue = settings.autoBuyTycoonButtons,Flag = "BuyTycoonButtonsToggle",Callback = function(Value)
    settings.autoBuyTycoonButtons = Value
    if settings.autoBuyTycoonButtons == true then
        while settings.autoBuyTycoonButtons do
            buyTycoonButtons()
            task.wait(settings.buyTycoonButtonsCooldown)
        end
    end
end,})

local CollectCashToggle = TycoonTab:CreateToggle({Name = "Auto Collect Cash",CurrentValue = false,Flag = "CollectCashToggle",Callback = function(Value)
    settings.autoCollectCash = Value
    if settings.autoCollectCash == true then
        while settings.autoCollectCash do
            collectCash()
            task.wait(settings.collectCashCooldown)
        end
    end
end,})

local MineClickerToggle = TycoonTab:CreateToggle({Name = "Auto Mine Clicker",CurrentValue = false,Flag = "MineClickerToggle",Callback = function(Value)
    settings.autoMineClicker = Value
    if settings.autoMineClicker == true then
        while settings.autoMineClicker do
            clickOnMine()
            task.wait(settings.mineClickerCooldown)
        end
    end
end,})

local UpdateValuesToggle = ConfigurationTab:CreateToggle({Name = "Update Values",CurrentValue = false,Flag = "UpdateValuesToggle",Callback = function(Value)
    settings.updateValues = Value
end,})

local MineClickerCooldownSlider = ConfigurationTab:CreateSlider({Name = "Mine Clicker Cooldown",Range = {0.01, 1},Increment = 0.01,Suffix = "s",CurrentValue = settings.mineClickerCooldown,Flag = "MineClickerCooldown",Callback = function(Value)
    settings.mineClickerCooldown = Value
end,})

local CollectCashCooldownSlider = ConfigurationTab:CreateSlider({Name = "Collect Cash Cooldown",Range = {0.01, 2},Increment = 0.01,Suffix = "s",CurrentValue = settings.collectCashCooldown,Flag = "CollectCashCooldown",Callback = function(Value)
    settings.collectCashCooldown = Value
end,})

local BuyTycoonButtonsCooldownSlider = ConfigurationTab:CreateSlider({Name = "Buy Tycoon Buttons Cooldown",Range = {0.01, 5},Increment = 0.01,Suffix = "s",CurrentValue = settings.buyTycoonButtonsCooldown,Flag = "BuyTycoonButtonsCooldown",Callback = function(Value)
    settings.buyTycoonButtonsCooldown = Value
end,})

heartbeatConnection = RunService.Heartbeat:Connect(function()
    if settings.updateValues == true then
        getPlayerTycoon()
        if localPlayer and localPlayer.Character then
            local newHRP = localPlayer.Character:FindFirstChild("HumanoidRootPart")
            if newHRP ~= playerHRP then
                playerHRP = newHRP
            end
        else
            playerHRP = nil
        end
    end
end)