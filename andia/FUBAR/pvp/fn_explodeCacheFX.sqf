params ["_obj"];

addCamShake [3.5,9,35];

private _pos = getPosATL _obj;
private _distance = (player distance _pos);
private _suppression = (
    (player getVariable "ANDIA_FUBAR_SuppressionValue") 
    + ((1.5 * (3300*0.05)) / _distance)
);
player setVariable ["ANDIA_FUBAR_SuppressionValue", _suppression];
[player] call andia_fnc_suppressionMain;
if (_distance <= 75) then {
    playSoundUI [(getMissionPath "andia\fubar\suppression\sound\sfx_tinnitus_short.ogg"), (0.1*_suppression), 1];
    [{
        private _rndDebrisSFX = selectRandom [
            "andia\FUBAR\pvp\sound\hll_debris_hard_rock_01.ogg",
            "andia\FUBAR\pvp\sound\hll_debris_hard_rock_02.ogg",
            "andia\FUBAR\pvp\sound\hll_debris_hard_rock_03.ogg",
            "andia\FUBAR\pvp\sound\hll_debris_hard_rock_04.ogg",
            "andia\FUBAR\pvp\sound\hll_debris_hard_rock_05.ogg"
        ];
        playSoundUI [(getMissionPath _rndDebrisSFX), 0.6, 1, true];
    }, [], 2] call CBA_fnc_waitAndExecute;
};

private _light = "#lightpoint" createVehicleLocal _pos;
_light setLightIntensity 5000000;
_light setLightColor [1,0.6,0.2];
_light setLightAmbient [1,0.6,0.2];
_light setLightDayLight true;
_light setLightFlareSize 50;
_light setLightFlareMaxDistance 5000;
_light setLightUseFlare true;

_light spawn {
    params ["_light"];
    private _intensity = 5000000;
    while {true} do {
        _intensity = (_intensity * 0.95);
        _light setLightIntensity _intensity;
        if (_intensity <= 0) exitWith {
            deleteVehicle _light;
        };
        sleep 0.01;
    };
};

private _sparks = "#particlesource" createVehicleLocal _pos;
_sparks setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal.p3d",16,12,1,1],"","Billboard",1,9,[0,0,0],[0,0,9],1,0.007,0.0038,0.1,[((random [0.8,1,1.2])*0.0001*(4800/2)),0],[[1,1,0.720384,-100],[0,0,0,0]],[1,0],3,1,"","","",0,false,0.21,[[50000,40000,(random [5000,25000,35000]),1000],[0,0,0,0]],[0,1,0]];
_sparks setParticleRandom [1,[0,0,0],[(19*(random [-0.2,1,2.5])),(19*(random [-0.2,1,2.5])),(29*(random [-0.1,1,2.5]))],3,1,[0,0,0,0],2,2,0,0];
_sparks setParticleCircle [0,[1,1,1]];
_sparks setDropInterval 0.001;

_rocks1 = "#particlesource" createVehicleLocal _pos;
_rocks1 setParticleParams [["\A3\data_f\ParticleEffects\Universal\Mud.p3d", 1, 0, 1], "", "SpaceObject", 1, 15.0, [0, 0, 0], [0, 0, 15], 5, 100, 7.9, 1, [.55, .35, 0], [[0.1, 0.1, 0.1, 1], [0.25, 0.25, 0.25, 0.5], [0.5, 0.5, 0.5, 0]], [0.08], 1, 0, "", "", _pos,0,false,0.3];
_rocks1 setParticleRandom [0, [1, 1, 0], [20, 20, 15], 3, 0.25, [0, 0, 0, 0.1], 0, 0];
_rocks1 setDropInterval 0.008;
_rocks1 setParticleCircle [0, [0, 0, 0]];

private _smoke = "#particlesource" createVehicleLocal _pos;
_smoke setVectorUp surfaceNormal _pos;
//_smoke setVehiclePosition [getpos _smoke,[],0,"none"];
_smoke setParticleCircle [6, [-3, -3, 3]];
_smoke setParticleRandom [1, [0.25, 0.25, 0], [3, 3, 15], 0.5, 0.25, [0, 0, 0, 0.1], 0, 0];
_smoke setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1, 9, [0,0,0], [0, 0, 0.1], 8, 25, 7.9, 0.01, [3, 9, 14, 14, 0], [[0.025, 0.015, 0.01, 0.1],[0.06, 0.05, 0.04, 0.9],[0.08, 0.07, 0.06, 0.9],[0.11, 0.1, 0.09, 0.9], [0.13, 0.12, 0.11, 0]], [0.08], 1, 0, "", "", _pos];
_smoke setDropInterval 0.0009;

/*_shockwave = "#particlesource" createVehicleLocal _pos;
_shockwave setParticleParams [
    [
        "\A3\data_f\ParticleEffects\Universal\refract",
        1,
        0,
        1,
        0
    ],
    "",
    "Billboard",
    1.0,
    0.8,
    [0,0,0],
    [0.2,0.5,0.2],
    0,
    10,
    7.9000001,
    0.1,
    [1,16,40,70,180,300],
    [[0.1,0.1,0.1,1],[0.25,0.25,0.25,1],[0.5,0.5,0.5,1],[0,0,0,1],[0,0,0,0.5],[0,0,0,0.3]],
    [1],
    0.2,
    0.2,
    "",
    "",
    _pos
];
//_shockwave setParticleRandom [0, [0, 0, 0], [0.2,0.5,0.2], 0, 0, [0, 0, 0, 0], 0, 0, 0, 0];
_shockwave setDropInterval 0.4;
_shockwave setParticleCircle [0, [0, 0, 0]];*/

drop
[
    [
        "\A3\data_f\ParticleEffects\Universal\refract",
        1,
        0,
        1,
        0
    ],
    "",
    "Billboard",
    1.0,
    0.6,
    [0,0,0],
    [0.2,0.5,0.2],
    0,
    10,
    7.9000001,
    0.1,
    [1,12,48,110,240,480],
    [[0.9,0.9,0.9,1],[0.9,0.9,0.9,1],[0.9,0.9,0.9,1],[0,0,0,1],[0,0,0,0.5],[0,0,0,0.3]],
    [1],
    0.2,
    0.2,
    "",
    "",
    _obj
];

[{
    _sparks = (_this#0);
    _rocks1 = (_this#1);
    _smoke = (_this#2);
    deleteVehicle _sparks;
    deleteVehicle _rocks1;
    deletevehicle _smoke;
}, [_sparks, _rocks1, _smoke], 0.2] call CBA_fnc_waitAndExecute;

/*private _lightPFH = ([{
    params ["_args"];
    systemChat str _args;
    private _obj = _args#0;
    private _light = _args#1;
    private _fxArray = _obj getVariable "andia_explodeCacheFX";
    private _intensity = _fxArray#0;
    private _color = _fxArray#1;
    _intensity = (_intensity * 0.9);
    _color = (_color apply {_x * 0.8});
    _light setLightIntensity _intensity;
    _light setLightColor _color;
    _light setLightAmbient _color;
    if (_intensity <= 0) then {
        private _id = _light getVariable "andia_explodeCacheFX_PFH";
        [_id] call CBA_fnc_removePerFrameHandler;
        deleteVehicle _light;
    };
} , 0.1, [_obj, _light]] call CBA_fnc_addPerFrameHandler);
_obj setVariable ["andia_explodeCacheFX_PFH", _lightPFH];*/