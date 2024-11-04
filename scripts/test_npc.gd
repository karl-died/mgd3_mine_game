extends CharacterBody2D

enum NPCState {
	Walking,
	Chasing
}

@export var navigation_agent : NavigationAgent2D
@export var rat : CharacterBody2D
@export var vision_area : Polygon2D

@export var locations_node : Node2D
@onready var locations = locations_node.get_children()

@export_range(0.0, 800.0) var walking_speed : float = 60
@export_range(0.0, 800.0) var running_speed : float = 95
@export_range(0.0, 1.0) var path_smoothing : float = 0.2
var path_node_radius : float = 5
@onready var current_speed = walking_speed
var current_location_index : int = 0

var state : NPCState = NPCState.Walking
var chase_timer = Timer.new()
var has_vision_of_rat = false
# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(chase_timer)
	navigation_agent.target_position = locations[current_location_index].global_position
	
func _process(delta):
	match state:
		NPCState.Walking:
			_follow_path(delta)
			current_speed = walking_speed
		NPCState.Chasing:
			_chase_rat(delta)
			current_speed = running_speed
			
	
	var next_position = navigation_agent.get_next_path_position()
	var direction = (next_position - position).normalized() * current_speed
	if not navigation_agent.is_target_reachable():
		direction = Vector2(0.0, 0.0)
	var sm = pow(path_smoothing, 0.25);
	
	if not navigation_agent.is_target_reached():
		velocity = (sm) * velocity + (1.0 - sm) * direction
		rotation_degrees = (velocity.angle() / PI) * 180
	else:
		velocity = Vector2(0.0, 0.0)

	move_and_slide()

func _follow_path(delta):
	if locations == null:
		return
	
	if navigation_agent.is_target_reached():
		current_location_index += 1
		current_location_index %= len(locations)
		navigation_agent.target_position = locations[current_location_index].global_position

	
	if Geometry2D.is_point_in_polygon(vision_area.global_transform.affine_inverse() * rat.global_position, vision_area.polygon):
		state = NPCState.Chasing
	
func _chase_rat(delta):
	if Geometry2D.is_point_in_polygon(vision_area.global_transform.affine_inverse() * rat.global_position, vision_area.polygon):
		has_vision_of_rat = true
		navigation_agent.target_position = rat.global_position
	elif has_vision_of_rat == true:
		has_vision_of_rat = false
		chase_timer.one_shot = true
		chase_timer.timeout.connect(_end_chase)
		chase_timer.start(3)
		
	
	
func _end_chase():
	navigation_agent.target_position = locations[current_location_index].global_position
	state = NPCState.Walking
