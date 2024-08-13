@tool
extends MeshInstance3D

@export_range(20,400,1) var terrain_size := 100
@export_range(1,100,1) var resolution := 30 


const cener_offset := 0.5 
@export var terrain_max_height = 5
@export var xSize = 20
@export var zSize = 20 
@export var terrian_height = 5 
@export var noise_offset = 0.5
@export var update = false 
@export var clear_vert_vis = false
@export var create_collisions = false
@export var remove_collisions = false
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
	for z in resolution+1:
		for x in resolution+1:
			var percent = Vector2(x,z)/resolution
			var pointOnMesh = Vector3((percent.x-cener_offset),0,(percent.y-cener_offset))
			var vertex = pointOnMesh * terrain_size;
			vertex.y = n.get_noise_2d(vertex.x*noise_offset,vertex.z*noise_offset) * terrain_max_height
			var uv = Vector2()
			uv.x = percent.x
			uv.y = percent.y
			surfTool.set_uv(uv)
			surfTool.add_vertex(vertex)
	var vert = 0 
	for z in resolution:
		for x in resolution:
			surfTool.add_index(vert+0)
			surfTool.add_index(vert+1)
			surfTool.add_index(vert+resolution+1)
			surfTool.add_index(vert+resolution+1)
			surfTool.add_index(vert+1)
			surfTool.add_index(vert+resolution+2)
			vert+=1
		vert+=1
	surfTool.generate_normals()
	a_mesh = surfTool.commit()
			
	mesh = a_mesh
	update_shader()
			
func update_shader():
	var mat = get_active_material(0)
	#mat.set_shader_material("min_height", min_height)
	#mat.set_shader_material("max_height", max_height)
	
var last_res = 0
var last_size = 0
var last_height = 0 
var last_offset = 0 


func _process(delta):
	if resolution != last_res or terrain_size!=last_size or \
		terrain_max_height!=last_height or noise_offset!=last_offset:
		generate_terrain()
		last_res = resolution 
		last_size = terrain_size
		last_height = terrain_max_height
		last_offset = noise_offset
		
	if remove_collisions:
		clear_collisions()
		remove_collisions = false
	if create_collisions:
		create_trimesh_collision()
		create_collisions = false
func genrate_collisions():
	clear_collisions()
	create_trimesh_collision()

		
func clear_collisions():
	if get_child_count() > 0:
		for i in get_children():
			i.free

	
	
	
	
	#if update:
		#generate_terrain()
		#update = false
		#
	#if clear_vert_vis:
		#for i in get_children():
			#i.free()			
			#
			
			
			
#func Draw_sphere(pos:Vector3):
	#var ins = MeshInstance3D.new()
	#add_child(ins)
	#ins.position = pos 
	#var sphere = SphereMesh.new()
	#sphere.radius = 0.1
	#sphere.height = 0.2
	#ins.mesh = sphere
	#
	
# Called every frame. 'delta' is the elapsed time since the previous frame.

