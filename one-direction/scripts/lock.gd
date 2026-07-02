extends Node2D

@export var required_key_id: String = "key_a"
@export var consume_key: bool = true
@export var fade_duration: float = 1.0

var _player: Player = null


func _ready() -> void:
	$InteractArea.body_entered.connect(_on_body_entered)
	$InteractArea.body_exited.connect(_on_body_exited)


func _process(_delta: float) -> void:
	if _player and Input.is_action_just_pressed("interact"):
		_try_unlock()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player = body


func _on_body_exited(body: Node2D) -> void:
	if body == _player:
		_player = null


func _try_unlock() -> void:
	if not _player.has_key(required_key_id):
		return

	if consume_key:
		_player.use_key(required_key_id)

	_unlock()


func _unlock() -> void:
	set_process(false)
	_player = null

	$StaticBody2D/CollisionShape2D.set_deferred("disabled", true)
	$InteractArea/CollisionShape2D.set_deferred("disabled", true)

	var tween := create_tween()
	tween.tween_property($Sprite2D, "modulate:a", 0.0, fade_duration)
	tween.tween_callback(queue_free)
