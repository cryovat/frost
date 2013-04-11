--- Cutscene loading and playback

local Sandbox = require "fw.event.Sandbox"
local I = require "fw.integrity"

local M = {}

--- Creates a new, empty @{fw.event.Sandbox}.
-- @treturn fw.event.Sandbox The new instance
function M.makeSandbox()
   return Sandbox.new()
end

--- Creates a factory function that loads @{fw.event.Event}s with a common
-- sandboxed environment.
-- @tparam function initf An unary initialization function
-- taking a @{fw.event.Sandbox} object as parameter. It will be invoked
-- exactly once, the first time the factory function is called.
-- @treturn function An unary function that takes a filename @{string}
-- as parameter and returns an @{fw.event.Event}.
function M.makeScriptFactory(initf)

   initf = I.required("initf", "function", initf)

   local sb = false

   local function factory(filename)
      if not sb then
	 sb = M.makeSandbox()
	 initf(sb)
      end

      return M.loadScript(filename, sb)
   end

   return factory

end

--- Loads a file as a sandboxed @{fw.event.Event} script.
-- @tparam string filename The name of the file to load
-- @tparam fw.event.Sandbox sandbox The sandboxed environment of the loaded
-- @{fw.event.Event}. If the parameter is not provided, an empty new environment
-- will be created exclusively for the new @{fw.event.Event} instance.
-- @treturn fw.event.Event Event object with blank @{fw.event.Sandbox}
function M.loadScript(filename, sandbox)
   error("Not implemented")
end

return M
