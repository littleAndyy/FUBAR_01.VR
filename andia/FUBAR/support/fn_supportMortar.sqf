if (!hasInterface) exitWith {};
params ["_unit", ["_delay", 300]];

private _name = name _unit;
private _side = side _unit;
private _cooldownSide = format ["andia_mortar_cooldown_%1", _side];
private _cooldown = missionNamespace getVariable _cooldownSide;

if (!isNil {_cooldown}) exitWith {
    {
        if (side _x == _side) then {
            [(format ["%1 - Mortar support is on cooldown", _side])] remoteExec ["hintSilent", _x];
        };
    } forEach allPlayers;
};

openMap [true,true];
["mortar_support", "onMapSingleClick", {
    params ["","_pos","",""];
    _name = name player;
    _side = side player;
    {
        if (side _x == _side) then {
            [(format ["%1 - %2 has called in mortar support.", _side, _name])] remoteExec ["hintSilent", _x];
        };
    } forEach allPlayers;
    openMap [false,false];
    [_pos] spawn {
        params ["_pos"];
        sleep 20;
        [
            _pos, // target
            "Sh_82mm_AMOS", // ammo
            100, // radius
            6, // rounds
            3, // delay
            {false}, // conditionEnd
            0, // safezone
            250, // altitude
            100 // speed
        ] remoteExec ["BIS_fnc_fireSupportVirtual", 2];
    };
    [] spawn {
        sleep 3;
        for "_i" from 1 to 6 do {
            private _rndSound = selectRandom [
                "andia\FUBAR\support\sound\Mortar_81mm_fire_far_01.ogg",
                "andia\FUBAR\support\sound\Mortar_81mm_fire_far_02.ogg",
                "andia\FUBAR\support\sound\Mortar_81mm_fire_far_03.ogg",
                "andia\FUBAR\support\sound\Mortar_81mm_fire_far_04.ogg",
                "andia\FUBAR\support\sound\Mortar_81mm_fire_far_05.ogg"
            ];
            [[0.5,0.5,12]] remoteExec ["addCamShake", [0,-2] select isDedicated];
            [[(getMissionPath _rndSound), 0.9, 1]] remoteExec ["playSoundUI", [0,-2] select isDedicated];
            sleep 3;
        };
    };
    ["mortar_support", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
}] call BIS_fnc_addStackedEventHandler;


//"andia_mortar_cooldown_blufor"
//"andia_mortar_cooldown_opfor"
//"andia_mortar_cooldown_guer"
//missionNameSpace setVariable ["andia_mortar_cooldown_opfor", nil, true];
missionNameSpace setVariable [_cooldownSide, _delay, true];
sleep _delay;
missionNameSpace setVariable [_cooldownSide, nil, true];

{
    if (side _x == _side) then {
        [(format ["%1 - Mortar support is available!", _side])] remoteExec ["hintSilent", _x];
    };
} forEach allPlayers;