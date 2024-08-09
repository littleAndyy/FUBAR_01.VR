if (!hasInterface) exitWith {};
params ["_unit"];

[_unit, 0.9] remoteExecCall ["setAnimSpeedCoef", 0, true];

if (!isNil {_unit getVariable "ANDIA_FUBAR_SuppressionEnabled"}) exitWith {};

enableCamShake true;
setCamShakeParams [0.03, 1.5, 1.5, 2, true];
_unit setVariable ["ANDIA_FUBAR_SuppressionEnabled", true];
_unit setVariable ["ANDIA_FUBAR_SuppressionValue", 0];

[_unit] call andia_fnc_suppressionFX;

private _ANDIA_FUBAR_SuppressedEH = _unit addEventHandler ["Suppressed", {    
	params ["_unit", "_distance", "_shooter", "_instigator", "_ammoObject", "_ammoClassName", "_ammoConfig"];
	if (_distance <= 1) then {[nil, 1.15] call BIS_fnc_dirtEffect;}; 
    
	private _suppression = (
		(_unit getVariable "ANDIA_FUBAR_SuppressionValue") + (0.2 / _distance)
	);
	_unit setVariable ["ANDIA_FUBAR_SuppressionValue", _suppression];
    [_unit] call andia_fnc_suppressionMain;
}];
_unit setVariable ["ANDIA_FUBAR_SuppressedEH", _ANDIA_FUBAR_SuppressedEH];

private _ANDIA_FUBAR_Suppression_ProjectileEH = addMissionEventHandler ["ProjectileCreated", {
	params ["_projectile"];
    _projectile addEventHandler ["HitPart", {
        params ["_projectile", "_hitEntity", "_projectileOwner", "_pos", "_velocity", "_normal", "_components", "_radius" ,"_surfaceType", "_instigator"];

        _projectileClass = typeOf _projectile;
        private _caliberSize = getNumber (configFile >> "CfgAmmo" >> _projectileClass >> "caliber");
        //systemChat format ["_projectile: %1, caliber: %2", _projectile, _caliberSize];

        private _unit = player;
        private _distance = (_unit distance (ASLToATL _pos));
        if (_distance <= 50) then {
            private _suppression = (
                (_unit getVariable "ANDIA_FUBAR_SuppressionValue") + ((0.7 * _caliberSize) / _distance)
            );
            _unit setVariable ["ANDIA_FUBAR_SuppressionValue", _suppression];
            [_unit] call andia_fnc_suppressionMain;
            [(ASLToATL _pos), _velocity, _caliberSize] call andia_fnc_impactSparks;
        };

        _projectile removeEventHandler [_thisEvent, _thisEventHandler];
    }];
    _projectile addEventHandler ["Explode", {
        params ["_projectile", "_pos", "_velocity"];

        private _size = getNumber (configFile >> "CfgAmmo" >> (typeOf _projectile) >> "indirectHitRange") * getNumber (configFile >> "CfgAmmo" >> (typeOf _projectile) >> "hit");
        if (_size <= 1) exitWith {};

        if (_size <= 360) then {
            _size = _size * 1.5;
        } else {
            if (_size > 15000) then {
                _size = 15000;
            };
            _size = _size * 0.75;
        };
        
        private _unit = player;
        private _distance = (_unit distance (ASLToATL _pos));
        //hintSilent format ["Size %1, Explosion at %2, distance from %3: %4", _size, _pos, player, _distance];

        [(ASLtoATL _pos), _size, _velocity] call andia_fnc_explCloseFX;
        if (_size > 2970) then {
            [_pos] call andia_fnc_SFX_largeImpactExpl;
        };
        if (_distance <= 50) exitWith {
            if (_distance <= 2) then {
                [_pos, _unit, _size] call andia_fnc_suppressionForce;
            };
            private _suppression = (
                (_unit getVariable "ANDIA_FUBAR_SuppressionValue") 
                + ((2.0 * (_size*0.05)) / _distance)
            );
            _unit setVariable ["ANDIA_FUBAR_SuppressionValue", _suppression];
            [player] call andia_fnc_suppressionMain;

            playSoundUI [(getMissionPath "andia\fubar\suppression\sound\sfx_tinnitus_short.ogg"), (0.1*_suppression), 1];

            // TODO: Sounds based on size & suppression. Muffle sounds as suppression gets higher.
            private _rndBass = selectRandom [
                "andia\FUBAR\suppression\sound\expl_small_bass_close_01.ogg",
                "andia\FUBAR\suppression\sound\expl_small_bass_close_02.ogg",
                "andia\FUBAR\suppression\sound\expl_small_bass_close_03.ogg",
                "andia\FUBAR\suppression\sound\expl_small_bass_close_04.ogg"
            ];
            playSoundUI [(getMissionPath _rndBass), (0.15*_suppression), 1];
        };
        if (_distance <= 125) exitWith {
            private _suppression = (
                (_unit getVariable "ANDIA_FUBAR_SuppressionValue") 
                + ((1.5 * (_size*0.05)) / _distance)
            );
            _unit setVariable ["ANDIA_FUBAR_SuppressionValue", _suppression];
            [player] call andia_fnc_suppressionMain;
        };
        if (_distance <= 250) exitWith {
            private _suppression = (
                (_unit getVariable "ANDIA_FUBAR_SuppressionValue") 
                + ((0.8 * (_size*0.05)) / _distance)
            );
            _unit setVariable ["ANDIA_FUBAR_SuppressionValue", _suppression];
            [player] call andia_fnc_suppressionMain;
        };
    }];
}];
_unit setVariable ["ANDIA_FUBAR_Suppression_ProjectileEH", _ANDIA_FUBAR_Suppression_ProjectileEH];

if (isMultiplayer) then {
    _unit addEventHandler ["MPRespawn", {
        params ["_unit", "_corpse"];
        [_unit, _corpse, _thisEvent, _thisEventHandler] call andia_fnc_suppressionRespawn;
    }];
} else {
    _unit addEventHandler ["Respawn", {
        params ["_unit", "_corpse"];
        [_unit, _corpse, _thisEvent, _thisEventHandler] call andia_fnc_suppressionRespawn;
    }];
};

//(1.8*((190*1.5)*0.05))/20