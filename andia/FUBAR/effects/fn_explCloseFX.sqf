if (!hasInterface) exitWith {};
if (floor (random 2) == 0) exitWith {};
params ["_pos", "_size"];

private _light = "#lightpoint" createVehicleLocal _pos;
_light setLightColor [1, (random [0.4,0.8,1]), (random [0.1,0.4,0.6])];
_light setLightIntensity (6*(_size/2));
_light setLightBrightness (0.02*(_size/2));
//systemChat format ["_intensity = %1", (5*(_size/2))];
//systemChat format ["_brightness = %1", (0.01*(_size/2))];
_light setLightAmbient [1, (random [0.6,0.8,1]), (random [0.1,0.3,0.4])];
_light setLightDayLight true;
_light setLightFlareSize (0.005*(_size/2));
_light setLightFlareMaxDistance 3000;
_light setLightUseFlare true;

private _sparks = "#particlesource" createVehicleLocal _pos;
_sparks setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal.p3d",16,12,1,1],"","Billboard",1,9,[0,0,0],[0,0,4],1,500,35,0.1,[(0.0001*(_size/2)),0],[[1,1,0.720384,-100],[0,0,0,0]],[1,0],3,1,"","","",0,false,0.31,[[500000,400000,5000,10000],[0,0,0,0]],[0,1,0]];
_sparks setParticleRandom [1,[0,0,0],[39,39,29],3,1,[0,0,0,0],2,2,0,0];
_sparks setParticleCircle [0,[1,1,1]];
_sparks setDropInterval 0.002;

[{
    _light = (_this#0);
    _sparks = (_this#1);
    deleteVehicle _light;
    deleteVehicle _sparks;
}, [_light, _sparks], 0.15] call CBA_fnc_waitAndExecute;