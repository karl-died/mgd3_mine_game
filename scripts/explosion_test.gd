extends Node2D

@onready var player : CharacterBody2D = $PlayerRat
@onready var blackout_layer : ColorRect = $Camera2D/CanvasLayer2/Blackout
# Called when the node enters the scene tree for the first time.
func _ready():
	player.position = $PlayerSpawnPosition.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("jump"):
		$Explosion.trigger()
