if (!hasInterface) exitWith {};
params ["_pos", "_unit", "_size"];

_explosionPos = (ASLToATL _pos);
private _hitPos = (_unit modelToWorldWorld (_unit selectionPosition "pelvis"));
private _directionVector = (_explosionPos vectorFromTo _hitPos);
private _force = _directionVector vectorMultiply (_size * 0.015);
_unit addForce [_force, _hitPos];
_unit spawn {
    sleep 6;
    if (alive _this) then {
        _this setUnconscious false;
    };
};