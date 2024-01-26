extends Control
signal introDone

@onready var anim = get_node("AnimationPlayer")
# Called when the node enters the scene tree for the first time.
func _ready():
	anim.current_animation = "intro"
	
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "intro":
		#anim.current_animation = "laugh"
		emit_signal("introDone")


func _on_logo_pressed():
	if anim.current_animation == "":
		anim.current_animation = "laugh"
