extends Button

@onready var buttoon = $"."
# Called when the node enters the scene tree for the first time.
func _ready():
	buttoon.visible = false 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_timer_timeout():
	buttoon.visible = true  
