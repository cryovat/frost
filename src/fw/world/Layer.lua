--- Base type for scene layers. Not intended for direct use; see
-- @{fw.world.EntityLayer|EntityLayer}, @{fw.world.ShapeLayer|ShapeLayer}
-- and @{fw.world.TileLayer|TileLayer}.

local Layer = {}

function Layer.new(o)

   o = o or {}

   setmetatable(o, Layer)
   Layer.__index = Layer

   return o

end
function Layer:update(e)

end

function Layer:draw()

end

return Layer
