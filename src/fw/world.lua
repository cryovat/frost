--- Types and utilities for world management and simulation

local M = {}

M.Scene = require "fw.world.Scene"

M.EntityLayer = require "fw.world.EntityLayer"
M.ShapeLayer  = require "fw.world.ShapeLayer"
M.TileLayer   = require "fw.world.TileLayer"

--- Creates a blank @{fw.world.Scene|Scene}
-- @tparam table o (optional) Table to base new instance on
-- @treturn fw.world.Scene New instance
function M.newScene(o)
   return M.Scene.new(o)
end

--- Creates a blank @{fw.world.EntityLayer|EntityLayer}
-- @tparam number width Width in pixels
-- @tparam number height Height in pixels
-- @tparam table o (optional) Table to base new instance on
-- @treturn fw.world.EntityLayer New instance
function M.newEntityLayer(width, height, o)
   return M.EntityLayer.new(width, height, o)
end

--- Creates a blank @{fw.world.ShapeLayer|ShapeLayer}
-- @tparam number width Width in pixels
-- @tparam number height Height in pixels
-- @tparam table o (optional) Table to base new instance on
-- treturn fw.world.ShapeLayer New instance
function M.newShapeLayer(width, height, o)
   return M.ShapeLayer.new(width, height, o)
end

--- Creates a blank @{fw.world.TileLayer|TileLayer}
-- @tparam fw.graphics.Atlas atlas Atlas to use
-- @tparam love.graphics.Image image Image to use for rendering
-- @tparam number width Width in pixels
-- @tparam number height Height in pixels
-- @tparam table o (optional) Table to base new instance on
-- treturn fw.world.TileLayer New instance
function M.newTileLayer(atlas, image, width, height, o)
   return M.TileLayer.new(atlas, image, width, height, o)
end

return M
