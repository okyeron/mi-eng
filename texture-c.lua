--
--       fuwa fuwa
--       --     ---
--    ----------------
--     --  ----  ---
--      -   --    -
--    v 0.3.4 @okyeron
--
--
-- E1: position
-- E2: grainsize
-- E3: density
-- K2: freeze
-- K3: trig
--
-- Based on the supercollider Mi-UGens by Volker Bohm <https://github.com/v7b1/mi-UGens>
-- Based on original code by Émilie Gillet <https://github.com/pichenettes/eurorack>
--
-- lfo's by @justmat
--

local UI = require "ui"
local TextureC = include "mi-eng/lib/TextureC_engine"

engine.name = "TextureC"

local pitch = 0 -- (+-48.0)
local position = 0.6 -- (0 -- 1)
local size = 0.2 -- (0 -- 1)
local dens = 0.25 -- (0 -- 1)
local texture = 0.1 -- (0 -- 1)
local drywet = 0.5 -- (0 -- 1)
local in_gain = 2 -- 0.125 -- 8
local spread = 1 -- (0 -- 1)
local rvb = 0.2 -- (0 -- 1)
local feedback = 0.2 -- (0 -- 1)
local freeze = 0 -- (0 -- 1)
local mode = 0 -- (0 -- 3)
local lofi = 0 -- (0 -- 1)
local trig = 0 -- (0 -- 1)

local controls = {}
local param_assign = {"pitch","position","grainsize","density","texture","drywet","in_gain","reverb","spread","feedback","freeze","mode","lofi"}
local clouds_mode = {"Granular","Stretch","Looping_Delay","Spectral"}
local legend = ""
local defualt_midicc = 32

function init()

  -- Add params
  TextureC.add_params()
  TextureC.add_lfo_params()

  -- initialize params
  params:set("pitch", pitch)
  params:set("position",position)
  params:set("grainsize",size)
  params:set("density",dens)
  params:set("texture",texture)
  params:set("drywet",drywet)
  params:set("in_gain",in_gain)
  params:set("reverb",rvb)
  params:set("spread",spread)
  params:set("feedback",feedback)
  params:set("freeze",freeze)
  params:set("mode",mode)
  params:set("lofi",lofi)
  params:set("trig",trig)

  legend = clouds_mode[params:get("mode")+1]

  -- UI controls
  controls = {}
  controls.pitch = {ui = nil, midi = nil,}
  controls.position = {ui = nil, midi = nil,}
  controls.grainsize = {ui = nil, midi = nil,}
  controls.density = {ui = nil, midi = nil,}
  controls.texture = {ui = nil, midi = nil,}
  controls.drywet = {ui = nil, midi = nil,}
  controls.in_gain = {ui = nil, midi = nil,}
  controls.reverb = {ui = nil, midi = nil,}
  controls.spread = {ui = nil, midi = nil,}
  controls.feedback = {ui = nil, midi = nil,}
  controls.freeze = {ui = nil, midi = nil,}
  controls.mode = {ui = nil, midi = nil,}
  controls.lofi = {ui = nil, midi = nil,}

  params:add{type = "control", id = "midi_channel", name = "MIDI channel",
    controlspec = controlspec.new(0, 16, "", 1, 0, ""), action = change_midi_channel}

  -- create midi pmap for 16n
  print ("check pmap")
  local p = norns.pmap.data.pitch
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
    if params:get('midi_channel') == 0 or d.ch == params:get('midi_channel') then
      if d.type == "note_on" then
        --print ("note-on: ".. d.note .. ", velocity:" .. d.vel)
        current_note = d.note
        params:set("pitch",d.note)
        params:set("trig",1)
        redraw()
      elseif d.type == "note_off" then
        params:set("trig",0)
      elseif d.type == "cc" then
        --print ("cc: ".. d.cc .. " : " .. d.val)
        for k,v in pairs(controls) do
            if controls[k].midi == d.cc then
              if k == "pitch" then 
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

  local offset = 19
  local col1 = 3
  local col2 = col1+offset
  local col3 = col2+offset
  local col4 = col3+offset
  local col5 = col4+offset
  local col6 = col5+offset
  local col7 = col6+offset

  local col8 = 116
  
  controls.pitch.ui = UI.Dial.new(col1, row1, 10, 0, 0, 1, 0.01, 0, {},"", "pit")
  controls.position.ui = UI.Dial.new(col2, row1, 10, 0, 0, 1, 0.01, 0, {},"", "pos")
  controls.grainsize.ui = UI.Dial.new(col3, row1, 10, 0, 0, 1, 0.01, 0, {},"", "size")
  controls.density.ui = UI.Dial.new(col4, row1, 10, 0, 0, 1, 0.01, 0, {},"", "den")
  controls.texture.ui = UI.Dial.new(col5, row1, 10, 0, 0, 1, 0.01, 0, {},"", "tex")

  controls.drywet.ui = UI.Dial.new(col1, row2, 10, 0, 0, 1, 0.01, 0, {},"", "d-w")
  controls.in_gain.ui = UI.Dial.new(col2, row2, 10, 0, 0, 1, 0.01, 0, {},"", "gain")
  controls.reverb.ui = UI.Dial.new(col3, row2, 10, 0, 0, 1, 0.01, 0, {},"", "verb")
  controls.spread.ui = UI.Dial.new(col4, row2, 10, 0, 0, 1, 0.01, 0, {},"", "sprd")
  controls.feedback.ui = UI.Dial.new(col5, row2, 10, 0, 0, 1, 0.01, 0, {},"", "fb")

  controls.freeze.ui = UI.Dial.new(col1, row3, 10, 0, 0, 1, 1, 0, {},"", "frz")
  controls.lofi.ui = UI.Dial.new(col2, row3, 10, 0, 0, 1, 1, 0, {},"", "lofi")
  controls.mode.ui = UI.Dial.new(col4+10, row3, 10, 0, 0, 3, 1, 0, {},"", "mode")

  for k,v in pairs(controls) do
     controls[k].ui:set_value (params:get(k))
  end  
  
  
  redraw()
