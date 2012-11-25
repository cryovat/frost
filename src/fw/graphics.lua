local M = {}

M.Atlas = require "fw.graphics.Atlas"
M.Sprite = require "fw.graphics.Sprite"

function M.makeSpriteFactory(atlas)
   return function()
      return M.Sprite:new(atlas)
   end
end

function M.newAtlas(imageWidth, imageHeight, countX, countY, o)
   return M.Atlas.new(imageWidth, imageHeight, countX, countY, o)
end

function M.newSprite(atlas, o)
   return M.Sprite.new(atlas, o)
end

return M
