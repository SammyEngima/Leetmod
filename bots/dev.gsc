#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include bots\bots_funcs;

init()
{
	if(getDVarint("bots_main_debug"))
	{
		if(!getDVarint("developer"))
		{
			setdvar("developer_script", 1);
			setdvar("developer", 1);
			
			setdvar("sv_mapRotation", "map "+getDvar("mapname"));
			exitLevel(false);
		}
		
		setdvar("bots_main_menu", 0);
		setdvar("bots_manage_fill_mode", 0);
		setdvar("bots_manage_fill", 0);
		setdvar("bots_manage_add", 0);
		setdvar("bots_manage_fill_kick", 1);
		
		if(getDvar("bots_main_debug_distance") == "")
			setDvar("bots_main_debug_distance", 500.0);
		if(getDvar("bots_main_debug_cone") == "")
			setDvar("bots_main_debug_cone", 0.65);
		if(getDvar("bots_main_debug_commandWait") == "")
			setDvar("bots_main_debug_commandWait", 0.5);
		if(getDvar("bots_main_debug_minDist") == "")
			setDvar("bots_main_debug_minDist", 30.0);
		if(getDvar("bots_main_debug_drawThrough") == "")
			setDvar("bots_main_debug_drawThrough", false);
		
		level.waypointCount = 0;
		level.waypoints = [];
		
		level waittill( "connected", player);
		
		player thread onPlayerSpawned();
	}
}

onPlayerSpawned()
{
	self endon("disconnect");
	for(;;)
	{
		self waittill("spawned_player");
		self thread beginDebug();
	}
}

beginDebug()
{
	level.wpToLink = -1;
	level.autoLink = false;
	self.closest = -1;
	self.command = undefined;
	
	self clearPerks();
	self takeAllWeapons();
	self.specialty = [];
	self giveWeapon("usp_mp");//to knife windows
	self freezecontrols(false);
	
	self thread debug();
	self thread addWaypoints();
	self thread linkWaypoints();
	self thread deleteWaypoints();
	self thread watchSaveWaypointsCommand();
	self thread sayExtras();
	
	self thread textScroll("^1SecondaryOffhand - ^2Add Waypoint; ^3MeleeButton - ^4Link Waypoint; ^5FragButton - ^6Delete Waypoint; ^7UseButton + AttackButton - ^8Save");
}

sayExtras()
{
	self endon("disconnect");
	self endon("death");
	self iprintln("Making a crouch waypoint with only one link...");
	self iprintln("Makes a camping waypoint.");
}

debug()
{
	self endon("disconnect");
	self endon("death");
	
	for(;;)
	{
		wait 0.05;
		
		if(isDefined(self.command))
			continue;
		
		closest = -1;
		myEye = self getTagOrigin( "j_head" );
		
		for(i = 0; i < level.waypointCount; i++)
		{
			if(closest == -1 || closer(self.origin, level.waypoints[i].origin, level.waypoints[closest].origin))
				closest = i;
			
			if(distance(level.waypoints[i].origin, self.origin) < getDvarFloat("bots_main_debug_distance") && (bulletTracePassed(myEye, level.waypoints[i].origin + (0, 0, 25), false, self) || getDVarint("bots_main_debug_drawThrough")))
			{
				for(h = 0; h < level.waypoints[i].childCount; h++)
					line(level.waypoints[i].origin + (0, 0, 25), level.waypoints[level.waypoints[i].children[h]].origin + (0, 0, 25), (1,0,1));
				
				if(self bots_IsFacingAtTarget(level.waypoints[i], getDvarFloat("bots_main_debug_cone")))
					print3d(level.waypoints[i].origin + (0, 0, 25), i, (1,0,0), 2);
			}
		}
		
		self.closest = closest;
	
		if(closest != -1)
		{
			stringChildren = "";
			for(i = 0; i < level.waypoints[closest].childCount; i++)
			{
				if(i != 0)
					stringChildren = stringChildren + "," + level.waypoints[closest].children[i];
				else
					stringChildren = stringChildren + level.waypoints[closest].children[i];
			}
			print3d(level.waypoints[closest].origin + (0, 0, 35), stringChildren, (0,1,0), 2);
			
			print3d(level.waypoints[closest].origin + (0, 0, 15), level.waypoints[closest].type, (0,1,0), 2);
		}
	}
}

