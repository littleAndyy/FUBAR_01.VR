if (!hasInterface) exitWith {};
disableSerialization;
private _ui = createDialog ["andia_terminal", true];
private _button = _ui displayCtrl 10002;
private _textBox = _ui displayCtrl 10001;

if (isNil {missionNameSpace getVariable "HCS_Terminal_logNum"}) then {
    missionNameSpace setVariable ["HCS_Terminal_logNum", 0, true];
};
if (!isNil {missionNameSpace getVariable "HCS_Terminal_buttonHandle"}) then {
    // move everything in later
    _buttonID = missionNameSpace getVariable "HCS_Terminal_buttonHandle";
    _button = _ui displayCtrl 10001;
    _button ctrlRemoveEventHandler ["ButtonClick", _buttonID];
};
private _buttonHandle = (_button ctrlAddEventHandler ["ButtonClick", {
    params ["_control"];
    
    private _logNum = missionNameSpace getVariable "HCS_Terminal_logNum";
    private _ui = findDisplay 3499;
    private _controls = allControls _ui;
    private _textBox = _ui displayCtrl 10002;
    private _text = (ctrlText _textBox);
    
    if (_text == "//...") exitWith {};

    private _rndSound = selectRandom [
        "andia\missions\01_HCS\sound\typewriter_finish_01.ogg",  "andia\missions\01_HCS\sound\typewriter_finish_02.ogg",  "andia\missions\01_HCS\sound\typewriter_finish_03.ogg"
    ];
    playSound3D [(getMissionPath _rndSound), player, true, getPosASL player, 2.5, 1, 50];


    _textBox ctrlSetText "//...";
    [format ["[HCS LOG %1]: '%2': %3", _logNum, (toUpper (rank player + " " + (name player))), _text]] remoteExecCall ["diag_log", 0];
    missionNameSpace setVariable ["HCS_Terminal_logNum", (_logNum + 1), true];

    [player, ["andia_hcs_terminal_logs", [(format ["LOG %1: %2", _logNum, (toUpper (rank player + " " + (name player)))]), (format ["%1", _text])]]] remoteExecCall ["createDiaryRecord"];

}]);
uiNamespace setVariable ["HCS_Terminal", _ui];
missionNameSpace setVariable ["HCS_Terminal_buttonHandle", _buttonHandle];
