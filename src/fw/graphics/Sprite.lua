--- An animated sprite

local math = require "math"

local Sprite = {}

function Sprite.new(atlas, o)

   assert(atlas, "Parameter atlas cannot be nil!")

   o = o or {}
   setmetatable(o,Sprite)
   Sprite.__index = Sprite

   o.atlas = atlas
   o:setAnim("default")

   local tileW, tileH = atlas:getTileSize()

   o.originX = tileW / 2
   o.originY = tileH / 2

   return o

end

--- Sets the current animation
-- @param id The id of the new animation sequence
function Sprite:setAnim(id)
   self.counter = 0
   self.current = 1
   self.currentSeq = self.atlas:getSeq(id)
end

--- Updates the animation state of the sprite
-- @tparam number e Elapsed time in seconds since last update
function Sprite:update(e)

   self.counter = self.counter + e

   if self.counter > self.currentSeq.tick then

      if self.current == self.currentSeq.n then
	 self.current = 1
      else
	 self.current = self.current + 1
      end

      self.counter = 0

   end

end

--- Draws the sprite
-- @tparam love.graphics.SpriteBatch batch The SpriteBatch used for drawing
-- @tparam number x The x coordinate of the sprite center
-- @tparam number y The y coordinate of the sprite center
-- @tparam number r The rotation in radians
-- @tparam number s The scale of the sprite
function Sprite:draw(batch, x,  y, r, s)
   local q = self.currentSeq[self.current]
   return batch:addq(q, x, y, r, s, s, self.originX, self.originY, 0, 0)
end

return Sprite
