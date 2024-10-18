
sleep 1;

[player, [missionNamespace, "inventory_var"]] call BIS_fnc_saveInventory;

//[player] call andia_fnc_FL_deathInit; // ! DO NOT USE
[player] call andia_fnc_suppressionEH;
[player] call andia_fnc_impactPlayer;
//[] call andia_fnc_grenadeDust;
[] spawn andia_fnc_enhTracersEdit;
player setAnimSpeedCoef 0.87;

private _supportRadioMortar = [player,"andia_mortar_support"] call BIS_fnc_addCommMenuItem;
//private _supportRadioGrad = [player,"andia_grad_support"] call BIS_fnc_addCommMenuItem;
private _supportRadioArtillery = [player,"andia_hartillery_support"] call BIS_fnc_addCommMenuItem;
