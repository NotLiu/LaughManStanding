extends Control
signal introDone
signal startGame

@onready var anim = get_node("AnimationPlayer")
@onready var laugh = get_node("LaughAudio")

# Called when the node enters the scene tree for the first time.
#func _input(event):
	#print("Input event received in Control node")
	#print(event)

func _ready():
	anim.current_animation = "intro"
	
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "intro":
		#anim.current_animation = "laugh"
		emit_signal("introDone")


func _on_logo_pressed():
	if anim.current_animation == "":
		laugh.pitch_scale = 1.0 + randf_range(-0.2, 0.2)
		print(laugh.pitch_scale)
		anim.current_animation = "laugh"


func _on_start_pressed():
	emit_signal("startGame")
