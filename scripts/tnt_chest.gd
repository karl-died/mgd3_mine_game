class_name TNT_Chest
extends Node2D

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var lock_area : Area2D = $LockArea
@onready var static_body : StaticBody2D = $StaticBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.play("closed")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func open():
	sprite.play("open")
	z_index = 0
	lock_area.collision_layer = 0
	static_body.collision_layer = 0
	
