--- Entry point for all fw modules

local M = {}

--M.entity = require("fw.entity")
M.gamestate = require "fw.gamestate"
M.graphics = require "fw.graphics"
M.Options = require "fw.Options"
M.menu = require "fw.menu"

--- Creates an Options instance
-- @param o (optional) Table to create instance from
function M.newOptions(o)
   return M.Options.new(o)
end

return M
