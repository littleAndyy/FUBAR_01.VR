if (!hasInterface) exitWith {};
params ["_unit"];

if (!isNil {_unit getVariable "ANDIA_FUBAR_SuppressionEnabled"}) exitWith {};

enableCamShake true;
setCamShakeParams [0.03, 1.5, 1.5, 2, true];

_unit setVariable ["ANDIA_FUBAR_SuppressionEnabled", true];
_unit setVariable ["ANDIA_FUBAR_SuppressionValue", 0];

[_unit] call andia_fnc_suppressionFX;
[_unit] call andia_fnc_suppressionMain;

private _ANDIA_FUBAR_SuppressedEH = ([player, "Suppressed", {    
	params ["_unit", "_distance", "_shooter", "_instigator", "_ammoObject", "_ammoClassName", "_ammoConfig"];
	if (_distance <= 1.5) then {[nil, 1.15] call BIS_fnc_dirtEffect;}; 
    
	private _suppression = (
		(_unit getVariable "ANDIA_FUBAR_SuppressionValue") + (0.28 / _distance)
	);
	_unit setVariable ["ANDIA_FUBAR_SuppressionValue", _suppression];
    [_unit] call andia_fnc_suppressionMain;
}] call CBA_fnc_addBISEventHandler);
_unit setVariable ["ANDIA_FUBAR_SuppressedEH", _ANDIA_FUBAR_SuppressedEH];

private _ANDIA_FUBAR_SuppressionRespawnID = ([player, "Respawn", {
    params ["_unit", "_corpse"];
    [_unit, _corpse] remoteExecCall ["andia_fnc_suppressionRespawn", player]; // remoteExec fix? try player instead of _unit
}] call CBA_fnc_addBISEventHandler);
_unit setVariable ["ANDIA_FUBAR_SuppressionRespawnID", _ANDIA_FUBAR_SuppressionRespawnID];

//(1.8*((190*1.5)*0.05))/20