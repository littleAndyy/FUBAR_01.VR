// ! BROKEN IN MULTIPLAYER, DO NOT USE

params ["_corpse"];

if (!hasInterface) exitWith {};

private _newBody = missionNameSpace getVariable "andia_FL_newBody";
selectPlayer _newBody;
_corpse switchcamera "internal";
_newBody enableSimulationGlobal true;
_newBody hideObjectGlobal false;
_newBody spawn {
    sleep 1;
    [player] call andia_fnc_FL_deathInit;
    [player, [missionNamespace, "inventory_var"]] call BIS_fnc_loadInventory; // TODO: Get unit loadout from variable! This is for the frontline gamemode.
};

sleep 0.05;

playSoundUI [(getMissionPath "andia\FUBAR\pvp\sound\death_hum.ogg"), 1, 1, false];

[0, "BLACK", 0.1, 1, nil] remoteExec ["BIS_fnc_fadeEffect", player];
//[3034, ["", "BLACK OUT", 0.05]] remoteExecCall ["cutRsc", player];
[2000] remoteExecCall ["BIS_fnc_bloodEffect", player];

sleep 0.6;

_camera = "camera" camCreate (getPosWorld _corpse);
_camera cameraEffect ["internal", "back"];
//_camera attachTo [_corpse, [0.2,0.33,0.17], "head", true];
_camera attachTo [_corpse, [0.2,-0.25,0.17], "head", true];
_camera camSetFOV 1.2;
_camera camCommitPrepared 0;

sleep 1.2;

[1, "BLACK", 3, 0.1, nil] remoteExec ["BIS_fnc_fadeEffect", player];
//[3034, ["", "BLACK IN", 1.5]] remoteExecCall ["cutRsc", player];

sleep 8;

//[0, "BLACK", 1, 1, "fuck off"] remoteExec ["BIS_fnc_fadeEffect", player];
//[3034, ["", "BLACK OUT", 1.5]] remoteExecCall ["cutRsc", player];

sleep 3;

//[1, "BLACK", 1, 1, "fuck off"] remoteExec ["BIS_fnc_fadeEffect", player];
//[3034, ["", "BLACK IN", 1.5]] remoteExecCall ["cutRsc", player];

_camera cameraEffect ["terminate", "back"];
camDestroy _camera;

_newBody switchcamera "internal";

sleep 1.5;
1 fadeSound 1;
