if (!hasInterface) exitWith {};
params ["_pos", "_unit", "_size"];

_explosionPos = (ASLToATL _pos);
private _hitPos = (_unit modelToWorldWorld (_unit selectionPosition "pelvis"));
private _directionVector = (_explosionPos vectorFromTo _hitPos);
private _force = _directionVector vectorMultiply (_size * 0.02);
_unit addForce [_force, _hitPos];

[{
    if (alive (_this#0)) then {
        (_this#0) setUnconscious false;
    };
}, [_unit], 7.5] call CBA_fnc_waitAndExecute;

/*_unit spawn {
    sleep 7.5;
    if (alive _this) then {
        _this setUnconscious false;
    };
};*/