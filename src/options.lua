local util = require("util")

local M = {}

M.Options = {}

function M.Options:new(o)
   o = o or {}
   setmetatable(o,self)
   self.__index = self
   self.items = {}

   return o
end

function M.Options:addBoolean(id, label, default)

   self.items[id] = {
      type="boolean",
      label=label,
      value = default
   }

end

function M.Options:addNumber(id, label, default, min, max, step)

   self.items[id] = {
      type="number",
      label=label,
      value=default,
      min=min,
      max=max,
      step=step or 1
   }

end

function M.Options:addList(id, label, default, ...)

   self.items[id] = {
      type="list",
      label=label,
      value=default,
      items=arg
   }

end

 function M.Options:get(id)

   local s = self.items[id]

   assert(s, "Setting with id '" .. id .. "' not found!")

   return self.items[id].value

end

function M.Options:createMenuItems()

   local menuItems, i = {}, 1

   for _, v in pairs(self.items) do
      if v.type == "list" then
	 menuItems[i] = util.makeToggleItem(v,"value", v.label, unpack(v.items))
      elseif v.type == "number" then
	 menuItems[i] = util.makeRangeItem(v, "value", v.label,
					   v.min, v.max, v.step)
      elseif v.type == "boolean" then
	 menuItems[i] = util.makeBooleanItem(v, "value", v.label)
      else
	 error("Unknown menu item type!", 1)
      end

      i = i + 1
   end

   return menuItems

end

return M
