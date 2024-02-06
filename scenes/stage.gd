extends Node2D
signal left_curtain_in
signal left_curtain_out
signal right_curtain_in
signal right_curtain_out

signal sparklers_done

signal curtain_down
signal curtain_up

@onready var leftCurtain = get_node("SET/left-curtain")
@onready var rightCurtain = get_node("SET/right-curtain")

@onready var anim = get_node("AnimationPlayer")

func moveLeftCurtain():
	print("wobbleleft")
	leftCurtain.material.set_shader_parameter("flowing", true)
	
func stopLeftCurtain():
	print("stopwobbleleft")
	leftCurtain.material.set_shader_parameter("flowing", false)

func moveRightCurtain():
	rightCurtain.material.set_shader_parameter("flowing", true)
	
func stopRightCurtain():
	rightCurtain.material.set_shader_parameter("flowing", false)

func sparklers():
	anim.current_animation = "sparkle"

func _ready():
	sparklers()
	
func openCurtain():
	anim.current_animation = "open_curtain"

func closeCurtain():
	anim.current_animation = "close_curtain"

func _on_leftcollision_body_entered(body):
	emit_signal("left_curtain_in")
	
func _on_leftcollision_body_exited(body):
	emit_signal("left_curtain_out")
	leftCurtain.material.set_shader_parameter("flowing", false)


func _on_rightcollision_body_entered(body):
	emit_signal("right_curtain_in")


func _on_rightcollision_body_exited(body):
	emit_signal("right_curtain_out")
	rightCurtain.material.set_shader_parameter("flowing", false)


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "sparkle":
		emit_signal("sparklers_done")
	elif anim_name == "open_curtain":
		emit_signal("curtain_up")
	elif anim_name == "close_curtain":
		emit_signal("curtain_down")
