extends Control


func _ready() -> void:
	$Level0/Level0BestTime.text = Global.get_best_time("level_0")
	$Level1/Level1BestTime.text = Global.get_best_time("level_1")
	$Tutorial/TutorialBestTime.text = Global.get_best_time("tutorial")


func _process(delta: float) -> void:
	pass


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/titlescreen.tscn")


func _on_tutorial_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/tutorial.tscn")


func _on_level_0_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_0.tscn")


func _on_level_1_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")