AddWaypoints()
{
	self endon("disconnect");
	self endon("death");
	for(;;)
	{
		while(!self SecondaryOffhandButtonPressed() || isDefined(self.command))
			wait 0.05;
		
		pos = self getOrigin();
		self.command = true;
		
		self iprintln("Adding a waypoint...");
		self iprintln("ADS - climb; Attack + Use - tube");
		self iprintln("Attack - grenade; Use - claymore");
		self iprintln("Else(wait) - your stance");
		
		wait getDvarFloat("bots_main_debug_commandWait");
		
		self addWaypoint(pos);
		
		self.command = undefined;
		
		while(self SecondaryOffhandButtonPressed())
			wait 0.05;
	}
}

linkWaypoints()
{
	self endon("disconnect");
	self endon("death");
	for(;;)
	{
		while(!self MeleeButtonPressed() || isDefined(self.command))
			wait 0.05;
		
		self.command = true;
		
		self iprintln("ADS - Unlink; Else(wait) - Link");
		
		wait getDvarFloat("bots_main_debug_commandWait");
		
		if(!self adsButtonPressed())
			self LinkWaypoint(self.closest);
		else
			self UnLinkWaypoint(self.closest);
		
		self.command = undefined;
		
		while(self MeleeButtonPressed())
			wait 0.05;
	}
}

deleteWaypoints()
{
	self endon("disconnect");
	self endon("death");
	for(;;)
	{
		while(!self fragButtonPressed() || isDefined(self.command))
			wait 0.05;
		
		self.command = true;
		
		self iprintln("Attack - DeleteAll; ADS - Load");
		self iprintln("Else(wait) - Delete");
		
		wait getDvarFloat("bots_main_debug_commandWait");
		
		if(self attackButtonPressed())
			self deleteAllWaypoints();
		else if(self adsButtonPressed())
			self LoadWaypoints();
		else
			self DeleteWaypoint(self.closest);
		
		self.command = undefined;
		
		while(self fragButtonPressed())
			wait 0.05;
	}
}

watchSaveWaypointsCommand()
{
	self endon("death");
	self endon("disconnect");
	
	for(;;)
	{
		while(!self useButtonPressed() || !self attackButtonPressed() || isDefined(self.command))
			wait 0.05;
		
		self.command = true;
		
		self iprintln("ADS - Autolink; Else(wait) - Save");
		
		wait getDvarFloat("bots_main_debug_commandWait");
		
		if(!self adsButtonPressed())
		{
			self checkForWarnings();
			logprint("***********ABiliTy's WPDump**************\n\n");
			logprint("\n\n\n\n");
			mpnm=bots_getMapName(getdvar("mapname"));
			logprint("\n\n"+mpnm+"()\n{\n/*");
			logprint("*/waypoints = [];\n/*");
			for(i = 0; i < level.waypointCount; i++)
			{
				logprint("*/waypoints["+i+"] = spawnstruct();\n/*");
				logprint("*/waypoints["+i+"].origin = "+level.waypoints[i].origin+";\n/*");
				logprint("*/waypoints["+i+"].type = \""+level.waypoints[i].type+"\";\n/*");
				logprint("*/waypoints["+i+"].childCount = "+level.waypoints[i].childCount+";\n/*");
				for(c = 0; c < level.waypoints[i].childCount; c++)
				{
					logprint("*/waypoints["+i+"].children["+c+"] = "+level.waypoints[i].children[c]+";\n/*");
				}
				if(isDefined(level.waypoints[i].angles) && (level.waypoints[i].type == "claymore" || level.waypoints[i].type == "tube" || (level.waypoints[i].type == "crouch" && level.waypoints[i].childCount == 1) || level.waypoints[i].type == "climb" || level.waypoints[i].type == "grenade"))
					logprint("*/waypoints["+i+"].angles = "+level.waypoints[i].angles+";\n/*");
			}
			logprint("*/return waypoints;\n}\n\n\n\n");
			self iprintln("Saved!!!");
		}
		else
		{
			if(level.autoLink)
			{
				self iPrintlnBold("Auto link disabled");
				level.autoLink = false;
			}
			else
			{
				self iPrintlnBold("Auto link enabled");
				level.autoLink = true;
			}
		}
		
		self.command = undefined;
		
		while(self useButtonPressed() && self attackButtonPressed())
			wait 0.05;
	}
}

