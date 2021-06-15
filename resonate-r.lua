--
--    ResonateR
--
--    v 0.3.4 @okyeron
--
--
-- E1: structure
-- E2: brightness
-- E3: position
-- K2: bypass
-- K3: trig
--
-- Based on the supercollider Mi-UGens by Volker Bohm <https://github.com/v7b1/mi-UGens>
-- Based on original code by Émilie Gillet <https://github.com/pichenettes/eurorack>
--
--

local UI = require "ui"
local ResonateR = require "mi-eng/lib/ResonateR_engine"

engine.name = "ResonateR"

local message = ""
local legend = ""

local pitch = 32.0
local struct = 0.5
local bright = 0.3
local damp = 0.25
local position = 0.5
local model = 0
local poly = 4
local intern_exciter = 0
local bypass = 0
local easteregg = 0
local current_note = pitch
local pitch_from_midi = 0
local ping_resonator = 0

--    arg in=0, trig=0, pit=60.0, struct=0.25, bright=0.5, damp=0.7, pos=0.25, model=0, poly=1,
--    intern_exciter=0, easteregg=0, bypass=0, mul=1.0, add=0;


local param_assign = {"pitch","structure","brightness","damping","position","model","polyphony","intern_exciter","bypass","easteregg"}
local rings_models = {"Modal Resonator","Sympathetic String","Mod/Inharm String","2-Op Fm Voice","Sympth Str Quant","String And Reverb"}
local rings_egg_models = {"FX Formant","FX Chorus","FX Reverb","FX Formant","FX Ensemble","FX Reverb"}

local current_note = pitch
local default_midicc = 32

