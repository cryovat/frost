local fw = require "fw.init"
local u = fw.util
local s = fw.sprite

local level = u.newLevel()

function level:load()

   local dude, atlas, sprite, batch = nil, nil, nil, nil

   dude = love.graphics.newImage("gfx/external/dynamiteguy.png")
   batch = love.graphics.newSpriteBatch(dude)

   atlas = s.Atlas.new(dude:getWidth(), dude:getHeight(), 4, 1)
   atlas:addSeq("boom", 1, 1,2,3,4)

   sprite = s.Sprite:new(atlas)

   sprite:setAnim("boom")

   self.assets = {
      dude=dude,
      atlas=atlas,
      sprite=sprite,
      batch=batch
   }

end

function level:update(e)
   self.assets.sprite:update(e)
end

function level:draw(alpha)
   local assets, batch, sprite = self.assets, nil, nil
   batch = assets.batch
   sprite = assets.sprite

   batch:clear()
   love.graphics.setColor(255,255,255,alpha)
   sprite:draw(batch, 200, 200, 0, 2)
   love.graphics.draw(batch)
end
return level
