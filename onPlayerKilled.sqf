[player, [missionNamespace, "inventory_var"]] call BIS_fnc_saveInventory; // TODO: temporary

params ["_oldUnit", "_killer", "_respawn", "_respawnDelay"];

/*if (isMultiplayer) then {
    [_oldUnit] remoteExec ["andia_fnc_FL_deathScreen", player];
} else {
    [_oldUnit] execVM "andia\FUBAR\pvp\frontline_v1\fn_FL_deathScreen.sqf";
};*/
