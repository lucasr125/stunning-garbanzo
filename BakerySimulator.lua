local localPlayer = game.Players.LocalPlayer
local playerName = localPlayer.Name
local playerPlot = nil
local gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name

local settings = {
  autoSellProducts = false, 

  autoGetIngredients = false,
  autoPutIngredients = false,
  autoGetProducts = false,

  getIngredientsCooldown = 1,
  putIngredientsCooldown = 0.5,
  getProductsCooldown = 1,
}

local function getPlayerPlot()
  for i, v in pairs(workspace.Plots:GetChildren()) do
    if v:GetAttribute("Owner") == playerName then
      playerPlot = v
    end
  end
end

local function getIngredients()
  for i, v in pairs(workspace.Ingredients:GetChildren()) do
    if v:FindFirstChild("Ingredient_Collider") then
      game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("TI_0"):FireServer(v["Ingredient_Collider"])
    end
  end
end

local function putIngredients()
  for i, v in pairs(playerPlot.Ovens:GetChildren()) do
    if v:FindFirstChild("ConverterData") and v.ConverterData:FindFirstChild("noob") then
      v.ConverterData.noob:FireServer()
    end
  end
end

local function startBaking()
  for i, v in pairs(playerPlot.Ovens:GetChildren()) do
    if v:FindFirstChild("ConverterData") and v.ConverterData:FindFirstChild("MaxContents") and v.ConverterData:FindFirstChild("ConverterContents") and v.ConverterData.ConverterContents:FindFirstChild("Ingredients") then
      local maxOvenIngredients = v.ConverterData.MaxContents.Value
      local ingredientsFolder = v.ConverterData.ConverterContents.Ingredients
      local totalOvenIngredients = #ingredientsFolder:GetChildren()
      if totalOvenIngredients >= maxOvenIngredients then
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("StartBake"):FireServer(v, "Cookies")
      end
    end
  end
end

local function getProducts()
  for i, v in pairs(playerPlot.Ovens:GetChildren()) do
    if v:FindFirstChild("ConverterData") and v.ConverterData:FindFirstChild("ConverterContents") and v.ConverterData.ConverterContents:FindFirstChild("Products") then
      local ovenProducts = v.ConverterData.ConverterContents.Products
      if #ovenProducts:GetChildren() >= 1 then
        v.ConverterData:FindFirstChild("__REMOTE"):FireServer()
        if settings.autoSellProducts == true then
          playerPlot:FindFirstChild("Shelf"):FindFirstChild("Info"):FireServer()
        end
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
    DisableBuildWarnings = false,
})

repeat task.wait(0.15) getPlayerPlot() until playerPlot ~= nil

local BakeryTab = Window:CreateTab("Bakery Tab", "banknote")
local ConfigurationTab = Window:CreateTab("Configuration Tab", "cog")

local AutoGetIngredientsToggle = BakeryTab:CreateToggle({Name = "Auto Get Ingredients",CurrentValue = settings.autoGetIngredients,Flag = "GetIngredientsToggle",Callback = function(Value)
  settings.autoGetIngredients = Value
  if settings.autoGetIngredients == true then
    while settings.autoGetIngredients do
      getIngredients()
      task.wait(settings.getIngredientsCooldown)
    end
  end
end,})

local PutIngredientsToggle = BakeryTab:CreateToggle({Name = "Auto Put Ingredients",CurrentValue = settings.autoPutIngredients,Flag = "PutIngredientsToggle",Callback = function(Value)
  settings.autoPutIngredients = Value
  if settings.autoPutIngredients == true then
    while settings.autoPutIngredients do
      putIngredients()
      task.wait(settings.putIngredientsCooldown)
    end
  end
end,})

local GetProductsToggle = BakeryTab:CreateToggle({Name = "Auto Get Oven Products",CurrentValue = settings.autoGetProducts,Flag = "GetProductsToggle",Callback = function(Value)
  settings.autoGetProducts = Value
  if settings.autoGetProducts == true then
    while settings.autoGetProducts do
      getProducts()
      task.wait(settings.getProductsCooldown)
    end
  end
end,})

local StartBakingButton = BakeryTab:CreateButton({
    Name = "Start Baking Ingredients (experimental)",
    Callback = function()
    startBaking()
    end,
})

local GetIngredientsCooldownSlider = ConfigurationTab:CreateSlider({Name = "Get Ingredients Cooldown",Range = {0.01, 2},Increment = 0.01,Suffix = "s",CurrentValue = settings.getIngredientsCooldown,Flag = "GetIngredientsCooldownFlag",Callback = function(Value)
    settings.getIngredientsCooldown = Value
end,})

local PutIngredientsCooldownSlider = ConfigurationTab:CreateSlider({Name = "Put Ingredients Cooldown",Range = {0.01, 2},Increment = 0.01,Suffix = "s",CurrentValue = settings.putIngredientsCooldown,Flag = "PutIngredientsCooldownFlag",Callback = function(Value)
    settings.putIngredientsCooldown = Value
end,})

local GetProductsCooldownSlider = ConfigurationTab:CreateSlider({Name = "Get Products Cooldown",Range = {0.01, 2},Increment = 0.01,Suffix = "s",CurrentValue = settings.getProductsCooldown,Flag = "GetProductsCooldownFlag",Callback = function(Value)
    settings.getProductsCooldown = Value
end,})

local AutoSellProductsToggle = ConfigurationTab:CreateToggle({Name = "Auto Sell Products",CurrentValue = settings.autoSellProducts,Flag = "AutoSellProductsToggle",Callback = function(Value)
  settings.autoSellProducts = Value
end,})