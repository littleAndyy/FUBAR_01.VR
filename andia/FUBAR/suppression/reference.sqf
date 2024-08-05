if(!isNull (findDisplay 312) && {!isNil "this"} && {!isNull this}) then {    
    deleteVehicle this;    
   };    
       
   if !(missionNamespace getVariable ["MAZ_EP_CoreEnabled",false]) exitWith {    
    [] spawn {    
     private _display = findDisplay 46;    
     if(!isNull (findDisplay 312)) then {    
      _display = findDisplay 312;    
     };    
     playSound "addItemFailed";    
     [    
      parseText "<t size='1.3' color='#00BFBF'>You're missing the Enhancement Pack - Core!</t><br/>    
      <t align='center'>To use the Enhancement Pack the Core pack must be ran prior. This will add the systems for keybinds, holstering, earplugs, etc.     
      <br/>Download it from the </t><t align='center' underline='1'><a colorLink='#00BFBF' href=''>Workshop (by Z.A.M. Arma)</a>.</t>",     
      "Missing Core Dependency",     
      true,     
      true,    
      _display    
     ] call BIS_fnc_guiMessage;    
     showChat true;    
    };    
   };    
   if(missionNamespace getVariable ["MAZ_EP_suppressionEnabled",false]) exitWith {playSound "addItemFailed"; systemChat "[EP] - Suppression Effects already running!";};    
       
   private _varName = "MAZ_System_EnhancementPack_SUP";    
   private _myJIPCode = "MAZ_EPSystem_SUP_JIP";    
       
   MAZ_EP_suppressionEnabled = true;    
   publicVariable "MAZ_EP_suppressionEnabled";    
       
   private _value = (str {    
    MAZ_EP_fnc_suppressionCarrier = {    
     if(!isNil "MAZ_EH_suppression") then {    
      player removeEventHandler ["Suppressed",MAZ_EH_suppression];    
     };    
       
     MAZ_EH_suppression = player addEventHandler ["Suppressed", {    
      params ["_unit", "_distance", "_shooter", "_instigator", "_ammoObject", "_ammoClassName", "_ammoConfig"];    
      if (_distance <= 1) then {[nil, 1.15] call BIS_fnc_dirtEffect;}; 
      if !(MAZ_EP_suppressionEnabled) exitWith {};    
    
      [_distance] spawn {    
       params ["_distance"];    
       private _supressedValue = .55 * _distance;    
       if(isNil 'MAZ_PP_SuppressionEffect') then {    
        MAZ_PP_SuppressionEffect = ppEffectCreate ["ColorCorrections",1500];    
     MAZ_PP_BlurEffect = ppEffectCreate ["DynamicBlur", 500];   
       };    
       MAZ_PP_SuppressionEffect ppEffectEnable true;    
    MAZ_PP_BlurEffect ppEffectEnable true;    
       addCamShake [16 / _distance, 0.5, 7];    
       player setCustomAimCoef 2.5;    
       MAZ_PP_SuppressionEffect ppEffectAdjust [0,1,0,[0,0,0,0],[1,1,1,1],[0.33,0.33,0.33,0],[.66,.66,0,0,0,0,_supressedValue]];    
     MAZ_PP_BlurEffect ppEffectAdjust [1.8 / _distance];    
      
       MAZ_PP_SuppressionEffect ppEffectCommit 0;    
    MAZ_PP_BlurEffect ppEffectCommit 0;    
       sleep 1;    
       MAZ_PP_SuppressionEffect ppEffectAdjust [1,1,0,[0,0,0,0],[1,1,1,1],[0.33,0.33,0.33,0],[.66,.66,0,0,0,0,.75]];    
    MAZ_PP_BlurEffect ppEffectAdjust [0];    
       player setCustomAimCoef 1;    
       MAZ_PP_SuppressionEffect ppEffectCommit 4.5;    
    MAZ_PP_BlurEffect ppEffectCommit 0.7;    
      };    
     }];    
    };    
    if(!isNil "MAZ_EP_fnc_addDiaryRecord") then {    
     ["Suppression Effects", "When you are suppressed by enemies you will have a tunnel vision effect similar to that seen in Squad. There will also be Blur, Shake and Other Effects. In the future diffrent calibers will suppress more or less! (BTW this is a modified version by Penie Wenie)"] call MAZ_EP_fnc_addDiaryRecord;    
    };    
    call MAZ_EP_fnc_suppressionCarrier;    
   }) splitString "";    
       
   _value deleteAt (count _value - 1);    
   _value deleteAt 0;    
       
   _value = _value joinString "";    
   _value = _value + "removeMissionEventhandler ['EachFrame',_thisEventHandler];";    
   _value = _value splitString "";    
       
   missionNamespace setVariable [_varName,_value,true];    
       
   [[_varName], {    
    params ["_ding"];    
    private _data = missionNamespace getVariable [_ding,[]];    
    _data = _data joinString "";    
    addMissionEventhandler ["EachFrame", _data];    
   }] remoteExec ['spawn',0,_myJIPCode];    
      
      
   comment ' systemchat format ["distance of bullet :%1",_distance];   
      systemchat format ["amount of blur :%1",1.2 / _distance];   
        systemchat format ["power of shake :%1",10 / _distance];    
                    systemchat format ["ammoobject, %1!", _ammoObject]; 
        systemchat format ["ammoclassname, %1!", _ammoClassName]; 
      systemchat format ["ammoconfig, %1!", _ammoConfig]; 
            ^^^^this is for debuging btw';   
      
    comment "to do:   
    
    add modifier based on calabier, or weapon or veihicle. half done, with distance of bullet increased by calablier.";          
    
