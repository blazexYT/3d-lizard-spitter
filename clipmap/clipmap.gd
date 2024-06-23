extends Node3D

@export var player:Node3D
# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	global_position = player.global_position * Vector3(1,0,1)
