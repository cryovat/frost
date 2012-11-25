local M = {}

M.Entity = {}

function M.Entity:new(x, y, o)

   o = o or {}
   setmetatable(o,self)
   self.__index = self

   o.x = x or 0
   o.y = y or 0
   o.speedX = 0
   o.speedY = 0
   o.rotation = 0

   return o
end

function M.Entity:update(e)

   self.x = self.x + (self.speedX * e)
   self.y = self.y + (self.speedY * e)

   if self.behavior then
      return self.behavior(self, e)
   else
      return true
   end
end

function M.Entity:draw(batch)
   if self.sprite then
      self.sprite.draw(batch, self.x, self.y, self.rotation)
   else
      error("Tried to draw an entity before assigning sprite!", 2)
   end
end

function M.Entity:getPos()
   return self.x, self.y
end

function M.Entity:setPos(x, y)
   self.x, self.y = x,y
end

function M.Entity:setSpeed(speedX,speedY)
   self.speedX, self.speedY = speedX, speedY
end

function M.Entity:getSpeed()
   return self.speedX, self.speedY
end

M.EntityManager = {}

function M.EntityManager:new(capacity, o)

   o = o or {}
   setmetatable(o,self)
   self.__index = self

   local i = capacity

   o.numFree = 0

   while i > 0 do

      local entity = M.Entity:new()

      entity.next = o.firstFree
      o.firstFree = entity

   end

end

function M.EntityManager:init(x, y, sprite, behavior)

   if self.numFree = 0 then
      error("Number of free entities in manager exhausted!", 2)
   end

   local entity = self.firstFree

   self.firstFree = entity.next

   entity.next = self.firstActive

   self.firstActive = entity

   return entity

end

function M.EntityManager:update(e)

   local current, prev = self.firstActive, nil

   while current do
      local next = current.next

      if not current.update(e) then

	 if prev then
	    prev.next = next
	 end

	 current.next = self.firstFree
	 self.firstFree = current

	 if current == self.firstActive then
	    self.firstActive = next
	 end

      end

      current = next
   end

end

function M.EntityManager:draw(batch)

   local current = self.firstActive

   while current do
      current:draw(batch)
   end

end

return M
