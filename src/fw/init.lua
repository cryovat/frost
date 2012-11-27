--- Entry point for all fw modules. fw is a micro-framework for
-- LÖVE-based games.

local M = {}

--M.entity = require("fw.entity")
M.codec     = require "fw.codec"
M.gamestate = require "fw.gamestate"
M.graphics  = require "fw.graphics"
M.world     = require "fw.world"
M.Options   = require "fw.Options"
M.menu      = require "fw.menu"

--- Creates an @{fw.Options|Options} instance
-- @tparam table o (optional) Table to create instance from
-- @treturn fw.Options New instance
function M.newOptions(o)
   return M.Options.new(o)
end

return M
