require "math"

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

   function p.State:draw(alpha)
      return
   end

   p.TransitionState = p.State:new()

   function p.TransitionState:new(old, new, duration, o)

      if not new then
	 error("New state cannot be nil!", 2)
      end

      o = o or {}
      setmetatable(o,self)
      self.__index = self

      o.old = old
      o.new = new
      o.position = 0
      o.duration = duration or 1
      o.timer = 0

      return o
   end

   function p.TransitionState:update(elapsed)
      self.timer = self.timer + elapsed
      if self.timer > self.duration then
	 print "Done!"
	 return self.new
      end
   end

   function p.TransitionState:draw(alpha)
      local position = math.max(0, math.min(self.timer / self.duration, 1))

      if self.old then
	 local oldAlpha = math.min(math.floor((1 - position) * 255), alpha)

	 self.old:draw(oldAlpha)
      end

      local newAlpha = math.min(math.floor(position * 255), alpha)

      self.new:draw(newAlpha)
   end

   function p.transition(old, new, duration)
      return p.TransitionState:new(old, new, duration)
   end

   function p.fadeIn(s, duration)
      local x = p.TransitionState:new(nil, s, duration)
      print(x.update)
      return x
   end

   frost = frost or {}
   frost.state = p

end
