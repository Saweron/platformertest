function love.load()
    x = require("functions.hello")
    print(x.returnathing())
end

function love.draw()
    love.graphics.print("Hello World", 400, 300)
end