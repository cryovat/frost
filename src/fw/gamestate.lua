--- Gamestate management classes and utilities

local M = {}

M.State = require "fw.gamestate.State"
M.TransitionState = require "fw.gamestate.TransitionState"

--- Creates a blank new level
-- @treturn fw.gamestate.State New extended @{fw.gamestate.State|State} instance
function M.newLevel()

   local level = State.new()

   function level:new(o)
      o = o or {}
      setmetatable(o, level)
      self.__index = self

      return o
   end

   function level:load()
   end

   return level

end

--- Creates a new @{fw.gamestate.State|State} instance
-- @treturn fw.gamestate.State New instance
function M.newState(o)
   return M.State.new(o)
end

--- Creates a new @{fw.gamestate.TransitionState|TransitionState} instance
-- @tparam fw.gamestate.State old Old state to transition from (can be null)
-- @tparam fw.gamestate.State new New state to transition into (cannot be null!)
-- @tparam number duration (optional) Transition time in seconds
-- @treturn fw.gamestate.TransitionState New instance
function M.transition(old, new, duration)
   return M.TransitionState.new(old, new, duration)
end

--- Creates a new @{fw.gamestate.TransitionState|TransitionState} instance
-- without previous state
-- @tparam fw.gamestate.State s The state to transition into
-- @tparam number duration (optional) Transition time in seconds
-- @treturn fw.gamestate.TransitionState New instance
function M.fadeIn(s, duration)
   return M.TransitionState.new(nil, s, duration)
end

--- Loads a level from a file. The function assumes that the target
-- file returns something that conforms to the State interface and
-- contains a parameter-less function with the id "new".
-- @tparam string file The name of the file to load
-- @treturn fw.gamestate.State  New instance of State defined in target file
function M.loadLevel(file)

   local f, level = require(file), nil

   assert(type(f) == "table" and type(f["new"]) == "function",
	  "Expected '" .. file .. "' to return a State 'class'")

   level = f:new()
   level:load()

   return level

end

return M
