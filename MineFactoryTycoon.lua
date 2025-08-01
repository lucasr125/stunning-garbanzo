local localPlayer = game.Players.LocalPlayer
local playerTycoon = nil
local playerHRP = localPlayer.Character.HumanoidRootPart
local RunService = game:GetService("RunService")
local heartbeatConnection
local gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name

local settings = {
  selectBuyOption = "Remote", -- Remote or TouchInterest (recommended)
  conveyorVelocityMultiplier = 2, 

  autoBuyTycoonButtons = false,
  autoCollectCash = false,
  autoRebirth = false,
  autoUseSpins = false,
  autoBuyChests = false,
  autoDoObby = false,
  autoRemoveGamepasses = false,

  buyTycoonButtonsCooldown = 1,
  collectCashCooldown = 1,
  rebirthCooldown = 10,
  useSpinsCooldown = 0.5,
  buyChestsCooldown = 5,
  doObbyCooldown = 20,
  removeGamepassesCooldown = 0.25,
}

local function getPlayerTycoon()
  for i, v in pairs(workspace.Map.Tycoons:GetChildren()) do
    if v:GetAttribute("Owner") == localPlayer.UserId then
      playerTycoon = v
    end
  end
end

local function buyTycoonButtons()
  if playerTycoon and playerTycoon:FindFirstChild("TmpButtons") then
    for i, v in pairs(playerTycoon.TmpButtons:GetChildren()) do
      if settings.selectBuyOption == "Remote" then
        local tempButton = string.split(v.Name, "_")
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("tycoonmanagerservice"):WaitForChild("PurchaseButton"):InvokeServer(tempButton[2])
      elseif settings.selectBuyOption == "TouchInterest" then
        if v:FindFirstChild("MovingPart") and v.MovingPart.Material ~= Enum.Material.Neon and firetouchinterest then
          firetouchinterest(playerHRP, v.MovingPart, 0)
          firetouchinterest(playerHRP, v.MovingPart, 1)
        end
      end
    end
  end
end

local function collectCash()
  if playerTycoon then
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("tycoonmanagerservice"):WaitForChild("ClaimCash"):InvokeServer()
  end
end

local function upgradeOresByTouch()
  if playerTycoon and playerTycoon:FindFirstChild("Ores") and playerTycoon:FindFirstChild("TmpAssets") then
    for a, ores in pairs(playerTycoon.Ores:GetChildren()) do
      if ores.ClassName == "Part" then
        for b, upgraders in pairs(playerTycoon.TmpAssets:GetChildren()) do
          if upgraders:FindFirstChild("TouchPart") and not string.find(string.lower(upgraders.Name), "sellpart") then
            local tempCFrameOres = ores.CFrame
            ores.CFrame = upgraders.TouchPart.CFrame
            task.wait(0.01)
            ores.CFrame = tempCFrameOres
          end
        end
      end
    end
  end
end

local function bringAllUpgraders()
  if playerTycoon and playerTycoon:FindFirstChild("TmpAssets") then
    for i, v in pairs(playerTycoon.TmpAssets:GetChildren()) do
      if v:FindFirstChild("TouchPart") and not string.find(string.lower(v.Name), "sellpart") then
        v.TouchPart.CFrame = playerHRP.CFrame
        v.TouchPart.Size = Vector3.new(10, 15, 10)
      end
    end
  end
end

local function changeConveyorVelocity()
    if playerTycoon and playerTycoon:FindFirstChild("TmpAssets") then
        for _, conveyor in pairs(playerTycoon.TmpAssets:GetChildren()) do
            if string.find(string.lower(conveyor.Name), "conveyor") then
                for _, part in pairs(conveyor:GetChildren()) do
                    if part:IsA("BasePart") and part.AssemblyLinearVelocity then
                        part.AssemblyLinearVelocity *= settings.conveyorVelocityMultiplier
                    end
                end
            end
        end
    end
end

local function doRebirth()
  game:GetService("ReplicatedStorage").Remotes.rebirthservice.Rebirth:InvokeServer()
end

local function useSpins()
  game:GetService("ReplicatedStorage").Remotes.luckproductsservice.SpinWheel:InvokeServer()
end

local function doObby()
  if firetouchinterest and workspace:FindFirstChild("Obby") then
    firetouchinterest(workspace.Obby.ObbyButton.MovingPart, playerHRP, 0)
    firetouchinterest(workspace.Obby.ObbyButton.MovingPart, playerHRP, 1)
  end
end

