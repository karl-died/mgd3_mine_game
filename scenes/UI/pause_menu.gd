extends Control

@export var camera: Camera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#position = camera.position
	testEsc()

func testEsc():
	if (Input.is_action_just_pressed("Escape") && get_tree().paused == false):
		pause()
		$PanelContainer/VBoxContainer/Resume.grab_focus()
	elif (Input.is_action_just_pressed("Escape") && get_tree().paused == true):
		hide()
		show()
		resume()
		
func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")

func pause(): 
	get_tree().paused = true
	$AnimationPlayer.play("blur")

func _on_resume_pressed():
	resume()
	hide()
	show()

func _on_restart_pressed():
	resume()
	get_tree().reload_current_scene()
	

func _on_quit_pressed() -> void:
	get_tree().quit()
