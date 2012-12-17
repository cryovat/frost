--- Entry point for all fw modules. fw is a micro-framework for
-- LÖVE-based games.

local M = {}

M.gamestate = require "fw.gamestate"
M.graphics  = require "fw.graphics"
M.Options   = require "fw.Options"
M.menu      = require "fw.menu"

--- Creates an @{fw.Options|Options} instance
-- @tparam table o (optional) Table to create instance from
-- @treturn fw.Options New instance
function M.newOptions(o)
   return M.Options.new(o)
end

return M
