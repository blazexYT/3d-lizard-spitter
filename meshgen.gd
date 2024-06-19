@tool
extends MeshInstance3D

@export var update = false

func _ready():
	_gen_mesh()

func _gen_mesh():
	



func _process(delta):
	if update:
		_gen_mesh()
		update = false
