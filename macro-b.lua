--
--    macro oscillator b
--
--    v 0.3.0 @okyeron
--
--
-- E1: model
-- E2: timbre
-- E3: color
-- K2: trigger note
--
-- Based on the supercollider UGens by Volker Bohm https://github.com/v7b1/mi-UGens
--
--

-- Synthesis models (0 -- 47):
-- 0:CSAW, 1:MORPH, 2:SAW_SQUARE, 3:SINE_TRIANGLE, 4:BUZZ, 5:SQUARE_SUB, 6:SAW_SUB, 7:SQUARE_SYNC,
-- 8:SAW_SYNC, 9:TRIPLE_SAW, 10:TRIPLE_SQUARE, 11:TRIPLE_TRIANGLE, 12:TRIPLE_SINE, 13:TRIPLE_RING_MOD,
-- 14:SAW_SWARM, 15:SAW_COMB, 16:TOY, 17:DIGITAL_FILTER_LP, 18:DIGITAL_FILTER_PK, 19:DIGITAL_FILTER_BP,
-- 20:DIGITAL_FILTER_HP, 21:VOSIM, 22:VOWEL, 23:VOWEL_FOF, 24:HARMONICS, 25:FM, 26:FEEDBACK_FM,
-- 27:CHAOTIC_FEEDBACK_FM, 28:PLUCKED, 29:BOWED, 30:BLOWN, 31:FLUTED, 32:STRUCK_BELL, 33:STRUCK_DRUM,
-- 34:KICK, 35:CYMBAL, 36:SNARE, 37:WAVETABLES, 38:WAVE_MAP, 39:WAVE_LINE, 40:WAVE_PARAPHONIC,
-- 41:FILTERED_NOISE, 42:TWIN_PEAKS_NOISE, 43:CLOCKED_NOISE, 44:GRANULAR_CLOUD, 45:PARTICLE_NOISE,
-- 46:DIGITAL_MODULATION, 47:QUESTION_MARK

local UI = require "ui"
local MacroB = require "mi-eng/lib/MacroB_engine"

engine.name = "MacroB"

local message = ""
local glyph = ""

local pitch=60 --(midi note)
local timbre=0.5
local color=0.5
local model=0
local trig=0
local resamp=2
local decim=1
local bits=0
local ws=0
local mul=1.0

local ampAtk=0.05
local ampDec=0.1
local ampSus=1.0
local ampRel=1.0

local current_note = pitch
local metarandom = false

local param_assign = {"pitch","timbre","color","model","resamp","decim","bits","ws", "ampAtk", "ampDec", "ampSus", "ampRel"}

local braids_engines = {"CSAW","Morph","Saw Square","Sine Triangle","Buzz","Square Sub","Saw Sub","Square Sync","Saw Sync","Triple Saw","Triple Square","Triple Triangle","Triple Sine","Triple Ring Mod","Saw Swarm","Saw Comb","Toy","Digital Filter Lp","Digital Filter Pk","Digital Filter Bp","Digital Filter Hp","Vosim","Vowel","Vowel Fof","Harmonics","Fm","Feedback Fm","Chaotic Feedback Fm","Plucked","Bowed","Blown","Fluted","Struck Bell","Struck Drum","Kick","Cymbal","Snare","Wavetables","Wave Map","Wave Line","Wave Paraphonic","Filtered Noise","Twin Peaks Noise","Clocked Noise","Granular Cloud","Particle Noise","Digital Modulation","Question Mark"}

local braids_glyphs = {"CSAW","/\\/|-_-_","/|/|-_-_","FOLD","_|_|_|_|_","-_-_SUB","/|/|SUB","SYN-_-_","SYN/|","/|/|x3","-_-_x3","/\\x3","SIx3","RING","/|/|/|/|","/|/|_|_|_","TOY*","ZLPF","ZPKF","ZBPF","ZHPF","VOSM","VOWL","VFOF","HARM","FM","FBFM","WTFM","PLUK","BOWD","BLOW","FLUTE","BELL","DRUM","KICK","CYMB","SNAR","WTBL","WMAP","WLIN","WTx4","NOIS","TWNQ","CLKN","CLOU","PRTC","QPSK","????"}

controls = {}
controls.pitch = {ui = nil, midi = 32,}
controls.timbre = {ui = nil, midi = 33,}
controls.color = {ui = nil, midi = 34,}
controls.model = {ui = nil, midi = 35,}
controls.decim = {ui = nil, midi = 36,}
controls.bits = {ui = nil, midi = 37,}
controls.ws = {ui = nil, midi = 38,}
--controls.resamp = {ui = nil, midi = 39,}

controls.ampAtk = {ui = nil, midi = 44,}
controls.ampDec = {ui = nil, midi = 45,}
controls.ampSus = {ui = nil, midi = 46,}
controls.ampRel = {ui = nil, midi = 47,}

local current_note = pitch

local mo = midi.connect() -- defaults to port 1 (which is set in SYSTEM > DEVICES)
mo.event = function(data) 
  d = midi.to_msg(data)
  if d.type == "note_on" then
    --print ("note-on: ".. d.note .. ", velocity:" .. d.vel)
    if metarandom then 
      meta_random()
    end
    current_note = d.note
    params:set("pitch", d.note)
    controls.pitch.ui:set_value (d.note)
    engine.noteOn(d.note, d.vel)
    redraw()
  elseif d.type == "note_off" then
    engine.noteOff(0)
  end 
