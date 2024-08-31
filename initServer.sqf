
// CLEAN UP CORPSES
/*[{
    {
        hideBody _x;
        [{
            params ["_unit"];
            deleteVehicle _unit;
        }, [_x], 10] call CBA_fnc_waitAndExecute;
    } forEach allDeadMen;
}, 30, []] call CBA_fnc_addPerFrameHandler;*/