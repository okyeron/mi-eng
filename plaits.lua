--
--         plaits
--
--    v 0.1.0 @okyeron
--
-- Based on the supercollider UGens by Volker Bohm https://github.com/v7b1/mi-UGens
--
--

engine.name = "MiPlaits"

--		pitch=60.0, engine=0, harm=0.1, timbre=0.5, morph=0.5, trigger=0.0, level=0, fm_mod=0.0, timb_mod=0.0,
--		morph_mod=0.0, decay=0.5, lpg_colour=0.5, mul=1.0;

-- engines
-- 0:virtual_analog_engine, 1:waveshaping_engine, 2:fm_engine, 3:grain_engine, 
-- 4:additive_engine, 5:wavetable_engine, 6:chord_engine, 7:speech_engine, 
-- 8:swarm_engine, 9:noise_engine, 10:particle_engine, 11:string_engine, 
-- 12:modal_engine, 13:bass_drum_engine, 14:snare_drum_engine, 15:hi_hat_engine


local pitch = 35.0	--(midi note)
local eng = 7	--(0 -- 15)
local harm = 0.25	--(0. -- 1.)
local timbre = 0.5	--(0. -- 1.)
local morph = 0.5	--(0. -- 1.)
local trig = 0	--(A non-zero value triggers)
local level = 0
local fm_mod = 0
local timb_mod = 0
local morph_mod = 0.0
local decay = 0 	--(0. -- 1.)
local lpg_colour = 0	--(0. -- 1.)
local mul	= 0.25 -- (output gain)

local current_note = pitch
local mo = midi.connect() -- defaults to port 1 (which is set in SYSTEM > DEVICES)
mo.event = function(data) 
  d = midi.to_msg(data)
  if d.type == "note_on" then
    --print ("note-on: ".. d.note .. ", velocity:" .. d.vel)
    current_note = d.note
    engine.noteOn(d.note, d.vel)
    redraw()
  elseif d.type == "note_off" then
    engine.noteOff(0)
  end 
  
end

function init()
  -- initialization
  engine.pitch(pitch)
  engine.eng(eng) 
  engine.harm(harm)
  engine.timbre(timbre)
  engine.morph(morph)
  engine.trigger(trig)
  engine.level(level)
  engine.fm_mod(fm_mod)
  engine.timb_mod(timb_mod)
  engine.morph_mod(morph_mod)
  engine.decay(decay)
  engine.lpg_colour(lpg_colour)


  params:add_control("pitch", "pitch", controlspec.new(0, 100, "lin", 1, pitch, ""))
  params:set_action("pitch", function(value) engine.pitch(value) end)

  params:add_control("engine", "engine", controlspec.new(0, 15, "lin", 1, eng, ""))
  params:set_action("engine", function(value) engine.eng(value) end)

  params:add_control("harmonics", "harmonics", controlspec.new(0.00, 1.00, "lin", 0.01, harm, ""))
  params:set_action("harmonics", function(value) engine.harm(value) end)

  params:add_control("timbre", "timbre", controlspec.new(0.00, 1.00, "lin", 0.01, timbre, ""))
  params:set_action("timbre", function(value) engine.timbre(value) end)

  params:add_control("morph", "morph", controlspec.new(0.00, 1.00, "lin", 0.01, morph, ""))
  params:set_action("morph", function(value) engine.morph(value) end)

  params:add_control("trigger", "trigger", controlspec.new(0, 1, "lin", 1, trig, ""))
  params:set_action("trigger", function(value) engine.trigger(value) end)

  params:add_control("level", "level", controlspec.new(1, 15, "lin", 1, level, ""))
  params:set_action("level", function(value) engine.level(value) end)

  params:add_control("fm_mod", "fm_mod", controlspec.new(0, 15, "lin", 1, fm_mod, ""))
  params:set_action("fm_mod", function(value) engine.fm_mod(value) end)
 
  params:add_control("timb_mod", "timb_mod", controlspec.new(0, 15, "lin", 1, timb_mod, ""))
  params:set_action("timb_mod", function(value) engine.timb_mod(value) end)

  params:add_control("morph_mod", "morph_mod", controlspec.new(0, 15, "lin", 1, morph_mod, ""))
  params:set_action("morph_mod", function(value) engine.morph_mod(value) end)

  params:add_control("decay", "decay", controlspec.new(0.00, 1.00, "lin", 0.01, decay, ""))
  params:set_action("decay", function(value) engine.decay(value) end)

  params:add_control("lpg_colour", "lpg_colour", controlspec.new(0.00, 1.00, "lin", 0.01, lpg_colour, ""))
  params:set_action("lpg_colour", function(value) engine.lpg_colour(value) end)
  
  redraw()
end

function key(n,z)
  if n == 2 and z == 1 then
    engine.noteOn(60,64)
  else
    engine.noteOff(0)
  end
  
  -- key actions: n = number, z = state
end

function enc(n,d)
  -- encoder actions: n = number, d = delta
  if n == 1 then
    params:delta("harmonics", d)
    print("harmonics", string.format("%.2f", params:get("harmonics")))
  elseif n == 2 then
    params:delta("timbre", d)
    print("timbre", string.format("%.2f", params:get("timbre")))
  elseif n == 3 then
    params:delta("morph", d)
    print("morph", string.format("%.2f", params:get("morph")))
  elseif n == 4 then
    params:delta("engine", d)
    print("engine", string.format("%.2f", params:get("engine")))
  end
  redraw()
end


function redraw()
  -- screen redraw
  screen.clear()
  screen.aa(0)
  screen.level(15)

  screen.move(8, 8)
  screen.text("plaits  ")


  screen.move(8, 32)
  screen.text("note:  ")
  screen.move(120, 32)
  screen.text_right(current_note)


  screen.move(8, 42)
  screen.text("harmonics:  ")
  screen.move(120, 42)
  screen.text_right(string.format("%.2f", params:get("harmonics")))

  screen.move(8, 48)
  screen.text("timbre:  ")
  screen.move(120, 48)
  screen.text_right(string.format("%.2f", params:get("timbre")))

  screen.move(8, 54)
  screen.text("morph:  ")
  screen.move(120, 54)
  screen.text_right(string.format("%.2f", params:get("morph")))

  screen.move(8, 60)
  screen.text("engine:  ")
  screen.move(120, 60)
  screen.text_right(string.format("%.2f", params:get("engine")))



  screen.update()
end

function cleanup()
  -- deinitialization
end