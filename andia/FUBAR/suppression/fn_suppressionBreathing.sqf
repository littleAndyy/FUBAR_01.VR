if (!hasInterface) exitWith {};
params ["_unit", "_i", "_max"];

if (_i == _max) then {
    _unit setVariable ["ANDIA_FUBAR_SuppressedBreathing", false];
};

private _rndSound = selectRandom [
    "andia\FUBAR\suppression\sound\HLL_Breathing_Heavy_M_1.ogg",
    "andia\FUBAR\suppression\sound\HLL_Breathing_Heavy_M_2.ogg",
    "andia\FUBAR\suppression\sound\HLL_Breathing_Heavy_M_3.ogg",
    "andia\FUBAR\suppression\sound\HLL_Breathing_Heavy_M_4.ogg",
    "andia\FUBAR\suppression\sound\HLL_Breathing_Heavy_M_5.ogg",
    "andia\FUBAR\suppression\sound\HLL_Breathing_Heavy_M_6.ogg",
    "andia\FUBAR\suppression\sound\HLL_Breathing_Heavy_M_7.ogg",
    "andia\FUBAR\suppression\sound\HLL_Breathing_Heavy_M_8.ogg",
    "andia\FUBAR\suppression\sound\HLL_Breathing_Heavy_M_9.ogg",
    "andia\FUBAR\suppression\sound\HLL_Breathing_Heavy_M_10.ogg",
    "andia\FUBAR\suppression\sound\HLL_Breathing_Heavy_M_11.ogg",
    "andia\FUBAR\suppression\sound\HLL_Breathing_Heavy_M_12.ogg",
    "andia\FUBAR\suppression\sound\HLL_Breathing_Heavy_M_13.ogg",
    "andia\FUBAR\suppression\sound\HLL_Breathing_Heavy_M_14.ogg",
    "andia\FUBAR\suppression\sound\HLL_Breathing_Heavy_M_15.ogg",
    "andia\FUBAR\suppression\sound\HLL_Breathing_Heavy_M_16.ogg",
    "andia\FUBAR\suppression\sound\HLL_Breathing_Heavy_M_17.ogg"
];
playSoundUI [(getMissionPath _rndSound), 0.33, 1];