//		blow_in=0, strike_in=0, gate=0, pit=48, strength=0.5, contour=0.2, bow_level=0,
//		blow_level=0, strike_level=0, flow=0.5, mallet=0.5, bow_timb=0.5, blow_timb=0.5,
//		strike_timb=0.5, geom=0.25, bright=0.5, damp=0.7, pos=0.2, space=0.3, model=0,
//		mul=1.0, add=0;

Engine_MiElements : CroneEngine {
  
	var <synth;
	
  *new { arg context, doneCallback;
    ^super.new(context, doneCallback);
  }

  alloc {
  	
    SynthDef(\MiElements, {
      arg inL, inR, out, blow_in=0, strike_in=0, gate=0, pit=48, strength=0.5, contour=0.2, bow_level=0,
		blow_level=0, strike_level=0, flow=0.5, mallet=0.5, bow_timb=0.5, blow_timb=0.5,
		strike_timb=0.5, geom=0.25, bright=0.5, damp=0.7, pos=0.2, space=0.3, model=0,
		mul=1.0, add=0;
	
      var sound = {
        MiElements.ar(SoundIn.ar(0),SoundIn.ar(1),gate,pit,strength,contour,bow_level,blow_level,strike_level,flow,mallet,bow_timb,blow_timb,strike_timb,geom,bright,damp,pos,space,model,mul,add); 
      };
      Out.ar(out, sound);
    }).add;

    context.server.sync;

    synth = Synth.new(\MiElements, [
		\out, context.out_b.index,
        \inL, context.in_b[0].index,			
        \inR, context.in_b[1].index,
		\gate, 0,
		\pit, 48,
		\strength, 0.5,
		\contour, 0.2,
		\bow_level, 0,
		\blow_level, 0,
		\strike_level, 0,
		\flow, 0.5,
		\mallet, 0.5,
		\bow_timb, 0.5,
		\blow_timb, 0.5,
		\strike_timb, 0.5,
		\geom, 0.25,
		\bright, 0.5,
		\damp, 0.7,
		\pos, 0.2,
		\space, 0.3,
		\model, 0,
		\mul, 1.0,
		\add, 0
      ],
    context.xg);

	//noteOn(note)
    this.addCommand("noteOn", "i", {|msg|
      synth.set(\pit, msg[1]);
      synth.set(\gate, 1);
    }); 
 
     this.addCommand("noteOff", "i", {|msg|
      synth.set(\gate, 0);
    }); 
    

    this.addCommand("gate", "i", {|msg|
      synth.set(\gate, msg[1]);
    });
    this.addCommand("pit", "i", {|msg|
      synth.set(\pit, msg[1]);
    });
    this.addCommand("strength", "f", {|msg|
      synth.set(\strength, msg[1]);
    });
    this.addCommand("contour", "f", {|msg|
      synth.set(\contour, msg[1]);
    });
    this.addCommand("bow_level", "f", {|msg|
      synth.set(\bow_level, msg[1]);
    });
    this.addCommand("blow_level", "f", {|msg|
      synth.set(\blow_level, msg[1]);
    });
    this.addCommand("strike_level", "f", {|msg|
      synth.set(\strike_level, msg[1]);
    });
    this.addCommand("flow", "f", {|msg|
      synth.set(\flow, msg[1]);
    });
    this.addCommand("mallet", "f", {|msg|
      synth.set(\mallet, msg[1]);
    });
    this.addCommand("bow_timb", "f", {|msg|
      synth.set(\bow_timb, msg[1]);
    });
     this.addCommand("blow_timb", "f", {|msg|
      synth.set(\blow_timb, msg[1]);
    });
    this.addCommand("strike_timb", "f", {|msg|
      synth.set(\strike_timb, msg[1]);
    });
    this.addCommand("geom", "f", {|msg|
      synth.set(\geom, msg[1]);
    });
    this.addCommand("bright", "f", {|msg|
      synth.set(\bright, msg[1]);
    });
    this.addCommand("damp", "f", {|msg|
      synth.set(\damp, msg[1]);
    });
    this.addCommand("pos", "f", {|msg|
      synth.set(\pos, msg[1]);
    });
    this.addCommand("space", "f", {|msg|
      synth.set(\space, msg[1]);
    });
    this.addCommand("model", "f", {|msg|
      synth.set(\model, msg[1]);
    });
    this.addCommand("mul", "f", {|msg|
      synth.set(\mul, msg[1]);
    });
    this.addCommand("add", "f", {|msg|
      synth.set(\add, msg[1]);
    });
  

  }

  free {
    synth.free;
  }
}