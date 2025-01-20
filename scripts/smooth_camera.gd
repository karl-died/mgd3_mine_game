extends Camera2D

@export var character : CharacterBody2D

var smoothing = 0.85;
# Called when the node enters the scene tree for the first time.
var zooming_out = false
var zoom_target: Vector2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	position += (1 - smoothing) * (character.position - position)
	if zooming_out:
		zoom = lerp(zoom, zoom_target, .02)
		

func zoom_out(zoomtarget):
	zooming_out = true
	zoom_target = zoomtarget
	
