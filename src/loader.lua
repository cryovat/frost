local fw = require "fw.init"
local behavior = require "behavior"
local Level = require "Level"
local Entity = require "Entity"

local M = {}

local function loadTiles(width, height, data, assets)

   local tiles

   tiles = fw.graphics.newTileMap(assets.atlas, assets.tiles, width, height)
   tiles:setData(unpack(data))

   return tiles

end

local function loadEntities(level, width, height, data, assets, exits)

   print(#data)

   print("Loading entities")

   for x=0,width-1 do
      for y=0, height-1 do
	 local n = data[(y * width + x) + 1]

	 -- Suggested coordinates
	 local sx, sy = Level.convertGridCoords(x,y)

	 if n == 0 then
	    -- Noop
	 elseif n == 1 then -- Northern exit
	    level:addExit(x, y, exits[behavior.directions.north])
	 elseif n == 2 then -- Southern exit
	    level:addExit(x, y, exits[behavior.directions.south])
	 elseif n == 3 then -- Eastern exit
	    level:addExit(x, y, exits[behavior.directions.east])
	 elseif n == 4 then -- Western exit
	    level:addExit(x, y, exits[behavior.directions.west])
	 elseif n == 5 then -- Wall
	    level:toggleBlocked(x, y, true)
	 elseif n == 6 then
	    local s = fw.graphics.newSprite(assets.chatlas)
	    s:setAnim("spike_idle")
	    local ent = Entity.new(s, sx, sy, 0, -8)
	    level:addEntity(ent)
	    behavior.spike(level, ent)
	 elseif n == 7 then
	    local s = fw.graphics.newSprite(assets.chatlas)
	    s:setAnim("spike_idle")
	    local ent = Entity.new(s, sx, sy, 0, -8)
	    level:addEntity(ent)
	    behavior.acid(level, ent)
	 elseif n == 8 then -- Robot
	    local s = fw.graphics.newSprite(assets.chatlas)
	    s:setAnim("robot_right")
	    local ent = Entity.new(s, sx, sy, 0, -8)
	    level:addEntity(ent)
	    behavior.robot(level, ent)
	 elseif n == 9 then
	    print("Coin pickup at " .. x .. "x" ..y)
	 elseif n == 10 then
	    print("Key at " .. x .. "x" ..y)
	 elseif n == 11 then
	    print("Locked door at " .. x .. "x" ..y)
	 elseif n == 12 then
	    level:setPlayerSpawn(sx, sy)
	 elseif n == 13 then -- Damsel
	    local s = fw.graphics.newSprite(assets.chatlas)
	    s:setAnim("girl_idle")
	    local ent = Entity.new(s, sx, sy, 0, -8)
	    level:addEntity(ent)
	    behavior.damsel(level, ent)
	 elseif n == 14 then -- Hero
	    print("Hero at " .. x .. "x" ..y)
	 elseif n == 15 then -- Vicimspawner
	    local s = fw.graphics.newSprite(assets.chatlas)
	    s:setAnim("spawner_closed")
	    local ent = Entity.new(s, sx, sy, 0, -8)
	    level:addEntity(ent)
	    behavior.spawner(level, ent, assets)
	 end

      end
   end

end

local function makePlayerFactory(assets)

   local f = function(level, x,y)

      local s = fw.graphics.newSprite(assets.chatlas)

      s:setAnim("evil_right_idle")
      local ent = Entity.new(s, x, y, 0, -8)
      behavior.mainChar(level, ent)

      return ent

   end

   return f

end

function M.loadMap(levelName, assets, entry)

   local ldata = love.filesystem.load("assets/" .. levelName .. ".lua")()
   local tiles_norm, objects_norm, bg, entities, l, e = 0, 0, nil, nil, nil, nil

   local p, exits = ldata.properties, {}

   if p then

      for i,_ in pairs(behavior.directions) do
	 if p[i] then
	    exits[i] = function () print(i);
	       return M.loadMap(p[i], assets, i) end
	 end
      end

   end

   for i,v in ipairs(ldata.tilesets) do

      if (v.name == "tiles") and v.firstgid ~= 1 then
	 tiles_norm = (v.firstgid * -1) + 1
      elseif (v.name == "objects") and v.firstgid ~= 1 then
	 objects_norm = (v.firstgid * -1) + 1
      end
   end

   for i,v in ipairs(ldata.layers) do

      if (v.name == "Background") then

	 for i,t in ipairs(v.data) do
	    v.data[i] = t + tiles_norm
	 end

	 bg = loadTiles(v.width, v.height, v.data, assets)
      elseif (v.name == "Entities") then
	 e = v
      end

   end

   local playerMaker = makePlayerFactory(assets)

   l = Level.new(bg, ldata.properties, a.charas, playerMaker)

   loadEntities(l, e.width, e.height, e.data, assets, exits)

   l:init()

   if entry then
      local flipped = behavior.flipDir(entry)
      local exitf = assert(exits[flipped],
			   "Exit " .. flipped .. " not found in " .. levelName)

      local ex, ey = l:findExitCoords(exitf)
      local sx, sy = Level.convertGridCoords(ex, ey)

      l:setPlayerSpawn(sx, sy)

   end

   l:respawnPlayer()

   return l

end

return M
