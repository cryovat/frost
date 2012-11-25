State = require "fw.State"
TransitionState = require "fw.TransitionState"
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

function M.range(min, max, step)

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

function M.makeRangeItem(target, property, prefix, min, max, step)

   return M.makeToggleItem(target, property, prefix,
			   unpack(M.range(min, max, step)))

end

function M.makeBooleanItem(target, property, prefix)

   return M.makeToggleItem(target, property, prefix, true, false)

end

function M.makeMenu(prevState, ...)

   local menu = State.new(
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
      return TransitionState.new(prevState, menu)
   else
      return menu
   end

end

function M.loadLevel(file)

   local f, level = require(file), nil

   assert(type(f) == "table" and type(f["new"]) == "function",
	  "Expected '" .. file .. "' to return a State 'class'")

   level = f:new()
   level:load()

   return level

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

return M
