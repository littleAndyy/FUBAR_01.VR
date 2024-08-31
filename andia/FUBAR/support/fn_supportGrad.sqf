if (!hasInterface) exitWith {};
params ["_unit", ["_delay", 1200]];

private _name = name _unit;
private _side = side _unit;
private _cooldownSide = format ["andia_grad_cooldown_%1", _side];
private _cooldown = missionNamespace getVariable _cooldownSide;

if (!isNil {_cooldown}) exitWith {
    {
        if (side _x == _side) then {
            [(format ["%1 - Rocket artillery is on cooldown", _side])] remoteExec ["hintSilent", _x];
        };
    } forEach allPlayers;
};

openMap [true,true];
["rocket_support", "onMapSingleClick", {
    params ["","_pos","",""];
    _name = name player;
    _side = side player;
    {
        if (side _x == _side) then {
            [(format ["%1 - %2 has called in rocket artillery.", _side, _name])] remoteExec ["hintSilent", _x];
        };
    } forEach allPlayers;
    openMap [false,false];
    [_pos] spawn {
        params ["_pos"];
        sleep 48;
        [
            _pos, // target
            "Rocket_03_HE_F", // ammo
            250, // radius
            40, // rounds
            [0.2,1.1], // delay
            {false}, // conditionEnd
            25, // safezone
            100, // altitude
            10000 // speed
        ] remoteExec ["BIS_fnc_fireSupportVirtual", 2];
    };
    [] spawn {
        sleep 8;
        [[(getMissionPath "andia\FUBAR\support\sound\Katyusha_Launch_Explosion.ogg"), 1.1, 1]] remoteExec ["playSoundUI", [0,-2] select isDedicated];
        //addCamShake [0.7,5.5,35];
        /*for "_i" from 1 to 40 do {
            private _rndSound = selectRandom [
                "andia\FUBAR\support\sound\bm21_fire_far_02.ogg",
                "andia\FUBAR\support\sound\bm21_fire_far_02.ogg",
                "andia\FUBAR\support\sound\bm21_fire_far_03.ogg",
                "andia\FUBAR\support\sound\bm21_fire_far_04.ogg",
                "andia\FUBAR\support\sound\bm21_fire_far_05.ogg",
                "andia\FUBAR\support\sound\bm21_fire_far_06.ogg"
            ];
            [[0.7,0.7,9]] remoteExec ["addCamShake", [0,-2] select isDedicated];
            [[(getMissionPath _rndSound), 0.4, 1]] remoteExec ["playSoundUI", [0,-2] select isDedicated];
            sleep (random [0.3,0.4,1.1]);
        };*/
    };
    ["rocket_support", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
}] call BIS_fnc_addStackedEventHandler;


//"andia_grad_cooldown_blufor"
//"andia_grad_cooldown_east"
//"andia_grad_cooldown_guer"
//missionNameSpace setVariable ["andia_grad_cooldown_east", nil, true];
missionNameSpace setVariable [_cooldownSide, _delay, true];
sleep _delay;
missionNameSpace setVariable [_cooldownSide, nil, true];

{
    if (side _x == _side) then {
        [(format ["%1 - Rocket artillery is available!", _side])] remoteExec ["hintSilent", _x];
    };
} forEach allPlayers;