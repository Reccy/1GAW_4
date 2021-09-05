extends KinematicBody2D

onready var sprite = $AnimatedSprite
onready var tween = $Tween
onready var damageSound = $DamageSound
onready var eatSound = $EatSound
onready var dieSound = $DieSound
onready var foodSpawner = $"../FoodSpawner"

signal player_moved
signal player_died
signal player_ate

export (float) var speed = 100.0
var canMove = false

var poopScene = load("res://objects/player/Poop.tscn")
export (int) var stepsPerPoop = 5000
export (int) var stepsPerFood = 6000
export (float) var growthAmount = 0.1
export (float) var shrinkAmount = 0.025
export (float) var deadFullness = 0.3

var stepsSinceLastFood = 0
var stepsSinceLastPoop = 0

func _fullness():
	return scale.x

func _ready():
	sprite.modulate.a = 0

func _physics_process(_delta):
	if not canMove:
		return
	
	var movement = read_movement()
	
	if movement.length_squared() > 0:
		emit_signal("player_moved")
	
	footstep_logic(movement)
	food_spawn_logic(movement)
	move_and_slide(movement)

func read_movement():
	var movement = Vector2.ZERO
	
	if (Input.is_action_pressed("move_left")):
		sprite.flip_h = true
		movement += Vector2.LEFT
	if (Input.is_action_pressed("move_right")):
		sprite.flip_h = false
		movement += Vector2.RIGHT
	if (Input.is_action_pressed("move_up")):
		movement += Vector2.UP
	if (Input.is_action_pressed("move_down")):
		movement += Vector2.DOWN
	
	return movement.normalized() * speed

func footstep_logic(movement):
	stepsSinceLastPoop += movement.length()
	
	if (stepsSinceLastPoop > stepsPerPoop):
		stepsSinceLastPoop -= stepsPerPoop
		poop()

func food_spawn_logic(movement):
	stepsSinceLastFood += movement.length()
	
	if (stepsSinceLastFood > stepsPerFood):
		stepsSinceLastFood -= stepsPerFood
		foodSpawner.spawn_food()

func poop():
	var poop = poopScene.instance()
	get_parent().add_child(poop)
	poop.position = position
	scale.x -= shrinkAmount
	scale.y -= shrinkAmount
	_check_dead()

func _on_RootNode2D_on_game_state_change(newState):
	if (newState == GameController.STATES.WASD_INTRO):
		tween.interpolate_property(sprite, "modulate", Color.transparent, Color.white, 3, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		tween.start()
		canMove = true

func _on_food_eaten(food):
	eatSound.play()
	scale.x += growthAmount
	scale.y += growthAmount
	
	tween.interpolate_property(sprite, "modulate", Color.green, Color.white, 0.2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()
	
	emit_signal("player_ate")
	

func _on_poop_eaten(poop):
	damageSound.play()
	scale.x -= shrinkAmount * 100
	scale.y -= shrinkAmount * 100
	
	tween.interpolate_property(sprite, "modulate", Color.red, Color.white, 0.2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()
	
	_check_dead()

func _check_dead():
	if _fullness() <= deadFullness:
		dieSound.play()
		scale.x = 0
		scale.y = 0
		canMove = false
		emit_signal("player_died")

func _on_DieSound_finished():
	queue_free()
