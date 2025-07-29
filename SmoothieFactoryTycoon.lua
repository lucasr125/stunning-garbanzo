local localPlayer = game.Players.LocalPlayer
local playerPlot = nil
local playerHRP = localPlayer.Character.HumanoidRootPart
local gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local settings = {
  enableBlenderUsing = "ProximityPrompt", -- Remote or ProximityPrompt (recommended)
  onlyBuyButtons = "Upgraders", -- Upgraders, Others, Both
  
  autoPickupCrates = false,
  autoBuyButtons = false,
  autoEnableBlenders = false, 
  autoOpenJarFactory = false, 
  autoRemoveTandGButtons = false,
  autoDoObbies = false,
  autoDoRebirths = false,
  autoSendCrates = false,
  
  basementSupport = false,
  moonSupport = false,
  venusSupport = false,
  marsSupport = false,
  
  pickupCratesCooldown = 5,
  buyButtonsCooldown = 2.5,
  enableBlendersCooldown = 7,
  openJarFactoryCooldown = 25,
  removeTandGButtonsCooldown = 10,
  doObbiesCooldown = 60,
  doRebirthsCooldown = 15,
  sellJarCrates = 8,
}

local function getPlayerPlot()
  if localPlayer and localPlayer:FindFirstChild("Values") and localPlayer.Values:FindFirstChild("Plot") then
    if localPlayer.Values.Plot ~= nil then
      playerPlot = localPlayer.Values.Plot.Value
    end
  end
end

local function openJarFactory()
  if playerPlot then
    local S_OpenedJarFactory = ReplicatedStorage.Remotes.Event["Factory Components"].S_OpenedJarFactory
    S_OpenedJarFactory:FireServer("Main_JarFactory")
    if settings.basementSupport == true then
      S_OpenedJarFactory:FireServer("Basement_JarFactory")
    end
    if settings.moonSupport == true then
      S_OpenedJarFactory:FireServer("Moon_JarFactory")
    end
    if settings.venusSupport == true then
      S_OpenedJarFactory:FireServer("Venus_JarFactory")
    end
    if settings.marsSupport == true then
      S_OpenedJarFactory:FireServer("Mars_JarFactory")
    end
  end
end

local function sendCrate()
  if playerPlot and playerPlot:FindFirstChild("ProcessingMachines") and playerPlot.ProcessingMachines:FindFirstChild("Main_JarPackager") then
    local mainJarMachine = playerPlot.ProcessingMachines["Main_JarPackager"]
    local totalJarsOnCrate = #mainJarMachine.Crates:FindFirstChild("Main_JarPackager_Crate").Jars:GetChildren()
    if totalJarsOnCrate >=  settings.sellJarCrates and fireproximityprompt then
      fireproximityprompt(mainJarMachine.Button.Button.Attachment.OpenDoorPrompt)
    end
    if settings.basementSupport == true then
      local mainJarMachine = playerPlot.ProcessingMachines["Basement_JarPackager"]
      local totalJarsOnCrate = #mainJarMachine.Crates:FindFirstChild("Basement_JarPackager_Crate").Jars:GetChildren()
      if totalJarsOnCrate >=  settings.sellJarCrates and fireproximityprompt then
        fireproximityprompt(mainJarMachine.Button.Button.Attachment.OpenDoorPrompt)
      end
    end
    if settings.moonSupport == true then
      
    end
    if settings.venusSupport == true then
      
    end
    if settings.marsSupport == true then
      
    end
  end
end

local function buyButtons()
  if playerPlot and playerPlot:FindFirstChild("PurchaseButtons") and playerPlot:FindFirstChild("UpgradeButtons") then
    if settings.onlyBuyButtons == "Upgraders" then
      for i, v in pairs(playerPlot.PurchaseButtons:GetChildren()) do
        if v:IsA("Model") then
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Event"):WaitForChild("PurchaseButton"):FireServer(v.Name)
        end
      end
    elseif settings.onlyBuyButtons == "Others" then
      for i, v in pairs(playerPlot.UpgradeButtons:GetChildren()) do
        if v:IsA("Model") then
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Event"):WaitForChild("PurchaseButton"):FireServer(v.Name)
        end
      end
    elseif settings.onlyBuyButtons == "Both" then
      for i, v in pairs(playerPlot.PurchaseButtons:GetChildren()) do
        if v:IsA("Model") then
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Event"):WaitForChild("PurchaseButton"):FireServer(v.Name)
        end
      end
      for i, v in pairs(playerPlot.UpgradeButtons:GetChildren()) do
        if v:IsA("Model") then
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Event"):WaitForChild("PurchaseButton"):FireServer(v.Name)
        end
      end
    end
  end
end

