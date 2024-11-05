extends Area2D


@export var key_owner : CharacterBody2D
@export var npc : CharacterBody2D
@export var player : CharacterBody2D

var stealing_timer = Timer.new()
var ready_to_steal = true

func _ready():
	add_child(stealing_timer)
	stealing_timer.timeout.connect(_ready_to_steal)

func _physics_process(_delta):
	position = lerp(position, key_owner.position, .1)
	rotation = key_owner.rotation
	
func _on_body_entered(body):
	if (key_owner.is_in_group("NPCs") &&
	body.is_in_group("Player") &&
	!key_owner.is_chasing &&
	Input.is_action_pressed("ínteract_primary")) :
			key_owner = player
			body.has_key = true
			ready_to_steal = false
			stealing_timer.start(3)

func _on_area_entered(area):
	if (key_owner.is_in_group("Player")):
			key_owner = area.get_parent()
			ready_to_steal = false
			stealing_timer.start(3)

func _ready_to_steal():
	ready_to_steal = true
