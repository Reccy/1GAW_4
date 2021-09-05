extends Area2D

var foodScene = load("res://objects/food/Food.tscn")
onready var shape = $FoodSpawnerShape

func spawn_food():
	var food = foodScene.instance()
	get_tree().root.get_child(0).call_deferred("add_child", food)
	food.position = get_rand_position()

func get_rand_position():
	var xMin = position.x - shape.shape.extents.x / 2
	var xMax = position.x + shape.shape.extents.x / 2
	var yMin = position.y - shape.shape.extents.y / 2
	var yMax = position.y + shape.shape.extents.y / 2
	
	var xRange = xMax - xMin
	var yRange = yMax - yMin
		
	var x = randi() % int(xRange * 2)
	var y = randi() % int(yRange * 2)
	
	return Vector2(x - xRange, y - yRange)

func _process(_delta):
	if Input.is_action_just_pressed("move_up"):
		spawn_food()
