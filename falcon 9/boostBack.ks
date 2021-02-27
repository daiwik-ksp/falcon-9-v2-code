Clearscreen.
switch to 0.

SET runMode to 0.

RCS on.
SAS off.
SET landingpad TO latlng(-0.205693190045787,-74.4730865932267). //change to your landing pad latitude and longtitude
SET targetDistOld TO 0.
SET landingpoint TO ADDONS:TR:IMPACTPOS.
set langoffset to (landingpad:LNG - ADDONS:TR:IMPACTPOS:LNG)*10472.
set latoffset to (landingpad:LAT - ADDONS:TR:IMPACTPOS:LAT)*10472.
lock steering to heading (landingpad:heading, 10).
wait 10.
toggle AG1.
lock  throttle to 1.
RCS off.

when altitude > 4000 then {
set langoffset to (landingpad:LNG - ADDONS:TR:IMPACTPOS:LNG)*10472.
set latoffset to (landingpad:LAT - ADDONS:TR:IMPACTPOS:LAT)*10472.
wait 0.1.
PRINT langoffset.
preserve.
}

when langoffset > -10000 then {
	    
TOGGLE AG1.
lock throttle to 0.6.
}

when langoffset > 1000 then {
lock throttle to 0.4.
		}
				
when langoffset > 2500 then {  //how far past the landing pad your impact position should be so that after the entry burn the impact position will be roughly near the landing pad. Experiment with this until you get what you desire.
SET throttle TO 0.
unlock throttle.
unlock steering.
TOGGLE AG1.
WAIT 1.
TOGGLE AG1.
lock steering to heading(90,90).
brakes on.
wait until ship:verticalspeed < -300.
unlock steering.
runpath("0:/Falcon 9/land.ks").  //landing guidance start
}
                                      
When throttle > 0 then {
when latoffset < -10 then {
lock steering to heading (landingpad:Heading - 15,10).
preserve.
}

when latoffset > 10 then {
lock steering to heading (landingpad:heading + 15,10).
preserve.
}

}

wait until ship:verticalspeed < -20.
lock steering to heading(90,90).
brakes on.
wait until ship:verticalspeed < 300.
unlock steering.
   runpath("0:/Falcon 9/land.ks"). 