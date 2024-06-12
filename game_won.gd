extends Control


@onready var MOUSE_MODE_VISIBLE = 0
#@onready var pause_menu = $pausemenu
var paused = false 

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_well_done_scene_pressed():
	get_tree().change_scene_to_file("res://dino vs lizzards/game models/menu.tscn")


func _on_won_menu_pressed():
	get_tree().change_scene_to_file("res://dino vs lizzards/game models/menu.tscn")
