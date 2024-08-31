if (!hasInterface) exitWith {};
params ["_unit", ["_delay", 600]];

private _name = name _unit;
private _side = side _unit;
private _cooldownSide = format ["andia_hartillery_cooldown_%1", _side];
private _cooldown = missionNamespace getVariable _cooldownSide;

if (!isNil {_cooldown}) exitWith {
    {
        if (side _x == _side) then {
            [(format ["%1 - Heavy artillery support is on cooldown", _side])] remoteExec ["hintSilent", _x];
        };
    } forEach allPlayers;
};

openMap [true,true];
["hartillery_support", "onMapSingleClick", {
    params ["","_pos","",""];
    _name = name player;
    _side = side player;
    {
        if (side _x == _side) then {
            [(format ["%1 - %2 has called in heavy artillery.", _side, _name])] remoteExec ["hintSilent", _x];
        };
    } forEach allPlayers;
    openMap [false,false];
    [_pos] spawn {
        params ["_pos"];
        sleep 18;
        [
            _pos, // target
            "Sh_155mm_AMOS", // ammo
            120, // radius
            1, // rounds
            [0.2,1.5], // delay
            {false}, // conditionEnd
            60, // safezone
            1000, // altitude
            500 // speed
        ] remoteExec ["BIS_fnc_fireSupportVirtual", 2];
        sleep 24; // 
        [
            _pos, // target
            "Sh_155mm_AMOS", // ammo
            100, // radius
            1, // rounds
            [0.2,1.5], // delay
            {false}, // conditionEnd
            40, // safezone
            1000, // altitude
            500 // speed
        ] remoteExec ["BIS_fnc_fireSupportVirtual", 2];
        sleep 24; // 
        [
            _pos, // target
            "Sh_155mm_AMOS", // ammo
            100, // radius
            3, // rounds
            [3,8], // delay
            {false}, // conditionEnd
            0, // safezone
            1000, // altitude
            500 // speed
        ] remoteExec ["BIS_fnc_fireSupportVirtual", 2];
        sleep 10.8; // 
        [
            _pos, // target
            "Sh_155mm_AMOS", // ammo
            100, // radius
            3, // rounds
            [3,8], // delay
            {false}, // conditionEnd
            0, // safezone
            1000, // altitude
            500 // speed
        ] remoteExec ["BIS_fnc_fireSupportVirtual", 2];
        sleep 10.8; // 
        [
            _pos, // target
            "Sh_155mm_AMOS", // ammo
            100, // radius
            3, // rounds
            [3,8], // delay
            {false}, // conditionEnd
            0, // safezone
            1000, // altitude
            500 // speed
        ] remoteExec ["BIS_fnc_fireSupportVirtual", 2];
    };
    [] spawn {
        private _rndSound = selectRandom [
            "andia\FUBAR\support\sound\artillery_hll_amb_25.ogg",
            "andia\FUBAR\support\sound\artillery_hll_amb_21.ogg"
        ];
        sleep 6;
        [[(getMissionPath _rndSound), 3, 1]] remoteExec ["playSoundUI", [0,-2] select isDedicated];
        _rndSound = selectRandom [
            "andia\FUBAR\support\sound\artillery_hll_amb_25.ogg",
            "andia\FUBAR\support\sound\artillery_hll_amb_21.ogg"
        ];
        sleep 24;
        [[(getMissionPath _rndSound), 3, 1]] remoteExec ["playSoundUI", [0,-2] select isDedicated];
        //addCamShake [0.9,3.5,30];
        sleep 24;
        [[(getMissionPath "andia\FUBAR\support\sound\artillery_hll_amb_20.ogg"), 3, 1]] remoteExec ["playSoundUI", [0,-2] select isDedicated];
        sleep 10.8;
        [[(getMissionPath "andia\FUBAR\support\sound\artillery_hll_amb_20.ogg"), 3, 1]] remoteExec ["playSoundUI", [0,-2] select isDedicated];
        sleep 10.8;
        [[(getMissionPath "andia\FUBAR\support\sound\artillery_hll_amb_20.ogg"), 3, 1]] remoteExec ["playSoundUI", [0,-2] select isDedicated];
        //addCamShake [0.9,3.5,30];
    };
    ["hartillery_support", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
}] call BIS_fnc_addStackedEventHandler;


//"andia_hartillery_cooldown_blufor"
//"andia_hartillery_cooldown_east"
//"andia_hartillery_cooldown_guer"
//missionNameSpace setVariable ["andia_hartillery_cooldown_east", nil, true];
missionNameSpace setVariable [_cooldownSide, _delay, true];
sleep _delay;
missionNameSpace setVariable [_cooldownSide, nil, true];

{
    if (side _x == _side) then {
        [(format ["%1 - Heavy artillery is available!", _side])] remoteExec ["hintSilent", _x];
    };
} forEach allPlayers;