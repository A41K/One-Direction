extends Label

func _ready() -> void:
	_update_text()
	Global.coin_collected.connect(_on_coin_collected)


func _on_coin_collected(_coin_id: String, _total: int) -> void:
	_update_text()


func _update_text() -> void:
	text = "%d" % Global.get_collected_coin_count()
