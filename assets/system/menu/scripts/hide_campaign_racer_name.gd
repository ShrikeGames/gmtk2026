extends RichTextLabel

@export var character_id:int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not Global.save_data.get("game", {}).get("unlocked_characters", [false,false,false,false,false,false,false,false])[character_id]:
		self.text = "???"
