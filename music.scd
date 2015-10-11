(
~freq = 440; // set initial value to 'A'

OSCdef.new(
    \gyrox,
    {
        arg msg, time, addr, port;
		[msg,time,addr,port].postln;
		~freq = abs(msg[1] - 1200); // so we can notice a change
		~freq.postln;
    }, '/gyro/x',n);
)

SynthDef.new("A",{Out.ar(0, SinOsc.ar(~freq,0,0.2)) });
a = Synth("A").play;
)


// Example sounds
{SinOsc.ar(440, 0, 0.2)}.play;

{SinOsc.ar(220, 0, 0.2)}.play;


