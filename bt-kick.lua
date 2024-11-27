-- Configuration
local GAME_PASS_ID = 12345678 -- Replace with your actual Game Pass ID
local KICK_MESSAGE = "Error, You Must buy the Beta Testing!"
local BLUR_EFFECT_NAME = "GameBlur"

-- Services
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- Create and add blur effect
local blur = Instance.new("BlurEffect")
blur.Name = BLUR_EFFECT_NAME
blur.Size = 24
blur.Parent = game.Lighting

-- UI for purchase prompt
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BetaPrompt"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.3, 0, 0.2, 0)
frame.Position = UDim2.new(0.35, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(1, 0, 0.6, 0)
textLabel.Position = UDim2.new(0, 0, 0, 0)
textLabel.Text = "Purchase the Beta Testing Game Pass to continue!"
textLabel.TextColor3 = Color3.new(1, 1, 1)
textLabel.BackgroundTransparency = 1
textLabel.TextScaled = true
textLabel.Parent = frame

local purchaseButton = Instance.new("TextButton")
purchaseButton.Size = UDim2.new(0.45, 0, 0.3, 0)
purchaseButton.Position = UDim2.new(0.05, 0, 0.65, 0)
purchaseButton.Text = "Purchase"
purchaseButton.TextColor3 = Color3.new(1, 1, 1)
purchaseButton.BackgroundColor3 = Color3.new(0, 0.5, 0)
purchaseButton.TextScaled = true
purchaseButton.Parent = frame

local cancelButton = Instance.new("TextButton")
cancelButton.Size = UDim2.new(0.45, 0, 0.3, 0)
cancelButton.Position = UDim2.new(0.5, 0, 0.65, 0)
cancelButton.Text = "Cancel"
cancelButton.TextColor3 = Color3.new(1, 1, 1)
cancelButton.BackgroundColor3 = Color3.new(0.5, 0, 0)
cancelButton.TextScaled = true
cancelButton.Parent = frame

-- Function to check Game Pass ownership
local function hasGamePass()
    local success, hasPass = pcall(function()
        return MarketplaceService:UserOwnsGamePassAsync(player.UserId, GAME_PASS_ID)
    end)
    return success and hasPass
end

-- Function to remove UI and blur
local function removeBlurAndUI()
    if blur then blur:Destroy() end
    if screenGui then screenGui:Destroy() end
end

-- Check Game Pass and handle logic
local function checkGamePass()
    if hasGamePass() then
        removeBlurAndUI()
    else
        -- Show Game Pass prompt on button click
        purchaseButton.MouseButton1Click:Connect(function()
            MarketplaceService:PromptGamePassPurchase(player, GAME_PASS_ID)
        end)

        cancelButton.MouseButton1Click:Connect(function()
            -- Kick the player if they don't want to purchase
            player:Kick(KICK_MESSAGE)
        end)

        -- Handle Game Pass purchase response
        MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(userId, passId, wasPurchased)
            if userId == player.UserId and passId == GAME_PASS_ID then
                if wasPurchased then
                    removeBlurAndUI()
                else
                    -- Do nothing, the UI remains as is
                end
            end
        end)
    end
end

-- Initialize on player join
checkGamePass()
