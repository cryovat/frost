require "state"

if not frost or not frost.util then

   local p = {}

   function wrap(max, min, i)
      if i > max then
	 return min
      elseif i < min then
	 return max
      else
	 return i
      end
   end

   function p.makeMenu(prevState, ...)

      local menu = frost.state.State:new(
	 {
	    options = { n = arg.n },
	    selected = 1,
	    counter = 0,
	    x = 0,
	    y = 0,
	    zDown = false
	 })

      for i = 1, arg.n do
	 local item = arg[i]

	 menu.options[i] = {
	    label = item[1],
	    action = item[2]
	 }
      end

      menu.x = (love.graphics.getWidth() / 2) - 100
      menu.y = (love.graphics.getHeight() / 2) - ((menu.options.n / 2) * 20)

      if prevState then
	 menu.options[menu.options.n + 1] = {
	    label = "Return",
	    action = function()
	       return prevState
	    end
	 }
	 menu.options.n = menu.options.n + 1
      end

      function menu:update(e)
	 if menu.counter > 0 then
	    menu.counter = gs.counter - e
	 elseif love.keyboard.isDown("up") then
	    menu.counter = 0.25
	    menu.selected = wrap(menu.options.n, 1, menu.selected - 1)
	 elseif love.keyboard.isDown("down") then
	    menu.counter = 0.25
	    menu.selected = wrap(menu.options.n, 1, menu.selected + 1)
	 elseif love.keyboard.isDown("z") then
	    menu.zDown = true
	 elseif menu.zDown then
	    local item = menu.options[menu.selected]
	    menu.zDown = false
	    return item.action(menu)
	 end
      end

      function menu:draw()
	 for i = 1,menu.options.n do
	    local item = menu.options[i]
	    local label = item.label

	    if type(label) == "function" then
	       label = label()
	    end

	    if i == menu.selected then
	       love.graphics.setColor(0, 255, 255, 255)
	    else
	       love.graphics.setColor(255,255,255,150)
	    end

	    love.graphics.printf(label, menu.x, menu.y + (i * 20), 200, "center")
	 end
      end

      return menu

   end

   frost = frost or {}
   frost.util= p

end
