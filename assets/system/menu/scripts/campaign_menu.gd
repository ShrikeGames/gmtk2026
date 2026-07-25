extends CenterContainer

class_name CampaignMenu

@export_category("Game")
@export var game_scene:String = "res://assets/game/scenes/game.scn"
@export var main_menu_scene:String = "res://assets/system/menu/scenes/main_menu.tscn"

@export_category("Main Menu")
@export var main_menu_container:CenterContainer
@export var challenge_champion_menu_button:MainMenuButton
@export var start_menu_button:MainMenuButton
@export var return_to_menu_menu_button:MainMenuButton
@export var exit_menu_button:MainMenuButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.load()
	
	challenge_champion_menu_button.disabled = true
	
	start_menu_button.pressed.connect(_start_menu_button_pressed)
	challenge_champion_menu_button.pressed.connect(_challenge_champion_menu_button_pressed)
	
	return_to_menu_menu_button.pressed.connect(_return_to_menu_menu_button_pressed)
	
	exit_menu_button.pressed.connect(_exit_menu_button_pressed)
	
	

func _start_menu_button_pressed() -> void:
	get_tree().change_scene_to_file(game_scene)
	
func _return_to_menu_menu_button_pressed() -> void:
	get_tree().change_scene_to_file(main_menu_scene)

func _challenge_champion_menu_button_pressed() -> void:
	# TODO
	return

func _hide_all_menus():
	main_menu_container.visible = false
	
func _show_menu(menu_container:CenterContainer):
	menu_container.visible = true

func _exit_menu_button_pressed() -> void:
	if OS.has_feature("web"):
		JavaScriptBridge.eval("window.close()")
	else:
		get_tree().quit()
