local localPlayer = game.Players.LocalPlayer
local playerHRP = localPlayer.Character.HumanoidRootPart
local playerTycoon = nil
local playerCash = localPlayer:WaitForChild("leaderstats").Cash
local gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name

local settings = {
    autoClickerCooldown = 0.01, 
    autoBuyTycoonButtonsCooldown = 1,
    autoCollectCashCooldown = 0.5,

    autoCollectCash = false,
    autoBuyTycoonButtons = false,
    autoMineClicker = false,
}

local function getIqBadge()
    if firetouchinterest then
        firetouchinterest(playerHRP, workspace["Wall Hop"].asset:GetChildren()[2], 0)
        firetouchinterest(playerHRP, workspace["Wall Hop"].asset:GetChildren()[2], 1)
    end
end

local function getChairBadge()
    if firetouchinterest then
        firetouchinterest(playerHRP, workspace.Obby.Chair:GetChildren()[3], 0)
        firetouchinterest(playerHRP, workspace.Obby.Chair:GetChildren()[3], 1)
        task.wait()
        firetouchinterest(playerHRP, workspace.Obby.TP.Part1, 0)
        firetouchinterest(playerHRP, workspace.Obby.TP.Part1, 1)
    end
end

local function explodeMango()
    if fireclickdetector then
        for i = 1, 30, 1 do
            fireclickdetector(workspace.Lobby.mango.Handle.ClickDetector)
            task.wait(0.15)
        end
    end
end

local function getNeaTBadge()
    if fireclickdetector and firetouchinterest then
        fireclickdetector(playerTycoon.Purchases.neat.Frame.tp.ClickDetector)
        task.wait()
        firetouchinterest(playerHRP, playerTycoon.Purchases.neat.WinPad3, 0)
        firetouchinterest(playerHRP, playerTycoon.Purchases.neat.WinPad3, 1)
        task.wait()
        if mouse1click then
            mouse1click(localPlayer.PlayerGui.exit.exitButton)
        else
            Rayfield:Notify({Title = "Warning",Content = "Your executor doesnt supports 'mouse1click' function, you'll need click on 'Exit' button manually.",Duration = 6.5,Image = "rewind",})
        end
    end
end

local function getPlayerTycoon()
    if localPlayer.TycoonOwned and localPlayer.TycoonOwned.Value ~= nil then
        playerTycoon = localPlayer.TycoonOwned.Value
    end
end

local function clickOnMine()
    if fireclickdetector and playerTycoon and playerTycoon:WaitForChild("Purchases").db1.Click then
        fireclickdetector(playerTycoon.Purchases.db1.Click.ClickDetector)
    end
end

local function buyTycoonButtons()
    if playerTycoon and playerTycoon:FindFirstChild("Buttons") then
        for i, buttons in pairs(playerTycoon.Buttons:GetChildren()) do
            if v.ClassName == "Model" and v:FindFirstChild("Button") and v:FindFirstChild("Price") then
                if v.Button.Transparency == 0 and playerCash.Value >= v.Price.Value then
                    if firetouchinterest then 
                        firetouchinterest(playerHRP, v.Button, 0)
                        firetouchinterest(playerHRP, v.Button, 1)
                    end
                end
            end
        end
    end
end

local function collectCash()
    if firetouchinterest then
        firetouchinterest(playerHRP, playerTycoon.MainItems.CashCollector.Button, 0)
        firetouchinterest(playerHRP, playerTycoon.MainItems.CashCollector.Button, 1)
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
    DisableBuildWarnings = false,
})

repeat task.wait(1) getPlayerTycoon() until playerTycoon ~= nil and playerTycoon:FindFirstChild("PurchasedObjects") ~= nil

local TycoonTab = Window:CreateTab("Tycoon Tab", 4483362458)
local GetIqButton = TycoonTab:CreateButton({
    Name = "Get IQ+ Badge",
    Callback = function()
    getIqBadge()
    end,
})
local GetChairButton = TycoonTab:CreateButton({
    Name = "Get Chair Badge",
    Callback = function()
    getChairBadge()
    end,
})
local ExplodeMangoButton = TycoonTab:CreateButton({
    Name = "Explode Mango",
    Callback = function()
    explodeMango()
    end,
})
local GetNeaTBadgeButton = TycoonTab:CreateButton({
    Name = "Get NeaT Badge",
    Callback = function()
    getNeaTBadge()
    end,
})
local AutoClickerMineToggle = TycoonTab:CreateToggle({
    Name = "Enable Mine Clicker",
    CurrentValue = false,
    Flag = "AutoClickerMineToggle",
    Callback = function(Value)
    settings.autoMineClicker = Value
    if settings.autoMineClicker == true then
        while settings.autoMineClicker then
            clickOnMine()
            task.wait(settings.autoClickerCooldown)
        end
    end
    end,
})

local AutoBuyToggle = TycoonTab:CreateToggle({
    Name = "Auto Buy Tycoon Buttons",
    CurrentValue = false,
    Flag = "AutoBuyTycoonToggle",
    Callback = function(Value)
    settings.autoBuyTycoonButtons = Value
    if settings.autoBuyTycoonButtons == true then
        while settings.autoBuyTycoonButtons then
            buyTycoonButtons()
            task.wait(settings.autoBuyTycoonButtonsCooldown)
        end
    end
    end,
})

local AutoCollectToggle = TycoonTab:CreateToggle({
    Name = "Auto Collect Cash",
    CurrentValue = false,
    Flag = "AutoCollectCashToggle",
    Callback = function(Value)
    settings.autoCollectCash = Value
    if settings.autoCollectCash == true then
        while settings.autoCollectCash then
            collectCash()
            task.wait(settings.autoCollectCashCooldown)
        end
    end
    end,
})

local ClickerCooldownSlider = TycoonTab:CreateSlider({
    Name = "Clicker Cooldown",
    Range = {0.01, 1},
    Increment = 0.01,
    Suffix = "s",
    CurrentValue = settings.autoClickerCooldown,
    Flag = "ClickerCooldown",
    Callback = function(Value)
    settings.autoClickerCooldown = Value
    end,
})

local BuyCooldownSlider = TycoonTab:CreateSlider({
    Name = "Buy Buttons Cooldown",
    Range = {0.01, 1},
    Increment = 0.01,
    Suffix = "s",
    CurrentValue = settings.autoBuyTycoonButtonsCooldown,
    Flag = "BuyCooldown",
    Callback = function(Value)
    settings.autoBuyTycoonButtonsCooldown = Value
    end,
})

local CollectCooldownSlider = TycoonTab:CreateSlider({
    Name = "Collect Cash Cooldown",
    Range = {0.01, 1},
    Increment = 0.01,
    Suffix = "s",
    CurrentValue = settings.autoCollectCashCooldown,
    Flag = "CollectCooldown",
    Callback = function(Value)
    settings.autoCollectCashCooldown = Value
    end,
})

local function updateHRP() --this is a mess deff
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
playerHRP = character:WaitForChild("HumanoidRootPart")
end

localPlayer.CharacterAdded:Connect(function()
    updateHRP()
    getPlayerTycoon()
  end)

updateHRP()

Rayfield:Notify({
    Title = "Warning",
    Content = "If you die unexpectedly, you'll need to re-enable all functions manually.",
    Duration = 6.5,
    Image = "rewind",
})