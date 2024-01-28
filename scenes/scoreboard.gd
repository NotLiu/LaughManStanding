extends Control

@onready var round = get_node("CenterContainer/VBoxContainer/round")
@onready var score = get_node("CenterContainer/VBoxContainer/HBoxContainer2/scoreval")
@onready var wpm = get_node("CenterContainer/VBoxContainer/HBoxContainer3/wpmval")
@onready var accuracy = get_node("CenterContainer/VBoxContainer/HBoxContainer4/accuracyval")
@onready var time = get_node("CenterContainer/VBoxContainer/HBoxContainer5/timeval")

func setRoundText(text):
	round.text = "[center]"+ text +"[/center]"

func setScoreText(text):
	score.text = "[fill]"+ text +"[/fill]"

func setWPMSection(text):
	$CenterContainer/VBoxContainer/HBoxContainer3/wpm.text = text

func setWPMText(text):
	wpm.text = "[fill]"+ text +"[/fill]"
	
func setAccuracyText(text):
	accuracy.text = "[fill]"+ text +"[/fill]"
	
func setTimeSection(text):
	$CenterContainer/VBoxContainer/HBoxContainer5/time.text = text
	
func setTimeText(text):
	time.text = "[fill]"+ text +"[/fill]"
