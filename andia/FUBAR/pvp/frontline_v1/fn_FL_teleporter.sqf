if (!hasInterface) exitWith {};
params ["_obj"];

// teleport to friendly objective before active objective
_obj addAction ["Teleport to Closest Friendly Objective", {
    private _objectives = missionNameSpace getVariable "andia_FL_objectives";
    private _sides = missionNameSpace getVariable "andia_FL_sides";
    private _activeObjective = objNull;
    private _activeObjectiveIndex = -1;
    {
        if ((_x getVariable "andia_FL_objective_isActive") == true) exitWith {
            _activeObjective = _x;
            _activeObjectiveIndex = _forEachIndex;
        };
    } forEach _objectives;
    private _sidePlayer = side player;
    if ((_activeObjectiveIndex < 0) || (_activeObjectiveIndex > (count _objectives))) exitWith {
        systemChat "Down to HQ objective: only emergency respawn is available! (TODO: Andy is too lazy, go manually respawn)";
    };
    if (_activeObjectiveIndex < _activeObjective) then {
        player setPos (getPos (_objectives select (_activeObjectiveIndex + 1)));
    };
    if (_activeObjectiveIndex < _activeObjective) then {
        player setPos (getPos (_objectives select (_activeObjectiveIndex - 1)));
    };
}];