local function buyChests()
  if fireproximityprompt and workspace:FindFirstChild("Shop") then
    for i, chests in pairs(workspace.Shop:GetChildren()) do
      if string.find(string.lower(chests.Name), "display") then
        if chests:FindFirstChild("ChestPosition") and chests.ChestPosition:FindFirstChild("ProximityPrompt") then
          fireproximityprompt(chests.ChestPosition.ProximityPrompt)
        end
      end
    end
  end
end

local function removeGamepass()
  if playerTycoon and playerTycoon:FindFirstChild("TmpButtons") then
    for i, v in pairs(playerTycoon.TmpButtons:GetChildren()) do
      if v.MovingPart.Material == Enum.Material.Neon then
        v:Destroy()
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

repeat task.wait(1) getPlayerTycoon() until playerTycoon ~= nil

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

local CollectCashToggle = TycoonTab:CreateToggle({Name = "Auto Collect Cash",CurrentValue = settings.autoCollectCash,Flag = "CollectCashToggle",Callback = function(Value)
  settings.autoCollectCash = Value
  if settings.autoCollectCash == true then
    while settings.autoCollectCash do
      collectCash()
      task.wait(settings.collectCashCooldown)
    end
  end
end,})

local RebirthToggle = TycoonTab:CreateToggle({Name = "Auto Rebirth",CurrentValue = settings.autoRebirth,Flag = "RebirthToggle",Callback = function(Value)
  settings.autoRebirth = Value
  if settings.autoRebirth == true then
    while settings.autoRebirth do
      doRebirth()
      task.wait(settings.rebirthCooldown)
    end
  end
end,})

local UseSpinsToggle = TycoonTab:CreateToggle({Name = "Auto Use Spins",CurrentValue = settings.autoUseSpins,Flag = "UseSpinsToggle",Callback = function(Value)
  settings.autoUseSpins = Value
  if settings.autoUseSpins == true then
    while settings.autoUseSpins do
      useSpins()
      task.wait(settings.useSpinsCooldown)
    end
  end
end,})

local BuyChestsToggle = TycoonTab:CreateToggle({Name = "Auto Buy Chests",CurrentValue = settings.autoBuyChests,Flag = "BuyChestsToggle",Callback = function(Value)
  settings.autoBuyChests = Value
  if settings.autoBuyChests == true then
    while settings.autoBuyChests do
      buyChests()
      task.wait(settings.buyChestsCooldown)
    end
  end
end,})

local DoObbyToggle = TycoonTab:CreateToggle({Name = "Auto Do Obby",CurrentValue = settings.autoDoObby,Flag = "DoObbyToggle",Callback = function(Value)
  settings.autoDoObby = Value
  if settings.autoDoObby == true then
    while settings.autoDoObby do
      doObby()
      task.wait(settings.doObbyCooldown)
    end
  end
end,})

local RemoveGamepassesToggle = TycoonTab:CreateToggle({Name = "Auto Remove Gamepasses Buttons",CurrentValue = settings.autoRemoveGamepasses,Flag = "RemoveGamepassesToggle",Callback = function(Value)
  settings.autoRemoveGamepasses = Value
  if settings.autoRemoveGamepasses == true then
    while settings.autoRemoveGamepasses do
      removeGamepass()
      task.wait(settings.removeGamepassesCooldown)
    end
  end
end,})

local BringAllUpgradersButton = TycoonTab:CreateButton({Name = "Bring All Upgraders",Callback = function()
  bringAllUpgraders()
end,})

local ChangeConveyorVelocityButton = TycoonTab:CreateButton({Name = "Change Conveyor Velocity",Callback = function()
  changeConveyorVelocity()
end,})

local UpgradeOresByTouchButton = TycoonTab:CreateButton({Name = "Upgrade Ores By Touch",Callback = function()
  upgradeOresByTouch()
end,})

local BuyButtonsDropdown = ConfigurationTab:CreateDropdown({
   Name = "Buy Buttons Option",
   Options = {"Remote","TouchInterest"},
   CurrentOption = {"Remote"},
   MultipleOptions = false,
   Flag = "BuyButtonsFlag1",
   Callback = function(Options)
     settings.selectBuyOption = Options[1]
end,
})

local ConveyorVelocityMultiplierSlider = ConfigurationTab:CreateSlider({
    Name = "Conveyor Velocity Multiplier",
    Range = {0.01, 5},
    Increment = 0.01,
    Suffix = "x",
    CurrentValue = settings.conveyorVelocityMultiplier,
    Flag = "ConveyorVelocityMultiplier",
    Callback = function(Value)
    settings.conveyorVelocityMultiplier = Value
    end,
})

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