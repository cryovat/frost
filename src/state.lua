--- Contains the State and TransitionState types

math = require "math"

local M = {}

M.State = {}

---State constructor
-- @param o (optional) Table to use as base
function M.State:new(o)
   o = o or {}
   setmetatable(o,self)
   self.__index = self
   return o
end

--- Called when the state should update its data
-- @param elapsed Time since last update as decimal
function M.State:update(elapsed)
end

--- Called when the state level should draw itself
-- @param alpha Alpha value to use for drawing
function M.State:draw(alpha)
end

--- Forwarded love.mousepressed
-- See: https://love2d.org/wiki/love.mousepressed
function M.State:mousepressed(x,y,button)
end

--- Forwarded love.mousereleased
-- See: https://love2d.org/wiki/love.mousereleased
function M.State:mousereleased(x,y,button)
end

--- Forwarded love.keypressed
-- See: https://love2d.org/wiki/love.keypressed
function M.State:keypressed(key, unicode)
end

--- Forwarded love.keyreleased
-- See: https://love2d.org/wiki/love.keyreleased
function M.State:keyreleased(key, unicode)
end

--- Forwarded love.focus
-- See: https://love2d.org/wiki/love.focus
function M.State:focus(f)
end

M.TransitionState = M.State:new()


--- TransitionState constructor
-- @param old The old state to transition away from (can be null)
-- @param new The new state to transition into (cannot be null!)
-- @param duration (optional) Transition time in seconds
-- @param o (optional) Table to use as base
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

--- Wrapper for TransitionState constructor
-- @param old The old state to transition away from (can be null)
-- @param new The new state to transition into (cannot be null!)
-- @param duration (optional) Transition time in seconds
function M.transition(old, new, duration)
   return M.TransitionState:new(old, new, duration)
end

--- Wrapper for TransitionState constructor with nil as old state
-- @param s The state to transition into
-- @param duration (optional) Transition time in seconds
function M.fadeIn(s, duration)
   local x = M.TransitionState:new(nil, s, duration)
   return x
end

return M
