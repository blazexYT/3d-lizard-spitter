extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_area_3d_body_entered(body):
	print(name)
	if body.name == "player":
		print("yah")
		get_tree().change_scene_to_file("res://dino vs lizzards/random/game_won.tscn")


func _on_area_3d_area_entered(area: Area3D) -> void:
	print(name)
