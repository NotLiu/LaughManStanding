extends Node2D
signal left_curtain_in
signal left_curtain_out
signal right_curtain_in
signal right_curtain_out

@onready var leftCurtain = get_node("SET/left-curtain")
@onready var rightCurtain = get_node("SET/right-curtain")

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