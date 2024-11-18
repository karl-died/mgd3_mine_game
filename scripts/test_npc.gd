extends CharacterBody2D

# signals
signal player_spotted
signal player_caught
signal chase_ended

# avoid navigating tree in code
@export var navigation_agent : NavigationAgent2D
@export var rat : CharacterBody2D
@export var vision_area : Polygon2D
@export var locations_node : Node2D
@onready var locations = locations_node.get_children()
@export var target: Node2D = null
@onready var anim = $AnimatedSprite2D
@onready var key_sprite = $KeySprite
@onready var nav_agent = $NavigationAgent2D

# stats
var walking_speed : float = 350
var running_speed : float = 1000
@onready var current_speed = walking_speed

# walking
var current_location_index : int = 0
var path_smoothing : float = 0.6
var path_node_radius : float = 5
var target_position: Vector2

# chasing
var chase = false
var has_vision_of_rat = false
var chase_timer = Timer.new()



func _ready():
	anim.play("default")
	key_sprite.play("default")
	add_child(chase_timer)
	target = locations[current_location_index]

func _physics_process(_delta):
	# fix jitter on reaching player by smoothly adjusting speed
	var direction = (target.position - position).normalized()
	if (position.distance_to(target.position) < 100 && target == rat):
		current_speed = lerp(current_speed, 0.0, .1)
	elif (target == rat):
		current_speed = lerp(current_speed, running_speed, .1)
		rotation=lerp_angle(rotation, atan2(direction.y, direction.x), .1)
	else:
		rotation=lerp_angle(rotation, atan2(direction.y, direction.x), .1)

	# movement
	nav_agent.target_position = target.global_position
	velocity = global_position.direction_to(nav_agent.get_next_path_position()) * current_speed
	var animation_speed_scale = 0.5 + 0.001 * velocity.length()
	anim.speed_scale = animation_speed_scale
	key_sprite.speed_scale = animation_speed_scale
	
	move_and_slide()

func _on_navigation_agent_2d_target_reached():
	if (!chase):
		current_location_index += 1
		current_location_index %= len(locations)
		target = locations[current_location_index]
	else:
		player_caught.emit()

func _on_area_2d_body_entered(body):
	if (body == rat && !chase):
		chase = true
		target = rat
		current_speed = running_speed
		player_spotted.emit()
		
func _on_key_collider_body_entered(body):
	if (body == rat):
		steal_key()
		rat.steal_key()

func _on_chaserange_body_exited(body):
	if (body == rat && chase):
		chase_ended.emit()
		current_speed = walking_speed
		chase = false
		target = locations[current_location_index]
	
func steal_key():
	key_sprite.visible = false
	
func return_key():
	key_sprite.visible = true
