params ["_obj", ["_isArmed", false]];

if (isNil {_obj getVariable "andia_FL_cache_marker"}) then {
    private _marker = createMarker [(format ["andia_FL_cache_marker%1", random 99999]), getPosATL _obj];
    _marker setMarkerType "loc_destroy";
    _marker setMarkerColor "ColorWhite";
    _marker setMarkerSize [0.8, 0.8];
    _obj setVariable ["andia_FL_cache_marker", _marker, true];
};

_obj setVectorUp surfaceNormal (getPosATL _obj); 
_obj setVehiclePosition [getPos _obj,[],0,"none"];

private _duration = 5; // action duration

if (!_isArmed) then {
    private _jip = ([
        _obj,														// Object the action is attached to
        "Arm Explosives",													// Title of the action
        "\a3\ui_f_oldman\data\IGUI\Cfg\holdactions\destroy_ca.paa",	// Idle icon shown on screen
        "\a3\ui_f_oldman\data\IGUI\Cfg\holdactions\destroy_ca.paa",	// Progress icon shown on screen
        "_this distance _target < 3",									// Condition for the action to be shown
        "_caller distance _target < 3",									// Condition for the action to progress
        {},																// Code executed when action starts
        {},																// Code executed on every progress tick
        {
            params ["_target", "_caller", "_id", "_args"];
            [_target] remoteExecCall ["removeAllActions", 0];
            private _jipID = (_target getVariable "andia_FL_cache_jipID");
            [_target] remoteExec ["", _jipID];
            private _side = (side _caller);
            [{
                params ["_target", "_side"];
                _target setVariable ["andia_FL_cache_jipID", nil, true];
                [_target, true] remoteExecCall ["andia_fnc_FL_cacheAction", 2]; // disarm bomb action
                _target setVariable ["andia_FL_cache_armed", true, true];
                [_target, _side] spawn {
                    params ["_obj", "_side"];

                    private _timer = 120; // bomb timer duration

                    sleep 0.1;
                    private _markerInfo = _obj getVariable "andia_FL_cache_marker";
                    for "_i" from 0 to _timer do {
                        private _isArmed = (_obj getVariable "andia_FL_cache_armed");
                        sleep 1;
                        playSound3D [(getMissionPath "andia\FUBAR\pvp\sound\bomb_beep.ogg"), _obj, false, (getPosATL _obj), 1, 1, 50];
                        //systemChat format ["Explosives armed! %1", _i]; // debug
                        _markerInfo setMarkerColor ([_side, true] call BIS_fnc_sideColor);
                        _markerInfo setMarkerText format ["%1s, armed by %2", (str (_timer - _i)), (str _side)];
                        if ((_isArmed == true) && (_i == _timer)) then {
                            _obj remoteExecCall ["andia_fnc_FL_cacheExplode", 2];
                        };
                        if (_isArmed == false) exitWith {
                            systemChat "Explosives disarmed!";
                            sleep 0.1;
                            [_obj, false] remoteExecCall ["andia_fnc_FL_cacheAction", 2]; // arm bomb action
                        };
                    };
                };
            }, [_target, _side], 0.1] call CBA_fnc_waitAndExecute;
        },							// Code executed on completion
        {},																// Code executed on interrupted
        [],																// Arguments passed to the scripts as _this select 3
        _duration,																// Action duration in seconds
        0,																// Priority
        true,															// Remove on completion
        false															// Show in unconscious state
    ] remoteExec ["BIS_fnc_holdActionAdd", 0, _obj]);				// MP-compatible implementation
    [{
        params ["_obj", "_jip"];
        _obj setVariable ["andia_FL_cache_jipID", _jip, true];
    }, [_obj, _jip], 0.1] call CBA_fnc_waitAndExecute;
} else {
    private _jip = ([
        _obj,														// Object the action is attached to
        "Disarm Explosives",													// Title of the action
        "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_unloaddevice_ca.paa",	// Idle icon shown on screen
        "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_unloaddevice_ca.paa",	// Progress icon shown on screen
        "_this distance _target < 3",									// Condition for the action to be shown
        "_caller distance _target < 3",									// Condition for the action to progress
        {},																// Code executed when action starts
        {},																// Code executed on every progress tick
        {
            params ["_target", "_caller", "_id", "_args"];
            _target setVariable ["andia_FL_cache_armed", false, true];
            [_target] remoteExecCall ["removeAllActions", 0];
            private _jipID = (_target getVariable "andia_FL_cache_jipID");
            [_target] remoteExec ["", _jipID];
            [{
                params ["_target"];
                _target setVariable ["andia_FL_cache_jipID", nil, true];
            }, [_target], 0.1] call CBA_fnc_waitAndExecute;
        },							// Code executed on completion
        {},																// Code executed on interrupted
        [],																// Arguments passed to the scripts as _this select 3
        _duration,																// Action duration in seconds
        0,																// Priority
        true,															// Remove on completion
        false															// Show in unconscious state
    ] remoteExec ["BIS_fnc_holdActionAdd", 0, _obj]);				// MP-compatible implementation
    [{
        params ["_obj", "_jip"];
        _obj setVariable ["andia_explodeCache_jipID", _jip, true];
    }, [_obj, _jip], 0.1] call CBA_fnc_waitAndExecute;
};