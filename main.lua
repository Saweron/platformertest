function decelerate(vel,time)
    if vel > 3 then
        return vel - time * 200
    elseif vel < -3 then
        return vel + time * 200
    else
        return 0
    end
end


function love.load()
    playerX = 0 
    playerY = 0
    playerXV = 0
    playerYV = 0

    x = require("functions.hello")
    print(x.returnathing())
end

function love.update(time)
    local moving = false
    local speed = 800
    if love.keyboard.isDown("up") then
        playerYV = playerYV + time*speed
        moving = true
    end
    if love.keyboard.isDown("down") then
        playerYV = playerYV - time*speed
        moving = true
    end
    if love.keyboard.isDown("right") then
        playerXV = playerXV + time*speed
        moving = true
    end
    if love.keyboard.isDown("left") then
        playerXV = playerXV - time*speed
        moving = true
    end


    --movement
    playerX = playerX + time * playerXV
    playerY = playerY + time * playerYV

    --deceleration
    if not moving then
        playerYV = decelerate(playerYV,time)
        playerXV = decelerate(playerXV,time) 
    end
end

function love.draw()
    local screenW = love.graphics.getWidth()
    local screenH = love.graphics.getHeight()

    love.graphics.translate(screenW / 2,screenH / 2)
    love.graphics.scale(1,-1)
    love.graphics.print("Hello World", 400, 300)
    love.graphics.rectangle("fill",playerX,playerY,10,10)
end