TicTacToeGame = require("TicTacToeGame")

function updateTicTacToeGamesGeometry()
    w = width * 0.2
    h = height * 0.2
    local xoffset = width * 0.05
    local yoffset = height * 0.05
    x1 = xc - w / 2
    y1 = yc - h / 2 - yoffset - h
    x2 = xc - xoffset / 2 - w
    y2 = yc - h / 2
    x3 = xc + xoffset / 2
    y3 = yc - h / 2
    x4 = xc - xoffset / 2 - w
    y4 = yc + h / 2 + yoffset
    x5 = xc + xoffset / 2
    y5 = yc + h / 2 + yoffset
    ticTacToeGame1:setGeometry(x1, y1, w, h)
    ticTacToeGame2:setGeometry(x2, y2, w, h)
    ticTacToeGame3:setGeometry(x3, y3, w, h)
    ticTacToeGame4:setGeometry(x4, y4, w, h)
    ticTacToeGame5:setGeometry(x5, y5, w, h)
end

function love.load()
    local major, minor, revision, codename = love.getVersion()
    loveVersion = { major = major, minor = minor,
        revision = revision, codename = codename }
    
    love.window.setTitle("TicTacToeGame")
    
	width = love.graphics.getWidth()
	height = love.graphics.getHeight()
    xc = width / 2
    yc = height / 2
    
    font = love.graphics.setNewFont(16)
    
    ticTacToeGame1 = TicTacToeGame.new("pvp", "", loveVersion)
    ticTacToeGame2 = TicTacToeGame.new("pve", "random", loveVersion)
    ticTacToeGame3 = TicTacToeGame.new("evp", "random", loveVersion)
    ticTacToeGame4 = TicTacToeGame.new("pve", "full", loveVersion)
    ticTacToeGame5 = TicTacToeGame.new("evp", "full", loveVersion)
    
    updateTicTacToeGamesGeometry()
end

function love.update(dt)
	--ticTacToeGame1:update()
	--ticTacToeGame2:update()
	--ticTacToeGame3:update()
end

function love.draw()
    love.graphics.printf("Use LMB to step and RMB to restart (on the game field).", 0, 0, width, "center")
    love.graphics.printf("PVP", x1, y1 - font:getHeight(), w, "center")
    love.graphics.printf("PVE Random", x2, y2 - font:getHeight(), w, "center")
    love.graphics.printf("EVP Random", x3, y3 - font:getHeight(), w, "center")
    love.graphics.printf("PVE Full", x4, y4 - font:getHeight(), w, "center")
    love.graphics.printf("EVP Full", x5, y5 - font:getHeight(), w, "center")
	ticTacToeGame1:draw()
	ticTacToeGame2:draw()
	ticTacToeGame3:draw()
	ticTacToeGame4:draw()
	ticTacToeGame5:draw()
end

function love.mousereleased(x, y, button, istouch, presses)
    ticTacToeGame1:mousereleased(x, y, button, istouch, presses)
    ticTacToeGame2:mousereleased(x, y, button, istouch, presses)
    ticTacToeGame3:mousereleased(x, y, button, istouch, presses)
    ticTacToeGame4:mousereleased(x, y, button, istouch, presses)
    ticTacToeGame5:mousereleased(x, y, button, istouch, presses)
end

function love.resize(w, h)
	width = w
	height = h
    xc = width / 2
    yc = height / 2
    
    updateTicTacToeGamesGeometry()
end
