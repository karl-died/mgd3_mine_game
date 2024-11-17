extends Node2D

@export var blackout_duration : float = 3.0

@onready var player : CharacterBody2D = $PlayerRat
@onready var blackout_layer : ColorRect = $Camera2D/CanvasLayer2/Blackout
@onready var npc : CharacterBody2D = $NPC

var blackout_timer = blackout_duration
var reset_performed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	_reset_level()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if blackout_timer < blackout_duration:
		reset_performed = false
		blackout_timer += delta
		blackout_layer.visible = true
	elif !reset_performed:
		_reset_level()
		blackout_layer.visible = false
		reset_performed = true
	
func on_npc_reached_player():
	blackout_timer = 0.0
	player.position = $PlayerSpawnPosition.position
	$Camera2D/ActionMusic.stop()
	
func _reset_level():
	player.position = $PlayerSpawnPosition.position
	player.return_key()
	npc.return_key()
	$Camera2D/BackgroundMusic.play()

	
