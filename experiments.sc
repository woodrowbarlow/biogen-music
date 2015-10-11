/**
   Experimenting with SClang. It has everything I never missed from Ruby AND JS!
*/

(
~gxMsg; // This creates an environment variable (basically global, but harder to get rid of, I think)
~gyrox = OSCdef.new(
    \gyrox,
    /*{ arg msg, time, addr;
        ~gxMsg = {msg[1]};
        ~gxMsg.value.postln;
    },*/
    _, // This is a place holder (partial application)
    '/gyro/x'
);
~gyrox.value({ arg msg, time, addr;
    ~gxMsg = {msg[1]};
    ~gxMsg.value.postln;
    {SinOsc.ar(440, 0, 1 - ~gxMsg.value * 2);}.play; // This spawns a metric buttload of nodes
});
//{SinOsc.ar(440, 0, 1 - ~gxMsg * 2);}.play; // This reads ~gxMsg once and then does nothing.
)

(
~partialOSCdef = { arg key, path;
    OSCdef.new(key, _, path).value;
};
~gyroxOSCdef = ~partialOSCdef.value(\gyrox, '/gyro/x').value;
~gyroyOSCdef = ~partialOSCdef.value(\gyroy, '/gyro/y').value;
~gyroxOSCdef.value({ arg msg, time, addr;
        ~gxMsg = {msg[1]};
        ~gxMsg.value.postln;
};);
{SinOsc.ar(~gxMsg.value * 800, 0, 1);}.play;
)

(
// Trying to make a volume object that can be adjusted dynamically from anywhere without destroying everything
~volume = (
    init: { arg vol;
        this.volume = vol;
    },
    setVolume: { arg newVol;
        this.volume = newVol;
    }
)
)
(
OSCdef.new(
    \gyrox,
    { arg msg, time, addr;
        ~gxMsg = {msg[1]};
        ~gxMsg.value.postln;
    },
    '/gyro/x'
);
)
