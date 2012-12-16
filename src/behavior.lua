local fw = require "fw.init"
local Entity = require "Entity"
local M = {}

local player_speed, player_jump_speed, player_gravity  = 60, 80, 60

local respawn_delay = 0.5

M.types = {
   player="player";
   spike="spike";
   acid="acid";
   damsel="damsel";
   spawner="spanwer";
   victim = "victim";
   robot = "robot"
}

M.directions = {
   north="north";
   south="south";
   east="east";
   west="west"
}

function M.flipDir(dir)

   if dir == "north" then
      return "south"
   elseif dir == "south" then
      return "north"
   elseif dir == "east" then
      return "west"
   else
      return "east"
   end

end

function M.acid(l, entity)

   function entity:getType()
      return M.types.acid
   end

   function entity:isVisible()
      return false
   end

   function entity:isFondlable()
      return true
   end

   function entity:init()
   end

end

function M.spike(l, entity)

   function entity:getType()
      return M.types.spike
   end

   function entity:isFondlable()
      return true
   end

   function entity:init()
   end

end

function M.mainChar(l, entity)

   local jumpM, can_jump, lastY, inExit, dead = 0, true, -1, false, false

   local facing = M.directions.east

   function entity:getType()
      return M.types.player
   end

   function entity:isTouchyFeely()
      return true
   end

   function entity:init()
      local x, y = entity:getPosition()

      if l:getExit(x, y) then
	 inExit = true
      end
   end

   function entity:fondle(other)

      local ot =  other:getType()

      if ot == M.types.spike then
	 dead = true
      elseif ot == M.types.acid then
	 dead = true
      elseif ot == M.types.victim then
	 dead = true
      elseif ot == M.types.robot then
	 dead = true
      end
   end

   function entity:behavior(elapsed)

      local ox, oy = entity:getPosition()
      local x, y = ox, oy

      if dead or love.keyboard.isDown("r") then
	 l:scheduleRespawnPlayer(respawn_delay)
	 return false, x, y
      end

      local exit = l:getExit(x, y)

      if not inExit and exit then
	 l:replaceLevel(exit)
	 inExit = true
      elseif inExit and not exit then
	 inExit = false
      end

      if love.keyboard.isDown("left") then
	 x = x - (player_speed * elapsed)
	 facing = M.directions.west
      elseif love.keyboard.isDown("right") then
	 x = x + (player_speed * elapsed)
	 facing = M.directions.east
      end

      if love.keyboard.isDown("z") and jumpM == 0 and can_jump then

	 jumpM = player_jump_speed

      elseif jumpM > 0 then

	 y = y - (elapsed * jumpM)
	 jumpM = math.max(jumpM - (elapsed * player_jump_speed), 0)

      else

	 y = y + (elapsed * player_gravity)

      end

      if not l:isOnFloor(x,y) then
	 if facing == M.directions.west then
	    entity:setAnim("evil_left_fly")
	 else
	    entity:setAnim("evil_right_fly")
	 end
      elseif ox == x then
	 if facing == M.directions.west then
	    entity:setAnim("evil_left_idle")
	 else
	    entity:setAnim("evil_right_idle")
	 end
      else
	 if facing == M.directions.west then
	    entity:setAnim("evil_left")
	 else
	    entity:setAnim("evil_right")
	 end
      end

      lastY = y

      return true, x, y
   end

end

function M.damsel(l, entity)

   function entity:getType()
      return M.types.damsel
   end

   function entity:isFondlable()
      return false
   end

end

function M.robot(l, entity)

   local direction = 1

   function entity:getType()
      return M.types.robot
   end

   function entity:isFondlable()
      return true
   end

   function entity:behavior(elapsed)

      local x, y = self:getPosition()

      local nx = x + (direction * player_speed * elapsed)

      if not l:isOnFloor(nx, y) then
	 direction = direction * -1
	 nx = x

	 if direction == 1 then
	    self:setAnim("robot_right")
	 else
	    self:setAnim("robot_left")
	 end
      end

      return true, nx, y

   end

end

function M.victim(l, entity)

   local dead = false

   function entity:getType()
      return M.types.victim
   end

   function entity:isFondlable()
      return true
   end

   function entity:isTouchyFeely()
      return true
   end

   function entity:fondle(other)
      if other:getType() == M.types.spike then
	 dead = true
      elseif other:getType() == M.types.acid then
	 dead = true
      end
   end

   function entity:behavior(elapsed)

      local x, y = self:getPosition()

      if dead then
	 return false, x, y
      else
	 return true, x, y + (player_gravity * elapsed)
      end


   end

end

function M.spawner(l, entity, assets)

   local state_closed, state_opening, state_closing = 0,1,2
   local state, timer = state_closed, 0

   local function spawnDude()
      local x, y = entity:getPosition()

      y = y + 20

      local s = fw.graphics.newSprite(assets.chatlas)
      s:setAnim("victim_falling")
      local ent = Entity.new(s, x, y, 0, -8)
      M.victim(l, ent)
      l:addEntity(ent)
   end

   function entity:getType()
      return M.types.spawner
   end

   function entity:isSolid()
      return false
   end

   function entity:behavior(elapsed)

      if timer > 0 then
	 timer = timer - elapsed
      elseif state == state_closed then
	 if math.random(0,100) > 95 then
	    timer = 0.5
	    state = state_opening
	    self:setAnim("spawner_open")
	 end
      elseif state == state_opening then
	 timer = 0.5
	 spawnDude()
	 state = state_closing
      elseif state == state_closing then
	 self:setAnim("spawner_closed")
	 timer = 1
	 state = state_closed
      end

      return true, self:getPosition()

   end

end

return M
