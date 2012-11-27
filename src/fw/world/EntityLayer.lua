--- Type for entity layers.
-- Entity layers are visual layers  contain dynamic objects such as the
-- player character, enemies, chests and so on. These commonly have an
-- associated hit box, @{fw.graphics.Sprite|Sprite} and behavior.

local Layer = require "fw.world.Layer"
local graphics = require "fw.graphics"

local EntityLayer = Layer.new()

function EntityLayer.new(width, height, o)

   o = o or {}

   setmetatable(o, EntityLayer)
   EntityLayer.__index = EntityTileLayer

   o.width = width
   o.height = height

   return o

end

function EntityLayer:update(e)
end

function EntityLayer:draw()
end

return EntityLayer
