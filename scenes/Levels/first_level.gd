extends Node2D

@onready var door = $LockedDoor
@onready var player: CharacterBody2D = $PlayerRat 
@onready var key

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.position = $PlayerSpawnPosition.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_keyhole_area_entered(area: Area2D) -> void:
	$LockedDoor/DestructionArea/CollisionShape2D.scale = Vector2(0, 0)
	$LockedDoor/DoorClosed.visible = false
	$LockedDoor/DoorOpened.visible = true
	remove_child($DestructibleWall)
	player.return_key()
	remove_child($Key_Item)


func _on_trapdoor_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://scenes/Levels/second_level.tscn")
