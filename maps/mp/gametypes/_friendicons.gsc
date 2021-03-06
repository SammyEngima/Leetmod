#include openwarfare\_utils;

init()
{
	// Draws a team icon over teammates
	level.drawfriend = getdvarx( "scr_drawfriend", "int", 0, 0, 1 );
	
	game["headicon_allies"] = level.scr_team_allies_headicon;
	game["headicon_axis"] = level.scr_team_axis_headicon;
	
	precacheHeadIcon( game["headicon_allies"] );
	precacheHeadIcon( game["headicon_axis"] );
	
	level thread onPlayerConnect();
	
	/*while(1)
	{
		updateFriendIconSettings();
		wait 5;
	}*/
}

onPlayerConnect()
{
	while(1) {
		level waittill("connected", player);
		
		player thread onPlayerSpawned();
		player thread onPlayerKilled();
	}
}

onPlayerSpawned()
{
	self endon("disconnect");
	
	while(1) {
		self waittill("spawned_player");
		
		self thread showFriendIcon();
	}
}

onPlayerKilled()
{
	self endon("disconnect");
	
	while(1) {
		self waittill("killed_player");
		self.headicon = "";
	}
}

showFriendIcon()
{
	if(level.drawfriend) {
		if(self.pers["team"] == "allies") {
			self.headicon = game["headicon_allies"];
			self.headiconteam = "allies";
		}
		else {
			self.headicon = game["headicon_axis"];
			self.headiconteam = "axis";
		}
	}
}

updateFriendIconSettings()
{
	drawfriend = getdvarFloat("scr_drawfriend");
	if(level.drawfriend != drawfriend) {
		level.drawfriend = drawfriend;
		
		updateFriendIcons();
	}
}

updateFriendIcons()
{
	// for all living players, show the appropriate headicon
	players = level.players;
	for(i = 0; i < players.size; i++) {
		player = players[i];
		
		if(isDefined(player.pers["team"]) && player.pers["team"] != "spectator" && player.sessionstate == "playing") {
			if(level.drawfriend) {
				if(player.pers["team"] == "allies") {
					player.headicon = game["headicon_allies"];
					player.headiconteam = "allies";
				}
				else {
					player.headicon = game["headicon_axis"];
					player.headiconteam = "axis";
				}
			}
			else {
				players = level.players;
				for(i = 0; i < players.size; i++) {
					player = players[i];
					
					if(isDefined(player.pers["team"]) && player.pers["team"] != "spectator" && player.sessionstate == "playing")
						player.headicon = "";
				}
			}
		}
	}
}
