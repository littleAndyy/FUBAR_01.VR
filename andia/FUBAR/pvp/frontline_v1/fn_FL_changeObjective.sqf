if (!isServer) exitWith {};
params ["_side", "_objective", "_marker", "_markerInfo"];

_objective setVariable ["andia_FL_objective_side", _side];

private _colour = [_side, true] call BIS_fnc_sideColor;
if (_side == civilian) then {
    _colour = "ColorWhite";
};

if ((((_objective getVariable "andia_FL_objectiveData") select 0) != _side)) then {
    [["Objective", _side, false], "andia\FUBAR\pvp\fubar_objectiveUI_v1\fn_objectiveUI.sqf"] remoteExecCall ["execVM", [0,-2] select isDedicated];
};
private _objectiveData = _objective getVariable "andia_FL_objectiveData";
_objectiveData set [0, _side];
_objective setVariable ["andia_FL_objectiveData", _objectiveData, true];

private _index = switch (_side) do {
    case west: {0};
    case east: {1};
    case resistance: {2};
};
private _timers = _objective getVariable "andia_FL_objectiveTimers";
private _elapsedTime = _objective getVariable "andia_FL_elapsedTime";
private _handle = _objective getVariable "andia_FL_objectiveHandle";

if ((_timers#_index) <= 0) exitWith { // IF TIMER HITS 0s == CAPTURED
    [["Objective", _side, true], "andia\FUBAR\pvp\fubar_objectiveUI_v1\fn_objectiveUI.sqf"] remoteExecCall ["execVM", [0,-2] select isDedicated];
    _markerInfo setMarkerColor _colour;
    _markerInfo setMarkerText format ["%1 CAPTURED", _side];
    [_handle] call CBA_fnc_removePerFrameHandler;
};


private _maximumTime = 1200; // CONFIG - USE FOR DEBUGGING, ETC


if ((_elapsedTime) >= _maximumTime) exitWith { // max time to capture / defend = 20 minutes
    _objective setVariable ["andia_FL_objective_isLocked", true];

    private _originalSide = _objective getVariable "andia_FL_originalSide";
    private _gameStatus = missionNameSpace getVariable "andia_fnc_FL_GameStatus";
    
    private _FL_Objectives = missionNameSpace getVariable "andia_fnc_FL_Objectives";
    private _currentObjective = missionNameSpace getVariable "andia_FL_currentObjective";
    private _currentObjectiveIndex = _FL_Objectives find _objective; // give index of current objective
    private _gameStatusNew = [];
    {
        private _side = _x getVariable "andia_FL_objective_side";
        _gameStatusNew pushBack _side;
    } forEach _FL_Objectives;
    
    private _team1 = missionNameSpace getVariable "andia_FL_firstSide";
    private _team2 = missionNameSpace getVariable "andia_FL_secondSide";
    private _unlockNewObjectiveIndex = 0;
    if ((_originalSide == _team1) && (_originalSide == _side)) then {
        _unlockNewObjectiveIndex = _currentObjectiveIndex+1;
    } else {
        _unlockNewObjectiveIndex = _currentObjectiveIndex-1;
    };
    _gameStatus set [_unlockNewObjectiveIndex, _side];
    private _changedIndex = -1;
    {
        if (_gameStatus select _forEachIndex != _gameStatusNew select _forEachIndex) exitWith {
            _changedIndex = _forEachIndex;
        };
    } forEach _gameStatus;
    (_FL_Objectives select _changedIndex) setVariable ["andia_FL_objective_isLocked", true];
    (_FL_Objectives select _changedIndex) setVariable ["andia_FL_objective_side", _side];
    missionNameSpace setVariable ["andia_fnc_FL_Objectives", _FL_Objectives];
    systemChat format ["_gameStatus: %1", _gameStatus];


    if (_originalSide == _side) exitWith {
        // OBJECTIVE DEFENDED SUCCESSFULLY!
        _markerInfo setMarkerType "mil_dot";
    };
    // select the side that has the lowest timer
    _index = (_timers find (selectMin _timers));
    [["Objective", _side, true], "andia\FUBAR\pvp\fubar_objectiveUI_v1\fn_objectiveUI.sqf"] remoteExecCall ["execVM", [0,-2] select isDedicated];
    _markerInfo setMarkerColor _colour;
    _markerInfo setMarkerText "CAPTURED";
    //[_handle] call CBA_fnc_removePerFrameHandler; // we want the game to continue
};

private _time = (_timers#_index) - 1; 
_timers set [_index, _time];
_object setVariable ["andia_fubar_objectiveTimers", _timers, true];
_markerInfo setMarkerText (format ["%1, %2", (str (_timers#0)), _objectiveName]);