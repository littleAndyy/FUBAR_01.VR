params ["_unit"];

_unit addEventHandler ["HitPart", {
	(_this select 0) params ["_target", "_shooter", "_projectile", "_position", "_velocity", "_selection", "_ammo", "_vector", "_radius", "_surfaceType", "_isDirect", "_instigator"];
    [(ASLtoATL _position), _velocity] remoteExecCall ["andia_fnc_impactGibs", [0,-2] select isDedicated];
}];