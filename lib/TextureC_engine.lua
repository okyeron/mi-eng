--- TextureC Engine lib
-- Engine params and functions.
--
-- @module TextureC
-- @release v0.3.1
-- @author Steven Noreyko @okyeron
--
-- 
-- Based on the supercollider Mi-UGens by Volker Bohm <https://github.com/v7b1/mi-UGens>
-- Based on original code by Émilie Gillet <https://github.com/pichenettes/eurorack>
--

local cs = require 'controlspec'

local TextureC = {}

function TextureC.add_params()
  
  params:add_separator ("Texture Synth")
  
  params:add{type = "control", id = "pitch", name = "pitch",
    controlspec = cs.new(-48, 48, "lin", 1, 36, ""), action = engine.pit}
  params:add{type = "control", id = "position", name = "position",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 0.5, ""), action = engine.pos}
  params:add{type = "control", id = "grainsize", name = "grainsize",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 0.5, ""), action = engine.size}
  params:add{type = "control", id = "density", name = "density",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 0.5, ""), action = engine.dens}
  params:add{type = "control", id = "texture", name = "texture",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 0, ""), action = engine.tex}
  params:add{type = "control", id = "drywet", name = "drywet",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 0.5, ""), action = engine.drywet}
  params:add{type = "control", id = "in_gain", name = "in_gain",
    controlspec = cs.new(0.125, 7.00, "lin", 0.05, in_gain, ""), action = engine.in_gain}
  params:add{type = "control", id = "spread", name = "spread",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 0.25, ""), action = engine.spread}
  params:add{type = "control", id = "reverb", name = "reverb",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 0, ""), action = engine.rvb}
  params:add{type = "control", id = "feedback", name = "feedback",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 0.5, ""), action = engine.fb}
  params:add{type = "control", id = "freeze", name = "freeze",
    controlspec = cs.new(0, 1, "lin", 1, 0, ""), action = engine.freeze}
  params:add{type = "control", id = "mode", name = "mode",
    controlspec = cs.new(0, 3, "lin", 1, 0, ""), action = engine.mode}
  params:add{type = "control", id = "lofi", name = "lofi",
    controlspec = cs.new(0, 1, "lin", 1, 0, ""), action = engine.lofi}
  params:add{type = "control", id = "trig", name = "trig",
    controlspec = cs.new(0, 1, "lin", 1, 0, ""), action = engine.trig}

end

return TextureC


