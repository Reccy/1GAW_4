extends AudioStreamPlayer2D

onready var tween = $Tween

func _ready():
	tween.interpolate_property(self, "volume_db", -30, 0, 2, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
	tween.start()
	play()
