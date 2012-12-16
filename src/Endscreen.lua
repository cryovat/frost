local fw = require "fw.init"

local Endscreen = fw.gamestate.newState()

function Endscreen.new(o)

   o = o or {}

   setmetatable(o,Endscreen)
   Endscreen.__index = Endscreen

   return o

end

function Endscreen:update(elapsed)

   if love.keyboard.isDown("z") then
      love.event.push("quit")
   end

end

function Endscreen:draw(alpha)

   love.graphics.printf("Horray, you escaped the evil castle before the hero arrived!", 10, 10, 200, "left")
   love.graphics.printf("Press 'z' to quit", 10, 100, 200, "left")

end

return Endscreen
