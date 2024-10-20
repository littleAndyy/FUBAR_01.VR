//if (!hasInterface) exitWith {};
// TODO: Still broken... :(
params ["_unit", "_corpse", "_eventHandlerType", "_eventHandlerID"];

_corpse removeEventHandler [_eventHandlerType, _eventHandlerID];
_corpse removeEventHandler ["Suppressed", (_corpse getVariable "ANDIA_FUBAR_SuppressedEH")];
removeMissionEventHandler ["ProjectileCreated", (_corpse getVariable "ANDIA_FUBAR_Suppression_ProjectileEH")];

// JUST NUKE IT ALL!!! (20/10/24)
_corpse removeAllEventHandlers "Suppressed";
_corpse removeAllEventHandlers "Respawn";

[_unit, _corpse, _eventHandlerType, _eventHandlerID] spawn {
    params ["_unit", "_corpse", "_typeEH", "_EH"];
    sleep 0.5;
    waitUntil { sleep 1.5; (!isNull player) };
    hintSilent format ["Attempted 'andia_fnc_suppressionEH' on respawn for %1!", (name _unit)];
    diag_log format ["Attempted 'andia_fnc_suppressionEH' on respawn for %1!", (name _unit)];
    
    sleep 0.5;
    [player] remoteExecCall ["andia_fnc_suppressionEH", player];
    [player] remoteExecCall ["andia_fnc_impactPlayer", player];
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