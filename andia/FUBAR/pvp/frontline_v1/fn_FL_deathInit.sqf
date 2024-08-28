// ! BROKEN IN MULTIPLAYER, DO NOT USE

if (!hasInterface) exitWith {};

player spawn {
    params ["_player"];
    private _className = typeOf _player;

    sleep 0.1;
    
    private _newBody = group player createUnit [_className, [0,0,0], [], 0, "CAN_COLLIDE"];

    sleep 0.1;

    missionNameSpace setVariable ["andia_FL_newBody", _newBody];
    _newBody enableSimulationGlobal false;
    _newBody hideObjectGlobal true;

    _newBody disableAI "ALL";
    _newBody setFace (face _player);
    _newBody setName (name _player);
    _newBody setUnitLoadout (getUnitLoadout _player); // TODO: Get unit loadout from variable! This is for the frontline gamemode.
};

// TODO: Delete clone after disconnect.