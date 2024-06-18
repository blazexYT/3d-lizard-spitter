extends Control
@onready var MOUSE_MODE_VISIBLE = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	$"VBoxContainer/levels button".grab_focus()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):

	pass
		


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://dino vs lizzards/game models/FirstLevel.tscn")


func _on_quit_button_pressed():
	get_tree().quit()


func _on_levels_button_pressed():
	get_tree().change_scene_to_file("res://levelsmenu.tscn")
