--
--    macro oscillator p
--
--    v 0.3.2 @okyeron
--
--
--
-- E1: harmonics
-- E2: timbre
-- E3: morph
-- K2: trigger note
--
-- Based on the supercollider Mi-UGens by Volker Bohm <https://github.com/v7b1/mi-UGens>
-- Based on original code by Émilie Gillet <https://github.com/pichenettes/eurorack>
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

local png = 1
local legend = ""
local current_note = pitch
local defualt_midich = 32

function init()

  controls = {}
  controls.pitch = {ui = nil, midi = nil,}
  controls.engine = {ui = nil, midi = nil,}
  controls.harmonics = {ui = nil, midi = nil,}
  controls.timbre = {ui = nil, midi = nil,}
  controls.timb_mod = {ui = nil, midi = nil,}
  controls.morph = {ui = nil, midi = nil,}
  controls.morph_mod = {ui = nil, midi = nil,}
  controls.fm_mod = {ui = nil, midi = nil,}
  controls.level = {ui = nil, midi = nil,}
  controls.decay = {ui = nil, midi = nil,}
  controls.lpg_colour = {ui = nil, midi = nil,}

  -- create midi pmap for 16n
  print ("check pmap")
  local p = norns.pmap.data.engine
  --p = pmap.get("contour")
  if p == nil then
    local i = defualt_midich-1
    for k,v in ipairs(param_assign) do
      controls[k].midi = i + 1 
      norns.pmap.new(k)
      norns.pmap.assign(k,1,1,controls[k].midi) -- (id, dev, ch, cc)
      i = i + 1     
    end
    print ("created default pmap")
    norns.pmap.write()
  else 
    print ("already have pmap")
    for k,v in pairs(norns.pmap.data) do
      controls[k].midi = v.cc
    end
    tab.print (controls.engine)
  end

  
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
    -- ccs
    if d.type == "cc" then
      for k,v in pairs(controls) do
          if controls[k].midi == d.cc then
            --print ("cc: ".. d.cc .. ", val:" .. d.val)
            if k == "pitch" then
              controls[k].ui:set_value (d.val)
              params:set(k, d.val)
            elseif k == "engine" then 
              controls[k].ui:set_value (d.val)
              params:set(k, d.val)
              legend = plaits_engines[params:get("engine")]
              png = params:get("engine")
            elseif k ~= nil then
              params:set(k, d.val/100)
              controls[k].ui:set_value (d.val/100)
            end
         end 
      end  
      redraw()    
    end 

  end

  

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
  
  legend = plaits_engines[params:get("engine")]
  
  -- UI
  local row1 = 11
  local row2 = 29
  local row3 = 47

  local offset = 19
  local col1 = 4
  local col2 = col1+offset
  local col3 = col2+offset
  local col4 = col3+offset
  local col5 = col4+offset
  local col6 = col5+offset
  local col7 = col6+offset-3
  
  controls.pitch.ui = UI.Dial.new(col1, row3, 10, 1, 1, 127, 1, 0, {},"", "pit")
  controls.engine.ui = UI.Dial.new(col7, row1, 10, 1, 1, 16, 1, 0, {},"", "eng")

  controls.harmonics.ui = UI.Dial.new(col1, row1, 10, 0, 0, 1, 0.01, 0, {},"", "harm")
  controls.timbre.ui = UI.Dial.new(col2, row1, 10, 0, 0, 1, 0.01, 0, {},"", "timb")
  controls.timb_mod.ui = UI.Dial.new(col3, row1, 10, 0, 0, 1, 0.01, 0, {},"", "tmod")
  controls.morph.ui = UI.Dial.new(col4, row1, 10, 0, 0, 1, 0.01, 0, {},"", "mrf")
  controls.morph_mod.ui = UI.Dial.new(col5, row1, 10, 0, 0, 1, 0.01, 0, {},"", "mmod")

  controls.fm_mod.ui = UI.Dial.new(col1, row2, 10, 0, 0, 1, 0.01, 0, {},"", "fmod")
  controls.level.ui = UI.Dial.new(col2, row2, 10, 0, 0, 1, 0.01, 0, {},"", "lev")
  controls.decay.ui = UI.Dial.new(col3, row2, 10, 0, 0, 1, 0.01, 0, {},"", "dec")
  controls.lpg_colour.ui = UI.Dial.new(col4, row2, 10, 0, 0, 1, 0.01, 0, {},"", "lpgc")

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
    --print("harmonics", string.format("%.2f", params:get("harmonics")))
    controls.harmonics.ui:set_value (params:get("harmonics"))
    --message = "harmonics"
  elseif n == 2 then
    params:delta("timbre", d)
    --print("timbre", string.format("%.2f", params:get("timbre")))
    controls.timbre.ui:set_value (params:get("timbre"))
    --message = "timbre"
  elseif n == 3 then
    params:delta("morph", d)
    --print("morph", string.format("%.2f", params:get("morph")))
    controls.morph.ui:set_value (params:get("morph"))
    --message = "morph"
  elseif n == 4 then
    params:delta("engine", d)
    --print("engine", string.format("%i", params:get("engine")))
    controls.engine.ui:set_value (params:get("engine"))
    legend = plaits_engines[params:get("engine")]
    png = params:get("engine")
  end
  redraw()
end


function redraw()
  -- screen redraw
  screen.clear()
  screen.aa(0)
  screen.level(15)
  screen.display_png("/home/we/dust/code/mi-eng/lib/waves/".. png .. ".png", 92, 30)

  screen.move(0,0)
  screen.stroke()
  screen.font_face (1)
  screen.font_size (8)

  for k,v in pairs(controls) do
      controls[k].ui:redraw()
  end 

--  for uis = 1, 11 do
    --controls[uis][1]:redraw()
--  end

  screen.move(2, 8)
  screen.text("macro osc p")


  screen.move(94, 62)
  screen.text_right(legend)

  --screen.move(128, 8)
  --screen.text_right(message)

  -- /home/we/dust/code/mi-eng/lib/waves/1.png
  screen.update()
end

function cleanup()
  -- deinitialization
end