if (!isServer) exitWith {};
params ["_object", "_defendingSide", "_isActive"];

// ! return value: _markers: ARRAY [_marker, _markerInfo]

private _colour = ([_defendingSide, true] call BIS_fnc_sideColor);
if (_defendingSide == civilian) then {
    _colour = "ColorWhite";
};

_marker = createMarker [(format ["ANDIA_FL_AREA-MARKER_%1", random 99999]), (getPos _object)];
_marker setMarkerShape "ELLIPSE";
_marker setMarkerSize [75, 75];
_marker setMarkerColor _colour;
_marker setMarkerAlpha 0.5;
if (_isActive) then {
    _marker setMarkerBrush "SolidFull";
} else {
    _marker setMarkerBrush "Vertical";
};

_markerInfo = createMarker [(format ["ANDIA_FL_AREA-MARKERINFO_%1", random 99999]), (getPos _object)];
_markerInfo setMarkerShape "ICON";
_markerInfo setMarkerType "mil_dot";
_markerInfo setMarkerSize [0.8, 0.8];
_markerInfo setMarkerColor _colour;
_markerInfo setMarkerAlpha 0.8;

private _markers = [_marker, _markerInfo];

_markers