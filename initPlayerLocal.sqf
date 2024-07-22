sleep 0.1;
[player, [missionNamespace, "inventory_var"]] call BIS_fnc_saveInventory;

sleep 1.5;

[player] call andia_fnc_suppressionEH;
//[] call andia_fnc_grenadeDust;

private _supportRadioMortar = [player,"andia_mortar_support"] call BIS_fnc_addCommMenuItem;
private _supportRadioGrad = [player,"andia_grad_support"] call BIS_fnc_addCommMenuItem;
