M = {}

function M.new(imageWidth, imageHeight, countX, countY, o)

   o = o or {}
   setmetatable(o,M)
   M.__index = M

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

function M:getImageSize()
   return self.imageWidth, self.imageHeight
end

function M:getTileSize()
   return self.tileWidth, self.tileHeight
end

function M:getSeq(id)
   return self.sequences[id]
end

function M:addSeq(id, tick, ...)

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

return M
