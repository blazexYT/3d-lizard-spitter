extends Area3D

const SPEED = 40.0 
var dam = 1

#onready
@onready var mesh = $MeshInstance3D
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
		print(ray.get_collider())
		mesh.visible = false
		particles.emitting = true
		ray.enabled = false
		if ray.get_collider().is_in_group("enimess"):
			print(ray.get_collider())
			ray.get_collider().hit()
		await  get_tree().create_timer(1.0).timeout
		queue_free()
						
func _on_timer_timeout():
	queue_free()
