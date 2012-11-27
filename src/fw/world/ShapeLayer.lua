--- Type for shape layers.
-- Shape layers are non-visual layers that  contain static shapes
-- which can be used to hit-test against. These shapes can optionally be
-- associated with arbitrary kind identifiers that allows the user to
-- limit the number of shapes an area is hit-tested against.

local Layer = require "fw.world.Layer"
local graphics = require "fw.graphics"

local ShapeLayer = Layer.new()

function ShapeLayer.new(width, height, o)

   o = o or {}

   setmetatable(o, ShapeLayer)
   ShapeLayer.__index = ShapeLayer

   o.width = width
   o.height = height
   o.shapes = {}
   o.debugDraw = false
   o.debugColor = { 255,0,0,100 }

   return o

end

--- Adds a rectangular shape to the layer
-- @tparam number left Minimum x coordinate of bounding rectangle
-- @tparam number right Maximum x coordinate of bounding rectangle
-- @tparam number top Minimum y coordinate of bounding rectangle
-- @tparam number bottom Maximum y coordinate of bounding rectangle
-- @param kind (optional) Kind of the shape. Can be any Lua value.
function ShapeLayer:addRect(left, right, top, bottom, kind)

   self.shapes[#self.shapes] = {
      kind = kind or true,
      left = left,
      right = right,
      top = top,
      bottom = bottom
   }

end

--- Tests if a bounding rectangle intersects with a shape in the layer.
-- @tparam number left Minimum x coordinate of bounding rectangle
-- @tparam number right Maximum x coordinate of bounding rectangle
-- @tparam number top Minimum y coordinate of bounding rectangle
-- @tparam number bottom Maximum y coordinate of bounding rectangle
-- @param kind (optional) Kind of shape to hit test. Nil value will
-- test with all shapes in layer.
-- @return The kind of shape the bounding rectangle intersects with,
-- or nil if no collision.
function ShapeLayer:hitTestRect(left,right,top,bottom,kind)

   for _,v in ipairs(self.shapes) do

      if (not kind or kind == vkind) and
	 not (v.left > left or v.right < right or
	      v.top > bottom or v.bottom < top) then

	 return v.kind

      end

   end

   return nil

end

--- Tests if a bounding circle intersects with a shape in the layer.
-- @tparam number x Center x coordinate of circle
-- @tparam number y Center y coordinate of circle
-- @tparam number radius Radius of circle
-- @param kind (optional) Kind of shape to hit test. Nil value will
-- test with all shapes in layer.
-- @return The kind of shape the bounding rectangle intersects with,
-- or nil if no collision.
function ShapeLayer:hitTestCircle(x,y,radius,kind)

   error("Not implemented yet!", 2)
end

--- Toggles whether the bounding boxes should be drawn for the layer.
-- @tparam boolean value True if boxes should be drawn
function ShapeLayer:setDebugDrawEnabled(value)
   self.debugDraw = value
end

--- Gets if debug drawing is enabled for the layer.
-- @treturn boolean True if the
function ShapeLayer:getDebugDrawEnabled()
   return self.debugDraw
end

--- Sets the current color used for debug drawing of shapes
-- @tparam number r Red component
-- @tparam number g Green component
-- @tparam number b Blue component
-- @tparam number a Alpha component
function ShapeLayer:setDebugColor(r, g, b, a)

   local c = self.debugColor
   c[1] = r or 255
   c[2] = g or 0
   c[3] = b or 0
   c[4] = a or 100

end

--- Gets the current color used for debug drawing of shapes
-- @treturn number Red component
-- @treturn number Green component
-- @treturn number Blue component
-- @treturn number Alpha component
function ShapeLayer:getDebugColor()
   return unpack(self.debugColor)
end

--- Resets the current color used for debug drawing of shapes to its
-- default value
function ShapeLayer:resetDebugColor()
   self:setDebugColor()
end

function ShapeLayer:update(e)
end

function ShapeLayer:draw()
end

return ShapeLayer
