params ["_side", "_object", "_marker", "_markerInfo", ["_isContested", false], ["_isBomb", false]];

diag_log format ["_side: %1, _object: %2, _marker: %3, _markerInfo: %4, _isContested: %5", _side, _object, _marker, _markerInfo, _isContested]; // debug

private _objectiveName = _object getVariable "andia_fnc_objectiveName";
private _timers = _object getVariable "andia_fubar_objectiveTimers";
private _handle = _object getVariable "andia_fubar_objectiveHandle";
private _colour = [_side, true] call BIS_fnc_sideColor;

if (((_object getVariable "andia_fubar_currentSide") != _side) && (_isBomb == false)) then {
    [[_objectiveName, _side], "andia\FUBAR\pvp\fubar_objectiveUI_v1\fn_objectiveUI.sqf"] remoteExecCall ["execVM", [0,-2] select isDedicated];
    _object setVariable ["andia_fubar_currentSide", _side, true];
};

if (_side == civilian) exitWith {
    _marker setMarkerColor "ColorWhite";
    _markerInfo setMarkerText "";
    _markerInfo setMarkerColor "ColorWhite";
    if (_isContested) then {
        _markerInfo setMarkerText "CONTESTED";
        [[_objectiveName, _side, false, true], "andia\FUBAR\pvp\fubar_objectiveUI_v1\fn_objectiveUI.sqf"] remoteExecCall ["execVM", [0,-2] select isDedicated];
    };
};

diag_log format ["Objective Name: %1, Timers: %2, Handle: %3, Colour: %4", _objectiveName, _timers, _handle, _colour]; // debug

_marker setMarkerColor _colour;
_markerInfo setMarkerColor _colour;
private _index = switch (_side) do {
    case west: {0};
    case east: {1};
    case resistance: {2};
};
if ((_timers#_index) <= 0) exitWith {
    [[_objectiveName, _side, true], "andia\FUBAR\pvp\fubar_objectiveUI_v1\fn_objectiveUI.sqf"] remoteExecCall ["execVM", [0,-2] select isDedicated];
    _markerInfo setMarkerColor _colour;
    _markerInfo setMarkerText format ["%1 CAPTURED", _side];
    [_handle] call CBA_fnc_removePerFrameHandler;
};
private _time = (_timers#_index) - 1; 
_timers set [0, _time];
_object setVariable ["andia_fubar_objectiveTimers", _timers, true];
_markerInfo setMarkerText (format ["%1, %2", (str (_timers#0)), _objectiveName]);