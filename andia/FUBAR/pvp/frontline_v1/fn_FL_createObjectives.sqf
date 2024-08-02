if (!isServer) exitWith {};
params ["_objectives"];

if (!isNil {missionNameSpace getVariable "andia_fnc_FL_Objectives"}) exitWith {
    // * Frontline gamemode in progress! * \\
};

/*
? objective elements
! 0: side
! 1: isHQ
! 2: isFOB
! 3: captureTime
! 4: pos
*/
private _FL_Objectives = []; // objects storing info for server
{
    private _isLocked = true;
    private _side = _x select 0;
    private _isHQ = _x select 1;
    private _isFOB = _x select 2;
    private _captureTime = _x select 3;
    private _pos = _x select 4;
    if (_side == civilian) then {_isLocked = false};
    private _objective = [_side, _isHQ, _isFOB, _captureTime, _pos, _isLocked] remoteExecCall andia_fnc_FL_createObjective;
    _FL_Objectives pushBack _objectives;
} forEach _objectives;

private _gameStatus = []; 
/*
_gameStatus
    example: [west, west, civilian, east, east] 
    HQ, FOB, neutral, FOB, HQ
    locked, locked, unlocked, locked, locked
*/
{
    _gameStatus pushBack (_x#0);
} forEach _objectives;

missionNameSpace setVariable ["andia_fnc_FL_GameStatus", _gameStatus];
missionNameSpace setVariable ["andia_fnc_FL_Objectives", _FL_Objectives]; // objects storing info for server

/*
TODO: Make option to sort by distance! 
! This will help when NOT using map selection to create Frontline objectives!
    private _team1HQ = _objectives select 0;
    private _team2HQ = _objectives select (count _objectives);
    _objectives = _objectives - [_team1HQ, _team2HQ];
    private _orderedObjectives = [];
    {
        _x
    } forEach _objectives;
 */