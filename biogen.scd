// boot if needed
s.boot;

(

// Read in OSC messages for drone
OSCdef.new(
	\inpan,
	{
		arg msg, time, addr, port;
		x.set(\pan, msg[1].linlin(0,1,-1,1));
	},
	'/inputs/pan'
);
OSCdef.new(
	\innharm,
	{
		arg msg, time, addr, port;
		x.set(\nharm, msg[1].linlin(0,1, 1, 50));
	},
	'/inputs/nharm'
);
OSCdef.new(
	\inamp,
	{
		arg msg, time, addr, port;
		x.set(\amp, msg[1].linexp(0,1,0.001,1));
	},
	'/inputs/amp'
);
OSCdef.new(
	\infreq,
	{
		arg msg, time, addr, port;
		x.set(\freq, msg[1].linexp(0,1, 20, 500));
		a.set(\freq, msg[1].linexp(0,1, 20, 500));
	},
	'/inputs/freq'
);
OSCdef.new(
	\indetune,
	{
		arg msg, time, addr, port;
		x.set(\detune, msg[1].linexp(0,1,0.01,12));
	},
	'/inputs/detune'
);


SynthDef.new(\tone, {
	arg freq=40, nharm=12, detune=0.2, gate=0, pan=0, amp=1, out=0;
	var sig, env;
	env = EnvGen.kr(Env.adsr(0.05,0.1,0.5,3), gate);
	sig = Blip.ar(
		freq * LFNoise1.kr(0.2!16), bipolar(detune.neg, detune).midiratio, nharm
	);
	sig = sig * LFNoise1.kr(0.5!16).exprange(0.1,1);
	sig = Splay.ar(sig);
	sig = Balance2.ar(sig[0], sig[1], pan);
	sig = sig * env * amp;
	Out.ar(out, sig)
}).add;

// Dm chord clock
TempoClock.default.tempo = 1;
Tdef(\D, { loop({ Synth(\synth1, [\freq, 293.66+(30.rand)]); 0.25.wait; }) }); // D

Tdef(\F, { loop({ Synth(\synth1, [\freq, 349.23+(30.rand)]); 1.wait; }) }); // F

Tdef(\A, { loop({ Synth(\synth1, [\freq, 440+(30.rand)]); 1.wait; }) }); // A

x = Synth.new(\tone, [\gate, 1]);
a = Tdef(\D).play(quant:1);
//Tdef(\D).play(quant:1);
Tdef(\F).play(quant:1);
Tdef(\A).play(quant:1);
)

x.set(\freq, 50)
x.set(\freq, 60)
x.set(\freq, 70)
x.set(\pan, -1)
x.set(\pan, 1)
x.set(\pan, 0)
x.set(\nharm, 0)
x.set(\nharm, 12)
x.set(\nharm, 24)
x.set(\nharm, 48)
x.set(\nharm, 100)
x.set(\detune, 1)
x.set(\detune, 2)
x.set(\detune, 0.1)
x.set(\amp, 0.2)
x.set(\amp, 0.4)
x.set(\amp, 1)
x.set(\gate, 0)
x.set(\gate, 1)
x.free