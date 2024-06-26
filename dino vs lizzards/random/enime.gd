extends CharacterBody3D

var SPEED = 10
var health = 6
#var bullet = $Bullet

	
	
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
			queue_free()

	
#func _on_area_3d_body_entered(body):
	#print(name)
	#if body.name == "player":
		#get_tree().change_scene_to_file("res://game_won.tscn")

#func _on_area_3d_area_entered(area):
	#if area.name == bullet:
	#queue_free(bullet)
