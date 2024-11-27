class_name Item

extends Node2D

@onready var sprite : Sprite2D = $Sprite
var parent_position_node : Node2D = null

func _process(delta):
	if parent_position_node != null:
		global_position = parent_position_node.global_position
		rotation = parent_position_node.rotation
		
func pick_up(parent: Node2D):
	parent_position_node = parent
	sprite.visible = false
	
func drop():
	parent_position_node = null
	sprite.visible = true
	
