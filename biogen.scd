// boot if needed
s.boot;

(

// Read in OSC messages for drone
OSCdef.new(
	\inpan,
	{
		arg msg, time, addr, port;
		x.set(\pan, msg[1].linlin(0,1,-1,1));
		a.set(\pan, msg[1].linlin(0,1,-1,1));
		b.set(\pan, msg[1].linlin(0,1,-1,1));
		c.set(\pan, msg[1].linlin(0,1,-1,1));
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
		a.set(\freq, msg[1].linexp(0,1, 250, 300)); // stay within D range
		b.set(\freq, msg[1].linexp(0,1, 325, 375)); // stay within F range
		c.set(\freq, msg[1].linexp(0,1, 420, 460)); // stay within F range
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

SynthDef(\synth1, {arg out=0, freq=440, envdur=1, amp=0.1, pan=0;
    var x, env;
    env = EnvGen.kr(Env.perc(0.001, envdur, amp), doneAction:2);
    x = Mix.ar([FSinOsc.ar(freq, pi/2, 0.5), Pulse.ar(freq,Rand(0.3,0.7))]);
    x = RLPF.ar(x,freq*4,Rand(0.04,1));
    x = Pan2.ar(x,pan);
    Out.ar(out, x*env);
}).add; // you can also load the synthdefs, but then you need to run the following line

// Dm chord clock
TempoClock.default.tempo = 1;
Tdef(\D, { loop({ Synth(\synth1, [\freq, 293.66+(30.rand)]); 0.25.wait; }) }); // D

Tdef(\F, { loop({ Synth(\synth1, [\freq, 349.23+(30.rand)]); 1.wait; }) }); // F

Tdef(\A, { loop({ Synth(\synth1, [\freq, 440+(30.rand)]); 1.wait; }) }); // A

x = Synth.new(\tone, [\gate, 1]);
a = Tdef(\D).play(quant:1);
b = Tdef(\F).play(quant:1);
c = Tdef(\A).play(quant:1);
)