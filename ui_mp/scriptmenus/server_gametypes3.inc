#include "ui_mp/menustyle_forcascadeinclude.inc"

#define ROTATEMENUGAMETYPES3 uiScript closeMenuOnDvar settings_config_gametype p settings_quick_sab; uiScript closeMenuOnDvar settings_config_gametype n settings_quick_sab; uiScript openMenuOnDvar settings_config_gametype p settings_quick_koth; uiScript openMenuOnDvar settings_config_gametype n settings_quick_sd;

menuDef 
{
  name			"settings_quick_sab"
  fullScreen		1
  rect			0 0 640 480
  focusColor		COLOR_FOCUSED
  //soundloop		""
  onOpen
  {
    execondvarstringvalue settings_config_gametype p "set settings_config_gametype dm";
    execondvarstringvalue settings_config_gametype n "set settings_config_gametype dom";
  }
  onClose
  {
    
  }
  onESC 
  { 
    close self;
  }
  #include "ui/blurredbg.inc"
  //#define 	BACK_ENABLE		0
  //#include "ui_mp/navcontrols.inc"
  
  #undef CHOICE_X_START
  #define CHOICE_X_START 80
  
  #undef CHOICE_Y_START
  #define CHOICE_Y_START 6
  
  #undef TEXTSIZE_BUTTON_PC
  #define TEXTSIZE_BUTTON_PC	0.4
  
  CHOICE_DVARSTRINGLIST( 1, "@MENU_GAME_TYPE", settings_config_gametype, { ""; "p"; "Domination"; "dom"; "Free-for-all"; "dm"; ""; "n" }, ROTATEMENUGAMETYPES3 )
  
  #undef TEXTSIZE_BUTTON_PC
  #define TEXTSIZE_BUTTON_PC	0.33
  
  #undef CHOICE_X_START
  #define CHOICE_X_START 0
  
  #undef CHOICE_Y_START
  #define CHOICE_Y_START 34
  
  #undef CHOICE_SIZE_Y
  #define CHOICE_SIZE_Y 		20

  //#undef	CHOICE_SIZE_X
  //#define CHOICE_SIZE_X		150
  
  //#undef CHOICE_X_SPACING
  //#define CHOICE_X_SPACING 200
  
  #include "ui_mp/server_gametype_dom.inc"
  #include "ui_mp/server_gametype_dm.inc"
}