extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/titlescreen.tscn")
	

func _on_tutorial_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/tutorial.tscn")


func _on_level_0_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_0.tscn")
