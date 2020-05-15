--
--    macro oscillator p
--
--    v 0.3.0 @okyeron
--
--
--
--
--
-- Based on the supercollider UGens by Volker Bohm https://github.com/v7b1/mi-UGens
--
--

local UI = require "ui"
local MacroP = require "mi-eng/lib/MacroP_engine"

engine.name = "MacroP"

--		pitch=60.0, engine=0, harm=0.1, timbre=0.5, morph=0.5, trigger=0.0, level=0, fm_mod=0.0, timb_mod=0.0,
--		morph_mod=0.0, decay=0.5, lpg_colour=0.5, mul=1.0;

-- engines
-- 0:virtual_analog_engine, 1:waveshaping_engine, 2:fm_engine, 3:grain_engine, 
-- 4:additive_engine, 5:wavetable_engine, 6:chord_engine, 7:speech_engine, 
-- 8:swarm_engine, 9:noise_engine, 10:particle_engine, 11:string_engine, 
-- 12:modal_engine, 13:bass_drum_engine, 14:snare_drum_engine, 15:hi_hat_engine

local png = 1

local pitch = 35.0	--(midi note)
local eng = 1	--(0 -- 15)
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
--local mul	= 0.25 -- (output gain)

local param_assign = {"pitch","engine","harmonics","timbre","timb_mod","morph","morph_mod","fm_mod","level","decay","lpg_colour","trigger"}

local plaits_engines = {"virtual analog","waveshaping","fm","grain","additive","wavetable","chord","speech","swarm","noise","particle","string","modal","bass drum","snare drum","hi hat"}

controls = {}
controls.pitch = {}
controls.engine = {}
controls.harmonics = {}
controls.timbre = {}
controls.timb_mod = {}
controls.morph = {}
controls.morph_mod = {}
controls.fm_mod = {}
controls.level = {}
controls.decay = {}
controls.lpg_colour = {}


local message = ""

local current_note = pitch
local mo = midi.connect() -- defaults to port 1 (which is set in SYSTEM > DEVICES)
mo.event = function(data) 
  d = midi.to_msg(data)
  if d.type == "note_on" then
    print ("note-on: ".. d.note .. ", velocity:" .. d.vel)
    current_note = d.note
    engine.noteOn(d.note, d.vel)
    redraw()
  elseif d.type == "note_off" then
    engine.noteOff(0)
  end 
  
end

function init()

  -- Add params
  MacroP.add_params()

  -- initialize params  
  params:set("pitch", pitch)
  params:set("engine",eng)
  params:set("harmonics",harm)
  params:set("timbre",timbre)
  params:set("timb_mod",timb_mod)
  params:set("morph",morph)
  params:set("morph_mod",morph_mod)
  params:set("fm_mod",fm_mod)
  params:set("trigger",trig)
  params:set("level",level)
  params:set("decay",decay)
  params:set("lpg_colour",lpg_colour)
  
  message = "engine: " .. plaits_engines[params:get("engine")]
  
  -- UI
  local row1 = 12
  local row2 = 30
  local row3 = 48

  local col1 = 3
  local col2 = 20
  local col3 = 36
  local col4 = 53
  local col5 = 70
  
  controls.pitch.ui = UI.Dial.new(col1, row3, 10, 1, 1, 127, 1)
  controls.engine.ui = UI.Dial.new(70, row3, 10, 1, 1, 16, 1)

  controls.harmonics.ui = UI.Dial.new(col1, row1, 10, 0, 0, 1, 0.01)
  controls.timbre.ui = UI.Dial.new(col2, row1, 10, 0, 0, 1, 0.01)
  controls.timb_mod.ui = UI.Dial.new(col3, row1, 10, 0, 0, 1, 0.01)
  controls.morph.ui = UI.Dial.new(col4, row1, 10, 0, 0, 1, 0.01)
  controls.morph_mod.ui = UI.Dial.new(col5, row1, 10, 0, 0, 1, 0.01)

  controls.fm_mod.ui = UI.Dial.new(col1, row2, 10, 0, 0, 1, 0.01)
  controls.level.ui = UI.Dial.new(col2, row2, 10, 0, 0, 1, 0.01)
  controls.decay.ui = UI.Dial.new(col3, row2, 10, 0, 0, 1, 0.01)
  controls.lpg_colour.ui = UI.Dial.new(col4, row2, 10, 0, 0, 1, 0.01)

  for k,v in pairs(controls) do
     controls[k].ui:set_value (params:get(k))
  end  
  
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
    controls.harmonics.ui:set_value (params:get("harmonics"))
    message = "harmonics"
  elseif n == 2 then
    params:delta("timbre", d)
    print("timbre", string.format("%.2f", params:get("timbre")))
    controls.timbre.ui:set_value (params:get("timbre"))
    message = "timbre"
  elseif n == 3 then
    params:delta("morph", d)
    print("morph", string.format("%.2f", params:get("morph")))
    controls.morph.ui:set_value (params:get("morph"))
    message = "morph"
  elseif n == 4 then
    params:delta("engine", d)
    print("engine", string.format("%i", params:get("engine")))
    controls.engine.ui:set_value (params:get("engine"))
    message = "engine: " .. plaits_engines[params:get("engine")]
    png = params:get("engine")
  end
  redraw()
end


function redraw()
  -- screen redraw
  screen.clear()
  screen.aa(0)
  screen.level(15)
  screen.display_png("/home/we/dust/code/mi-eng/lib/waves/".. png .. ".png", 90, 15)

  screen.move(0,0)
  screen.stroke()

  for k,v in pairs(controls) do
      controls[k].ui:redraw()
  end 

--  for uis = 1, 11 do
    --controls[uis][1]:redraw()
--  end


  screen.move(2, 8)
  screen.text("macro osc p ")



  screen.move(128, 8)
  screen.text_right(message)

  -- /home/we/dust/code/mi-eng/lib/waves/1.png
  screen.update()
end

function cleanup()
  -- deinitialization
end