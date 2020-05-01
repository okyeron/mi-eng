--
--         elements
--
--    v 0.1.0 @okyeron
--
-- Based on the supercollider UGens by Volker Bohm https://github.com/v7b1/mi-UGens
--
--

engine.name = "MiElements"

    --blow_in=0, strike_in=0, gate=0, pit=48, strength=0.5, contour=0.2, bow_level=0,
		--blow_level=0, strike_level=0, flow=0.5, mallet=0.5, bow_timb=0.5, blow_timb=0.5,
		--strike_timb=0.5, geom=0.25, bright=0.5, damp=0.7, pos=0.2, space=0.3, model=0,
		--mul=1.0, add=0;

local gate = 0 -- (open for positive input values)
local pit = 48 -- (midi note)
local strength = 0.5 --(0 -- 1)
local contour = 0.2
local bow_level = 0
local blow_level = 0
local strike_level = 0
local flow = 0.5
local mallet = 0.5
local bow_timb = 0.5
local blow_timb = 0.5
local strike_timb = 0.5
local geom = 0.25
local bright = 0.5
local damp = 0.7
local pos = 0.2
local space = 0.3
local model = 0
local mul = 1.0
local add = 0


local current_note = pit
local mo = midi.connect() -- defaults to port 1 (which is set in SYSTEM > DEVICES)
mo.event = function(data) 
  d = midi.to_msg(data)
  if d.type == "note_on" then
    --print ("note-on: ".. d.note .. ", velocity:" .. d.vel)
    current_note = d.note
    engine.noteOn(d.note)
    redraw()
  elseif d.type == "note_off" then
    engine.noteOff(0)
  end 
  
end

function init()
  -- initialization
  engine.gate(gate)
  engine.pit(pit)
  engine.strength(strength)
  engine.contour(contour)
  engine.bow_level(bow_level)
  engine.blow_level(blow_level)
  engine.strike_level(strike_level)
  engine.flow(flow)
  engine.mallet(mallet)
  engine.bow_timb(bow_timb)
  engine.blow_timb(blow_timb)
  engine.strike_timb(strike_timb)
  engine.geom(geom)
  engine.bright(bright)
  engine.damp(damp)
  engine.pos(pos)
  engine.space(space)
  engine.model(model)
  engine.mul(mul)


  params:add_control("gate", "gate", controlspec.new(0, 1, "lin", 1, gate, ""))
  params:set_action("gate", function(value) engine.gate(value) end)

  params:add_control("pitch", "pitch", controlspec.new(0, 100, "lin", 1, pitch, ""))
  params:set_action("pitch", function(value) engine.pit(value) end)

  params:add_control("strength", "strength", controlspec.new(0.00, 1.00, "lin", 0.01, strength, ""))
  params:set_action("strength", function(value) engine.strength(value) end)

  params:add_control("contour", "contour", controlspec.new(0.00, 1.00, "lin", 0.01, contour, ""))
  params:set_action("contour", function(value) engine.contour(value) end)

  params:add_control("bow_level", "bow_level", controlspec.new(0.00, 1.00, "lin", 0.01, bow_level, ""))
  params:set_action("bow_level", function(value) engine.bow_level(value) end)

  params:add_control("blow_level", "blow_level", controlspec.new(0.00, 1.00, "lin", 0.01, blow_level, ""))
  params:set_action("blow_level", function(value) engine.blow_level(value) end)

  params:add_control("strike_level", "strike_level", controlspec.new(0.00, 1.00, "lin", 0.01, strike_level, ""))
  params:set_action("strike_level", function(value) engine.strike_level(value) end)

  params:add_control("flow", "flow", controlspec.new(0.00, 1.00, "lin", 0.01, flow, ""))
  params:set_action("flow", function(value) engine.flow(value) end)
 
  params:add_control("mallet", "mallet", controlspec.new(0.00, 1.00, "lin", 0.01, mallet, ""))
  params:set_action("mallet", function(value) engine.mallet(value) end)

  params:add_control("bow_timb", "bow_timb", controlspec.new(0.00, 1.00, "lin", 0.01, bow_timb, ""))
  params:set_action("bow_timb", function(value) engine.bow_timb(value) end)

  params:add_control("blow_timb", "blow_timb", controlspec.new(0.00, 1.00, "lin", 0.01, blow_timb, ""))
  params:set_action("blow_timb", function(value) engine.blow_timb(value) end)

  params:add_control("strike_timb", "strike_timb", controlspec.new(0.00, 1.00, "lin", 0.01, strike_timb, ""))
  params:set_action("strike_timb", function(value) engine.strike_timb(value) end)
  
  params:add_control("geom", "geom", controlspec.new(0.00, 1.00, "lin", 0.01, geom, ""))
  params:set_action("geom", function(value) engine.geom(value) end)
  
  params:add_control("bright", "bright", controlspec.new(0.00, 1.00, "lin", 0.01, bright, ""))
  params:set_action("bright", function(value) engine.bright(value) end)
  
  params:add_control("damp", "damp", controlspec.new(0.00, 1.00, "lin", 0.01, damp, ""))
  params:set_action("damp", function(value) engine.damp(value) end)
  
  params:add_control("pos", "pos", controlspec.new(0.00, 1.00, "lin", 0.01, pos, ""))
  params:set_action("pos", function(value) engine.pos(value) end)
  
  params:add_control("space", "space", controlspec.new(0.00, 1.00, "lin", 0.01, space, ""))
  params:set_action("space", function(value) engine.space(value) end)
  
  params:add_control("model", "model", controlspec.new(0.00, 1.00, "lin", 0.01, model, ""))
  params:set_action("model", function(value) engine.model(value) end)

  params:add_control("mul", "mul", controlspec.new(0.00, 1.00, "lin", 0.01, mul, ""))
  params:set_action("mul", function(value) engine.mul(value) end)
  
  redraw()
end

function key(n,z)
  if n == 2 and z == 1 then
    engine.noteOn(pit)
  else
    engine.noteOff(0)
  end
  
  -- key actions: n = number, z = state
end

function enc(n,d)
  -- encoder actions: n = number, d = delta
  if n == 1 then
    params:delta("geom", d)
    print("geom", string.format("%.2f", params:get("geom")))
  elseif n == 2 then
    params:delta("bright", d)
    print("bright", string.format("%.2f", params:get("bright")))
  elseif n == 3 then
    params:delta("space", d)
    print("space", string.format("%.2f", params:get("space")))
  elseif n == 4 then
    params:delta("contour", d)
    print("contour", string.format("%.2f", params:get("contour")))
  end
  redraw()
end


function redraw()
  -- screen redraw
  screen.clear()
  screen.aa(0)
  screen.level(15)

  screen.move(8, 8)
  screen.text("elements  ")


  screen.move(8, 32)
  screen.text("note:  ")
  screen.move(120, 32)
  screen.text_right(current_note)


  screen.move(8, 42)
  screen.text("geom:  ")
  screen.move(120, 42)
  screen.text_right(string.format("%.2f", params:get("geom")))

  screen.move(8, 48)
  screen.text("bright:  ")
  screen.move(120, 48)
  screen.text_right(string.format("%.2f", params:get("bright")))

  screen.move(8, 54)
  screen.text("space:  ")
  screen.move(120, 54)
  screen.text_right(string.format("%.2f", params:get("space")))

  screen.move(8, 60)
  screen.text("contour:  ")
  screen.move(120, 60)
  screen.text_right(string.format("%.2f", params:get("contour")))



  screen.update()
end

function cleanup()
  -- deinitialization
end