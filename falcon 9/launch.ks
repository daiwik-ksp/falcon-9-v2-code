switch to 0.
runpath("0:/function.ks").
//-------------------launch veriables-------------//
set pitchRate to 0.001.
set targetAp to 70000.

//-----------------------------------------------//
set vdeg to 90.
set shipPitch to 90.
set shipHed to 90.
set thrToWeight to 1.5.
lock g to constant:g * body:mass / body:radius^2.
lock thrott to thrToWeight * ship:mass * g / ship:availablethrust.
//-----------------------------------------------//

function launch{
    lock throttle to 1.
    toggle ag2.
    wait 3.
    lock steering to heading(shipHed,shipPitch).
    doSafeStage().
    doSafeStage().
    wait until alt:radar > 100.

    until alt:radar > 15000{
    set vdeg to vdeg - pitchRate.
    lock throttle to thrott.
    set shipPitch to vdeg .
    }
   
    until ship:apoapsis >  targetAp{
        lock throttle to 1.   
    }
    lock throttle to 0.
    wait 1.
    stage.
    wait 1.
    stage.
    lock throttle to 1.
    set shipPitch to 10.
    wait until ship:apoapsis > 95000.


}
function Coast{
    lock throttle to 0.
    wait until eta:apoapsis < 28.
}
function Circularize{
    rcs on .
    set shipPitch to 10.
    lock throttle to 1.
    wait until ship:periapsis > targetAp + 100.
    lock throttle to 0. 
}
function doshutdown{
   set ship:control:pilotmainthrottle to 0.
   unlock steering.
   shutdown.
}
function main{
launch().
Coast().
Circularize().
doshutdown().
}
main().