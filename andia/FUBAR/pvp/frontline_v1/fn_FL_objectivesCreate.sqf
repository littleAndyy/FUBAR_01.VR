/*
    example: 
    [[obj_01, obj_02, obj_03, obj_04, obj_05], west, east] execVM "andia\FUBAR\pvp\frontline_v1\fn_FL_objectivesCreate.sqf";
*/

if (!isServer) exitWith {};
params ["_objects", "_side1", "_side2"];
private _numObjectives = (count _objects);
if ((_numObjectives % 2) == 0) exitWith {
    // number of objectives must be odd
};
_numObjectives = _numObjectives - 1;
for "_i" from 0 to _numObjectives do {
    [{
        params ["_index", "_numObjectives", "_objects", "_side1", "_side2"];
        private _isHQ = false;
        // if objective is first or last = HQ
        if ((_index == 0) || (_index == _numObjectives)) then {
            _isHQ = true;
        };
        private _defendingSide = civilian;
        private _attackingSide = civilian;
        private _middleObjective = (round (_numObjectives/2));
        private _isActive = false;
        if (_index == _middleObjective) then {
            _defendingSide = civilian;
            _attackingSide = [_side1,_side2];
            _isActive = true;
        } else {
            if (_index < _middleObjective) then {
                _defendingSide = _side1;
                _attackingSide = _side2;
            };
            if (_index > _middleObjective) then {
                _defendingSide = _side2;
                _attackingSide = _side1;
            };
        };
        (_objects select _index) setVariable ["andia_FL_objective_sides", [_side1, _side2]];
        [
            _index,
            (_objects select _index),
            20, // 300s default
            [_defendingSide, _attackingSide],
            _isActive,
            _isHQ
        ] remoteExecCall ["andia_fnc_FL_objectiveCreate", 2];
    }, [_i, _numObjectives, _objects, _side1, _side2], (_i+0.1)] call CBA_fnc_waitAndExecute;
};