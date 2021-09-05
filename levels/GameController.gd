extends Camera2D

class_name GameController

enum STATES { PRE_START, WASD_INTRO, GAME_OVER }
var currentState = STATES.PRE_START

var foodEaten = 0
func getFoodAte():
	return foodEaten

signal on_game_state_change

func _ready():
	pass

func _process(delta):
	if currentState == STATES.PRE_START:
		processPreStart(delta)
	if currentState == STATES.WASD_INTRO:
		processWasdIntro(delta)
	if currentState == STATES.GAME_OVER:
		processGameOver(delta)

func processPreStart(_delta):
	if (Input.is_action_pressed("game_start")):
		changeState(STATES.WASD_INTRO)

func processWasdIntro(_delta):
	if (Input.is_action_pressed("restart")):
		restart()

func processGameOver(_delta):
	if (Input.is_action_just_pressed("restart")):
		restart()

func changeState(newState):
	currentState = newState
	emit_signal("on_game_state_change", newState)

func restart():
	get_tree().reload_current_scene()

func _on_food_eaten(_food):
	foodEaten += 1
	print("Ate " + String(foodEaten))

func _on_Player_player_died():
	changeState(STATES.GAME_OVER)
