local fw = require "fw.init"
local loader = require "loader"

local Storyscreen = fw.gamestate.newState()

function Storyscreen.new(assets, o)

   o = o or {}

   setmetatable(o,Storyscreen)
   Storyscreen.__index = Storyscreen

   o.assets = assets
   o.zdown = false

   return o

end

function Storyscreen:getOffset()
   return -320, 0
end

function Storyscreen:update(elapsed)

   if love.keyboard.isDown("z") then
      self.zdown = true
   elseif self.zdown then
      return loader.loadMap("level1", self.assets)
   end

end

function Storyscreen:draw(alpha)

end

return Storyscreen
