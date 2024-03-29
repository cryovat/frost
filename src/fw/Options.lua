--- Class for managing game options

local menu = require("fw.menu")

local Options = {}

function Options.new(o)
   o = o or {}
   setmetatable(o,Options)
   Options.__index = Options
   o.items = {}

   return o
end

--- Adds a boolean option
-- @param id The id of the option
-- @tparam string label The label to show in menus
-- @tparam boolean default The default value (true or false)
function Options:addBoolean(id, label, default)

   self.items[id] = {
      type="boolean",
      label=label,
      value = default
   }

end

--- Adds a numeric option. The user is expected to ensure that the default
-- falls into the valid range.
-- @param id The id of the option
-- @tparam string label The label to show in menus
-- @tparam number default The default value
-- @tparam number min The minimum value
-- @tparam number max The maximum value
-- @tparam number step Incremental step
function Options:addNumber(id, label, default, min, max, step)

   self.items[id] = {
      type="number",
      label=label,
      value=default,
      min=min,
      max=max,
      step=step or 1
   }

end

--- Adds an option based on a list. The user is expected to ensure that the
-- default is a member of the list
-- @param id The id of the option
-- @tparam string label The label to show in menus
-- @param default The default value
-- @param ... All valid choices
function Options:addList(id, label, default, ...)

   self.items[id] = {
      type="list",
      label=label,
      value=default,
      items=arg
   }

end


--- Gets the current value of an option
-- @param id The id of the option
-- @return The current value
function Options:get(id)

   local s = self.items[id]

   assert(s, "Setting with id '" .. id .. "' not found!")

   return self.items[id].value

end

--- Creates a State instance with user interface for manipulating the values
-- of the options.
-- @treturn fw.gamestate.State A State instance
function Options:createMenuItems()

   local menuItems, i = {}, 1

   for _, v in pairs(self.items) do
      if v.type == "list" then
	 menuItems[i] = menu.makeToggleItem(v,"value", v.label, unpack(v.items))
      elseif v.type == "number" then
	 menuItems[i] = menu.makeRangeItem(v, "value", v.label,
					   v.min, v.max, v.step)
      elseif v.type == "boolean" then
	 menuItems[i] = menu.makeBooleanItem(v, "value", v.label)
      else
	 error("Unknown menu item type!", 1)
      end

      i = i + 1
   end

   return menuItems

end

return Options
