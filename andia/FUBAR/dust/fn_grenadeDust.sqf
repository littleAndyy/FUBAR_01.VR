/*private _grenadeDust = addMissionEventHandler ["ProjectileCreated", {
	params ["_projectile"];

	if ((owner _projectile isEqualTo 0) && !hasInterface) exitWith {};

	_projectile addEventHandler ["Explode", {
		params ["_projectile", "_pos", "_velocity"];

		private _size = getNumber (configFile >> "CfgAmmo" >> (typeOf _projectile) >> "indirectHitRange") * getNumber (configFile >> "CfgAmmo" >> (typeOf _projectile) >> "hit");

		// Prevent things like smoke grenades from generating craters
		if (_size <= 1) exitWith {};

        //TODO: MAKE MULTIPLAYER COMPAT
		if (_size <= 600) exitWith {
            private _dust = "#particlesource" createVehicleLocal (ASLToAGL _pos);
            _dust setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal.p3d",18,16,12,10],"","Billboard",1,25,[0,0,0],[0,0,0.01],0,1.276,1,0.01,[3.5,8,14,16,10,10,10,12,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10],[[0.2,0.2,0.2,0.16],[0.2,0.2,0.2,0.14],[0.2,0.2,0.2,0.1],[0.2,0.2,0.2,0.08],[0.2,0.2,0.2,0.06],[0.2,0.2,0.2,0.03],[0.2,0.2,0.2,0.01],[0.2,0.2,0.2,0.001]],[1000],0.1,0.02,"","","",0,false,0,[[0,0,0,0]],[0,1,0]];
            _dust setParticleRandom [8,[0,0,0],[0.25,0.25,0.1],20,0.3,[0,0,0,0],0,0,1,0];
            _dust setParticleCircle [0,[0,0,0]];
            _dust setParticleFire [0,0,0];
            _dust setDropInterval 0.002;
            _dust spawn {
                sleep 0.05;
                deleteVehicle _this;
            };
		};
	}];
}];*/