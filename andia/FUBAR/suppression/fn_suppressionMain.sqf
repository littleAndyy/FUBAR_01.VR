if (!hasInterface) exitWith {};
params ["_unit"];

if (!isNil {_unit getVariable "ANDIA_FUBAR_SuppressionLoop"}) exitWith {
	/*Unit is already being suppressed - loop already in progress.*/
};

if (isNil {_unit getVariable "ANDIA_FUBAR_Suppressed"}) then {
	_unit setVariable ["ANDIA_FUBAR_Suppressed", true];
};

if (isNil {_unit getVariable "ANDIA_FUBAR_Deafness"}) then {
	_unit setVariable ["ANDIA_FUBAR_Deafness", true];
};

private _suppressionValue = _unit getVariable "ANDIA_FUBAR_SuppressionValue";
_unit setVariable ["ANDIA_FUBAR_Suppressed", true];
if ((_unit getVariable "ANDIA_FUBAR_Suppressed") == true) then {
	[{
		params ["_unit"];
		private _suppressionValue = _unit getVariable "ANDIA_FUBAR_SuppressionValue";
		[{
			params ["_unit"];
			_unit setVariable ["ANDIA_FUBAR_Suppressed", false];
		},
		[_unit], (0.25*_suppressionValue)] call CBA_fnc_waitAndExecute;
	},
	[_unit], 1.5] call CBA_fnc_waitAndExecute;
};

private _loop = [{
	params ["_args"];
	private _unit = _args select 0;
	private _suppressionValue = _unit getVariable "ANDIA_FUBAR_SuppressionValue";
	if (_suppressionValue <= 0.1) then {
		_suppressionValue = 0;
	};
	if (_suppressionValue >= 30.00) then {
		_suppressionValue = 30.00;
	};
	if ((_suppressionValue <= 0) || (!alive _unit)) exitWith {
		private _loopPFH = _unit getVariable "ANDIA_FUBAR_SuppressionLoop";
		[_loopPFH] call CBA_fnc_removePerFrameHandler;
		_unit setVariable ["ANDIA_FUBAR_SuppressionLoop", nil];
		_unit setVariable ["ANDIA_FUBAR_SuppressionValue", 0];
	};
	
	
	if ((_unit getVariable "ANDIA_FUBAR_Suppressed") == true) then {
		_suppressionValue = (_suppressionValue - (_suppressionValue * 0.00015));
		systemChat "Suppression has been reduced.";
	} else {
		_suppressionValue = (_suppressionValue - (_suppressionValue * 0.0028));
		systemChat "Suppression normalised.";
	};
	_unit setVariable ["ANDIA_FUBAR_SuppressionValue", _suppressionValue];
	systemChat format ["Suppression: %1", _suppressionValue];

	if ((_suppressionValue >= 10) && ((_unit getVariable "ANDIA_FUBAR_Deafness") == false)) then {
		_unit setVariable ["ANDIA_FUBAR_Deafness", true];
		private _hum = playSoundUI [(getMissionPath "andia\FUBAR\suppression\sound\low_hum_loop.ogg"), 1, 1];
		_unit setVariable ["ANDIA_FUBAR_DeafnessSFX", _hum];
	};
	if ((_suppressionValue <= 10) && ((_unit getVariable "ANDIA_FUBAR_Deafness") == true)) then {
		playSoundUI [(getMissionPath "andia\FUBAR\suppression\sound\low_hum_end.ogg"), 1, 1];
		private _SFX = (_unit getVariable "ANDIA_FUBAR_DeafnessSFX");
		stopSound _SFX;
		_unit setVariable ["ANDIA_FUBAR_Deafness", false];
		_unit setVariable ["ANDIA_FUBAR_DeafnessSFX", nil];
	};
	
	[_unit, _suppressionValue] call andia_fnc_suppressionFX;
	

}, 0, [_unit]] call CBA_fnc_addPerFrameHandler;
_unit setVariable ["ANDIA_FUBAR_SuppressionLoop", _loop];
