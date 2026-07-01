extends Node

const SAVE_PATH := "user://save.cfg"

var key_scheme: String = ""

# Timer
var level_start_time: float = 0.0
var level_times: Array = []
var total_time: float = 0.0
var timer_running: bool = false

var best_times: Dictionary = {}

# Coins
var collected_coins: Dictionary = {}       
var level_coin_totals: Dictionary = {}   
signal coin_collected(coin_id: String, total_collected: int)

var _is_web: bool = false


func _ready() -> void:
	_is_web = OS.get_name() == "Web"
	_load_save()


func _process(delta: float) -> void:
	if timer_running:
		total_time += delta


# --- Save / Load ---

func _load_save() -> void:
	if _is_web:
		var scheme = JavaScriptBridge.eval("localStorage.getItem('key_scheme') || ''")
		var times_json = JavaScriptBridge.eval("localStorage.getItem('best_times') || '{}'")
		var coins_json = JavaScriptBridge.eval("localStorage.getItem('collected_coins') || '{}'")
		var totals_json = JavaScriptBridge.eval("localStorage.getItem('level_coin_totals') || '{}'")
		key_scheme = str(scheme)
		var parsed = JSON.parse_string(str(times_json))
		if parsed is Dictionary:
			best_times = parsed
		var parsed_coins = JSON.parse_string(str(coins_json))
		if parsed_coins is Dictionary:
			collected_coins = parsed_coins
		var parsed_totals = JSON.parse_string(str(totals_json))
		if parsed_totals is Dictionary:
			level_coin_totals = parsed_totals
	else:
		var cfg := ConfigFile.new()
		if cfg.load(SAVE_PATH) != OK:
			return
		key_scheme = cfg.get_value("player", "key_scheme", "")
		best_times = cfg.get_value("player", "best_times", {})
		collected_coins = cfg.get_value("player", "collected_coins", {})
		level_coin_totals = cfg.get_value("player", "level_coin_totals", {})

	if key_scheme != "":
		_apply_scheme(key_scheme)


func _write_save() -> void:
	if _is_web:
		JavaScriptBridge.eval("localStorage.setItem('key_scheme', '%s')" % key_scheme)
		JavaScriptBridge.eval("localStorage.setItem('best_times', '%s')" % JSON.stringify(best_times))
		JavaScriptBridge.eval("localStorage.setItem('collected_coins', '%s')" % JSON.stringify(collected_coins))
		JavaScriptBridge.eval("localStorage.setItem('level_coin_totals', '%s')" % JSON.stringify(level_coin_totals))
	else:
		var cfg := ConfigFile.new()
		cfg.load(SAVE_PATH)
		cfg.set_value("player", "key_scheme", key_scheme)
		cfg.set_value("player", "best_times", best_times)
		cfg.set_value("player", "collected_coins", collected_coins)
		cfg.set_value("player", "level_coin_totals", level_coin_totals)
		cfg.save(SAVE_PATH)


# --- Key scheme ---

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


# --- Timer ---

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


# --- Coins ---

func register_coin(level_id: String, full_coin_id: String) -> void:
	if not level_coin_totals.has(level_id):
		level_coin_totals[level_id] = {}
	if level_coin_totals[level_id].has(full_coin_id):
		return
	level_coin_totals[level_id][full_coin_id] = true
	_write_save()


func collect_coin(full_coin_id: String) -> void:
	if collected_coins.has(full_coin_id):
		return
	collected_coins[full_coin_id] = true
	_write_save()
	coin_collected.emit(full_coin_id, get_collected_coin_count())


func is_coin_collected(full_coin_id: String) -> bool:
	return collected_coins.has(full_coin_id)


func get_collected_coin_count() -> int:
	return collected_coins.size()

func get_current_level_id() -> String:
	var scene := get_tree().current_scene
	if scene == null or scene.scene_file_path == "":
		return "unknown_level"
	return scene.scene_file_path.get_file().get_basename()


func get_level_coin_total(level_id: String) -> int:
	if level_coin_totals.has(level_id):
		return level_coin_totals[level_id].size()
	return 0


func get_level_coin_collected(level_id: String) -> int:
	var prefix := level_id + "/"
	var count := 0
	for id in collected_coins.keys():
		if str(id).begins_with(prefix):
			count += 1
	return count
