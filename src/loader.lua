local fw = require "fw.init"

M = {}

local function loadTiles(width, height, data, assets)

   local tiles

   tiles = fw.graphics.newTileMap(assets.atlas, assets.tiles, width, height)
   tiles:setData(unpack(data))

   return tiles

end

local function loadEntities(width, height, data, assets)

   for x=0,width-1 do
      for y=0, height-1 do
	 local n = data[(y * width + x) + 1]

	 if n == 0 then
	 elseif n == 1 then
	    print("Northern exit at " .. x .. "x" ..y)
	 elseif n == 2 then
	    print("Southern exit at " .. x .. "x" ..y)
	 elseif n == 3 then
	    print("Eastern exit at " .. x .. "x" ..y)
	 elseif n == 4 then
	    print("Western exit at " .. x .. "x" ..y)
	 elseif n == 5 then
	    print("Wall at " .. x .. "x" ..y)
	 elseif n == 6 then
	    print("Spike death at " .. x .. "x" ..y)
	 elseif n == 7 then
	    print("Acid death at " .. x .. "x" ..y)
	 elseif n == 8 then
	    print("Angry robot at " .. x .. "x" ..y)
	 elseif n == 9 then
	    print("Coin pickup at " .. x .. "x" ..y)
	 elseif n == 10 then
	    print("Key at " .. x .. "x" ..y)
	 elseif n == 11 then
	    print("Locked door at " .. x .. "x" ..y)
	 end

	-- o.quads[y * countX + x] = love.graphics.newQuad(
	--    o.tileWidth * x,
	--    o.tileHeight * y,
	--    o.tileWidth,
	--    o.tileHeight,
	--    imageWidth,
	--    imageHeight)

	-- i = i + 1

      end
   end

end

function M.loadMap(levelName, assets)

   local level = love.filesystem.load("assets/" .. levelName .. ".lua")()
   local tiles_norm, objects_norm, bg, entities, l = 0, 0, nil, nil, nil

   for i,v in ipairs(level.tilesets) do

      if (v.name == "tiles") and v.firstgid ~= 1 then
	 tiles_norm = (v.firstgid * -1) + 1
      elseif (v.name == "objects") and v.firstgid ~= 1 then
	 objects_norm = (v.firstgid * -1) + 1
      end
   end

   for i,v in ipairs(level.layers) do

      if (v.name == "Background") then

	 for i,t in ipairs(v.data) do
	    v.data[i] = t + tiles_norm
	 end

	 bg = loadTiles(v.width, v.height, v.data, assets)
      elseif (v.name == "Entities") then
	 entities = loadEntities(v.width, v.height, v.data, assets)
      end

   end

   l = fw.gamestate.newState()

   function l:update(e)

   end

   function l:draw(alpha)

      bg:draw()

   end

   return l

end

return M
