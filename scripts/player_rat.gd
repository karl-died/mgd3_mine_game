extends CharacterBody2D

enum player_state {
	IDLE,
	RUNNING,
	DASHING,
	TRAPPED
}

@export var speed : float = 140.0
@export var dash_boost : float = 50.0
@export var dash_duration : float = 0.5
@export var dash_recovery_duration : float = 1.0
@export var dash_invincibility_duration : float = 0.1
@export var trap_spam_bonus : float = 0.5
@export var trap_duration : float = 3.0

var move_direction : Vector2 = Vector2(0, 0)
var look_direction : Vector2 = Vector2(1, 0)

var state = player_state.IDLE
var dash_timer = dash_duration
var dash_recovery_timer = dash_recovery_duration
var trap_timer = trap_duration
var invincibility_timer = -0.1
var has_key = false

@onready var anim : AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta):
	if not (state == player_state.TRAPPED):
		if Input.is_action_just_pressed("jump") && dash_recovery_timer < 0:
			state = player_state.DASHING
			dash_timer = dash_duration
			dash_recovery_timer = dash_recovery_duration
			invincibility_timer = dash_invincibility_duration
		else:
			dash_timer -= delta
			
		if dash_timer < 0:
			state = player_state.RUNNING
			dash_recovery_timer -= delta
	
	invincibility_timer -= delta
	
	match state:
		player_state.TRAPPED:
			trap_timer -= delta
			if Input.is_action_just_pressed("jump"):
				trap_timer -= trap_spam_bonus
				anim.play("run")
			else:
				anim.play("default")
			if trap_timer < 0:
				state = player_state.IDLE
				
		player_state.IDLE, player_state.RUNNING:
			#move_direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
			#move_direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
			#move_direction = move_direction.normalized()
			move_direction = Input.get_vector("left", "right", "up", "down")
			anim.speed_scale = 0.5 + 0.5 * move_direction.length()
			
			if move_direction.length() > 0.1:
				look_direction = move_direction
				#anim.material.set("shader_parameter/rotadtion", -look_direction.angle())
				anim.play("run")
			else:
				anim.play("default")
				
			rotation_degrees = (look_direction.angle() / PI) * 180
			velocity = move_direction * speed
			move_and_slide()
			
		player_state.DASHING:
			velocity = look_direction * (speed + dash_boost)
			anim.play("dash")
			move_and_slide()
	
	

func on_trap_entered():
	if invincibility_timer <= 0:
		state = player_state.TRAPPED
		trap_timer = trap_duration
	


func _on_trapdoor_body_entered(body):
	if (body == self && has_key):
		print("success!")
