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
var demoText = [
	"UH... TEST TEST. CAN YOU GUYS HEAR ME..", 
	"SPHINX OF BLACK QUARTZ, JUDGE MY VOW",
	"HEY.. I DON'T KNOW IF I CAN DO THIS",
	"WHY DON'T VIDEO GAME CHARACTERS GET SLEEPY. BECAUSE THEY HAVE ENDLESS 'ENERGY BARS'.",
	"TWO MEMBERS OF THE 1984 CLASS OF JEFFERSON HIGH SCHOOL ARE CHAIRING A GROUP OF 18 TO LOOK FOR A RESORT FOR THE 20YEAR CLASS REUNION. A LOVELY PLACE 78 MILES FROM THE CITY TURNS OUT TO BE THE BEST. IT HAS 254 ROOMS AND A BANQUET HALL TO SEAT 378.",
	"IT HAS BEEN OPEN 365 DAYS PER YEAR SINCE OPENING ON MAY 30, 1926. THEY WILL NEED 450 TO RESERVE THE RESORT. DEBBIE HOLMES WAS PUT IN CHARGE OF BUYING 2,847 OFFICE MACHINES FOR THE ENTIRE FIRM.", 
	"DEBBIE VISITED MORE THAN 109 COMPANIES IN 35 STATES IN 6 MONTHS. SHE WILL REPORT TO THE BOARD TODAY IN ROOM 2784 AT 5 P.M. THE BOARD WILL CONSIDER HER REPORT ABOUT THOSE 109 FIRMS AND RECOMMEND THE TOP 2 OR 3 BRANDS TO PURCHASE. DEBBIE MUST DECIDE BEFORE AUGUST 16.",
	"LYNN GREENE SAID WORK STARTED ON THE PROJECT MARCH 27, 2003. THE 246 BLUEPRINTS WERE MAILED TO THE OFFICE 18 DAYS AGO. THE PRINTS HAD TO BE 100 PERCENT ACCURATE BEFORE THEY WERE ACCEPTABLE. THE PROJECT SHOULD BE FINISHED BY MAY 31, 2025. AT THAT TIME THERE WILL BE 47 NEW CONDOMINIUMS, EACH HAVING AT LEAST 16 ROOMS. THE BUILDING WILL BE 25 STORIES.",
	"UHH.. OKAY MOVING ON. HOW ABOUT THIS ONE.. LETS SEE... OH IVE GOT IT",
	"ONCE IN A LAND OF EVERYDAY LIFE, THERE WAS A GUY NAMED BOB. BOB WASN'T YOUR AVERAGE JOE. HE HAD A PECULIAR PASSION FOR COLLECTING SPOONS. HIS FRIENDS OFTEN JOKED THAT BOB HAD MORE SPOONS THAN A CUTLERY SHOP.",
	"ONE DAY, BOB DECIDED TO DISPLAY HIS SPOONS IN WHAT HE CALLED THE 'SPECTACULAR SPOON SPEED' HE INVITED EVERYONE, EXPECTING THEME TO BE AMAZED. BUT WHEN THEY ARRIVED, THEY JUST SAW SPOONS... EVERYWHERE. ON THE WALLS, HANGING FROM THE CEILING, EVEN REPLACING THE TV REMOTE. BOB PROUDLY PRESENTED HIS 'INTERACTIVE SPOON EXHIBIT' WHERE YOU COULD... WELL, JUST LOOK AT SPOONS.",
	"THANKS FOR PLAYING YALL, WAS A FUN GGJ2024... I DON'T REALLY KNOW WHAT TO TYPE NOW."
	]
	
var cueGood = ["CHEER NOW", "WOW NOW", "WOO", "GREAT JOB", "APPLAUSE", "HA... YES!", "TEXT HERE"] 
var cueBad = ["WHO THIS?", "cue card..", "UHH...", "BOOoo", "...", "TYPE BETTER", "CRY"]

var curtainDown = false

#LAUGH MAN TEXT
var laughManTalking = [
	["YOU TOLD ME YOU WANTED TO MAKE PEOPLE LAUGH RIGHT?", "THAT WAS THE DEAL RIGHT?", "DON'T LET THOSE FEET GET TOO COLD.", "YOU WON'T BE MUCH OF A STAND-UP IF YOU CAN'T STAND UP!", "LISTEN TO THAT CROWD. I'VE GOT YOU A FULL HOUSE OUT THERE.", "THE LEAST YOU COULD DO IS PREFORM FOR ME.
 ", "DON'T WORRY ABOUT IT! YOU'LL KNOCK EM DEAD!...", "OR VICE-VERSA.."], 
	["LISTEN TO THAT APPLAUSE!", "MUST BE GLAD IT'S OVER!"],
	["CLAPPING?", "HMPH, I WAS BETTING ON CRICKETS"],
	["SOUNDS LIKE YOUR JOKES LANDED!","CRASH-LANDED…"],
	["THEY LOVE YOU!", "AREN'T YOU GLAD I GOT YOU AN AUDIENCE OF MORONS?"],
	["AN APPLAUSE!","YOU MUST BE JOKING."],
	["OH PLEASE, I'VE HEARD THAT ONE BEFORE."],
	["I TAUGHT YOU THAT ONE!", "YOU COULD CREDIT ME NEXT TIME."],
	["ZZZZZ…","OH YOU'RE FINISHED?"]
	]

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
		
		
		if global.game_state == "TYPE_REVIEW":
			laughmantext.talk()
			global.game_state = "DODGING"
		elif global.game_state == "DODGE_REVIEW":
			laughmantext.talk()
			if global.level > len(demoText):
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
	global.game_state = "TALKING"
	#global.game_state = "COUNTDOWN"
	$UI/Title.queue_free()
	stage.closeCurtain()
	player.shock(-100)
	


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
	scoreboard.setWPMText("%.2f"%max(0.0, wpm)+" wpm") #exception, has WPM already defined
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
		
		thrownObject.numObjects = 10 + global.level * 5
		
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
		
		#FINISH DODGING GO NEXT LVL
		global.level += 1
		
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
			
		if global.level - 1 < len(laughManTalking):
			laughmantext.setTextCycle(laughManTalking[global.level - 1])
		else:
			laughmantext.setTextCycle(["HAHAHAHA", "HAHA..."])
		cue.cueUp()
		


func _on_laughmantext_laughman_finished_talking():
	if curtainDown:
		#start game from intro
		stage.openCurtain()
	else:
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


func _on_stage_curtain_down():
	# CURTAIN DOWN
	curtainDown = true
	player.playIntro()
	


func _on_stage_curtain_up():
	#START GAME FROM INTRO
	print("CURTAIN UP")
	curtainDown = false
	player.shock(-sign(player.position.x - 640) * 9500)
	global.game_state = "COUNTDOWN"


func _on_player_player_in_place():
	#ONCE PLAYER IN PLACE START LAUGHMAN TEXT
	if global.level - 1 < len(laughManTalking):
		laughmantext.setTextCycle(laughManTalking[global.level - 1])
	else:
		laughmantext.setTextCycle(["HAHAHAHA", "HAHA..."])
	laughmantext.talk()
