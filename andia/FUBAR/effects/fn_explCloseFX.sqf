if (!hasInterface) exitWith {};
params ["_pos", "_size", "_velocityVector"];

//if (_size < 1000 && (player distance2D _pos > 300)) exitWith {};

if (_size >= 7200) then {
    _size = 7200;
};
if (_size <= 720) then {
    _size = 720;
};

/*if (floor (random 2) == 0) exitWith {
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
};*/

_velocityVector = _velocityVector vectorMultiply (random [-0.12,0.1,0.3]);

private _light = createVehicleLocal ["#lightpoint", _pos, [], 0, "CAN_COLLIDE"];
_light setLightColor [1, (random [0.5,0.6,1]), (random [0.1,0.2,0.4])];
_light setLightIntensity (6*(_size/2)*(random [0.1,1,2]));
_light setLightBrightness (0.02*(_size/2)*(random [0.1,1,2]));
//systemChat format ["_intensity = %1", (5*(_size/2))];
//systemChat format ["_brightness = %1", (0.01*(_size/2))];
_light setLightAmbient [1, (random [0.5,0.6,1]), (random [0.1,0.2,0.4])];
_light setLightDayLight true;
_light setLightFlareSize (0.005*(_size/2));
_light setLightFlareMaxDistance 3000;
_light setLightUseFlare true;

private _sparks = createVehicleLocal ["#particlesource", (getPos player), [], 0, "CAN_COLLIDE"];
_obj = createVehicleLocal ["Sign_Sphere25cm_F", _pos, [], 0, "CAN_COLLIDE"];
_obj hideObject true;
private _sparksSizeInitial = ((random [0.8,1,1.2])*0.00015*(_size/2));
private _rubbing = 0.08;
if (_sparksSizeInitial > 0.5) then {
    _sparksSizeInitial = 0.5;
    _rubbing = 0.03;
};
if (_sparksSizeInitial < 0.06) then {
    _sparksSizeInitial = 0.06;
};
//systemChat str _sparksSizeInitial; // DEBUG
private _sparksSizeOverLife = [_sparksSizeInitial,0]; //0.0001
_sparks setParticleParams [
    ["\A3\data_f\ParticleEffects\Universal\Universal.p3d",16,12,1,1],
    "",
    "Billboard",
    1,
    (3+random 7),
    [0,0,0],
    _velocityVector,
    1,
    0.0088,
    0.0038,
    _rubbing,
    _sparksSizeOverLife, 
    [[1,1,0.720384,-100],[0,0,0,0]],
    [1,0],
    3,
    1,
    "",
    "",
    _obj,
    0,
    false,
    0.21,
    [[45000,(random [25000,35000,45000]),(random [5000,10000,20000]),1000],
    [0,0,0,0]],
    [0,1,0]
];
_sparks setParticleRandom [1,[0,0,0],[(29*(random [-0.5,1,2.5])),(29*(random [-0.5,1,2.5])),(29*(random [-0.5,1,2.5]))],3,1,[0,0,0,0],2,2,0,0];
_sparks setParticleCircle [0,[1,1,1]];
_sparks setDropInterval 0.0015;

private _explSmokeBig = createVehicleLocal ["#particlesource", (getPos player), [], 0, "CAN_COLLIDE"];
if (_size >= 240) then {
    private _rubbingSmoke = 0.35;
    if (_size < 2400) then {
        _rubbingSmoke = 0.5;
    };
    _explSmokeBig setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal.p3d",16,7,48,1],"","Billboard",1,(60*_sparksSizeInitial),[0,0,0],_velocityVector,0,0.49,0.4,_rubbingSmoke,[(6*_sparksSizeInitial*2),(18*_sparksSizeInitial*2),(16*_sparksSizeInitial*2),(13*_sparksSizeInitial*2),(9*_sparksSizeInitial*2)],[[0.116575,0.112729,0.120421,0.624248],[0.478099,0.481944,0.478099,0.351205],[0.505019,0.508865,0.512711,0.2473684],[0.505019,0.508865,0.512711,0.1073684],[0.605019,0.608865,0.612711,0.0173684]],[1.5,0.5,0.5,0.2,0.2],0.1,0.2,"","",_obj,0,false,0,[[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]],[0,1,0]];
    _explSmokeBig setParticleRandom [2,[0.5,0.5,2],[16,16,32],10,0.5,[0,0,0,0],0.5,3,1,0];
    _explSmokeBig setParticleCircle [0,[0,0,0]];
    _explSmokeBig setParticleFire [0,0,0];
    _explSmokeBig setDropInterval 0.0008;
};

private _shakeCoef = 1-((player distance _obj)/1400);
addCamShake [3*(_shakeCoef^2), 1.5, 10];

[{
    _light = (_this#0);
    _sparks = (_this#1);
    _obj = (_this#2);
    _explSmokeBig = (_this#3);
    deleteVehicle _light;
    deleteVehicle _sparks;
    deleteVehicle _obj;
    deleteVehicle _explSmokeBig;
}, [_light, _sparks, _obj, _explSmokeBig], 0.15] call CBA_fnc_waitAndExecute;