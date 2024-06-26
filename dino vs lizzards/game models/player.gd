extends CharacterBody3D
#evrything to do with portal!
var portal_id = 0 
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var mouseSensility = 300
var mouse_relative_x = 0
var mouse_relative_y = 0
var max_jumps = 100000000000000
var jump_count = 0 
# bullets 
var bullet = load("res://dino vs lizzards/game models/Bullet.tscn")
var instance

#onready
@onready var gun_anim = $head/Camera3D/Rifle/AnimationPlayer
@onready var gun_barrel = $head/Camera3D/Rifle/RayCast3D
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED 

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	if is_on_floor():
		jump_count = 0 

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and jump_count < max_jumps:
		velocity.y = JUMP_VELOCITY
		jump_count = jump_count + 1
		

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	# shooting 
	if Input.is_action_pressed("shoot"):
		if !gun_anim.is_playing():
			gun_anim.play("Shoot")
			instance = bullet.instantiate()
			instance.position = gun_barrel.global_position
			instance.transform.basis = gun_barrel.global_transform.basis
			get_parent().add_child(instance)

	move_and_slide()


func _input(event):
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x / mouseSensility
		$head/Camera3D.rotation.x -= event.relative.y/ mouseSensility
		$head/Camera3D.rotation.x = clamp($head/Camera3D.rotation.x , deg_to_rad(-90), deg_to_rad(90))
		mouse_relative_x = clamp(event.relative.x , -100, 100)
		mouse_relative_y = clamp(event.relative.y , -100, 100)


