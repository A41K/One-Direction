extends Area2D

@export var coin_id: String = ""

var _full_id: String = ""

func _ready() -> void:
	var level_id := Global.get_current_level_id()

	if coin_id == "":
		coin_id = str(get_tree().current_scene.get_path_to(self))

	_full_id = level_id + "/" + coin_id

	Global.register_coin(level_id, _full_id)

	if Global.is_coin_collected(_full_id):
		queue_free()
		return

	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Global.collect_coin(_full_id)
		queue_free()
