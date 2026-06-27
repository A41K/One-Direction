class_name Player extends CharacterBody2D

var jump_height: float = -400.0
var gravity: float = 20.0
const max_gravity: float = 18

var is_wall_sticking: bool = false

var world_rotation_steps: int = 0

const max_speed: float = 150
const acceleration: float = 12
const friction: float = 26

var last_right_press_time: float = 0.0
const double_tap_window: float = 0.3

var spawn_position: Vector2

var is_in_switch_zone: bool = false


func _ready() -> void:
	print("Player initialized")
	spawn_position = global_position
	add_to_group("player")


func _get_axes() -> Array:
	match world_rotation_steps:
		0: return [Vector2.DOWN, Vector2.RIGHT]
		1: return [Vector2.LEFT, Vector2.UP]
		2: return [Vector2.UP, Vector2.RIGHT]
		3: return [Vector2.RIGHT, Vector2.DOWN]
	return [Vector2.DOWN, Vector2.RIGHT]


func _physics_process(delta: float) -> void:
	_handle_double_tap_input()

	var axes = _get_axes()
	var grav_dir: Vector2 = axes[0]
	var move_dir: Vector2 = axes[1]

	up_direction = -grav_dir

	var x_input: float = Input.get_action_strength("ui_right") - Input.get_action_strength("left")

	if is_in_switch_zone:
		x_input = -x_input

	var velocity_weight: float = delta * (acceleration if x_input else friction)

	var move_speed: float = velocity.dot(move_dir)
	move_speed = lerp(move_speed, x_input * max_speed, velocity_weight)

	var grav_speed: float = velocity.dot(grav_dir)

	if is_wall_sticking:
		grav_speed = 0.0

	if is_on_floor():
		gravity = lerp(gravity, 12.0, 12.0 * delta)
	elif not is_wall_sticking:
		if Input.is_action_just_released("jump") or is_on_ceiling():
			grav_speed *= 0.5
		gravity = lerp(gravity, max_gravity, 12.0 * delta)

	if Input.is_action_just_pressed("jump") and is_on_floor():
		grav_speed = jump_height

	if grav_speed < jump_height / 2.0:
		var head_collision: Array = [
			$Left_HeadNudge.is_colliding(), $Left_HeadNudge2.is_colliding(),
			$Right_HeadNudge.is_colliding(), $Right_HeadNudge2.is_colliding()
		]
		if head_collision.count(true) == 1:
			if head_collision[0]:
				global_position += move_dir * 1.75
			if head_collision[2]:
				global_position -= move_dir * 1.75

	if grav_speed > -30 and abs(move_speed) > 3:
		if $Left_LedgeHop.is_colliding() and !$Left_LedgeHop2.is_colliding() and x_input < 0:
			grav_speed += jump_height / 3.25
		if $Right_LedgeHop.is_colliding() and !$Right_LedgeHop2.is_colliding() and x_input > 0:
			grav_speed += jump_height / 3.25

	if not is_wall_sticking:
		grav_speed += gravity

	velocity = move_dir * move_speed + grav_dir * grav_speed

	move_and_slide()


func _handle_double_tap_input() -> void:
	if Input.is_action_just_pressed("right"):
		var current_time = Time.get_ticks_msec() / 1000.0
		var time_since_last = current_time - last_right_press_time

		if time_since_last <= double_tap_window and last_right_press_time > 0:
			print("DOUBLE TAP DETECTED!")
			_rotate_world()
			last_right_press_time = 0.0
		else:
			last_right_press_time = current_time


func _rotate_world() -> void:
	world_rotation_steps = (world_rotation_steps + 1) % 4
	var target_deg: float = world_rotation_steps * -90.0

	var cam: Camera2D = $Camera2D
	cam.rotation_degrees = target_deg

	$Sprite2D.rotation_degrees = -target_deg

	print("World rotated to: ", target_deg, " deg")


func respawn() -> void:
	global_position = spawn_position
	velocity = Vector2.ZERO
	gravity = 20.0
	Global.start_level_timer()
	is_in_switch_zone = false

	world_rotation_steps = 0
	$Camera2D.rotation_degrees = 0.0
	$Sprite2D.rotation_degrees = 0.0

	print("Player respawned at: ", spawn_position)
