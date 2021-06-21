--- ResonateR Engine lib
-- Engine params and functions.
--
-- @module ResonateR
-- @release v0.3.1
-- @author Steven Noreyko @okyeron
--
-- 
-- Based on the supercollider Mi-UGens by Volker Bohm <https://github.com/v7b1/mi-UGens>
-- Based on original code by Émilie Gillet <https://github.com/pichenettes/eurorack>
--

local cs = require 'controlspec'

local ResonateR = {}

function ResonateR.add_params()

  params:add_separator ("Resonator")

  params:add_control("pitch", "pitch", controlspec.new(0, 100, "lin", 1, pitch, ""))
  params:set_action("pitch", function(value) engine.pit(value) update_ui("pitch", value) end)

  params:add_control("structure", "structure", controlspec.new(0.00, 1.00, "lin", 0.01, struct, ""))
  params:set_action("structure", function(value) engine.struct(value) update_ui("structure", value) end)

  params:add_control("brightness", "brightness", controlspec.new(0.00, 1.00, "lin", 0.01, bright, ""))
  params:set_action("brightness", function(value) engine.bright(value) update_ui("brightness", value) end)

  params:add_control("damping", "damping", controlspec.new(0.00, 1.00, "lin", 0.01, damp, ""))
  params:set_action("damping", function(value) engine.damp(value) update_ui("damping", value) end)

  params:add_control("position", "position", controlspec.new(0.00, 1.00, "lin", 0.01, position, ""))
  params:set_action("position", function(value) engine.pos(value) update_ui("position", value) end)

  params:add_control("model", "model", controlspec.new(0, 5, "lin", 1, model, ""))
  params:set_action("model", function(value) engine.model(value) update_ui("model", value) print("action: " .. value) end)

  params:add_control("polyphony", "polyphony", controlspec.new(1, 4, "lin", 1, poly, ""))
  params:set_action("polyphony", function(value) engine.poly(value) update_ui("polyphony", value) end)

  params:add_control("intern_exciter", "intern_exciter", controlspec.new(0, 1, "lin", 1, intern_exciter, ""))
  params:set_action("intern_exciter", function(value) engine.intern_exciter(value) update_ui("intern_exciter", value) end)

  params:add_control("easteregg", "easteregg", controlspec.new(0, 5, "lin", 1, 0, ""))
  params:set_action("easteregg", function(value) engine.easteregg(value) update_ui("easteregg", value) end)
 
  params:add_control("bypass", "bypass", controlspec.new(0, 1, "lin", 1, bypass, ""))
  params:set_action("bypass", function(value) engine.bypass(value) update_ui("bypass", value) end)
  
  params:add_control("pitch_from_midi", "pitch_from_midi", controlspec.new(0, 1, "lin", 1, pitch_from_midi, ""))
  params:add_control("ping_resonator", "ping_resonator", controlspec.new(0, 1, "lin", 1, ping_resonator, ""))

end

return ResonateR
