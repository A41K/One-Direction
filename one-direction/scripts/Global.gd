extends Node

const SAVE_KEY := "application/key_scheme"

var key_scheme: String = ""


func _ready() -> void:
	# Load saved scheme on startup
	if ProjectSettings.has_setting(SAVE_KEY):
		key_scheme = ProjectSettings.get_setting(SAVE_KEY)
		if key_scheme != "":
			_apply_scheme(key_scheme)


func save_scheme(scheme: String) -> void:
	key_scheme = scheme
	ProjectSettings.set_setting(SAVE_KEY, scheme)
	ProjectSettings.save()
	_apply_scheme(scheme)


func _apply_scheme(scheme: String) -> void:
	var key: Key = KEY_D if scheme == "wasd" else KEY_RIGHT
	if InputMap.has_action("right"):
		for event in InputMap.action_get_events("right"):
			InputMap.action_erase_event("right", event)
	else:
		InputMap.add_action("right")
	var event := InputEventKey.new()
	event.keycode = key
	InputMap.action_add_event("right", event)
