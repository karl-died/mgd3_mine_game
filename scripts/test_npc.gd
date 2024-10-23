extends Node2D

@onready var body : CharacterBody2D = $CharacterBody2D
@export var paths_node : Node2D
@onready var paths = paths_node.get_children()

@export_range(0.0, 1.0) var speed : float = 0.3
@export_range(0.0, 1.0) var path_smoothing : float = 0.2
var path_node_radius : float = 5

var velocity : Vector2 = Vector2(0.0, 0.0)
var current_path_index : int = 0
@onready var current_path_node : Node2D = paths[current_path_index].get_child(0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_follow_path(delta)

func _follow_path(delta):
	if paths == null:
		return
	
	if (current_path_node.global_position - position).length() < path_node_radius:
		current_path_node = current_path_node.get_child(0)
		
	if current_path_node == null:
		current_path_index += 1
		current_path_index %= len(paths)
		current_path_node = paths[current_path_index].get_child(0)
	
	var direction = (current_path_node.global_position - position).normalized() * speed
	var sm = pow(path_smoothing, 0.25);
	velocity = (sm) * velocity + (1.0 - sm) * direction
	position += velocity
	rotation_degrees = (velocity.angle() / PI) * 180
	
	
