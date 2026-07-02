extends Node2D

@export var bob_height: float = 4.0
@export var bob_duration: float = 0.6

var _base_y: float


func _ready() -> void:
	_base_y = position.y
	var tween := create_tween()
	tween.set_loops()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position:y", _base_y - bob_height, bob_duration)
	tween.tween_property(self, "position:y", _base_y + bob_height, bob_duration)
