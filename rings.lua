--
--          rings
--
--    v 0.2.0 @okyeron
--
-- Based on the supercollider UGens by Volker Bohm https://github.com/v7b1/mi-UGens
--
--

engine.name = "MiRings"

local pitch = 50.0
local struct = 0.5
local bright = 0.3
local damp = 0.25
local position = 0.5
local model = 0
local poly = 4
local intern_exciter = 0
local bypass = 0
local easteregg = 0

-- 		arg in=0, trig=0, pit=60.0, struct=0.25, bright=0.5, damp=0.7, pos=0.25, model=0, poly=1,
--		intern_exciter=0, easteregg=0, bypass=0, mul=1.0, add=0;

function init()
  -- initialization
  engine.pit(pitch) -- pitch
  engine.struct(struct) 
  engine.bright(bright) -- brightness 0-1
  engine.damp(damp) -- damping 0-1
  engine.pos(position) -- position 0-1
  engine.model(model) -- 0-5
  engine.poly(poly) -- Polyphony 1-4
  engine.intern_exciter(intern_exciter) -- intern_exciter
  engine.bypass(bypass)
  engine.easteregg(easteregg)
  -- easteregg 0-5
  
  params:add_control("pitch", "pitch", controlspec.new(0, 100, "lin", 1, pitch, ""))
  params:set_action("pitch", function(value) engine.pit(value) end)

  params:add_control("structure", "structure", controlspec.new(0.00, 1.00, "lin", 0.01, struct, ""))
  params:set_action("structure", function(value) engine.struct(value) end)

  params:add_control("brightness", "brightness", controlspec.new(0.00, 1.00, "lin", 0.01, bright, ""))
  params:set_action("brightness", function(value) engine.bright(value) end)

  params:add_control("damping", "damping", controlspec.new(0.00, 1.00, "lin", 0.01, damp, ""))
  params:set_action("damping", function(value) engine.damp(value) end)

  params:add_control("position", "position", controlspec.new(0.00, 1.00, "lin", 0.01, position, ""))
  params:set_action("position", function(value) engine.pos(value) end)

  params:add_control("model", "model", controlspec.new(0, 5, "lin", 1, model, ""))
  params:set_action("model", function(value) engine.model(value) end)

  params:add_control("polyphony", "polyphony", controlspec.new(1, 4, "lin", 1, poly, ""))
  params:set_action("polyphony", function(value) engine.poly(value) end)

  params:add_control("intern_exciter", "intern_exciter", controlspec.new(0, 1, "lin", 1, intern_exciter, ""))
  params:set_action("intern_exciter", function(value) engine.intern_exciter(value) end)

  --params:add_control("easteregg", "easteregg", controlspec.new(0, 5, "lin", 1, 0, ""))
  --params:set_action("easteregg", function(value) engine.easteregg(value) end)
 
  params:add_control("bypass", "bypass", controlspec.new(0, 1, "lin", 1, bypass, ""))
  params:set_action("bypass", function(value) engine.bypass(value) end)

  
  redraw()
end

function key(n,z)
  if n == 2 and z == 1 then
    engine.bypass(1)
  else
    engine.bypass(0)
  end
  
  -- key actions: n = number, z = state
end

function enc(n,d)
  -- encoder actions: n = number, d = delta
  if n == 1 then
    params:delta("brightness", d)
    --print("bright", string.format("%.2f", params:get("brightness")))
  elseif n == 2 then
    params:delta("position", d)
    --print("position", string.format("%.2f", params:get("position")))
  elseif n == 3 then
    params:delta("structure", d)
    --print("structure", string.format("%.2f", params:get("structure")))
--  elseif n == 4 then
--    params:delta("damping", d)
    --print("damping", string.format("%.2f", params:get("damping")))
  end
  redraw()
end

local function draw_ring(x,y,lev)
  screen.move(x, y)
  screen.level(lev)
  _x = x+64
  _y = y+30
  screen.circle(_x, _y, 18)
  screen.fill()
  screen.circle(_x, _y, 17)
  screen.level(0)
  screen.fill()
 
 screen.stroke()
  
  --screen.fill()
end


function redraw()
  -- screen redraw
  screen.clear()
  screen.aa(0)
  screen.level(15)

  screen.move(8, 42)
  screen.text("bright:  ")
  screen.move(120, 42)
  screen.text_right(string.format("%.2f", params:get("brightness")))

  screen.move(8, 48)
  screen.text("pos:  ")
  screen.move(120, 48)
  screen.text_right(string.format("%.2f", params:get("position")))

  screen.move(8, 54)
  screen.text("struct:  ")
  screen.move(120, 54)
  screen.text_right(string.format("%.2f", params:get("structure")))

--  screen.move(8, 60)
--  screen.text("damp:  ")
--  screen.move(120, 60)
--  screen.text_right(string.format("%.2f", params:get("damping")))

  draw_ring(-20,-5,6)
  draw_ring(30,-9,9)
  draw_ring(0,10,16)
  



  screen.update()
end

function cleanup()
  -- deinitialization
end