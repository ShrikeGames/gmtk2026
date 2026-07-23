extends Node2D

class_name MainMenu

@export_category("Game")
@export var game_scene:String = "res://assets/game/scenes/game.scn"

@export_category("Main Menu")
@export var main_menu_container:CenterContainer
@export var continue_menu_button:MainMenuButton
@export var start_menu_button:MainMenuButton
@export var options_menu_button:MainMenuButton
@export var credits_button:MainMenuButton
@export var exit_menu_button:MainMenuButton

@export_category("Options Menu")
@export var options_menu_container:CenterContainer
@export var game_options_menu_button:MainMenuButton
@export var audio_options_menu_button:MainMenuButton
@export var video_options_menu_button:MainMenuButton
@export var back_options_menu_button:MainMenuButton

@export_category("Game Options Menu")
@export var game_options_menu_container:CenterContainer
@export var back_game_options_menu_button:MainMenuButton

@export_category("Audio Options Menu")
@export var audio_options_menu_container:CenterContainer
@export var back_audio_options_menu_button:MainMenuButton

@export_category("Video Options Menu")
@export var video_options_menu_container:CenterContainer
@export var video_options_fullscreen_toggle_menu_button:MenuToggleButton
@export var back_video_options_menu_button:MainMenuButton

@export_category("Credits Menu")
@export var credits_menu_container:CenterContainer
@export var back_credits_menu_button:MainMenuButton



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.load()
	_video_options_fullscreen_toggle_menu_button_pressed()
	
	var has_previous_save:bool = Global.save_data.get("game", {}).get("started", false)
	continue_menu_button.disabled = not has_previous_save
	
	start_menu_button.pressed.connect(_start_menu_button_pressed)
	continue_menu_button.pressed.connect(_continue_menu_button_pressed)
	
	options_menu_button.pressed.connect(_options_menu_button_pressed)
	credits_button.pressed.connect(_credits_menu_button_pressed)
	
	game_options_menu_button.pressed.connect(_game_options_menu_button_pressed)
	audio_options_menu_button.pressed.connect(_audio_options_menu_button_pressed)
	video_options_menu_button.pressed.connect(_video_options_menu_button_pressed)
	back_options_menu_button.pressed.connect(_back_options_menu_button_pressed)
	back_credits_menu_button.pressed.connect(_back_options_menu_button_pressed)
	
	back_game_options_menu_button.pressed.connect(_options_menu_button_pressed)
	back_audio_options_menu_button.pressed.connect(_options_menu_button_pressed)
	
	video_options_fullscreen_toggle_menu_button.pressed.connect(_video_options_fullscreen_toggle_menu_button_pressed)
	back_video_options_menu_button.pressed.connect(_options_menu_button_pressed)
	
	exit_menu_button.pressed.connect(_exit_menu_button_pressed)

func _start_menu_button_pressed() -> void:
	Global.save_data.set("game", Global.DEFAULT_SAVE_DATA.get("game"))
	Global.save_data.get("game", Global.DEFAULT_SAVE_DATA.get("game")).set("started", true)
	Global.save()
	get_tree().change_scene_to_file(game_scene)

func _continue_menu_button_pressed() -> void:
	get_tree().change_scene_to_file(game_scene)

func _hide_all_menus():
	main_menu_container.visible = false
	options_menu_container.visible = false
	game_options_menu_container.visible = false
	audio_options_menu_container.visible = false
	video_options_menu_container.visible = false
	credits_menu_container.visible = false
	
func _show_menu(menu_container:CenterContainer):
	menu_container.visible = true

func _options_menu_button_pressed() -> void:
	_hide_all_menus()
	_show_menu(options_menu_container)
	
func _credits_menu_button_pressed() -> void:
	_hide_all_menus()
	_show_menu(credits_menu_container)

func _game_options_menu_button_pressed() -> void:
	_hide_all_menus()
	_show_menu(game_options_menu_container)

func _audio_options_menu_button_pressed() -> void:
	_hide_all_menus()
	_show_menu(audio_options_menu_container)
	
func _video_options_menu_button_pressed() -> void:
	_hide_all_menus()
	_show_menu(video_options_menu_container)

func _back_options_menu_button_pressed() -> void:
	_hide_all_menus()
	_show_menu(main_menu_container)

func _video_options_fullscreen_toggle_menu_button_pressed() -> void:
	var window : Window = get_window()
	window.mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (video_options_fullscreen_toggle_menu_button.value_id == 1) else Window.MODE_WINDOWED

func _exit_menu_button_pressed() -> void:
	if OS.has_feature("web"):
		JavaScriptBridge.eval("window.close()")
	else:
		get_tree().quit()
