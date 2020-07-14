--todo
--add collision detection //
--add actual collision
---add gravity
--add platforms
--add camera movement
--add progression
-- make window resizable 
function decelerate(vel,time)
    local friction = 1200
    if vel > 3 then
        return vel - time * friction
    elseif vel < -3 then
        return vel + time * friction
    else
        return 0
    end
end


function isColliding(x,y,w,h,cx,cy,cw,ch)
    if x > cx and x < cx+cw 
    and y > cy and y < cy+ch
    or x+w > cx and x+w < cx+cw
    and y+h > cy and y+h < cy+ch then return true end
    return false
end

function resolveCollision(px,py,pw,ph,pxv,pyv,cx,cy,cw,ch)
    --fix corners
        --todo optimize collision
    --todo split collision into new file
    updatedPlayer = {x=px,y=py,xv=playerXV,yv=playerYV}
    local newX = px+pxv
    local newY = py+pyv

    local function isCollidingOffset(oX,oY)
        return isColliding(px+oX,py+oY,pw,ph,cx,cy,cw,ch)
    end
    updatedPlayer.x = newX
    updatedPlayer.y = newY

    --determine side 1U 2D 3L 4R
    local side=0
    if px+pw > cx and px < cx+cw then
        if pyv > 0 then
            side=1
        else
            side=2
        end
    elseif py+ph > cy and py < cy+ch then
        if pxv > 0 then
            side=4
        else
            side=3
        end
    end

    if isColliding(newX,newY,pw,ph,cx,cy,cw,ch) then
        print("colliding")
        if side == 4 then
            updatedPlayer.x = cx - pw
            updatedPlayer.xv = 0
        elseif side == 3 then
            updatedPlayer.x = cx + cw
            updatedPlayer.xv = 0
        elseif side == 2 then
            updatedPlayer.y = cy + ch
            updatedPlayer.yv = 0
        else
            updatedPlayer.y = cy - ph
            updatedPlayer.yv = 0
        end
    end
    return updatedPlayer
end

function positionPlayer(pos)
    playerX = pos.x
    playerY = pos.y
    playerXV = pos.xv
    playerYV = pos.yv
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

    if not moving then
        playerYV = decelerate(playerYV,time)
        playerXV = decelerate(playerXV,time) 
    end

    positionPlayer(resolveCollision(playerX,playerY,10,10,time*playerXV,time*playerYV,50,50,200,200))
end

function love.draw()
    local screenW = love.graphics.getWidth()
    local screenH = love.graphics.getHeight()

    love.graphics.translate(screenW / 2,screenH / 2)
    love.graphics.scale(1,-1)
    love.graphics.print("Hello World", 400, 300)
    love.graphics.rectangle("fill",playerX,playerY,10,10)

    love.graphics.rectangle("fill",50,50,200,200)
end