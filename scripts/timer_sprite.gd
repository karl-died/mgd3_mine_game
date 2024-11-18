extends AnimatedSprite2D

var duration : float = 1.0
var value : float = 0.0

@onready var number_of_frames = sprite_frames.get_frame_count("default")

func _ready():
	pass # Replace with function body.


func _process(delta):
	var current_frame = ((duration - value) / duration) * number_of_frames
	set_frame_and_progress(round(current_frame), 0.0)

func set_duration(val : float):
	duration = val
	
func set_value(val : float):
	value = val
