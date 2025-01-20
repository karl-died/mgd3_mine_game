extends Node

var input_device:= "controller"

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ControllerStart"):
		input_device = "controller"
	
	if Input.is_action_just_pressed("KeyboardEnter"):
		input_device = "keyboard"
