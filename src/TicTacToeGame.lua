-- dependent functions with independent interface
local DI = {}

function DI.fif(condition, if_true, if_false)
    if condition then return if_true else return if_false end
end

function DI.printDict(arg, name)
    if name then
        print(name .. ": ")
    end
    for key, val in pairs(arg) do
        print(key, val)
    end
    print()
end

function DI.setUpRandom()
    love.math.setRandomSeed(love.timer.getTime())
end

function DI.random()
    return love.math.random()
end

function DI.randomInt(l, r)
    return love.math.random(l, r)
end

function DI.loadAll(loveVersion)
    DI.loveVersion = loveVersion
    DI.printDict(loveVersion, "loveVersion")
    DI.font = love.graphics.newFont(24)
    DI.setUpRandom()
end

function DI.color2Rgb(color)
    local colors = {
        black = {0, 0, 0},
        white = {1, 1, 1},
        gray = {0.5, 0.5, 0.5},
        red = {1, 0, 0},
        green = {0, 1, 0},
        blue = {0, 0, 1},
        pink = {255 / 255, 192 / 255, 203 / 255}
    }
    local res
    if colors[color] then
        res = colors[color]
    else
        res = color
    end
    if DI.loveVersion.major < 11 then
        for i = 1, #res do
            res[i] = res[i] * 255
        end
    end
    return res
end

function DI.drawRect(x1, y1, x2, y2, colorf, coloro)
    local r, g, b, a = love.graphics.getColor()
    
    local w = x2 - x1
    local h = y2 - y1
    love.graphics.setColor(DI.color2Rgb(colorf))
    love.graphics.rectangle("fill", x1, y1, w, h)
    if coloro then
        love.graphics.setColor(DI.color2Rgb(coloro))
        love.graphics.rectangle("line", x1, y1, w, h)
    end
    
    love.graphics.setColor(r, g, b, a)
end

function DI.drawRectSz(x, y, w, h, colorf, coloro)
    local r, g, b, a = love.graphics.getColor()
    
    love.graphics.setColor(DI.color2Rgb(colorf))
    love.graphics.rectangle("fill", x, y, w, h)
    if coloro then
        love.graphics.setColor(DI.color2Rgb(coloro))
        love.graphics.rectangle("line", x, y, w, h)
    end
    
    love.graphics.setColor(r, g, b, a)
end

function DI.drawCircleByRect(x, y, w, h, colorf, coloro)
    local r, g, b, a = love.graphics.getColor()
    
    local xc = x + w / 2
    local yc = y + h / 2
    local xr = w / 2
    local yr = h / 2
    love.graphics.setColor(DI.color2Rgb(colorf))
    love.graphics.ellipse("fill", xc, yc, xr, yr)
    if coloro then
        love.graphics.setColor(DI.color2Rgb(coloro))
        love.graphics.ellipse("line", xc, yc, xr, yr)
    end
    
    love.graphics.setColor(r, g, b, a)
end

function DI.drawLine(x1, y1, x2, y2, color)
    local r, g, b, a = love.graphics.getColor()
    
    love.graphics.setColor(DI.color2Rgb(color))
    love.graphics.line(x1, y1, x2, y2)
    
    love.graphics.setColor(r, g, b, a)
end

function DI.drawText(x, y, w, str, color)
    local r, g, b, a = love.graphics.getColor()
    local font = love.graphics.getFont()
    
    love.graphics.setColor(DI.color2Rgb(color))
    love.graphics.setFont(DI.font)
    love.graphics.printf(str, x, y, w, "center")
    
    love.graphics.setFont(font)
    love.graphics.setColor(r, g, b, a)
end





-- directly module
local TicTacToeGame = {}

local WC = 3
local HC = 3
local D = 3
    
function TicTacToeGame.new(mode, bot, loveVersion)
    local self = {}
    setmetatable(self, {__index = TicTacToeGame})
    
    DI.loadAll(loveVersion)
    
    self:setGeometry(0, 0, 0, 0)
    
    self.mode = mode
    self.bot = bot
    
    self:restart()
    
    return self
end

function TicTacToeGame:setGeometry(x, y, w, h)
    self.x = x
    self.y = y
    self.w = w
    self.h = h
