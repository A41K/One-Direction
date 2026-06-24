extends Control

var key_selection_shown: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_pressed() -> void:
	# Only show the key selection panel once
	if key_selection_shown:
		return
	
	key_selection_shown = true
	
	# Show the keychoose panel
	var keychoose_panel = get_node("KeyChoose")  # Adjust path if needed
	if keychoose_panel:
		keychoose_panel.visible = true
