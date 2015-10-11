/**
   This runs when the jack server starts up.
   
   It goes in ~/.config/SuperCollider/startup.scd
*/

GUI.qt; // for some compatability issues

(
s = Server.default;
s.options.memSize = 1000000; // This is in kb. Change as needed
s.boot;
)