end

function TicTacToeGame:draw()
    self:drawField()
    self:drawSigns()
    self:drawUi()
end

function TicTacToeGame:drawField()
    --DI.drawRectSz(self.x, self.y, self.w, self.h, "gray", "pink")
    local cellw = self.w / WC
    local cellh = self.h / HC
    for i = 0, WC - 1 do
        for j = 0, HC - 1 do
            DI.drawRectSz(self.x + cellw * i, self.y + cellh * j, cellw, cellh, "gray", "pink")
        end
    end
end

function TicTacToeGame:drawSigns()
    local cellw = self.w / WC
    local cellh = self.h / HC
    for i = 0, WC - 1 do
        for j = 0, HC - 1 do
            if self.sign[i][j] == 'X' then
                self:drawX(self.x + cellw * i, self.y + cellh * j, cellw, cellh)
            elseif self.sign[i][j] == 'O' then
                self:drawO(self.x + cellw * i, self.y + cellh * j, cellw, cellh)
            elseif self.sign[i][j] == '-' then
            else
                self:drawWTF(self.x + cellw * i, self.y + cellh * j, cellw, cellh)
            end
        end
    end
end

function TicTacToeGame:drawX(x, y, w, h)
    DI.drawLine(x, y, x + w, y + h, "black")
    DI.drawLine(x + w, y, x, y + h, "black")
end

function TicTacToeGame:drawO(x, y, w, h)
    DI.drawCircleByRect(x, y, w, h, "white")
end

function TicTacToeGame:drawWTF(x, y, w, h)
    local xoffset = w * 0.2
    local yoffset = h * 0.2
    local x1 = x + xoffset
    local y1 = y + yoffset
    local x2 = x + w - xoffset
    local y2 = y + h - yoffset
    DI.drawRect(x1, y1, x2, y2, "red")
end

function TicTacToeGame:drawUi()
    if self.winner == 'X' or self.winner == 'O' then
        DI.drawText(self.x, self.y, self.w, self.winner .. " wins!", "blue")
    elseif self.winner == '?' then
        DI.drawText(self.x, self.y, self.w, "Draw!", "blue")
    end
end

function TicTacToeGame:isMouseInArea(x, y)
    return x >= self.x and y >= self.y and x < self.x + self.w and y < self.y + self.h
end

function TicTacToeGame:restart()
    self.sign = {}
    for i = 0, WC - 1 do
        self.sign[i] = {}
        for j = 0, HC - 1 do
            self.sign[i][j] = '-'
        end
    end
    self.stepInd = 0
    self.winner = '-'
    if self.mode == "evp" then
        self:doAiStep()
    end
end

function TicTacToeGame:doAiStepRandom()
    local seli = DI.randomInt(0, WC - 1)
    local selj = DI.randomInt(0, HC - 1)
    while self.sign[seli][selj] ~= '-' do
        seli = DI.randomInt(0, WC - 1)
        selj = DI.randomInt(0, HC - 1)
    end
    return seli, selj
end

function TicTacToeGame:doAiStepFull_minimax(i)
    local res = self:func(self:checkEnd())
    if res ~= -1 then
        return res
    end
    local op = DI.fif(i % 2 == 0, 100, -100)
    local xa, ya
    for x = 0, WC - 1 do
        for y = 0, HC - 1 do
            if self.sign[x][y] == '-' then
                if i % 2 == 0 then
                    self.sign[x][y] = 'X'
                    local res, xx, yy = self:doAiStepFull_minimax(i + 1)
                    if res < op then
                        op = res
                        xa = x
                        ya = y
                    end
                else
                    self.sign[x][y] = 'O'
                    local res, xx, yy = self:doAiStepFull_minimax(i + 1)
                    if res > op then
                        op = res
                        xa = x
                        ya = y
                    end
                end
                self.sign[x][y] = '-'
            end
        end
    end
    return op, xa, ya
end

function TicTacToeGame:doAiStepFull()
    local modei
    if self.mode == "pve" then
        modei = 1
    elseif self.mode == "evp" then
        modei = 0
    end
    local op, xa, ya = self:doAiStepFull_minimax(modei)
    return xa, ya
