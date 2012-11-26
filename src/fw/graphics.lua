--- Graphics related classes and utilities

local M = {}

M.Atlas = require "fw.graphics.Atlas"
M.Sprite = require "fw.graphics.Sprite"
M.TileMap = require "fw.graphics.TileMap"

--- Creates a new @{fw.graphics.Atlas|Atlas} instance
-- @tparam number imageWidth Width of target image
-- @tparam number imageHeight Height of target image
-- @tparam number countX Number of horizontal tiles
-- @tparam number countY Number of vertical tiles
-- @tparam table o (optional) Table to create instance from
-- @treturn fw.graphics.Atlas New instance
function M.newAtlas(imageWidth, imageHeight, countX, countY, o)
   return M.Atlas.new(imageWidth, imageHeight, countX, countY, o)
end

--- Creates a new @{fw.graphics.Sprite|Sprite} instance
-- @tparam fw.graphics.Atlas atlas Atlas to use as animation source
-- @tparam table o (optional) Table to create instance from
-- @treturn fw.graphics.Sprite New instance
function M.newSprite(atlas, o)
   return M.Sprite.new(atlas, o)
end

--- Returns a function that creates new @{fw.graphics.Sprite|Sprites} with
-- the specified @{fw.graphics.Atlas|Atlas}.
-- @tparam fw.graphics.Atlas atlas The atlas parameter for the new Sprite
-- @treturn function A factory function
function M.makeSpriteFactory(atlas)
   return function()
      return M.newSprite(atlas)
   end
end

--- Creates a @{fw.graphics.TileMap|TileMap} instance
-- @tparam fw.graphics.Atlas atlas The texture atlas to use as tile source
-- @tparam love.graphics.Image image The image to use for drawing
-- @tparam number width The width of the tile map
-- @tparam number height The height of the tile map
-- @tparam table o (optional) Table to create instance from
-- @treturn fw.graphics.TileMap New instance
function M.newTileMap(atlas, image, width, height, o)
   return M.TileMap.new(atlas, image, width, height, o)
end

return M
