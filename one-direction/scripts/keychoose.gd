extends Panel

var current_scheme: String = ""


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass


func _on_wasd_pressed() -> void:
	if current_scheme == "wasd":
		return

	current_scheme = "wasd"
	Global.save_scheme("wasd")
	_set_controls(KEY_D)
	_load_game_scene()


func _on_arrow_pressed() -> void:
	if current_scheme == "arrow":
		return

	current_scheme = "arrow"
	Global.save_scheme("arrow")
	_set_controls(KEY_RIGHT)
	_load_game_scene()


func _set_controls(key: Key) -> void:
	if InputMap.has_action("right"):
		var events = InputMap.action_get_events("right")
		for event in events:
			InputMap.action_erase_event("right", event)
	else:
		InputMap.add_action("right")

	var event = InputEventKey.new()
	event.keycode = key
	InputMap.action_add_event("right", event)


func _load_game_scene() -> void:
	get_tree().change_scene_to_file("res://scenes/gamescene.tscn")
