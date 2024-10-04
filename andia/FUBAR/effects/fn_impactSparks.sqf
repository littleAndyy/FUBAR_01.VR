if (!hasInterface) exitWith {};
if (floor (random 4) == 0) exitWith {};
params ["_pos", "_velocityVector", "_caliber"];

//if (player distance2D _pos > 1000) exitWith {};

if (_caliber < 0.8) exitWith {};
if ((random [0.2, 1.0, 3.2]) > _caliber) exitWith {};

_velocityVector = _velocityVector vectorMultiply (random [-0.01,0.01,0.05]);
if (_caliber >= 9) then {
    _caliber = 9;
};
private _randomSize = (random [0.8,1,2.5]) * _caliber;

private _sparks = "#particlesource" createVehicleLocal _pos;
_sparks setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal.p3d",16,12,1,1],"","Billboard",1,(0.5 + random 6.5),[0,0,0],_velocityVector,1,0.0088,0.0038,0.15,[(0.0125*_randomSize),0],[[1,1,0.720384,-100],[0,0,0,0]],[1,0],3,1,"","","",0,false,0.31,[[45000,(random [20000,30000,45000]),(random [5000,10000,15000]),1000],[0,0,0,0]],[0,1,0]];
_sparks setParticleRandom [1,[0,0,0],[(19*(random [-0.5,1,2.5])),(19*(random [-0.5,1,2.5])),(19*(random [-0.5,1,2.5]))],3,1,[0,0,0,0],2,2,0,0];
_sparks setParticleCircle [0,[1,1,1]];
_sparks setDropInterval 0.002;

private _light = "#lightpoint" createVehicleLocal _pos;
_light setLightColor [1, (random [0.6,0.8,1]), (random [0.1,0.3,0.6])];
_light setLightIntensity (2.5*_caliber*_randomSize);
_light setLightBrightness (0.5*_caliber*_randomSize);
//systemChat format ["_intensity = %1", (5*(_size/2))];
//systemChat format ["_brightness = %1", (0.01*(_size/2))];
_light setLightAmbient [1, (random [0.6,0.8,1]), (random [0.1,0.3,0.6])];
_light setLightDayLight true;
//_light setLightFlareSize (0.01*(_caliber/2));
//_light setLightFlareMaxDistance 3000;
//_light setLightUseFlare false;

[{
    _light = (_this#0);
    _sparks = (_this#1);
    deleteVehicle _light;
    deleteVehicle _sparks;
}, [_light, _sparks], 0.1] call CBA_fnc_waitAndExecute;