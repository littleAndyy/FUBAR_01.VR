sleep 0.1;
[player, [missionNamespace, "inventory_var"]] call BIS_fnc_saveInventory;

[player] call andia_fnc_suppressionEH;
//[] call andia_fnc_grenadeDust;

private _supportRadio = [player,"andia_mortar_support"] call BIS_fnc_addCommMenuItem;
