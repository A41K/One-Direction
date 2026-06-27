extends Area2D

@export var level_name: String = "tutorial"
@export var next_scene: String = "res://scenes/gamescene.tscn"


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		Global.finish_level_timer(level_name)
		print("Level time: ", Global.format_time(Global.level_times.back()))
		get_tree().change_scene_to_file(next_scene)
