math = require "math"

local M = {}

M.State = {}

function M.State:new(o)
   o = o or {}
   setmetatable(o,self)
   self.__index = self
   return o
end

function M.State:update(elapsed)
end

function M.State:draw(alpha)
end

function M.State:mousepressed(x,y,button)
end

function M.State:mousereleased(x,y,button)
end

function M.State:keypressed(key, unicode)
end

function M.State:keyreleased(key, unicode)
end

function M.State:focus(f)
end

M.TransitionState = M.State:new()

function M.TransitionState:new(old, new, duration, o)

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

function M.TransitionState:update(elapsed)
   self.timer = self.timer + elapsed
   if self.timer > self.duration then
      return self.new
   end
end

function M.TransitionState:draw(alpha)
   local position = math.max(0, math.min(self.timer / self.duration, 1))

   if self.old then
      local oldAlpha = math.min(math.floor((1 - position) * 255), alpha)

      self.old:draw(oldAlpha)
   end

   local newAlpha = math.min(math.floor(position * 255), alpha)

   self.new:draw(newAlpha)
end

function M.transition(old, new, duration)
   return M.TransitionState:new(old, new, duration)
end

function M.fadeIn(s, duration)
   local x = M.TransitionState:new(nil, s, duration)
   print(x.update)
   return x
end

return M
