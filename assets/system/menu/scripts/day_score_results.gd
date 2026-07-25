extends Node2D

@export var total_score_text:RichTextLabel
@export var goal_score:int = 15
@export var challenge_button:MainMenuButton

func _ready() -> void:
	var total_score:int = 0
	var total_races:int = Global.save_data.get("game", {}).get("total_races", 0)
	for i in range(0, min(6, total_races)):
		var score:int = int(Global.save_data.get("game", {}).get("score_history")[i])
		self.get_child(i).text = "%spts"%[score]
		total_score += score
	total_score_text.text = "Total %s/%s"%[total_score, goal_score]
	if total_score >= goal_score:
		challenge_button.disabled = false
