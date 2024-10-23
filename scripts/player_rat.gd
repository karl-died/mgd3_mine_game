extends CharacterBody2D


const SPEED = 140.0

var move_direction : Vector2 = Vector2(0, 0)
var look_direction : Vector2 = Vector2(1, 0)

@onready var anim : AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta):
	move_direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	move_direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	move_direction = move_direction.normalized()
	
	if move_direction.length() > 0.1:
		look_direction = move_direction
		#anim.material.set("shader_parameter/rotadtion", -look_direction.angle())
		anim.play("run")
	else:
		anim.play("default")
	
	rotation_degrees = (look_direction.angle() / PI) * 180
	
	velocity = move_direction * SPEED
	move_and_slide()