end

function key(n,z)
  -- key actions: n = number, z = state
  if n == 2 and z == 1 then
    engine.freeze(1)
  else
    engine.freeze(0)
  end
   if n == 3 and z == 1 then
    engine.trig(1)
  else
    engine.trig(0)
  end
  
end

function enc(n,d)
  -- encoder actions: n = number, d = delta
  if n == 1 then
    params:delta("position", d)
    controls.position.ui:set_value (params:get("position"))
    --print("position",string.format("%.2f", params:get("position")))
  elseif n == 2 then
    params:delta("grainsize", d)
    controls.grainsize.ui:set_value (params:get("grainsize"))
  elseif n == 3 then
    params:delta("density", d)
    controls.density.ui:set_value (params:get("density"))
    --print("density",string.format("%.2f", params:get("density")))
--  elseif n == 4 then
--    params:delta("drywet", d)
    --print("density",string.format("%.2f", params:get("drywet")))
  end
  redraw()
end

local function draw_cloud(x,y,lev)
  screen.move(x, y)
  screen.level(lev)
  screen.circle(x+44, y+30, 13)
  screen.fill()
  screen.circle(x+65, y+26, 18)
  screen.fill()
  screen.circle(x+80, y+30, 14)
  screen.fill()
  screen.level(0)
  screen.arc(x+80, y+30, 14, -2, -1)
  screen.move(x+66, y+47)
  screen.arc(x+65, y+26, 18, 1, 2.7)
  screen.stroke()
end

function change_midi_channel(d)
  -- shush everything. But how?
end

function redraw()
  -- screen redraw
  screen.clear()
  screen.aa(0)
  draw_cloud(34,20,2) -- bottom
  draw_cloud(48,-6,3) -- top
  draw_cloud(19,9,1) -- middle

  screen.level(15)

  screen.move(0,0)
  screen.stroke()

  for k,v in pairs(controls) do
      controls[k].ui:redraw()
  end 

  screen.font_face(1)
  screen.font_size(8)

  screen.move(3, 8)

  screen.text("texture-c")

  screen.move(128, 63)
  screen.text_right(legend)

  screen.update()
end

function cleanup()
  -- deinitialization
end
