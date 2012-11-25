--- Gamestate management classes and utilities

local M = {}

M.State = require "fw.gamestate.State"
M.TransitionState = require "fw.gamestate.TransitionState"

--- Creates a blank new level
-- @return An extended State instance
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

--- Creates a State instance
-- @return A vanilla State instance
function M.newState(o)
   return M.State.new(o)
end

--- Creates a new TransitionState
-- @param old The old state to transition away from (can be null)
-- @param new The new state to transition into (cannot be null!)
-- @param duration (optional) Transition time in seconds
function M.transition(old, new, duration)
   return M.TransitionState.new(old, new, duration)
end

--- Creates a new TransitionState without previous state
-- @param s The state to transition into
-- @param duration (optional) Transition time in seconds
function M.fadeIn(s, duration)
   return M.TransitionState.new(nil, s, duration)
end

--- Loads a level from a file. The function assumes that the target
-- file returns something that conforms to the State interface and
-- contains a parameter-less function with the id "new".
-- @param file The name of the file to load
-- @return An instance of the State defined in the target file
function M.loadLevel(file)

   local f, level = require(file), nil

   assert(type(f) == "table" and type(f["new"]) == "function",
	  "Expected '" .. file .. "' to return a State 'class'")

   level = f:new()
   level:load()

   return level

end

return M
