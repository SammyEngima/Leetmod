#include "ui_mp/menustyle.inc"

#include "ui_mp/scriptmenus/server_spectate_setadvars.inc"

menuDef
{
	name			"settings_quick_koth_@MPUI_RULES_FRIENDLY_FIRE"
	fullScreen		0
	rect			0 0 640 480
	focusColor		COLOR_FOCUSED
	//soundloop		""
	onOpen
	{
		setdvar tmp_menu_name spe;
		setdvar tmp_menu_optcount 0;
		setdvar tmp_menu_savedsess 0;
		setdvar tmp_open_event_d1 1;
		execNow "set menu_cfg_gt _def";
		FILLMENUDVARS;
	}
	onClose
	{
	
	}
	onESC
	{
		close self;
	}
#include "ui_mp/blurredbg.inc"
#define MENU_TOPBARSHORT
#include "ui_mp/navcontrols.inc"
#undef MENU_TOPBARSHORT
	
	CHOICE_MENU_TITLE("@OW_SERVER_SPECTATE" )
	
#undef TEXTSIZE_BUTTON_PC
#define TEXTSIZE_BUTTON_PC	0.33
	
#undef CHOICE_SIZE_Y
#define CHOICE_SIZE_Y 		20
	
#undef	CHOICE_SIZE_X
#define CHOICE_SIZE_X		220
	
#undef CHOICE_X_SPACING
#define CHOICE_X_SPACING 300
	
#undef CHOICE_X_START
#define CHOICE_X_START 0
	
#undef CHOICE_Y_START
#define CHOICE_Y_START 34
	
#undef CHOICE_Y_COUNT
#define CHOICE_Y_COUNT			20
	
	
	CHOICE_DVARFLOATLIST_VIS( 1, "@OW_SCR_GAME_SPECTATETYPE", menu_scr_game_spectatetype, { "Disabled" 0 "Team/Player only" 1 "Free" 2 }, SET_SCR_GAME_SPECTATETYPE; , 1 )
	CHOICE_DVARFLOATLIST_VIS( 2, "@OW_SCR_GAME_SPECTATETYPE_SPECTATORS", menu_scr_game_spectatetype_spectators, { "Disabled" 0 "Team/Player only" 1 "Free" 2 }, SET_SCR_GAME_SPECTATETYPE_SPECTATORS; , 1 )
	CHOICE_DVAREDIT_VIS( 3, "@OW_SCR_GAME_SPECTATORS_GUIDS", menu_scr_game_spectators_guids, 1000, 80, SET_SCR_GAME_SPECTATORS_GUIDS; , 1 )
	CHOICE_DVARYESNO( 4, "@OW_SCR_ALLOW_THIRDPERSON", menu_scr_allow_thirdperson, SET_SCR_ALLOW_THIRDPERSON; )
	CHOICE_DVAREDIT_VIS( 5, "@OW_SCR_ALLOW_THIRDPERSON_GUIDS", menu_scr_allow_thirdperson_guids, 1000, 80, SET_SCR_ALLOW_THIRDPERSON_GUIDS; , when( dvarBool(menu_scr_allow_thirdperson) ) )
	
	CHOICE_DVARYESNO( 6, "@OW_SCR_LIVEBROADCAST_ENABLE", menu_scr_livebroadcast_enable, SET_SCR_LIVEBROADCAST_ENABLE; )
	CHOICE_DVAREDIT_VIS( 7, "@OW_SCR_LIVEBROADCAST_GUIDS", menu_scr_livebroadcast_guids, 1000, 80, SET_SCR_LIVEBROADCAST_GUIDS; , when( dvarBool(menu_scr_livebroadcast_enable) ) )
	
	CHOICE_DVAREDIT_NUMERIC( 8, "@OW_SCR_IDLE_SWITCH_SPECTATOR", menu_scr_idle_switch_spectator, 3, SET_SCR_IDLE_SWITCH_SPECTATOR; )
	CHOICE_DVAREDIT_NUMERIC_VIS( 9, "@OW_SCR_IDLE_SPECTATOR_TIMEOUT", menu_scr_idle_spectator_timeout, 3, SET_SCR_IDLE_SPECTATOR_TIMEOUT; , when( dvarBool(menu_scr_idle_switch_spectator) ) )
	CHOICE_DVARYESNO_VIS( 10, "@OW_SCR_IDLE_SHOW_WARNING", menu_scr_idle_show_warning, SET_SCR_IDLE_SHOW_WARNING; , when( dvarBool(menu_scr_idle_switch_spectator) ) )
	CHOICE_DVAREDIT_VIS( 11, "@OW_SCR_IDLE_PROTECTED_TAGS", menu_scr_idle_protected_tags, 1000, 80, SET_SCR_IDLE_PROTECTED_TAGS; , when( dvarBool(menu_scr_idle_switch_spectator) ) )
	CHOICE_DVAREDIT_VIS( 12, "@OW_SCR_IDLE_PROTECTED_GUIDS", menu_scr_idle_protected_guids, 1000, 80, SET_SCR_IDLE_PROTECTED_GUIDS; , when( dvarBool(menu_scr_idle_switch_spectator) ) )
	
#undef CHOICE_Y_COUNT
#define CHOICE_Y_COUNT			100
	
#undef CHOICE_Y_START
#define CHOICE_Y_START -2172
	
#undef CHOICE_HORIZONTAL_ALIGN
#define CHOICE_HORIZONTAL_ALIGN	HORIZONTAL_ALIGN_RIGHT

#undef CHOICE_X_START
#define CHOICE_X_START -400
	
#undef CHOICE_SIZE_X
#define CHOICE_SIZE_X 160
	
#undef TEXTSIZE_BUTTON_PC
#define TEXTSIZE_BUTTON_PC	0.38
	
	CHOICE_DVARSTRINGLIST_VIS( 100, "@OW_MENU_CONFIGURE_TO_GAMETYPE", menu_cfg_gt, { "@OW_MENU_CFG_FOR_DEF_GT"; "_def"; "@OW_ASSASSINATION"; "ass"; "@OW_BEHIND_ENEMY_LINES"; "bel"; "@OW_CAPTURE_AND_HOLD"; "ch"; "@MPUI_CAPTURE_THE_FLAG"; "ctf"; "@MPUI_DOMINATION"; "dom"; "@MPUI_DEATHMATCH"; "dm"; "@OW_FREEZETAG"; "ftag"; "@OW_GREED"; "gr"; "@OW_GUNGAME"; "gg"; "@MPUI_HEADQUARTERS"; "koth"; "@OW_ONEINTHECHAMBER"; "oitc"; "@OW_RETRIEVAL"; "re"; "@MPUI_SABOTAGE"; "sab"; "@MPUI_SEARCH_AND_DESTROY_CLASSIC"; "sd"; "@OW_SHARPSHOOTER"; "ss"; "@MPUI_WAR"; "war"; "@OW_TEAM_GREED"; "tgr"; }, setdvar tmp_menu_optcount 0;setdvar tmp_menu_savedsess 0;FILLMENUDVARS;setdvar tmp_open_event_d1 1; , 1 )
	
	// hack for cleaning dvars (long script) on menu open
	itemDef {
		type			ITEM_TYPE_BUTTON
		rect			-600 -800 2000 2000 0 0
		text			""
		textfont		UI_FONT_NORMAL
		visible			when( dvarbool(tmp_open_event_d1) )
		onfocus { CLEANMENUDVARS;setdvar tmp_open_event_d1 0; }
		mouseEnter { CLEANMENUDVARS;setdvar tmp_open_event_d1 0; }
	}
	
	itemDef {
		name			save
		text			"@OW_MENU_SAVE_FOR_SESSION"
		type			1
		style			WINDOW_STYLE_FILLED
		textstyle		ITEM_TEXTSTYLE_SHADOWED
		rect			130 -26 100 20 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_BOTTOM
		textfont		UI_FONT_NORMAL
		textalign		ITEM_ALIGN_LEFT
		textscale		TEXTSIZE_SMALL
		textaligny		18
		visible			1
		mouseEnter		{ play "mouse_over"; }
		action
		{
			setdvar tmp_menu_savedsess 1;
			play "menu_save_changes";
			SAVEMENUDVARS;
		}
	}
	itemDef {
		name			storedisk
		text			"@OW_MENU_STORE_TO_DISK"
		type			1
		style			WINDOW_STYLE_FILLED
		textstyle		ITEM_TEXTSTYLE_SHADOWED
		rect			-100 -26 100 20 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_BOTTOM
		textfont		UI_FONT_NORMAL
		textalign		ITEM_ALIGN_LEFT
		textscale		TEXTSIZE_SMALL
		textaligny		18
		visible			when( !dvarbool(tmp_menu_savedsess) )
		mouseEnter		{ play "mouse_over"; }
		action { setdvar tmp_menu_optcount 1; open single_popmenu; }
	}
	itemDef {
		type			1
		style			WINDOW_STYLE_SHADER
		rect			-20 -26 16 16 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_BOTTOM
		background		"checkbox_checked"
		forecolor		COLOR_FOCUSED
		visible			when( dvarInt(tmp_menu_optcount) == 14)
	}
}