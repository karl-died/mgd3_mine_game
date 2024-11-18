extends Node2D


@export var flash_intensity : float = 1.0
@export_range(0.01, 0.99) var flash_decay : float = 0.2
@export var shockwave_intensity : float = 0.7
@export_range(0.001, 10.0) var shockwave_speed_scale = 1.0
@export_range(0.01, 0.99) var shockwave_decay = 0.1

@onready var particles = $GPUParticles2D
@onready var flash_light = $PointLight2D

var current_flash_intensity = 0.0
var max_flash_intensity = 10.0

var current_shockwave_radius = 0.0
var current_shockwave_intensity = 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	current_flash_intensity = lerp(current_flash_intensity, 0.0, flash_decay)
	flash_light.energy = current_flash_intensity * flash_intensity
	if current_shockwave_radius < 2.0:
		current_shockwave_radius += delta * shockwave_speed_scale
	current_shockwave_intensity = lerp(current_shockwave_intensity, 0.0, shockwave_decay)
	$ShockwaveShader.material.set("shader_parameter/size", current_shockwave_radius)
	$ShockwaveShader.material.set("shader_parameter/force", shockwave_intensity)

func trigger():
	particles.emitting = true
	current_shockwave_intensity = shockwave_intensity
	current_shockwave_radius = 0.0
	current_flash_intensity = max_flash_intensity
