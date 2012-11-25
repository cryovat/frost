local fw = require "fw.init"

local level = fw.gamestate.newLevel()

function level:load()

   local dude, atlas, sprite, batch, map = nil, nil, nil, nil, nil

   dude = love.graphics.newImage("gfx/external/dynamiteguy.png")
   batch = love.graphics.newSpriteBatch(dude)

   atlas = fw.graphics.newAtlas(dude:getWidth(), dude:getHeight(), 4, 1)
   atlas:addSeq("boom", 1, 1,2,3,4)

   map = fw.graphics.newTileMap(atlas, dude, 10, 10)
   print(map)
   print(map.setData)
   map:setData(1,2,3,4,1,2,3,4,1,2)

   sprite = fw.graphics.newSprite(atlas)

   sprite:setAnim("boom")

   self.assets = {
      dude=dude,
      atlas=atlas,
      sprite=sprite,
      batch=batch,
      map=map
   }

end

function level:update(e)
   self.assets.sprite:update(e)
   self.assets.map:update(e)
end

function level:draw(alpha)
   local assets, batch, sprite = self.assets, nil, nil
   batch = assets.batch
   sprite = assets.sprite

   self.assets.map:draw()

   batch:clear()
   love.graphics.setColor(255,255,255,alpha)
   sprite:draw(batch, 200, 200, 0, 2)
   love.graphics.draw(batch)
end
return level
