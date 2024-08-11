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
    _textBox ctrlSetText "//...";
    [format ["[HCS Log %1]: '%2': %3", (missionNameSpace getVariable "HCS_Terminal_logNum"), (name player), _text]] remoteExecCall ["diag_log", 0];
    missionNameSpace setVariable ["HCS_Terminal_logNum", (_logNum + 1), true];
}]);
uiNamespace setVariable ["HCS_Terminal", _ui];
missionNameSpace setVariable ["HCS_Terminal_buttonHandle", _buttonHandle];
