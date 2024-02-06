extends Control
signal laughman_finished_talking

@onready var text = get_node("CenterContainer/RichTextLabel")
@onready var timer = get_node("textTimer")
@onready var anim = get_node("AnimationPlayer")
@onready var sound = get_node("laughmanSound")

var index = 0
var textList = []

func setTextCycle(text):
	# set text to cycle through
	textList = text
	
func talk():
	visible = true
	timer.start()
	nextText()
	
func nextText():
	if index < len(textList):
		print(textList[index])
		anim.current_animation = "talk"
		sound.pitch_scale = .85 + randf_range(-0.2, 0.2)
		sound.play()
		text.text = "[center]"+textList[index]+"[/center]"
		index += 1



func _on_text_timer_timeout():
	if index < len(textList):
		nextText()
	else:
		# DONE TALKING
		timer.stop()
		visible = false
		index = 0
		
		emit_signal("laughman_finished_talking")
	
