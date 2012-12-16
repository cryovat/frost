local fw = require "fw.init"
local menu = fw.menu
local loader = require "loader"

a = {}

local function newGame(prev)

   return loader.loadMap("level1", a)

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
			{ "Code and graphics: Cryovat", nil },
			{ "Engine: http://www.love2d.org" },
			{ "Made for Ludum Dare 25"}
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

   local o, tw, th, cw, ch = fw.newOptions(), -1, -1, -1, -1
   o:addBoolean("musicOn", "Music enabled", true)
   o:addBoolean("soundOn", "Sound effects enabled", true)
   a.options = o

   a.tiles = love.graphics.newImage("assets/tiles.png")
   tw = a.tiles:getWidth()
   th = a.tiles:getHeight()

   a.tileWidth = 16
   a.tileHeight = 16

   a.atlas = fw.graphics.newAtlas(tw, th, tw / a.tileWidth, th / a.tileHeight)

   a.charas = love.graphics.newImage("assets/charas.png")
   cw = a.charas:getWidth()
   ch = a.charas:getHeight()

   a.chatlas = fw.graphics.newAtlas(cw, ch, 8, 8)
   a.chatlas:addSeq("evil_right_fly", 1, 7)
   a.chatlas:addSeq("evil_right_idle", 1, 1)
   a.chatlas:addSeq("evil_right", 0.25, 2,1,3,1)
   a.chatlas:addSeq("evil_left_fly", 1, 8)
   a.chatlas:addSeq("evil_left_idle", 1, 4)
   a.chatlas:addSeq("evil_left", 0.25, 5,4,6,4)
   a.chatlas:addSeq("hero_idle", 1, 9)
   a.chatlas:addSeq("girl_idle", 1, 17,18,19,20)
   a.chatlas:addSeq("spike_idle", 1, 25)
   a.chatlas:addSeq("robot_right", 1, 33, 34)
   a.chatlas:addSeq("robot_left", 1, 35, 36)
   a.chatlas:addSeq("spawner_closed", 1, 26)
   a.chatlas:addSeq("spawner_open", 1, 27)
   a.chatlas:addSeq("victim_falling", 0.5, 41,42,43,44,45,46)

   --gs = fw.gamestate.fadeIn(mainMenu(nil), 1)
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
