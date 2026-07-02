extends RigidBody2D

@export var carry_offset: Vector2 = Vector2(20, -10)

const BOX_ICON_SCENE := preload("res://scenes/box_icon.tscn")

var _player: Player = null
var _pickup_range_body: Node = null
var _nearby_plate: Node = null
var _is_held: bool = false
var _original_parent: Node = null
var _icon: Node2D = null


func _ready() -> void:
	add_to_group("box")
	$InteractArea.body_entered.connect(_on_interact_body_entered)
	$InteractArea.body_exited.connect(_on_interact_body_exited)
	$InteractArea.area_entered.connect(_on_interact_area_entered)
	$InteractArea.area_exited.connect(_on_interact_area_exited)


func _process(_delta: float) -> void:
	if _is_held:
		if Input.is_action_just_pressed("interact") and _nearby_plate:
			_drop()
		return

	if _pickup_range_body and Input.is_action_just_pressed("interact"):
		_pick_up(_pickup_range_body)


func _on_interact_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not _is_held:
		_pickup_range_body = body


func _on_interact_body_exited(body: Node2D) -> void:
	if body == _pickup_range_body:
		_pickup_range_body = null


func _on_interact_area_entered(area: Area2D) -> void:
	if area.is_in_group("pressure_plate"):
		_nearby_plate = area


func _on_interact_area_exited(area: Area2D) -> void:
	if area == _nearby_plate:
		_nearby_plate = null


func _pick_up(player: Player) -> void:
	_player = player
	_is_held = true
	_pickup_range_body = null

	freeze = true
	linear_velocity = Vector2.ZERO
	angular_velocity = 0.0
	$CollisionShape2D.set_deferred("disabled", true)

	$Sprite2D.visible = false
	_icon = BOX_ICON_SCENE.instantiate()
	add_child(_icon)

	_original_parent = get_parent()
	reparent(player.get_node("Sprite2D"), false)
	position = carry_offset


func _drop() -> void:
	_is_held = false

	if _icon:
		_icon.queue_free()
		_icon = null
	$Sprite2D.visible = true

	reparent(_original_parent, true)
	_original_parent = null
	_player = null

	freeze = false
	$CollisionShape2D.set_deferred("disabled", false)
