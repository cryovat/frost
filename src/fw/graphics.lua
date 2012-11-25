--- Graphics related classes and utilities

local M = {}

M.Atlas = require "fw.graphics.Atlas"
M.Sprite = require "fw.graphics.Sprite"
M.TileMap = require "fw.graphics.TileMap"

--- Creates a new Atlas instance
-- @param imageWidth Width of target image
-- @param imageHeight Height of target image
-- @param countX Number of horizontal tiles
-- @param countY Number of vertical tiles
-- @param o (optional) Table to create instance from
function M.newAtlas(imageWidth, imageHeight, countX, countY, o)
   return M.Atlas.new(imageWidth, imageHeight, countX, countY, o)
end

--- Creates a new Sprite instance
-- @param atlas The texture atlas to use as animation source
-- @param o (optional) Table to create instance from
function M.newSprite(atlas, o)
   return M.Sprite.new(atlas, o)
end

--- Returns a function that creates new Sprites with the specified atlas
-- @param atlas The atlas parameter for the new Sprite
function M.makeSpriteFactory(atlas)
   return function()
      return M.newSprite(atlas)
   end
end

return M
