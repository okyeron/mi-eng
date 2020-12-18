--
--    modal synth
--
--    v 0.3.4 @okyeron
--
--
--
-- E1: brightness
-- E2: position
-- E3: space
-- K2: trigger note
-- K3: gate
--
-- Based on the supercollider Mi-UGens by Volker Bohm <https://github.com/v7b1/mi-UGens>
-- Based on original code by Émilie Gillet <https://github.com/pichenettes/eurorack>
--
--

local UI = require "ui"
local ModalE = require "mi-eng/lib/ModalE_engine"

engine.name = "ModalE"

-- redefine defaults as needed
local gate = 0 -- (open for positive input values)
local pit = 36 -- (midi note)
local strength = 0.5 --(0 -- 1)
local contour = 0.5
local bow_level = 1
local blow_level = 0
local strike_level = 0
local flow = 0.25
local mallet = 0.5
local bow_timb = 0.4
local blow_timb = 0.6
local strike_timb = 0.5
local geom = 0.4
local bright = 0.2
local damp = 0.5
local pos = 0
local space = 0.25
local model = 0
local mul = 1.0
local add = 0

local param_assign = {"contour","bow_level","blow_level","strike_level","pit","strength","flow","mallet","geom","bright","bow_timb","blow_timb","strike_timb","damp","pos","space"}
local defualt_midich = {32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47}
local defualt_midicc = 32
local current_note = pit

function init()

  -- Add params
  ModalE.add_params()

  -- initialize params  
  params:set("gate", gate)
  params:set("pit", pit)
  params:set("strength", strength)
  params:set("contour", contour)
  params:set("bow_level", bow_level)
  params:set("blow_level", blow_level)
  params:set("strike_level", strike_level)
  params:set("flow", flow)
  params:set("mallet", mallet)
  params:set("bow_timb", bow_timb)
  params:set("blow_timb", blow_timb)
  params:set("strike_timb", strike_timb)
  params:set("geom", geom)
  params:set("bright", bright)
  params:set("damp", damp)
  params:set("pos", pos)
  params:set("model", model)
  params:set("mul", mul)

  -- UI controls
  controls = {}
  controls.contour = {ui = nil, midi = nil,}
  controls.bow_level = {ui = nil, midi = nil,}
  controls.blow_level = {ui = nil, midi = nil,}
  controls.strike_level = {ui = nil, midi = nil,}
  controls.pit = {ui = nil, midi = nil,}
  controls.strength = {ui = nil, midi = nil,}
  controls.flow = {ui = nil, midi = nil,}
  controls.mallet = {ui = nil, midi = nil,}
  controls.geom = {ui = nil, midi = nil,}
  controls.bright = {ui = nil, midi = nil,}
  controls.bow_timb = {ui = nil, midi = nil,}
  controls.blow_timb = {ui = nil, midi = nil,}
  controls.strike_timb = {ui = nil, midi = nil,}
  controls.damp = {ui = nil, midi = nil,}
  controls.pos = {ui = nil, midi = nil,}
  controls.space = {ui = nil, midi = nil,}

  params:add{type = "control", id = "midi_channel", name = "MIDI channel",
    controlspec = controlspec.new(0, 16, "", 1, 0, ""), action = change_midi_channel}

  -- create midi pmap for 16n
  print ("check pmap")
  local p = norns.pmap.data.contour
  --p = pmap.get("contour")
  if p == nil then
    local i = defualt_midicc - 1
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
    --tab.print(norns.pmap.data)
    for k,v in pairs(norns.pmap.data) do
      if controls[k] ~= nil then
        controls[k].midi = v.cc
      end
    end
    --tab.print (controls.space)
  end

  -- MIDI  
  local mo = midi.connect() -- defaults to port 1 (which is set in SYSTEM > DEVICES)
  mo.event = function(data) 
    d = midi.to_msg(data)
    if params:get('midi_channel') == 0 or d.ch == params:get('midi_channel') then
      if d.type == "note_on" then
        --print ("note-on: ".. d.note .. ", velocity:" .. d.vel)
        current_note = d.note
        engine.noteOn(d.note)
        redraw()
      elseif d.type == "note_off" then
        engine.noteOff(0)
      elseif d.type == "cc" then
        --print ("cc: ".. d.cc .. " : " .. d.val)
        for k,v in pairs(controls) do
            if controls[k].midi == d.cc then
              if k == "pit" then 
                params:set(k, d.val)
                controls[k].ui:set_value (d.val)
              else 
                params:set(k, d.val/100)
                controls[k].ui:set_value (d.val/100)
              end
            end 
        end  
      end
      redraw()
    end 
  end
  

  -- UI
  local row1 = 12
  local row2 = 30
  local row3 = 48
  
  local offset = 18
  local col1 = 3
  local col2 = col1+offset
  local col3 = col2+offset
  local col4 = col3+offset
  local col5 = col4+offset
  local col6 = col5+offset
  local col7 = col6+offset


  controls.contour.ui = UI.Dial.new(col1, row1, 10, contour, 0, 1, 0.01, 0, {},"", "cont")
  controls.bow_level.ui = UI.Dial.new(col2, row1, 10, bow_level, 0, 1, 0.01, 0, {},"", "bow")
  controls.blow_level.ui = UI.Dial.new(col3, row1, 10, blow_level, 0, 1, 0.01, 0, {},"", "blow")
  controls.strike_level.ui = UI.Dial.new(col4, row1, 10, strike_level, 0, 1, 0.01, 0, {},"", "strk")
  controls.pit.ui = UI.Dial.new(col5+10, row1, 10, pit, 0, 127, 1, 0, {},"", "pit")
  controls.strength.ui = UI.Dial.new(col6+10, row1, 10, strength, 0, 1, 0.01, 0, {},"", "strn")

  controls.flow.ui = UI.Dial.new(col2+10, row2, 10, flow, 0, 1, 0.01, 0, {},"", "flow")
  controls.mallet.ui = UI.Dial.new(col3+10, row2, 10, mallet, 0, 1, 0.01, 0, {},"", "mal")
  controls.geom.ui = UI.Dial.new(col5, row2, 10, geom, 0, 1, 0.01, 0, {},"", "geo")
  controls.bright.ui = UI.Dial.new(col6, row2, 10, bright, 0, 1, 0.01, 0, {},"", "brit")
  
  controls.bow_timb.ui = UI.Dial.new(col2, row3, 10, bow_timb, 0, 1, 0.01, 0, {},"", "btm")
  controls.blow_timb.ui = UI.Dial.new(col3, row3, 10, blow_timb, 0, 1, 0.01, 0, {},"", "bltm")
  controls.strike_timb.ui = UI.Dial.new(col4, row3, 10, strike_timb, 0, 1, 0.01, 0, {},"", "stim")
  controls.damp.ui = UI.Dial.new(col5, row3, 10, damp, 0, 1, 0.01, 0, {},"", "dam")
  controls.pos.ui = UI.Dial.new(col6, row3, 10, pos, 0, 1, 0.01, 0, {},"", "pos")
  controls.space.ui = UI.Dial.new(col7, row3, 10, space, 0, 1, 0.01, 0, {},"", "spc")


  for k,v in pairs(controls) do
     controls[k].ui:set_value (params:get(k))
  end 
    
  redraw()
