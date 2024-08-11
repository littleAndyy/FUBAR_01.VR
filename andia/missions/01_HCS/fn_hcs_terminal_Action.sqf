if (!hasInterface) exitWith {};
params ["_obj"];
player createDiarySubject ["andia_hcs_terminal_logs","ANDIA:LOGS"];
[] spawn {
	[] spawn andia_fnc_hcs_terminal_UI;
	sleep 0.1;
	closeDialog 3499;
};
[
	_obj,
	"Use Terminal",
	"\a3\ui_f_oldman\data\IGUI\Cfg\holdactions\holdAction_sleep_ca.paa",	// Idle icon shown on screen
	"\a3\ui_f_oldman\data\IGUI\Cfg\holdactions\holdAction_sleep_ca.paa",	// Progress icon shown on screen
	"_this distance _target < 3",									// Condition for the action to be shown
	"_caller distance _target < 3",									// Condition for the action to progress
	{},
	{},
	{
		params ["_target"];
        if (isMultiplayer) then {
            [] spawn andia_fnc_hcs_terminal_UI;
        } else {
            [] execVM "andia\missions\01_HCS\fn_hcs_terminal_UI.sqf";
        };
    },
	{},
	[], 0.5, 0, false, false
] call BIS_fnc_holdActionAdd;