LoadWaypoints()
{
	self DeleteAllWaypoints();
	self iPrintlnBold("Loading WPS...");
	bots_loadWaypoints();
	
	self checkForWarnings();
}

checkForWarnings()
{
	if(level.waypointCount <= 0)
		self iprintln("WARNING: waypointCount is "+level.waypointCount);
	
	if(level.waypointCount != level.waypoints.size)
		self iprintln("WARNING: waypointCount is not "+level.waypoints.size);
	
	for(i = 0; i < level.waypointCount; i++)
	{
		if(!isDefined(level.waypoints[i]))
		{
			self iprintln("WARNING: waypoint "+i+" is undefined");
			continue;
		}
		
		if(level.waypoints[i].childCount <= 0)
			self iprintln("WARNING: waypoint "+i+" childCount is "+level.waypoints[i].childCount);
		
		if(level.waypoints[i].childCount != level.waypoints[i].children.size)
			self iprintln("WARNING: waypoint "+i+" childCount is not "+level.waypoints[i].children.size);
		
		for(h = 0; h < level.waypoints[i].children.size; h++)
		{
			child = level.waypoints[i].children[h];
			
			if(!isDefined(level.waypoints[child]))
				self iprintln("WARNING: waypoint "+i+" child "+child+" is undefined");
			else if(child == i)
				self iprintln("WARNING: waypoint "+i+" child "+child+" is itself");
		}
		
		if(!isDefined(level.waypoints[i].type))
		{
			self iprintln("WARNING: waypoint "+i+" type is undefined");
			continue;
		}
		
		if(!isDefined(level.waypoints[i].angles) && (level.waypoints[i].type == "claymore" || level.waypoints[i].type == "tube" || (level.waypoints[i].type == "crouch" && level.waypoints[i].childCount == 1) || level.waypoints[i].type == "climb" || level.waypoints[i].type == "grenade"))
			self iprintln("WARNING: waypoint "+i+" angles is undefined");
	}
}

DeleteAllWaypoints()
{
	for(i = 0; i < level.waypointCount; i++)
	{
		level.waypoints[i] = undefined;
	}
	
	level.waypoints = [];
	level.waypointCount = 0;
	
	self iprintln("DelAllWps");
}

DeleteWaypoint(nwp)
{
	if(nwp == -1 || distance(self.origin, level.waypoints[nwp].origin) > getDvarFloat("bots_main_debug_minDist"))
	{
		self iprintln("No close enough waypoint to delete.");
		return;
	}
	
	level.wpToLink = -1;
	
	for(i = 0; i < level.waypoints[nwp].childCount; i++)
	{
		child = level.waypoints[nwp].children[i];
		
		level.waypoints[child].children = bots_array_remove(level.waypoints[child].children, nwp);
		
		level.waypoints[child].childCount = level.waypoints[child].children.size;
	}
	
	for(i = 0; i < level.waypointCount; i++)
	{
		for(h = 0; h < level.waypoints[i].childCount; h++)
		{
			if(level.waypoints[i].children[h] > nwp)
				level.waypoints[i].children[h]--;
		}
	}
	
	for ( entry = 0; entry < level.waypointCount; entry++ )
	{
		if ( entry == nwp )
		{
			while ( entry < level.waypointCount-1 )
			{
				level.waypoints[entry] = level.waypoints[entry+1];
				entry++;
			}
			level.waypoints[entry] = undefined;
			break;
		}
	}
	level.waypointCount--;
	
	self iprintln("DelWp "+nwp);
}

