sleep 1.5;

[player, [missionNamespace, "inventory_var"]] call BIS_fnc_loadInventory;
player enableStamina false;

sleep 1.5;

[player] call andia_fnc_suppressionEH;