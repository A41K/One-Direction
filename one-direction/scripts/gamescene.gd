extends Control


func _ready() -> void:
	_update_level_display("level_0", $Level0/Level0BestTime, $Level0/Level0Coins)
	_update_level_display("level_1", $Level1/Level1BestTime, $Level1/Level1Coins)
	_update_level_display("level_2", $Level2/Level2BestTime, $Level2/Level2Coins)
	_update_level_display("level_3", $Level3/Level3BestTime, $Level3/Level3Coins)
	_update_level_display("level_4", $Level4/Level4BestTime, $Level4/Level4Coins)
	$Tutorial/TutorialBestTime.text = Global.get_best_time("tutorial")


func _update_level_display(level_id: String, time_label: Label, coins_label: Label) -> void:
	time_label.text = Global.get_best_time(level_id)

	var collected := Global.get_level_coin_collected(level_id)
	var total := Global.get_level_coin_total(level_id)

	if total > 0:
		coins_label.text = "%d / %d" % [collected, total]
	else:
		coins_label.text = ""


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


func _on_level_2_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_2.tscn")


func _on_level_3_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_3.tscn")


func _on_level_4_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_4.tscn")