end

function TicTacToeGame:doAiStep()
    local seli, selj
    if self.bot == "random" then
        seli, selj = self:doAiStepRandom()
    elseif self.bot == "full" then
        seli, selj = self:doAiStepFull()
    end
    self:doCurrentStep(seli, selj)
end

function TicTacToeGame:doCurrentStep(seli, selj)
    self.sign[seli][selj] = DI.fif(self.stepInd % 2 == 0, 'X', 'O')
    self.stepInd = self.stepInd + 1
    self:updWinner(self:checkEnd(seli, selj))
end

function TicTacToeGame:doPlayerStep(seli, selj)
    self:doCurrentStep(seli, selj)
    if self.winner == '-' and (self.mode == "pve" or self.mode == "evp") then
        self:doAiStep()
    end
end

function TicTacToeGame:mousereleased(x, y, button, istouch, presses)
    if not self:isMouseInArea(x, y) then
        return
    end
    if self.winner == '-' then
        if button == 1 and (self.mode == "pvp" or self.mode == "pve"
            and self.stepInd % 2 == 0 or self.mode == "evp" and self.stepInd % 2 == 1) then
            local cellw = self.w / WC
            local cellh = self.h / HC
            local seli = math.floor((x - self.x) / cellw)
            local selj = math.floor((y - self.y) / cellh)
            if self.sign[seli][selj] == '-' then
                self:doPlayerStep(seli, selj)
            end
        elseif button == 2 then
            self:restart()
        end
    else
        if button == 2 then
            self:restart()
        end
    end
end

function TicTacToeGame:getWinnerByCnt(cntX, cntO)
    if cntX == D then
        return 'X'
    elseif cntO == D then
        return 'O'
    end
    return '-'
end

function TicTacToeGame:func(c)
    if c == 'X' then
        return 0
    elseif c == 'O' then
        return 2
    elseif c == '?' then
        return 1
    elseif c == '-' then
        return -1
    end
end

function TicTacToeGame:updWinner(winner)
    self.winner = winner
end

function TicTacToeGame:checkEnd(seli, selj)
    -- not yet implemented
    for i = 0, WC - 1 do
        local cntX = 0
        local cntO = 0
        for j = 0, HC - 1 do
            if self.sign[i][j] == 'X' then
                cntX = cntX + 1
            elseif self.sign[i][j] == 'O' then
                cntO = cntO + 1
            end
        end
        local c = self:getWinnerByCnt(cntX, cntO)
        if c ~= '-' then return c end
    end
    for j = 0, HC - 1 do
        local cntX = 0
        local cntO = 0
        for i = 0, WC - 1 do
            if self.sign[i][j] == 'X' then
                cntX = cntX + 1
            elseif self.sign[i][j] == 'O' then
                cntO = cntO + 1
            end
        end
        local c = self:getWinnerByCnt(cntX, cntO)
        if c ~= '-' then return c end
    end
    
    -- if the field is a square
    if WC ~= HC then
        return
    end
    
    local cntX = 0
    local cntO = 0
    for i = 0, WC - 1 do
        local j = i
        if self.sign[i][j] == 'X' then
            cntX = cntX + 1
        elseif self.sign[i][j] == 'O' then
            cntO = cntO + 1
        end
        local c = self:getWinnerByCnt(cntX, cntO)
        if c ~= '-' then return c end
    end
    local cntX = 0
    local cntO = 0
    for i = 0, WC - 1 do
        local j = WC - 1 - i
        if self.sign[i][j] == 'X' then
            cntX = cntX + 1
        elseif self.sign[i][j] == 'O' then
            cntO = cntO + 1
        end
        local c = self:getWinnerByCnt(cntX, cntO)
        if c ~= '-' then return c end
    end
    
    local cnt = 0
    for i = 0, WC - 1 do
        for j = 0, HC - 1 do
            if self.sign[i][j] == 'X' or self.sign[i][j] == 'O' then
                cnt = cnt + 1
            end
        end
    end
    if cnt == WC * HC then
        return '?'
    end
    
    return '-'
end

return TicTacToeGame