local function removeTokensGamepassesButtons()
  if playerPlot and playerPlot:FindFirstChild("KeepButtons") and playerPlot:FindFirstChild("PurchaseButtons") then
    for i, v in pairs(playerPlot.KeepButtons:GetChildren()) do
      if v:IsA("Model") then
        v:Destroy()
      end
    end
    for i, v in pairs(playerPlot.PurchaseButtons:GetChildren()) do
      if v:FindFirstChild("Button") and v.Button.Material == Enum.Material.Neon then
        v:Destroy()
      end
    end
  end
end

local function enableAllBlenders()
  if playerPlot and playerPlot:FindFirstChild("Purchases") then
    for i, v in pairs(playerPlot.Purchases:GetChildren()) do
      if string.find(string.lower(v.Name), "blender") and v:IsA("Model") then
        if settings.enableBlenderUsing == "Remote" and v:FindFirstChild("ActivationLight") and v.ActivationLight.Color == Color3.fromRGB(0, 255, 0) then
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Event"):WaitForChild("Factory Components"):WaitForChild("S_ActivateBlender"):FireServer(v.Name)
          v.ActivationLight.Color = Color3.fromRGB(255, 0, 0)
        elseif settings.enableBlenderUsing == "ProximityPrompt" and v:FindFirstChild("ActivationLight") and v.ActivationLight.Color == Color3.fromRGB(0, 255, 0) and fireproximityprompt then
          fireproximityprompt(v.Button.Attachment.ActivateBlender)
        end
      end
    end
  end
end

local function getAllCrates()
  for i, v in pairs(workspace.RandomCrateDropsFolder:GetChildren()) do
    if v:FindFirstChild("Box") and v.Box.CanCollide == false then
      v.Box.CFrame = playerHRP.CFrame
    end
  end
end

local function doObbies()
  if playerPlot and playerHRP and firetouchinterest then
    for i, v in pairs(workspace.Obbies:GetChildren()) do
      if v:FindFirstChild("Finish") and v.Finish:FindFirstChild("Button") then
        firetouchinterest(playerHRP, v.Finish.Button, 0)
        firetouchinterest(playerHRP, v.Finish.Button, 1)
      end
    end
  end
end

local function doRebirth()
  if playerPlot and firetouchinterest and playerPlot:FindFirstChild("RebirthButtons") and playerPlot.RebirthButtons:FindFirstChild("RebirthButton") and playerPlot.RebirthButtons.RebirthButton:FindFirstChild("Button") then
    firetouchinterest(playerHRP, playerPlot.RebirthButtons.RebirthButton.Button, 0)
    firetouchinterest(playerHRP, playerPlot.RebirthButtons.RebirthButton.Button, 1)
    task.wait(1)
    if localPlayer.PlayerGui.MainGui.RebirthUi.Visible == true then
      game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Event"):WaitForChild("Factory Components"):WaitForChild("S_Rebirth"):FireServer()
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

repeat task.wait(1) getPlayerPlot() until playerPlot ~= nil

local TycoonTab = Window:CreateTab("Tycoon Tab", 4483362458)
local AutomatizationTab = Window:CreateTab("Automatization Tab", "refresh-ccw")
local ConfigurationTab = Window:CreateTab("Configuration Tab", "sliders-horizontal")

local RemoveTandGButton = TycoonTab:CreateButton({
    Name = "Remove Tokens and Gamepasses",
    Callback = function()
    removeTokensGamepassesButtons()
    end,
})

local DoObbiesButton = TycoonTab:CreateButton({
    Name = "Do Obbies",
    Callback = function()
    doObbies()
    end,
})

local DoRebirthButton = TycoonTab:CreateButton({
    Name = "Do Rebirth",
    Callback = function()
    doRebirth()
    end,
})

local EnableBlendersButton = TycoonTab:CreateButton({
    Name = "Enable All Blenders",
    Callback = function()
    enableAllBlenders()
    end,
})

local OpenJarFactoryButton = TycoonTab:CreateButton({
    Name = "Open Jar Factory",
    Callback = function()
    openJarFactory()
    end,
})

local GetAllCratesButton = TycoonTab:CreateButton({
    Name = "Get All Crates",
    Callback = function()
    getAllCrates()
    end,
})

local SendJarCrateButton = TycoonTab:CreateButton({
    Name = "Send Jar Crate",
    Callback = function()
    sendCrate()
    end,
})

local BuyTycoonButtonsButton = TycoonTab:CreateButton({
    Name = "Buy Tycoon Buttons",
    Callback = function()
    buyButtons()
    end,
})

local AutoCollectToggle = AutomatizationTab:CreateToggle({
    Name = "Auto Collect Cash",
    CurrentValue = false,
    Flag = "AutoCollectCashToggle",
    Callback = function(Value)
    
    end,
})

local BuyButtonsDropdown = ConfigurationTab:CreateDropdown({
   Name = "Buy Buttons Option",
   Options = {"Upgraders","Others","Both"},
   CurrentOption = {"Upgraders"},
   MultipleOptions = false,
   Flag = "BuyButtonsFlag1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Options)
     settings.onlyBuyButtons = Options[1]
end,
})

