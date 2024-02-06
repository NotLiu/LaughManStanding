extends Control

@onready var score = get_node("score")

func _ready():
	print($"/root/Global".points)
	score.text = "[fill]FINAL SCORE: "+str($"/root/Global".points)+"[/fill]"
