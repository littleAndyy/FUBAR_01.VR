params ["_name", "_side", ["_isCaptured", false], ["_isContested", false]];
disableSerialization;
1 cutRsc ["fubar_objectiveUI", "PLAIN"];

private _colour = switch (_side) do {
    case blufor: {[WEST, false] call BIS_fnc_sideColor;};
    case opfor: {[EAST, false] call BIS_fnc_sideColor;};
    case resistance: {[resistance, false] call BIS_fnc_sideColor;};
    case civilian: {[1,1,1,0.5]};
    default {[1,1,1,0.5]};
};
_colour set [3, 0.5];

waitUntil {!isNull (uiNameSpace getVariable "andia_fubar_objectiveUI")};
private _display = uiNameSpace getVariable "andia_fubar_objectiveUI";
_setText = _display displayCtrl 3499;
if (_side == civilian) then {
    _setText ctrlSetText format ["New Objective %1 is now active!", _name];
};
if (!_isCaptured) then {
    _setText ctrlSetText format ["Objective %1 is being captured by %2!", _name, _side];
    if (_isContested) then {
        _setText ctrlSetText format ["Objective %1 is CONTESTED!", _name];
    };
} else {
    _setText ctrlSetText format ["Objective %1 has been CAPTURED by %2!", _name, _side];
};
_setText ctrlSetTextColor [1,1,1,1];
_setText ctrlSetBackgroundColor _colour;