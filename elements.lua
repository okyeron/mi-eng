--
--    elements
--
--    v 0.2.0 @okyeron
--
--
--
--
-- Based on the supercollider UGens by Volker Bohm https://github.com/v7b1/mi-UGens
--
--

local UI = require "ui"
local miElements = require "mi-eng/lib/mielements_engine"

engine.name = "MiElements"

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
local space = 0.5
local model = 0
local mul = 1.0
local add = 0
local slide = {}
local midiassignments = {"contour","bow_level","blow_level","strike_level","pit","strength","flow","mallet","geom","bright","bow_timb","blow_timb","strike_timb","damp","pos","space"}
local midichannels = {32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47}

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
    for uis = 1, 16 do
      if midichannels[uis] == d.cc then
        slide[uis]:set_value (d.val/100)
        params:set(midiassignments[uis], d.val/100)
      end
    end
    redraw()

  end 
  
end

function init()
  -- engine initialization
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

-- Add params

  miElements.add_params()
 

  -- UI
  --for uis = 1, 16 do
  --  slide[uis] = UI.Slider.new((uis*6)+20, 18, 4, 36, 0, 0, 1, {0.5})
  --end
  for uis = 1, 4 do
    slide[uis] = UI.Dial.new(uis*16, 12, 10, 0, 0, 1, 0.01)
  end 
  for uis = 5, 6 do
    slide[uis] = UI.Dial.new((uis*16)+16, 12, 10, 0, 0, 1, 0.01)
  end 
  for uis = 7, 10 do
    slide[uis] = UI.Dial.new((uis-7)*20+40, 30, 10, 0, 0, 1, 0.01)
  end 
  for uis = 11, 16 do
    slide[uis] = UI.Dial.new((uis-11)*16+30, 48, 10, 0, 0, 1, 0.01)
  end 

   for uis = 1, 16 do
    slide[uis]:set_value (params:get(midiassignments[uis]))
  end 
 
  redraw()
end

function key(n,z)
  if n == 2 and z == 1 then
    engine.noteOn(pit)
  else
    engine.noteOff(0)
  end

  if n == 3 and z == 1 then
    engine.gate(1)
  else
    engine.gate(0)
  end
  
  -- key actions: n = number, z = state
end

function enc(n,d)
  -- encoder actions: n = number, d = delta
  if n == 1 then
    params:delta("bright", d)
    --print("blow_level", string.format("%.2f", params:get("bright")))
  elseif n == 2 then
    params:delta("pos", d)
    --print("strike_level", string.format("%.2f", params:get("pos")))
  elseif n == 3 then
    params:delta("space", d)
    --print("flow", string.format("%.2f", params:get("space")))
  elseif n == 4 then
    params:delta("damp", d)
    --print("mallet", string.format("%.2f", params:get("damp")))
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

  for uis = 1, 16 do
    slide[uis]:redraw()
  end

  screen.move(8, 8)
  screen.font_face(1)
  screen.font_size(8)
  screen.text("elements  ")

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