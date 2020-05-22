Engine_TextureC : CroneEngine {
  
  var <synth;
  
  *new { arg context, doneCallback;
    ^super.new(context, doneCallback);
  }

  alloc {
    SynthDef(\TextureC, {| inL, inR, out, 
      pit=0.7, pos=0.5, size=0.5, dens=0.5, tex=0, drywet=0.5, in_gain=1, spread=0.5, rvb=0.5, fb=0,
      freeze=0, mode=0, lofi=0, trig=0, trig_sel=1, trig_freq=50,
      pos_mod_amt=0, size_mod_amt=0, dens_mod_amt=0, tex_mod_amt=0, spread_mod_amt=0,
      pos_mod_freq=20.0, size_mod_freq=20, dens_mod_freq=20, tex_mod_freq=20, spread_mod_freq=20,
      pos_mod_sel=1, size_mod_sel=1, dens_mod_sel=1, tex_mod_sel=1, spread_mod_sel=1 |

      var sound, pos_mod, size_mod, dens_mod, tex_mod, spread_mod, trig_mod;

      pos_mod = Select.ar(pos_mod_sel, [SinOsc.ar(pos_mod_freq, 0, 0.5, 0.5), LFSaw.ar(pos_mod_freq, 0.5, 0.5), GbmanN.ar(pos_mod_freq, 0.5, 0.5)]);
      size_mod = Select.ar(size_mod_sel, [SinOsc.ar(size_mod_freq, 0, 0.5, 0.5), LFSaw.ar(size_mod_freq, 0.5, 0.5), GbmanN.ar(size_mod_freq, 0.5, 0.5)]);
      dens_mod = Select.ar(dens_mod_sel, [SinOsc.ar(dens_mod_freq, 0, 0.5, 0.5), LFSaw.ar(dens_mod_freq, 0.5, 0.5), GbmanN.ar(dens_mod_freq, 0.5, 0.5)]);
      tex_mod = Select.ar(tex_mod_sel, [SinOsc.ar(tex_mod_freq, 0, 0.5, 0.5), LFSaw.ar(tex_mod_freq, 0.5, 0.5), GbmanN.ar(tex_mod_freq, 0.5, 0.5)]);
      spread_mod = Select.ar(spread_mod_sel, [SinOsc.ar(spread_mod_freq, 0, 0.5, 0.5), LFSaw.ar(spread_mod_freq, 0.5, 0.5), GbmanN.ar(spread_mod_freq, 0.5, 0.5)]);
      trig_mod = Select.kr(trig_sel, [trig, Dust2.kr(trig_freq)]);
      
      sound = {
        MiClouds.ar(SoundIn.ar([0,1]),
          pit, 
          Clip.kr(pos + (pos_mod * pos_mod_amt), 0.0, 1.0),
          Clip.kr(size + (size_mod * size_mod_amt), 0.0, 1.0),
          Clip.kr(dens + (dens_mod * dens_mod_amt), 0.0, 1.0),
          Clip.kr(tex + (tex_mod * tex_mod_amt), 0.0, 1.0),
          drywet, 
          in_gain, 
          Clip.kr(spread + (spread_mod * spread_mod_amt), 0.0, 1.0),
          rvb, 
          fb,
          freeze, 
          mode, 
          lofi, 
          trig_mod
        ); 
      };
      
      Out.ar(out, sound);
    }).add;

    context.server.sync;

    synth = Synth.new(\TextureC, [
      \inL, context.in_b[0].index,      
      \inR, context.in_b[1].index,
      \out, context.out_b.index,
      \pit, 0.7,
      \pos, 0.5,
      \size, 0.5,
      \dens, 0.5,
      \tex, 0.1,
      \drywet, 0.8,
      \in_gain, 1,
      \spread, 0.5,
      \rvb, 0.5,
      \fb, 0.5,
      \freeze, 0,
      \mode, 0,
      \lofi, 0,
      \trig, 0
      ],
    context.xg);


    this.addCommand("pit", "f", {|msg|
      synth.set(\pit, msg[1]);
    });

    this.addCommand("pos", "f", {|msg|
      synth.set(\pos, msg[1]);
    });
    this.addCommand("pos_mod_sel", "i", {|msg|
      synth.set(\pos_mod_sel, msg[1]);
    });
    this.addCommand("pos_mod_freq", "f", {|msg|
      synth.set(\pos_mod_freq, msg[1]);
    });
    this.addCommand("pos_mod_amt", "f", {|msg|
      synth.set(\pos_mod_amt, msg[1]);
    });

    this.addCommand("size", "f", {|msg|
      synth.set(\size, msg[1]);
    });
    this.addCommand("size_mod_sel", "i", {|msg|
      synth.set(\size_mod_sel, msg[1]);
    });
    this.addCommand("size_mod_freq", "f", {|msg|
      synth.set(\size_mod_freq, msg[1]);
    });
    this.addCommand("size_mod_amt", "f", {|msg|
      synth.set(\size_mod_amt, msg[1]);
    });

    this.addCommand("dens", "f", {|msg|
      synth.set(\dens, msg[1]);
    });
    this.addCommand("dens_mod_sel", "i", {|msg|
      synth.set(\dens_mod_sel, msg[1]);
    });
    this.addCommand("dens_mod_freq", "f", {|msg|
      synth.set(\dens_mod_freq, msg[1]);
    });
    this.addCommand("dens_mod_amt", "f", {|msg|
      synth.set(\dens_mod_amt, msg[1]);
    });

    this.addCommand("tex", "f", {|msg|
      synth.set(\tex, msg[1]);
    });
    this.addCommand("tex_mod_sel", "i", {|msg|
      synth.set(\tex_mod_sel, msg[1]);
    });
    this.addCommand("tex_mod_freq", "f", {|msg|
      synth.set(\tex_mod_freq, msg[1]);
    });
    this.addCommand("tex_mod_amt", "f", {|msg|
      synth.set(\tex_mod_amt, msg[1]);
    });

    this.addCommand("drywet", "f", {|msg|
      synth.set(\drywet, msg[1]);
    });
    this.addCommand("in_gain", "f", {|msg|
      synth.set(\in_gain, msg[1]);
    });

    this.addCommand("spread", "f", {|msg|
      synth.set(\spread, msg[1]);
    });
    this.addCommand("spread_mod_sel", "i", {|msg|
      synth.set(\spread_mod_sel, msg[1]);
    });
    this.addCommand("spread_mod_freq", "f", {|msg|
      synth.set(\spread_mod_freq, msg[1]);
    });
    this.addCommand("spread_mod_amt", "f", {|msg|
      synth.set(\spread_mod_amt, msg[1]);
    });

    this.addCommand("rvb", "f", {|msg|
      synth.set(\rvb, msg[1]);
    });

    this.addCommand("fb", "f", {|msg|
      synth.set(\fb, msg[1]);
    });
    this.addCommand("fb_mod_sel", "f", {|msg|
      synth.set(\fb_mod_sel, msg[1]);
    });
    this.addCommand("fb_mod_freq", "f", {|msg|
      synth.set(\fb_mod_freq, msg[1]);
    });
    this.addCommand("fb_mod_amt", "f", {|msg|
      synth.set(\fb_mod_amt, msg[1]);
    });

    this.addCommand("freeze", "i", {|msg|
      synth.set(\freeze, msg[1]);
    });
    this.addCommand("mode", "i", {|msg|
      synth.set(\mode, msg[1]);
    });
     this.addCommand("lofi", "i", {|msg|
      synth.set(\lofi, msg[1]);
    });

    this.addCommand("trig_sel", "i", {|msg|
      synth.set(\trig, msg[1]);
    }); 
    this.addCommand("trig", "i", {|msg|
      synth.set(\trig, msg[1]);
    });
    this.addCommand("trig_freq", "f", {|msg|
      synth.set(\trig_freq, msg[1]);
    });
  }

  free {
    synth.free;
  }
}