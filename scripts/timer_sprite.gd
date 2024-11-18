extends AnimatedSprite2D

var duration : float = 1.0
var value : float = 0.0

@export var bump_scale_factor = 1.5
@export_range(0.01, 0.99) var bump_decay = 0.1
@onready var base_scale : float = transform.get_scale().x
@onready var current_scale : float = base_scale


@onready var number_of_frames = sprite_frames.get_frame_count("default")

func _ready():
	pass # Replace with function body.


func _process(delta):
	var current_frame = ((duration - value) / duration) * number_of_frames
	set_frame_and_progress(round(current_frame), 0.0)
	current_scale = lerp(current_scale, base_scale, 1.0 - bump_decay)
	set_scale(Vector2(current_scale, current_scale))

func set_duration(val : float):
	duration = val
	
func set_value(val : float):
	value = val

func trigger_bump():
	current_scale = base_scale * bump_scale_factor
