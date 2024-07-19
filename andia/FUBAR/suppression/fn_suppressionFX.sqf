if (!hasInterface) exitWith {};
params ["_unit", ["_suppressionValue", 0]];


if (isNil {_unit getVariable "ANDIA_FUBAR_SuppressionFX_Array"}) then {
	private _blur = ppEffectCreate ["DynamicBlur", 201];
	_blur ppEffectEnable true;
	
	private _vignette = ppEffectCreate ["ColorCorrections",1499];
	_vignette ppEffectEnable true;
	
	private _grain = ppEffectCreate ["FilmGrain", 2001];
	_grain ppEffectEnable true;
	
	private _colour = ppEffectCreate ["ColorCorrections", 1501];
	_colour ppEffectEnable true;
	
	_unit setVariable ["ANDIA_FUBAR_SuppressionFX_Array", [_blur, _vignette, _grain, _colour]];
};

if (_suppressionValue <= 0.05) exitWith {};

/*if (!isNil {_unit getVariable "ANDIA_FUBAR_SuppressionTinnitus"}) then {
	private _tinnitus = (_unit getVariable "ANDIA_FUBAR_SuppressionTinnitus");
	stopSound _tinnitus;
	_unit setVariable ["ANDIA_FUBAR_SuppressionTinnitus", nil];
};
private _tinnitus = playSoundUI [(getMissionPath "andia\fubar\suppression\sfx_tinnitus_short.ogg"), (0.15*_suppressionValue), 1];
_unit setVariable ["ANDIA_FUBAR_SuppressionTinnitus", _tinnitus];*/

private _soundVolume = (1 - (_suppressionValue * 0.05));
if (_soundVolume <= 0) then {
	_soundVolume = 0;
};
0 fadeSound _soundVolume;
0 fadeMusic _soundVolume;
0 fadeEnvironment _soundVolume;


if (isNil {_unit getVariable "ANDIA_FUBAR_SuppressedBreathing"}) then {
	_unit setVariable ["ANDIA_FUBAR_SuppressedBreathing", false];
};
if (_suppressionValue >= 10 && ((_unit getVariable "ANDIA_FUBAR_SuppressedBreathing") == false)) then {
	//TODO: Potential sound queueing - so that the more suppression, the more sounds to play; As the player is being suppressed each time - it adds to the queue.
	_unit setVariable ["ANDIA_FUBAR_SuppressedBreathing", true];
	private _max = round (_suppressionValue * 0.5);
	for "_i" from 1 to _max do {
		[{
			params ["_unit", "_i", "_max"];
			["_unit", "_i", "_max"] call andia_fnc_suppressionBreathing;
		},
		["_unit", "_i", "_max"], ((_i*(random [1.00,1.04,1.06]))+(_i*0.1))] call CBA_fnc_waitAndExecute;
	};
};


private _FXArray = (_unit getVariable "ANDIA_FUBAR_SuppressionFX_Array");
private _blur = (_FXArray#0);
private _vignette = (_FXArray#1);
private _grain = (_FXArray#2);
private _colour = (_FXArray#3);


_blur ppEffectAdjust [0.3 * _suppressionValue];
_blur ppEffectCommit 0;

private _vignetteValue = (1 - (_suppressionValue * 0.05));
if (_vignetteValue <= 0.4) then {_vignetteValue = 0.4};
_vignette ppEffectAdjust [0,0,0,[0,0,0,0],[0,1,1,1],[0,0.33,0.33,0],[_vignetteValue,_vignetteValue,0,0,0,0,2]];
_vignette ppEffectCommit 0;

_grain ppEffectAdjust [
	(0.01*_suppressionValue), //intensity
	0.4, //sharpness
	0.6, //grainSize
	0.75, //intensityX0
	1, //intensityX1
	0.5 //monochromatic
];
_grain ppEffectCommit 0;

_colour ppEffectAdjust
[
	1,
	1,
	0,
	[0, 0, 0, 0],
	[1, 1, 1, (1-(_suppressionValue*0.1))],
	[0.299, 0.587, 0.114, 0],
	[-1, -1, 0, 0, 0, 0, 0]
];
_colour ppEffectCommit 0;

private _shakePower = _suppressionValue * 0.5;
if (_shakePower >= 4.5) then {_shakePower = 4.5};
addCamShake [_shakePower, 0.5, (0.35*_shakePower)];