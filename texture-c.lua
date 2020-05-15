--
--       fuwa fuwa
--       --     ---
--    ----------------
--     --  ----  ---
--      -   --    -
--    v 0.3.0 @okyeron
--
-- Based on the supercollider UGens by Volker Bohm https://github.com/v7b1/mi-UGens
--
--

local UI = require "ui"
local TextureC = require "mi-eng/lib/TextureC_engine"

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


function init()
-- Add params
  TextureC.add_params()  

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
  

  -- UI
  controls[3] = UI.Dial.new(6, 4, 10, 0, 0, 1, 0.01)
  controls[2] = UI.Dial.new(6, 48, 10, 0, 0, 1, 0.01)
  controls[4] = UI.Dial.new(110, 48, 10, 0, 0, 1, 0.01)
  
  for uis = 2, 4 do
    controls[uis]:set_value (params:get(param_assign[uis]))
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
    params:delta("grainsize", d)
    controls[3]:set_value (params:get("grainsize"))
    --print("grainsize", string.format("%.2f", params:get("grainsize")))
  elseif n == 2 then
    params:delta("position", d)
    controls[2]:set_value (params:get("position"))
    --print("position",string.format("%.2f", params:get("position")))
  elseif n == 3 then
    params:delta("density", d)
    controls[4]:set_value (params:get("density"))
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


function redraw()
  -- screen redraw
  screen.clear()
  screen.aa(0)
  screen.level(15)

  screen.move(0,0)
  screen.stroke()

  for uis = 2, 4 do
    controls[uis]:redraw()
  end


  --screen.move(8, 8)
  --screen.text("wet:  ")
  --screen.move(120, 8)
  --screen.text_right(string.format("%.2f", params:get("drywet")))

  screen.move(21, 12)
  screen.text("size")
  --screen.move(120, 48)
  --screen.text_right(string.format("%.2f", params:get("grainsize")))
  screen.move(21, 62)
  screen.text("pos")
  --screen.move(120, 54)
  --screen.text_right(string.format("%.2f", params:get("position")))
  screen.move(85, 62)
  screen.text("dens")
  --screen.move(120, 60)
  --screen.text_right(string.format("%.2f", params:get("density")))

  
  draw_cloud(-16,0,1)
  draw_cloud(32,-1,2)
  draw_cloud(2,12,4)

  
  screen.update()
end

function cleanup()
  -- deinitialization
end