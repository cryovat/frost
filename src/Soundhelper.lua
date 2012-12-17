local Soundhelper = {}

function Soundhelper.new(options, o)

   o = o or {}

   setmetatable(o,Soundhelper)
   Soundhelper.__index = Soundhelper

   o.options = options

   o.sources = {
      death= love.audio.newSource("assets/sound/death.wav", "static");
      door= love.audio.newSource("assets/sound/door.wav", "static");
      jump= love.audio.newSource("assets/sound/jump.wav", "static");
      robodeath= love.audio.newSource("assets/sound/robodeath.wav", "static");
      spawn= love.audio.newSource("assets/sound/spawn.wav", "static");
      thud= love.audio.newSource("assets/sound/thud.wav", "static");
      victory= love.audio.newSource("assets/sound/victory.wav", "static");
   }

   return o

end

function Soundhelper:update(elapsed)

   if love.keyboard.isDown("z") then
      self.zdown = true
   elseif self.zdown then
      return loader.loadMap("level1", self.assets)
   end

end

function Soundhelper:play(id)

   if self.options:get("soundOn") then

      local s = assert(self.sources[id], "Sound '" .. id .. "' not found!")
      s:rewind()
      love.audio.play(s)

   end

end

return Soundhelper
