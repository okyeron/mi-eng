Engine_MiClouds : CroneEngine {
  
  var <synth;
	
  *new { arg context, doneCallback;
    ^super.new(context, doneCallback);
  }

  alloc {
    SynthDef(\MiClouds, {|inL, inR, out, pit=0.7, pos=0.5, size=0.5, dens=0.5, tex=0, drywet=0.5, in_gain=1, spread=0.5, rvb=0.5, fb=0, freeze=0, mode=0, lofi=0, trig=0, mul=1.0, add=0.0|
      var sound = {
        MiClouds.ar(SoundIn.ar([0,1]),
          pit, 
          pos, 
          size, 
          dens, 
          tex, 
          drywet, 
          in_gain, 
          spread, 
          rvb, 
          fb, 
          freeze, 
          mode, 
          lofi, 
          trig, 
          mul, 
          add
        ); 
      };
      
      Out.ar(out, sound);
    }).add;

    context.server.sync;

    synth = Synth.new(\MiClouds, [
      \inL, context.in_b[0].index,			
      \inR, context.in_b[1].index,
      \out, context.out_b.index,
      \pit, 0.7,
      \pos, 0.5,
      \size, 0.5,
      \dens, 0.5,
      \tex, 0,
      \drywet, 0.8,
      \in_gain, 1,
      \spread, 0.5,
      \rvb, 0.5,
      \fb, 0.5,
      \freeze, 0,
      \mode, 0,
      \lofi, 0,
      \trig, 1,
      \mul, 1.0,
      \add, 0
      ],
    context.xg);


    this.addCommand("pit", "f", {|msg|
      synth.set(\pit, msg[1]);
    }); 
    this.addCommand("pos", "f", {|msg|
      synth.set(\pos, msg[1]);
    }); 
    this.addCommand("size", "f", {|msg|
      synth.set(\size, msg[1]);
    });
    this.addCommand("dens", "f", {|msg|
      synth.set(\dens, msg[1]);
    });
    this.addCommand("tex", "f", {|msg|
      synth.set(\tex, msg[1]);
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
    this.addCommand("rvb", "f", {|msg|
      synth.set(\rvb, msg[1]);
    });
    this.addCommand("fb", "f", {|msg|
      synth.set(\fb, msg[1]);
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
    this.addCommand("trig", "i", {|msg|
      synth.set(\trig, msg[1]);
    });
    this.addCommand("mul", "i", {|msg|
      synth.set(\mul, msg[1]);
    });
    this.addCommand("add", "i", {|msg|
      synth.set(\add, msg[1]);
    });
   

  }

  free {
    synth.free;
  }
}