(

~startClock =0; //initialize the running "clock counter" to zero
SystemClock.sched(0, {
        ~startClock = ~startClock + 1; //increments the clock by 1 every 1ms
        ~myClock = ~startClock - 1; // makes sure the clock at 0 every time it is reset instead of 1
        0.001; //updates the clock every 1ms
});

~freq = 440; // set initial value to 'A'

OSCdef.new(
    \gyrox,
    {
        arg msg, time, addr, port;
		[msg,time,addr,port].postln;
		~freq = abs(msg[1] - 1200); // so we can notice a change
		~freq.postln;
    }, '/gyro/x',n);

SystemClock.sched(0,{
	SynthDef.new("A",{Out.ar(0, SinOsc.ar(~freq,0,0.2)) });
	a = Synth("A").play;
});
)


// Example sounds
{SinOsc.ar(440, 0, 0.2)}.play;

{SinOsc.ar(220, 0, 0.2)}.play;


