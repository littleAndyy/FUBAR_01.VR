if (!isServer) exitWith {};
params ["_order", "_object", ["_captureTime", 600], "_sides", "_isActive", "_isHQ"];

if (isNil {missionNameSpace getVariable "andia_FL_objectives"}) then {
    missionNameSpace setVariable ["andia_FL_objectives", []];
};
private _objectives = missionNameSpace getVariable "andia_FL_objectives";
_objectives pushBack _object;
missionNameSpace setVariable ["andia_FL_objectives", _objectives];

private _defendingSide = _sides#0;
private _attackingSide = _sides#1;

_markers = [_object, _defendingSide, _isActive] call andia_fnc_FL_markerCreate;
_marker = _markers#0;
_markerInfo = _markers#1;

_object setVariable ["andia_FL_objective_order", _order];
_object setVariable ["andia_FL_objective_marker", _marker];
_object setVariable ["andia_FL_objective_markerInfo", _markerInfo];
_object setVariable ["andia_FL_objective_currentSide", _defendingSide];
_object setVariable ["andia_FL_objective_defendingSide", _defendingSide];
_object setVariable ["andia_FL_objective_attackingSide", _attackingSide];
_object setVariable ["andia_FL_objective_timers", [_captureTime, _captureTime, _captureTime]];
_object setVariable ["andia_FL_objective_originalTimers", [_captureTime, _captureTime, _captureTime]];
_object setVariable ["andia_FL_objective_isActive", _isActive];
_object setVariable ["andia_FL_objective_isHQ", _isHQ];

_respawn = [_defendingSide, _object] call BIS_fnc_addRespawnPosition;
_object setVariable ["andia_FL_objective_spawnPoint", _respawn];

if (_isHQ) then {
    private _randomCacheTypes = ["RuggedTerminal_01_communications_F", "RuggedTerminal_02_communications_F", "RuggedTerminal_01_F"];
    private _bomb1 = createVehicle [(selectRandom _randomCacheTypes), (getPos _object), [], 35, "NONE"];
    private _bomb2 = createVehicle [(selectRandom _randomCacheTypes), (getPos _object), [], 35, "NONE"];
    private _bombs = [_bomb1, _bomb2];
    {
        _x enableSimulationGlobal false;
        _x allowDamage false;
        _x setDir (random 360);
        _x call andia_fnc_FL_cacheAction;
    } forEach _bombs;
    _object setVariable ["andia_FL_objective_caches", _bombs];
};

private _handle = [{
    params ["_args", "_handle"];
    private _object = _args#0;
    private _marker = _object getVariable "andia_FL_objective_marker";
    private _currentSide = _object getVariable "andia_FL_objective_currentSide";
    private _defendingSide = _object getVariable "andia_FL_objective_defendingSide";
    private _attackingSide = _object getVariable "andia_FL_objective_attackingSide";
    private _isActive = _object getVariable "andia_FL_objective_isActive";
    private _isHQ = _object getVariable "andia_FL_objective_isHQ";
    private _respawn = _object getVariable "andia_FL_objective_spawnPoint";
    private _bombs = _object getVariable "andia_FL_objective_caches";
    
    if (_isHQ) then {
        [_currentSide, _object, _marker] remoteExecCall ["andia_fnc_FL_objectiveUpdate", 2];
    };
    
    if (_isActive) then {
        if (_respawn isEqualTo []) exitWith {
            // respawn point has already been removed
        };
        _respawn call BIS_fnc_removeRespawnPosition;
    };

    if (!_isHQ && _isActive) then {
        // find which side has the most units on the objective
        private _units = allUnits inAreaArray _marker;
        private _westCount = west countSide _units;
        private _eastCount = east countSide _units;
        private _guerCount = independent countSide _units;
        private _maxCount = selectMax [_westCount, _eastCount, _guerCount];
        switch (_maxCount) do {
            case 0: {
                // neutral
                [civilian, _object, _marker] remoteExecCall ["andia_fnc_FL_objectiveUpdate", 2];
            };
            case _westCount: {
                // west
                [west, _object, _marker] remoteExecCall ["andia_fnc_FL_objectiveUpdate", 2];
            };
            case _eastCount: {
                // east
                [east, _object, _marker] remoteExecCall ["andia_fnc_FL_objectiveUpdate", 2];
            };
            case _guerCount: {
                // guer
                [resistance, _object, _marker] remoteExecCall ["andia_fnc_FL_objectiveUpdate", 2];
            };
        };
    };
}, 1, // delay 
[_object] // parameters (_args)
] call CBA_fnc_addPerFrameHandler;