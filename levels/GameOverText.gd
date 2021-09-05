extends RichTextLabel

onready var tween = $Tween

func _ready():
	percent_visible = 0

func _on_RootNode2D_on_game_state_change(newState):
	if newState == GameController.STATES.GAME_OVER:
		tween.interpolate_property(self, "percent_visible", 0, 1, 1.2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		tween.start()

func _on_Tween_tween_all_completed():
	hide()
