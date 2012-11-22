local math = require "math"

local M = {}

M.Atlas = {}

function M.Atlas:new(imageWidth, imageHeight, countX, countY, o)

   o = o or {}
   setmetatable(o,self)
   self.__index = self

   o.n = countX * countY
   o.imageWidth = imageWidth
   o.imageHeight = imageHeight
   o.tileWidth = imageWidth / countX
   o.tileHeight = imageHeight / countY
   o.quads = {}
   o.sequences = {}

   local i = 1

   for x=0,(countX-1) do
      for y=0, (countY-1) do
	 o.quads[i] = love.graphics.newQuad(
	    o.tileWidth * x,
	    o.tileHeight * y,
	    o.tileWidth,
	    o.tileHeight,
	    imageWidth,
	    imageHeight)

	 i = i + 1
      end
   end

   o:addSeq(1, 1, 1)

   return o

end

function M.Atlas:getImageSize()
   return self.imageWidth, self.imageHeight
end

function M.Atlas:getTileSize()
   return self.tileWidth, self.tileHeight
end

function M.Atlas:getSeq(id)
   return self.sequences[id]
end

function M.Atlas:addSeq(id, tick, ...)

   assert(id, "Parameter id cannot be nil!")
   assert(type(tick) == "number" and tick > 0,
	  "Parameter tick must be a number greater than zero!")

   assert(arg.n > 0, "Requires at least one frame!")

   local seq = {}
   seq.tick = tick
   seq.n = arg.n

   for i = 1, arg.n do
      seq[i] = self.quads[arg[i]]
   end

   self.sequences[id] = seq

end

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
