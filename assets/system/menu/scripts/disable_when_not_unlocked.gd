extends TextureButton

@export var character_id:int = 0
@export var track_select:bool = false

func _ready() -> void:
	self.disabled = not Global.save_data.get("game", {}).get("unlocked_characters", [false,false,false,false,false,false,false,false])[character_id]
	if self.track_select:
		self.button_pressed = Global.save_data.get("game", {}).get("track", 0) == character_id - 1
	else:
		self.button_pressed = Global.save_data.get("game", {}).get("racer", 0) == character_id
	self.pressed.connect(_button_pressed)
	
	if self.button_pressed:
		_update()

func _button_pressed() -> void:
	_update()
	
func _update():
	if self.track_select:
		Global.save_data.get("game", {})["track"] = character_id - 1
		Global.save()
		return
	
	Global.save_data.get("game", {})["racer"] = character_id
	Global.save()
