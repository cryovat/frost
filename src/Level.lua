local fw = require "fw.init"

local Level = fw.gamestate.newState()

local tileW, tileH, tileWo2, tileHo2  = 16, 16, 8, 8

function Level.new(bg, sprite_image, o)

   o = o or {}
   o.bg = assert(bg, "Background tilemap must be provided!")
   o.blocked = {}
   o.debug = true
   o.firstEntity = nil
   o.batch = love.graphics.newSpriteBatch(sprite_image, 100)

   local tileW, tileH = bg:getTileSize()

   o.minX = 0
   o.maxX = tileW * bg:getWidth()
   o.minY = 0
   o.maxY = tileH * bg:getHeight()

   for i=1, bg:getSize() do
      o.blocked[i] = false
   end

   print("Size: " .. bg:getSize())

   setmetatable(o,Level)
   Level.__index = Level

   return o

end

function Level:addEntity(e)

   local en = assert(e, "Entity cannot be nil!")

   en.level_next = self.firstEntity

   self.firstEntity = en

end

function Level:toggleDebug(enabled)
   self.debug = enabled
end

function Level:isOnFloor(x, y)

   local m = y % tileH

end

function Level:clampPos(oldX, oldY, reqX, reqY)

--   local modX, modY = reqX % tileW, reqY % tileH
--   local bx, by
--      = math.floor((reqX - modX) / tileW), math.floor((reqY - modY) / tileH)

--   print(reqX, reqY, modX, modY, bx, by)

   if reqX + tileWo2 > self.maxX or reqX - tileWo2 < self.minX then
      -- The X position would go outside legal X bounds
      reqX = oldX
   elseif reqX > oldX then

   elseif reqX < oldX then

   end

   if reqY + tileHo2 < self.minY or reqY > self.maxY then
      reqY = oldY
   elseif reqY > oldY then
      local botY = reqY + tileHo2

      local modX = reqX % tileW
      local modY = botY % tileH

      local bx,by =
	 math.floor((reqX - modX) / tileW), math.floor((botY - modY) / tileH)

      if self:isBlocked(bx, by) then
	 reqY = (by * tileH) - tileHo2
      end
   end

   return reqX, reqY

end

function Level:toggleBlocked(x, y, blocked)
   self.blocked[(y * self.bg:getWidth() + x) + 1] = blocked
end

function Level:isBlocked(x, y)
   return self.blocked[(y * self.bg:getWidth() + x) + 1]
end

function Level:update(e)

   local last,current = nil,self.firstEntity

   while current do

      local oldX, oldY = current:getPosition()
      local keep, reqX, reqY = current:update(e)

      if current:isSolid() then
	 current:setPosition(self:clampPos(oldX, oldY, reqX, reqY))
      else
	 current:setPosition(reqX, reqY)
      end

      if keep then
	 last = current
	 current = current.level_next
      else
	 if self.firstEntity == current then
	    self.firstEntity = current.level_next
	 elseif last then
	    last.level_next = current.level_next
	    current = current.level_next
	 end
      end
   end

end

function Level:draw(alpha)

   local batch,bg,w,h,e = self.batch, self.bg, 0,0, nil

   w,h = self.bg:getTileSize()

   bg:draw()

   e = self.firstEntity

   batch:clear()

   while e do
      e:draw(batch)

      e = level_next
   end

   love.graphics.draw(batch)

   if self.debug then

      love.graphics.setColor(255,0,0,100)

      for x = 0,(bg:getWidth() - 1) do
	 for y = 0,(bg:getHeight() - 1) do
	    if self:isBlocked(x, y) then
	       love.graphics.rectangle("fill", x * w, y * h, w, h)
	    end
	 end
      end

      local e = self.firstEntity

      while e do
	 local x, y = e:getPosition()

	 love.graphics.rectangle("fill", x - tileWo2, y - tileHo2, tileW, tileH)

	 e = e.level_next
      end

      love.graphics.setColor(255,255,255,255)

   end

end

return Level
