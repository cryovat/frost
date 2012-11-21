if not frost then frost = {} end
if not frost.assets then frost.assets = {} end

require "state"
require "util"

local state, util = frost.state, frost.util

function newGame()
   error "Game not implemented"
end

function quit()
   love.event.push("quit")
end

function options(prev)

   local counter, label = 0, "Continues: None"

   function counterLabel()
      return label
   end

   function incCounter()
      counter = counter + 1
      label = "Continues: " .. counter
   end

   return util.makeMenu(prev,
			{ counterLabel, incCounter }
		       )

end

function credits(prev)

   function void()
   end

   return util.makeMenu(prev,
			{ "Copyright, etc", void }
		       )
end

function mainMenu(prev)

   return util.makeMenu(nil,
			{ "New Game", mainMenu },
			{ "Options", options },
			{ "Credits", credits },
			{ "Quit", quit }
		       )

end

function love.load()
   local a = frost.assets
   a.bg = love.graphics.newImage("gfx/winter.png")
   love.graphics.setMode(640,480,false,false,4)
   gs = state.fadeIn(mainMenu(nil), 1)
end

function love.update(e)
   local nextState = gs:update(e)

   gs = nextState or gs
end

function love.draw()
   love.graphics.setColor(255,255,255,alpha)
   love.graphics.draw(frost.assets.bg, 0, 0)
   gs:draw(255)
end