end
local mo2 = midi.connect(2) -- defaults to port 1 (which is set in SYSTEM > DEVICES)
mo2.event = function(data) 
  d = midi.to_msg(data)
  if d.type == "cc" then
    for k,v in pairs(controls) do
        if d.cc == 40 and d.val > 64 then
          metarandom = true
        else
          metarandom = false
        end 
        if controls[k].midi == d.cc then
          --print ("cc: ".. d.cc .. ", val:" .. d.val)
          if k == "pitch" then
            controls[k].ui:set_value (d.val)
            params:set(k, d.val)
          elseif k == "model" then 
            controls[k].ui:set_value (d.val)
            params:set(k, d.val)
            legend = "" .. braids_engines[params:get(k)]
            glyph = braids_glyphs[params:get(k)]
          elseif k == "decim" then
            params:set(k, d.val/4)
           controls[k].ui:set_value (d.val/4)
          elseif k == "bits" then
            params:set(k, util.round(d.val/21, 0.1))
            controls[k].ui:set_value (d.val/21)
          elseif k ~= nil then
            params:set(k, d.val/100)
            controls[k].ui:set_value (d.val/100)
          end
       end 
    end  
    --params:bang ()
    redraw()
    
  end 
end

function init()

  -- Add params
  MacroB.add_params()

  -- initialize params  
  params:set("pitch", pitch)
  params:set("timbre",timbre)
  params:set("color",color)
  params:set("model",model)
  params:set("trig",trig)
  params:set("resamp",resamp)
  params:set("decim",decim)
  params:set("bits",bits)
  params:set("ws",ws)

  params:set("ampAtk",ampAtk)
  params:set("ampDec",ampDec)
  params:set("ampSus",ampSus)
  params:set("ampRel",ampRel)

  legend = "" .. braids_engines[params:get("model")]
  glyph = "" .. braids_glyphs[params:get("model")]
 
  -- UI
  local row1 = 12
  local row2 = 30
  local row3 = 48

  local col1 = 3
  local col2 = 22
  local col3 = 40
  local col4 = 52
  local col5 = 68
  local col6 = 84
  local col7 = 100
  local col8 = 116
  
  controls.pitch.ui = UI.Dial.new(col1, row3, 10, 1, 1, 127, 1)
  controls.model.ui = UI.Dial.new(114, row3-8, 14, 1, 1, #braids_engines, 1)

  controls.timbre.ui = UI.Dial.new(col1, row1, 10, 0, 0, 1, 0.01, 0, {},"", "timb")
  controls.color.ui = UI.Dial.new(col2, row1, 10, 0, 0, 1, 0.01, 0, {},"", "color")
  --controls.resamp.ui = UI.Dial.new(col3, row1, 10, 0, 1, 3, 1)

  controls.decim.ui = UI.Dial.new(col1, row2, 10, 1, 1, 32, 1, 0, {},"", "dec")
  controls.bits.ui = UI.Dial.new(col2, row2, 10, 1, 1, 7, 1, 0, {},"", "bits")
  controls.ws.ui = UI.Dial.new(col3, row2, 10, 0, 0, 1, 0.01, 0, {},"", "ws")

  controls.ampAtk.ui = UI.Dial.new(col5, row1, 10, 0, 0, 1, 0.01, 0, {},"", "a")
  controls.ampDec.ui = UI.Dial.new(col6, row1, 10, 0, 0, 1, 0.01, 0, {},"", "d")
  controls.ampSus.ui = UI.Dial.new(col7, row1, 10, 0, 0, 1, 0.01, 0, {},"", "s")
  controls.ampRel.ui = UI.Dial.new(col8, row1, 10, 0, 0, 1, 0.01, 0, {},"", "r")

  for k,v in pairs(controls) do
     controls[k].ui:set_value (params:get(k))
  end  
  
  
  redraw()
end

function key(n,z)
  if n == 2 and z == 1 then
    engine.noteOn(60,64)
  else
    engine.noteOff(0)
  end
  
  -- key actions: n = number, z = state
end

function enc(n,d)
  -- encoder actions: n = number, d = delta
  if n == 1 then
    params:delta("model", d)
    --print("model", string.format("%i", params:get("model")))
    controls.model.ui:set_value (params:get("model"))
    legend = "" .. braids_engines[params:get("model")]
    glyph = braids_glyphs[params:get("model")]
  elseif n == 2 then
    params:delta("timbre", d)
    --print("timbre", string.format("%.2f", params:get("timbre")))
    controls.timbre.ui:set_value (params:get("timbre"))
    message = "timbre"
  elseif n == 3 then
    params:delta("color", d)
    --print("color", string.format("%.2f", params:get("color")))
    controls.color.ui:set_value (params:get("color"))
    message = "color"
  end
  redraw()
end

function meta_random()
    local meta = math.random(1, #braids_engines)    
    controls.model.ui:set_value (meta)
    params:set("model", meta)
    legend = "" .. braids_engines[meta]
    glyph = braids_glyphs[meta]

end

function redraw()
  -- screen redraw
  screen.clear()
  screen.aa(0)
  screen.font_face (1)
  screen.font_size (8)
  screen.level(15)
  
  screen.move(0,0)
  screen.stroke()

  for k,v in pairs(controls) do
      controls[k].ui:redraw()
  end 

  screen.move(2, 8)
  screen.text("macro osc b ")

  screen.move(128, 8)
  --screen.text_right(message)


  screen.move(110, 62)
  screen.text_right(legend)

  screen.move(110, 52)
  screen.font_face (8)
  screen.font_size (16)
  screen.text_right(glyph)

  screen.update()
end

function cleanup()
  -- deinitialization
end