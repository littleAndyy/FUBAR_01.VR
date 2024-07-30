if (!isServer) exitWith {};
params ["_obj"];

_obj hideObjectGlobal true;
_obj enableSimulationGlobal false;

private _bomb = "Bo_GBU12_LGB" createVehicle (getPosATL _obj);

private _rndExplosionSFX = selectRandom [
    "andia\FUBAR\pvp\sound\explCache_01.ogg",
    "andia\FUBAR\pvp\sound\explCache_02.ogg",
    "andia\FUBAR\pvp\sound\explCache_03.ogg"
];
private _rndExplosionAdd = selectRandom [
    "andia\FUBAR\pvp\sound\body_big_02_001.ogg",
    "andia\FUBAR\pvp\sound\body_big_02_002.ogg",
    "andia\FUBAR\pvp\sound\body_big_02_003.ogg"
];
private _rndExplosionAddExtra = selectRandom [
    "andia\FUBAR\pvp\sound\explosion_body_big_001.ogg",
    "andia\FUBAR\pvp\sound\explosion_body_big_002.ogg",
    "andia\FUBAR\pvp\sound\explosion_body_big_003.ogg",
    "andia\FUBAR\pvp\sound\explosion_body_big_004.ogg"
];
private _posASL = (getPosASL _obj);
playSound3D [(getMissionPath _rndExplosionSFX), _obj, false, _posASL, 5, 1, 10000, 0];
playSound3D [(getMissionPath _rndExplosionAdd), _obj, false, _posASL, 5, 1, 10000, 0];
playSound3D [(getMissionPath _rndExplosionAddExtra), _obj, false, _posASL, 5, 1, 15000, 0];
[_obj] remoteExecCall ["andia_fnc_explodeCacheFX", [0,-2] select isDedicated];

_obj setVariable ["andia_fnc_explodeCache_armed", nil, true];
_obj setVariable ["andia_fnc_explodeCache_jipID", nil, true];
[{deleteVehicle _this}, _obj, 1.5] call CBA_fnc_waitAndExecute;