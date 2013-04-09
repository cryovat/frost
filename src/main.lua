local fw = require "fw.init"
local menu = fw.menu

local function quit()
   love.event.push("quit")
end

local function mainMenu(prev)

   return menu.makeMenu(nil,
			{ "fw" },
			{ "Quit", quit }
		       )

end

function love.load()
   gs = mainMenu(nil)
end

function love.update(e)

   local nextState = gs:update(e)

   gs = nextState or gs
end

function love.draw()
   love.graphics.setColor(255,255,255,255)

   gs:draw(255)

   love.graphics.setColor(255,255,255,255)
end

function love.mousepressed(x, y, button)
   if gs and gs.mousepressed then
      gs:mousepressed(x, y, button)
   end
end

function love.mousereleased(x, y, button)
   if gs and gs.mousepressed then
      gs:mousepressed(x, y, button)
   end
end

function love.keypressed(key, unicode)
   if gs and gs.keypressed then
      gs:keypressed(key, unicode)
   end
end

function love.keyreleased(key, unicode)
   if gs and gs.keyreleased then
      gs:keyreleased(key, unicode)
   end
end

function love.focus(f)
   if gs and gs.focus then
      gs:focus(f)
   end
end
