--- A state that represents a transition between two other states

local state = require "fw.gamestate.State"

TransitionState = state.new()

function TransitionState.new(old, new, duration, o)

   if not new then
      error("New state cannot be nil!", 2)
   end

   o = o or {}
   setmetatable(o,TransitionState)
   TransitionState.__index = TransitionState

   o.old = old
   o.new = new
   o.position = 0
   o.duration = duration or 1
   o.timer = 0

   return o
end


--- Updates the transitional state
-- @tparam number elapsed Elapsed time in seconds since last update
-- @treturn fw.gamestate.State Next game state, or nil if still valid
function TransitionState:update(elapsed)
   self.timer = self.timer + elapsed
   if self.timer > self.duration then
      return self.new
   end
end

--- Draws the state
-- @tparam number alpha Alpha value used for drawing
function TransitionState:draw(alpha)
   local position = math.max(0, math.min(self.timer / self.duration, 1))

   if self.old then
      local oldAlpha = math.min(math.floor((1 - position) * 255), alpha)

      self.old:draw(oldAlpha)
   end

   local newAlpha = math.min(math.floor(position * 255), alpha)

   self.new:draw(newAlpha)
end

return TransitionState
