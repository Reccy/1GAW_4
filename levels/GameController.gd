extends Camera2D

class_name GameController

enum STATES { PRE_START, WASD_INTRO }
var currentState = STATES.PRE_START

signal on_game_state_change

func _ready():
	pass

func _process(delta):
	if currentState == STATES.PRE_START:
		processPreStart(delta)
	if currentState == STATES.WASD_INTRO:
		processWasdIntro(delta)

func processPreStart(delta):
	if (Input.is_action_pressed("game_start")):
		changeState(STATES.WASD_INTRO)

func processWasdIntro(delta):
	pass

func changeState(newState):
	currentState = newState
	emit_signal("on_game_state_change", newState)
