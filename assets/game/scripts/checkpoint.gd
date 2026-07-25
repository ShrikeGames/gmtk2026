extends MeshInstance3D

class_name CheckPoint
signal checkpoint_reached

@export var id:int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	if is_instance_of(body, PodRacer):
		checkpoint_reached.emit(body, id)
