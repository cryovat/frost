local state = require "state"
local util = require "util"

local a = {}
local settings = {
   difficulty="Easy",
   continues=1
}

local function newGame()
   error "Game not implemented"
end

local function quit()
   love.event.push("quit")
end

local function options(prev)

   local diffItem = util.makeToggleItem(settings, "difficulty", "Difficulty",
					"Easy", "Medium", "Hard")

   local contItem = util.makeRangeItem(settings, "continues", "Continues",
				       1, 5)

   return util.makeMenu(prev, diffItem, contItem)

end

local function credits(prev)

   return util.makeMenu(prev,
			{ "Copyright, etc", nil }
		       )
end

local function mainMenu(prev)

   return util.makeMenu(nil,
			{ "New Game", mainMenu },
			{ "Options", options },
			{ "Credits", credits },
			{ "Quit", quit }
		       )

end

function love.load()
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

   love.graphics.setMode(640,480,false,false,4)
   gs = state.fadeIn(mainMenu(nil), 1)
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
end
