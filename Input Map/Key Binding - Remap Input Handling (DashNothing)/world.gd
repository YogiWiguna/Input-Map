extends Node2D

@onready var input_mapper = $GUI/InputMapper

var game_paused = false

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		game_paused = !game_paused
		if game_paused: 
			Engine.time_scale = 0
			input_mapper.visible = true
		else: 
			Engine.time_scale = 1
			input_mapper.visible = false
		get_tree().root.get_viewport().set_input_as_handled()
