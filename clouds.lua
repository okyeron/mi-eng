--
--          cloudy
--       --     ---
--    ----------------
--     --  ----  ---
--      -   --    -
--

engine.name = "MiClouds"

local pitch = 0 -- (+-48.0)
local position = 0.0 -- (0 -- 1)
local size = 0.2 -- (0 -- 1)
local dens = 0.5 -- (0 -- 1)
local texture = 0.1 -- (0 -- 1)
local drywet = 0 -- (0 -- 1)
local in_gain = 2 -- 0.125 -- 8
local spread = 1 -- (0 -- 1)
local rvb = 0.2 -- (0 -- 1)
local feedback = 0.2 -- (0 -- 1)
local freeze = 0 -- (0 -- 1)
local mode = 0 -- (0 -- 3)
local lofi = 0 -- (0 -- 1)
local trig = 0 -- (0 -- 1)

function init()
  -- initialization
  engine.pit(pitch)
  engine.pos(position)
  engine.size(size)
  engine.dens(dens)
  engine.tex(texture)
  engine.drywet(drywet)
  engine.in_gain(in_gain)
  engine.rvb(rvb)
  engine.spread(spread)
  engine.fb(feedback)
  engine.freeze(freeze)
  engine.mode(mode)
  engine.lofi(lofi)
  
  params:add_control("pitch", "pitch", controlspec.new(-48, 48, "lin", 1, pitch, ""))
  params:set_action("pitch", function(value) engine.pit(value) end)

  params:add_control("position", "position", controlspec.new(0.00, 1.00, "lin", 0.05, position, ""))
  params:set_action("position", function(value) engine.pos(value) end)

  params:add_control("grainsize", "grainsize", controlspec.new(0.00, 1.00, "lin", 0.01, size, ""))
  params:set_action("grainsize", function(value) engine.size(value) end)

  params:add_control("density", "density", controlspec.new(0.00, 1.00, "lin", 0.01, dens, ""))
  params:set_action("density", function(value) engine.dens(value) end)

  params:add_control("texture", "texture", controlspec.new(0.00, 1.00, "lin", 0.05, texture, ""))
  params:set_action("texture", function(value) engine.tex(value) end)

  params:add_control("reverb", "reverb", controlspec.new(0.00, 1.00, "lin", 0.05, rvb, ""))
  params:set_action("reverb", function(value) engine.rvb(value) end)

  params:add_control("in_gain", "in_gain", controlspec.new(0.125, 7.00, "lin", 0.05, in_gain, ""))
  params:set_action("in_gain", function(value) engine.in_gain(value) end)

  params:add_control("spread", "spread", controlspec.new(0.00, 1.00, "lin", 0.01, spread, ""))
  params:set_action("spread", function(value) engine.spread(value) end)

  params:add_control("feedback", "feedback", controlspec.new(0.00, 1.00, "lin", 0.01, feedback, ""))
  params:set_action("feedback", function(value) engine.fb(value) end)

  params:add_control("drywet", "drywet", controlspec.new(0.00, 1.00, "lin", 0.01, drywet, ""))
  params:set_action("drywet", function(value) engine.drywet(value) end)

  params:add_control("freeze", "freeze", controlspec.new(0, 1, "lin", 1, freeze, ""))
  params:set_action("freeze", function(value) engine.freeze(value) end)

  params:add_control("mode", "mode", controlspec.new(0, 3, "lin", 1, mode, ""))
  params:set_action("mode", function(value) engine.mode(value) end)

  redraw()
end

function key(n,z)
  if n == 2 and z == 1 then
    engine.freeze(1)
  else
    engine.freeze(0)
  end
  
  -- key actions: n = number, z = state
end

function enc(n,d)
  -- encoder actions: n = number, d = delta
  if n == 1 then
    params:delta("grainsize", d)
    --print("grainsize", string.format("%.2f", params:get("grainsize")))
  elseif n == 2 then
    params:delta("position", d)
    --print("position",string.format("%.2f", params:get("position")))
  elseif n == 3 then
    params:delta("density", d)
    --print("density",string.format("%.2f", params:get("density")))
  elseif n == 4 then
    params:delta("drywet", d)
    --print("density",string.format("%.2f", params:get("density")))
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


  screen.move(8, 8)
  screen.text("wet:  ")
  screen.move(120, 8)
  screen.text_right(string.format("%.2f", params:get("drywet")))

  screen.move(8, 48)
  screen.text("size:  ")
  screen.move(120, 48)
  screen.text_right(string.format("%.2f", params:get("grainsize")))
  screen.move(8, 54)
  screen.text("pos:  ")
  screen.move(120, 54)
  screen.text_right(string.format("%.2f", params:get("position")))
  screen.move(8, 60)
  screen.text("dens:  ")
  screen.move(120, 60)
  screen.text_right(string.format("%.2f", params:get("density")))

  
  draw_cloud(-20,-2,6)
  draw_cloud(30,-3,8)
  draw_cloud(0,10,10)

  
  screen.update()
end

function cleanup()
  -- deinitialization
end