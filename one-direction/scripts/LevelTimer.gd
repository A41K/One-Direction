extends Label

func _ready() -> void:
	Global.start_level_timer()


func _process(delta: float) -> void:
	text = Global.format_time(Global.get_current_level_time())
