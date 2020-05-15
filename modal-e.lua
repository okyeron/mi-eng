--
--    modal synth
--
--    v 0.3.0 @okyeron
--
--
--
--
-- Based on the supercollider UGens by Volker Bohm https://github.com/v7b1/mi-UGens
--
--

local UI = require "ui"
local ModalE = require "mi-eng/lib/ModalE_engine"

engine.name = "ModalE"

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

local midiassignments = {"contour","bow_level","blow_level","strike_level","pit","strength","flow","mallet","geom","bright","bow_timb","blow_timb","strike_timb","damp","pos","space"}
--local midichannels = {32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47}

controls = {}
controls.contour = {ui = nil, midi = 32,}
controls.bow_level = {ui = nil, midi = 33,}
controls.blow_level = {ui = nil, midi = 34,}
controls.strike_level = {ui = nil, midi = 35,}
controls.pit = {ui = nil, midi = 36,}
controls.strength = {ui = nil, midi = 37,}
controls.flow = {ui = nil, midi = 38,}
controls.mallet = {ui = nil, midi = 39,}
controls.geom = {ui = nil, midi = 40,}
controls.bright = {ui = nil, midi = 41,}
controls.bow_timb = {ui = nil, midi = 42,}
controls.blow_timb = {ui = nil, midi = 43,}
controls.strike_timb = {ui = nil, midi = 44,}
controls.damp = {ui = nil, midi = 45,}
controls.pos = {ui = nil, midi = 46,}
controls.space = {ui = nil, midi = 47,}


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

    redraw()

  end 
end

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

  -- UI
  local row1 = 12
  local row2 = 30
  local row3 = 48
  
  controls.contour.ui = UI.Dial.new(5, row1, 10, contour, 0, 1, 0.01)
  controls.bow_level.ui = UI.Dial.new(5+18, row1, 10, bow_level, 0, 1, 0.01)
  controls.blow_level.ui = UI.Dial.new(5+(18*2), row1, 10, blow_level, 0, 1, 0.01)
  controls.strike_level.ui = UI.Dial.new(5+(18*3), row1, 10, strike_level, 0, 1, 0.01)
  controls.pit.ui = UI.Dial.new(15+(18*4), row1, 10, pit, 0, 127, 1)
  controls.strength.ui = UI.Dial.new(15+(18*5), row1, 10, strength, 0, 1, 0.01)

  controls.flow.ui = UI.Dial.new(15, row2, 10, flow, 0, 1, 0.01)
  controls.mallet.ui = UI.Dial.new(15+18, row2, 10, mallet, 0, 1, 0.01)
  controls.geom.ui = UI.Dial.new(30+(18*2), row2, 10, geom, 0, 1, 0.01)
  controls.bright.ui = UI.Dial.new(30+(18*3), row2, 10, bright, 0, 1, 0.01)
  
  controls.bow_timb.ui = UI.Dial.new(5, row3, 10, bow_timb, 0, 1, 0.01)
  controls.blow_timb.ui = UI.Dial.new(5+18, row3, 10, blow_timb, 0, 1, 0.01)
  controls.strike_timb.ui = UI.Dial.new(5+(18*2), row3, 10, strike_timb, 0, 1, 0.01)
  controls.damp.ui = UI.Dial.new(5+(18*3), row3, 10, damp, 0, 1, 0.01)
  controls.pos.ui = UI.Dial.new(5+(18*4), row3, 10, pos, 0, 1, 0.01)
  controls.space.ui = UI.Dial.new(5+(18*5), row3, 10, space, 0, 1, 0.01)


  for k,v in pairs(controls) do
     controls[k].ui:set_value (params:get(k))
  end 
  
  -- create midi pmap for 16n
  if norns.pmap.data[1] == nil then
    for k,v in pairs(controls) do
      norns.pmap.new(k)
      norns.pmap.assign(k,1,1,controls[k].midi) 
    end
    norns.pmap.write()
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
     
  elseif n == 4 then
    params:delta("damp", d)
    --print("mallet", string.format("%.2f", params:get("damp")))
     controls.damp.ui:set_value (params:get("damp"))
  end
  redraw()
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

  screen.move(8, 8)
  screen.font_face(1)
  screen.font_size(8)
  screen.text("modal synth  ")

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