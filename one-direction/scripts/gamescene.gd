extends Control

const FILLED_STAR := preload("res://assets/Star2.png")
const EMPTY_STAR := preload("res://assets/emptystar.png")

const LEVEL_COUNT := 6


func _ready() -> void:
	for i in LEVEL_COUNT:
		var level_node := get_node(str("Level", i))
		var level_id := "level_%d" % i
		var time_label: Label = level_node.get_node(str("Level", i, "BestTime"))
		var star_sprites: Array = [
			level_node.get_node(str("Level", i, "Star1")),
			level_node.get_node(str("Level", i, "Star2")),
			level_node.get_node(str("Level", i, "Star3")),
		]
		var coin_sprites: Array = [
			level_node.get_node(str("Level", i, "Coin1")),
			level_node.get_node(str("Level", i, "Coin2")),
			level_node.get_node(str("Level", i, "Coin3")),
		]
		_update_level_display(level_id, time_label, star_sprites, coin_sprites)

	$Tutorial/TutorialBestTime.text = Global.get_best_time("tutorial")


func _update_level_display(level_id: String, time_label: Label, star_sprites: Array, coin_sprites: Array) -> void:
	time_label.text = Global.get_best_time(level_id)
	_update_stars(level_id, star_sprites)
	_update_coins(level_id, coin_sprites)


func _update_stars(level_id: String, star_sprites: Array) -> void:
	var earned := Global.get_stars_earned(level_id)
	for i in star_sprites.size():
		var sprite: Sprite2D = star_sprites[i]
		if i < earned:
			var already_filled := sprite.texture == FILLED_STAR
			sprite.texture = FILLED_STAR
			if not already_filled:
				_pop_in(sprite)
		else:
			sprite.texture = EMPTY_STAR


func _update_coins(level_id: String, coin_sprites: Array) -> void:
	var collected := Global.get_level_coin_collected(level_id)
	for i in coin_sprites.size():
		var sprite: Sprite2D = coin_sprites[i]
		var should_show := i < collected
		if should_show and not sprite.visible:
			sprite.visible = true
			_pop_in(sprite)
		elif not should_show:
			sprite.visible = false


func _pop_in(sprite: Sprite2D) -> void:
	var target_scale := sprite.scale
	sprite.scale = Vector2.ZERO
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(sprite, "scale", target_scale, 0.4)


func _process(delta: float) -> void:
	pass


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/titlescreen.tscn")


func _on_tutorial_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/tutorial.tscn")


func _on_level_0_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_0.tscn")


func _on_level_1_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")


func _on_level_2_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_2.tscn")


func _on_level_3_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_3.tscn")


func _on_level_4_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_4.tscn")


func _on_level_5_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_5.tscn")