local EnableBlenderOptionDropdown = ConfigurationTab:CreateDropdown({
   Name = "Enable Blender Option",
   Options = {"Remote","ProximityPrompt"},
   CurrentOption = {"ProximityPrompt"},
   MultipleOptions = false,
   Flag = "EnableBlenderOptionFlag", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Options)
     settings.enableBlenderUsing = Options[1]
end,
})

local BasementSupportToggle = ConfigurationTab:CreateToggle({
    Name = "Basement Support",
    CurrentValue = settings.basementSupport,
    Flag = "BasementSupportFlag",
    Callback = function(Value)
    settings.basementSupport = Value
    end,
})

local pickupCratesCooldownSlider = ConfigurationTab:CreateSlider({
    Name = "Pickup Crates Cooldown",
    Range = {0.01, 7},
    Increment = 0.01,
    Suffix = "s",
    CurrentValue = settings.pickupCratesCooldown,
    Flag = "PickupCratesCooldownFlag",
    Callback = function(Value)
    settings.pickupCratesCooldown = Value
    end,
})

local buyButtonsCooldownSlider = ConfigurationTab:CreateSlider({
    Name = "Buy Buttons Cooldown",
    Range = {0.01, 5},
    Increment = 0.01,
    Suffix = "s",
    CurrentValue = settings.buyButtonsCooldown,
    Flag = "BuyButtonsCooldownFlag",
    Callback = function(Value)
    settings.buyButtonsCooldown = Value
    end,
})

local enableBlendersCooldownSlider = ConfigurationTab:CreateSlider({
    Name = "Enable Blenders Cooldown",
    Range = {0.01, 10},
    Increment = 0.01,
    Suffix = "s",
    CurrentValue = settings.enableBlendersCooldown,
    Flag = "EnableBlendersCooldownFlag",
    Callback = function(Value)
    settings.enableBlendersCooldown = Value
    end,
})

local openJarFactoryCooldownSlider = ConfigurationTab:CreateSlider({
    Name = "Open Jar Factory Cooldown",
    Range = {1, 60},
    Increment = 1,
    Suffix = "s",
    CurrentValue = settings.openJarFactoryCooldown,
    Flag = "OpenJarFactoryCooldownFlag",
    Callback = function(Value)
    settings.openJarFactoryCooldown = Value
    end,
})

local removeTandGButtonsCooldownSlider = ConfigurationTab:CreateSlider({
    Name = "Remove Tokens and Gamepasses Cooldown",
    Range = {1, 10},
    Increment = 1,
    Suffix = "s",
    CurrentValue = settings.removeTandGButtonsCooldown,
    Flag = "RemoveTandGButtonsCooldownFlag",
    Callback = function(Value)
    settings.removeTandGButtonsCooldown = Value
    end,
})

local doObbiesCooldownSlider = ConfigurationTab:CreateSlider({
    Name = "Do Obbies Cooldown",
    Range = {45, 120},
    Increment = 1,
    Suffix = "s",
    CurrentValue = settings.doObbiesCooldown,
    Flag = "DoObbiesCooldownFlag",
    Callback = function(Value)
    settings.doObbiesCooldown = Value
    end,
})

local doRebirthsCooldown = ConfigurationTab:CreateSlider({
    Name = "Do Rebirths Cooldown",
    Range = {0.01, 30},
    Increment = 0.01,
    Suffix = "s",
    CurrentValue = settings.doRebirthsCooldown,
    Flag = "DoRebirthsCooldown",
    Callback = function(Value)
    settings.doRebirthsCooldown = Value
    end,
})

local sellJarCratesSlider = ConfigurationTab:CreateSlider({
    Name = "Sell Jar Crates",
    Range = {1, 8},
    Increment = 1,
    Suffix = "jars",
    CurrentValue = settings.sellJarCrates,
    Flag = "SellJarCratesFlag",
    Callback = function(Value)
    settings.sellJarCrates = Value
    end,
})

RunService.Heartbeat:Connect(function()
  if playerHRP == nil then
    playerHRP = localPlayer.Character.HumanoidRootPart
  end
  if playerPlot == nil then
    getPlayerPlot()
  end
end)


--[[workspace.Tycoons.Tycoon2.ProcessingMachines.Main_JarFactory.Button.Button.Attachment.OpenDoorPrompt
workspace.Tycoons.Tycoon2.ProcessingMachines.Main_JarFactory.Button.Button.Attachment.Arrow.ImageLabel

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local S_OpenedJarFactory = ReplicatedStorage.Remotes.Event["Factory Components"].S_OpenedJarFactory -- RemoteEvent 

S_OpenedJarFactory:FireServer("Basement_JarFactory")

workspace.Tycoons.Tycoon8.ProcessingMachines.Basement_JarPackager.Crates.Basement_JarPackager_Crate.Jars
workspace.Tycoons.Tycoon8.ProcessingMachines.Basement_JarPackager.Button.Button.Attachment.OpenDoorPrompt]]