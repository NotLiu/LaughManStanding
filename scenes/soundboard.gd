extends Node

@onready var title = get_node("TITLE")
@onready var typing = get_node("TYPING")
@onready var cheer = get_node("CHEER")

func playTitle():
	title.playing = true
	
func stopTitle():
	title.playing = false

func playType():
	typing.playing = true

func stopType():
	typing.playing = false

func transitionToTyping():
	$AnimationPlayer.current_animation = "FadeToTrack2"

func transitionToTitle():
	$AnimationPlayer.current_animation = "FadeToTrack1"

func playCheer():
	cheer.volume_db = -5 + randf_range(-5, 5)
	cheer.pitch_scale = 1.0 + randf_range(-0.15, 0.15)
	cheer.play()
