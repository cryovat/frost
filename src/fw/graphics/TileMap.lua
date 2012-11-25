--- Class for representing and drawing tile map

local TileMap = {}

--- Creates a TileMap instance
-- @param atlas The texture atlas to use as tile source
-- @param image The image to use for drawing
-- @param width The width of the tile map
-- @param height The height of the tile map
-- @param o (optional) Table to create instance from
function TileMap.new(atlas, image, width, height, o)

   o = o or {}
   setmetatable(o,TileMap)
   TileMap.__index = TileMap

   o.atlas = atlas
   o.image = image
   o.width = width
   o.height = height

   o.batch = love.graphics.newSpriteBatch(image, width * height)
   o.data = {}

   local defaultQuad = atlas:getDefaultQuad()

   for i = 1, width * height do
      o.data[i] = defaultQuad
   end

   return o

end

function TileMap:updateBatch()

   local width, height, atlas, batch, data
      = self.width, self.height, self.atlas, self.batch, self.data

   local tileWidth, tileHeight = atlas:getTileSize()

   batch:clear()
   batch:bind()

   for x = 1, width do
      for y = 1, height do
	 local id = width * (y - 1) + x
	 local tileX = (x - 1) * tileWidth
	 local tileY = (y - 1) * tileHeight

	 batch:addq(self.data[id], tileX, tileY)
      end
   end

   batch:unbind()

end

--- Sets the tile data, starting at the first tile. The function expects
-- a flat list with the ids row by row, and assumes that the row width
-- is the same as the one the TileMap was initialized with. If the data
-- exceeds the capacity of the tile map, it will be cropped.
-- @param ... The sequence of tile ids.
function TileMap:setData(...)

   local max, data, atlas = self.width * self.height, self.data, self.atlas

   for i,v in ipairs(arg) do
      if i <= max then
	 data[i] = atlas:getQuad(v)
      end
   end

   self:updateBatch()

end

--- Updates the state of the tile map
-- @param e Elapsed time in seconds since last update
function TileMap:update(e)

end

--- Draws the tilemap
function TileMap:draw()

   love.graphics.draw(self.batch)

end


return TileMap
