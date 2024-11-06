extends Area2D


@export var key_owner : CharacterBody2D
@export var npc : CharacterBody2D
@export var player : CharacterBody2D

var facing_direction: Vector2
var stealing_timer = Timer.new()
var ready_to_steal = true
var offset_position
var follow_distance = 300

func _ready():
	add_child(stealing_timer)
	stealing_timer.timeout.connect(_ready_to_steal)
	

func _physics_process(_delta):
	facing_direction = Vector2(cos(key_owner.rotation), sin(key_owner.rotation))
	offset_position = key_owner.global_position - facing_direction * follow_distance
	position = lerp(position, offset_position, .1)
	rotation = lerp(rotation, key_owner.rotation, .1)
		

	
func _on_body_entered(body):
	if (key_owner.is_in_group("NPCs") &&
	body.is_in_group("Player") &&
	!key_owner.chase &&
	Input.is_action_pressed("interact_primary")) :
			key_owner = player
			follow_distance = 100
			body.has_key = true
			ready_to_steal = false
			stealing_timer.start(3)

func _on_area_entered(area):
	if (key_owner.is_in_group("Player")):
			key_owner = area.get_parent()
			follow_distance = 400
			ready_to_steal = false
			stealing_timer.start(3)

func _ready_to_steal():
	ready_to_steal = true