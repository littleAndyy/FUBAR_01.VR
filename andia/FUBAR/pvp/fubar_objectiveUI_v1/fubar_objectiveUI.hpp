#include "CustomControlClasses.h"
class fubar_objectiveUI
{
	idd = 3498;
	movingEnable = 0;
	enableDisplay = 1;
	duration = 5;
	fadeIn = 0.5;
	fadeOut = 2;
	name = "fubar_objectiveUI";
	onLoad = "uiNamespace setVariable ['andia_fubar_objectiveUI', _this select 0];";
	class Controls
	{
		class MainText
		{
			type = 0;
			idc = 3499;
			x = safeZoneX + safeZoneW * 0.31875;
			y = safeZoneY + safeZoneH * 0.17555556;
			w = safeZoneW * 0.3625;
			h = safeZoneH * 0.06111112;
			style = 2;
			text = "Objective is being captured by Test!";
			colorBackground[] = {0.2,0.2,0.2,1};
			colorText[] = {1,1,1,1};
			font = "PuristaMedium";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
		};
	};
	class ControlsBackground
	{
		
	};
	
};
