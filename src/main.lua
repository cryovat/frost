local fw = require("fw.init")
local menu = fw.menu

a = {}

local function newGame(prev)

   return fw.gamestate.loadLevel "level/test"

end

local function quit()
   love.event.push("quit")
end

local function options(prev)

   local optItems = a.options:createMenuItems()

   return menu.makeMenu(prev, unpack(optItems))

end

local function credits(prev)

   return menu.makeMenu(prev,
			{ "Copyright, etc", nil }
		       )
end

local function mainMenu(prev)

   return menu.makeMenu(nil,
			{ "New Game", newGame },
			{ "Options", options },
			{ "Credits", credits },
			{ "Quit", quit }
		       )

end

function love.load()

   local o = fw.newOptions()
   o:addBoolean("musicOn", "Music enabled", true)
   o:addBoolean("soundOn", "Sound effects enabled", true)
   o:addNumber("conts", "Continues", 1, 1, 5, 1)
   o:addList("diff", "Difficulty", "Easy", "Easy", "Medium", "Hard")
   o:addList("color", "Player color", "green", "red", "blue")
   a.options = o

   a.bg = love.graphics.newImage("gfx/external/winter.png")

   a.flake = love.graphics.newImage("gfx/snowflake.png")
   a.snow = love.graphics.newParticleSystem(a.flake, 100)

   a.snow:setEmissionRate(1)
   a.snow:setLifetime(-1)
   a.snow:setPosition(320, -100)
   a.snow:setParticleLife(10,15)
   a.snow:setSizes(0.1, 0.2, 0.3)
   a.snow:setGravity(5)
   a.snow:setSpread(80)
   a.snow:setTangentialAcceleration(-5,5)
   a.snow:setSpeed(10, 0)
   a.snow:start()

   gs = fw.gamestate.fadeIn(mainMenu(nil), 1)
end

function love.update(e)
   a.snow:update(e)

   local nextState = gs:update(e)

   gs = nextState or gs
end

function love.draw()
   love.graphics.setColor(255,255,255,255)
   love.graphics.draw(a.bg, 0, 0)
   love.graphics.setColor(255,255,255,50)
   love.graphics.draw(a.snow)
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
   if key == "rctrl" then
      debug.debug()
   elseif gs and gs.keypressed then
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
