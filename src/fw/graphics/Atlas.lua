--- Texture atlas for handling tilesets and animation sequences

Atlas = {}

function Atlas.new(imageWidth, imageHeight, countX, countY, o)

   o = o or {}
   setmetatable(o,Atlas)
   Atlas.__index = Atlas

   o.n = countX * countY
   o.imageWidth = imageWidth
   o.imageHeight = imageHeight
   o.tileWidth = imageWidth / countX
   o.tileHeight = imageHeight / countY
   o.quads = {}
   o.sequences = {}

   for x=0,(countX-1) do
      for y=0, (countY-1) do

	 o.quads[(y * countX + x) + 1] = love.graphics.newQuad(
	    o.tileWidth * x,
	    o.tileHeight * y,
	    o.tileWidth,
	    o.tileHeight,
	    imageWidth,
	    imageHeight)
      end
   end

   o:addSeq(1, 1, 1)

   return o

end

--- Gets the size of the target image
-- @treturn number Width of image in pixels
-- @treturn number Height of image in pixels
function Atlas:getImageSize()
   return self.imageWidth, self.imageHeight
end

--- Gets the size of a tile
-- @treturn number Width of tile in pixels
-- @treturn number Height of tile in pixels
function Atlas:getTileSize()
   return self.tileWidth, self.tileHeight
end

--- Gets an animation sequence
-- @param id The id of the sequence
-- @return The animation sequence (or nil if unknown)
function Atlas:getSeq(id)
   return self.sequences[id]
end

--- Adds an animation sequence
-- @param id The id of the sequence
-- @tparam number tick Time in seconds per frame
-- @tparam {number,...} ... A list of frame indices
function Atlas:addSeq(id, tick, ...)

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

--- Gets the first quad in the atlas
-- @treturn love.graphics.Quad The first quad in the atlas
function Atlas:getDefaultQuad()
   return self.quads[1]
end

--- Gets a single quad
-- @tparam number id The id of the quad
-- @treturn love.graphics.Quad A Quad, or nil if invalid id
function Atlas:getQuad(id)
   return self.quads[id]
end

return Atlas
