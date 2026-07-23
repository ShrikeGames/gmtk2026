extends MainMenuButton
class_name MenuToggleButton

@export var value_options:Array[String] = ["FULLSCREEN", "WINDOWED"]
@export var value_text:String
@export var value_id:int = 0
@export var settings_name:String = "mode"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_prepare_audio()
	Global.load()
	original_text = self.text
	value_id = Global.save_data.get("settings", {}).get("toggles", {}).get(settings_name, value_id)
	value_text = value_options[value_id]
	update_text(false)
	self.pressed.connect(_toggle_value)

func _toggle_value()->void:
	value_id = wrapi(value_id+1, 0, len(value_options))
	Global.save_data.get("settings", {}).get("toggles", {}).set(settings_name, value_id)
	Global.save()
	value_text = value_options[value_id]
	update_text(add_chevrons)

func update_text(include_chevrons:bool) -> void:
	if include_chevrons:
		self.text = "%s %s %s %s"%[Global.CHEVRON_LEFT, original_text, value_text, Global.CHEVRON_RIGHT]
	else:
		self.text = "%s %s"%[original_text, value_text]
