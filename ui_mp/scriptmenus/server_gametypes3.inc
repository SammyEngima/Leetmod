#include "ui_mp/menustyle.inc"

#define ROTATEMENUGAMETYPES2 uiScript closeMenuOnDvar settings_config_gametype p settings_quick_koth; uiScript closeMenuOnDvar settings_config_gametype n settings_quick_koth; uiScript openMenuOnDvar settings_config_gametype p settings_quick_dom; uiScript openMenuOnDvar settings_config_gametype n settings_quick_war;

menuDef
{
	name			"settings_quick_koth"
	fullscreen		0
	rect			0 0 640 480
	focusColor		COLOR_FOCUSED
	//soundloop		""
	onOpen
	{
		execondvarstringvalue settings_config_gametype p "set settings_config_gametype sab";
		execondvarstringvalue settings_config_gametype n "set settings_config_gametype koth";
	}
	onClose
	{
	
	}
	onESC
	{
		close self;
	}
#include "ui_mp/blurredbg.inc"
#include "ui_mp/navcontrols.inc"
	
#undef CHOICE_X_START
#define CHOICE_X_START 80
	
#undef CHOICE_Y_START
#define CHOICE_Y_START 6
	
#undef TEXTSIZE_BUTTON_PC
#define TEXTSIZE_BUTTON_PC	0.4
	
#undef	CHOICE_SIZE_X
#define CHOICE_SIZE_X		200
	
	CHOICE_DVARSTRINGLIST( 1, "@MENU_GAME_TYPE", settings_config_gametype, { ""; "p"; "@MPUI_HEADQUARTERS"; "koth"; "@OW_ONEINTHECHAMBER"; "oitc"; "@OW_RETRIEVAL"; "re"; "@MPUI_SABOTAGE"; "sab"; ""; "n" }, ROTATEMENUGAMETYPES2 )
	
#undef TEXTSIZE_BUTTON_PC
#define TEXTSIZE_BUTTON_PC	0.33
	
#undef CHOICE_X_START
#define CHOICE_X_START 0
	
#undef CHOICE_Y_START
#define CHOICE_Y_START 34
	
#undef CHOICE_SIZE_Y
#define CHOICE_SIZE_Y 		20
	
#undef	CHOICE_SIZE_X
#define CHOICE_SIZE_X		250
	
#include "ui_mp/server_gametype_koth.inc"
#include "ui_mp/server_gametype_oitc.inc"
#include "ui_mp/server_gametype_re.inc"
	
#undef CHOICE_Y_COUNT
#define CHOICE_Y_COUNT			18
	
#undef	CHOICE_SIZE_X
#define CHOICE_SIZE_X		235
	
#undef CHOICE_X_SPACING
#define CHOICE_X_SPACING 285
	
#include "ui_mp/server_gametype_sab.inc"
	
#undef CHOICE_Y_COUNT
#define CHOICE_Y_COUNT			20
	
#undef	CHOICE_SIZE_X
#define CHOICE_SIZE_X		250
	
#undef CHOICE_X_SPACING
#define CHOICE_X_SPACING 350
}