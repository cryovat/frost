--- Class for representing and drawing tile map

local TileMap = {}

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

--- Gets the size of a single tile within the tilemap
-- @treturn number Width of tile in pixels
-- @treturn number Height of tile in pixels
function TileMap:getTileSize()
   return self.atlas:getTileSize()
end

--- Gets the width of the TileMap
-- @treturn number Width in number of tiles
function TileMap:getWidth()
   return self.width
end

--- Gets the height of the Tilemap
-- @treturn number Height in number of tiles
function TileMap:getHeight()
   return self.height
end

--- Gets the size of the TileMap
-- @treturn number The number of tiles (x * y)
function TileMap:getSize()

   return #self.data

end

--- Sets the tile data, starting at the first tile. The function expects
-- a flat list with the ids row by row, and assumes that the row width
-- is the same as the one the TileMap was initialized with. If the data
-- exceeds the capacity of the tile map, it will be cropped.
-- @tparam {number,...} ... The sequence of tile ids.
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
-- @tparam number e Elapsed time in seconds since last update
function TileMap:update(e)


end

--- Draws the tilemap
function TileMap:draw()

   love.graphics.draw(self.batch)

end


return TileMap
