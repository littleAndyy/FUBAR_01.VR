[player, [missionNamespace, "inventory_var"]] call BIS_fnc_saveInventory;

[] spawn {
	titleCut ["", "WHITE FADED", 0];
	sleep 3;
	titleCut ["", "WHITE IN", 7];
}; // DEAD BYE GO TO HEAVEN!!! SEE THE LIGHT PEARLY GATES OF JESUS CHRIST

sleep 3;

[player] call andia_fnc_suppressionEH;