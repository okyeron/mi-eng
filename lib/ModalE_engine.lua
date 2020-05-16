--- ModalE Engine lib
-- Engine params and functions.
--
-- @module ModalE
-- @release v0.3.1
-- @author Steven Noreyko @okyeron
--
-- 
-- Based on the supercollider Mi-UGens by Volker Bohm <https://github.com/v7b1/mi-UGens>
-- Based on original code by Émilie Gillet <https://github.com/pichenettes/eurorack>
--

local cs = require 'controlspec'

local ModalE = {}

function ModalE.add_params()

  params:add_separator ("Modal Synth")

  params:add{type = "control", id = "gate", name = "gate",
    controlspec = cs.new(0, 1, "lin", 1, 0, ""), action = engine.gate}
    
  params:add{type = "control", id = "pit", name = "pit",
    controlspec = controlspec.MIDINOTE, action = engine.pit}
  
  params:add{type = "control", id = "strength", name = "strength",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 0.5, ""), action = engine.strength}
  params:add{type = "control", id = "contour", name = "contour",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 0.5, ""), action = engine.contour}

params:add_separator ("Bow")
  params:add{type = "control", id = "bow_level", name = "bow_level",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 0, ""), action = engine.bow_level}
  params:add{type = "control", id = "bow_timb", name = "bow_timb",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 0.5, ""), action = engine.bow_timb}

params:add_separator ("Blow")
  params:add{type = "control", id = "blow_level", name = "blow_level",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 0, ""), action = engine.blow_level}
  params:add{type = "control", id = "flow", name = "flow",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 0.25, ""), action = engine.flow}
  params:add{type = "control", id = "blow_timb", name = "blow_timb",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 0.5, ""), action = engine.blow_timb}

params:add_separator ("Strike")
  params:add{type = "control", id = "strike_level", name = "strike_level",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 0, ""), action = engine.strike_level}
  params:add{type = "control", id = "mallet", name = "mallet",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 0.5, ""), action = engine.mallet}
  params:add{type = "control", id = "strike_timb", name = "strike_timb",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 0.5, ""), action = engine.strike_timb}

params:add_separator ("Modal resonator")
  params:add{type = "control", id = "geom", name = "geom",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 0.4, ""), action = engine.geom}
  params:add{type = "control", id = "bright", name = "bright",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 0.2, ""), action = engine.bright}
  params:add{type = "control", id = "damp", name = "damp",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 0.5, ""), action = engine.damp}
  params:add{type = "control", id = "pos", name = "pos",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 0, ""), action = engine.pos}
  params:add{type = "control", id = "space", name = "space",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 0.3, ""), action = engine.space}
  params:add{type = "control", id = "model", name = "model",
    controlspec = cs.new(0, 2, "lin", 1, 0, ""), action = engine.model}

  --params:add{type = "control", id = "easteregg", name = "easteregg",
  --  controlspec = cs.new(0, 1, "lin", 1, 0, ""), action = engine.easteregg}

  params:add{type = "control", id = "mul", name = "mul",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 1.0, ""), action = engine.mul}
end

return ModalE
