local Entity = {}

function Entity.new(sprite, x, y, soX, soY, o)

   o = o or {}
   setmetatable(o,Entity)
   Entity.__index = Entity

   o.x = x or 0
   o.y = y or 0
   o.soX = soX or 0
   o.soY = soY or 0
   o.sprite = assert(sprite, "Sprite cannot be nil!")

   return o

end

function Entity:getType()
   return "thing"
end

function Entity:isVisible()
   return true
end

function Entity:isSolid()
   return true
end

function Entity:isTouchyFeely()
   return false
end

function Entity:isFondlable()
   return false
end

function Entity:getRect()
   local x,y,cwo2,cho2 = self.x, self.y, self.collisionw/2, self.collisionh/2
   return x - cwo2, y - cwo2, x + cwo2, y + cwo2
end

function Entity:getPotentialRect()

end

function Entity:getPosition()
   return self.x, self.y
end

function Entity:setPosition(x,y)
   self.x, self.y = x, y
end

function Entity:setAnim(seq)
   self.sprite:setAnim(seq)
end

function Entity:fondle(other)

end

function Entity:init()

end

function Entity:behavior(elapsed)

   return true, self:getPosition()

end

function Entity:update(elapsed)
   self.sprite:update(elapsed)

   return self:behavior(elapsed)
end

function Entity:draw(batch, alpha)
   local x,y = math.floor(self.x + self.soX), math.floor(self.y + self.soY)

   self.sprite:draw(batch, x, y, 0, 1)
end







return Entity
