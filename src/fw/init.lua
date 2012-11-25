local M = {}

--M.entity = require("fw.entity")
M.Atlas = require("fw.Atlas")
M.Sprite = require("fw.Sprite")
M.options = require("fw.options")
M.state = require("fw.state")
M.util = require("fw.util")

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
