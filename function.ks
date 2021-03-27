function doAutoStage {
  if not(defined oldThrust) {
    declare global oldThrust to ship:availablethrust.
  }
  if ship:availablethrust < (oldThrust - 10) {
    doSafeStage(). 
    wait 1.
    declare global oldThrust to ship:availablethrust.
  }
}
parameter landingsite is latlng(-0.20543866388187,-74.4732551043124).//Input the landing latlng() here
//parameter landingsite is vessel("Drone ship 1"):geoposition.//Input the landing latlng() here

function updateReadouts{
Print "FALCON 9 LANDING CONTROL COMPUTER" at ( 2, 1).
Print "-------------------------------------" at ( 2, 2).
Print "____________________________________" at ( 3, 3).
Print "step: " + step at ( 3, 4).
PRINT "Altitude: " + Alt:radar at (3,5).
print "land mode: " + LandMode at (3,6).
//print "Distance to target: " + langoffset at(3,7).
}

function doSafeStage {
  wait until stage:ready.
  stage.
}

function getVectorRadialout{
	SET normalVec TO getVectorNormal().
	return -1*vcrs(ship:velocity:orbit,normalVec).
}
function getVectorNormal{
	return vcrs(ship:velocity:orbit,-body:position).
}
function getVectorSurfaceRetrograde{
	
	return -1*ship:velocity:surface.
}


function setHoverPIDLOOPS{
	//Controls altitude by changing climbPID setpoint
	SET hoverPID TO PIDLOOP(1, 0.01, 0.0, -50, 50). 
	//Controls vertical speed
	SET climbPID TO PIDLOOP(0.1, 0.3, 0.005, 0, 1). 
	//Controls horizontal speed by tilting rocket
	SET eastVelPID TO PIDLOOP(3, 0.01, 0.0, -20, 20).
	SET northVelPID TO PIDLOOP(3, 0.01, 0.0, -20, 20). 
	 //controls horizontal position by changing velPID setpoints
	SET eastPosPID TO PIDLOOP(1700, 0, 100, -40,40).
	SET northPosPID TO PIDLOOP(1700, 0, 100, -40,40).
}

function getImpact {
    if addons:tr:hasimpact { return addons:tr:impactpos. }       
        return ship:geoposition.
}
function lngError {     
    return getImpact():lng - landingsite:lng.
}
function latError {
    return getImpact():lat - landingsite:lat.
}

function errorVector {
    return getImpact():position - landingSite:position.
}

function getSteering {            
    
    local errorVector is errorVector().
        local velVector is -ship:velocity:surface.
        local result is velVector + errorVector*1.
        if vang(result, velVector) > aoa
        {
            set result to velVector:normalized
                          + tan(aoa)*errorVector:normalized.
        }

        return lookdirup(result, facing:topvector).
    }
function setHoverAltitude{ //set just below landing altitude to touchdown smoothly
	parameter a.
	SET hoverPID:SETPOINT TO a.
}

function setHoverDescendSpeed{
	parameter a.
	SET hoverPID:MAXOUTPUT TO a.
	SET hoverPID:MINOUTPUT TO -1*a.
	SET climbPID:SETPOINT TO hoverPID:UPDATE(TIME:SECONDS, SHIP:ALTITUDE). //control descent speed with throttle
	lock throttle TO climbPID:UPDATE(TIME:SECONDS, SHIP:VERTICALSPEED).	
}

function setEngineThrustLimit{

	parameter engineThrustLimit. // 0 - 100

	for e IN ship:partstagged("MainEngine") { SET e:THRUSTLIMIT TO engineThrustLimit. }.

}

function setParameter{	

lock aoa to 40. 
lock error to 1.
}

function setThrustTOWeight{
parameter thrToWeight.
lock g to constant:g * body:mass / body:radius^2.
lock thrott to thrToWeight * ship:mass * g / ship:availablethrust.
lock throttle to thrott.
}

function sendCommToVessel{
	parameter v.
	parameter msg.
	SET C TO v:CONNECTION.
	C:SENDMESSAGE(msg).
}

