local M = {}

--M.entity = require("fw.entity")
M.gamestate = require "fw.gamestate"
M.graphics = require "fw.graphics"
M.Options = require "fw.Options"
M.menu = require "fw.menu"

function M.newOptions(o)
   return M.Options.new(o)
end

return M
