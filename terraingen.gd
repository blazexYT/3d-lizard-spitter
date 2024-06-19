@tool
extends MeshInstance3D

@export var xSize = 20
@export var zSize = 20 
@export var terrian_height = 5 
@export var noise_offset = 0.5
@export var update = false 
@export var clear_vert_vis = false

var min_height = 0
var max_height = 1 
# Called when the node enters the scene tree for the first time.
func _ready():
	generate_terrain()

func generate_terrain():
	var a_mesh:ArrayMesh
	var surfTool = SurfaceTool.new()
	var n = FastNoiseLite.new()
	n.noise_type = FastNoiseLite.TYPE_PERLIN
	n.frequency = 0.1 
	surfTool.begin(Mesh.PRIMITIVE_TRIANGLES)
	for z in range(zSize+1):
		for x in range(xSize+1):
			var y = n.get_noise_2d(x*0.5,z*0.5) * 5
			
			if y < min_height and y != null:
				min_height = y 
			if y < min_height and y != null:
				min_height = y 
			var uv = Vector2()
			uv.x = inverse_lerp(0,xSize,x)
			uv.y = inverse_lerp(0,zSize,z)
			surfTool.set_uv(uv)
			surfTool.add_vertex(Vector3(x,y,z))
			Draw_sphere(Vector3(x,y,z))
	
	var vert = 0 
	for z in zSize:
		for x in xSize:
			surfTool.add_index(vert+0)
			surfTool.add_index(vert+1)
			surfTool.add_index(vert+xSize+1)
			surfTool.add_index(vert+xSize+1)
			surfTool.add_index(vert+1)
			surfTool.add_index(vert+xSize+2)
			vert+=1
		vert+=1
	surfTool.generate_normals()
	a_mesh = surfTool.commit()
			
	mesh = a_mesh
	update_shader()
			
func update_shader():
	var mat = get_active_material(0)
	mat.set_shader_material("min_height", min_height)
	mat.set_shader_material("max_height", max_height)
			
			
func Draw_sphere(pos:Vector3):
	var ins = MeshInstance3D.new()
	add_child(ins)
	ins.position = pos 
	var sphere = SphereMesh.new()
	sphere.radius = 0.1
	sphere.height = 0.2
	ins.mesh = sphere
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if update:
		generate_terrain()
		update = false
		
	if clear_vert_vis:
		for i in get_children():
			i.free()
