extends KinematicBody2D

onready var sprite = $AnimatedSprite
onready var tween = $Tween

signal player_moved

export (float) var speed = 100.0
var canMove = false

func _ready():
	sprite.modulate.a = 0

func _physics_process(_delta):
	if not canMove:
		return
	
	var movement = read_movement()
	
	if movement.length_squared() > 0:
		emit_signal("player_moved")
	
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

func _on_RootNode2D_on_game_state_change(newState):
	if (newState == GameController.STATES.WASD_INTRO):
		tween.interpolate_property(sprite, "modulate", Color.transparent, Color.white, 3, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		tween.start()
		canMove = true
