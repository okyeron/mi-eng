--- miPlaits Engine lib
-- Engine params and functions.
--
-- @module miPlaits
-- @release v0.5.0
-- @author Steven Noreyko @okyeron

-- 

local cs = require 'controlspec'

local miPlaits = {}

function miPlaits.add_params()

  params:add{type = "control", id = "pitch", name = "pitch",
    controlspec = cs.new(0, 127, "lin", 1, 35, ""), action = engine.pitch}
  params:add{type = "control", id = "engine", name = "engine",
    controlspec = cs.new(0, 15, "lin", 1, 0, ""), action = engine.eng}
  params:add{type = "control", id = "harmonics", name = "harmonics",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 0.25, ""), action = engine.harm}

  params:add{type = "control", id = "timbre", name = "timbre",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 0.5, ""), action = engine.timbre}
  params:add{type = "control", id = "timb_mod", name = "timb_mod",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 0, ""), action = engine.timb_mod}

  params:add{type = "control", id = "morph", name = "morph",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 0.5, ""), action = engine.morph}
  params:add{type = "control", id = "morph_mod", name = "morph_mod",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 0, ""), action = engine.morph_mod}

  params:add{type = "control", id = "fm_mod", name = "fm_mod",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 0, ""), action = engine.fm_mod}

  params:add{type = "control", id = "trigger", name = "trigger",
    controlspec = cs.new(0, 1, "lin", 1, 0, ""), action = engine.trigger}
  params:add{type = "control", id = "level", name = "level",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 0, ""), action = engine.level}
  
  params:add{type = "control", id = "decay", name = "decay",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 0, ""), action = engine.decay}
  params:add{type = "control", id = "lpg_colour", name = "lpg_colour",
    controlspec = cs.new(0.00, 1.00, "lin", 0.01, 0, ""), action = engine.lpg_colour}

end

return miPlaits
