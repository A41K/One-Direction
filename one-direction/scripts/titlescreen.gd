extends Control

var key_selection_shown: bool = false


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass


func _on_play_pressed() -> void:
	if Global.key_scheme != "":
		get_tree().change_scene_to_file("res://scenes/gamescene.tscn")
		return

	if key_selection_shown:
		return

	key_selection_shown = true

	var keychoose_panel = get_node("KeyChoose")
	if keychoose_panel:
		keychoose_panel.visible = true
