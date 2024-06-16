extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		get_tree().change_scene_to_file("res://dino vs lizzards/game models/pausemenu.tscn")
	if Input.is_action_just_pressed("respawn"):
		get_tree().reload_current_scene()
