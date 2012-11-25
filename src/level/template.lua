local fw = require "fw.init"

local level = fw.gamestate.newLevel()

-- Unused functions can be safely removed below

function level:load()
end

function level:update(elapsed)
end

function level:draw(alpha)
end

function level:mousepressed(x,y,button)
end

function level:mousereleased(x,y,button)
end

function level:keypressed(key, unicode)
end

function level:keyreleased(key, unicode)
end

function level:focus(f)
end

-- But don't remove the next line! :D

return level
