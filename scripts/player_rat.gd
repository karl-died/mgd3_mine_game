class_name PlayerRat
extends CharacterBody2D

signal tnt_picked_up

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
@export var key_npc : CharacterBody2D = null

var move_direction : Vector2 = Vector2(0, 0)
var look_direction : Vector2 = Vector2(1, 0)

var state = player_state.IDLE
var dash_timer = dash_duration
var dash_recovery_timer = 0.0
var trap_timer = 0.0
var invincibility_timer = -0.1
var has_key = false

const step_interval_s = 0.1
var step_timer = step_interval_s

@onready var anim : AnimatedSprite2D = $AnimatedSprite2D
@onready var key_sprite : AnimatedSprite2D = $ItemSprites/KeySprite
@onready var dash_recovery_timer_sprite : AnimatedSprite2D = $DashTimerSprite
@onready var trap_timer_sprite : AnimatedSprite2D = $TrapTimerSprite
@onready var item_pickup_area : Area2D = $ItemPickupArea
@onready var item_indicator_area : Area2D = $ItemIndicatorArea
@onready var collision_shape : CollisionShape2D = $CollisionShape2D
@onready var squeek_audio_player : AudioStreamPlayer2D = $SqueekAudioPlayer
@onready var key_audio_player : AudioStreamPlayer2D = $KeyAudioPlayer
@onready var key_steal_audio_player : AudioStreamPlayer2D = $KeyStealAudioPlayer
@onready var key_drop_audio_player : AudioStreamPlayer2D = $KeyDropAudioPlayer
@onready var footstep_audio_player : AudioStreamPlayer2D = $FootstepAudioPlayer

@onready var current_item : Item = null

func _ready():
	key_sprite.visible = false
	dash_recovery_timer_sprite.set_duration(dash_recovery_duration)
	trap_timer_sprite.set_duration(trap_duration)
	item_pickup_area.area_entered.connect(on_item_area_entered)
	item_indicator_area.area_entered.connect(on_item_indicator_area_entered)
	item_indicator_area.area_exited.connect(on_item_indicator_area_exited)
	squeek_audio_player.finished.connect(squeek_audio_player.play)


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
	
	if Input.is_action_just_pressed("drop"):
		if (current_item == TNT_Item):
			print("item was TNT")
		drop_item()
		
		
	
	match state:
		player_state.TRAPPED:
			if Input.is_action_just_pressed("jump"):
				trap_timer -= trap_spam_bonus
				trap_timer_sprite.trigger_bump()
				anim.play("run")
			else:
				anim.play("default")
			if trap_timer < 0:
				state = player_state.IDLE
				
		player_state.IDLE, player_state.RUNNING:
			move_direction = Input.get_vector("left", "right", "up", "down")
			anim.speed_scale = 0.5 + 0.5 * move_direction.length()
			
			if move_direction.length() > 0.1:
				look_direction = move_direction
				#anim.material.set("shader_parameter/rotadtion", -look_direction.angle())
				anim.play("run")
				key_sprite.play("default")
				
				step_timer -= 0.5 * delta + 0.5 * delta * move_direction.length()
				if step_timer < 0:
					footstep_audio_player.play()
					step_timer = step_interval_s
			else:
				anim.play("default")
				key_sprite.stop()
				step_timer = 0
				
			rotation_degrees = (look_direction.angle() / PI) * 180
			velocity = move_direction * speed
			move_and_slide()
			
		player_state.DASHING:
			velocity = look_direction * (speed + dash_boost)
			anim.play("dash")
			move_and_slide()
	
	dash_recovery_timer_sprite.set_value(dash_recovery_timer)
	trap_timer_sprite.set_value(trap_timer)
	
	if current_item == null:
		key_audio_player.stop()
	elif current_item.name == "Key_Item":
			key_sprite.visible = true
			if move_direction.length() > 0.1:
				if key_audio_player.playing == false:
					key_audio_player.play()
			else:
				key_audio_player.stop()
	else:
		key_sprite.visible = false
		key_audio_player.stop()


func on_trap_entered(trap_position: Vector2):
	print("aaaa")
	if invincibility_timer <= 0:
		state = player_state.TRAPPED
		trap_timer = trap_duration
		position = trap_position - Vector2(70.0, 0)
	
	
func on_item_area_entered(item_area: Node2D):
	var item = item_area.get_parent()
	if (item.name == "TNT_item" && get_parent().chest_isOpen):
		return
	if item.get_groups().find("Item") == -1:
		return
	
	drop_item()
	item.pick_up(self)
	item.hide_indicator()
		
	current_item = item
	
	
	match item.name:
		"TNT_Item":
				tnt_picked_up.emit()
		"Key_Item":
			if (key_npc != null):
				key_npc.steal_key()
			
			
			
func on_item_indicator_area_entered(item_area: Node2D):
	if item_area.get_parent().get_groups().find("Item") != -1:
		item_area.get_parent().show_indicator()
	
func on_item_indicator_area_exited(item_area: Node2D):
	if item_area.get_parent().get_groups().find("Item") != -1:
		item_area.get_parent().hide_indicator()
			
			
func drop_item():
	if current_item != null:
		current_item.drop()
		current_item.show_indicator()
		current_item.visible = true
	current_item = null
	for item_sprite in $ItemSprites.get_children():
		item_sprite.visible = false

func _on_trapdoor_body_entered(body):
	if (body == self && has_key):
		print("success!")
		
func steal_key():
	key_sprite.visible = true
	has_key = true
	
func return_key():
	key_sprite.visible = false
	has_key = false
	print("returned key")
	current_item = null
