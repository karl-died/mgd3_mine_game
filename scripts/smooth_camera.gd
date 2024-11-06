extends Camera2D

@export var character : CharacterBody2D

var smoothing = 0.85;
# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	position += (1 - smoothing) * (character.position - position)
	pass
