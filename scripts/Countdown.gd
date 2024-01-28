extends Control
signal startType
signal startDodge

@onready var timer = get_node("Timer")
@onready var global = get_node("/root/Global")
@onready var anim = get_node("AnimationPlayer")

var type = "DODGE"
var totalCountdown = 0
#func _ready():
	#startTimer()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if totalCountdown == 3 and timer.is_stopped() == false:
		if global.game_state == "DODGING":
			$CenterContainer/RichTextLabel.text = "[center]"+type+"![/center]"
		else:
			$CenterContainer/RichTextLabel.text = "[center]TYPE![/center]"
	else:
		$CenterContainer/RichTextLabel.text = "[center]" + str(3-totalCountdown) +"[/center]"

func _on_timer_timeout():
	if totalCountdown < 3:
		anim.current_animation = "talk"
		$timerSound.pitch_scale = 0.6
		$timerSound.play()
		totalCountdown += 1
	else:
		visible = false
		$timerSound.pitch_scale = 0.8
		$timerSound.play()
		if global.game_state == "DODGING":
			timer.stop()
			emit_signal("startDodge")
			totalCountdown = 0
		else:
			timer.stop()
			global.game_state = "TYPING"
			emit_signal("startType")
			totalCountdown = 0
#
func startTimer():
	visible = true
	timer.start(1.0)
