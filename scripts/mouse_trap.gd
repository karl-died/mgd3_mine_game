extends Node2D

signal trap_entered

@onready var area : Area2D = $Area2D

var is_active = true

# Called when the node enters the scene tree for the first time.
func _ready():
	area.monitoring = true
	area.body_entered.connect(_on_player_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_player_entered(_body: CharacterBody2D):
	trap_entered.emit()
