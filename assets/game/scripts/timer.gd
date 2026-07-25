extends CenterContainer

@export var pod_racers_node:Node3D
@export var time_text:RichTextLabel
@export var timer:Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.timeout.connect(_start_race)
	pass # Replace with function body.

func _start_race():
	for pod_racer in pod_racers_node.get_children():
		pod_racer.disabled = false
	time_text.visible = false

func _process(_delta: float) -> void:
	time_text.text = "%s"%[snappedf(timer.time_left, 0.01)]
