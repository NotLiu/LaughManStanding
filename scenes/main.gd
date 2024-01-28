extends Node2D

@onready var cam = get_node("Camera2DPlus")
@onready var player = get_node("Player")
@onready var stage = get_node("Stage")

@onready var soundboard = get_node("/root/Soundboard")
@onready var global = get_node("/root/Global")

# UI
@onready var type_countdown = get_node("UI/Countdown")
@onready var type_keyboard = get_node("UI/Keyboard")
@onready var scoreboard = get_node("UI/SCOREBOARD")
@onready var audience = get_node("audienceMembers")
@onready var laughmantext = get_node("UI/LAUGHMANTEXT")

@onready var cue = get_node("Cue")
@onready var thrownObject = get_node("ThrownObject")

# variables for curtain wobbling
var inLeft = false
var inRight = false
var leftWobbling = false
var rightWobbling = false
var EULERS_NUMBER = 2.71828

# game vars
var demoText = ["THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG", "SPHINX OF BLACK QUARTZ, JUDGE MY VOW"]
var cueGood = ["CHEER NOW", "WOW NOW", "WOO", "GREAT JOB", "APPLAUSE", "HA... YES!", "TEXT HERE"] 
var cueBad = ["WHO THIS?", "cue card..", "UHH...", "BOOoo", "...", "TYPE BETTER", "CRY"]

#LAUGH MAN TEXT
var laughManTalking = [["HEE HEE"], ["HEE HEE HEE"]]

# current round info
var roundPoints = 0
var maxRoundPoints = 0
var typingTextLen = 0

func _input(event):
	if event is InputEventKey and event.is_pressed() and (global.game_state == "TYPE_REVIEW" or global.game_state == "DODGE_REVIEW"):
		# PRESS TO CONTINUE OFF SCOREBOARD
		cue.cueDown()
		audience.audienceStop()
		scoreboard.visible = false
		laughmantext.talk()
		
		if global.game_state == "TYPE_REVIEW":
			global.game_state = "DODGING"
		elif global.game_state == "DODGE_REVIEW":
			global.level += 1
			if global.level > len(laughManTalking):
				get_tree().change_scene_to_file("res://scenes/end.tscn")
			global.game_state = "TALKING"

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
		
	#print(global.game_state)
	if global.game_state == "COUNTDOWN" and $UI/Countdown/Timer.is_stopped():
		soundboard.transitionToTyping()
		type_countdown.startTimer()
		

func _on_title_intro_done():
	#screen shake on intro slam
	cam.shake_strength = 5.0
	player.shock(-500)
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


func _on_title_start_game():
	global.level = 1
	#global.game_state = "TALKING"
	global.game_state = "COUNTDOWN"
	$UI/Title.queue_free()


func _on_countdown_start_type():
	#START TYPING
	type_keyboard.setNewText(demoText[global.level - 1])
	typingTextLen = len(demoText[global.level - 1])

func _on_keyboard_finish_typing():
	# GET TYPING STATS
	var accuracy = type_keyboard.checkAccuracy()
	var wpm = type_keyboard.wpm
	
	# CALCULATE ROUND SCORE - BONUS POINTS ON WPM > 90
	var speed_scale = pow(EULERS_NUMBER, (max(0, wpm - 90.0) / 120.0))
	roundPoints =  snapped(10.0 * typingTextLen * pow(accuracy + 0.25, 4) * speed_scale, 25)
	maxRoundPoints = snapped(10.0 * typingTextLen * (1.00) * pow(EULERS_NUMBER, 30.0 / 120.0), 25)
	
	print("speed_scale=", speed_scale)
	print("POINTS:", roundPoints)
	print("MAX POINTS:", maxRoundPoints)
	# SET DISPLAY VALUES
	scoreboard.setRoundText("ROUND: "+str(global.level))
	scoreboard.setScoreText(str(roundPoints)+" pts")
	scoreboard.setWPMSection("WORDS PER MINUTE:")
	scoreboard.setWPMText("%.2f"%wpm+" wpm") #exception, has WPM already defined
	scoreboard.setAccuracyText("%.2f"%(accuracy*100.0)+" (%)")
	scoreboard.setTimeSection("TIME:")
	scoreboard.setTimeText("%.2f"%type_keyboard.timeTaken+" secs")
	
	# SPARKLERS FOR COMPLETING TEXT BEFORE TRANSITION TO REVIEW STAGE
	stage.sparklers()

