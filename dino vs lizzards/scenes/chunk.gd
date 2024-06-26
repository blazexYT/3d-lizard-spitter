class_name TerrainChunk
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
@export var remove_collisions = false
var min_height = 0
var max_height = 1 	

@export var terrian_max_height = 5
var chunks_lods = [5,20,50,80]
var position_cord = Vector2()
const Center_OffSet = 0.5

var set_collision = false

func generate_terrain(_noise:FastNoiseLite,coords:Vector2,size:float,initally_visible,bool):
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
			vertex.y = n.get_noise_2d(position.x*noise_offset,position.z*noise_offset) * terrain_max_height
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
	
	if set_collision == true:
		create_collisions()
		
	setchunkisvisible(initally_visible)


func update_chunk(view_pos:Vector2,max_view_dis):
	var viewer_distance = position_cord.distance_to(view_pos)
	var _is_visible = viewer_distance <= max_view_dis
	setchunkisvisible(_is_visible)
	
func update_lod(view_pos:Vector2):
	var viewer_distance = position_cord.distance_to(view_pos)
	var update_terrain = false
	var new_lod = 0
	if viewer_distance > 1000:
		new_lod = chunks_lods[0]
	if viewer_distance <= 1000:
		new_lod = chunks_lods[1]
	if viewer_distance < 900:
		new_lod = chunks_lods[2]
	if viewer_distance < 500:
		new_lod = chunks_lods[3]
		set_collision = true
		
	if resolution != new_lod:
		resolution = new_lod
		update_terrain = true
	return update_terrain
	
	
	
func setchunkisvisible(_is_visible):
	visible = _is_visible


func create_collisions():
	if get_child_count() > 0:
		for i in get_children():
			i.free
	create_trimesh_collision() 

