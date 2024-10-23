extends CharacterBody2D

enum NPCState {
	Idle,
	Walking,
	Chasing
}

@export var navigation_agent : NavigationAgent2D
@export var rat : CharacterBody2D

@export var paths_node : Node2D
@onready var paths = paths_node.get_children()

@export_range(0.0, 100.0) var speed : float = 50
@export_range(0.0, 1.0) var path_smoothing : float = 0.2
var path_node_radius : float = 5

var current_path_index : int = 0
@onready var current_path_node : Node2D = paths[current_path_index].get_child(0)

var state : NPCState = NPCState.Chasing
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _process(delta):
	match state:
		NPCState.Walking:
			_follow_path(delta)
		NPCState.Chasing:
			_chase_rat(delta)

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
	move_and_slide()
	rotation_degrees = (velocity.angle() / PI) * 180;
	
func _chase_rat(delta):
	navigation_agent.target_position = rat.global_position
	var next_position = navigation_agent.get_next_path_position()
	var direction = (next_position - position).normalized() * speed
	if not navigation_agent.is_target_reachable():
		direction = Vector2(0.0, 0.0);
	var sm = pow(path_smoothing, 0.25);
	velocity = (sm) * velocity + (1.0 - sm) * direction
	
	move_and_slide()
	rotation_degrees = (velocity.angle() / PI) * 180;