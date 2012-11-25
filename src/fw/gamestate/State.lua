--- Represents the state of the game at a given time

math = require "math"

State = {}

---State constructor
-- @param o (optional) Table to use as base
function State.new(o)
   o = o or {}
   setmetatable(o,State)
   State.__index = State
   return o
end

--- Called when the state should update its data
-- @param elapsed Time since last update as decimal
function State:update(elapsed)
end

--- Called when the state level should draw itself
-- @param alpha Alpha value to use for drawing
function State:draw(alpha)
end

--- Forwarded love.mousepressed
-- See: https://love2d.org/wiki/love.mousepressed
function State:mousepressed(x,y,button)
end

--- Forwarded love.mousereleased
-- See: https://love2d.org/wiki/love.mousereleased
function State:mousereleased(x,y,button)
end

--- Forwarded love.keypressed
-- See: https://love2d.org/wiki/love.keypressed
function State:keypressed(key, unicode)
end

--- Forwarded love.keyreleased
-- See: https://love2d.org/wiki/love.keyreleased
function State:keyreleased(key, unicode)
end

--- Forwarded love.focus
-- See: https://love2d.org/wiki/love.focus
function State:focus(f)
end

return State
