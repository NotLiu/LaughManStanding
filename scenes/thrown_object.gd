extends Node2D
signal done_throwing


@onready var objectsGroup = get_node("objectsGroup")
@onready var timer = get_node("Control/Timer")

@onready var roundTimer = get_node("Timer")
@onready var throwTimer = get_node("throwTimer")

var object = preload("res://scenes/object.tscn")

var numObjects = 25
var thrownObjects = 0
var throwing = false
var objectType = "GOOD" # or BAD

func startRound(time):
	visible = true
	roundTimer.start(time)
	throwTimer.wait_time = time / numObjects
	throwTimer.start()
	throwing = true

func _on_timer_timeout():
	#finish throwing
	visible = false
	roundTimer.stop()
	throwTimer.stop()
	emit_signal("done_throwing")
	
	for object in get_tree().get_nodes_in_group("object"):
			object.queue_free()

func _process(delta):
	timer.setFill(roundTimer.time_left/roundTimer.wait_time)
	
	
func _on_throw_timer_timeout():
	if thrownObjects < numObjects:
		print("THROW OBJECT")
		var instance = object.instantiate()
			
		instance.objectType = objectType
		
		var minY = 700.0
		var maxY = 740.0
		
		instance.position = Vector2(randf_range(-10.0, 1290.0), randf_range(minY, maxY))
		
		$objectsGroup.add_child(instance)
		thrownObjects += 1
