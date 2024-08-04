if (!hasInterface) exitWith {};
params [["_firstSide", west], ["_secondSide", east], ["_numObjectives", 5], ["_captureTime", 600]];

missionNameSpace setVariable ["andia_FL_firstSide", _firstSide];
missionNameSpace setVariable ["andia_FL_secondSide", _secondSide];

if ((_numObjectives % 2)== 0) exitWith {
    titleText ["<t color='#ff0000' size='1.5' font='OSWALDBOLD' >Number of objectives must be odd!</t>", "PLAIN", -1, true, true];
};

private _team1_HQ = 0;
private _team2_HQ = _numObjectives + 1;
private _neutralObjective = round (_numObjectives / 2); // find middle objective
private _team1_FOB = _neutralObjective - 1;
private _team2_FOB = _neutralObjective + 1;

/*
    ? "HQ" > "OBJECTIVE" > "FOB" > "NEUTRAL" < "FOB" < "OBJECTIVE" < "HQ" ?
*/

player setVariable ["andia_frontline_variables", [

    // ? andia_frontline_sides - 0
    [_firstSide, _secondSide], // ? Sides array [west, east]

    // ? andia_frontline_numObjectives - 1
    [_numObjectives], // ! Number of objectives

    // ? andia_frontline_captureTime - 2
    [_captureTime], // ! Capture time

    // ? andia_frontline_objectives - 3 
    [[]], // ! Objectives array

    // ? andia_frontline_clickCount - 4
    [0], // ! Click count

    // ? Additional variables
    [_team1_HQ, _team2_HQ, _neutralObjective, _team1_FOB, _team2_FOB] // ! Additional variables
]];
player setVariable ["andia_frontline_tempMarkers", []];

titleText ["<t color='#ff0000' size='1.5' font='OSWALDBOLD' >Alt-Click to Cancel.</t><br/>Select Team 1 HQ", "PLAIN", -1, true, true];

[{
    openMap [true,true];

    for "_i" from 0 to _numObjectives do {
        onMapSingleClick {
            params ["_pos", "_units", "_shift", "_alt"];

            private _deleteVariables = {
                player setVariable ["andia_frontline_variables", nil];
                player setVariable ["andia_frontline_tempMarkers", nil];
            };

            if (_alt) exitWith {
                call _deleteVariables;
                openMap [false, false];
                titleText ["<t color='#ff0000' size='1.5' font='OSWALDBOLD' >Cancelled BF1 Frontline Creation!</t>", "PLAIN", -1, true, true];
            };

            private _variablesArray = player getVariable "andia_frontline_variables";
            private _sides = _variablesArray select 0;
            private _numObjectives = _variablesArray select 1;
            private _captureTime =  _variablesArray select 2;
            private _objectives = _variablesArray select 3;
            private _clickCount = _variablesArray select 4;
            private _team1_HQ = _variablesArray select 5;
            private _team2_HQ = _variablesArray select 6;
            private _neutralObjective = _variablesArray select 7;
            private _team1_FOB = _variablesArray select 8;
            private _team2_FOB = _variablesArray select 9;

            private _isHQ = [_clickCount, _team1_HQ, _team2_HQ] call {
                params ["_clickCount", "_team1_HQ", "_team2_HQ"];
                if (_clickCount == _team1_HQ) exitWith {true};
                if (_clickCount == _team2_HQ) exitWith {true};
                false;
            };
            private _side = [_sides, _clickCount, _neutralObjective] call {
                params ["_sides", "_clickCount", "_neutralObjective"];
                private _side1 = _sides select 0;
                private _side2 = _sides select 1;
                if (_clickCount == _neutralObjective) exitWith {civilian};
                if (_clickCount < _neutralObjective) exitWith {_side1};
                if (_clickCount > _neutralObjective) exitWith {_side2};
            };
            private _isFOB = [_clickCount, _team1_FOB, _team2_FOB] call {
                params ["_clickCount", "_team1_FOB", "_team2_FOB"];
                if (_clickCount == _team1_FOB) exitWith {true};
                if (_clickCount == _team2_FOB) exitWith {true};
                false;
            };

            _objectives pushBack [_side, _isHQ, _isFOB, _captureTime, _pos];

            private _marker = createMarkerLocal [(format ["FL_TEMP_%1", random 99999]), _pos];
            _marker setMarkerShapeLocal "ICON";
            _marker setMarkerSizeLocal [0.5, 0.5];
            _marker setMarkerTypeLocal "mil_dot";
            _marker setMarkerColorLocal ([_side, true] call BIS_fnc_sideColor);
            _marker setMarkerTextLocal format ["No.%1: %2, HQ: %3", _clickCount, _side, _isHQ, _isFOB, _captureTime];
            private _markers = player getVariable "andia_frontline_tempMarkers";
            _markers pushBack _marker;
            
            _clickCount = _clickCount + 1;
            player setVariable ["andia_frontline_clickCount", _clickCount];
            if (_clickCount >= _numObjectives) exitWith {
                [_objectives] remoteExecCall ["andia_fnc_FL_createObjectives", 2];
                [{
                    params ["_deleteVariables"];
                    {
                        deleteMarkerLocal _x;
                    } forEach (player getVariable "andia_frontline_tempMarkers");
                    call _deleteVariables;
                    openMap [false, false];
                }, [_deleteVariables], 1.5] call CBA_fnc_waitAndExecute;
            };
        };
    };
}, [], 3] call CBA_fnc_waitAndExecute;

