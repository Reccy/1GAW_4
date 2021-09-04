extends RichTextLabel

onready var tween = $Tween

var isDone = false

func _on_RootNode2D_on_game_state_change(newState):
	if newState == GameController.STATES.WASD_INTRO:
		enter()

func enter():
	tween.interpolate_property(self, "margin_top", -500, -285, 1.2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

func _on_Player_player_moved():
	if isDone:
		return
	
	tween.interpolate_property(self, "margin_top", -285, -500, 1.2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()
	
	isDone = true
