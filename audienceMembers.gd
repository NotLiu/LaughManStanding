extends Node2D

@onready var audienceMember = preload("res://scenes/audience.tscn")

var numAudience = 100

func _ready():
	randomize()
	generateAudience()
	
func generateAudience():
	for person in range(numAudience):
		var instance = audienceMember.instantiate()
		
		var minY = 680.0
		var maxY = 775.0
		instance.position = Vector2(randf_range(-10.0, 1290.0), randf_range(minY, maxY))
		instance.scale = Vector2(0.5 + (instance.position.y-minY)/(maxY-minY), 0.5 + (instance.position.y-minY)/(maxY-minY))
		instance.modulate = Color(((255.0 - 18.0) * pow((instance.position.y/maxY), 2.0) + 18.0)/255.0, ((255.0 - 20.0) * pow((instance.position.y/maxY), 2.0) + 20.0)/255.0, ((255.0 - 28.0) * pow((instance.position.y/maxY), 2.0) + 28.0)/255.0)
		#instance.z_index = instance.scale.y/1.5
		
		add_child(instance)
	audienceStop()
	
func audienceCheer():
	for person in get_tree().get_nodes_in_group("audience"):
		person.cheer()

func audienceStop():
	for person in get_tree().get_nodes_in_group("audience"):
		person.stopCheer()
