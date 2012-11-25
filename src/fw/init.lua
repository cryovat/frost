local M = {}

--M.entity = require("fw.entity")
M.Atlas = require "fw.Atlas"
M.Sprite = require "fw.Sprite"
M.Options = require "fw.Options"
M.State = require "fw.State"
M.TransitionState = require "fw.TransitionState"
M.menu = require "fw.menu"

function M.makeSpriteFactory(atlas)
   return function()
      return M.Sprite:new(atlas)
   end
end

function M.newAtlas(imageWidth, imageHeight, countX, countY, o)
   return M.Atlas.new(imageWidth, imageHeight, countX, countY, o)
end

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

function M.newOptions(o)
   return M.Options.new(o)
end

function M.newSprite(atlas, o)
   return M.Sprite.new(atlas, o)
end

--- Wrapper for TransitionState constructor
-- @param old The old state to transition away from (can be null)
-- @param new The new state to transition into (cannot be null!)
-- @param duration (optional) Transition time in seconds
function M.transition(old, new, duration)
   return M.TransitionState.new(old, new, duration)
end

--- Wrapper for TransitionState constructor with nil as old state
-- @param s The state to transition into
-- @param duration (optional) Transition time in seconds
function M.fadeIn(s, duration)
   return M.TransitionState.new(nil, s, duration)
end


function M.loadLevel(file)

   local f, level = require(file), nil

   assert(type(f) == "table" and type(f["new"]) == "function",
	  "Expected '" .. file .. "' to return a State 'class'")

   level = f:new()
   level:load()

   return level

end

return M
