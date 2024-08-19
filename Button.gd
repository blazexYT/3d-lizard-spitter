extends Button

@onready var Buttoon = $"."
# Called when the node enters the scene tree for the first time.
func _ready():
	Buttoon.visible = false 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_timer_timeout():
	Buttoon.visible = true 
