params ["_unit"];

_unit addEventHandler ["HitPart", {
	(_this select 0) params ["_target", "_shooter", "_projectile", "_position", "_velocity", "_selection", "_ammo", "_vector", "_radius", "_surfaceType", "_isDirect", "_instigator"];
    [(ASLtoATL _position), _velocity] remoteExecCall ["andia_fnc_impactGibs", [0,-2] select isDedicated];

    private _speed = (vectorMagnitude _velocity) * 3.6;
    private _caliber = getNumber (configFile >> "CfgAmmo" >> (typeOf _projectile) >> "caliber");
    if (_isDirect == true && _speed > 330 && _caliber > 0.8) then {
        systemChat str "Player ragdolled by fast projectile!"; // DEBUG
        systemChat str _selection; // DEBUG
        private _hitPos = (_target modelToWorldWorld (_target selectionPosition (_selection#0)));
        private _directionVector = (_position vectorFromTo _hitPos);
        private _force = _directionVector vectorMultiply (_caliber*200);
        {
            if (_x > 1000) then {
                _x = 1000;
            };
            if (_x < -1000) then {
                _x = -1000;
            };
        } forEach _force;
        systemChat format ["%1 km/h, _velocity: %2, _force: %3, _caliber: %4", _speed, _velocity, _force, _caliber]; // DEBUG
        _target addForce [_force, _hitPos];
        [{
            if (!isNil "ace_medical_fnc_setUnconscious") then {
                [(_this#0), true, (random [3,7,14]), true] call ace_medical_fnc_setUnconscious;
            };
        }, [_target], 0.1] call CBA_fnc_waitAndExecute;
    
        [{
            if (!isNil "ace_medical_fnc_setUnconscious") then {
                /*([player] call ace_medical_status_fnc_hasStableVitals) then {
                    [player, false, 3, true] call ace_medical_fnc_setUnconscious;
                };*/
            } else {
                if (alive (_this#0)) then {
                    (_this#0) setUnconscious false;
                };
            };
        }, [_target], (random [3,6,12])] call CBA_fnc_waitAndExecute;
    };
}];