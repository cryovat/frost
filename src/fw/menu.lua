--- Utilities for creating in-game menus

gamestate = require "fw.gamestate"
math = require "math"

local M = {}

local function wrap(max, min, i)
   if i > max then
      return min
   elseif i < min then
      return max
   else
      return i
   end
end

local function range(min, max, step)

   assert(type(max) == "number",
	  "Parameter max must be a number!")

   assert(type(min) == "number",
	  "Parameter min must be a number!")

   assert(type(step) == "nil" or type(step) == "number",
	  "Parameter step must be nil or a number!")

   assert(min < max,
	  "Parameter min must be smaller than parameter max!")

   local idx = 1
   local result = {n=0 }

   for i=min,max,step or 1 do
      result[idx] = i
      result.n = result.n + 1
      idx = idx + 1
   end

   return result

end

--- Creates a menu item that cycles between a list of values and writes the
-- current selection to a target table.
-- @param target The target table
-- @param property The id of the item in the table to read/update
-- @param prefix The prefix of the value in the menu
-- @param ... All valid choices
-- @return A menu item
function M.makeToggleItem(target, property, prefix, ...)

   assert(target and type(target) == "table",
	  "Parameter target must be table!")

   assert(property,
	   "Parameter property cannot be nil!")

   assert(arg.n and arg.n > 0,
	  "At least one option must be provided!")

   local position = 1
   local lastLabel, lastValue = nil, nil

   local function getLabel()

      local value = arg[position]

      if lastValue == value then
	 return lastLabel
      else
	 lastValue = value

	 if value == true then
	    value = "On"
	 elseif value == false then
	    value = "Off"
	 end

	 lastLabel = prefix .. ":" .. value

	 return lastLabel
      end
   end

   local function action()
      position = wrap(arg.n, 1, position + 1)
      target[property] = arg[position]
   end

   return { getLabel, action }

end

--- Creates a menu item that cycles through a numeric range and writes the
-- current selection to a target table.
-- @param target The target table
-- @param property The id of the item in the table to read/update
-- @param prefix The prefix of the value in the menu
-- @param min The minimum value
-- @param max The maximum value
-- @param step Incremental step
-- @return A menu item
function M.makeRangeItem(target, property, prefix, min, max, step)

   return M.makeToggleItem(target, property, prefix,
			   unpack(range(min, max, step)))

end

--- Creates a menu item that toggles a boolean value and writes the
-- current selection to a target table.
-- @param target The target table
-- @param property The id of the item in the table to read/update
-- @param prefix The prefix of the value in the menu
-- @return A menu item
function M.makeBooleanItem(target, property, prefix)

   return M.makeToggleItem(target, property, prefix, true, false)

end

--- Creates a State instance that provides an interactive menu to the user
-- @param prevState (optional) The previous state. If provided, the menu will
--                  provide a "Previous" option.
-- @param ... A list of items in the menu. Use the @{makeToggleItem},
-- @{makeRangeItem} and @{makeBooleanItem} functions to construct these.
-- @return A state instance
function M.makeMenu(prevState, ...)

   local menu = gamestate.newState(
      {
	 options = { n = arg.n },
	 selected = 1,
	 counter = 0,
	 x = 0,
	 y = 0,
	 zDown = false
      })

   for i = 1, arg.n do
      local item = arg[i]

      menu.options[i] = {
	 label = item[1],
	 action = item[2]
      }
   end

   menu.x = (love.graphics.getWidth() / 2) - 100
   menu.y = (love.graphics.getHeight() / 2) - ((menu.options.n / 2) * 20)

   if prevState then
      menu.options[menu.options.n + 1] = {
	 label = "Return",
	 action = function()
	    return prevState
	 end
      }
      menu.options.n = menu.options.n + 1
   end

   function menu:update(e)
      if menu.counter > 0 then
	 menu.counter = gs.counter - e
	 elseif love.keyboard.isDown("up") then
	    menu.counter = 0.25
	    menu.selected = wrap(menu.options.n, 1, menu.selected - 1)
	 elseif love.keyboard.isDown("down") then
	    menu.counter = 0.25
	    menu.selected = wrap(menu.options.n, 1, menu.selected + 1)
	 elseif love.keyboard.isDown("z") then
	    menu.zDown = true
	 elseif menu.zDown then
	    local item = menu.options[menu.selected]
	    menu.zDown = false

	    if item.action then
	       return item.action(menu)
	    end
	 end
      end

   function menu:draw(alpha)

      for i = 1,menu.options.n do
	 local item = menu.options[i]
	 local label = item.label

	 if type(label) == "function" then
	    label = label()
	 end

	 if i == menu.selected then
	    love.graphics.setColor(0, 255, 255, alpha)
	 else
	    love.graphics.setColor(255,255,255, math.min(alpha,150))
	 end

	 love.graphics.printf(label, menu.x, menu.y + (i * 20), 200, "center")
      end
   end

   if prevState then
      return gamestate.transition(prevState, menu)
   else
      return menu
   end

end

return M