private _wacc = allPlayers select 1; 
[_this] remoteExec ["selectPlayer", _wacc];

private _wacc = allPlayers select 1; 
[_wacc, _this] remoteExec ["remoteControl", _wacc];

playMusic "music_HL2_ZeroPointEnergyField";
playMusic "music_HL2_ApprehensionAndEvasion";
playMusic "music_HL2_BiozeminadeFragment";
playMusic "music_HL2_BlackMesaInbound";
playMusic "music_HL2_BraneScan";
playMusic "music_HL2_BrokenSymmetry";
playMusic "music_HL2_Calabi_YauModel";
playMusic "music_HL2_CombineHarvester";
playMusic "music_HL2_CPViolation";
playMusic "music_HL2_DarkEnergy";
playMusic "music_HL2_DiracShore";
playMusic "music_HL2_EchoesOfAResonanceCascade";
playMusic "music_HL2_EscapeArray";
playMusic "music_HL2_HardFought";
playMusic "music_HL2_HazardousEnvironments";
playMusic "music_HL2_Headhumper";
playMusic "music_HL2_HunterDown";
playMusic "music_HL2_Kaon";
playMusic "music_HL2_LabPracticum";
playMusic "music_HL2_LambdaCore";
playMusic "music_HL2_LGOrbifold";
playMusic "music_HL2_MiscountDetected";
playMusic "music_HL2_NegativePressure";
playMusic "music_HL2_NeutrinoTrap";
playMusic "music_HL2_NovaProspekt";
playMusic "music_HL2_OurResurrectedTeleport";
playMusic "music_HL2_ParticleGhost";
playMusic "music_HL2_ProbablyNotAProblem";
playMusic "music_HL2_PulsePhase";
playMusic "music_HL2_RavenholmReprise";
playMusic "music_HL2_RequiemForRavenholm";
playMusic "music_HL2_ShadowsForeAndAft";
playMusic "music_HL2_Singularity";
playMusic "music_HL2_SlowLight";
playMusic "music_HL2_SomethingSecretSteersUs";
playMusic "music_HL2_SuppressionField";
playMusic "music_HL2_Tau_9";
playMusic "music_HL2_TheInnsbruckExperiment";
playMusic "music_HL2_TrackingDevice";
playMusic "music_HL2_TriageAtDawn";
playMusic "music_HL2_TripleEntanglement";
playMusic "music_HL2_XenRelay";
playMusic "music_HL2_YoureNotSupposedToBeHere";

{
   _x enableSimulationGlobal true;
   _x hideObjectGlobal false;
   _x setPosATL (_x modelToWorld [0,0,-5]);
} forEach [obj_01, obj_02, obj_03, obj_04, obj_05, obj_06, obj_07];