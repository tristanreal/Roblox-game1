local player = game.Players.LocalPlayer
local screenGui = player.PlayerGui:WaitForChild("ScreenGui")
local shopUI = screenGui:WaitForChild("Frame")
local shopButton = screenGui:WaitForChild("ImageButton")
local closeButton = shopUI:WaitForChild("TextButton")

-- Initially hide the shop UI
shopUI.Visible = false

-- Open shop UI when the button is clicked
shopButton.MouseButton1Click:Connect(function()
    shopUI.Visible = true
end)

-- Close the shop UI when the close button is clicked
closeButton.MouseButton1Click:Connect(function()
    shopUI.Visible = false
end)

-- Draggable UI functionality
local dragging = false
local dragInput, mousePos, framePos

shopUI.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragInput = input
        mousePos = input.Position
        framePos = shopUI.Position
    end
end)

shopUI.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - mousePos
        shopUI.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
    end
end)

shopUI.InputEnded:Connect(function(input)
    if input == dragInput then
        dragging = false
    end
end)
