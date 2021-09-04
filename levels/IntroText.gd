extends RichTextLabel

var enterpressed = false
onready var tween = $Tween

func _on_RootNode2D_on_game_state_change(newState):
	print(newState)
	if newState == GameController.STATES.WASD_INTRO:
		tween.interpolate_property(self, "margin_top", self.margin_top, -500, 1.2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		tween.start()
		$GongNoise.play()
