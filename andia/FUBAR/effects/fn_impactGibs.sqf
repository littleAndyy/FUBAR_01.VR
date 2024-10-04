params ["_pos", "_velocity"];

_velocity = _velocity vectorMultiply (random [0.03,0.08,0.12]);
private _rndSize = (random [2,2.5,3.5]);

private _gibs = "#particlesource" createVehicleLocal _pos;
_gibs setParticleCircle [0, [0, 0, 0]];
_gibs setParticleRandom [0, [0.25, 0.25, 0], [3, 3, 5], 0, 0.25, [0, 0, 0, 0.1], 0, 0];
_gibs setParticleParams [["\A3\data_f\ParticleEffects\Universal\Meat_ca.p3d", 1, 0, 1], "", "SpaceObject", 0.5, 10, [0, 0, 0.5], _velocity, 0.5, 750, 7.9, 0.075, [_rndSize, _rndSize, _rndSize, 0], [[0.1, 0.1, 0.1, 1], [0.25, 0.25, 0.25, 0.5], [0.5, 0.5, 0.5, 0]], [0.08], 1, 0, "", "", _gibs,0,true,0.1];
_gibs setDropInterval 0.01;

private _blood_01 = "#particlesource" createVehicleLocal _pos;
_blood_01 setParticleClass "ATMineExplosionParticles";   
_blood_01 setParticleParams [ 
    ["\a3\Data_f\ParticleEffects\Universal\Universal", 16, 13, 1, 16],   //model name             
    "",   //animation             
    "billboard", //type             
    0.1, 7, //period and lifecycle             
    [0, 0, 0], //position             
    _velocity, //movement vector             
    0, 1, 0.3, 1, //rotation, weight, volume , rubbing             
    [0.2, 8], //size transform             
    [[1,1,1,0.12], [0.01,0.01,0.01,0.0]],     
    [0.00001],     
    0.4,     
    0.4,     
    "",     
    "",     
    "",    
    0, //angle              
    false, //on surface              
    0 //bounce on surface      
];      
_blood_01 setdropinterval 0.01;             

private _blood_02 = "#particlesource" createVehicleLocal _pos;
_blood_02 setParticleParams [
    ["\a3\Data_f\ParticleEffects\Universal\Universal", 16, 13, 1, 16],   //model name            
    "",   //animation            
    "billboard", //type            
    0.1, 0.05, //period and lifecycle            
    [0, 0, 0], //position            

    [0.5 + random -1, 0.5 + random -1, 1], //movement vector            
    1, 1, 0.3, 0, //rotation, weight, volume , rubbing            
    [0.25, 0.45], //size transform            
    [[0.1,0,0,0.001], [0.04,0,0,0.05], [1,1,1,0]],    
    [0.00001],    
    0.4,    
    0.4,    
    "",    
    "",    
    "",   
    0, //angle             
    false, //on surface             
    0 //bounce on surface     
];     
_blood_02 setdropinterval 0.001;         

[{
    _gibs = (_this#0);
    _blood_01 = (_this#1);
    _blood_02 = (_this#2);
    deleteVehicle _gibs;
    deleteVehicle _blood_01;
    deleteVehicle _blood_02;
}, [_gibs, _blood_01, _blood_02], 0.1] call CBA_fnc_waitAndExecute;