addWaypoint(pos)
{
	level.waypoints[level.waypointCount] = spawnstruct();
	
	level.waypoints[level.waypointCount].origin = pos;
	
	if(self AdsButtonPressed())
		level.waypoints[level.waypointCount].type = "climb";
	else if(self AttackButtonPressed() && self UseButtonPressed())
		level.waypoints[level.waypointCount].type = "tube";
	else if(self AttackButtonPressed())
		level.waypoints[level.waypointCount].type = "grenade";
	else if(self UseButtonPressed())
		level.waypoints[level.waypointCount].type = "claymore";
	else
		level.waypoints[level.waypointCount].type = self getStance();
	
	level.waypoints[level.waypointCount].angles = self getPlayerAngles();
	
	level.waypoints[level.waypointCount].children = [];
	level.waypoints[level.waypointCount].childCount = 0;
	
	self iprintln(level.waypoints[level.waypointCount].type + " Waypoint "+ level.waypointCount +" Added at "+pos);
	
	if(level.autoLink)
	{
		if(level.wpToLink == -1)
			level.wpToLink = level.waypointCount - 1;
		
		level.waypointCount++;
		self LinkWaypoint(level.waypointCount - 1);
	}
	else
	{
		level.waypointCount++;
	}
}

UnLinkWaypoint(nwp)
{
	if(nwp == -1 || distance(self.origin, level.waypoints[nwp].origin) > getDvarFloat("bots_main_debug_minDist"))
	{
		self iprintln("Waypoint Unlink Cancelled "+level.wpToLink);
		level.wpToLink = -1;
		return;
	}
	
	if(level.wpToLink == -1 || nwp == level.wpToLink)
	{
		level.wpToLink = nwp;
		self iprintln("Waypoint Unlink Started "+nwp);
		return;
	}
	
	level.waypoints[nwp].children = bots_array_remove(level.waypoints[nwp].children, level.wpToLink);
	level.waypoints[level.wpToLink].children = bots_array_remove(level.waypoints[level.wpToLink].children, nwp);
	
	level.waypoints[nwp].childCount = level.waypoints[nwp].children.size;
	level.waypoints[level.wpToLink].childCount = level.waypoints[level.wpToLink].children.size;
	
	self iprintln("Waypoint " + nwp + " Broken to " + level.wpToLink);
	level.wpToLink = -1;
}

LinkWaypoint(nwp)
{
	if(nwp == -1 || distance(self.origin, level.waypoints[nwp].origin) > getDvarFloat("bots_main_debug_minDist"))
	{
		self iprintln("Waypoint Link Cancelled "+level.wpToLink);
		level.wpToLink = -1;
		return;
	}
	
	if(level.wpToLink == -1 || nwp == level.wpToLink)
	{
		level.wpToLink = nwp;
		self iprintln("Waypoint Link Started "+nwp);
		return;
	}
	
	weGood = true;
	for(i = 0; i < level.waypoints[level.wpToLink].childCount; i++)
	{
		if(level.waypoints[level.wpToLink].children[i] == nwp)
		{
			weGood = false;
			break;
		}
	}
	if(weGood)
	{
		for(i = 0; i < level.waypoints[nwp].childCount; i++)
		{
			if(level.waypoints[nwp].children[i] == level.wpToLink)
			{
				weGood = false;
				break;
			}
		}
	}
	
	if (!weGood )
	{
		self iprintln("Waypoint Link Cancelled "+nwp+" and "+level.wpToLink+" already linked.");
		level.wpToLink = -1;
		return;
	}
	
	level.waypoints[level.wpToLink].children[level.waypoints[level.wpToLink].childcount] = nwp;
	level.waypoints[level.wpToLink].childcount++;
	level.waypoints[nwp].children[level.waypoints[nwp].childcount] = level.wpToLink;
	level.waypoints[nwp].childcount++;
	
	self iprintln("Waypoint " + nwp + " Linked to " + level.wpToLink);
	level.wpToLink = -1;
}

destroyOnDeath(hud)
{
	hud endon("death");
	self bots_waittill_either("death","disconnect");
	hud destroy();
	hud = undefined;
	hud notify("death");
}

textScroll(string)
{
	self endon("death");
	self endon("disconnect");
	//thanks ActionScript
	
    back = createBar((0,0,0), 1000, 30);
    back setPoint("CENTER", undefined, 0, 220);
	self thread destroyOnDeath(back);
	
    text = createFontString("default", 1.5);
    text setText(string);
	self thread destroyOnDeath(text);
	
    for (;;)
    {
        text setPoint("CENTER", undefined, 1200, 220);
        text setPoint("CENTER", undefined, -1200, 220, 20);
        wait 20;
    }
}