end

function key(n,z)
  -- key actions: n = number, z = state
  if n == 2 and z == 1 then
    engine.noteOn(pit)
    --print('noteon')
  else
    engine.noteOff(0)
  end

  if n == 3 and z == 1 then
    engine.gate(1)
    --print('gate')
  else
    engine.gate(0)
  end
  
end

function enc(n,d)
  -- encoder actions: n = number, d = delta
  if n == 1 then
    params:delta("bright", d)
    --print("blow_level", string.format("%.2f", params:get("bright")))
    controls.bright.ui:set_value (params:get("bright"))

  elseif n == 2 then
    params:delta("pos", d)
    --print("strike_level", string.format("%.2f", params:get("pos")))
     controls.pos.ui:set_value (params:get("pos"))
     
  elseif n == 3 then
    params:delta("space", d)
    --print("flow", string.format("%.2f", params:get("space")))
     controls.space.ui:set_value (params:get("space"))
     
  end
  redraw()
end

function change_midi_channel(d)
  -- shush everything
  engine.noteOff(0)
end

function redraw()
  -- screen redraw
  screen.clear()
  screen.aa(1)
  screen.level(15)

  screen.move(0,0)
  screen.stroke()

 for k,v in pairs(controls) do
    controls[k].ui:redraw()
  end 

  screen.move(3, 8)
  screen.font_face(1)
  screen.font_size(8)
  screen.text("modal synth ")

  --screen.font_face(1)
  --screen.font_size(8)
  --screen.move(90, 8)
  --screen.text("note:  ")
  --screen.move(120, 8)
  --screen.text_right(current_note)


  screen.update()
end

function cleanup()
  -- deinitialization
end