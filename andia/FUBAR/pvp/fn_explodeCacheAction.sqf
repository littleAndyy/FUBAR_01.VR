params ["_obj", "_isArmed"];

private _duration = 1;

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
            private _jipID = (_target getVariable "andia_fnc_explodeCache_jipID");
            [_target] remoteExec ["", _jipID];
            [{
                params ["_target"];
                _target setVariable ["andia_fnc_explodeCache_jipID", nil, true];
                [_target, true] remoteExecCall ["andia_fnc_explodeCacheAction", 2]; // disarm bomb action
                _target setVariable ["andia_fnc_explodeCache_armed", true, true];
                _target spawn {
                    params ["_obj"];
                    sleep 0.1;
                    private _isArmed = (_obj getVariable "andia_fnc_explodeCache_armed");
                    for "_i" from 0 to 60 do {
                        _isArmed = (_obj getVariable "andia_fnc_explodeCache_armed");
                        sleep 1;
                        systemChat format ["Explosives armed! %1", _i]; // debug
                        if ((_isArmed == true) && (_i == 60)) then {
                            _obj remoteExecCall ["andia_fnc_explodeCache", 2];
                        };
                        if (_isArmed == false) exitWith {
                            systemChat "Explosives disarmed!";
                            sleep 0.1;
                            [_obj, false] remoteExecCall ["andia_fnc_explodeCacheAction", 2]; // arm bomb action
                        };
                    };
                };
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
        _obj setVariable ["andia_fnc_explodeCache_jipID", _jip, true];
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
            _target setVariable ["andia_fnc_explodeCache_armed", false, true];
            [_target] remoteExecCall ["removeAllActions", 0];
            private _jipID = (_target getVariable "andia_fnc_explodeCache_jipID");
            [_target] remoteExec ["", _jipID];
            [{
                params ["_target"];
                _target setVariable ["andia_fnc_explodeCache_jipID", nil, true];
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
        _obj setVariable ["andia_fnc_explodeCache_jipID", _jip, true];
    }, [_obj, _jip], 0.1] call CBA_fnc_waitAndExecute;
};