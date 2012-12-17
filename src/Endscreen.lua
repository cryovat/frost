local fw = require "fw.init"

local Endscreen = fw.gamestate.newState()

function Endscreen.new(o)

   o = o or {}

   setmetatable(o,Endscreen)
   Endscreen.__index = Endscreen

   return o

end

function Endscreen:getOffset()
   return -320, -240
end

function Endscreen:update(elapsed)

   if love.keyboard.isDown("escape") then
      love.event.push("quit")
   end

end

function Endscreen:draw(alpha)

end

return Endscreen
