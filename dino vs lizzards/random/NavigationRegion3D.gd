extends NavigationRegion3D

@onready var player = $player
@onready var pausemenu = $pausemenu
var paused = false 
func _physics_process(_delta):
	get_tree().call_group("enime", "update_target_location", player.global_transform.origin)

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		pauseMenu()
		
		
func pauseMenu():
	if paused:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		pausemenu.hide()
		Engine.time_scale = 1 
	else:
		pausemenu.show()
		Engine.time_scale = 0 
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	paused = !paused
