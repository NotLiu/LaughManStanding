extends Control

@onready var layoutText = get_node("layoutText")
@onready var displayText = get_node("typedText")

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

var textToType = "THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG"
var typeIndex = 0

var typedText = ""
var bbcodeText = ""

var correctChars = 0
var incorrectChars = 0

var accuracy = 0.0

var regex = RegEx.new()

func _ready():
	regex.compile("[A-Za-z0-9 _.,!'/$]")
	setNewText(textToType)

func _input(event):
	if event is InputEventKey and event.is_pressed():
		var keycode = DisplayServer.keyboard_get_keycode_from_physical(event.physical_keycode)
		
		
		var isAlphaNumPunc = regex.search(OS.get_keycode_string(keycode))
		if OS.get_keycode_string(keycode) in special_keys:
			isAlphaNumPunc = regex.search(special_keys[OS.get_keycode_string(keycode)])
			
		
		if OS.get_keycode_string(keycode) == "Backspace":
			print(bbcodeText)
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
			
			displayText.clear()
			displayText.append_text(bbcodeText.substr(0, index))
			bbcodeText = bbcodeText.substr(0, index)
				
		elif isAlphaNumPunc and typeIndex < len(textToType):
			if OS.get_keycode_string(keycode) in special_keys:
				addTypedText(special_keys[OS.get_keycode_string(keycode)])
			elif len(OS.get_keycode_string(keycode)) == 1:
				addTypedText(OS.get_keycode_string(keycode))
		#print(typedText)

func addTypedText(char):
	typedText += char
	if typedText[typeIndex] == textToType[typeIndex]:
		bbcodeText += char
		displayText.append_text(char)
		correctChars += 1
	else:
		bbcodeText += "[color=red]"+char+"[/color]"
		displayText.append_text("[color=red]"+char+"[/color]")
		incorrectChars += 1
	typeIndex += 1

func setNewText(text):
	layoutText.text = text
	textToType = text
	typeIndex = 0

func checkAccuracy():
	if correctChars != 0 or incorrectChars != 0:
		accuracy = float(correctChars) / float(correctChars + incorrectChars)
	print("%.2f" % (accuracy * 100.0) + "%")
	
func _process(delta):
	checkAccuracy()
