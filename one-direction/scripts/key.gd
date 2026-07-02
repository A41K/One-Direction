extends Area2D

@export var key_id: String = "key_a"

var _player: Player = null


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _process(_delta: float) -> void:
	if _player and Input.is_action_just_pressed("interact"):
		_player.pick_up_key(key_id)
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player = body


func _on_body_exited(body: Node2D) -> void:
	if body == _player:
		_player = null
