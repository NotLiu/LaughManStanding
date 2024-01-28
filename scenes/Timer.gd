extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
@onready var particle = get_node("GPUParticles2D")
@onready var particle2 = get_node("GPUParticles2D2")
@onready var fill = get_node("CenterContainer/fill")
@onready var fillSize = fill.custom_minimum_size.x

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setFill(percent):
	fill.custom_minimum_size.x = max(0.0, fillSize * percent)
	fill.modulate = Color(((255.0 - 197.0) * percent + 197.0)/255.0, ((255.0 - 53.0) * percent + 53.0)/255.0, ((255.0 - 56.0) * percent + 56.0)/255.0)
	particle.modulate = Color(((255.0 - 197.0) * percent + 197.0)/255.0, ((255.0 - 53.0) * percent + 53.0)/255.0, ((255.0 - 56.0) * percent + 56.0)/255.0)
	particle2.modulate = Color(((255.0 - 197.0) * percent + 197.0)/255.0, ((255.0 - 53.0) * percent + 53.0)/255.0, ((255.0 - 56.0) * percent + 56.0)/255.0)
	
	if percent > 0.0:
		particle.emitting = true
		particle.position = Vector2(1280/2.0 + fill.custom_minimum_size.x / 2.0 - 2.0, 100.0)
		particle2.emitting = true
		particle2.position = Vector2(1280/2.0 - fill.custom_minimum_size.x / 2.0 + 2.0, 100.0)
	else:
		particle.emitting = false
		particle2.emitting = false
