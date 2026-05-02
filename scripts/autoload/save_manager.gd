extends Node

const SAVE_PATH := "user://save_data.cfg"

var best_score: int = 0


func _ready() -> void:
	load_data()


func load_data() -> void:
	var config := ConfigFile.new()
	var error := config.load(SAVE_PATH)
	if error == OK:
		best_score = int(config.get_value("scores", "best_score", 0))
	else:
		best_score = 0


func submit_score(score: int) -> bool:
	if score <= best_score:
		return false

	best_score = score
	save_data()
	return true


func save_data() -> void:
	var config := ConfigFile.new()
	config.set_value("scores", "best_score", best_score)
	config.save(SAVE_PATH)
