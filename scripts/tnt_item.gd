class_name TNT_Item

extends Item

@onready var collision_area : Area2D = $CollisionArea

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super(delta)
	pass
	
func pick_up(parent: Node2D):
	parent_position_node = parent
	
func explode():
	sprite.visible = false
	pickup_indicator.visible = false
	collision_area.collision_layer = 0
