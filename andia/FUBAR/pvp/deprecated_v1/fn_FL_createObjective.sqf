if (!isServer) exitWith {};
params ["_isLocked", "_side", "_isHQ", "_isFOB", "_captureTime", "_pos"];

_markerInfo = createMarker [(format ["FL_MARKER-INFO_%1", random 99999]), _pos];
_markerInfo setMarkerShape "ICON";
_markerInfo setMarkerType "mil_dot";
_markerInfo setMarkerColor ([_side, true] call BIS_fnc_sideColor);
_marker = createMarker [(format ["FL_AREA-MARKER_%1", random 99999]), _pos];
_marker setMarkerShape "ELLIPSE";
_marker setMarkerSize [50, 50];
_marker setMarkerColor ([_side, true] call BIS_fnc_sideColor);
_marker setMarkerAlpha 0.5;

if (!_isLocked) then {
    _markerInfo setMarkerSize [1,1];
    _markerInfo setMarkerType "loc_Attack";
} else {
    _markerInfo setMarkerSize [0.5,0.5];
};
if (_isHQ) then {
    _markerInfo setMarkerSize [1,1];
    _markerInfo setMarkerType "loc_LetterH";
} else {
    _markerInfo setMarkerText format ["%1", _side];
};

private _object = objNull;
if (!isHQ) then {
    _object = createVehicle ["Land_HelipadEmpty_F", _pos, [], 0, "CAN_COLLIDE"];
} else {
    _object = createVehicle ["RuggedTerminal_01_F", _pos, [], 25, "NONE"];
};
if (_side == civilian) then {
    _markerInfo setMarkerSize [1,1];
    _markerInfo setMarkerText "No Mans Land";
    _markerInfo setMarkerColor "ColorWhite";
    _markerInfo setMarkerType "loc_Attack";
    private _currentObjective = missionNameSpace setVariable ["andia_FL_currentObjective", _object];
};

//_object setVariable ["andia_FL_objectiveData", [_isLocked, _side, _isHQ, _isFOB, _captureTime, _pos, _marker, _markerInfo]];
_object setVariable ["andia_FL_objective_isLocked", _isLocked];
_object setVariable ["andia_FL_objective_side", _side];
_object setVariable ["andia_FL_objective_isHQ", _isHQ];
_object setVariable ["andia_FL_objective_isFOB", _isFOB];
_object setVariable ["andia_FL_objective_captureTime", _captureTime];
_object setVariable ["andia_FL_objective_pos", _pos];
_object setVariable ["andia_FL_objective_marker", _marker];
_object setVariable ["andia_FL_objective_markerInfo", _markerInfo];

_object setVariable ["andia_FL_objectiveMarker", _marker];

_object setVariable ["andia_FL_objectiveMarkerInfo", _markerInfo];

_object setVariable ["andia_FL_objectiveTimers", [_captureTime,_captureTime,_captureTime]];

_elapsedTime = 0;
_object setVariable ["andia_FL_elapsedTime", _elapsedTime];

_object setVariable ["andia_FL_originalSide", _side];

private _handler = [{
    params ["_args", "_handle"];

    private _objective = _args#0;

    private _isLocked = _objective getVariable "andia_FL_objective_isLocked";
    private _side = _objective getVariable "andia_FL_objective_side";
    private _isHQ = _objective getVariable "andia_FL_objective_isHQ";
    private _isFOB = _objective getVariable "andia_FL_objective_isFOB";
    private _captureTime = _objective getVariable "andia_FL_objective_captureTime";
    private _pos = _objective getVariable "andia_FL_objective_pos";
    
    private _marker = _objective getVariable "andia_FL_objective_marker";
    private _markerInfo = _objective getVariable "andia_FL_objective_markerInfo";

    private _timers = (_objective getVariable "andia_FL_objectiveTimers");
    private _elapsedTime = (_objective getVariable "andia_FL_elapsedTime");
    private _elapsedTime = _elapsedTime + 1;
    _objective setVariable ["andia_FL_objectiveTimers", [_timers#0, _timers#1, _timers#2, _elapsedTime]];

    private _handle = _objective setVariable ["andia_FL_objectiveHandle", _handle];

    if (isNull _objective) exitWith {
        [_handle] call CBA_fnc_removePerFrameHandler;
    };

    if (!_isHQ) then {
        private _units = allUnits inAreaArray _marker;
        private _westCount = west countSide _units;
        private _eastCount = east countSide _units;
        private _guerCount = independent countSide _units;
        private _maxCount = selectMax [_westCount, _eastCount, _guerCount];
        switch (_maxCount) do {
            case 0: {
                [_side, _objective, _marker, _markerInfo, false] remoteExecCall ["andia_fnc_FL_changeObjective", 2];
            };
            case _westCount: {
                [west, _objective, _marker, _markerInfo] remoteExecCall ["andia_fnc_FL_changeObjective", 2];
            };
            case _eastCount: {
                [east, _objective, _marker, _markerInfo] remoteExecCall ["andia_fnc_FL_changeObjective", 2];
            };
            case _guerCount: {
                [resistance, _objective, _marker, _markerInfo] remoteExecCall ["andia_fnc_FL_changeObjective", 2];
            };
        };
    };
    
}, 1, [_object]] call CBA_fnc_addPerFrameHandler;

_object