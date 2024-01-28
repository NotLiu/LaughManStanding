extends RigidBody2D

@onready var anim = get_node("AnimationPlayer")
@onready var object = get_node("Sprite2D")

var good_objects = ["res://assets/flwr.png", "res://assets/meta-flower.png", "res://assets/meta-gift.png"]
var bad_objects = ["res://assets/tomato-stock.png"]

var objectType = "GOOD" # or BAD

var throwing = true
var falling = false

func _ready():
	if objectType == "GOOD":
		object.texture = load(good_objects[randi() % len(good_objects)])
	else:
		object.texture = load(bad_objects[randi() % len(bad_objects)])
		
	apply_force(Vector2(0, -100000.0))
	#set_collision_mask_value(1, false)

func _on_area_2d_body_entered(body):
	if body.name == "floor" and falling:
		if get_node("Ring"):
			$indicator.queue_free()
		falling = false
		if scale.x > 1.0:
			queue_free()
	if body.name == "Player" and falling:
		body.shock(sign(body.position.x - 640) * 500.0)
		
		if objectType == "GOOD":
			body.hit(25)
		else:
			body.hit(-25)
		queue_free()

func _process(delta):
	if global_position.y < 0.0:
		throwing = false
		falling = true
		set_collision_mask_value(1, true)
		set_collision_mask_value(6, true)
	
	if falling:
		if get_node("Ring"):
			$indicator.visible = true
			$indicator.global_position = Vector2(position.x, 650.0)
			$indicator.scale = Vector2(0.2 + (max(0.0, global_position.y) / 640.0) * 0.4, 0.2 + (max(0.0, global_position.y) / 640.0) * 0.4)
		$Sprite2D.scale = Vector2(0.25, 0.25)
		$CollisionShape2D.scale = Vector2(0.25, 0.25)
		$Area2D.scale = Vector2(0.25, 0.25)
		$Area2D.monitoring = true
		modulate = Color(1.0, 1.0, 1.0)
		set_collision_mask_value(1, true)
	
	if throwing:
		$Sprite2D.scale = Vector2(1.0, 1.0)
		$CollisionShape2D.scale = Vector2(1.0, 1.0)
		$Area2D.scale = Vector2(1.0, 1.0)
		modulate = Color(0.0, 0.0, 0.0)