function init()
  -- UI controls
  controls = {}
  controls.pitch = {ui = nil, midi = nil,}
  controls.structure = {ui = nil, midi = nil,}
  controls.brightness = {ui = nil, midi = nil,}
  controls.damping = {ui = nil, midi = nil,}
  controls.position = {ui = nil, midi = nil,}
  controls.model = {ui = nil, midi = nil,}
  controls.polyphony = {ui = nil, midi = nil,}
  controls.intern_exciter = {ui = nil, midi = nil,}
  controls.bypass = {ui = nil, midi = nil,}
  controls.easteregg = {ui = nil, midi = nil,}

  -- create midi pmap for 16n
  print ("check pmap")
  local p = norns.pmap.data.pitch

  if p == nil then
    local i = default_midicc - 1
    for k,v in ipairs(param_assign) do
      controls[v].midi = i + 1 
      norns.pmap.new(v)
      norns.pmap.assign(v,1,1,controls[v].midi) -- (id, dev, ch, cc)
      i = i + 1 
    end
    print ("created default pmap")
    norns.pmap.write()
  else 
    --print ("already have pmap")
    for k,v in pairs(norns.pmap.data) do
      if controls[k] ~= nil then
        controls[k].midi = v.cc
      end
    end
    --tab.print (controls.pitch)
  end


  -- MIDI
  local mo = midi.connect() -- defaults to port 1 (which is set in SYSTEM > DEVICES)
  mo.event = function(data) 
    d = midi.to_msg(data)
    if params:get('pitch_from_midi') == 1 then
      if d.type == "note_on" then
        print ("note-on: ".. d.note .. ", velocity:" .. d.vel)
        current_note = d.note
        params:set("pitch", d.note)
        controls.pitch.ui:set_value (d.note)
        if params:get("ping_resonator") == 1 then
          engine.noteOn(d.note)
        end
        redraw()
      elseif d.type == "note_off" and params:get("ping_resonator") == 1 then
        engine.noteOff(0)
      end 
    end
  end


  -- Add params
  ResonateR.add_params()

    -- initialization
  params:set("pitch", pitch)
  params:set("structure", struct)
  params:set("brightness", bright)
  params:set("damping", damp)
  params:set("position", position)
  params:set("model", model)
  params:set("polyphony", poly)
  params:set("intern_exciter", intern_exciter)
  params:set("bypass", bypass)
  params:set("easteregg", easteregg)

  print(rings_models[params:get("model")+1])
  legend = rings_models[params:get("model")+1]
  
  
  -- UI
  local row1 = 11
  local row2 = 22
  local row3 = 47

  local offset = 20
  local col1 = 5
  local col2 = col1+offset
  local col3 = col2+offset
  local col4 = col3+offset
  local col5 = col4+offset
  local col6 = col5+offset
  local col7 = col6+offset

  local col8 = 116
  
  controls.pitch.ui = UI.Dial.new(col8, row3, 10, 1, 1, 100, 1)
  controls.model.ui = UI.Dial.new(112, row1, 10, 0, 1, #rings_models, 0.1, 0, {},"", "mode")

  controls.structure.ui =  UI.Dial.new(col1, row1, 10, 0, 0, 1, 0.01, 0, {}, "", "struc")
  controls.brightness.ui = UI.Dial.new(col2, row2, 10, 0, 0, 1, 0.01, 0, {}, "", "bright")
  controls.damping.ui =    UI.Dial.new(col3, row1, 10, 0, 0, 1, 0.01, 0, {}, "", "damp")
  controls.position.ui =   UI.Dial.new(col4, row2, 10, 0, 0, 1, 0.01, 0, {}, "", "pos")

  controls.polyphony.ui =   UI.Dial.new(col1, row3, 10, 1, 1, 4, 0.01, 0, {},"", "poly")
  controls.intern_exciter.ui = UI.Dial.new(col2, row3, 10, 0, 0, 1, 0.01, 0, {},"", "exci")
  controls.bypass.ui =      UI.Dial.new(col3, row3, 10, 0, 0, 1, 0.01, 0, {},"", "byp")
  controls.easteregg.ui =   UI.Dial.new(col4, row3, 10, 0, 0, 1, 0.01, 0, {},"", "egg")

 
  for k,v in pairs(controls) do
     controls[k].ui:set_value (params:get(k))
  end  
  initialisation = 0
  redraw()
end


function update_ui(dial) -- called by params set_action
  if initialisation == 0 then -- to avoid function call on init
    if dial == "model" then
      controls[dial].ui:set_value (params:get(dial)+1)
      if easteregg == 0 then -- scan through correct models
        legend = rings_models[params:get(dial)+ 1]
      else
        legend = rings_egg_models[params:get(dial)+1]
      end
    elseif dial == "easteregg" then -- switch legend to equivalent model
      --print(params:get(dial))
      if params:get(dial) >= 1 then
        easteregg = 1
        legend = rings_egg_models[params:get("model")+1]
        controls[dial].ui:set_value (params:get(dial))
      else
        easteregg = 0
        legend = rings_models[params:get(dial)+ 1]
        controls[dial].ui:set_value (params:get(dial))
      end
    elseif dial == "bypass" then
      if params:get(dial) == 1 then
        engine.bypass(1)
      else
        engine.bypass(0)
      end
      controls[dial].ui:set_value (params:get(dial))
    else
      controls[dial].ui:set_value (params:get(dial))
    end
    redraw()
  end
end

function key(n,z)
  if n == 2 and z == 1 then
    engine.bypass(1)
    print("bypass on")
  elseif n == 2 and z == 0 then
    engine.bypass(0)
    print("bypass off")
  end
  if n == 3 and z == 1 then
    engine.trig(1)
    print("trig on")
  elseif n == 3 and z == 0 then
    engine.trig(0)
    print("trig off")
  end
  
  -- key actions: n = number, z = state
end

function enc(n,d)
  -- encoder actions: n = number, d = delta
  if n == 1 then
    params:delta("structure", d)
    controls.structure.ui:set_value (params:get("structure"))
    --print("structure", string.format("%.2f", params:get("structure")))
  elseif n == 2 then
    params:delta("brightness", d)
    controls.brightness.ui:set_value (params:get("brightness"))
    --print("bright", string.format("%.2f", params:get("brightness")))
  elseif n == 3 then
    params:delta("position", d)
    controls.position.ui:set_value (params:get("position"))
    --print("position", string.format("%.2f", params:get("position")))
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

  draw_ring(-20,-5,1)
  draw_ring(25,-8,1)
  draw_ring(0,10,1)

  screen.font_face (1)
  screen.font_size (8)
  screen.level(15)
  
  screen.move(0,0)
  screen.stroke()

  for k,v in pairs(controls) do
      controls[k].ui:redraw()
  end 

  screen.move(2, 8)
  screen.text("resonate-r")

  screen.move(128, 8)
  screen.text_right(legend)


  screen.update()
end

function cleanup()
  -- deinitialization
end