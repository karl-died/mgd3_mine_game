extends Node2D

@export var blackout_duration : float = 3.0

@onready var player : PlayerRat = $PlayerRat
@onready var blackout_layer : CanvasLayer = $Camera2D/CanvasLayer2
@onready var npc : CharacterBody2D = $NPC
@onready var explosion : Explosion = $Explosion
@onready var tnt_chest : TNT_Chest = $TNT_Chest
@onready var key_item : Key_Item = $Key_Item
@onready var tnt_item : TNT_Item = $TNT_Item
@onready var locked_door_collision_area : Node2D = $LockedDoor/DestructionArea


var explosion_timer = 11.5
var tnt_ignited = false

@onready var tnt_music : AudioStreamPlayer2D = $Camera2D/TNTMusic

var blackout_timer = blackout_duration
var reset_performed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	_reset_level()
	var tnt_chest_lock_area : Area2D = tnt_chest.find_child("LockArea")
	if tnt_chest_lock_area != null:
		tnt_chest_lock_area.area_entered.connect(on_tnt_chest_lock_area_entered)
		
	player.tnt_picked_up.connect(on_tnt_picked_up)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if blackout_timer < blackout_duration:
		reset_performed = false
		blackout_timer += delta
		blackout_layer.visible = true
	elif !reset_performed:
		_reset_level()
		blackout_layer.visible = false
		reset_performed = true
		
	if tnt_ignited:
		explosion_timer -= delta
		explosion.global_position = tnt_item.global_position
		
	if explosion_timer < 0 && tnt_ignited:
		explode_tnt()
		tnt_ignited = false
	
	
func on_npc_reached_player():
	blackout_timer = 0.0
	player.position = $PlayerSpawnPosition.position
	$Camera2D/ActionMusic.stop()
	
func on_tnt_chest_lock_area_entered(area: Area2D):
	var parent = area.get_parent()
	if parent.name == "PlayerRat" && area.name == "ItemPickupArea" && player.has_key:
		tnt_chest.open()
		player.return_key()
		remove_child(key_item)
		
func on_tnt_picked_up():
	tnt_ignited = true
	tnt_music.play()
	$Camera2D/ActionMusic.stop()
	$Camera2D/BackgroundMusic.stop()
	
func explode_tnt():
	tnt_item.explode()
	explosion.trigger()
	if tnt_item.destruction_area.overlaps_body(player):
		blackout_timer = 0
	if tnt_item.destruction_area.overlaps_area(locked_door_collision_area):
		remove_child($LockedDoor)
		remove_child($DestructibleWall)
	
func _reset_level():
	player.position = $PlayerSpawnPosition.position
	player.return_key()
	player.rotation_degrees = 90
	npc.return_key()
	$Camera2D/BackgroundMusic.play()

	
