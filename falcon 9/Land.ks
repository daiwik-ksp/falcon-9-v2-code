runpath("0:/function.ks").
clearscreen.
print "Falcon 9 landing software ".

set SburnAlt to 6000.

lock aoa to -5. 
lock error to 1.                                              


RCS on.
lock steering to   getSteering(). 
wait until ship:verticalspeed <-700.
    lock throttle to 1.
    toggle AG6.
	RCS off.

wait until ship:verticalspeed > -310.
lock aoa to 15.
    lock throttle to 0.
    lock steering to getSteering().

wait until alt:radar < 12000.
    lock aoa to 10.5.

wait until  alt:radar < 7000. 
    lock aoa to 7.

wait until alt:radar < SburnAlt.
lock aoa to -8.

setHoverPIDLOOPS().
setHoverAltitude(100).
setHoverDescendSpeed(45).

wait until alt:radar < 1000.
setHoverDescendSpeed(35).

wait until alt:radar < 500.
toggle ag1.
lock steering to getVectorSurfaceRetrograde().
setHoverDescendSpeed(25).

wait until alt:radar < 200 .

setHoverDescendSpeed(6).
gear on.
lock steering to getVectorSurfaceRetrograde().
wait until ship:status = "landed".
print "landed".
lock throttle to 0.
lock steering to up.
wait 2000.

  
   
