extends Node2D

@onready var cam = get_node("Camera2DPlus")
@onready var player = get_node("Player")
@onready var stage = get_node("Stage")

@onready var soundboard = get_node("/root/Soundboard")
@onready var global = get_node("/root/Global")

# variables for curtain wobbling
var inLeft = false
var inRight = false
var leftWobbling = false
var rightWobbling = false

# game vars


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# curtain wobbling section
	if inLeft and ((abs(player.velocity.x) > 0.0) or (abs(player.velocity.y) > 0.0)) and leftWobbling == false:
		# wobble curtain if on curtain and player moving
		print(player.velocity)
		leftWobbling = true
		stage.moveLeftCurtain()
	elif inLeft and abs(player.velocity.x) == 0.0 and abs(player.velocity.y) == 0.0 and leftWobbling == true:
		leftWobbling = false
		stage.stopLeftCurtain()
		
	if inRight and ((abs(player.velocity.x) > 0.0) or (abs(player.velocity.y) > 0.0)) and rightWobbling == false:
		# wobble curtain if on curtain and player moving
		rightWobbling = true
		stage.moveRightCurtain()
	elif inRight and abs(player.velocity.x) == 0.0 and abs(player.velocity.y) == 0.0 and rightWobbling == true:
		rightWobbling = false
		stage.stopRightCurtain()


func _on_title_intro_done():
	#screen shake on intro slam
	cam.shake_strength = 5.0
	player.shock()
	$Stage/SET/Mic.linear_velocity.y = -200
	$Stage/SET/Mic.angular_velocity = .25

func _on_stage_left_curtain_in():
	inLeft = true

func _on_stage_left_curtain_out():
	inLeft = false


func _on_stage_right_curtain_in():
	inRight = true


func _on_stage_right_curtain_out():
	inRight = false
