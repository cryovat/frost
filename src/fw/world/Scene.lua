--- Class for scene management and rendering.
-- Scenes represent levels. They aggregate different kinds of
-- @{fw.world.Layer|layers} that contain specialized information about the
-- scene and ensure that these are updated and drawn.

local Scene = {}

function Scene.new(o)

   o = o or {}

   setmetatable(o,Scene)

   return o

end

--- Called when the scene should update its data
-- @tparam number Seconds since last update as decimal
function Scene:update(e)
end

--- Draws the scene
-- @tparam number alpha Alpha value to use for drawing
function Scene:draw(alpha)
end

return Scene
