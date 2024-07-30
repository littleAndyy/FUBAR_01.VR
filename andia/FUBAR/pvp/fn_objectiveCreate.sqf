if (!isServer) exitWith {};
params ["_object", ["_radius", 50], ["_isCache", false]];

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

if (!_isCache) then {
    _objectives pushBack _object;
    private _markerName = format ["%1", random 99999];
    private _marker = createMarker [_markerName, _object];
    _marker setMarkerShape "ELLIPSE";
    _marker setMarkerSize [_radius, _radius];
    _marker setMarkerColor "ColorWhite";
    private _handle = [{
        params ["_args", "_handle"];
        private _object = _args#0;
        private _marker = _args#1;
        private _markerName = _args#2;

        private _units = allUnits inAreaArray _markerName;
        private _westCount = west countSide _units;
        private _eastCount = east countSide _units;
        private _guerCount = independent countSide _units;
        private _maxCount = selectMax [_westCount, _eastCount, _guerCount];
        private _mostNumerousTeam = "";
        switch (_maxCount) do {
            case _westCount: {
                _mostNumerousTeam = "west";
                _marker setMarkerColor "ColorBlue";
            };
            case _eastCount: {
                _mostNumerousTeam = "east";
                _marker setMarkerColor "ColorRed";
            };
            case _guerCount: {
                _mostNumerousTeam = "guer";
                _marker setMarkerColor "ColorGreen";
            };
        };
        if (isNull _object) exitWith {
            [_handle] call CBA_fnc_removePerFrameHandler;
        };
    }, 1, [_object, _marker, _markerName]] call CBA_fnc_addPerFrameHandler;
    missionNameSpace setVariable ["andia_fnc_objectives", _objectives, true];
};