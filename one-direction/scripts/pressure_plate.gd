extends Area2D

@export var target_path: NodePath
@export var reversible: bool = true
@export var fade_duration: float = 0.5

var _target: Node = null
var _boxes_on_plate: int = 0


func _ready() -> void:
	add_to_group("pressure_plate")
	_target = get_node_or_null(target_path)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("box"):
		return
	_boxes_on_plate += 1
	if _boxes_on_plate == 1:
		_set_target_active(false)


func _on_body_exited(body: Node2D) -> void:
	if not body.is_in_group("box"):
		return
	_boxes_on_plate = max(_boxes_on_plate - 1, 0)
	if _boxes_on_plate == 0 and reversible:
		_set_target_active(true)


func _set_target_active(active: bool) -> void:
	if _target == null or not is_instance_valid(_target):
		return

	_set_target_collision(active)

	if active:
		_target.visible = true

	if _target is CanvasItem:
		var tween := create_tween()
		tween.tween_property(_target, "modulate:a", 1.0 if active else 0.0, fade_duration)
		if not active:
			tween.tween_callback(func():
				if is_instance_valid(_target):
					_target.visible = false
			)
	else:
		_target.visible = active

	if not reversible and not active:
		await get_tree().create_timer(fade_duration).timeout
		if is_instance_valid(_target):
			_target.queue_free()


func _set_target_collision(enabled: bool) -> void:
	for shape in _target.find_children("*", "CollisionShape2D", true, false):
		shape.set_deferred("disabled", not enabled)
	for shape in _target.find_children("*", "CollisionPolygon2D", true, false):
		shape.set_deferred("disabled", not enabled)
