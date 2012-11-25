local math = require "math"

local M = {}

M.Sprite = {}

function M.Sprite:new(atlas, o)

   assert(atlas, "Parameter atlas cannot be nil!")

   o = o or {}
   setmetatable(o,self)
   self.__index = self

   o.atlas = atlas
   o:setAnim("default")

   local tileW, tileH = atlas:getTileSize()

   o.originX = tileW / 2
   o.originY = tileH / 2

   return o

end

function M.Sprite:setAnim(id)
   self.counter = 0
   self.current = 1
   self.currentSeq = self.atlas:getSeq(id)
end

function M.Sprite:update(e)

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

function M.Sprite:draw(batch, x,  y, r, s)
   local q = self.currentSeq[self.current]
   return batch:addq(q, x, y, r, s, s, self.originX, self.originY, 0, 0)
end

function M.makeSpriteFactory(atlas)
   return function()
      return M.Sprite:new(atlas)
   end
end

return M
