extends Node

const SAVE_PATH := "user://save.cfg"

var key_scheme: String = ""

# Timer
var level_start_time: float = 0.0
var level_times: Array = []
var total_time: float = 0.0
var timer_running: bool = false

var best_times: Dictionary = {}


func _ready() -> void:
	_load_save()


func _process(delta: float) -> void:
	if timer_running:
		total_time += delta


func _load_save() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(SAVE_PATH) != OK:
		return
	key_scheme = cfg.get_value("player", "key_scheme", "")
	best_times = cfg.get_value("player", "best_times", {})
	if key_scheme != "":
		_apply_scheme(key_scheme)


func _write_save() -> void:
	var cfg := ConfigFile.new()
	# Preserve existing data before writing
	cfg.load(SAVE_PATH)
	cfg.set_value("player", "key_scheme", key_scheme)
	cfg.set_value("player", "best_times", best_times)
	cfg.save(SAVE_PATH)


func save_scheme(scheme: String) -> void:
	key_scheme = scheme
	_write_save()
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


func start_level_timer() -> void:
	level_start_time = total_time
	timer_running = true


func finish_level_timer(level_name: String) -> void:
	var level_time := total_time - level_start_time
	level_times.append(level_time)
	timer_running = false
	if not best_times.has(level_name) or level_time < best_times[level_name]:
		best_times[level_name] = level_time
		_write_save()


func reset_timer() -> void:
	level_start_time = 0.0
	level_times = []
	total_time = 0.0
	timer_running = false


func get_current_level_time() -> float:
	return total_time - level_start_time


func format_time(seconds: float) -> String:
	var mins := int(seconds) / 60
	var secs := int(seconds) % 60
	var ms := int(fmod(seconds, 1.0) * 100)
	return "%02d:%02d.%02d" % [mins, secs, ms]


func get_best_time(level_name: String) -> String:
	if best_times.has(level_name):
		return format_time(best_times[level_name])
	return "--:--.--"
