--- Helper methods to prevent type errors and protect program state.

local M = {}

--- Asserts that a named parameter value is of the expected type. Raises error
-- upon invalid value, otherwise returns value.
-- @tparam string name The name of the parameter
-- @tparam string typename The name of the expected type
-- @param value The value to verify
function M.required(name, typename, value)
   local actual = type(value)

   if type(name) ~= "string" or string.len(name) == 0 then
      error("Ironically, the name passed to 'required' is invalid!", 1)
   elseif type(typename) ~= "string" or string.len(typename) == 0 then
     error("Ironically, the typename passed to 'required' is invalid!", 1)
   elseif typename ~= actual then
     error("Expected " .. name .. " to be " .. typename ..
	   "; got " .. actual, 2)
   end

   return value
end

--- Asserts that a named parameter value is either of the expected type or nil.
-- @tparam string name The name of the parameter
-- @tparam string typename The name of the expected type
-- @param value The value to verify
function M.optional(name, typename, value)
   local actual = type(value)

   if type(name) ~= "string" or string.len(name) == 0 then
      error("Ironically, the name passed to 'optional' is invalid!", 1)
   elseif type(typename) ~= "string" or string.len(typename) == 0 then
     error("Ironically, the typename passed to 'optional' is invalid!", 1)
   elseif typename ~= actual and actual ~= "nil" then
     error("Expected " .. name .. " to be " .. typename ..
	   "; got " .. actual, 2)
   end

   return value
end

--- Asserts that a named parameter value is a non-blank string.
-- @tparam string name The name of the parameter
-- @param value The value to verify
function M.nonblank(name, value)
   local actual = type(value)

   if type(name) ~= "string" or string.len(name) == 0 then
      error("Ironically, the name passed to 'nonblank' is invalid!", 1)
   elseif actual ~= "string" then
      error("Expected " .. name .. " to be string; got " .. actual, 1)
   elseif string.len(value) == 0 then
      error("Parameter " .. name .. " is a blank string", 2)
   end

   return value
end

--- Exports the parameter checking functions for better performance.
-- @treturn function @{required}
-- @treturn function @{optional}
-- @treturn function @{nonblank}
function M.yoink()
   return M.required, M.optional, M.nonblank
end

local required, optional, nonblank = M.yoink()

--- Makes a table that enforces non-blank string keys and values of
-- a single type.
-- @tparam string typename The type name of permitted values
-- @param default (optional) The default value if key does not exist
-- @treturn table A table that only permits string keys (treated as
-- case insensitive) and values of the specified type.
function M.makeTypedStore(typename, default)

   typename = nonblank("typename", typename)
   default = optional("default", typename, default)

   local public, store, mt, keyname = {}, {}, {}, (typename .. " store key")

   function mt.__index(_, key)

      key = string.lower(nonblank(keyname, key))

      return store[string.lower(nonblank(key))]

   end

   function mt.__newindex(_, key, value)

      key = string.lower(nonblank(keyname, key))
      value = optional("value", typename, value)

      store[key] = value

   end

   setmetatable(public, mt)

   return public

end

--- Creates a table proxy that will redirect lookups to the
-- original table, but raise errors upon assignment.
-- @tparam table actual The table to create a wrapper for
-- @treturn table The new read-only wrapper table
function M.protect(actual)

   actual = required("actual", "table", actual)

   local public, mt = {}, {}

   function mt.__index(_, key)
      return actual[key]
   end

   function mt.__newindex(_, key, value)
      error("Tried to write to a protected table", 2)
   end

   setmetatable(public, mt)

   return public

end

return M
