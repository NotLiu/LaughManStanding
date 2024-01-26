extends Node2D

@onready var cam = get_node("Camera2DPlus")
@onready var player = get_node("Player")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_title_intro_done():
	#screen shake on intro slam
	cam.shake_strength = 5.0
	player.shock()
