extends Node2D

@export var blackout_duration : float = 3.0

@onready var player : PlayerRat = $PlayerRat
@onready var blackout_layer : ColorRect = $Camera2D/CanvasLayer2/Blackout
@onready var npc : CharacterBody2D = $NPC
@onready var tnt_chest : TNT_Chest = $TNT_Chest
@onready var key_item = $Key_Item

var blackout_timer = blackout_duration
var reset_performed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	_reset_level()
	var tnt_chest_lock_area : Area2D = tnt_chest.find_child("LockArea")
	if tnt_chest_lock_area != null:
		print("connected")
		tnt_chest_lock_area.area_entered.connect(on_tnt_chest_lock_area_entered)
	

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
	
func _reset_level():
	player.position = $PlayerSpawnPosition.position
	player.return_key()
	npc.return_key()
	$Camera2D/BackgroundMusic.play()

	
