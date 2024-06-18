extends CharacterBody3D

var SPEED = 3.0
var accel = 10.0 
var Global
@onready var nav: NavigationAgent3D = $NavigationAgent3D

func _physics_process(delta):
	
	var direction = Vector3(0, 0 ,0)
	
	nav.target_position = Global.target.global_position
	
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	
	velocity = velocity.lerp(direction * SPEED , accel * delta)
	
	move_and_slide()
