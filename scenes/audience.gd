extends Node2D

@onready var hands = get_node("hands")
@onready var anim = get_node("AnimationPlayer")

func cheer():
	anim.speed_scale = randf_range(0.9, 1.1)
	anim.current_animation = "cheer"

func stopCheer():
	anim.current_animation = "idle"
