if (!isServer) exitWith {};
params ["_obj"];

_obj allowDamage false;
_obj hideObjectGlobal true;
_obj enableSimulationGlobal false;

private _bomb = "Bo_GBU12_LGB" createVehicle (getPosATL _obj);

private _posASL = (getPosASL _obj);
[_obj, _posASL] spawn {
    params ["_obj", "_posASL"];
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
    playSound3D [(getMissionPath _rndExplosionSFX), _obj, false, _posASL, 5, 1, 10000];
    sleep 0.1;
    playSound3D [(getMissionPath _rndExplosionAdd), _obj, false, _posASL, 5, 1, 10000];
    sleep 0.1;
    playSound3D [(getMissionPath _rndExplosionAddExtra), _obj, false, _posASL, 5, 1, 15000];
};
[_obj] remoteExecCall ["andia_fnc_FL_cacheExplodeFX", [0,-2] select isDedicated];

//_obj setVariable ["andia_FL_cache_armed", nil, true];
//_obj setVariable ["andia_FL_cache_jipID", nil, true];
[{deleteVehicle _this}, _obj, 3] call CBA_fnc_waitAndExecute;