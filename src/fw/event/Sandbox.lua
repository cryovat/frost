--- An object providing access to the inner environment of an @{fw.event.Event}.
-- Note that value/function identifiers are treated in a case-insensitive way.

local I = require "fw.integrity"

Sandbox = {}

function Sandbox.new(o)
   o = o or {}
   setmetatable(o, Sandbox)
   Sandbox.__index = Sandbox
   return o
end

--- Gets the names of global functions in the inner environment.
-- @treturn table A table with function names as @{string}s
function Sandbox:getFunctionNames()
   error("Not implemented")
end

--- Registers a global function in the inner environment
-- @tparam string name The name of the function
-- @tparam function f The function to associate with the name
function Sandbox:addFunction(name, f)
   error("Not implemented")
end

--- Removes a global function from the inner environment
-- @tparam string name The name of the function
function Sandbox:removeFunction(name)
   error("Not implemented")
end

--- Gets the names of flags in the inner environment.
-- @treturn table A table with flag names as @{string}s
function Sandbox:getFlagNames()
   error("Not implemented")
end

--- Reads a named boolean flag from the inner environment
-- @tparam string name The name of the flag
-- @tparam bool default The default value if unknown (default = false)
-- @treturn bool The value of the flag or default if unknown
function Sandbox:readFlag(name, default)
   error("Not implemented")
end

--- Sets a named boolean flag in the inner environment
-- @tparam string name The name of the flag
-- @tparam bool value The value to set
function Sandbox:setFlag(name, value)
   error("Not implemented")
end

--- Gets the names of numbers in the inner environment.
-- @treturn table A table with number names as @{string}s
function Sandbox:getNumberNames()
   error("Not implemented")
end

--- Reads a named numeric value from the inner environment
-- @tparam string name The name of the numeric value
-- @tparam number default The default value if unknown (default = 0)
-- @treturn number The value of the number or default if unknown
function Sandbox:readNumber(name, default)
   error("Not implemented")
end

--- Writes a named numeric value to the inner environment
-- @tparam string name The name of the value
-- @tparam number value The value to set
function Sandbox:writeNumber(name, value)
   error("Not implemented")
end

--- Gets the names of @{string}s in the inner environment.
-- @treturn table A table with string names as @{string}s
function Sandbox:getStringNames()
   error("Not implemented")
end

--- Reads a named @{string} value from the inner environment
-- @tparam string name The name of the @{string} value
-- @tparam string default The default value if unknown (default = "")
-- @treturn string The value of the string or default if unknown
function Sandbox:readString(name, default)
   error("Not implemented")
end

--- Writes a named string value to the inner environment
-- @tparam string name The name of the value
-- @tparam string value The value to set
function Sandbox:writeString(name, value)
   error("Not implemented")
end

--- Serializes the internal primitive values (and names) to a file
-- @tparam string filename The name of the target file
function Sandbox:serialize(filename)
   error("Not implemented")
end

--- Serializes the internal primitive values (and names) from a file
-- @tparam string filename The name of the target file
function Sandbox:deserialize(filename)
   error("Not implemented")
end

return Sandbox
