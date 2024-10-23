extends Node2D

@onready var poly = $Polygon2D
@export var rat : CharacterBody2D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(poly.global_transform)
	if Geometry2D.is_point_in_polygon(poly.global_transform.affine_inverse() * rat.global_position, poly.polygon):
		print("chase!")
	else:
		print("no")
		
	#position += Vector2(1.0, 1.0)
	rotation_degrees += 1
