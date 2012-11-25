--- Texture atlas for handling tilesets and animation sequences

Atlas = {}

--- Creates an Atlas instance
-- @param imageWidth Width of target image
-- @param imageHeight Height of target image
-- @param countX Number of horizontal tiles
-- @param countY Number of vertical tiles
-- @param o (optional) Table to create instance from
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

--- Gets the size of the target image
-- @return Width and height in pixels
function Atlas:getImageSize()
   return self.imageWidth, self.imageHeight
end

--- Gets the size of a tile
-- @return Width and height in pixels
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
-- @param tick Time in seconds per frame
-- @param ... A list of frame indices
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
-- @return The first quad in the atlas
function Atlas:getDefaultQuad()
   return self.quads[1]
end

--- Gets a single quad
-- @param id The id of the quad
-- @return A Quad, or nil if invalid id
function Atlas:getQuad(id)
   return self.quads[id]
end

return Atlas
