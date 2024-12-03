class_name Item

extends Node2D

@onready var sprite : Sprite2D = $Sprite
@onready var pickup_indicator : Node2D = $ItemPickupIndicator
var parent_position_node : Node2D = null

func _process(delta):
	if parent_position_node != null:
		global_position = parent_position_node.global_position
		rotation = parent_position_node.rotation
		
	if pickup_indicator != null:
		pickup_indicator.global_rotation = 0
		
func pick_up(parent: Node2D):
	print(parent.name)
	parent_position_node = parent
	sprite.visible = false
	
func drop():
	parent_position_node = null
	sprite.visible = true
	
func show_indicator():
	if pickup_indicator != null:
		pickup_indicator.visible = true
		
func hide_indicator():
	if pickup_indicator != null:
		pickup_indicator.visible = false
