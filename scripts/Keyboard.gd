extends Control
signal finishTyping


@onready var layoutText = get_node("layoutText")
@onready var displayText = get_node("typedText")

var typing = false

var clackVars = []
@onready var keyClack = get_tree().get_nodes_in_group("clack")
@onready var keyWrong = get_node("keyWrong")
@onready var keyBack = get_node("keyBack")

@onready var typingTimer = get_node("TypeTimer")
var timeOut = false
var startTime = 0.0
var timeTaken = 0.0
var wpm = 0.0

@onready var timerVisual = get_node("Timer")

var special_keys = {
	"Space": " ",
	"Comma": ",",
	"Period": ".",
	"Slash": "/",
	"Semicolon": ";",
	"Apostrophe": "'",
	"Braceleft": "[",
	"Braceright": "]",
	"Backslash": "\\",
	"Minus": "-",
	"Equal": "=",
	"QuoteLeft": "`"
}

var textToType = "SPHINX OF BLACK QUARTZ, JUDGE MY VOW"
var typeIndex = 0

var typedText = ""
var bbcodeText = ""

var correctChars = 0
var incorrectChars = 0
var charsTyped = 0

var accuracy = 0.0

var regex = RegEx.new()

func _ready():
	randomize()
	regex.compile("[A-Za-z0-9 _.,!'/$]")
	#setNewText(textToType) #DEBUG

func _input(event):
	if event is InputEventKey and event.is_pressed() and typing:
		print(displayText)
		print(typedText)
		var keycode = DisplayServer.keyboard_get_keycode_from_physical(event.physical_keycode)
		
		
		var isAlphaNumPunc = regex.search(OS.get_keycode_string(keycode))
		if OS.get_keycode_string(keycode) in special_keys:
			isAlphaNumPunc = regex.search(special_keys[OS.get_keycode_string(keycode)])
			
		
		if OS.get_keycode_string(keycode) == "Backspace":
			keyBack.volume_db = -10 + randf_range(-0.025, 0.025)
			keyBack.pitch_scale = 0.75 + randf_range(-0.1, 0.1)
			keyBack.play()
			if typeIndex > 0:
				typeIndex -= 1
			typedText = typedText.substr(0, typeIndex)
			
			if len(bbcodeText)>0 and bbcodeText[len(bbcodeText)-1] == "]":
				incorrectChars -= 1
			else:
				correctChars -= 1
			
			# parse bbcode				
			var bracketCount = 0
			var index = len(bbcodeText) - 1
			while index > 0 and bbcodeText[len(bbcodeText)-1] == "]" and bracketCount < 2:
				index -= 1
				if bbcodeText[index] == "[":
					bracketCount += 1
			
			if layoutText.text[typeIndex] == " ":
				layoutText.text[typeIndex] = textToType[typeIndex]
			displayText.clear()
			displayText.append_text(bbcodeText.substr(0, index))
			bbcodeText = bbcodeText.substr(0, index)
				
		elif isAlphaNumPunc and typeIndex < len(textToType):
			
			charsTyped += 1
			if OS.get_keycode_string(keycode) in special_keys:
				addTypedText(special_keys[OS.get_keycode_string(keycode)])
			elif len(OS.get_keycode_string(keycode)) == 1:
				addTypedText(OS.get_keycode_string(keycode))

func addTypedText(char):
	typedText += char
	if typedText[typeIndex] == textToType[typeIndex]:
		keyClack[randi()%len(keyClack)].volume_db = -10 + randf_range(-0.025, 0.025)
		keyClack[randi()%len(keyClack)].pitch_scale = 0.75 + randf_range(-0.1, 0.1)
		keyClack[randi()%len(keyClack)].play()
		bbcodeText += char
		displayText.append_text(char)
		correctChars += 1
	else:
		keyWrong.play()     
		if char == " ":
			char = "_"
		bbcodeText += "[color=red]"+char+"[/color]"
		displayText.append_text("[color=red]"+char+"[/color]")
		incorrectChars += 1
		layoutText.text[typeIndex] = " "
	typeIndex += 1

func setNewText(text):
	layoutText.text = text
	textToType = text
	correctChars = 0
	incorrectChars = 0
	charsTyped = 0
	
	typedText = ""
	bbcodeText = ""
	typeIndex = 0
	
	typingTimer.wait_time = 60.0 * (60.0 / len(text)/5.0) #wait_time calculated for 60 wpm
	#print(60.0 * (60.0 / len(text)/5.0))
	
	displayText.clear()
	start_typing()
		
func start_typing():
	typing = true
	visible = true
	timerVisual.visible = true
	startTime = Time.get_ticks_msec() 
	typingTimer.start()

func checkAccuracy():
	if correctChars != 0 or incorrectChars != 0:
		accuracy = float(correctChars) / float(len(textToType))
	return accuracy
	
func _process(delta):
	#print(typingTimer.time_left)
	if typing:
		timerVisual.setFill(typingTimer.time_left / typingTimer.wait_time)
	if typing and (len(typedText) == len(textToType) or timeOut):
		timerVisual.visible = false
		typingTimer.stop()
		typing = false
		timeTaken = (Time.get_ticks_msec() - startTime) / 1000.0
		print("TIME TAKEN:",timeTaken)
		wpm = len(textToType)/5.0 * 60.0 / timeTaken
		print("WPM:", wpm)
		#after calculating stats
		emit_signal("finishTyping")

func _on_type_timer_timeout():
	timeOut = true
