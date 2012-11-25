local menu = require("fw.menu")

local Options = {}

function Options.new(o)
   o = o or {}
   setmetatable(o,Options)
   Options.__index = Options
   o.items = {}

   return o
end

function Options:addBoolean(id, label, default)

   self.items[id] = {
      type="boolean",
      label=label,
      value = default
   }

end

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

function Options:addList(id, label, default, ...)

   self.items[id] = {
      type="list",
      label=label,
      value=default,
      items=arg
   }

end

 function Options:get(id)

   local s = self.items[id]

   assert(s, "Setting with id '" .. id .. "' not found!")

   return self.items[id].value

end

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
