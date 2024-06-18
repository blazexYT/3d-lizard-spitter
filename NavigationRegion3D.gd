extends NavigationRegion3D

@onready var player = $player

func _physics_process(_delta):
	get_tree().call_group("enime", "update_target_location", player.global_transform.origin)

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		get_tree().change_scene_to_file("res://dino vs lizzards/game models/pausemenu.tscn")
	if Input.is_action_just_pressed("respawn"):
		get_tree().reload_current_scene()
