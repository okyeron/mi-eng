// Implementation of MiBraids UGen as norns engine
// Steven Noreyko @okyeron
//
// Mi-Ugens by volker böhm, 2020 - https://vboehm.net

Engine_MacroB : CroneEngine {
  
	var <synth;
	
  *new { arg context, doneCallback;
    ^super.new(context, doneCallback);
  }

  alloc {
  	
    SynthDef(\MacroB, {
      arg out, pitch=60.0, timbre=0.5, color=0.5, model=0, trig=0, resamp=0, decim=0, bits=0, ws=0, mul=0.3, gate=0, 
      		// amplitude envelope params
			ampAtk=0.05, ampDec=0.1, ampSus=1.0, ampRel=1.0, ampCurve= -1.0;
      var aenv, sound;
      aenv = EnvGen.ar(Env.adsr(ampAtk, ampDec, ampSus, ampRel, 1.0, ampCurve), gate: gate, doneAction:0);
      sound = {
        MiBraids.ar(pitch, timbre, color, model, trig, resamp, decim, bits, ws, mul)!2; 
      };
		
      Out.ar(out, sound * aenv);
    }).add;

    context.server.sync;

    synth = Synth.new(\MacroB, [
		\out, context.out_b.index,
		\pitch, 60.0,
		\timbre, 0.5,
		\color, 0.5,
		\model, 0,
		\trig, 0,
		\resamp, 0,
		\decim, 0,
		\bits, 0,
		\ws, 0,
		\mul, 0.3,
		\ampAtk, 0.05, 
		\ampDec, 0.1, 
		\ampSus, 1.0, 
		\ampRel, 1.0, 
		\ampCurve, -1.0
      ],
    context.xg);

	//noteOn(note, vel)
    this.addCommand("noteOn", "ii", {|msg|
      synth.set(\pitch, msg[1]);
      synth.set(\gate, 1);

    }); 
 
     this.addCommand("noteOff", "i", {|msg|
      synth.set(\gate, 0);
    }); 
    

    this.addCommand("pitch", "i", {|msg|
      synth.set(\pitch, msg[1]);
    });
    this.addCommand("timbre", "f", {|msg|
      synth.set(\timbre, msg[1]);
    });
    this.addCommand("color", "f", {|msg|
      synth.set(\color, msg[1]);
    });
    this.addCommand("model", "i", {|msg|
      synth.set(\model, msg[1]);
    });
    this.addCommand("trig", "i", {|msg|
      synth.set(\trig, msg[1]);
    });
    this.addCommand("resamp", "i", {|msg|
      synth.set(\resamp, msg[1]);
    });
    this.addCommand("decim", "i", {|msg|
      synth.set(\decim, msg[1]);
    });
    this.addCommand("bits", "i", {|msg|
      synth.set(\bits, msg[1]);
    });
    this.addCommand("ws", "f", {|msg|
      synth.set(\ws, msg[1]);
    });
    this.addCommand("mul", "f", {|msg|
      synth.set(\mul, msg[1]);
    });

    this.addCommand("ampAtk", "f", {|msg|
      synth.set(\ampAtk, msg[1]);
    });
    this.addCommand("ampDec", "f", {|msg|
      synth.set(\ampDec, msg[1]);
    });
    this.addCommand("ampSus", "f", {|msg|
      synth.set(\ampSus, msg[1]);
    });
    this.addCommand("ampRel", "f", {|msg|
      synth.set(\ampRel, msg[1]);
    });
   

  }

  free {
    synth.free;
  }
}
