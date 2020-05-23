--- TextureC Engine lib
-- Engine params and functions.
--
-- @module TextureC
-- @release v0.3.1
-- @author Steven Noreyko @okyeron
-- Lfo's by mat @justmat
-- 
-- Based on the supercollider Mi-UGens by Volker Bohm <https://github.com/v7b1/mi-UGens>
-- Based on original code by Émilie Gillet <https://github.com/pichenettes/eurorack>
--

local cs = require 'controlspec'
local wave_shapes = {"sine", "saw", "chaos"}

local TextureC = {}


function TextureC.add_lfo_params()
  params:add_separator("modulation")

  params:add_group("*position", 3)
  params:add_option("pos_mod_sel", "position mod source", wave_shapes, 1)
  params:set_action("pos_mod_sel", function(v) engine.pos_mod_sel(v - 1) end)
  params:add{type = "control", id = "pos_mod_freq", name = "position mod freq",
    controlspec = cs.new(0.01, 20.00, "exp", 0.01, 0.5, ""), action = engine.pos_mod_freq}
  params:add{type = "control", id = "pos_mod_amt", name = "position mod amount",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 0.00, ""), action = engine.pos_mod_amt}

  params:add_group("*grainsize", 3)
  params:add_option("size_mod_sel", "size mod source", wave_shapes, 1)
  params:set_action("size_mod_sel", function(v) engine.size_mod_sel(v - 1) end)
  params:add{type = "control", id = "size_mod_freq", name = "size mod freq",
    controlspec = cs.new(0.01, 20.00, "exp", 0.01, 0.5, ""), action = engine.size_mod_freq}
  params:add{type = "control", id = "size_mod_amt", name = "size mod amount",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 0.00, ""), action = engine.size_mod_amt}

  params:add_group("*density", 3)
  params:add_option("dens_mod_sel", "density mod source", wave_shapes, 1)
  params:set_action("dens_mod_sel", function(v) engine.dens_mod_sel(v - 1) end)
  params:add{type = "control", id = "dens_mod_freq", name = "density mod freq",
    controlspec = cs.new(0.01, 20.00, "exp", 0.01, 0.5, ""), action = engine.dens_mod_freq}
  params:add{type = "control", id = "dens_mod_amt", name = "density mod amount",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 0.00, ""), action = engine.dens_mod_amt}

  params:add_group("*texture", 3)
  params:add_option("tex_mod_sel", "texture mod source", wave_shapes, 1)
  params:set_action("tex_mod_sel", function(v) engine.tex_mod_sel(v - 1) end)
  params:add{type = "control", id = "tex_mod_freq", name = "texture mod freq",
    controlspec = cs.new(0.01, 20.00, "exp", 0.01, 0.5, ""), action = engine.tex_mod_freq}
  params:add{type = "control", id = "tex_mod_amt", name = "texture mod amount",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 0.00, ""), action = engine.tex_mod_amt}

  params:add_group("*spread", 3)
  params:add_option("spread_mod_sel", "spread mod source", wave_shapes, 1)
  params:set_action("spread_mod_sel", function(v) engine.spread_mod_sel(v - 1) end)
  params:add{type = "control", id = "spread_mod_freq", name = "spread mod freq",
    controlspec = cs.new(0.01, 20.00, "exp", 0.01, 0.5, ""), action = engine.spread_mod_freq}
  params:add{type = "control", id = "spread_mod_amt", name = "spread mod amount",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 0.00, ""), action = engine.spread_mod_amt}

  params:add_group("*trig", 2)
  params:add_option("trig_sel", "trig source", {"manual", "dust"}, 2)
  params:set_action("trig_sel", function(v) engine.trig_sel(v - 1) end)
  params:add{type = "control", id = "dust_freq", name = "dust freq",
    controlspec = cs.new(1, 500, "lin", 1, 25, ""), action = engine.trig_freq}
end


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
  params:add{type = "number", id = "trig", name = "trig",
    min = 0, max = 1, default = 0, action = engine.trig}
end

return TextureC
