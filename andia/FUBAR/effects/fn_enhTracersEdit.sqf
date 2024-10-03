/*

Pierre MGI modules - version sept 2020
_______________________________________

MGI_LIMITTRACERS (boolean) : If you set it to FALSE, all bullets/shells/missiles will have an attached light. That could be enchanting but not very realistic... and resource consuming.

If you let it to TRUE, you will force all end of magazines for custom tracers (set to 5 here);

MGI_FORCESOMETRACERS (number): if set to zero, no extra thing. If you set it >O, 2 cases:
 - the current magazine is already able to fire a tracer regularly (say every 5 bullets): The vanilla parameter is taken into account and the script adds a light on these tracers only;

 - there is no tracer supposed to be fired regularly : in this case, your parameter will add tracers every interval you set.

Colors used are:
 - white for any missile,
 - red for BLUFOR, green for OPFOR, yellow for INDEP


Must be spawned

*/



MGI_LIMITTRACERS = TRUE;
MGI_FORCESOMETRACERS = 1;

fn_tracerLights = compileFinal "
  params ['_light','_projectile','_sideColor','_sideColorAmbient'];

  comment ""_light lightAttachObject [_projectile,[0,-0.5,0]]"";
  _light setLightColor _sideColor;
  _light setLightAmbient _sideColorAmbient;
  _light setLightIntensity (if (sunOrMoon > 0.5) then [{30000},{100}]);
  _light setLightDayLight true;
  _light setLightUseFlare true;
  _light setLightFlareSize .4;
  _light setLightFlareMaxDistance 2000;
  [_light,_projectile] spawn {
    params ['_light','_projectile'];
    waitUntil {uiSleep 0.1; isNull _projectile};
    LightDetachObject _light;
    deleteVehicle _light;
  };
";

// andy edited - only large caliber weaponry!
While {TRUE} do {
	private _allUnits = allUnits select {isNil {_x getVariable "MGI_Tracers"}};
	private ["_unit","_sideColor","_sideColorAmbient"];

  {
    _unit = _x;
    _sideColor = if (side _unit isEqualTo WEST) then [{[235, 150, 150]},{if (side _unit isEqualTo EAST) then [{[150,255,150]},{[255,255,150]}]}];
    _sideColorAmbient = if (side _unit isEqualTo WEST) then [{[2.35, 1.5, 1.5]},{if (side _unit isEqualTo EAST) then [{[1.5,2.55,1.5]},{[2.55,2.55,1.5]}]}];
    _unit setVariable ["MGI_Tracers",[_sideColor,_sideColorAmbient]];

    _unit addEventHandler ["firedMan",{
      params ["_unit", "_weapon", "_muzzle", "", "", "_magazine", "_projectile"];
      if ((getNumber (configfile >> "CfgMagazines" >> _magazine >> "useAction") >= 3.2) && _weapon != "Throw" && _weapon != handgunWeapon _unit && getNumber (configfile >> "CfgMagazines" >> _magazine >> "useAction") != 1 && ["flare","smoke"] findIf {_x in toLowerANSI currentMagazine _unit} == -1) then {
        private _tracerEnabled = FALSE;
        if (MGI_LIMITTRACERS) then {
          call {
            if (_unit ammo _muzzle < ((getNumber (configFile >> "cfgMagazines" >> _magazine >> "lastRoundsTracer")) max 5)) exitWith {
              _tracerEnabled = TRUE;
            };
            _tracersEvery = getNumber (configFile >> "cfgMagazines" >> _magazine >> "tracersEvery");
            if (_tracersEvery == 0 and MGI_FORCESOMETRACERS >0) then {_tracersEvery = MGI_FORCESOMETRACERS};
            if (_tracersEvery >0 && {((_unit ammo _muzzle)+1) mod _tracersEvery == 0}) then {
              _tracerEnabled = TRUE;
            };
          };
        } else {
          _tracerEnabled = TRUE
        };
        private ["_sideColor","_sideColorAmbient"];
        if (_tracerEnabled) then {
          if (getText (configfile >> "CfgMagazines" >> _magazine >> "nameSound") != "missiles") then {
            _sideColor = (_unit getVariable "MGI_Tracers") #0;
            _sideColorAmbient = (_unit getVariable "MGI_Tracers") #1;
          } else {
            _sideColor = [255,255,255];
            _sideColorAmbient = [2.55,2.55,2.55];
          };
          private _light = '#lightPoint' createVehicle (getPosVisual _projectile);
          _light attachTo [_projectile];
          [_light,_projectile,_sideColorAmbient,_sideColorAmbient] call fn_tracerLights;
        };
      };
    }]
  } forEach _allUnits;
  uisleep 3;
};

true