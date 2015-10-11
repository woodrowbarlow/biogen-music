

(
//s.boot;
var sound;
OSCdef.new(
	\gyrox,
	{
		arg msg, time, addr, port;
		sound = {SinOsc.ar(msg[1]/4, 0, 0.5)};
		sound.play;
		//x = Bus.control(s,2);
		//inArray = msg[1]/;
		//{SinOsc.ar(msg[1]/4, 0, 0.5)}.play;
	},
	'/gyro/x'
);

{SinOsc.ar(inArray/4, 0, 0.5)}.play;

)