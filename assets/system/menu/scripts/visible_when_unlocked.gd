extends SpotLight3D

@export var character_id:int = 0

func _ready() -> void:
	self.visible = Global.save_data.get("game", {}).get("unlocked_characters", [false,false,false,false,false,false,false,false])[character_id]
