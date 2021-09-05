extends Area2D

export (Array, StreamTexture) var foodSprites
onready var sprite = $Sprite
onready var tween = $Tween
onready var eatTween = $EatTween
onready var player = $"../Player"
onready var rootNode = $"../"

var eaten = false

signal food_eaten

func _ready():
	var idx = randi() % foodSprites.size()
	var tex = foodSprites[idx]
	sprite.texture = tex
	
	connect("food_eaten", player, "_on_food_eaten")
	connect("food_eaten", rootNode, "_on_food_eaten")
	
	tween.interpolate_property(sprite, "scale", Vector2.ZERO, Vector2.ONE, 0.2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

func _on_Food_body_entered(body):
	if body == player && not eaten:
		emit_signal("food_eaten", self)
		tween.interpolate_property(self, "position", position, player.position, 0.05, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		tween.interpolate_property(self, "scale", scale, Vector2.ZERO, 0.1, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		tween.start()
		eaten = true

func _on_EatTween_tween_all_completed():
	queue_free()
