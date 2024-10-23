//if (!hasInterface) exitWith {};
// TODO: Still broken... :(
params ["_unit", "_corpse"];

_corpse removeEventHandler ["Respawn", (_corpse getVariable "ANDIA_FUBAR_SuppressionRespawnID")];
_corpse removeEventHandler ["Suppressed", (_corpse getVariable "ANDIA_FUBAR_SuppressedEH")];
_corpse removeEventHandler ["HitPart", (_corpse getVariable "ANDIA_FUBAR_HitPartEH_Impact")];
_corpse setVariable ["ANDIA_FUBAR_SuppressionRespawnID", nil];
_corpse setVariable ["ANDIA_FUBAR_SuppressedEH", nil];
_corpse setVariable ["ANDIA_FUBAR_HitPartEH_Impact", nil];
//removeMissionEventHandler ["ProjectileCreated", (_corpse getVariable "ANDIA_FUBAR_Suppression_ProjectileEH")]; // should be unncessary


[_unit, _corpse] spawn {
    params ["_unit", "_corpse"];

    waitUntil { sleep 1; (!isNull player) };
    
    hintSilent format ["Attempted 'andia_fnc_suppressionEH' on respawn for %1!", (name player)];
    diag_log format ["Attempted 'andia_fnc_suppressionEH' on respawn for %1!", (name player)];

    sleep 0.5;
    [player] remoteExecCall ["andia_fnc_suppressionEH", player];
    [player] remoteExecCall ["andia_fnc_impactPlayer", player];

    sleep 1;
    [player] call andia_fnc_suppressionFX;
};

// reverted ...

/* OLD "new" CODE
if (!hasInterface) exitWith {};
params ["_unit", "_corpse", "_eventHandlerType", "_eventHandlerID"];

_corpse setVariable ["ANDIA_FUBAR_SuppressionEnabled", nil];
_corpse setVariable ["ANDIA_FUBAR_SuppressionValue", nil];
_corpse removeEventHandler ["Suppressed", (_corpse getVariable "ANDIA_FUBAR_SuppressedEH")];
removeMissionEventHandler ["ProjectileCreated", (_corpse getVariable "ANDIA_FUBAR_Suppression_ProjectileEH")]; // potentially buggy?
private _projectileEH = _corpse getVariable "ANDIA_FUBAR_Suppression_ProjectileEH";
[_unit, _corpse, _eventHandlerType, _eventHandlerID, _projectileEH] spawn {
    params ["_unit", "_corpse", "_typeEH", "_EH", "_projectileEH"];
    waitUntil { sleep 1.5; (!isNull player) };
    hintSilent "Executed 'andia_fnc_suppressionEH' on respawn!";
    _corpse removeEventHandler [_typeEH, _EH];
    sleep 1.5;
    _unit setVariable ["ANDIA_FUBAR_Suppression_ProjectileEH", _projectileEH];
    _unit setVariable ["ANDIA_FUBAR_SuppressionValue", 0];
    _unit call andia_fnc_suppressionEH;
    [_unit, 0] call andia_fnc_suppressionFX;
};
*/