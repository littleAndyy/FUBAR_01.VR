if (!hasInterface) exitWith {};
params ["_pos", "_unit", "_size"];

_explosionPos = (ASLToATL _pos);
private _hitPos = (_unit modelToWorldWorld (_unit selectionPosition "pelvis"));
private _directionVector = (_explosionPos vectorFromTo _hitPos);
private _force = _directionVector vectorMultiply (_size * 0.06); // 0.05 -> 0.06
_unit addForce [_force, _hitPos];

[{
    params ["_unit"];
    if (random 1 >= 0.95) then { // 5% chance of insta dying
        _unit setDamage 1;
    } else {
        [{
            if (!isNil "ace_medical_fnc_setUnconscious") then {
                [(_this#0), true, (random [3,7,14]), true] call ace_medical_fnc_setUnconscious;
            };
        }, [_unit], 0.1] call CBA_fnc_waitAndExecute;
        
        [{
            if (!isNil "ace_medical_fnc_setUnconscious") then {
                //[player, false, 3, true] call ace_medical_fnc_setUnconscious;
            } else {
                if (alive (_this#0)) then {
                    (_this#0) setUnconscious false;
                };
            };
        }, [_unit], 7.5] call CBA_fnc_waitAndExecute;
    };
}, [_unit], 0.1] call CBA_fnc_waitAndExecute;


/*_unit spawn {
    sleep 7.5;
    if (alive _this) then {
        _this setUnconscious false;
    };
};*/