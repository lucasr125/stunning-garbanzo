if game.PlaceId == 123352919072485 then
  print('real?')
local localPlayer = game.Players.LocalPlayer
local playerTycoon = nil
local playerHRP = localPlayer.Character.HumanoidRootPart
local gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name

local settings = {
  selectBuyOption = "Remote", -- Remote or TouchInterest
  conveyorVelocityMultiplier = 2, 
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
    for i, v in pairs(playerTycoon.TmpAssets:GetChildren()) do
      if string.find(string.lower(v.Name), "conveyor") then
        for y, parts in pairs(v:GetChildren()) do
          parts.AssemblyLinearVelocity *= settings.conveyorVelocityMultiplier
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

local TycoonTab = Window:CreateTab("Tycoon Tab", 4483362458)

local BuyButtonsDropdown = TycoonTab:CreateDropdown({
   Name = "Buy Buttons Option",
   Options = {"Remote","TouchInterest"},
   CurrentOption = {"Remote"},
   MultipleOptions = false,
   Flag = "BuyButtonsFlag1",
   Callback = function(Options)
     settings.selectBuyOption = Options[1]
end,
})
local BuyTycoonButtonsButton = TycoonTab:CreateButton({
    Name = "Buy All Tycoon Buttons",
    Callback = function()
    buyTycoonButtons()
    end,
})
local CollectCashButton = TycoonTab:CreateButton({
    Name = "Collect Cash",
    Callback = function()
    collectCash()
    end,
})
local BringAllUpgradersButton = TycoonTab:CreateButton({
    Name = "Bring All Upgraders",
    Callback = function()
    bringAllUpgraders()
    end,
})
local ConveyorVelocityMultiplierSlider = TycoonTab:CreateSlider({
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
local ChangeConveyorVelocityButton = TycoonTab:CreateButton({
    Name = "Change Conveyor Velocity",
    Callback = function()
    changeConveyorVelocity()
    end,
})
local RemoveGamepassButton = TycoonTab:CreateButton({
    Name = "Remove Gamepass Buttons",
    Callback = function()
    removeGamepass()
    end,
})
local UpgradeOresByTouchButton = TycoonTab:CreateButton({
    Name = "Upgrade Ores By Touch",
    Callback = function()
    upgradeOresByTouch()
    end,
})
end
