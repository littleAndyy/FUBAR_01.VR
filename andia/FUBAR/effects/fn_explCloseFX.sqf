if (!hasInterface) exitWith {};
params ["_pos", "_size", "_velocityVector"];
if (floor (random 2) == 0) exitWith {
    private _light = "#lightpoint" createVehicleLocal _pos;
    _light setLightColor [1, (random [0.5,0.6,1]), (random [0.1,0.2,0.4])];
    _light setLightIntensity (3*(_size/2)*(random [0.1,1,2]));
    _light setLightBrightness (0.01*(_size/2)*(random [0.1,1,2]));
    //systemChat format ["_intensity = %1", (5*(_size/2))];
    //systemChat format ["_brightness = %1", (0.01*(_size/2))];
    _light setLightAmbient [1, (random [0.5,0.6,1]), (random [0.1,0.2,0.4])];
    _light setLightDayLight true;
    [{
        deleteVehicle (_this#0);
    }, [_light], 0.1] call CBA_fnc_waitAndExecute;
};

_velocityVector = _velocityVector vectorMultiply (random [-0.12,0.09,0.2]);

private _light = "#lightpoint" createVehicleLocal _pos;
_light setLightColor [1, (random [0.5,0.6,1]), (random [0.1,0.2,0.4])];
_light setLightIntensity (6*(_size/2)*(random [0.1,1,2]));
_light setLightBrightness (0.02*(_size/2)*(random [0.1,1,2]));
//systemChat format ["_intensity = %1", (5*(_size/2))];
//systemChat format ["_brightness = %1", (0.01*(_size/2))];
_light setLightAmbient [1, (random [0.5,0.6,1]), (random [0.1,0.2,0.4])];
_light setLightDayLight true;
//_light setLightFlareSize (0.005*(_size/2));
//_light setLightFlareMaxDistance 3000;
//_light setLightUseFlare true;

private _sparks = "#particlesource" createVehicleLocal _pos;
_sparks setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal.p3d",16,12,1,1],"","Billboard",1,9,[0,0,0],_velocityVector,1,0.0068,0.0038,0.1,[((random [0.8,1,1.2])*0.0001*(_size/2)),0],[[1,1,0.720384,-100],[0,0,0,0]],[1,0],3,1,"","","",0,false,0.21,[[50000,30000,(random [10000,20000,25000]),1000],[0,0,0,0]],[0,1,0]];
_sparks setParticleRandom [1,[0,0,0],[(29*(random [-0.5,1,2.5])),(29*(random [-0.5,1,2.5])),(29*(random [-0.5,1,2.5]))],3,1,[0,0,0,0],2,2,0,0];
_sparks setParticleCircle [0,[1,1,1]];
_sparks setDropInterval 0.0015;

[{
    _light = (_this#0);
    _sparks = (_this#1);
    deleteVehicle _light;
    deleteVehicle _sparks;
}, [_light, _sparks], 0.15] call CBA_fnc_waitAndExecute;