func _on_stage_sparklers_done():
	if global.game_state == "TYPING":
		player.emote()
		scoreboard.visible = true
		# RESET VARS
		typingTextLen = 0
		global.game_state = "TYPE_REVIEW"
		type_keyboard.visible = false
		
		global.points += roundPoints
		
		thrownObject.numObjects = 25 + global.level * 5
		
		if roundPoints > 0.5 * maxRoundPoints:
			soundboard.playCheer()
			audience.audienceCheer()
			cam.shake_strength = 5.0
			cue.setCueText(cueGood[randi()%len(cueGood)])
			
			var dodge_dialogue = [["THEY'RE CRACKING UP!", "CATCH THEIR GIFTS!"], ["THEY LOVED IT!", "GET READY!"], ["HAHAHAHA", "AHH..", "I CRACK MYSELF UP", "HERE THEY COME", "CATCH 'EM ALL!"]]
			
			laughmantext.setTextCycle(dodge_dialogue[randi()%len(dodge_dialogue)])
			thrownObject.objectType = "GOOD"
			type_countdown.type = "CATCH"
		else:
			var dodge_dialogue = [["WOW THAT SUCKED!", "BETTER DODGE"], ["WOW SURPRISINGLY BAD!", "WELL, GET READY.."], ["...", "wow.","DODGE.. OR DON'T."]]
			
			laughmantext.setTextCycle(dodge_dialogue[randi()%len(dodge_dialogue)])
			thrownObject.objectType = "BAD"
			type_countdown.type = "DODGE"
			
			cue.setCueText(cueBad[randi()%len(cueBad)])
			
		cue.cueUp()
	elif global.game_state == "DODGING":
		player.emote()
		scoreboard.visible = true
		player.caught_objects = 0
		global.game_state = "DODGE_REVIEW"
		thrownObject.visible = false
		
		if thrownObject.objectType == "GOOD":
			soundboard.playCheer()
			audience.audienceCheer()
			cam.shake_strength = 5.0
			cue.setCueText(cueGood[randi()%len(cueGood)])
		elif thrownObject.objectType == "BAD":
			cue.setCueText(cueBad[randi()%len(cueBad)])
			
		laughmantext.setTextCycle(laughManTalking[global.level - 1])
		cue.cueUp()
		


func _on_laughmantext_laughman_finished_talking():
	#START DODGE COUNTDOWN
	soundboard.transitionToTitle()
	type_countdown.startTimer()


func _on_countdown_start_dodge():
	# DODGE COUNTDOWN DONE, START SHOOTING
	player.shock(sign(player.position.x - 640) * 500.0)
	cam.shake_strength = 5.0
	print("DODGE")
	
	thrownObject.startRound(10.0 + ceil(typingTextLen / 10) * 5.0)


func _on_thrown_object_done_throwing():
	#get DODGE REVIEW STATS
	if thrownObject.objectType == "GOOD":
		var acc = float(player.caught_objects) / float(thrownObject.numObjects)
		
		scoreboard.setScoreText(str(player.caught_objects * 50) + " pts")
		scoreboard.setWPMSection("CAUGHT:")
		scoreboard.setWPMText(str(player.caught_objects))
		scoreboard.setTimeSection("MISSED:")
		scoreboard.setTimeText(str(thrownObject.numObjects - player.caught_objects))
		scoreboard.setAccuracyText("%.2f"%(acc*100.0)+" (%)")
		
	elif thrownObject.objectType == "BAD":
		var acc = float(thrownObject.numObjects - player.caught_objects) / float(thrownObject.numObjects)
		
		global.points += ((thrownObject.numObjects - player.caught_objects) * 5) + player.caught_objects * -50
		scoreboard.setScoreText(str(((thrownObject.numObjects - player.caught_objects) * 5) + player.caught_objects * -50) + " pts")
		scoreboard.setWPMSection("HIT BY:")
		scoreboard.setWPMText(str(player.caught_objects))
		scoreboard.setTimeSection("DODGED:")
		scoreboard.setTimeText(str(thrownObject.numObjects - player.caught_objects))
		scoreboard.setAccuracyText("%.2f"%(acc*100.0)+" (%)")
		
	
	stage.sparklers()
