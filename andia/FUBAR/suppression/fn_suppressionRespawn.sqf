if (!hasInterface) exitWith {};
params ["_unit", "_corpse", "_eventHandlerType", "_eventHandlerID"];

_corpse setVariable ["ANDIA_FUBAR_SuppressionEnabled", nil];
_corpse setVariable ["ANDIA_FUBAR_SuppressionValue", nil];
_corpse removeEventHandler ["Suppressed", (_corpse getVariable "ANDIA_FUBAR_SuppressedEH")];
//removeMissionEventHandler ["ProjectileCreated", (_corpse getVariable "ANDIA_FUBAR_Suppression_ProjectileEH")]; // potentially buggy?
private _projectileEH = _corpse getVariable "ANDIA_FUBAR_Suppression_ProjectileEH";
[_unit, _corpse, _eventHandlerType, _eventHandlerID, _projectileEH] spawn {
    params ["_unit", "_corpse", "_typeEH", "_EH", "_projectileEH"];
    waitUntil { sleep 1; (!isNull _this) };
    hintSilent "Executed 'andia_fnc_suppressionEH' on respawn!";
    _corpse removeEventHandler [_typeEH, _EH];
    sleep 0.5;
    _unit setVariable ["ANDIA_FUBAR_Suppression_ProjectileEH", _projectileEH];
    _unit setVariable ["ANDIA_FUBAR_SuppressionValue", 0];
    _unit call andia_fnc_suppressionEH;
    [_unit, 0] call andia_fnc_suppressionFX;
};