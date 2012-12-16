local M = {}

local player_speed, player_jump_speed, player_gravity  = 60, 80, 60

function M.mainChar(l, entity)

   local jumpM, can_jump = 0, true

   function entity:update(elapsed)

      local x, y = entity:getPosition()

      if love.keyboard.isDown("left") then
	 x = x - (player_speed * elapsed)
      elseif love.keyboard.isDown("right") then
	 x = x + (player_speed * elapsed)
      end

      if love.keyboard.isDown("z") and jumpM == 0 and can_jump then

	 jumpM = player_jump_speed

      elseif jumpM > 0 then

	 y = y - (elapsed * jumpM)
	 jumpM = math.max(jumpM - (elapsed * player_jump_speed), 0)

      else

	 y = y + (elapsed * player_gravity)

      end

      return true, x, y
   end

end


return M
