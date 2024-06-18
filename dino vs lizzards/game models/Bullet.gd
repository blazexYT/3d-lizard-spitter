extends Node3D

const SPEED = 40.0 


#onready
@onready var mesh = $Area3D/MeshInstance3D
@onready var ray = $RayCast3D
@onready var particles = $GPUParticles3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#bullet movement
	position += transform.basis * Vector3(0, 0, -SPEED) * delta
	if ray.is_colliding():
		mesh.visible = false
		particles.emitting = true
		await  get_tree().create_timer(1.0).timeout
		queue_free()
						
func _on_timer_timeout():
	queue_free()



func _on_area_3d_body_entered(body):
	print(name)
