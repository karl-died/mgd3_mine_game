extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match InputDevice.input_device:
		"controller": 
			$CanvasLayer/pressContinue.text = "- press A to continue -"
		"keyboard":
			$CanvasLayer/pressContinue.text = "- press Spacebar to continue -"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("ui_accept")):
		get_tree().change_scene_to_file("res://scenes/Levels/first_level.tscn")
