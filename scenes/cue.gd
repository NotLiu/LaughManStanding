extends Node2D

@onready var card = get_node("Cue/Card")
@onready var cueText = get_node("Cue/Card/TEXT")
@onready var anim = get_node("Cue/AnimationPlayer")

func setCueText(text):
	cueText.text = "[center]"+text+"[/center]"

func cueUp():
	anim.current_animation = "flip_up"
	
func cueDown():
	anim.current_animation = "flip_down"
