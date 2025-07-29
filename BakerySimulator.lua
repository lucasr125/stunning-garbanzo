local localPlayer = game.Players.LocalPlayer
local playerName = localPlayer.Name
local playerPlot = nil
local gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name

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
      local args = { v["Ingredient_Collider"] }
      game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("TI_0"):FireServer(unpack(args))
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
        local args = { v, "Cookies" }
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("StartBake"):FireServer(unpack(args))
      end
      task.wait()
    end
  end
end

local function getProducts()
  for i, v in pairs(playerPlot.Ovens:GetChildren()) do
    if v:FindFirstChild("ConverterData") and v.ConverterData:FindFirstChild("ConverterContents") and v.ConverterData.ConverterContents:FindFirstChild("Products") then
      local ovenProducts = v.ConverterData.ConverterContents.Products
      if #ovenProducts:GetChildren() >= 1 then
        v.ConverterData:FindFirstChild("__REMOTE"):FireServer()
        task.wait()
        playerPlot:FindFirstChild("Shelf"):FindFirstChild("Info"):FireServer()
      end
    end
    task.wait()
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

repeat getPlayerPlot() task.wait(1) until playerPlot ~= nil

local BakeryTab = Window:CreateTab("Bakery Tab", 4483362458)
local GetIngredientsButton = BakeryTab:CreateButton({
    Name = "Get Ingredients",
    Callback = function()
    getIngredients()
    end,
})
local PutIngredientsButton = BakeryTab:CreateButton({
    Name = "Put Ingredients",
    Callback = function()
    putIngredients()
    end,
})
local StartBakingButton = BakeryTab:CreateButton({
    Name = "Start Baking Ingredients",
    Callback = function()
    startBaking()
    end,
})
local GetProductsButton = BakeryTab:CreateButton({
    Name = "Get Oven Products",
    Callback = function()
    getProducts()
    end,
})