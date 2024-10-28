extends CharacterBody2D

enum player_state {
	IDLE,
	RUNNING,
	DASHING
}

@export var speed : float = 140.0
@export var dash_boost : float = 50.0
@export var dash_duration : float = 0.5
@export var dash_recovery_duration : float = 1.0

var move_direction : Vector2 = Vector2(0, 0)
var look_direction : Vector2 = Vector2(1, 0)

var state = player_state.IDLE
var dash_timer = dash_duration
var dash_recovery_timer = dash_recovery_duration

@onready var anim : AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta):
	
	if Input.is_action_just_pressed("jump") && dash_recovery_timer < 0:
		state = player_state.DASHING
		dash_timer = dash_duration
		dash_recovery_timer = dash_recovery_duration
	else:
		dash_timer -= delta
		
	if dash_timer < 0:
		state = player_state.RUNNING
		dash_recovery_timer -= delta
		
		
	match state:
		player_state.IDLE, player_state.RUNNING:
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
			velocity = move_direction * speed
			
		player_state.DASHING:
			velocity = look_direction * (speed + dash_boost)
			anim.play("dash")
	
	
	
	
	move_and_slide()
