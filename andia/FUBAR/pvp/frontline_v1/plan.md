	// original fn_objCreate.sqf
	params [
		["_object", objNull], 
		["_objType", "defense"],
		["_side"], // west, east, resistance
		["_radius", 50],
		["_captureTime", 300], 
		["_isLocked", false], 
		["_isHQ", false]
	];

## andy bf1 frontlines

##### (?) = MAY NOT BE NECESSARY

### __fn_FL_gameMain.sqf__
- _teams: [side1, side2] (missionNameSpace array)
- _objectives: missionNameSpace getVariable (array)
	- e.g. [[order, object, [_defendingSide, _attackingSide], _isActive, _isHQ]]
> - cba-PFH & forEach loop to check which objective is active every 10s (?)

### __fn_FL_objectivesCreate.sqf__
(draft) script to be used in eden editor 
(very difficult to use in zeus). 

designed to initialise game

	params ["_objects", "_side1", "_side2"];
	private _numObjectives = (count _objects);
	if ((_numObjectives % 2) == 0) exitWith {
		// number of objectives must be odd
	};
	for "_i" from 0 to _numObjectives do {
		[{
			params ["_index", "_numObjectives", "_objects", "_side1", "_side2"];
			private _isHQ = false;
			// if objective is first or last = HQ
			if (_index == 0 || _index == _numObjectives) then {
				_isHQ = true;
			};
			private _defendingSide = civilian;
			private _attackingSide = civilian;
			private _middleObjective = (round (_numObjectives/2));
			private _isActive = false;
			if (_index == _middleObjective) then {
				_defendingSide = civilian;
				_attackingSide = [_side1,_side2];
				_isActive = true;
			} else {
				if (_index < _middleObjective) then {
					_defendingSide = _side1;
					_attackingSide = _side2;
				} else {
					_defendingSide = _side2;
					_attackingSide = _side1;
				};
			};
			[
				_index,
				(_objects select _index),
				[_defendingSide, _attackingSide],
				_isActive,
				_isHQ
			] remoteExecCall ["andia_fnc_FL_objectiveCreate", 2]; 
		}, [_i, _numObjectives, _objects, "_side1", "_side2"], (_i+1)] call CBA_fnc_waitAndExecute;
	};

- _numObjectives: number of objectives
- _objects: array of objects
- _side1: side
- _side2: side

### __fn_FL_objectiveCreate.sqf__
return value (array): [order, object, [_defendingSide, _attackingSide], _isActive, _isHQ]
- _order: number
- _object: object used as data storage
- _captureTime: seconds to capture (for each side)
- _defendingSide: side (?)
- _attackingSide: side or array (?)
	- (two sides can attack same objective)
- _radius: number
- _captureTime: number
	- _object setVariable _captureTimes (array) 
- _isHQ: boolean
	- create cache objective logic 
	- both caches detonated = end scenario logic & side that detonated>captures objective
- _isActive: boolean
	- keep objective disabled until active (uncapturable)
> - if _defendingSide == civilian then
> 	- _isActive = true
> 	- marker is white + no vertical bars
> - cba-PFH loop = to check which side has the most on objective
> 	- send to fn_FL_objectiveUpdate.sqf

### __fn_FL_objectiveUpdate.sqf__
- _side: new side
- _object: object used as data storage for variables
- _timers: _object getvariable (array)
	- [300,300,300] (for each side : west,east,resistance) == capture timers
> - if current side != old side = broadcast (objective) being captured
> - if timer <= 0 then 
> 	- objective capture
>	- getVariable missionNameSpace (_objectives)
>	- find index of _object in _objectives (array)
> 	- update missionNameSpace variable (inactive & active point)
> 		- current objective captured = index
> 		- if HQ == end scenario logic & unique defender spawnpoint
> 		- if side1 captures == index + 1
> 		- if side2 captures == index - 1
> 		- use index to:
>			- select which objective is inactive
> 			- which is the next active objective
> 			- where the spawn points of defender/attacker are (on previous, inactive objective, before the active objective)