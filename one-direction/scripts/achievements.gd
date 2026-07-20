extends Control

const FILLED_STAR := preload("res://assets/Star2.png")
const EMPTY_STAR := preload("res://assets/emptystar.png")

const UNLOCKED_TINT := Color(1, 1, 1, 1)
const LOCKED_TINT := Color(0.6, 0.6, 0.62, 1)

const LEVEL_ACHIEVEMENT_NODES := {
	"level_1": "Ach1",
	"level_2": "Ach2",
	"level_3": "Ach3",
	"level_4": "Ach4",
	"level_5": "Ach5",
	# "level_6": "Ach6",
}


func _ready() -> void:
	Global.refresh_achievements()

	var stagger := 0.0
	for level_id in LEVEL_ACHIEVEMENT_NODES:
		var node_name: String = LEVEL_ACHIEVEMENT_NODES[level_id]
		var card := get_node(node_name)
		_setup_level_card(card, level_id, stagger)
		stagger += 0.1

	_setup_all_levels_card(stagger)


func _setup_level_card(card: Panel, level_id: String, stagger: float) -> void:
	var stars: Array = [card.get_node("Star1"), card.get_node("Star2"), card.get_node("Star3")]
	var earned := Global.get_stars_earned(level_id)

	for i in stars.size():
		var sprite: Sprite2D = stars[i]
		var should_fill := i < earned
		var was_filled := sprite.texture == FILLED_STAR
		sprite.texture = FILLED_STAR if should_fill else EMPTY_STAR
		if should_fill and not was_filled:
			_pop_in(sprite, stagger + i * 0.06)

	var subtitle: Label = card.get_node("Subtitle")
	subtitle.text = Global.get_best_time(level_id)

	card.self_modulate = UNLOCKED_TINT if earned >= 3 else LOCKED_TINT


func _setup_all_levels_card(stagger: float) -> void:
	var card: Panel = $AchAll
	var pip_names := ["Pip1", "Pip2", "Pip3", "Pip4", "Pip5"]
	var mastered := Global.get_levels_3starred_count()

	for i in pip_names.size():
		var sprite: Sprite2D = card.get_node(pip_names[i])
		var should_fill := i < mastered
		var was_filled := sprite.texture == FILLED_STAR
		sprite.texture = FILLED_STAR if should_fill else EMPTY_STAR
		if should_fill and not was_filled:
			_pop_in(sprite, stagger + i * 0.06)

	var subtitle: Label = card.get_node("Subtitle")
	subtitle.text = "%d / 5 Levels" % mastered

	card.self_modulate = UNLOCKED_TINT if mastered >= 5 else LOCKED_TINT


func _pop_in(sprite: Sprite2D, delay: float = 0.0) -> void:
	var target_scale := sprite.scale
	sprite.scale = Vector2.ZERO
	var tween := create_tween()
	tween.tween_interval(delay)
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(sprite, "scale", target_scale, 0.4)


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/gamescene.tscn")
