extends Area2D

@export var popup_text: String = "Rotation Reversed!"
@export var fade_duration: float = 0.3
@export var visible_duration: float = 0.8


func _ready() -> void:
	if has_node("SwitchLabel"):
		$SwitchLabel.modulate.a = 0.0
		$SwitchLabel.text = popup_text


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		body.is_in_switch_zone = true
		_show_popup()


func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		body.is_in_switch_zone = false


func _show_popup() -> void:
	if not has_node("SwitchLabel"):
		return

	var label: Label = $SwitchLabel
	var tween := create_tween()
	tween.tween_property(label, "modulate:a", 1.0, fade_duration)
	tween.tween_interval(visible_duration)
	tween.tween_property(label, "modulate:a", 0.0, fade_duration)
