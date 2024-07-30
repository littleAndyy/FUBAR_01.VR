if (!isServer) exitWith {};
/*
[_this, 50, false, 10] execVM "andia\FUBAR\pvp\fn_objectiveCreate.sqf";
*/
params ["_object", ["_radius", 50], ["_isCache", false], ["_captureTime", 300]];

if (isNil {missionNameSpace getVariable "andia_fnc_pvpObjectives"}) then {
    missionNameSpace setVariable ["andia_fnc_objectives", [], true];
};

private _objectives = missionNameSpace getVariable "andia_fnc_objectives";

/*if (_isCache) then {
    _objectives pushBack _object;
    missionNameSpace setVariable ["andia_fnc_objectives", _objectives, true];
    [_object] remoteExecCall ["andia_fnc_explodeCacheAction", 2];
    private _handle = [{
        params ["_args", "_handle"];
        private _object = _args#0;
        if (isNull _object) exitWith {
            [_handle] call CBA_fnc_removePerFrameHandler;
        };
    }, 1, [_object]] call CBA_fnc_addPerFrameHandler;
};*/

private _phoneticAlphabet = ["Alpha", "Bravo", "Charlie", "Delta", "Echo", "Foxtrot", "Golf", "Hotel", "India", "Juliet", "Kilo", "Lima", "Mike", "November", "Oscar", "Papa", "Quebec", "Romeo", "Sierra", "Tango", "Uniform", "Victor", "Whiskey", "X-ray", "Yankee", "Zulu"];
private _randomName = ((selectRandom _phoneticAlphabet) + str(floor random 999));
_object setVariable ["andia_fnc_objectiveName", _randomName, true];

_objectives pushBack _object;
private _markerName = format ["%1", random 99999];
private _marker = createMarker [_markerName, _object];
_marker setMarkerShape "ELLIPSE";
_marker setMarkerSize [_radius, _radius];
_marker setMarkerColor "ColorWhite";
private _markerInfo = createMarker [(format ["%1", random 99999]), _object];
_markerInfo setMarkerShape "ICON";
_markerInfo setMarkerType "mil_dot";
_markerInfo setMarkerText _randomName;
_object setVariable ["andia_fubar_marker", _marker, true];
_object setVariable ["andia_fubar_markerInfo", _markerInfo, true];
_object setVariable ["andia_fubar_currentSide", civilian, true];

if (_isCache) exitWith {
    _object setVariable ["andia_fubar_objectiveTimers", [0,0,0], true];
    _objectives pushBack _object;
    missionNameSpace setVariable ["andia_fnc_objectives", _objectives, true];
    [_object] remoteExecCall ["andia_fnc_explodeCacheAction", 2];
    private _handle = [{
        params ["_args", "_handle"];
        private _object = _args#0;
        if (isNull _object) exitWith {
            [_handle] call CBA_fnc_removePerFrameHandler;
        };
    }, 1, [_object]] call CBA_fnc_addPerFrameHandler;
};

if (!_isCache) exitWith {
    _object setVariable ["andia_fubar_objectiveTimers", [_captureTime,_captureTime,_captureTime], true];
    private _handle = [{
        params ["_args", "_handle"];
        private _object = _args#0;
        _object setVariable ["andia_fubar_objectiveHandle", _handle, true];
        private _marker = _args#1;
        private _markerName = _args#2;
        private _markerInfo = _args#3;
        private _objectiveName = _object getVariable "andia_fnc_objectiveName";
        private _timers = _object getVariable "andia_fubar_objectiveTimers";
        private _units = allUnits inAreaArray _markerName;
        private _westCount = west countSide _units;
        private _eastCount = east countSide _units;
        private _guerCount = independent countSide _units;
        private _maxCount = selectMax [_westCount, _eastCount, _guerCount];
        /*if (((_westCount + _eastCount + _guerCount) > 1) && (_westCount == _eastCount || _westCount == _guerCount || _eastCount == _guerCount)) then {
            [civilian, _object, _marker, _markerInfo, true] remoteExecCall ["andia_fnc_objectiveSide", 2];*/
        switch (_maxCount) do {
            case 0: {
                [civilian, _object, _marker, _markerInfo, false] remoteExecCall ["andia_fnc_objectiveSide", 2];        
            };
            case _westCount: {
                //_mostNumerousTeam = "west";
                [blufor, _object, _marker, _markerInfo] remoteExecCall ["andia_fnc_objectiveSide", 2];
            };
            case _eastCount: {
                //_mostNumerousTeam = "east";
                [opfor, _object, _marker, _markerInfo] remoteExecCall ["andia_fnc_objectiveSide", 2];        
            };
            case _guerCount: {
                //_mostNumerousTeam = "resistance";
                [resistance, _object, _marker, _markerInfo] remoteExecCall ["andia_fnc_objectiveSide", 2];
            };
        };
        
        if (isNull _object) exitWith {
            [_handle] call CBA_fnc_removePerFrameHandler;
        };
    }, 1, [_object, _marker, _markerName, _markerInfo]] call CBA_fnc_addPerFrameHandler;
    missionNameSpace setVariable ["andia_fnc_objectives", _objectives, true];
};
