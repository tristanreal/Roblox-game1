-- Configuration
local GAME_PASS_ID = 981695332 -- Replace with your actual Game Pass ID
local KICK_MESSAGE = "Error: You must buy the Beta Testing Game Pass to continue!"
local MAX_BLUR_SIZE = 100 -- Makes the screen completely blurred

-- Services
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local player = Players.LocalPlayer

-- Create and apply blur effect
local blur = Instance.new("BlurEffect")
blur.Name = "GameBlur"
blur.Size = MAX_BLUR_SIZE
blur.Parent = game.Lighting

-- Disable player controls
local function disablePlayerControls()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")

    humanoid.WalkSpeed = 0
    humanoid.JumpPower = 0

    -- Prevent chat
    player.Chatted:Connect(function()
        player:Kick(KICK_MESSAGE)
    end)
end

-- Function to check if the player owns the Game Pass
local function hasGamePass()
    local success, hasPass = pcall(function()
        return MarketplaceService:UserOwnsGamePassAsync(player.UserId, GAME_PASS_ID)
    end)
    return success and hasPass
end

-- Show Game Pass purchase popup
local function promptPurchase()
    MarketplaceService:PromptGamePassPurchase(player, GAME_PASS_ID)

    -- Handle purchase response
    MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(userId, passId, wasPurchased)
        if userId == player.UserId and passId == GAME_PASS_ID then
            if wasPurchased then
                -- Remove blur and enable controls
                blur:Destroy()
                local character = player.Character or player.CharacterAdded:Wait()
                local humanoid = character:WaitForChild("Humanoid")
                humanoid.WalkSpeed = 16
                humanoid.JumpPower = 50
            else
                -- Show prompt again if canceled
                promptPurchase()
            end
        end
    end)
end

-- Main logic
local function checkGamePassOnJoin()
    if hasGamePass() then
        -- Player owns the Game Pass, remove restrictions
        blur:Destroy()
    else
        -- Player does not own the Game Pass
        disablePlayerControls()
        promptPurchase()
    end
end

-- Ensure purchase requirements are always enforced
player.CharacterAdded:Connect(function()
    if not hasGamePass() then
        player:Kick(KICK_MESSAGE) -- Kick if bypassing the initial check
    end
end)

-- Initial check
checkGamePassOnJoin()
