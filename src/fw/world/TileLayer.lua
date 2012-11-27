--- Type for tile layers.
-- Tile layers are graphical layers containing an uniform grid of tiles
-- sourced from a single image. They serve as wrappers for the
-- @{fw.graphics.TileMap|TileMap} type, integrating them into the
-- @{fw.world.Scene|Scene} infrastructure.

local Layer = require "fw.world.Layer"
local graphics = require "fw.graphics"

local TileLayer = Layer.new()

function TileLayer.new(atlas, image, width, height, o)

   o = o or {}

   setmetatable(o, TileLayer)
   TileLayer.__index = TileLayer

   o.atlas = atlas
   o.image = image
   o.tileMap = graphics.newTileMap(atlas, image, width, height)

   return o

end

--- Sets the tile data on the internal @{fw.graphics.TileMap|TileMap}.
-- @tparam {number,...} ... The sequence of tile ids.
function TileLayer:setData(...)
   o.tileMap:setData(...)
end

function TileLayer:update(e)
   o.tileMap.update(e)
end

function TileLayer:draw()
   o.tileMap:draw()
end

return TileLayer
