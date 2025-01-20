extends Node2D

signal trap_entered

@onready var area : Area2D = $TriggerArea

@export var player : CharacterBody2D

var is_active = true

# Called when the node enters the scene tree for the first time.
func _ready():
	area.body_entered.connect(_on_player_entered)
	area.body_exited.connect(_on_player_exited)
	$ClosedSprite.visible = false
	$LatchSprite.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_player_entered(body: Node2D):
	if (body == player && is_active):
		player.on_trap_entered(area.global_position)
		$ClosedSprite.visible = true
		$LatchSprite.visible = true
		is_active = false
		$AudioStreamPlayer2D.play()

func _on_player_exited(body: Node2D):
	if (body == player):
		$LatchSprite.z_index = 0
