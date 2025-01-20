extends Node2D

@export var blackout_duration : float = 3.0

@onready var player : PlayerRat = $PlayerRat
@onready var blackout_layer : CanvasLayer = $Camera2D/CanvasLayer2
@onready var npc : CharacterBody2D = $NPC1
@onready var explosion : Explosion = $Explosion
@onready var tnt_chest : TNT_Chest = $TNT_Chest
@onready var key_item : Key_Item = $Key_Item
@onready var tnt_item : TNT_Item = $TNT_Item
@onready var locked_door : Node2D = $LockedDoor
@onready var success_area : Area2D = $SuccessArea

var chest_isOpen = false

var explosion_timer = 11.5
var tnt_ignited = false

var locked_door_hint_timer = 0

@onready var tnt_music : AudioStreamPlayer2D = $Camera2D/TNTMusic

var blackout_timer = blackout_duration
var reset_performed = true

# Called when the node enters the scene tree for the first time.
func _ready():
	_reset_level()
	blackout_layer.visible = false
	var tnt_chest_lock_area : Area2D = tnt_chest.find_child("LockArea")
	if tnt_chest_lock_area != null:
		tnt_chest_lock_area.area_entered.connect(on_tnt_chest_lock_area_entered)
		
	player.tnt_picked_up.connect(on_tnt_picked_up)
	$LockedDoorKeyHint.visible = true
	$LockedDoor/LockArea.body_entered.connect(on_locked_door_body_entered)
	success_area.body_entered.connect(on_success_area_body_entered)
	#$NPC.body_entered.connect(on_npc_hitbox_entered)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if blackout_timer < blackout_duration:
		reset_performed = false
		blackout_timer += delta
		blackout_layer.visible = true
	elif !reset_performed:
		get_tree().reload_current_scene()
		#_reset_level()
		blackout_layer.visible = false
		reset_performed = true
		
	if tnt_ignited:
		$Camera2D.zoom_out(Vector2(.3, .3))
		explosion_timer -= delta
		explosion.global_position = tnt_item.global_position
		
	if explosion_timer < 0 && tnt_ignited:
		explode_tnt()
		tnt_ignited = false
		
	if locked_door_hint_timer > 0:
		locked_door_hint_timer -= delta
	else:
		$LockedDoorKeyHint.visible = false
		
func on_npc_reached_player():
	blackout_timer = 0.0
	player.position = $PlayerSpawnPosition.position
	$Camera2D/ActionMusic.stop()
	
func on_tnt_chest_lock_area_entered(area: Area2D):
	var parent = area.get_parent()
	if parent.name == "PlayerRat" && area.name == "ItemPickupArea" && player.has_key:
		tnt_chest.open()
		chest_isOpen = true
		player.return_key()
		remove_child(key_item)
		
func on_tnt_picked_up():
	if tnt_ignited == false:
		tnt_music.play()
	tnt_ignited = true
	$Camera2D/ActionMusic.stop()
	$Camera2D/BackgroundMusic.stop()
	
func explode_tnt():
	tnt_item.explode()
	explosion.trigger()
	if tnt_item.destruction_area.overlaps_body(player):
		blackout_timer = 0
		$Camera2D/TextCanvasLayer/YouDiedLabel.visible = true
	elif tnt_item.destruction_area.overlaps_area($LockedDoor/DestructionArea):
		remove_child($LockedDoor)
		remove_child($DestructibleWall)
	else:
		blackout_timer = 0
		$Camera2D/TextCanvasLayer/MissionFailedLabel.visible = true
		
func on_locked_door_body_entered(body: Node2D):
	if body == player && player.has_key:
		$LockedDoorKeyHint.visible = true
		locked_door_hint_timer = 3.0
		
func on_success_area_body_entered(body: Node2D):
	if body == player:
		#blackout_timer = 0
		$Camera2D/TextCanvasLayer/GoodJobLabel.visible = true
		
func on_npc_hitbox_entered(body: Node2D):
	if body == player:
		blackout_timer = 0
		$Camera2D/TextCanvasLayer/YouDiedLabel.visible = true
	
func _reset_level():
	player.position = $PlayerSpawnPosition.position
	player.return_key()
	player.rotation_degrees = 90
	npc.return_key()
	$Camera2D/BackgroundMusic.play()
	for label in $Camera2D/TextCanvasLayer.get_children():
		label.visible = false

func _on_success_area_body_entered(body: Node2D) -> void:
	if(body == player):
		get_tree().change_scene_to_file("res://scenes/Levels/End_scene.tscn")
