if not frost or not frost.state then

   local p = {}

   p.State = {}

   function p.State:new(o)
      o = o or {}
      setmetatable(o,self)
      self.__index = self
      return o
   end

   function p.State:update(elapsed)
      return
   end

   function p.State:draw()
      return
   end

   frost = frost or {}
   frost.state = p

end
