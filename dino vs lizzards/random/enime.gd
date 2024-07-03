extends CharacterBody3D
@onready var explosion = $explosion
var SPEED = 10
var health = 6
var player =  null
@onready var particles = $MeshInstance3D2
@onready var mesh = $MeshInstance3D
#var bullet = $Bullet

func _ready(): 
	explosion.visible = false 
	
	
	
	
	
func _physics_process(_delta):
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED 
	
	nav_agent.set_velocity(new_velocity)
	
	
@onready var nav_agent = $NavigationAgent3D

func update_target_location(target_location):
	nav_agent.target_position = target_location
	


func _on_navigation_agent_3d_target_reached():
	pass


func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	velocity = velocity.move_toward(safe_velocity, .25)
	move_and_slide()


func _on_child_entered_tree(_node):
	pass
	
func _apply_damage(damage: float) -> void:
	health -= damage
	 	
func _on_area_3d_body_part_hit(dam):
	health -= dam
	print("health "+ health)
	if health <= 0:
		mesh.visible = false 
		particles.emmiting = true 
		await get_tree().create_timer(1.0).timeout
		queue_free()
	
func hit():
	health -= 1
	if health <= 0:
		queue_free()

func _on_area_3d_area_entered(area):
	print(area)
	if area.name.contains("Bullet"):
		health -= area.dam
		print("health "+ health)
		if health <= 0:
			explosion = true 
			if $SubViewport/healthbar3d.value < health:
				health = $SubViewport/healthbar3d.value
			$SubViewport/healthbar3d.value -= health
			queue_free()

	
#func _on_area_3d_body_entered(body):
	#print(name)
	#if body.name == "player":
		#get_tree().change_scene_to_file("res://game_won.tscn")

#func _on_area_3d_area_entered(area):
	#if area.name == bullet:
	#queue_free(bullet)
func take_damage(damage):
	if $SubViewport/healthbar3d.value < damage:
		damage = $SubViewport/healthbar3d.value
	$SubViewport/healthbar3d.value -= damage

func _on_timer_timeout():
	take_damage(5)
