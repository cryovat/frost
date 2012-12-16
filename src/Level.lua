local fw = require "fw.init"

local Level = fw.gamestate.newState()

local tileW, tileH, tileWo2, tileHo2  = 16, 16, 8, 8

local function areOverlapping(e1, e2)

   local e1x, e1y = e1:getPosition()
   local e2x, e2y = e2:getPosition()

   e1x = e1x - tileWo2
   e1y = e1y - tileHo2

   e2x = e2x - tileWo2
   e2y = e2y - tileHo2

   return
      e1x < e2x + tileW and
      e1x + tileW > e2x and
      e1y < e2y + tileH and
      e1y + tileH > e2y

end

function Level.normalize(posX, posY)
   local mx, my = posX % tileW, posY % tileH
   return math.floor((posX - mx) / tileW), math.floor((posY - my) / tileH)
end

function Level.convertGridCoords(x, y)
   return x * tileW + tileWo2, y * tileH + tileHo2
end

function Level.new(bg, properties, sprite_image, playerMaker)

   o = o or {}
   o.bg = assert(bg, "Background tilemap must be provided!")
   o.blocked = {}
   o.exits = {}
   o.debug = false
   o.firstEntity = nil
   o.batch = love.graphics.newSpriteBatch(sprite_image, 100)
   o.properties = properties or {}
   o.nextLevelFactory = false
   o.spawn = { x = tileW; y = 0}
   o.playerMaker = playerMaker
   o.respawnCounter = false

   o.minX = 0
   o.maxX = tileW * bg:getWidth()
   o.minY = 0
   o.maxY = tileH * bg:getHeight()

   for i=1, bg:getSize() do
      o.blocked[i] = false
      o.exits[i] = false
   end

   print("Size: " .. bg:getSize())

   setmetatable(o,Level)
   Level.__index = Level

   return o

end

function Level:replaceLevel(nextFactory)
   self.nextLevelFactory = nextFactory
end

function Level:addEntity(e)

   print(e)

   local en = assert(e, "Entity cannot be nil!")

   en.level_next = self.firstEntity

   self.firstEntity = en

   print("Added", en:getType(), en, "Next:",  en.level_next)

end

function Level:hasEntityOfType(t)

   local e = self.firstEntity

   while e do
      if e:getType() == t then
	 return true
      end

      e = e.level_next
   end

   return false

end

function Level:respawnPlayer()

   local player = self.playerMaker(self, self.spawn.x, self.spawn.y)

   self:addEntity(player)
   player:init()

end

function Level:scheduleRespawnPlayer(delay)

   self.respawnCounter = delay

end

function Level:getPlayerSpawn()

   return self.spawn.x, self.spawn.y

end

function Level:setPlayerSpawn(x,y)

   self.spawn.x, self.spawn.y = x, y

end

function Level:toggleDebug(enabled)
   self.debug = enabled
end

function Level:clampPos(oldX, oldY, reqX, reqY)

   if reqX + tileWo2 > self.maxX or reqX - tileWo2 < self.minX then
      reqX = oldX
   elseif reqX > oldX or reqX < oldX then
      local width = tileWo2

      if reqX < oldX then
	 width = width * -1
      end

      local ox, oy = Level.normalize(oldX + width, oldY)
      local nx, ny = Level.normalize(reqX + width, reqY)

      if ox ~= nx and self:isBlocked(nx, ny) then
	 reqX = oldX
      end
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

function Level:setNext(name, spawn)

end

function Level:toggleBlocked(x, y, blocked)
   self.blocked[(y * self.bg:getWidth() + x) + 1] = blocked
end

function Level:isBlocked(x, y)
   return self.blocked[(y * self.bg:getWidth() + x) + 1]
end

function Level:isOnFloor(x, y)

   x, y = Level.normalize(x, y)

   return self:isBlocked(x, y + 1) and not self:isBlocked(x, y)

end

function Level:addExit(x, y, direction)
   self.exits[(y * self.bg:getWidth() + x) + 1] = direction
end

function Level:getExit(posX, posY)
   local x, y = self.normalize(posX, posY)

   return self.exits[(y * self.bg:getWidth() + x) + 1]
end

function Level:findExitCoords(exit)

   for i=1,#self.exits do
      for x = 0,(self.bg:getWidth() - 1) do
	 for y = 0,(self.bg:getHeight() - 1) do
	    local maybeE = self.exits[(y * self.bg:getWidth() + x) + 1]

	    if maybeE == exit then
	       return x, y
	    end
	 end
      end
   end

   return nil

end

function Level:init()

   local current = self.firstEntity

   while current do
      current:init()

      current = current.level_next
   end

end

function Level:update(e)

   if self.nextLevelFactory then
      return self.nextLevelFactory()
   end

   if self.respawnCounter then
      self.respawnCounter = self.respawnCounter - e

      if self.respawnCounter <= 0 then
	 self:respawnPlayer()
	 self.respawnCounter = false
      end
   end

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
	 print("Deleting")
	 if self.firstEntity == current then
	    self.firstEntity = current.level_next
	    current = current.level_next
	 elseif last then
	    last.level_next = current.level_next
	    current = current.level_next
	 end
      end
   end

   current = self.firstEntity

   while current do
      if current:isTouchyFeely() then

	 local other = self.firstEntity

	 while other do
	    if other ~= current and other:isFondlable() then
	       if areOverlapping(current, other) then
		  current:fondle(other)
	       end
	    end

	    other = other.level_next
	 end

      end

      current = current.level_next
   end

end

function Level:draw(alpha)

   local batch,bg,w,h,e = self.batch, self.bg, 0,0, nil

   w,h = self.bg:getTileSize()

   bg:draw()

   e = self.firstEntity

   batch:clear()

   while e do
      if e:isVisible() then
	 e:draw(batch)
      end

      e = e.level_next
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

      e = self.firstEntity

      while e do
	 local x, y = e:getPosition()

	 love.graphics.rectangle("fill", x - tileWo2, y - tileHo2, tileW, tileH)

	 e = e.level_next
      end

      love.graphics.setColor(255,255,255,255)

   end

end

return Level
