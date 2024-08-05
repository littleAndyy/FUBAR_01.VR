if (!isServer) exitWith {};
params ["_side", "_object", "_marker"];

private _markerInfo = _object getVariable "andia_FL_objective_markerInfo";
private _colour = ([_side, true] call BIS_fnc_sideColor);
if (_side == civilian) then {
    _colour = "ColorWhite";
};

_isActive = _object getVariable "andia_FL_objective_isActive";
private _respawn = _object getVariable "andia_FL_objective_spawnPoint";
if (_isActive) then {
    _respawn remoteExec ["BIS_fnc_removeRespawnPosition", 2];
};

private _isHQ = _object getVariable "andia_FL_objective_isHQ";
if (_isHQ) exitWith {
    private _bombs = _object getVariable "andia_FL_objective_caches";
    if ((isNull (_bombs#0)) && (isNull (_bombs#1))) then {
        // HQ is destroyed
        _object setVariable ["andia_FL_objective_isActive", false];
        _marker setMarkerColor _colour;
        _marker setMarkerBrush "Vertical";
        [["HQ Objective", _side, true], "andia\FUBAR\pvp\fubar_objectiveUI_v1\fn_objectiveUI.sqf"] remoteExecCall ["execVM", [0,-2] select isDedicated];
        titleText [format ["HQ Objective Caches destroyed. %1 wins.", _side], "PLAIN DOWN", 5];
    };
};

// if objective side has changed then broadcast
private _currentSide = _object getVariable "andia_FL_objective_currentSide";
if (_currentSide != _side) then {
    _marker setMarkerColor _colour;
    _markerInfo setMarkerColor _colour;
    _object setVariable ["andia_FL_objective_currentSide", _side];
    [["", _side, false], "andia\FUBAR\pvp\fubar_objectiveUI_v1\fn_objectiveUI.sqf"] remoteExecCall ["execVM", [0,-2] select isDedicated];
};

if (_side == civilian) exitWith {};
private _timers = _object getVariable "andia_FL_objective_timers";
private _index = switch (_side) do {
    case west: {0};
    case east: {1};
    case resistance: {2};
};
// if any timer hits 0s then objective is captured by that respective side
if ((_timers#_index) <= 0) exitWith {
    // captured point logic
    [["", _side, true], "andia\FUBAR\pvp\fubar_objectiveUI_v1\fn_objectiveUI.sqf"] remoteExecCall ["execVM", [0,-2] select isDedicated];
    _marker setMarkerColor _colour;
    _marker setMarkerBrush "Vertical";

    // reset timers for captured objective
    private _originalTimers = _object getVariable "andia_FL_objective_originalTimers";
    _object setVariable ["andia_FL_objective_timers", _originalTimers];

    // update which objective is next
    private _objectives = missionNameSpace getVariable "andia_FL_objectives";
    private _order = _object getVariable "andia_FL_objective_order";
    private _sides = _object getVariable "andia_FL_objective_sides";
    private _side1 = _sides#0;
    private _side2 = _sides#1;
    private _index = 0;
    if (_side == _side1) then {
        _index = _order + 1;
    };
    if (_side == _side2) then {
        _index = _order - 1;
    };
    _object setVariable ["andia_FL_objective_isActive", false];

    private _nextObjective = (_objectives select _index);
    _nextObjective setVariable ["andia_FL_objective_isActive", true];
    (_nextObjective getVariable "andia_FL_objective_marker") setMarkerBrush "SolidBorder";

    // ! _object is now the captured objective !
    _object setVariable ["andia_FL_objective_currentSide", _side];

    // // TODO: Add spawnpoints!
    // New respawn point! Remove the old one, add the new one to the victors.
    _respawn = _object getVariable "andia_FL_objective_spawnPoint";
    _respawn remoteExec ["BIS_fnc_removeRespawnPosition", 2];
    _markerInfo setMarkerText "";
    [{
        params ["_object", "_side"];
        _respawn = [_side, _object] call BIS_fnc_addRespawnPosition; 
        _object setVariable ["andia_FL_objective_spawnPoint", _respawn];
    }, [_object, _side], 1] call CBA_fnc_waitAndExecute;
};
private _time = (_timers#_index) - 1;
_timers set [_index, _time];
_object setVariable ["andia_FL_objective_timers", _timers];
_markerInfo setMarkerText (format ["%1 : %2s", _side, (_timers#_index)]);
